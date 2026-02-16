package database

import (
	"bytes"
	"encoding/binary"
)

// Constantes de tipo de nó
const (
	NodeTypeInternal = 1 // Nó interno (apenas ponteiros)
	NodeTypeLeaf     = 2 // Nó folha (chave + valor)
)

// Layout de um nó:
// Header (12 bytes):
//   - Type: 1 byte (Internal ou Leaf)
//   - Reserved: 1 byte (padding para alinhamento)
//   - NKeys: 2 bytes (número de chaves)
//   - Parent: 8 bytes (ponteiro para página pai)
//
// Body (depende do tipo):
//   Internal: [pointer_0][key_1][pointer_1][key_2][pointer_2]...
//   Leaf: [key_1][size_1][value_1][key_2][size_2][value_2]...

const (
	HeaderSize = 12
	// Tamanho máximo da chave composta: garage_id (36) + separator (1) + plate (20) = 57 bytes
	// Arredondando para 64 para alinhamento
	MaxKeySize = 64
)

// BNode representa um nó da B+Tree dentro de uma página
type BNode struct {
	data []byte // Referência direta para a página de 4KB
}

// NewBNode cria um novo nó a partir de uma página
func NewBNode(page *Page) *BNode {
	return &BNode{data: page[:]}
}

// ===== HEADER METHODS =====

// NodeType retorna o tipo do nó (Internal ou Leaf)
func (node *BNode) NodeType() uint16 {
	return uint16(node.data[0])
}

// SetNodeType define o tipo do nó
func (node *BNode) SetNodeType(nodeType uint16) {
	node.data[0] = byte(nodeType)
}

// NKeys retorna o número de chaves no nó
func (node *BNode) NKeys() uint16 {
	return binary.LittleEndian.Uint16(node.data[2:4])
}

// SetNKeys define o número de chaves
func (node *BNode) SetNKeys(n uint16) {
	binary.LittleEndian.PutUint16(node.data[2:4], n)
}

// Parent retorna o ponteiro para a página pai
func (node *BNode) Parent() uint64 {
	return binary.LittleEndian.Uint64(node.data[4:12])
}

// SetParent define o ponteiro para a página pai
func (node *BNode) SetParent(parent uint64) {
	binary.LittleEndian.PutUint64(node.data[4:12], parent)
}

// SetHeader define cabeçalho completo do nó
func (node *BNode) SetHeader(nodeType uint16, nkeys uint16, parent uint64) {
	node.SetNodeType(nodeType)
	node.SetNKeys(nkeys)
	node.SetParent(parent)
}

// ===== INTERNAL NODE METHODS =====
// Layout: [ptr_0][key_1][ptr_1][key_2][ptr_2]...

// GetPointer retorna o ponteiro na posição idx (para nós internos)
func (node *BNode) GetPointer(idx uint16) uint64 {
	if node.NodeType() != NodeTypeInternal {
		panic("GetPointer called on non-internal node")
	}

	// Cada entrada em nó interno: 8 bytes (pointer) + MaxKeySize bytes (key)
	offset := HeaderSize + uint16(idx)*(8+MaxKeySize)
	return binary.LittleEndian.Uint64(node.data[offset : offset+8])
}

// SetPointer define o ponteiro na posição idx
func (node *BNode) SetPointer(idx uint16, ptr uint64) {
	if node.NodeType() != NodeTypeInternal {
		panic("SetPointer called on non-internal node")
	}

	offset := HeaderSize + uint16(idx)*(8+MaxKeySize)
	binary.LittleEndian.PutUint64(node.data[offset:offset+8], ptr)
}

// GetInternalKey retorna a chave na posição idx (para nós internos)
// Nota: índice 0 não tem chave (apenas ponteiro), chaves começam em idx=1
func (node *BNode) GetInternalKey(idx uint16) []byte {
	if node.NodeType() != NodeTypeInternal {
		panic("GetInternalKey called on non-internal node")
	}
	if idx == 0 {
		panic("internal node has no key at index 0")
	}

	// Offset: header + (idx-1) * entry_size + 8 (skip pointer_0) + idx * key_size
	offset := HeaderSize + 8 + (uint16(idx)-1)*(8+MaxKeySize)
	keyData := node.data[offset : offset+MaxKeySize]

	// Encontrar terminador nulo para obter tamanho real da chave
	nullPos := bytes.IndexByte(keyData, 0)
	if nullPos == -1 {
		return keyData
	}
	return keyData[:nullPos]
}

// SetInternalKey define a chave na posição idx
func (node *BNode) SetInternalKey(idx uint16, key []byte) {
	if node.NodeType() != NodeTypeInternal {
		panic("SetInternalKey called on non-internal node")
	}
	if idx == 0 {
		panic("cannot set key at index 0 in internal node")
	}
	if len(key) > MaxKeySize {
		panic("key too large")
	}

	offset := HeaderSize + 8 + (uint16(idx)-1)*(8+MaxKeySize)

	// Limpar área da chave e copiar
	for i := 0; i < MaxKeySize; i++ {
		node.data[offset+uint16(i)] = 0
	}
	copy(node.data[offset:], key)
}

// ===== LEAF NODE METHODS =====
// Layout: [key_size_1][key_1][val_size_1][value_1][key_size_2]...

// GetLeafKey retorna a chave na posição idx (para nós folha)
func (node *BNode) GetLeafKey(idx uint16) []byte {
	if node.NodeType() != NodeTypeLeaf {
		panic("GetLeafKey called on non-leaf node")
	}

	offset := node.getLeafOffset(idx)
	keySize := binary.LittleEndian.Uint16(node.data[offset : offset+2])
	return node.data[offset+2 : offset+2+uint16(keySize)]
}

// GetLeafValue retorna o valor na posição idx (para nós folha)
func (node *BNode) GetLeafValue(idx uint16) []byte {
	if node.NodeType() != NodeTypeLeaf {
		panic("GetLeafValue called on non-leaf node")
	}

	offset := node.getLeafOffset(idx)
	keySize := binary.LittleEndian.Uint16(node.data[offset : offset+2])

	// Avançar para onde está o valor
	valueOffset := offset + 2 + uint16(keySize)
	valueSize := binary.LittleEndian.Uint16(node.data[valueOffset : valueOffset+2])

	return node.data[valueOffset+2 : valueOffset+2+uint16(valueSize)]
}

// SetLeafKV define um par chave-valor na posição idx (para nós folha)
func (node *BNode) SetLeafKV(idx uint16, key []byte, value []byte) {
	if node.NodeType() != NodeTypeLeaf {
		panic("SetLeafKV called on non-leaf node")
	}

	offset := node.getLeafOffset(idx)

	// Escrever: [key_size][key][val_size][value]
	binary.LittleEndian.PutUint16(node.data[offset:offset+2], uint16(len(key)))
	copy(node.data[offset+2:], key)

	valueOffset := offset + 2 + uint16(len(key))
	binary.LittleEndian.PutUint16(node.data[valueOffset:valueOffset+2], uint16(len(value)))
	copy(node.data[valueOffset+2:], value)
}

// getLeafOffset calcula o offset do elemento idx em um nó folha
func (node *BNode) getLeafOffset(idx uint16) uint16 {
	if idx == 0 {
		return HeaderSize
	}

	// Percorrer elementos anteriores para calcular offset
	offset := uint16(HeaderSize)
	for i := uint16(0); i < idx; i++ {
		keySize := binary.LittleEndian.Uint16(node.data[offset : offset+2])
		offset += 2 + keySize // key_size + key

		valueSize := binary.LittleEndian.Uint16(node.data[offset : offset+2])
		offset += 2 + valueSize // val_size + value
	}

	return offset
}

// ===== UTILITY METHODS =====

// BytesUsed retorna quantos bytes estão em uso neste nó
func (node *BNode) BytesUsed() uint16 {
	if node.NodeType() == NodeTypeInternal {
		// Header + (n_keys + 1) pointers + (n_keys) keys
		nkeys := node.NKeys()
		return HeaderSize + (nkeys+1)*8 + nkeys*MaxKeySize
	} else {
		// Leaf: calcular tamanho real percorrendo elementos
		return node.getLeafOffset(node.NKeys())
	}
}

// IsFull verifica se o nó está cheio (> 75% da capacidade)
func (node *BNode) IsFull() bool {
	return node.BytesUsed() > (PageSize * 3 / 4)
}

// MakeCompositeKey cria chave composta: garage_id + "|" + vehicle_plate
func MakeCompositeKey(garageID, vehiclePlate string) []byte {
	key := garageID + "|" + vehiclePlate
	return []byte(key)
}

// SplitCompositeKey decompõe a chave composta
func SplitCompositeKey(key []byte) (garageID string, vehiclePlate string) {
	parts := bytes.Split(key, []byte("|"))
	if len(parts) != 2 {
		return "", ""
	}
	return string(parts[0]), string(parts[1])
}
