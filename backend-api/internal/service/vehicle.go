package service

import (
	"context"
	"fmt"
	"time"

	"cloud.google.com/go/firestore"
	"github.com/emersonnjsantos/ParkingZero/backend-api/internal/database"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
)

// VehicleService gerencia operações de entrada/saída de veículos
type VehicleService struct {
	localDB         *database.DB
	firestoreClient *firestore.Client
	syncQueue       chan *pb.VehicleEntry // Fila para sincronização assíncrona
}

// NewVehicleService cria um novo serviço de veículos
func NewVehicleService(localDB *database.DB, firestoreClient *firestore.Client) *VehicleService {
	return &VehicleService{
		localDB:         localDB,
		firestoreClient: firestoreClient,
		syncQueue:       make(chan *pb.VehicleEntry, 100), // Buffer de 100 entradas
	}
}

// RecordVehicleEntry registra a entrada de um veículo (LATÊNCIA CRÍTICA)
func (s *VehicleService) RecordVehicleEntry(ctx context.Context, req *pb.VehicleEntryRequest) (*pb.VehicleEntryResponse, error) {
	// Validações
	if req.GetGarageId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id é obrigatório")
	}
	if req.GetVehiclePlate() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "vehicle_plate é obrigatória")
	}

	// Criar entrada
	compositeKey := database.MakeCompositeKey(req.GarageId, req.VehiclePlate)

	entry := &pb.VehicleEntry{
		Id:           string(compositeKey), // Converter para string
		GarageId:     req.GarageId,
		VehiclePlate: req.VehiclePlate,
		EntryTime:    req.EntryTime,
		ExitTime:     0, // Ainda não saiu
		AmountPaid:   0,
		Status:       pb.VehicleStatus_PARKED,
		UserId:       req.UserId,
	}

	// Se entry_time não foi fornecido, usar timestamp atual
	if entry.EntryTime == 0 {
		entry.EntryTime = time.Now().Unix()
	}

	// PASSO 1: Salvar no banco local B+Tree (LATÊNCIA ZERO)
	protoBytes, err := proto.Marshal(entry)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "falha ao serializar entrada: %v", err)
	}

	key := []byte(entry.Id)
	if err := s.localDB.Put(key, protoBytes); err != nil {
		// Se der erro ErrDuplicateKey, veículo já está estacionado
		if err == database.ErrDuplicateKey {
			return nil, status.Errorf(codes.AlreadyExists, "veículo já está estacionado nesta garagem")
		}
		return nil, status.Errorf(codes.Internal, "falha ao gravar no banco local: %v", err)
	}

	// PASSO 2: Enviar para fila de sincronização (não bloqueia)
	select {
	case s.syncQueue <- entry:
		// Enfileirado com sucesso
	default:
		// Fila cheia - log de warning mas não falha a operação
		// O sync worker eventualmente pegará do banco
		fmt.Printf("WARNING: sync queue full, entrada %s será sincronizada no próximo cycle\n", entry.Id)
	}

	// PASSO 3: Retornar sucesso imediatamente
	return &pb.VehicleEntryResponse{
		EntryId:   string(key),
		Success:   true,
		Message:   "Entrada registrada com sucesso",
		EntryTime: entry.EntryTime,
	}, nil
}

// RecordVehicleExit registra a saída de um veículo e calcula o valor
func (s *VehicleService) RecordVehicleExit(ctx context.Context, req *pb.VehicleExitRequest) (*pb.VehicleExitResponse, error) {
	// Validações
	if req.GetGarageId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id é obrigatório")
	}
	if req.GetVehiclePlate() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "vehicle_plate é obrigatória")
	}

	// Buscar entrada no banco local
	key := database.MakeCompositeKey(req.GarageId, req.VehiclePlate)
	protoBytes, found := s.localDB.Get(key)
	if !found {
		return nil, status.Errorf(codes.NotFound, "veículo não encontrado nesta garagem")
	}

	// Deserializar entrada
	var entry pb.VehicleEntry
	if err := proto.Unmarshal(protoBytes, &entry); err != nil {
		return nil, status.Errorf(codes.Internal, "falha ao deserializar entrada: %v", err)
	}

	// Verificar se já não saiu
	if entry.Status == pb.VehicleStatus_EXITED {
		return nil, status.Errorf(codes.FailedPrecondition, "veículo já saiu às %v", time.Unix(entry.ExitTime, 0))
	}

	// Definir timestamp de saída
	exitTime := req.ExitTime
	if exitTime == 0 {
		exitTime = time.Now().Unix()
	}

	// Calcular duração e valor
	durationSeconds := exitTime - entry.EntryTime
	if durationSeconds < 0 {
		return nil, status.Errorf(codes.InvalidArgument, "exit_time não pode ser anterior a entry_time")
	}

	// Buscar preço base da garagem
	garageDoc, err := s.firestoreClient.Collection("garages").Doc(req.GarageId).Get(ctx)
	var basePrice float64 = 5.0 // Preço padrão se não encontrar
	if err == nil {
		data := garageDoc.Data()
		if price, ok := data["base_price"].(float64); ok {
			basePrice = price
		}
	}

	// Calcular valor total (base_price por hora)
	hours := float64(durationSeconds) / 3600.0
	totalAmount := basePrice * hours

	// Atualizar entrada
	entry.ExitTime = exitTime
	entry.AmountPaid = totalAmount
	entry.Status = pb.VehicleStatus_EXITED

	// Salvar no banco local
	updatedBytes, _ := proto.Marshal(&entry)
	// Primeiro deletar a entrada antiga
	s.localDB.Delete(key)
	// Depois inserir a atualizada (workaround para update)
	if err := s.localDB.Put(key, updatedBytes); err != nil {
		return nil, status.Errorf(codes.Internal, "falha ao atualizar entrada: %v", err)
	}

	// Enviar para fila de sincronização
	select {
	case s.syncQueue <- &entry:
	default:
		fmt.Printf("WARNING: sync queue full para saída %s\n", entry.Id)
	}

	// Retornar resposta
	return &pb.VehicleExitResponse{
		EntryId:         string(key),
		TotalAmount:     totalAmount,
		DurationSeconds: durationSeconds,
		EntryTime:       entry.EntryTime,
		ExitTime:        exitTime,
		Success:         true,
		Message:         fmt.Sprintf("Total: R$ %.2f | Duração: %dh%dm", totalAmount, durationSeconds/3600, (durationSeconds%3600)/60),
	}, nil
}

// GetActiveVehicles retorna todos os veículos ativamente estacionados
// NOTA: Esta operação pode ser lenta se houver muitas entradas no banco
// TODO: Implementar índice secundário ou cache em memória
func (s *VehicleService) GetActiveVehicles(ctx context.Context, req *pb.GetActiveVehiclesRequest) (*pb.GetActiveVehiclesResponse, error) {
	// Por enquanto, esta operação consulta o Firestore
	// porque a B+Tree não tem índice secundário por garage_id
	// TODO: Adicionar suporte a scan com prefixo no B+Tree

	if req.GetGarageId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id é obrigatório")
	}

	// Consultar Firestore temporariamente
	// Quando o Sync Worker estiver implementado, os dados estarão lá
	// iter := s.firestoreClient.Collection("vehicle_entries").
	// 	Where("garage_id", "==", req.GarageId).
	// 	Where("status", "==", int32(pb.VehicleStatus_PARKED)).
	// 	Documents(ctx)

	var activeVehicles []*pb.VehicleEntry
	// TODO: Implementar iteração completa

	return &pb.GetActiveVehiclesResponse{
		Vehicles:    activeVehicles,
		TotalActive: int32(len(activeVehicles)),
	}, nil
}

// GetVehicleEntry busca uma entrada específica
func (s *VehicleService) GetVehicleEntry(ctx context.Context, req *pb.GetVehicleEntryRequest) (*pb.VehicleEntry, error) {
	if req.GetGarageId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id é obrigatório")
	}
	if req.GetVehiclePlate() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "vehicle_plate é obrigatória")
	}

	// Buscar no banco local
	key := database.MakeCompositeKey(req.GarageId, req.VehiclePlate)
	protoBytes, found := s.localDB.Get(key)
	if !found {
		return nil, status.Errorf(codes.NotFound, "entrada não encontrada")
	}

	// Deserializar
	var entry pb.VehicleEntry
	if err := proto.Unmarshal(protoBytes, &entry); err != nil {
		return nil, status.Errorf(codes.Internal, "falha ao deserializar: %v", err)
	}

	return &entry, nil
}

// GetSyncQueue retorna o canal de sincronização (para o Sync Worker)
func (s *VehicleService) GetSyncQueue() <-chan *pb.VehicleEntry {
	return s.syncQueue
}
