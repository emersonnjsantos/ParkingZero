package main

import (
	"log"
	"os"
	"testing"
	"time"

	"github.com/emersonnjsantos/ParkingZero/backend-api/internal/database"
	pb "github.com/emersonnjsantos/ParkingZero/pkg/pb"
	"google.golang.org/protobuf/proto"
)

func TestDatabaseIntegration(t *testing.T) {
	// 1. Abrir banco local
	dbPath := "./test_integration.db"
	localDB, err := database.Open(dbPath)
	if err != nil {
		t.Fatalf("Falha ao abrir banco: %v", err)
	}
	defer localDB.Close()
	defer os.Remove(dbPath)

	// 2. Criar entrada de veículo (proto)
	entry := &pb.VehicleEntry{
		Id:           "garage-123|ABC1234",
		GarageId:     "garage-123",
		VehiclePlate: "ABC1234",
		EntryTime:    time.Now().Unix(),
		ExitTime:     0,
		AmountPaid:   0,
		Status:       pb.VehicleStatus_PARKED,
		UserId:       "user-456",
	}

	// 3. Serializar com Protobuffer
	protoBytes, err := proto.Marshal(entry)
	if err != nil {
		t.Fatalf("Erro ao serializar proto: %v", err)
	}
	log.Printf("📦 Protobuffer serializado: %d bytes", len(protoBytes))

	// 4. Salvar no B+Tree local
	key := database.MakeCompositeKey(entry.GarageId, entry.VehiclePlate)
	if err := localDB.Put(key, protoBytes); err != nil {
		t.Fatalf("Erro ao salvar no B+Tree: %v", err)
	}
	log.Printf("💾 Entrada salva no B+Tree: %s", key)

	// 5. Buscar no B+Tree
	retrievedBytes, found := localDB.Get(key)
	if !found {
		t.Fatal("❌ Entrada não encontrada no B+Tree!")
	}
	log.Printf("🔍 Entrada recuperada: %d bytes", len(retrievedBytes))

	// 6. Deserializar
	var retrievedEntry pb.VehicleEntry
	if err := proto.Unmarshal(retrievedBytes, &retrievedEntry); err != nil {
		t.Fatalf("Erro ao deserializar: %v", err)
	}

	// 7. Verificar dados
	if retrievedEntry.GarageId != entry.GarageId {
		t.Errorf("GarageID mismatch: got %s, want %s", retrievedEntry.GarageId, entry.GarageId)
	}
	if retrievedEntry.VehiclePlate != entry.VehiclePlate {
		t.Errorf("Plate mismatch: got %s, want %s", retrievedEntry.VehiclePlate, entry.VehiclePlate)
	}
	if retrievedEntry.Status != pb.VehicleStatus_PARKED {
		t.Errorf("Status mismatch: got %v, want PARKED", retrievedEntry.Status)
	}

	log.Printf("✅ Teste de integração PASSOU!")
	log.Printf("   Garagem: %s", retrievedEntry.GarageId)
	log.Printf("   Placa: %s", retrievedEntry.VehiclePlate)
	log.Printf("   Status: %v", retrievedEntry.Status)
	log.Printf("   Entrada: %v", time.Unix(retrievedEntry.EntryTime, 0))

	// 8. Testar atualização (saída do veículo)
	retrievedEntry.ExitTime = time.Now().Unix()
	retrievedEntry.AmountPaid = 25.50
	retrievedEntry.Status = pb.VehicleStatus_EXITED

	updatedBytes, _ := proto.Marshal(&retrievedEntry)
	localDB.Delete(key)
	if err := localDB.Put(key, updatedBytes); err != nil {
		t.Fatalf("Erro ao atualizar entrada: %v", err)
	}

	// Verificar atualização
	finalBytes, _ := localDB.Get(key)
	var finalEntry pb.VehicleEntry
	proto.Unmarshal(finalBytes, &finalEntry)

	if finalEntry.Status != pb.VehicleStatus_EXITED {
		t.Errorf("Status não atualizado corretamente")
	}
	if finalEntry.AmountPaid != 25.50 {
		t.Errorf("Valor pago não atualizado: got %.2f, want 25.50", finalEntry.AmountPaid)
	}

	log.Printf("✅ Atualização testada com sucesso!")
	log.Printf("   Status final: %v", finalEntry.Status)
	log.Printf("   Valor pago: R$ %.2f", finalEntry.AmountPaid)
}
