package main

import (
	"context"
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

	"github.com/emersonnjsantos/ParkingZero/backend-api/internal/auth"
	"github.com/emersonnjsantos/ParkingZero/backend-api/internal/database"
	"github.com/emersonnjsantos/ParkingZero/backend-api/internal/service"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
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

	// 2. Abrir Banco Local B+Tree
	dbPath := os.Getenv("LOCAL_DB_PATH")
	if dbPath == "" {
		dbPath = "/data/parkingzero.db" // Caminho padrão para produção
		// Para desenvolvimento local no Windows:
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

	// Log de estatísticas do banco
	stats, _ := localDB.GetStats()
	log.Printf("✅ Banco local aberto - %d páginas, root=%d\n", stats.TotalPages, stats.RootPageID)

	// 3. Criar serviços (ordem importa: VehicleService primeiro)
	vehicleService := service.NewVehicleService(localDB, firestoreClient)
	parkingService := service.NewParkingService(firestoreClient, vehicleService)

	// PaymentService (Sistema de Patrocínio de Lojas)
	paymentService, err := service.NewPaymentService(firestoreClient, app)
	if err != nil {
		log.Printf("⚠️  PaymentService inicializado sem FCM: %v", err)
	}

	// 4. Iniciar Sync Worker em goroutine
	syncWorker := service.NewSyncWorker(localDB, firestoreClient, vehicleService.GetSyncQueue())
	syncCtx, syncCancel := context.WithCancel(ctx)
	defer syncCancel()

	go syncWorker.Start(syncCtx)

	// 5. Processar DLQ (entradas que falharam anteriormente)
	go func() {
		time.Sleep(10 * time.Second) // Aguardar estabilização
		log.Println("🔄 Processando Dead Letter Queue...")
		if err := syncWorker.ProcessDLQ(ctx); err != nil {
			log.Printf("⚠️  Erro ao processar DLQ: %v\n", err)
		}
	}()

	// 6. Configurar servidor HTTP para health checks
	healthHandler := NewHealthCheckHandler(syncWorker)
	httpMux := http.NewServeMux()
	healthHandler.RegisterRoutes(httpMux)

	// Iniciar servidor HTTP em porta separada (para health checks)
	healthPort := os.Getenv("HEALTH_PORT")
	if healthPort == "" {
		healthPort = "8081"
	}

	go func() {
		log.Printf("🏥 Health check server rodando em :%s\n", healthPort)
		if err := http.ListenAndServe(":"+healthPort, httpMux); err != nil {
			log.Printf("Erro no servidor HTTP: %v\n", err)
		}
	}()

	// 7. Configurar servidor gRPC
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	lis, err := net.Listen("tcp", ":"+port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	// 8. Configurar servidor gRPC com AuthInterceptor (RBAC)
	grpcServer := grpc.NewServer(
		grpc.UnaryInterceptor(auth.AuthInterceptor(firestoreClient)),
	)

	// 6. Registrar serviços gRPC
	pb.RegisterParkingServiceServer(grpcServer, parkingService)
	pb.RegisterPaymentServiceServer(grpcServer, paymentService)

	// NOTA: VehicleService precisa ser registrado quando o protoc gerar o código
	// pb.RegisterVehicleServiceServer(grpcServer, vehicleService)

	// Habilitar reflection para ferramentas como BloomRPC/Postman
	reflection.Register(grpcServer)

	// 7. Graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)

	go func() {
		<-sigChan
		log.Println("\n🛑 Shutdown signal recebido - encerrando gracefully...")

		// Parar sync worker
		syncCancel()

		// Parar servidor gRPC
		grpcServer.GracefulStop()

		// Fechar banco local (fsync final)
		localDB.Close()

		log.Println("✅ Shutdown completo")
		os.Exit(0)
	}()

	// 8. Iniciar servidor
	log.Printf("🚀 Servidor gRPC rodando em %v\n", lis.Addr())
	log.Println("📊 Serviços disponíveis:")
	log.Println("   - ParkingService (Firestore)")
	log.Println("   - PaymentService (Sponsorship/FCM)")
	log.Println("   - VehicleService (B+Tree Local) [aguardando protoc]")
	log.Println("   - Sync Worker (Background)")

	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
