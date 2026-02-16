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

	firebase "firebase.google.com/go"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
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

	// 2. Inicializar FCM
	fcmClient, err := app.Messaging(ctx)
	if err != nil {
		log.Printf("⚠️  FCM indisponível: %v (notificações desabilitadas)\n", err)
	}

	// 3. Criar serviços
	voucherService := NewVoucherService()
	paymentService := NewPaymentService(firestoreClient, fcmClient, voucherService)

	// 4. Configurar gRPC
	port := os.Getenv("PORT")
	if port == "" {
		port = "50053"
	}

	lis, err := net.Listen("tcp", ":"+port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer(
		grpc.UnaryInterceptor(auth.AuthInterceptor(firestoreClient)),
	)

	pb.RegisterPaymentServiceServer(grpcServer, paymentService)
	reflection.Register(grpcServer)

	// 5. Health check HTTP
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
				"service": "payment-svc",
			})
		})
		mux.HandleFunc("/health/ready", func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(map[string]interface{}{"ready": true})
		})
		log.Printf("🏥 Health check em :%s\n", healthPort)
		http.ListenAndServe(":"+healthPort, mux)
	}()

	// 6. Graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)

	go func() {
		<-sigChan
		log.Println("🛑 Shutdown payment-svc...")
		grpcServer.GracefulStop()
	}()

	log.Printf("🚀 payment-svc rodando em :%s\n", port)
	log.Println("📊 Serviços: PaymentService + VoucherService")

	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
