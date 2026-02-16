package main

import (
	"context"
	"encoding/json"
	"io"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"

	firebase "firebase.google.com/go"
	"github.com/emersonnjsantos/ParkingZero/shared/auth"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

// ServiceRoute mapeia serviços gRPC para backends
type ServiceRoute struct {
	Name string
	Conn *grpc.ClientConn
}

var routes map[string]*ServiceRoute

func main() {
	ctx := context.Background()

	// 1. Inicializar Firebase/Firestore (para auth interceptor)
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

	// 2. Configurar rotas para backends
	garageAddr := getEnv("GARAGE_SVC_ADDR", "garage-svc:50051")
	vehicleAddr := getEnv("VEHICLE_SVC_ADDR", "vehicle-svc:50052")
	paymentAddr := getEnv("PAYMENT_SVC_ADDR", "payment-svc:50053")
	authAddr := getEnv("AUTH_SVC_ADDR", "auth-svc:50054")
	dashboardAddr := getEnv("DASHBOARD_SVC_ADDR", "dashboard-svc:50055")

	routes = make(map[string]*ServiceRoute)

	// Conectar ao garage-svc
	garageConn, err := grpc.NewClient(garageAddr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("failed to connect to garage-svc: %v", err)
	}
	defer garageConn.Close()
	routes["parking.ParkingService"] = &ServiceRoute{Name: "garage-svc", Conn: garageConn}

	// Conectar ao vehicle-svc
	vehicleConn, err := grpc.NewClient(vehicleAddr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("failed to connect to vehicle-svc: %v", err)
	}
	defer vehicleConn.Close()
	routes["parking.VehicleService"] = &ServiceRoute{Name: "vehicle-svc", Conn: vehicleConn}

	// Conectar ao payment-svc
	paymentConn, err := grpc.NewClient(paymentAddr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("failed to connect to payment-svc: %v", err)
	}
	defer paymentConn.Close()
	routes["parking.PaymentService"] = &ServiceRoute{Name: "payment-svc", Conn: paymentConn}

	// Conectar ao auth-svc
	authConn, err := grpc.NewClient(authAddr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("failed to connect to auth-svc: %v", err)
	}
	defer authConn.Close()
	routes["auth.AuthService"] = &ServiceRoute{Name: "auth-svc", Conn: authConn}

	// Conectar ao dashboard-svc
	dashboardConn, err := grpc.NewClient(dashboardAddr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("failed to connect to dashboard-svc: %v", err)
	}
	defer dashboardConn.Close()
	routes["dashboard.DashboardService"] = &ServiceRoute{Name: "dashboard-svc", Conn: dashboardConn}

	// 3. Criar servidor gRPC com proxy handler
	port := getEnv("PORT", "8080")

	lis, err := net.Listen("tcp", ":"+port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer(
		grpc.UnaryInterceptor(auth.AuthInterceptor(firestoreClient)),
		grpc.UnknownServiceHandler(proxyHandler),
	)

	// 4. Health check HTTP (em porta separada quando necessário)
	healthPort := getEnv("HEALTH_PORT", "8081")

	go func() {
		mux := http.NewServeMux()
		mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Content-Type", "application/json")

			backends := make(map[string]string)
			for svc, route := range routes {
				state := route.Conn.GetState().String()
				backends[svc] = state
			}

			json.NewEncoder(w).Encode(map[string]interface{}{
				"status":   "healthy",
				"service":  "api-gateway",
				"backends": backends,
			})
		})
		mux.HandleFunc("/health/ready", func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(map[string]interface{}{"ready": true})
		})
		log.Printf("🏥 Health check em :%s\n", healthPort)
		http.ListenAndServe(":"+healthPort, mux)
	}()

	// 5. Graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)

	go func() {
		<-sigChan
		log.Println("🛑 Shutdown api-gateway...")
		grpcServer.GracefulStop()
	}()

	log.Printf("🚀 API Gateway rodando em :%s\n", port)
	log.Printf("📊 Rotas: garage(%s), vehicle(%s), payment(%s), auth(%s), dashboard(%s)\n",
		garageAddr, vehicleAddr, paymentAddr, authAddr, dashboardAddr)

	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}

// proxyHandler roteia chamadas gRPC desconhecidas para o backend correto
func proxyHandler(srv interface{}, serverStream grpc.ServerStream) error {
	fullMethod, ok := grpc.MethodFromServerStream(serverStream)
	if !ok {
		return status.Errorf(codes.Internal, "failed to get method from stream")
	}

	// Extrair nome do serviço: "/package.Service/Method" → "package.Service"
	parts := strings.Split(fullMethod, "/")
	if len(parts) < 3 {
		return status.Errorf(codes.Unimplemented, "malformed method: %s", fullMethod)
	}
	serviceName := parts[1]

	route, exists := routes[serviceName]
	if !exists {
		return status.Errorf(codes.Unimplemented, "unknown service: %s", serviceName)
	}

	log.Printf("🔀 Routing %s → %s\n", fullMethod, route.Name)

	// Propagar metadata
	md, _ := metadata.FromIncomingContext(serverStream.Context())
	ctx := metadata.NewOutgoingContext(serverStream.Context(), md)

	// Fazer chamada proxy
	desc := &grpc.StreamDesc{ServerStreams: false, ClientStreams: false}
	clientStream, err := route.Conn.NewStream(ctx, desc, fullMethod)
	if err != nil {
		return status.Errorf(codes.Internal, "failed to create stream to %s: %v", route.Name, err)
	}

	// Receber request do client
	req := &rawMessage{}
	if err := serverStream.RecvMsg(req); err != nil {
		return err
	}

	// Enviar request para backend
	if err := clientStream.SendMsg(req); err != nil {
		return err
	}
	if err := clientStream.CloseSend(); err != nil {
		return err
	}

	// Receber response do backend
	resp := &rawMessage{}
	if err := clientStream.RecvMsg(resp); err != nil {
		return err
	}

	// Propagar header e trailer metadata
	header, _ := clientStream.Header()
	serverStream.SendHeader(header)
	serverStream.SetTrailer(clientStream.Trailer())

	// Enviar response para o client
	return serverStream.SendMsg(resp)
}

// rawMessage implementa proto.Message para proxy transparente (sem desserializar)
type rawMessage struct {
	data []byte
}

func (r *rawMessage) ProtoMessage()            {}
func (r *rawMessage) Reset()                   { r.data = nil }
func (r *rawMessage) String() string           { return string(r.data) }
func (r *rawMessage) Marshal() ([]byte, error) { return r.data, nil }
func (r *rawMessage) Unmarshal(b []byte) error { r.data = b; return nil }
func (r *rawMessage) MarshalTo(b []byte) (int, error) {
	copy(b, r.data)
	return len(r.data), nil
}
func (r *rawMessage) Size() int {
	return len(r.data)
}

// Interface para io.Reader (unused but required by some paths)
var _ io.Reader = (*rawMessage)(nil)

func (r *rawMessage) Read(p []byte) (n int, err error) {
	n = copy(p, r.data)
	if n < len(r.data) {
		return n, nil
	}
	return n, io.EOF
}

func getEnv(key, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return def
}
