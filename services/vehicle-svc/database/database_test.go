package database

import (
	"path/filepath"
	"testing"
)

func TestDatabaseOpenClose(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "parkingzero.db")

	db, err := Open(dbPath)
	if err != nil {
		t.Fatalf("Failed to open database: %v", err)
	}

	stats, err := db.GetStats()
	if err != nil {
		t.Fatalf("Failed to get stats: %v", err)
	}

	if stats.TotalPages == 0 {
		t.Error("Expected at least meta page")
	}

	if err := db.Close(); err != nil {
		t.Fatalf("Failed to close database: %v", err)
	}
}

func TestDatabasePutGet(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "test.db")

	db, err := Open(dbPath)
	if err != nil {
		t.Fatalf("Failed to open database: %v", err)
	}
	defer db.Close()

	// Teste básico de Put/Get
	key := MakeCompositeKey("garage-123", "ABC1234")
	value := []byte("proto-serialized-vehicle-entry-data")

	if err := db.Put(key, value); err != nil {
		t.Fatalf("Failed to put: %v", err)
	}

	retrievedValue, found := db.Get(key)
	if !found {
		t.Fatal("Key not found after insertion")
	}

	if string(retrievedValue) != string(value) {
		t.Errorf("Value mismatch: got %s, want %s", retrievedValue, value)
	}
}

func TestDatabaseMultipleInserts(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "multi.db")

	db, err := Open(dbPath)
	if err != nil {
		t.Fatalf("Failed to open database: %v", err)
	}
	defer db.Close()

	// Inserir múltiplas entradas
	testData := []struct {
		garageID string
		plate    string
		value    string
	}{
		{"garage-1", "ABC1234", "entry-1"},
		{"garage-1", "XYZ5678", "entry-2"},
		{"garage-2", "DEF9999", "entry-3"},
		{"garage-1", "GHI0000", "entry-4"},
		{"garage-3", "JKL1111", "entry-5"},
	}

	for _, td := range testData {
		key := MakeCompositeKey(td.garageID, td.plate)
		if err := db.Put(key, []byte(td.value)); err != nil {
			t.Fatalf("Failed to insert %s/%s: %v", td.garageID, td.plate, err)
		}
	}

	// Verificar que todas podem ser recuperadas
	for _, td := range testData {
		key := MakeCompositeKey(td.garageID, td.plate)
		value, found := db.Get(key)
		if !found {
			t.Errorf("Key %s not found", key)
		}
		if string(value) != td.value {
			t.Errorf("Value mismatch for %s: got %s, want %s", key, value, td.value)
		}
	}
}

func TestDatabaseDelete(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "delete.db")

	db, err := Open(dbPath)
	if err != nil {
		t.Fatalf("Failed to open database: %v", err)
	}
	defer db.Close()

	key := MakeCompositeKey("garage-1", "ABC1234")
	value := []byte("test-entry")

	// Inserir
	if err := db.Put(key, value); err != nil {
		t.Fatalf("Failed to put: %v", err)
	}

	// Verificar que existe
	_, found := db.Get(key)
	if !found {
		t.Fatal("Key should exist before delete")
	}

	// Deletar
	if err := db.Delete(key); err != nil {
		t.Fatalf("Failed to delete: %v", err)
	}

	// Verificar que não existe mais
	_, found = db.Get(key)
	if found {
		t.Fatal("Key should not exist after delete")
	}
}

func TestDatabasePersistence(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "persist.db")

	// Fase 1: Inserir dados e fechar
	func() {
		db, err := Open(dbPath)
		if err != nil {
			t.Fatalf("Failed to open database: %v", err)
		}

		for i := 0; i < 10; i++ {
			key := MakeCompositeKey("garage-1", string(rune('A'+i))+"BC1234")
			value := []byte("entry-" + string(rune('0'+i)))
			if err := db.Put(key, value); err != nil {
				t.Fatalf("Failed to insert: %v", err)
			}
		}

		if err := db.Close(); err != nil {
			t.Fatalf("Failed to close: %v", err)
		}
	}()

	// Fase 2: Reabrir e verificar dados
	db, err := Open(dbPath)
	if err != nil {
		t.Fatalf("Failed to reopen database: %v", err)
	}
	defer db.Close()

	for i := 0; i < 10; i++ {
		key := MakeCompositeKey("garage-1", string(rune('A'+i))+"BC1234")
		expectedValue := "entry-" + string(rune('0'+i))

		value, found := db.Get(key)
		if !found {
			t.Errorf("Key %s not found after reopen", key)
		}
		if string(value) != expectedValue {
			t.Errorf("Value mismatch after reopen: got %s, want %s", value, expectedValue)
		}
	}
}

func TestDatabaseDuplicateKey(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "dup.db")

	db, err := Open(dbPath)
	if err != nil {
		t.Fatalf("Failed to open database: %v", err)
	}
	defer db.Close()

	key := MakeCompositeKey("garage-1", "ABC1234")

	// Primeira inserção deve funcionar
	if err := db.Put(key, []byte("value-1")); err != nil {
		t.Fatalf("First insert failed: %v", err)
	}

	// Segunda inserção da mesma chave deve falhar
	err = db.Put(key, []byte("value-2"))
	if err != ErrDuplicateKey {
		t.Errorf("Expected ErrDuplicateKey, got %v", err)
	}
}

func TestDatabaseMetaPage(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "meta.db")

	db, err := Open(dbPath)
	if err != nil {
		t.Fatalf("Failed to open database: %v", err)
	}
	defer db.Close()

	// Inserir alguns dados
	for i := 0; i < 5; i++ {
		key := MakeCompositeKey("garage-1", "PLATE"+string(rune('0'+i)))
		value := []byte("entry-" + string(rune('0'+i)))
		db.Put(key, value)
	}

	// Atualizar LastSyncedID (simula sincronização com Firestore)
	meta, err := db.GetMetaPage()
	if err != nil {
		t.Fatalf("Failed to get meta page: %v", err)
	}

	meta.LastSyncedID = 12345
	if err := db.UpdateMetaPage(meta); err != nil {
		t.Fatalf("Failed to update meta page: %v", err)
	}

	// Verificar atualização
	updatedMeta, err := db.GetMetaPage()
	if err != nil {
		t.Fatalf("Failed to get updated meta page: %v", err)
	}

	if updatedMeta.LastSyncedID != 12345 {
		t.Errorf("LastSyncedID not persisted: got %d, want 12345", updatedMeta.LastSyncedID)
	}
}
