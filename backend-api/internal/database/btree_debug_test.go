package database

import (
	"fmt"
	"path/filepath"
	"testing"
)

func TestSimpleSplit(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "simple_split.db")

	db, err := Open(dbPath)
	if err != nil {
		t.Fatalf("Failed to open database: %v", err)
	}
	defer db.Close()

	// Inserir muitas chaves para forçar um split
	numKeys := 50
	for i := 0; i < numKeys; i++ {
		key := MakeCompositeKey("garage-1", fmt.Sprintf("PLATE%03d", i))
		value := []byte(fmt.Sprintf("entry-%d", i))

		if err := db.Put(key, value); err != nil {
			t.Fatalf("Failed to insert key %d: %v", i, err)
		}
	}

	// Agora verificar se TODAS as chaves podem ser recuperadas
	notFound := 0
	for i := 0; i < numKeys; i++ {
		key := MakeCompositeKey("garage-1", fmt.Sprintf("PLATE%03d", i))
		expectedValue := fmt.Sprintf("entry-%d", i)

		value, found := db.Get(key)
		if !found {
			t.Errorf("Key %d (%s) not found", i, key)
			notFound++
		} else if string(value) != expectedValue {
			t.Errorf("Value mismatch for key %d: got %s, want %s", i, value, expectedValue)
		}
	}

	if notFound > 0 {
		t.Errorf("Total keys not found: %d/%d", notFound, numKeys)
	}
}
