package database

import (
	"sync"
)

// DB é a interface de alto nível para o banco de dados B+Tree
type DB struct {
	pager *Pager
	tree  *BTree
	mu    sync.RWMutex // Controle de concorrência para operações do banco
}

// Open abre ou cria um banco de dados no caminho especificado
func Open(path string) (*DB, error) {
	pager, err := OpenPager(path)
	if err != nil {
		return nil, err
	}

	tree := NewBTree(pager)

	return &DB{
		pager: pager,
		tree:  tree,
	}, nil
}

// Put insere ou atualiza um par chave-valor
// Para o ParkingZero: key = MakeCompositeKey(garageID, plate), value = proto.Marshal(entry)
func (db *DB) Put(key, value []byte) error {
	db.mu.Lock()
	defer db.mu.Unlock()

	// Por enquanto, apenas insere (não atualiza)
	// TODO: Implementar update se chave já existe
	return db.tree.Insert(key, value)
}

// Get busca um valor pela chave
func (db *DB) Get(key []byte) ([]byte, bool) {
	db.mu.RLock()
	defer db.mu.RUnlock()

	return db.tree.Search(key)
}

// Delete remove uma chave do banco
func (db *DB) Delete(key []byte) error {
	db.mu.Lock()
	defer db.mu.Unlock()

	return db.tree.Delete(key)
}

// GetMetaPage retorna a meta page (útil para sincronização)
func (db *DB) GetMetaPage() (*MetaPage, error) {
	return db.pager.GetMetaPage()
}

// UpdateMetaPage atualiza a meta page (para LastSyncedID)
func (db *DB) UpdateMetaPage(meta *MetaPage) error {
	return db.pager.UpdateMetaPage(meta)
}

// Close fecha o banco de dados e libera recursos
func (db *DB) Close() error {
	db.mu.Lock()
	defer db.mu.Unlock()

	return db.pager.Close()
}

// Stats retorna estatísticas do banco
type DBStats struct {
	TotalPages   uint64
	RootPageID   uint64
	LastSyncedID uint64
}

// GetStats retorna estatísticas do banco de dados
func (db *DB) GetStats() (*DBStats, error) {
	meta, err := db.pager.GetMetaPage()
	if err != nil {
		return nil, err
	}

	return &DBStats{
		TotalPages:   meta.TotalPages,
		RootPageID:   meta.RootPageID,
		LastSyncedID: meta.LastSyncedID,
	}, nil
}
