package database

import (
	"bytes"
	"errors"
	"sync"
)

var (
	ErrKeyNotFound  = errors.New("key not found")
	ErrDuplicateKey = errors.New("duplicate key")
)

// BTree representa a estrutura da B+Tree
type BTree struct {
	pager *Pager
	mu    sync.RWMutex
}

// NewBTree cria uma nova B+Tree
func NewBTree(pager *Pager) *BTree {
	return &BTree{
		pager: pager,
	}
}

// Insert insere um par chave-valor na árvore
func (tree *BTree) Insert(key, value []byte) error {
	tree.mu.Lock()
	defer tree.mu.Unlock()

	meta, err := tree.pager.GetMetaPage()
	if err != nil {
		return err
	}

	// Caso 1: Árvore vazia, criar primeira folha
	if meta.RootPageID == 0 {
		return tree.createFirstLeaf(key, value)
	}

	// Caso 2: Árvore existente, buscar folha apropriada
	leafPageID, err := tree.findLeafForKey(meta.RootPageID, key)
	if err != nil {
		return err
	}

	// Carregar folha
	leafPage, err := tree.pager.ReadPage(leafPageID)
	if err != nil {
		return err
	}

	leafNode := NewBNode(leafPage)

	// Verificar se chave já existe
	if tree.keyExistsInNode(leafNode, key) {
		return ErrDuplicateKey
	}

	// Verificar se há espaço na folha
	if !leafNode.IsFull() {
		// Inserir diretamente
		return tree.insertIntoLeaf(leafPageID, leafNode, key, value)
	}

	// Nó cheio: precisamos fazer split
	return tree.splitAndInsert(leafPageID, leafNode, key, value)
}

// Search busca uma chave na árvore
func (tree *BTree) Search(key []byte) ([]byte, bool) {
	tree.mu.RLock()
	defer tree.mu.RUnlock()

	meta, err := tree.pager.GetMetaPage()
	if err != nil || meta.RootPageID == 0 {
		return nil, false
	}

	// Encontrar folha que contém a chave
	leafPageID, err := tree.findLeafForKey(meta.RootPageID, key)
	if err != nil {
		return nil, false
	}

	// Carregar folha e buscar chave
	leafPage, err := tree.pager.ReadPage(leafPageID)
	if err != nil {
		return nil, false
	}

	leafNode := NewBNode(leafPage)
	return tree.searchInLeaf(leafNode, key)
}

// Delete remove uma chave da árvore (implementação simplificada)
func (tree *BTree) Delete(key []byte) error {
	tree.mu.Lock()
	defer tree.mu.Unlock()

	meta, err := tree.pager.GetMetaPage()
	if err != nil || meta.RootPageID == 0 {
		return ErrKeyNotFound
	}

	// Encontrar folha
	leafPageID, err := tree.findLeafForKey(meta.RootPageID, key)
	if err != nil {
		return err
	}

	leafPage, err := tree.pager.ReadPage(leafPageID)
	if err != nil {
		return err
	}

	leafNode := NewBNode(leafPage)

	// Remover chave (compactar nó)
	return tree.deleteFromLeaf(leafPageID, leafNode, key)
}

// ===== MÉTODOS INTERNOS =====

// createFirstLeaf cria a primeira folha da árvore
func (tree *BTree) createFirstLeaf(key, value []byte) error {
	// Alocar nova página para a raiz
	rootPageID, err := tree.pager.AllocatePage()
	if err != nil {
		return err
	}

	// Criar nó folha
	rootPage, err := tree.pager.ReadPage(rootPageID)
	if err != nil {
		return err
	}

	rootNode := NewBNode(rootPage)
	rootNode.SetHeader(NodeTypeLeaf, 0, 0) // Sem pai
	rootNode.SetLeafKV(0, key, value)
	rootNode.SetNKeys(1)

	// Escrever de volta
	if err := tree.pager.WritePage(rootPageID, rootPage); err != nil {
		return err
	}

	// Atualizar meta page com nova raiz
	meta, _ := tree.pager.GetMetaPage()
	meta.RootPageID = rootPageID
	return tree.pager.UpdateMetaPage(meta)
}

// findLeafForKey navega pela árvore para encontrar a folha onde a chave deveria estar
func (tree *BTree) findLeafForKey(nodePageID uint64, key []byte) (uint64, error) {
	nodePage, err := tree.pager.ReadPage(nodePageID)
	if err != nil {
		return 0, err
	}

	node := NewBNode(nodePage)

	// Se for folha, retornar ID desta página
	if node.NodeType() == NodeTypeLeaf {
		return nodePageID, nil
	}

	// Nó interno: buscar ponteiro apropriado
	nkeys := node.NKeys()

	// Busca binária para encontrar posição
	idx := uint16(0)
	for i := uint16(1); i <= nkeys; i++ {
		nodeKey := node.GetInternalKey(i)
		if bytes.Compare(key, nodeKey) < 0 {
			break
		}
		idx = i
	}

	// Seguir ponteiro
	childPageID := node.GetPointer(idx)
	return tree.findLeafForKey(childPageID, key)
}

// keyExistsInNode verifica se a chave já existe em um nó folha
func (tree *BTree) keyExistsInNode(node *BNode, key []byte) bool {
	nkeys := node.NKeys()
	for i := uint16(0); i < nkeys; i++ {
		nodeKey := node.GetLeafKey(i)
		if bytes.Equal(nodeKey, key) {
			return true
		}
	}
	return false
}

// searchInLeaf busca uma chave em um nó folha
func (tree *BTree) searchInLeaf(node *BNode, key []byte) ([]byte, bool) {
	nkeys := node.NKeys()
	for i := uint16(0); i < nkeys; i++ {
		nodeKey := node.GetLeafKey(i)
		if bytes.Equal(nodeKey, key) {
			return node.GetLeafValue(i), true
		}
	}
	return nil, false
}

// insertIntoLeaf insere chave-valor em uma folha com espaço
func (tree *BTree) insertIntoLeaf(pageID uint64, node *BNode, key, value []byte) error {
	nkeys := node.NKeys()

	// Encontrar posição de inserção (manter ordenado)
	insertPos := nkeys
	for i := uint16(0); i < nkeys; i++ {
		nodeKey := node.GetLeafKey(i)
		if bytes.Compare(key, nodeKey) < 0 {
			insertPos = i
			break
		}
	}

	// Mover elementos para dar espaço
	if insertPos < nkeys {
		// Precisamos reescrever o nó com os dados reorganizados
		// Por simplicidade, vamos copiar para novo layout
		tempKeys := make([][]byte, nkeys+1)
		tempValues := make([][]byte, nkeys+1)

		for i := uint16(0); i < insertPos; i++ {
			tempKeys[i] = node.GetLeafKey(i)
			tempValues[i] = node.GetLeafValue(i)
		}

		tempKeys[insertPos] = key
		tempValues[insertPos] = value

		for i := insertPos; i < nkeys; i++ {
			tempKeys[i+1] = node.GetLeafKey(i)
			tempValues[i+1] = node.GetLeafValue(i)
		}

		// Reescrever nó
		for i := uint16(0); i <= nkeys; i++ {
			node.SetLeafKV(i, tempKeys[i], tempValues[i])
		}
	} else {
		// Inserir no final
		node.SetLeafKV(nkeys, key, value)
	}

	node.SetNKeys(nkeys + 1)

	// Persistir
	page := (*Page)(node.data)
	return tree.pager.WritePage(pageID, page)
}

// splitAndInsert divide um nó cheio e insere a chave
func (tree *BTree) splitAndInsert(oldPageID uint64, oldNode *BNode, key, value []byte) error {
	// Alocar nova página para o split
	newPageID, err := tree.pager.AllocatePage()
	if err != nil {
		return err
	}

	newPage, err := tree.pager.ReadPage(newPageID)
	if err != nil {
		return err
	}
	newNode := NewBNode(newPage)
	newNode.SetHeader(NodeTypeLeaf, 0, oldNode.Parent())

	// Coletar todas as chaves antigas primeiro
	nkeys := oldNode.NKeys()
	allKeys := make([][]byte, nkeys+1)
	allValues := make([][]byte, nkeys+1)

	// Copiar chaves existentes
	for i := uint16(0); i < nkeys; i++ {
		allKeys[i] = oldNode.GetLeafKey(i)
		allValues[i] = oldNode.GetLeafValue(i)
	}

	// Encontrar posição de inserção (manter ordenação)
	insertPos := nkeys
	for i := uint16(0); i < nkeys; i++ {
		if bytes.Compare(key, allKeys[i]) < 0 {
			insertPos = i
			break
		}
	}

	// Fazer shift se necessário e inserir nova chave
	if insertPos < nkeys {
		// Shift elementos para a direita
		for i := nkeys; i > insertPos; i-- {
			allKeys[i] = allKeys[i-1]
			allValues[i] = allValues[i-1]
		}
	}
	allKeys[insertPos] = key
	allValues[insertPos] = value

	// Dividir ao meio
	mid := (nkeys + 1) / 2

	// Primeira metade fica no nó antigo
	for i := uint16(0); i < mid; i++ {
		oldNode.SetLeafKV(i, allKeys[i], allValues[i])
	}
	oldNode.SetNKeys(mid)

	// Segunda metade vai para novo nó
	for i := mid; i < nkeys+1; i++ {
		newNode.SetLeafKV(i-mid, allKeys[i], allValues[i])
	}
	newNode.SetNKeys(nkeys + 1 - mid)

	// Persistir ambos os nós
	oldPage := (*Page)(oldNode.data)
	if err := tree.pager.WritePage(oldPageID, oldPage); err != nil {
		return err
	}
	if err := tree.pager.WritePage(newPageID, newPage); err != nil {
		return err
	}

	// Promover chave do meio para o pai (ou criar novo pai se for raiz)
	promotedKey := allKeys[mid]

	// Por simplicidade inicial, se o nó não tem pai, criar nova raiz
	if oldNode.Parent() == 0 {
		return tree.createNewRoot(oldPageID, newPageID, promotedKey)
	}

	// TODO: Implementar inserção no pai para árvores com múltiplos níveis
	return errors.New("multi-level tree insert not yet implemented")
}

// createNewRoot cria uma nova raiz quando a raiz anterior foi dividida
func (tree *BTree) createNewRoot(leftPageID, rightPageID uint64, splitKey []byte) error {
	// Alocar página para nova raiz
	newRootPageID, err := tree.pager.AllocatePage()
	if err != nil {
		return err
	}

	newRootPage, err := tree.pager.ReadPage(newRootPageID)
	if err != nil {
		return err
	}

	newRootNode := NewBNode(newRootPage)
	newRootNode.SetHeader(NodeTypeInternal, 1, 0) // 1 chave, sem pai

	// Layout: [ptr_left][key][ptr_right]
	newRootNode.SetPointer(0, leftPageID)
	newRootNode.SetInternalKey(1, splitKey)
	newRootNode.SetPointer(1, rightPageID)

	// Persistir nova raiz
	if err := tree.pager.WritePage(newRootPageID, newRootPage); err != nil {
		return err
	}

	// Atualizar filhos para apontar para novo pai
	for _, childID := range []uint64{leftPageID, rightPageID} {
		childPage, _ := tree.pager.ReadPage(childID)
		childNode := NewBNode(childPage)
		childNode.SetParent(newRootPageID)
		tree.pager.WritePage(childID, childPage)
	}

	// Atualizar meta page
	meta, _ := tree.pager.GetMetaPage()
	meta.RootPageID = newRootPageID
	return tree.pager.UpdateMetaPage(meta)
}

// deleteFromLeaf remove uma chave de um nó folha (compactando)
func (tree *BTree) deleteFromLeaf(pageID uint64, node *BNode, key []byte) error {
	nkeys := node.NKeys()
	found := false
	deletePos := uint16(0)

	// Encontrar posição da chave
	for i := uint16(0); i < nkeys; i++ {
		if bytes.Equal(node.GetLeafKey(i), key) {
			found = true
			deletePos = i
			break
		}
	}

	if !found {
		return ErrKeyNotFound
	}

	// Compactar (mover elementos)
	tempKeys := make([][]byte, 0, nkeys-1)
	tempValues := make([][]byte, 0, nkeys-1)

	for i := uint16(0); i < nkeys; i++ {
		if i != deletePos {
			tempKeys = append(tempKeys, node.GetLeafKey(i))
			tempValues = append(tempValues, node.GetLeafValue(i))
		}
	}

	// Reescrever nó
	for i := uint16(0); i < nkeys-1; i++ {
		node.SetLeafKV(i, tempKeys[i], tempValues[i])
	}
	node.SetNKeys(nkeys - 1)

	// Persistir
	page := (*Page)(node.data)
	return tree.pager.WritePage(pageID, page)
}
