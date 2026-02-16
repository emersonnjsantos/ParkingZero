package main

import (
	"context"
	"encoding/json"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	firebase "firebase.google.com/go"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
	"github.com/emersonnjsantos/ParkingZero/services/vehicle-svc/database"
	"github.com/emersonnjsantos/ParkingZero/shared/auth"
)

func main() {
	ctx := context.Background()

	// 1. Inicializar Firebase/Firestore
	conf := &firebase.Config{ProjectID: os.Getenv("GOOGLE_CLOUD_PROJECT")}
	app, err := firebase.NewApp(ctx, conf)
	if err != nil {
		log.Fatalf("error initializing app: %v\n", err)
	}

	firestoreClient, err := app.Firestore(ctx)
	if err != nil {
		log.Fatalf("error getting Firestore client: %v\n", err)
	}
	defer firestoreClient.Close()

	// 2. Abrir banco local B+Tree
	dbPath := os.Getenv("LOCAL_DB_PATH")
	if dbPath == "" {
		dbPath = "/data/parkingzero.db"
		if _, err := os.Stat("/data"); os.IsNotExist(err) {
			dbPath = "./parkingzero.db"
		}
	}

	log.Printf("📂 Abrindo banco local: %s\n", dbPath)
	localDB, err := database.Open(dbPath)
	if err != nil {
		log.Fatalf("❌ Falha ao abrir banco local: %v\n", err)
	}
	defer localDB.Close()

	stats, _ := localDB.GetStats()
	log.Printf("✅ Banco local aberto - %d páginas, root=%d\n", stats.TotalPages, stats.RootPageID)

	// 3. Criar serviço
	vehicleService := NewVehicleService(localDB, firestoreClient)

	// 4. Iniciar Sync Worker
	syncWorker := NewSyncWorker(localDB, firestoreClient, vehicleService.GetSyncQueue())
	syncCtx, syncCancel := context.WithCancel(ctx)
	defer syncCancel()

	go syncWorker.Start(syncCtx)

	// 5. Processar DLQ
	go func() {
		time.Sleep(10 * time.Second)
		log.Println("🔄 Processando Dead Letter Queue...")
		if err := syncWorker.ProcessDLQ(ctx); err != nil {
			log.Printf("⚠️  Erro ao processar DLQ: %v\n", err)
		}
	}()

	// 6. Configurar gRPC
	port := os.Getenv("PORT")
	if port == "" {
		port = "50052"
	}

	lis, err := net.Listen("tcp", ":"+port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer(
		grpc.UnaryInterceptor(auth.AuthInterceptor(firestoreClient)),
	)

	pb.RegisterParkingServiceServer(grpcServer, vehicleService)
	reflection.Register(grpcServer)

	// 7. Health check HTTP
	healthPort := os.Getenv("HEALTH_PORT")
	if healthPort == "" {
		healthPort = "8081"
	}

	go func() {
		mux := http.NewServeMux()
		mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(map[string]string{
				"status":  "healthy",
				"service": "vehicle-svc",
			})
		})
		mux.HandleFunc("/health/sync", func(w http.ResponseWriter, r *http.Request) {
			syncStats, err := syncWorker.GetSyncStats()
			w.Header().Set("Content-Type", "application/json")
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]interface{}{"error": err.Error()})
				return
			}
			circuitStates := []string{"closed", "open", "half-open"}
			json.NewEncoder(w).Encode(map[string]interface{}{
				"status":               "ok",
				"last_synced_at":       syncStats.LastSyncedAt,
				"local_total_pages":    syncStats.LocalTotalPages,
				"queue_size":           syncStats.QueueSize,
				"consecutive_failures": syncStats.ConsecutiveFailures,
				"circuit_state":        circuitStates[syncStats.CircuitState],
			})
		})
		mux.HandleFunc("/health/ready", func(w http.ResponseWriter, r *http.Request) {
			syncStats, _ := syncWorker.GetSyncStats()
			ready := syncStats != nil && syncStats.CircuitState == 0
			w.Header().Set("Content-Type", "application/json")
			if ready {
				w.WriteHeader(http.StatusOK)
			} else {
				w.WriteHeader(http.StatusServiceUnavailable)
			}
			json.NewEncoder(w).Encode(map[string]interface{}{"ready": ready})
		})
		log.Printf("🏥 Health check em :%s\n", healthPort)
		http.ListenAndServe(":"+healthPort, mux)
	}()

	// 8. Graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)

	go func() {
		<-sigChan
		log.Println("🛑 Shutdown vehicle-svc...")
		syncCancel()
		grpcServer.GracefulStop()
		localDB.Close()
		log.Println("✅ Shutdown completo")
	}()

	log.Printf("🚀 vehicle-svc rodando em :%s\n", port)
	log.Println("📊 Serviços: VehicleService (B+Tree) + SyncWorker")

	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
