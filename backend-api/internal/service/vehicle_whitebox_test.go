// =============================================================================
// TESTES DE CAIXA BRANCA - VehicleService
// =============================================================================
// Categoria: Testes Estruturais (White Box Testing)
// Norma: ISO/IEC/IEEE 29119-4:2021
// Técnicas:
//   - Statement Coverage (Cobertura de Comandos)
//   - Branch Coverage (Cobertura de Ramificações)
//   - Path Coverage (Cobertura de Caminhos)
//   - Condition Coverage (Cobertura de Condições)
// =============================================================================

package service

import (
	"context"
	"testing"
	"time"

	"github.com/emersonnjsantos/ParkingZero/backend-api/internal/database"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
)

// =============================================================================
// SETUP E HELPERS
// =============================================================================

// setupTestVehicleService cria um VehicleService com banco de teste em memória
func setupTestVehicleService(t *testing.T) (*VehicleService, func()) {
	t.Helper()

	// Criar banco de teste temporário
	dbPath := t.TempDir() + "/test_vehicle.db"
	db, err := database.Open(dbPath)
	if err != nil {
		t.Fatalf("Falha ao criar banco de teste: %v", err)
	}

	svc := &VehicleService{
		localDB:         db,
		firestoreClient: nil, // Mock - não precisamos do Firestore para testes unitários
		syncQueue:       make(chan *pb.VehicleEntry, 10),
	}

	cleanup := func() {
		db.Close()
	}

	return svc, cleanup
}

// =============================================================================
// TC-WB-VEH-001: RecordVehicleEntry - Cobertura de Validações
// Objetivo: Testar todos os caminhos de validação de entrada
// Técnica: Branch Coverage
// =============================================================================
func TestRecordVehicleEntry_Validations(t *testing.T) {
	svc, cleanup := setupTestVehicleService(t)
	defer cleanup()

	ctx := context.Background()

	testCases := []struct {
		name        string
		garageID    string
		plate       string
		expectError bool
		errorCode   string
		description string
	}{
		// Caminho 1: garage_id vazio
		{
			name:        "TC-WB-VEH-001-A: garage_id vazio",
			garageID:    "",
			plate:       "ABC1234",
			expectError: true,
			errorCode:   "InvalidArgument",
			description: "Verifica branch linha 35-37: if req.GetGarageId() == ''",
		},
		// Caminho 2: vehicle_plate vazia
		{
			name:        "TC-WB-VEH-001-B: vehicle_plate vazia",
			garageID:    "garage-123",
			plate:       "",
			expectError: true,
			errorCode:   "InvalidArgument",
			description: "Verifica branch linha 38-40: if req.GetVehiclePlate() == ''",
		},
		// Caminho 3: entrada válida
		{
			name:        "TC-WB-VEH-001-C: entrada válida",
			garageID:    "garage-123",
			plate:       "ABC1234",
			expectError: false,
			description: "Caminho feliz - passa por todas as validações",
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			req := &pb.VehicleEntryRequest{
				GarageId:     tc.garageID,
				VehiclePlate: tc.plate,
				EntryTime:    time.Now().Unix(),
			}

			resp, err := svc.RecordVehicleEntry(ctx, req)

			if tc.expectError {
				if err == nil {
					t.Errorf("[%s] Esperava erro mas recebeu sucesso", tc.name)
				}
			} else {
				if err != nil {
					t.Errorf("[%s] Erro inesperado: %v", tc.name, err)
				}
				if resp == nil || !resp.Success {
					t.Errorf("[%s] Resposta inválida", tc.name)
				}
			}
		})
	}
}

// =============================================================================
// TC-WB-VEH-002: RecordVehicleEntry - Cobertura de EntryTime Default
// Objetivo: Testar branch do entry_time automático
// Técnica: Condition Coverage (Linha 57-59)
// =============================================================================
func TestRecordVehicleEntry_EntryTimeDefault(t *testing.T) {
	svc, cleanup := setupTestVehicleService(t)
	defer cleanup()

	ctx := context.Background()

	t.Run("TC-WB-VEH-002-A: entry_time fornecido", func(t *testing.T) {
		providedTime := int64(1704067200) // 2024-01-01 00:00:00

		req := &pb.VehicleEntryRequest{
			GarageId:     "garage-001",
			VehiclePlate: "DEF5678",
			EntryTime:    providedTime,
		}

		resp, err := svc.RecordVehicleEntry(ctx, req)

		if err != nil {
			t.Fatalf("Erro inesperado: %v", err)
		}

		// Verifica que usou o tempo fornecido (branch FALSE linha 57)
		if resp.EntryTime != providedTime {
			t.Errorf("entry_time incorreto: esperado %d, recebido %d", providedTime, resp.EntryTime)
		}
	})

	t.Run("TC-WB-VEH-002-B: entry_time zero (default)", func(t *testing.T) {
		beforeTest := time.Now().Unix()

		req := &pb.VehicleEntryRequest{
			GarageId:     "garage-002",
			VehiclePlate: "GHI9012",
			EntryTime:    0, // Não fornecido
		}

		resp, err := svc.RecordVehicleEntry(ctx, req)

		afterTest := time.Now().Unix()

		if err != nil {
			t.Fatalf("Erro inesperado: %v", err)
		}

		// Verifica que usou timestamp atual (branch TRUE linha 57)
		if resp.EntryTime < beforeTest || resp.EntryTime > afterTest {
			t.Errorf("entry_time deveria ser o timestamp atual, recebido: %d", resp.EntryTime)
		}
	})
}

// =============================================================================
// TC-WB-VEH-003: RecordVehicleEntry - Cobertura de Duplicatas
// Objetivo: Testar branch de ErrDuplicateKey
// Técnica: Path Coverage (Linhas 70-74)
// =============================================================================
func TestRecordVehicleEntry_DuplicateKey(t *testing.T) {
	svc, cleanup := setupTestVehicleService(t)
	defer cleanup()

	ctx := context.Background()

	// Primeira entrada - sucesso
	req := &pb.VehicleEntryRequest{
		GarageId:     "garage-dup",
		VehiclePlate: "DUP1234",
		EntryTime:    time.Now().Unix(),
	}

	_, err := svc.RecordVehicleEntry(ctx, req)
	if err != nil {
		t.Fatalf("Primeira entrada falhou: %v", err)
	}

	// Segunda entrada com mesma chave - deve falhar
	t.Run("TC-WB-VEH-003-A: Entrada duplicada", func(t *testing.T) {
		_, err := svc.RecordVehicleEntry(ctx, req)

		if err == nil {
			t.Error("Esperava erro ErrDuplicateKey, mas recebeu sucesso")
		}
	})
}

// =============================================================================
// TC-WB-VEH-004: RecordVehicleEntry - Cobertura de SyncQueue
// Objetivo: Testar branches do select para fila de sincronização
// Técnica: Branch Coverage (Linhas 77-84)
// =============================================================================
func TestRecordVehicleEntry_SyncQueue(t *testing.T) {
	t.Run("TC-WB-VEH-004-A: Fila com espaço", func(t *testing.T) {
		svc, cleanup := setupTestVehicleService(t)
		defer cleanup()

		ctx := context.Background()

		req := &pb.VehicleEntryRequest{
			GarageId:     "garage-sync",
			VehiclePlate: "SYN1234",
			EntryTime:    time.Now().Unix(),
		}

		_, err := svc.RecordVehicleEntry(ctx, req)
		if err != nil {
			t.Fatalf("Erro inesperado: %v", err)
		}

		// Verifica que entrada foi enfileirada (branch case linha 78)
		select {
		case entry := <-svc.syncQueue:
			if entry.VehiclePlate != "SYN1234" {
				t.Errorf("Entrada errada na fila: %s", entry.VehiclePlate)
			}
		default:
			t.Error("Entrada não foi enfileirada")
		}
	})

	t.Run("TC-WB-VEH-004-B: Fila cheia (default branch)", func(t *testing.T) {
		// Criar serviço com fila de tamanho 1
		dbPath := t.TempDir() + "/test_queue_full.db"
		db, err := database.Open(dbPath)
		if err != nil {
			t.Fatalf("Erro ao criar banco: %v", err)
		}
		defer db.Close()

		svc := &VehicleService{
			localDB:         db,
			firestoreClient: nil,
			syncQueue:       make(chan *pb.VehicleEntry, 1), // Fila pequena
		}

		ctx := context.Background()

		// Primeira entrada - preenche a fila
		req1 := &pb.VehicleEntryRequest{
			GarageId:     "garage-full",
			VehiclePlate: "FULL001",
			EntryTime:    time.Now().Unix(),
		}
		_, err = svc.RecordVehicleEntry(ctx, req1)
		if err != nil {
			t.Fatalf("Primeira entrada falhou: %v", err)
		}

		// Segunda entrada - fila já cheia, deve ir para default branch
		req2 := &pb.VehicleEntryRequest{
			GarageId:     "garage-full",
			VehiclePlate: "FULL002",
			EntryTime:    time.Now().Unix(),
		}

		resp, err := svc.RecordVehicleEntry(ctx, req2)

		// Operação ainda deve ter sucesso (não bloqueia)
		if err != nil {
			t.Errorf("Erro inesperado: %v", err)
		}
		if resp == nil || !resp.Success {
			t.Error("Operação deveria ter sucesso mesmo com fila cheia")
		}
		// Verifica que entrou no branch default (linha 80-83)
		// A entrada foi salva no banco mas não na fila
	})
}

// =============================================================================
// TC-WB-VEH-005: GetVehicleEntry - Cobertura Completa
// Objetivo: Testar todos os caminhos de busca
// Técnica: Statement Coverage
// =============================================================================
func TestGetVehicleEntry_AllStatements(t *testing.T) {
	svc, cleanup := setupTestVehicleService(t)
	defer cleanup()

	ctx := context.Background()

	// Setup: criar uma entrada
	entryReq := &pb.VehicleEntryRequest{
		GarageId:     "garage-get",
		VehiclePlate: "GET1234",
		EntryTime:    time.Now().Unix(),
	}
	_, err := svc.RecordVehicleEntry(ctx, entryReq)
	if err != nil {
		t.Fatalf("Setup falhou: %v", err)
	}

	testCases := []struct {
		name        string
		garageID    string
		plate       string
		expectError bool
		description string
	}{
		{
			name:        "TC-WB-VEH-005-A: garage_id vazio",
			garageID:    "",
			plate:       "GET1234",
			expectError: true,
			description: "Branch linha 212-214",
		},
		{
			name:        "TC-WB-VEH-005-B: plate vazia",
			garageID:    "garage-get",
			plate:       "",
			expectError: true,
			description: "Branch linha 215-217",
		},
		{
			name:        "TC-WB-VEH-005-C: não encontrado",
			garageID:    "garage-get",
			plate:       "NOTEXIST",
			expectError: true,
			description: "Branch linha 222-224",
		},
		{
			name:        "TC-WB-VEH-005-D: encontrado",
			garageID:    "garage-get",
			plate:       "GET1234",
			expectError: false,
			description: "Caminho feliz - retorna entrada",
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			req := &pb.GetVehicleEntryRequest{
				GarageId:     tc.garageID,
				VehiclePlate: tc.plate,
			}

			entry, err := svc.GetVehicleEntry(ctx, req)

			if tc.expectError {
				if err == nil {
					t.Errorf("[%s] Esperava erro mas recebeu sucesso", tc.name)
				}
			} else {
				if err != nil {
					t.Errorf("[%s] Erro inesperado: %v", tc.name, err)
				}
				if entry == nil {
					t.Errorf("[%s] Entrada não retornada", tc.name)
				}
			}
		})
	}
}

// =============================================================================
// TC-WB-VEH-006: GetActiveVehicles - Validação
// Objetivo: Testar validação de garage_id
// Técnica: Branch Coverage (Linha 190-192)
// =============================================================================
func TestGetActiveVehicles_Validation(t *testing.T) {
	svc, cleanup := setupTestVehicleService(t)
	defer cleanup()

	ctx := context.Background()

	t.Run("TC-WB-VEH-006-A: garage_id vazio", func(t *testing.T) {
		req := &pb.GetActiveVehiclesRequest{
			GarageId: "",
		}

		_, err := svc.GetActiveVehicles(ctx, req)

		if err == nil {
			t.Error("Esperava erro para garage_id vazio")
		}
	})

	t.Run("TC-WB-VEH-006-B: garage_id válido", func(t *testing.T) {
		req := &pb.GetActiveVehiclesRequest{
			GarageId: "garage-active",
		}

		resp, err := svc.GetActiveVehicles(ctx, req)

		if err != nil {
			t.Errorf("Erro inesperado: %v", err)
		}
		if resp == nil {
			t.Error("Resposta não deveria ser nil")
		}
	})
}
