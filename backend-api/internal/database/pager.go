package database

import (
	"encoding/binary"
	"errors"
	"os"
	"sync"
)

const (
	PageSize    = 4096
	MagicNumber = 0x504B5A00 // "PKZ\0" em hex (ParkingZero)
)

var (
	ErrInvalidPageID = errors.New("invalid page ID")
	ErrCorruptedDB   = errors.New("corrupted database file")
)

// Page representa um bloco de 4KB do banco de dados
type Page [PageSize]byte

// MetaPage armazena metadados críticos do banco (sempre na Page 0)
type MetaPage struct {
	MagicNumber  uint32 // Identificador do formato (validação)
	RootPageID   uint64 // ID da página raiz da B+Tree
	FreelistHead uint64 // Primeira página livre (linked list)
	LastSyncedID uint64 // ID da última entrada sincronizada com Firestore
	TotalPages   uint64 // Total de páginas alocadas
}

// Pager gerencia I/O do arquivo em blocos de 4KB
type Pager struct {
	file      *os.File
	pageCount uint64
	mu        sync.RWMutex // Controle de concorrência para operações de I/O
}

// OpenPager abre ou cria um arquivo de banco de dados
func OpenPager(path string) (*Pager, error) {
	// Abrir arquivo com permissões de leitura/escrita, criar se não existir
	file, err := os.OpenFile(path, os.O_RDWR|os.O_CREATE, 0644)
	if err != nil {
		return nil, err
	}

	// Obter tamanho do arquivo
	fileInfo, err := file.Stat()
	if err != nil {
		file.Close()
		return nil, err
	}

	fileSize := fileInfo.Size()
	pageCount := uint64(fileSize / PageSize)

	pager := &Pager{
		file:      file,
		pageCount: pageCount,
	}

	// Se arquivo é novo, inicializar meta page
	if fileSize == 0 {
		if err := pager.initializeMetaPage(); err != nil {
			file.Close()
			return nil, err
		}
	} else {
		// Validar meta page existente
		if err := pager.validateMetaPage(); err != nil {
			file.Close()
			return nil, err
		}
	}

	return pager, nil
}

// initializeMetaPage cria a meta page inicial (Page 0)
func (p *Pager) initializeMetaPage() error {
	meta := MetaPage{
		MagicNumber:  MagicNumber,
		RootPageID:   0, // Será definido quando criar primeira página
		FreelistHead: 0, // Nenhuma página livre inicialmente
		LastSyncedID: 0,
		TotalPages:   1, // Apenas a meta page
	}

	page := &Page{}
	p.serializeMetaPage(&meta, page)

	if err := p.writePage(0, page); err != nil {
		return err
	}

	// CRÍTICO: Garantir que a meta page tocou o disco físico
	if err := p.file.Sync(); err != nil {
		return err
	}

	p.pageCount = 1
	return nil
}

// validateMetaPage verifica se a meta page é válida
func (p *Pager) validateMetaPage() error {
	page, err := p.readPage(0)
	if err != nil {
		return err
	}

	meta := p.deserializeMetaPage(page)
	if meta.MagicNumber != MagicNumber {
		return ErrCorruptedDB
	}

	return nil
}

// ReadPage lê uma página do disco
func (p *Pager) ReadPage(pageID uint64) (*Page, error) {
	p.mu.RLock()
	defer p.mu.RUnlock()
	return p.readPage(pageID)
}

// readPage versão sem lock (para uso interno)
func (p *Pager) readPage(pageID uint64) (*Page, error) {
	if pageID >= p.pageCount {
		return nil, ErrInvalidPageID
	}

	page := &Page{}
	offset := int64(pageID * PageSize)

	n, err := p.file.ReadAt(page[:], offset)
	if err != nil {
		return nil, err
	}
	if n != PageSize {
		return nil, ErrCorruptedDB
	}

	return page, nil
}

// WritePage escreve uma página no disco
func (p *Pager) WritePage(pageID uint64, page *Page) error {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.writePage(pageID, page)
}

// writePage versão sem lock (para uso interno)
func (p *Pager) writePage(pageID uint64, page *Page) error {
	offset := int64(pageID * PageSize)
	n, err := p.file.WriteAt(page[:], offset)
	if err != nil {
		return err
	}
	if n != PageSize {
		return errors.New("incomplete page write")
	}

	// Atualizar contagem de páginas se necessário
	if pageID >= p.pageCount {
		p.pageCount = pageID + 1
	}

	// CRÍTICO: fsync para garantir durabilidade
	return p.file.Sync()
}

// AllocatePage aloca uma nova página e retorna seu ID
func (p *Pager) AllocatePage() (uint64, error) {
	p.mu.Lock()
	defer p.mu.Unlock()

	// TODO: Implementar freelist para reuso de páginas deletadas
	// Por enquanto, apenas adiciona no final do arquivo

	newPageID := p.pageCount

	// Expandir arquivo escrevendo uma página vazia
	emptyPage := &Page{}
	offset := int64(newPageID * PageSize)
	n, err := p.file.WriteAt(emptyPage[:], offset)
	if err != nil {
		return 0, err
	}
	if n != PageSize {
		return 0, errors.New("failed to allocate page")
	}

	p.pageCount++

	// Atualizar meta page com novo total de páginas
	metaPage, err := p.readPage(0)
	if err != nil {
		return 0, err
	}

	meta := p.deserializeMetaPage(metaPage)
	meta.TotalPages = p.pageCount
	p.serializeMetaPage(&meta, metaPage)

	if err := p.writePage(0, metaPage); err != nil {
		return 0, err
	}

	return newPageID, nil
}

// GetMetaPage retorna a meta page atual
func (p *Pager) GetMetaPage() (*MetaPage, error) {
	p.mu.RLock()
	defer p.mu.RUnlock()

	page, err := p.readPage(0)
	if err != nil {
		return nil, err
	}

	meta := p.deserializeMetaPage(page)
	return &meta, nil
}

// UpdateMetaPage atualiza a meta page
func (p *Pager) UpdateMetaPage(meta *MetaPage) error {
	p.mu.Lock()
	defer p.mu.Unlock()

	page := &Page{}
	p.serializeMetaPage(meta, page)
	return p.writePage(0, page)
}

// serializeMetaPage converte MetaPage para bytes
func (p *Pager) serializeMetaPage(meta *MetaPage, page *Page) {
	binary.LittleEndian.PutUint32(page[0:4], meta.MagicNumber)
	binary.LittleEndian.PutUint64(page[4:12], meta.RootPageID)
	binary.LittleEndian.PutUint64(page[12:20], meta.FreelistHead)
	binary.LittleEndian.PutUint64(page[20:28], meta.LastSyncedID)
	binary.LittleEndian.PutUint64(page[28:36], meta.TotalPages)
}

// deserializeMetaPage converte bytes para MetaPage
func (p *Pager) deserializeMetaPage(page *Page) MetaPage {
	return MetaPage{
		MagicNumber:  binary.LittleEndian.Uint32(page[0:4]),
		RootPageID:   binary.LittleEndian.Uint64(page[4:12]),
		FreelistHead: binary.LittleEndian.Uint64(page[12:20]),
		LastSyncedID: binary.LittleEndian.Uint64(page[20:28]),
		TotalPages:   binary.LittleEndian.Uint64(page[28:36]),
	}
}

// Close fecha o arquivo do banco de dados
func (p *Pager) Close() error {
	p.mu.Lock()
	defer p.mu.Unlock()

	// Força sync final antes de fechar
	if err := p.file.Sync(); err != nil {
		return err
	}

	return p.file.Close()
}

// PageCount retorna o número total de páginas
func (p *Pager) PageCount() uint64 {
	p.mu.RLock()
	defer p.mu.RUnlock()
	return p.pageCount
}
