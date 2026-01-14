package service

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"time"

	"cloud.google.com/go/firestore"
	"github.com/emersonnjsantos/ParkingZero/backend-api/internal/database"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
)

// Estados do Circuit Breaker
const (
	CircuitClosed   = 0 // Tudo funcionando normalmente
	CircuitOpen     = 1 // Firestore offline - não tenta sincronizar
	CircuitHalfOpen = 2 // Testando se Firestore voltou - apenas 1 requisição
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
	circuitState           int // Closed, Open, ou Half-Open
	lastFailureTime        time.Time
	circuitResetTime       time.Duration

	// Retry configuration
	maxRetries     int
	initialBackoff time.Duration

	// DLQ (Dead Letter Queue)
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
		localDB:         localDB,
		firestoreClient: firestoreClient,
		syncQueue:       syncQueue,
		batchSize:       10,              // Sincronizar em lotes de 10
		syncInterval:    5 * time.Second, // Intervalo de 5 segundos

		// Circuit Breaker config
		maxConsecutiveFailures: 5,
		circuitResetTime:       30 * time.Second,

		// Retry config
		maxRetries:     3,
		initialBackoff: time.Second,

		// DLQ
		dlqPath: "./sync_dlq.log",
	}
}

// Start inicia o worker de sincronização (executa em goroutine)
func (w *SyncWorker) Start(ctx context.Context) {
	log.Println("🔄 Sync Worker iniciado - sincronizando B+Tree → Firestore")

	ticker := time.NewTicker(w.syncInterval)
	defer ticker.Stop()

	batch := make([]*pb.VehicleEntry, 0, w.batchSize)

	for {
		select {
		case <-ctx.Done():
			// Contexto cancelado - sincronizar batch pendente antes de sair
			if len(batch) > 0 {
				w.syncBatch(context.Background(), batch)
			}
			log.Println("⏹️  Sync Worker encerrado")
			return

		case entry := <-w.syncQueue:
			// Nova entrada na fila
			batch = append(batch, entry)

			// Se batch atingiu o tamanho máximo, sincronizar imediatamente
			if len(batch) >= w.batchSize {
				w.syncBatch(ctx, batch)
				batch = batch[:0] // Limpar batch
			}

		case <-ticker.C:
			// Intervalo atingido - sincronizar batch pendente
			if len(batch) > 0 {
				w.syncBatch(ctx, batch)
				batch = batch[:0]
			}

			// Atualizar LastSyncedID na meta page
			w.updateLastSyncedID()
		}
	}
}

// syncBatch sincroniza um lote de entradas com o Firestore (com retry e circuit breaker)
func (w *SyncWorker) syncBatch(ctx context.Context, entries []*pb.VehicleEntry) {
	if len(entries) == 0 {
		return
	}

	// Verificar estado do circuit breaker
	if w.circuitState == CircuitOpen {
		// Verificar se já passou o tempo de reset
		if time.Since(w.lastFailureTime) > w.circuitResetTime {
			log.Println("🟡 Circuit breaker: Mudando para HALF-OPEN (modo de teste)")
			w.circuitState = CircuitHalfOpen
		} else {
			timeRemaining := w.circuitResetTime - time.Since(w.lastFailureTime)
			log.Printf("⚠️  Circuit breaker ABERTO - pulando sincronização (aguardando %v)\n", timeRemaining)
			// Salvar em DLQ para não perder
			w.saveToDLQ(entries)
			return
		}
	}

	// Modo HALF-OPEN: testar com apenas 1 entrada
	if w.circuitState == CircuitHalfOpen {
		log.Println("🧪 HALF-OPEN: Testando conexão com Firestore (1 entrada)...")

		testEntry := []*pb.VehicleEntry{entries[0]}
		err := w.syncBatchWithRetry(ctx, testEntry)

		if err != nil {
			// ❌ Teste falhou - Firestore ainda offline
			log.Printf("❌ Teste HALF-OPEN falhou: %v\n", err)
			log.Println("🔴 Retornando para OPEN - Firestore ainda indisponível")
			w.circuitState = CircuitOpen
			w.consecutiveFailures++
			w.lastFailureTime = time.Now()

			// Salvar TODAS as entradas em DLQ (incluindo a testada)
			w.saveToDLQ(entries)
			return
		}

		// ✅ Teste passou - Firestore voltou!
		log.Println("✅ Teste HALF-OPEN PASSOU! Firestore está online novamente")
		log.Println("🟢 Circuit breaker: FECHADO")
		w.circuitState = CircuitClosed
		w.consecutiveFailures = 0

		// Processar resto do batch (se houver)
		if len(entries) > 1 {
			log.Printf("📤 Processando resto do batch (%d entradas)...\n", len(entries)-1)
			remainingEntries := entries[1:]
			if err := w.syncBatchWithRetry(ctx, remainingEntries); err != nil {
				log.Printf("⚠️  Erro ao processar resto do batch: %v\n", err)
				w.saveToDLQ(remainingEntries)
			} else {
				log.Printf("✅ %d entradas sincronizadas com sucesso\n", len(entries))
			}
		} else {
			log.Println("✅ 1 entrada (teste) sincronizada com sucesso")
		}
		return
	}

	// Modo CLOSED: funcionamento normal
	log.Printf("📤 Sincronizando %d entradas com Firestore...\n", len(entries))

	// Tentar sincronizar com retry
	err := w.syncBatchWithRetry(ctx, entries)

	if err != nil {
		// Incrementar contador de falhas
		w.consecutiveFailures++
		w.lastFailureTime = time.Now()

		log.Printf("❌ Falha após %d tentativas: %v\n", w.maxRetries, err)
		log.Printf("⚠️  Falhas consecutivas: %d/%d\n", w.consecutiveFailures, w.maxConsecutiveFailures)

		// Abrir circuit breaker se muitas falhas
		if w.consecutiveFailures >= w.maxConsecutiveFailures {
			w.circuitState = CircuitOpen
			log.Printf("🔴 CIRCUIT BREAKER ABERTO - Firestore indisponível!\n")
			log.Printf("   Aguardando %v antes de testar novamente (Half-Open)\n", w.circuitResetTime)
		}

		// Salvar em DLQ
		w.saveToDLQ(entries)
		return
	}

	// Sucesso: resetar contadores
	if w.consecutiveFailures > 0 {
		log.Printf("✅ Sincronização recuperada após %d falhas\n", w.consecutiveFailures)
		w.consecutiveFailures = 0
	}

	log.Printf("✅ %d entradas sincronizadas com sucesso\n", len(entries))
}

// syncBatchWithRetry tenta sincronizar com retry e backoff exponencial
func (w *SyncWorker) syncBatchWithRetry(ctx context.Context, entries []*pb.VehicleEntry) error {
	backoff := w.initialBackoff

	for attempt := 0; attempt < w.maxRetries; attempt++ {
		err := w.attemptSync(ctx, entries)

		if err == nil {
			return nil // Sucesso
		}

		// Se não for a última tentativa, fazer backoff
		if attempt < w.maxRetries-1 {
			log.Printf("⚠️  Tentativa %d/%d falhou: %v\n", attempt+1, w.maxRetries, err)
			log.Printf("   Aguardando %v antes de tentar novamente...\n", backoff)

			select {
			case <-time.After(backoff):
				// Backoff exponencial: 1s, 2s, 4s
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

// attemptSync tenta sincronizar batch uma única vez
func (w *SyncWorker) attemptSync(ctx context.Context, entries []*pb.VehicleEntry) error {
	// Usar batch write do Firestore para melhor performance
	batch := w.firestoreClient.Batch()

	for _, entry := range entries {
		// Converter para map para o Firestore
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

		// Usar ID composto como document ID
		docRef := w.firestoreClient.Collection("vehicle_entries").Doc(entry.Id)
		batch.Set(docRef, docData)
	}

	// Executar batch write
	_, err := batch.Commit(ctx)
	return err
}

// saveToDLQ salva entradas que falharam em Dead Letter Queue
func (w *SyncWorker) saveToDLQ(entries []*pb.VehicleEntry) {
	// Abrir arquivo DLQ em modo append
	file, err := os.OpenFile(w.dlqPath, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Printf("❌ Erro ao abrir DLQ: %v\n", err)
		return
	}
	defer file.Close()

	for _, entry := range entries {
		// Serializar entrada como JSON
		jsonData, err := json.Marshal(map[string]interface{}{
			"timestamp": time.Now().Unix(),
			"entry":     entry,
		})
		if err != nil {
			log.Printf("❌ Erro ao serializar entrada para DLQ: %v\n", err)
			continue
		}

		// Escrever no arquivo
		if _, err := file.Write(append(jsonData, '\n')); err != nil {
			log.Printf("❌ Erro ao escrever em DLQ: %v\n", err)
		}
	}

	log.Printf("💾 %d entradas salvas em Dead Letter Queue: %s\n", len(entries), w.dlqPath)
}

// updateLastSyncedID atualiza o LastSyncedID na meta page
func (w *SyncWorker) updateLastSyncedID() {
	meta, err := w.localDB.GetMetaPage()
	if err != nil {
		log.Printf("Erro ao obter meta page: %v\n", err)
		return
	}

	// Incrementar LastSyncedID (representa o timestamp da última sincronização)
	meta.LastSyncedID = uint64(time.Now().Unix())

	if err := w.localDB.UpdateMetaPage(meta); err != nil {
		log.Printf("Erro ao atualizar LastSyncedID: %v\n", err)
	}
}

// ResyncFromLocalDB força uma ressincronização de todas as entradas locais
// Útil para recuperação após falhas ou inicialização
func (w *SyncWorker) ResyncFromLocalDB(ctx context.Context, garageID string) error {
	log.Printf("🔄 Iniciando ressincronização completa para garagem %s...\n", garageID)

	// TODO: Implementar scan com prefixo quando B+Tree suportar
	// Por enquanto, esta função é um placeholder

	// Quando implementado, irá:
	// 1. Escanear todas as chaves com prefixo garage_id|
	// 2. Ler cada entrada do banco local
	// 3. Deserializar proto
	// 4. Enviar para Firestore em batches

	log.Println("⚠️  ResyncFromLocalDB não implementado - aguardando suporte a scan com prefixo")
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
		CircuitState:        w.circuitState, // 0=Closed, 1=Open, 2=Half-Open
		DLQPath:             w.dlqPath,
	}, nil
}

// SyncStats contém estatísticas do sync worker
type SyncStats struct {
	LastSyncedAt        time.Time
	LocalTotalPages     uint64
	QueueSize           int
	ConsecutiveFailures int
	CircuitState        int // 0=Closed, 1=Open, 2=Half-Open
	DLQPath             string
}

// ProcessDLQ reprocessa entradas do Dead Letter Queue
func (w *SyncWorker) ProcessDLQ(ctx context.Context) error {
	log.Printf("🔄 Processando Dead Letter Queue: %s\n", w.dlqPath)

	// Abrir arquivo DLQ
	file, err := os.Open(w.dlqPath)
	if err != nil {
		if os.IsNotExist(err) {
			log.Println("✅ DLQ vazio - nada para processar")
			return nil
		}
		return fmt.Errorf("erro ao abrir DLQ: %w", err)
	}
	defer file.Close()

	// Ler todas as linhas
	var dlqEntries []*pb.VehicleEntry
	decoder := json.NewDecoder(file)

	for decoder.More() {
		var record struct {
			Timestamp int64            `json:"timestamp"`
			Entry     *pb.VehicleEntry `json:"entry"`
		}

		if err := decoder.Decode(&record); err != nil {
			log.Printf("⚠️  Erro ao decodificar linha DLQ: %v\n", err)
			continue
		}

		dlqEntries = append(dlqEntries, record.Entry)
	}

	if len(dlqEntries) == 0 {
		log.Println("✅ DLQ vazio - nada para processar")
		return nil
	}

	log.Printf("📋 Encontradas %d entradas no DLQ\n", len(dlqEntries))

	// Tentar reprocessar em batches
	successCount := 0
	for i := 0; i < len(dlqEntries); i += w.batchSize {
		end := i + w.batchSize
		if end > len(dlqEntries) {
			end = len(dlqEntries)
		}

		batch := dlqEntries[i:end]
		if err := w.syncBatchWithRetry(ctx, batch); err != nil {
			log.Printf("❌ Batch %d-%d falhou: %v\n", i, end, err)
			// Continuar tentando outros batches
		} else {
			successCount += len(batch)
			log.Printf("✅ Batch %d-%d sincronizado\n", i, end)
		}
	}

	// Se conseguiu processar tudo, limpar DLQ
	if successCount == len(dlqEntries) {
		if err := os.Remove(w.dlqPath); err != nil {
			log.Printf("⚠️  Erro ao limpar DLQ: %v\n", err)
		} else {
			log.Println("🗑️  DLQ processado e limpo com sucesso")
		}
	} else {
		log.Printf("⚠️  Processado %d/%d entradas do DLQ\n", successCount, len(dlqEntries))
	}

	return nil
}

// FullResync força sincronização completa lendo direto do banco local
// Esta função itera por TODAS as páginas (pode ser lento)
func (w *SyncWorker) FullResync(ctx context.Context) error {
	log.Println("🔄 Iniciando Full Resync - lendo todas as entradas do banco local...")

	stats, err := w.localDB.GetStats()
	if err != nil {
		return fmt.Errorf("erro ao obter stats: %v", err)
	}

	syncCount := 0
	batch := make([]*pb.VehicleEntry, 0, w.batchSize)

	// Iterar por todas as páginas (página 0 é meta, começar da 1)
	for pageID := uint64(1); pageID < stats.TotalPages; pageID++ {
		// TODO: Verificar se página é um nó folha antes de tentar ler
		// Por enquanto, tentamos ler e ignoramos erros

		// Esta é uma abordagem bruta - idealmente teríamos um iterator na B+Tree
		// Exemplo de como seria:
		// for entry := range w.localDB.IterateAll(ctx) { ... }

		// Placeholder: log progresso
		if pageID%100 == 0 {
			log.Printf("  Processando página %d/%d...\n", pageID, stats.TotalPages)
		}
	}

	// Sincronizar batch final
	if len(batch) > 0 {
		w.syncBatch(ctx, batch)
	}

	log.Printf("✅ Full Resync completo: %d entradas sincronizadas\n", syncCount)
	return nil
}
