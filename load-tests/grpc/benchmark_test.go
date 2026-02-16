// Package grpc_benchmark contém benchmarks e testes de carga para os serviços gRPC do ParkingZero
package grpc_benchmark

import (
	"context"
	"fmt"
	"math/rand"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"

	proto "github.com/emersonnjsantos/ParkingZero/pkg/pb"
)

// Configurações do benchmark
const (
	defaultServerAddr  = "localhost:8080"
	defaultConcurrency = 100
	defaultDuration    = 2 * time.Minute
	defaultRampUpTime  = 30 * time.Second
	defaultWarmupTime  = 10 * time.Second
)

// TestConfig contém configurações para os testes de carga
type TestConfig struct {
	ServerAddr     string
	MaxConcurrency int
	TestDuration   time.Duration
	RampUpTime     time.Duration
	WarmupTime     time.Duration
}

// LoadTestResult contém os resultados do teste de carga
type LoadTestResult struct {
	TotalRequests  int64
	SuccessCount   int64
	ErrorCount     int64
	TotalDuration  time.Duration
	RequestsPerSec float64
	AvgLatency     time.Duration
	P50Latency     time.Duration
	P95Latency     time.Duration
	P99Latency     time.Duration
	MaxLatency     time.Duration
	MinLatency     time.Duration
	ErrorsByType   map[string]int64
}

// latencySample armazena amostras de latência
type latencySample struct {
	latencies []time.Duration
	mu        sync.Mutex
}

func (ls *latencySample) add(d time.Duration) {
	ls.mu.Lock()
	defer ls.mu.Unlock()
	ls.latencies = append(ls.latencies, d)
}

func (ls *latencySample) getPercentile(p float64) time.Duration {
	ls.mu.Lock()
	defer ls.mu.Unlock()
	if len(ls.latencies) == 0 {
		return 0
	}
	// Ordenar latências (simplificado - usar sort em produção)
	sorted := make([]time.Duration, len(ls.latencies))
	copy(sorted, ls.latencies)
	for i := 0; i < len(sorted); i++ {
		for j := i + 1; j < len(sorted); j++ {
			if sorted[i] > sorted[j] {
				sorted[i], sorted[j] = sorted[j], sorted[i]
			}
		}
	}
	idx := int(float64(len(sorted)) * p)
	if idx >= len(sorted) {
		idx = len(sorted) - 1
	}
	return sorted[idx]
}

// ==================== Benchmark: SearchGarages ====================

// BenchmarkSearchGarages testa a performance da busca de garagens
func BenchmarkSearchGarages(b *testing.B) {
	conn, client := setupClient(b)
	defer conn.Close()

	ctx := context.Background()
	req := &proto.SearchRequest{
		Latitude:     -23.5505,
		Longitude:    -46.6333,
		RadiusMeters: 5000,
	}

	// Warmup
	for i := 0; i < 10; i++ {
		_, _ = client.SearchGarages(ctx, req)
	}

	b.ResetTimer()
	b.ReportAllocs()

	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			_, err := client.SearchGarages(ctx, req)
			if err != nil {
				b.Logf("SearchGarages error: %v", err)
			}
		}
	})
}

// BenchmarkSearchGarages_Concurrent testa com diferentes níveis de concorrência
func BenchmarkSearchGarages_Concurrent(b *testing.B) {
	concurrencyLevels := []int{10, 50, 100, 500, 1000}

	for _, concurrency := range concurrencyLevels {
		b.Run(fmt.Sprintf("Concurrency_%d", concurrency), func(b *testing.B) {
			conn, client := setupClient(b)
			defer conn.Close()

			ctx := context.Background()
			req := &proto.SearchRequest{
				Latitude:     -23.5505,
				Longitude:    -46.6333,
				RadiusMeters: 5000,
			}

			b.SetParallelism(concurrency)
			b.ResetTimer()

			b.RunParallel(func(pb *testing.PB) {
				for pb.Next() {
					_, _ = client.SearchGarages(ctx, req)
				}
			})
		})
	}
}

// ==================== Benchmark: CreateReservation ====================

// BenchmarkCreateReservation testa a criação de reservas
func BenchmarkCreateReservation(b *testing.B) {
	conn, client := setupClient(b)
	defer conn.Close()

	ctx := context.Background()
	counter := int64(0)

	b.ResetTimer()
	b.ReportAllocs()

	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			n := atomic.AddInt64(&counter, 1)
			req := &proto.CreateReservationRequest{
				UserId:       fmt.Sprintf("bench_user_%d", n),
				GarageId:     "garage_001",
				VehiclePlate: fmt.Sprintf("BNC%04d", n%10000),
				StartTime:    time.Now().Unix(),
				EndTime:      time.Now().Add(2 * time.Hour).Unix(),
			}
			_, err := client.CreateReservation(ctx, req)
			if err != nil {
				b.Logf("CreateReservation error: %v", err)
			}
		}
	})
}

// ==================== Benchmark: RecordVehicleEntry (LATÊNCIA CRÍTICA) ====================

// BenchmarkRecordVehicleEntry testa o registro de entrada de veículos
// Este é o endpoint mais crítico - deve ser < 50ms no P95
func BenchmarkRecordVehicleEntry(b *testing.B) {
	conn, client := setupClient(b)
	defer conn.Close()

	ctx := context.Background()
	counter := int64(0)
	samples := &latencySample{}

	b.ResetTimer()
	b.ReportAllocs()

	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			n := atomic.AddInt64(&counter, 1)
			req := &proto.VehicleEntryRequest{
				GarageId:     "garage_001",
				VehiclePlate: fmt.Sprintf("ENT%04d", n%10000),
				EntryTime:    time.Now().Unix(),
				UserId:       fmt.Sprintf("user_%d", n),
			}

			start := time.Now()
			_, err := client.RecordVehicleEntry(ctx, req)
			latency := time.Since(start)

			samples.add(latency)

			if err != nil {
				b.Logf("RecordVehicleEntry error: %v", err)
			}
		}
	})

	// Log de latências
	b.Logf("P50 Latency: %v", samples.getPercentile(0.50))
	b.Logf("P95 Latency: %v", samples.getPercentile(0.95))
	b.Logf("P99 Latency: %v", samples.getPercentile(0.99))
}

// ==================== Benchmark: RecordVehicleExit ====================

// BenchmarkRecordVehicleExit testa o registro de saída de veículos
func BenchmarkRecordVehicleExit(b *testing.B) {
	conn, client := setupClient(b)
	defer conn.Close()

	ctx := context.Background()
	counter := int64(0)

	b.ResetTimer()
	b.ReportAllocs()

	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			n := atomic.AddInt64(&counter, 1)
			req := &proto.VehicleExitRequest{
				GarageId:     "garage_001",
				VehiclePlate: fmt.Sprintf("EXT%04d", n%10000),
				ExitTime:     time.Now().Unix(),
			}
			_, err := client.RecordVehicleExit(ctx, req)
			if err != nil {
				// Esperado: veículo pode não existir
			}
		}
	})
}

// ==================== Teste de Carga Completo ====================

// TestFullFlowLoadTest executa o teste de carga completo
func TestFullFlowLoadTest(t *testing.T) {
	if testing.Short() {
		t.Skip("Skipping load test in short mode")
	}

	config := TestConfig{
		ServerAddr:     defaultServerAddr,
		MaxConcurrency: 1000,
		TestDuration:   2 * time.Minute,
		RampUpTime:     30 * time.Second,
		WarmupTime:     10 * time.Second,
	}

	result := runLoadTest(t, config)
	printLoadTestResult(t, result)

	// Validações
	if result.SuccessRate() < 0.99 {
		t.Errorf("Success rate %.2f%% is below 99%% threshold", result.SuccessRate()*100)
	}

	if result.P95Latency > 500*time.Millisecond {
		t.Errorf("P95 latency %v exceeds 500ms threshold", result.P95Latency)
	}
}

// LoadTestResult.SuccessRate calcula a taxa de sucesso
func (r *LoadTestResult) SuccessRate() float64 {
	if r.TotalRequests == 0 {
		return 0
	}
	return float64(r.SuccessCount) / float64(r.TotalRequests)
}

// runLoadTest executa o teste de carga
func runLoadTest(t *testing.T, config TestConfig) *LoadTestResult {
	t.Logf("🚀 Iniciando teste de carga")
	t.Logf("   Concorrência: %d VUs", config.MaxConcurrency)
	t.Logf("   Duração: %v", config.TestDuration)
	t.Logf("   Ramp-up: %v", config.RampUpTime)

	conn, err := grpc.Dial(
		config.ServerAddr,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithBlock(),
	)
	if err != nil {
		t.Fatalf("Failed to connect: %v", err)
	}
	defer conn.Close()

	client := proto.NewParkingServiceClient(conn)

	result := &LoadTestResult{
		ErrorsByType: make(map[string]int64),
	}
	samples := &latencySample{}

	var wg sync.WaitGroup
	ctx, cancel := context.WithTimeout(context.Background(), config.TestDuration)
	defer cancel()

	startTime := time.Now()
	currentVUs := int64(0)
	targetVUs := int64(config.MaxConcurrency)

	// Controle de ramp-up
	rampUpTicker := time.NewTicker(config.RampUpTime / time.Duration(config.MaxConcurrency))
	defer rampUpTicker.Stop()

	// Worker pool
	for i := 0; i < config.MaxConcurrency; i++ {
		wg.Add(1)
		go func(vuID int) {
			defer wg.Done()

			// Aguardar ramp-up
			for atomic.LoadInt64(&currentVUs) < int64(vuID) {
				select {
				case <-ctx.Done():
					return
				case <-time.After(10 * time.Millisecond):
				}
			}

			// Executar fluxo
			for {
				select {
				case <-ctx.Done():
					return
				default:
					latency := executeFullFlow(ctx, client, vuID, result)
					samples.add(latency)
				}
			}
		}(i)

		// Ramp-up gradual
		select {
		case <-rampUpTicker.C:
			atomic.AddInt64(&currentVUs, 1)
		case <-ctx.Done():
			break
		}
	}

	// Suppress unused variable warning
	_ = targetVUs

	// Aguardar todos os VUs
	wg.Wait()

	result.TotalDuration = time.Since(startTime)
	result.RequestsPerSec = float64(result.TotalRequests) / result.TotalDuration.Seconds()
	result.P50Latency = samples.getPercentile(0.50)
	result.P95Latency = samples.getPercentile(0.95)
	result.P99Latency = samples.getPercentile(0.99)

	if len(samples.latencies) > 0 {
		var total time.Duration
		result.MinLatency = samples.latencies[0]
		result.MaxLatency = samples.latencies[0]
		for _, l := range samples.latencies {
			total += l
			if l < result.MinLatency {
				result.MinLatency = l
			}
			if l > result.MaxLatency {
				result.MaxLatency = l
			}
		}
		result.AvgLatency = total / time.Duration(len(samples.latencies))
	}

	return result
}

// executeFullFlow executa o fluxo completo
func executeFullFlow(ctx context.Context, client proto.ParkingServiceClient, vuID int, result *LoadTestResult) time.Duration {
	start := time.Now()
	iterID := rand.Int63()

	// 1. Buscar garagens
	_, err := client.SearchGarages(ctx, &proto.SearchRequest{
		Latitude:     -23.5505 + (rand.Float64() * 0.01),
		Longitude:    -46.6333 + (rand.Float64() * 0.01),
		RadiusMeters: 5000,
	})
	if err != nil {
		atomic.AddInt64(&result.ErrorCount, 1)
		result.ErrorsByType["SearchGarages"]++
	} else {
		atomic.AddInt64(&result.SuccessCount, 1)
	}
	atomic.AddInt64(&result.TotalRequests, 1)

	// 2. Criar reserva
	_, err = client.CreateReservation(ctx, &proto.CreateReservationRequest{
		UserId:       fmt.Sprintf("load_user_%d_%d", vuID, iterID),
		GarageId:     "garage_001",
		VehiclePlate: fmt.Sprintf("LT%02d%04d", vuID%100, iterID%10000),
		StartTime:    time.Now().Unix(),
		EndTime:      time.Now().Add(2 * time.Hour).Unix(),
	})
	if err != nil {
		atomic.AddInt64(&result.ErrorCount, 1)
	} else {
		atomic.AddInt64(&result.SuccessCount, 1)
	}
	atomic.AddInt64(&result.TotalRequests, 1)

	// 3. Entrada de veículo
	_, err = client.RecordVehicleEntry(ctx, &proto.VehicleEntryRequest{
		GarageId:     "garage_001",
		VehiclePlate: fmt.Sprintf("LT%02d%04d", vuID%100, iterID%10000),
		EntryTime:    time.Now().Unix(),
		UserId:       fmt.Sprintf("load_user_%d_%d", vuID, iterID),
	})
	if err != nil {
		atomic.AddInt64(&result.ErrorCount, 1)
	} else {
		atomic.AddInt64(&result.SuccessCount, 1)
	}
	atomic.AddInt64(&result.TotalRequests, 1)

	// 4. Histórico
	_, err = client.ListReservations(ctx, &proto.ListReservationsRequest{
		UserId: fmt.Sprintf("load_user_%d_%d", vuID, iterID),
	})
	if err != nil {
		atomic.AddInt64(&result.ErrorCount, 1)
	} else {
		atomic.AddInt64(&result.SuccessCount, 1)
	}
	atomic.AddInt64(&result.TotalRequests, 1)

	return time.Since(start)
}

// printLoadTestResult imprime o resultado do teste
func printLoadTestResult(t *testing.T, result *LoadTestResult) {
	t.Logf("")
	t.Logf("╔══════════════════════════════════════════════════════════════════╗")
	t.Logf("║           📊 RESULTADO DO TESTE DE CARGA                         ║")
	t.Logf("╠══════════════════════════════════════════════════════════════════╣")
	t.Logf("║")
	t.Logf("║ 📈 MÉTRICAS GERAIS")
	t.Logf("║ ─────────────────────────────────────────────────────────────")
	t.Logf("║   Total de Requisições: %d", result.TotalRequests)
	t.Logf("║   Requisições com Sucesso: %d (%.2f%%)", result.SuccessCount, result.SuccessRate()*100)
	t.Logf("║   Requisições com Erro: %d", result.ErrorCount)
	t.Logf("║   Duração Total: %v", result.TotalDuration)
	t.Logf("║   Throughput: %.2f req/s", result.RequestsPerSec)
	t.Logf("║")
	t.Logf("║ ⏱️  LATÊNCIA")
	t.Logf("║ ─────────────────────────────────────────────────────────────")
	t.Logf("║   Média: %v", result.AvgLatency)
	t.Logf("║   P50: %v", result.P50Latency)
	t.Logf("║   P95: %v", result.P95Latency)
	t.Logf("║   P99: %v", result.P99Latency)
	t.Logf("║   Mínimo: %v", result.MinLatency)
	t.Logf("║   Máximo: %v", result.MaxLatency)
	t.Logf("║")
	t.Logf("╚══════════════════════════════════════════════════════════════════╝")
}

// ==================== Helpers ====================

func setupClient(b *testing.B) (*grpc.ClientConn, proto.ParkingServiceClient) {
	conn, err := grpc.Dial(
		defaultServerAddr,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
	)
	if err != nil {
		b.Fatalf("Failed to connect: %v", err)
	}

	return conn, proto.NewParkingServiceClient(conn)
}

// ==================== Benchmark: PaymentService ====================

// BenchmarkRequestSponsorship testa o patrocínio de lojas
func BenchmarkRequestSponsorship(b *testing.B) {
	conn, err := grpc.Dial(
		defaultServerAddr,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
	)
	if err != nil {
		b.Fatalf("Failed to connect: %v", err)
	}
	defer conn.Close()

	client := proto.NewPaymentServiceClient(conn)
	ctx := context.Background()
	counter := int64(0)

	b.ResetTimer()
	b.ReportAllocs()

	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			n := atomic.AddInt64(&counter, 1)
			req := &proto.SponsorshipRequest{
				ReservationId:   fmt.Sprintf("res_bench_%d", n),
				StoreId:         "store_001",
				AmountToSponsor: 25.00,
				Invoice: &proto.InvoiceInfo{
					InvoiceId: fmt.Sprintf("INV_BENCH_%d", n),
					AmountUsd: 250.00,
					Timestamp: time.Now().Unix(),
					StoreName: "Loja Benchmark",
				},
			}
			_, _ = client.RequestSponsorship(ctx, req)
		}
	})
}

// BenchmarkVerifyExit testa a verificação de saída
func BenchmarkVerifyExit(b *testing.B) {
	conn, err := grpc.Dial(
		defaultServerAddr,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
	)
	if err != nil {
		b.Fatalf("Failed to connect: %v", err)
	}
	defer conn.Close()

	client := proto.NewPaymentServiceClient(conn)
	ctx := context.Background()
	counter := int64(0)

	b.ResetTimer()
	b.ReportAllocs()

	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			n := atomic.AddInt64(&counter, 1)
			req := &proto.VerifyExitRequest{
				GarageId:     "garage_001",
				VehiclePlate: fmt.Sprintf("VRF%04d", n%10000),
			}
			_, _ = client.VerifyExit(ctx, req)
		}
	})
}
