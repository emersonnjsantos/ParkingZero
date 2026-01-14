package database

import (
	"bytes"
	"testing"
)

func TestBNodeHeader(t *testing.T) {
	page := &Page{}
	node := NewBNode(page)

	// Testar definição e leitura de header
	node.SetHeader(NodeTypeLeaf, 5, 42)

	if node.NodeType() != NodeTypeLeaf {
		t.Errorf("NodeType: got %d, want %d", node.NodeType(), NodeTypeLeaf)
	}

	if node.NKeys() != 5 {
		t.Errorf("NKeys: got %d, want 5", node.NKeys())
	}

	if node.Parent() != 42 {
		t.Errorf("Parent: got %d, want 42", node.Parent())
	}
}

func TestBNodeCompositeKey(t *testing.T) {
	garageID := "garage-123"
	plate := "ABC1234"

	key := MakeCompositeKey(garageID, plate)

	expectedKey := "garage-123|ABC1234"
	if string(key) != expectedKey {
		t.Errorf("MakeCompositeKey: got %s, want %s", key, expectedKey)
	}

	// Testar decomposição
	gid, plt := SplitCompositeKey(key)
	if gid != garageID {
		t.Errorf("SplitCompositeKey garageID: got %s, want %s", gid, garageID)
	}
	if plt != plate {
		t.Errorf("SplitCompositeKey plate: got %s, want %s", plt, plate)
	}
}

func TestBNodeLeafOperations(t *testing.T) {
	page := &Page{}
	node := NewBNode(page)

	node.SetHeader(NodeTypeLeaf, 0, 0)

	// Inserir 3 entradas de teste
	testData := []struct {
		key   []byte
		value []byte
	}{
		{MakeCompositeKey("garage-1", "ABC1234"), []byte("proto-data-1")},
		{MakeCompositeKey("garage-1", "XYZ5678"), []byte("proto-data-2-longer")},
		{MakeCompositeKey("garage-2", "DEF9999"), []byte("proto-3")},
	}

	for i, td := range testData {
		node.SetLeafKV(uint16(i), td.key, td.value)
	}
	node.SetNKeys(3)

	// Verificar leitura
	for i, td := range testData {
		readKey := node.GetLeafKey(uint16(i))
		if !bytes.Equal(readKey, td.key) {
			t.Errorf("Leaf key %d mismatch: got %s, want %s", i, readKey, td.key)
		}

		readValue := node.GetLeafValue(uint16(i))
		if !bytes.Equal(readValue, td.value) {
			t.Errorf("Leaf value %d mismatch: got %s, want %s", i, readValue, td.value)
		}
	}
}

func TestBNodeInternalOperations(t *testing.T) {
	page := &Page{}
	node := NewBNode(page)

	node.SetHeader(NodeTypeInternal, 0, 0)

	// Layout de nó interno: [ptr_0][key_1][ptr_1][key_2][ptr_2]
	// Inserir 3 ponteiros e 2 chaves
	node.SetPointer(0, 100)
	node.SetInternalKey(1, MakeCompositeKey("garage-1", "ABC0000"))
	node.SetPointer(1, 200)
	node.SetInternalKey(2, MakeCompositeKey("garage-2", "XYZ0000"))
	node.SetPointer(2, 300)
	node.SetNKeys(2)

	// Verificar leitura
	if node.GetPointer(0) != 100 {
		t.Errorf("Pointer 0: got %d, want 100", node.GetPointer(0))
	}

	key1 := node.GetInternalKey(1)
	expectedKey1 := MakeCompositeKey("garage-1", "ABC0000")
	if !bytes.Equal(key1, expectedKey1) {
		t.Errorf("Key 1 mismatch: got %s, want %s", key1, expectedKey1)
	}

	if node.GetPointer(1) != 200 {
		t.Errorf("Pointer 1: got %d, want 200", node.GetPointer(1))
	}

	key2 := node.GetInternalKey(2)
	expectedKey2 := MakeCompositeKey("garage-2", "XYZ0000")
	if !bytes.Equal(key2, expectedKey2) {
		t.Errorf("Key 2 mismatch: got %s, want %s", key2, expectedKey2)
	}

	if node.GetPointer(2) != 300 {
		t.Errorf("Pointer 2: got %d, want 300", node.GetPointer(2))
	}
}

func TestBNodeBytesUsed(t *testing.T) {
	// Teste com nó folha
	page := &Page{}
	node := NewBNode(page)
	node.SetHeader(NodeTypeLeaf, 0, 0)

	node.SetLeafKV(0, []byte("key1"), []byte("value1"))
	node.SetLeafKV(1, []byte("key2"), []byte("value2"))
	node.SetNKeys(2)

	bytesUsed := node.BytesUsed()

	// Header (12) + entry1 (2+4+2+6=14) + entry2 (2+4+2+6=14) = 40 bytes
	expectedBytes := uint16(12 + 14 + 14)
	if bytesUsed != expectedBytes {
		t.Errorf("BytesUsed: got %d, want %d", bytesUsed, expectedBytes)
	}
}

func TestBNodeIsFull(t *testing.T) {
	page := &Page{}
	node := NewBNode(page)
	node.SetHeader(NodeTypeLeaf, 0, 0)

	// Nó vazio não deve estar cheio
	if node.IsFull() {
		t.Error("Empty node should not be full")
	}

	// Adicionar dados até ficar cheio (> 75% de 4096 = 3072 bytes)
	largeValue := make([]byte, 500)
	for i := 0; i < 6; i++ {
		key := MakeCompositeKey("garage-1", "PLATE000")
		node.SetLeafKV(uint16(i), key, largeValue)
	}
	node.SetNKeys(6)

	// Agora deve estar cheio
	if !node.IsFull() {
		t.Errorf("Node with %d bytes should be full", node.BytesUsed())
	}
}
