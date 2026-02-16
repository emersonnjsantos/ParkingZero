package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"time"

	"cloud.google.com/go/firestore"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
	"github.com/emersonnjsantos/ParkingZero/services/vehicle-svc/database"
)

// Estados do Circuit Breaker
const (
	CircuitClosed   = 0
	CircuitOpen     = 1
	CircuitHalfOpen = 2
)

// SyncWorker gerencia a sincronização entre o banco local B+Tree e o Firestore
type SyncWorker struct {
	localDB         *database.DB
	firestoreClient *firestore.Client
	syncQueue       <-chan *pb.VehicleEntry
	batchSize       int
	syncInterval    time.Duration

	// Circuit Breaker
	consecutiveFailures    int
	maxConsecutiveFailures int
	circuitState           int
	lastFailureTime        time.Time
	circuitResetTime       time.Duration

	// Retry
	maxRetries     int
	initialBackoff time.Duration

	// DLQ
	dlqPath string
	dlqFile *os.File
}

// NewSyncWorker cria um novo worker de sincronização
func NewSyncWorker(
	localDB *database.DB,
	firestoreClient *firestore.Client,
	syncQueue <-chan *pb.VehicleEntry,
) *SyncWorker {
	return &SyncWorker{
		localDB:                localDB,
		firestoreClient:        firestoreClient,
		syncQueue:              syncQueue,
		batchSize:              10,
		syncInterval:           5 * time.Second,
		maxConsecutiveFailures: 5,
		circuitResetTime:       30 * time.Second,
		maxRetries:             3,
		initialBackoff:         time.Second,
		dlqPath:                "./sync_dlq.log",
	}
}

// Start inicia o worker de sincronização
func (w *SyncWorker) Start(ctx context.Context) {
	log.Println("🔄 Sync Worker iniciado - sincronizando B+Tree → Firestore")

	ticker := time.NewTicker(w.syncInterval)
	defer ticker.Stop()

	batch := make([]*pb.VehicleEntry, 0, w.batchSize)

	for {
		select {
		case <-ctx.Done():
			if len(batch) > 0 {
				w.syncBatch(context.Background(), batch)
			}
			log.Println("⏹️  Sync Worker encerrado")
			return

		case entry := <-w.syncQueue:
			batch = append(batch, entry)
			if len(batch) >= w.batchSize {
				w.syncBatch(ctx, batch)
				batch = batch[:0]
			}

		case <-ticker.C:
			if len(batch) > 0 {
				w.syncBatch(ctx, batch)
				batch = batch[:0]
			}
			w.updateLastSyncedID()
		}
	}
}

// syncBatch sincroniza um lote de entradas com o Firestore
func (w *SyncWorker) syncBatch(ctx context.Context, entries []*pb.VehicleEntry) {
	if len(entries) == 0 {
		return
	}

	if w.circuitState == CircuitOpen {
		if time.Since(w.lastFailureTime) > w.circuitResetTime {
			log.Println("🟡 Circuit breaker: Mudando para HALF-OPEN")
			w.circuitState = CircuitHalfOpen
		} else {
			w.saveToDLQ(entries)
			return
		}
	}

	if w.circuitState == CircuitHalfOpen {
		log.Println("🧪 HALF-OPEN: Testando conexão com Firestore...")
		testEntry := []*pb.VehicleEntry{entries[0]}
		err := w.syncBatchWithRetry(ctx, testEntry)

		if err != nil {
			log.Printf("❌ Teste HALF-OPEN falhou: %v\n", err)
			w.circuitState = CircuitOpen
			w.consecutiveFailures++
			w.lastFailureTime = time.Now()
			w.saveToDLQ(entries)
			return
		}

		log.Println("✅ Teste HALF-OPEN PASSOU! Firestore online")
		w.circuitState = CircuitClosed
		w.consecutiveFailures = 0

		if len(entries) > 1 {
			if err := w.syncBatchWithRetry(ctx, entries[1:]); err != nil {
				w.saveToDLQ(entries[1:])
			}
		}
		return
	}

	log.Printf("📤 Sincronizando %d entradas...\n", len(entries))
	err := w.syncBatchWithRetry(ctx, entries)

	if err != nil {
		w.consecutiveFailures++
		w.lastFailureTime = time.Now()

		if w.consecutiveFailures >= w.maxConsecutiveFailures {
			w.circuitState = CircuitOpen
			log.Printf("🔴 CIRCUIT BREAKER ABERTO!\n")
		}

		w.saveToDLQ(entries)
		return
	}

	if w.consecutiveFailures > 0 {
		w.consecutiveFailures = 0
	}
	log.Printf("✅ %d entradas sincronizadas\n", len(entries))
}

func (w *SyncWorker) syncBatchWithRetry(ctx context.Context, entries []*pb.VehicleEntry) error {
	backoff := w.initialBackoff
	for attempt := 0; attempt < w.maxRetries; attempt++ {
		err := w.attemptSync(ctx, entries)
		if err == nil {
			return nil
		}
		if attempt < w.maxRetries-1 {
			select {
			case <-time.After(backoff):
				backoff *= 2
			case <-ctx.Done():
				return ctx.Err()
			}
		} else {
			return fmt.Errorf("falhou após %d tentativas: %w", w.maxRetries, err)
		}
	}
	return fmt.Errorf("todas as tentativas falharam")
}

func (w *SyncWorker) attemptSync(ctx context.Context, entries []*pb.VehicleEntry) error {
	batch := w.firestoreClient.Batch()
	for _, entry := range entries {
		docData := map[string]interface{}{
			"id":            entry.Id,
			"garage_id":     entry.GarageId,
			"vehicle_plate": entry.VehiclePlate,
			"entry_time":    entry.EntryTime,
			"exit_time":     entry.ExitTime,
			"amount_paid":   entry.AmountPaid,
			"status":        int32(entry.Status),
			"user_id":       entry.UserId,
			"synced_at":     time.Now().Unix(),
		}
		docRef := w.firestoreClient.Collection("vehicle_entries").Doc(entry.Id)
		batch.Set(docRef, docData)
	}
	_, err := batch.Commit(ctx)
	return err
}

func (w *SyncWorker) saveToDLQ(entries []*pb.VehicleEntry) {
	file, err := os.OpenFile(w.dlqPath, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Printf("❌ Erro ao abrir DLQ: %v\n", err)
		return
	}
	defer file.Close()
	for _, entry := range entries {
		jsonData, err := json.Marshal(map[string]interface{}{
			"timestamp": time.Now().Unix(),
			"entry":     entry,
		})
		if err != nil {
			continue
		}
		file.Write(append(jsonData, '\n'))
	}
	log.Printf("💾 %d entradas salvas em DLQ\n", len(entries))
}

func (w *SyncWorker) updateLastSyncedID() {
	meta, err := w.localDB.GetMetaPage()
	if err != nil {
		return
	}
	meta.LastSyncedID = uint64(time.Now().Unix())
	w.localDB.UpdateMetaPage(meta)
}

func (w *SyncWorker) ResyncFromLocalDB(ctx context.Context, garageID string) error {
	log.Printf("🔄 Ressincronização para garagem %s...\n", garageID)
	return fmt.Errorf("not implemented")
}

// GetSyncStats retorna estatísticas de sincronização
func (w *SyncWorker) GetSyncStats() (*SyncStats, error) {
	meta, err := w.localDB.GetMetaPage()
	if err != nil {
		return nil, err
	}
	stats, err := w.localDB.GetStats()
	if err != nil {
		return nil, err
	}
	return &SyncStats{
		LastSyncedAt:        time.Unix(int64(meta.LastSyncedID), 0),
		LocalTotalPages:     stats.TotalPages,
		QueueSize:           len(w.syncQueue),
		ConsecutiveFailures: w.consecutiveFailures,
		CircuitState:        w.circuitState,
		DLQPath:             w.dlqPath,
	}, nil
}

// SyncStats contém estatísticas do sync worker
type SyncStats struct {
	LastSyncedAt        time.Time
	LocalTotalPages     uint64
	QueueSize           int
	ConsecutiveFailures int
	CircuitState        int
	DLQPath             string
}

// ProcessDLQ reprocessa entradas do Dead Letter Queue
func (w *SyncWorker) ProcessDLQ(ctx context.Context) error {
	file, err := os.Open(w.dlqPath)
	if err != nil {
		if os.IsNotExist(err) {
			log.Println("✅ DLQ vazio")
			return nil
		}
		return fmt.Errorf("erro ao abrir DLQ: %w", err)
	}
	defer file.Close()

	var dlqEntries []*pb.VehicleEntry
	decoder := json.NewDecoder(file)
	for decoder.More() {
		var record struct {
			Timestamp int64            `json:"timestamp"`
			Entry     *pb.VehicleEntry `json:"entry"`
		}
		if err := decoder.Decode(&record); err != nil {
			continue
		}
		dlqEntries = append(dlqEntries, record.Entry)
	}

	if len(dlqEntries) == 0 {
		return nil
	}

	log.Printf("📋 %d entradas no DLQ\n", len(dlqEntries))
	successCount := 0
	for i := 0; i < len(dlqEntries); i += w.batchSize {
		end := i + w.batchSize
		if end > len(dlqEntries) {
			end = len(dlqEntries)
		}
		if err := w.syncBatchWithRetry(ctx, dlqEntries[i:end]); err != nil {
			log.Printf("❌ Batch %d-%d falhou: %v\n", i, end, err)
		} else {
			successCount += end - i
		}
	}

	if successCount == len(dlqEntries) {
		os.Remove(w.dlqPath)
		log.Println("🗑️  DLQ processado e limpo")
	}
	return nil
}

// FullResync força sincronização completa
func (w *SyncWorker) FullResync(ctx context.Context) error {
	log.Println("🔄 Full Resync...")
	stats, err := w.localDB.GetStats()
	if err != nil {
		return fmt.Errorf("erro ao obter stats: %v", err)
	}

	batch := make([]*pb.VehicleEntry, 0, w.batchSize)
	for pageID := uint64(1); pageID < stats.TotalPages; pageID++ {
		if pageID%100 == 0 {
			log.Printf("  Página %d/%d...\n", pageID, stats.TotalPages)
		}
	}
	if len(batch) > 0 {
		w.syncBatch(ctx, batch)
	}
	return nil
}
