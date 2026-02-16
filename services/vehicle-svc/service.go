package main

import (
	"context"
	"fmt"
	"time"

	"cloud.google.com/go/firestore"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
	"github.com/emersonnjsantos/ParkingZero/services/vehicle-svc/database"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
)

// VehicleService gerencia operações de entrada/saída de veículos
type VehicleService struct {
	pb.UnimplementedParkingServiceServer
	localDB         *database.DB
	firestoreClient *firestore.Client
	syncQueue       chan *pb.VehicleEntry
}

func NewVehicleService(localDB *database.DB, firestoreClient *firestore.Client) *VehicleService {
	return &VehicleService{
		localDB:         localDB,
		firestoreClient: firestoreClient,
		syncQueue:       make(chan *pb.VehicleEntry, 100),
	}
}

// RecordVehicleEntry registra a entrada de um veículo (LATÊNCIA CRÍTICA)
func (s *VehicleService) RecordVehicleEntry(ctx context.Context, req *pb.VehicleEntryRequest) (*pb.VehicleEntryResponse, error) {
	if req.GetGarageId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id é obrigatório")
	}
	if req.GetVehiclePlate() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "vehicle_plate é obrigatória")
	}

	compositeKey := database.MakeCompositeKey(req.GarageId, req.VehiclePlate)

	entry := &pb.VehicleEntry{
		Id:           string(compositeKey),
		GarageId:     req.GarageId,
		VehiclePlate: req.VehiclePlate,
		EntryTime:    req.EntryTime,
		ExitTime:     0,
		AmountPaid:   0,
		Status:       pb.VehicleStatus_PARKED,
		UserId:       req.UserId,
	}

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
		if err == database.ErrDuplicateKey {
			return nil, status.Errorf(codes.AlreadyExists, "veículo já está estacionado nesta garagem")
		}
		return nil, status.Errorf(codes.Internal, "falha ao gravar no banco local: %v", err)
	}

	// PASSO 2: Enviar para fila de sincronização
	select {
	case s.syncQueue <- entry:
	default:
		fmt.Printf("WARNING: sync queue full, entrada %s será sincronizada no próximo cycle\n", entry.Id)
	}

	return &pb.VehicleEntryResponse{
		EntryId:   string(key),
		Success:   true,
		Message:   "Entrada registrada com sucesso",
		EntryTime: entry.EntryTime,
	}, nil
}

// RecordVehicleExit registra a saída de um veículo e calcula o valor
func (s *VehicleService) RecordVehicleExit(ctx context.Context, req *pb.VehicleExitRequest) (*pb.VehicleExitResponse, error) {
	if req.GetGarageId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id é obrigatório")
	}
	if req.GetVehiclePlate() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "vehicle_plate é obrigatória")
	}

	key := database.MakeCompositeKey(req.GarageId, req.VehiclePlate)
	protoBytes, found := s.localDB.Get(key)
	if !found {
		return nil, status.Errorf(codes.NotFound, "veículo não encontrado nesta garagem")
	}

	var entry pb.VehicleEntry
	if err := proto.Unmarshal(protoBytes, &entry); err != nil {
		return nil, status.Errorf(codes.Internal, "falha ao deserializar entrada: %v", err)
	}

	if entry.Status == pb.VehicleStatus_EXITED {
		return nil, status.Errorf(codes.FailedPrecondition, "veículo já saiu às %v", time.Unix(entry.ExitTime, 0))
	}

	exitTime := req.ExitTime
	if exitTime == 0 {
		exitTime = time.Now().Unix()
	}

	durationSeconds := exitTime - entry.EntryTime
	if durationSeconds < 0 {
		return nil, status.Errorf(codes.InvalidArgument, "exit_time não pode ser anterior a entry_time")
	}

	// Buscar preço base da garagem
	garageDoc, err := s.firestoreClient.Collection("garages").Doc(req.GarageId).Get(ctx)
	var basePrice float64 = 5.0
	if err == nil {
		data := garageDoc.Data()
		if price, ok := data["base_price"].(float64); ok {
			basePrice = price
		}
	}

	hours := float64(durationSeconds) / 3600.0
	totalAmount := basePrice * hours

	entry.ExitTime = exitTime
	entry.AmountPaid = totalAmount
	entry.Status = pb.VehicleStatus_EXITED

	updatedBytes, _ := proto.Marshal(&entry)
	s.localDB.Delete(key)
	if err := s.localDB.Put(key, updatedBytes); err != nil {
		return nil, status.Errorf(codes.Internal, "falha ao atualizar entrada: %v", err)
	}

	select {
	case s.syncQueue <- &entry:
	default:
		fmt.Printf("WARNING: sync queue full para saída %s\n", entry.Id)
	}

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
func (s *VehicleService) GetActiveVehicles(ctx context.Context, req *pb.GetActiveVehiclesRequest) (*pb.GetActiveVehiclesResponse, error) {
	if req.GetGarageId() == "" {
		return nil, status.Errorf(codes.InvalidArgument, "garage_id é obrigatório")
	}

	var activeVehicles []*pb.VehicleEntry
	// TODO: Implementar iteração completa por prefixo no B+Tree

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

	key := database.MakeCompositeKey(req.GarageId, req.VehiclePlate)
	protoBytes, found := s.localDB.Get(key)
	if !found {
		return nil, status.Errorf(codes.NotFound, "entrada não encontrada")
	}

	var entry pb.VehicleEntry
	if err := proto.Unmarshal(protoBytes, &entry); err != nil {
		return nil, status.Errorf(codes.Internal, "falha ao deserializar: %v", err)
	}

	return &entry, nil
}

// GetSyncQueue retorna o canal de sincronização
func (s *VehicleService) GetSyncQueue() <-chan *pb.VehicleEntry {
	return s.syncQueue
}
