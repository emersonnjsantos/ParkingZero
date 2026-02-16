package database

import (
	"os"
	"path/filepath"
	"testing"
)

func TestPagerCreateAndOpen(t *testing.T) {
	// Criar diretório temporário para testes
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "test.db")

	// Criar novo pager
	pager, err := OpenPager(dbPath)
	if err != nil {
		t.Fatalf("Failed to create pager: %v", err)
	}
	defer pager.Close()

	// Verificar se arquivo foi criado
	if _, err := os.Stat(dbPath); os.IsNotExist(err) {
		t.Fatal("Database file was not created")
	}

	// Verificar meta page
	meta, err := pager.GetMetaPage()
	if err != nil {
		t.Fatalf("Failed to get meta page: %v", err)
	}

	if meta.MagicNumber != MagicNumber {
		t.Errorf("Invalid magic number: got %x, want %x", meta.MagicNumber, MagicNumber)
	}

	if meta.TotalPages != 1 {
		t.Errorf("Expected 1 page initially, got %d", meta.TotalPages)
	}
}

func TestPagerReadWritePage(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "test.db")

	pager, err := OpenPager(dbPath)
	if err != nil {
		t.Fatalf("Failed to create pager: %v", err)
	}
	defer pager.Close()

	// Alocar nova página
	pageID, err := pager.AllocatePage()
	if err != nil {
		t.Fatalf("Failed to allocate page: %v", err)
	}

	// Preparar dados de teste
	testData := &Page{}
	copy(testData[:], []byte("ParkingZero Test Data - Esta página contém dados de teste"))

	// Escrever página
	if err := pager.WritePage(pageID, testData); err != nil {
		t.Fatalf("Failed to write page: %v", err)
	}

	// Ler página
	readPage, err := pager.ReadPage(pageID)
	if err != nil {
		t.Fatalf("Failed to read page: %v", err)
	}

	// Verificar se dados foram persistidos corretamente
	if string(readPage[:58]) != string(testData[:58]) {
		t.Errorf("Data mismatch:\ngot:  %s\nwant: %s", readPage[:58], testData[:58])
	}
}

func TestPagerPersistence(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "test.db")

	// Fase 1: Criar e escrever dados
	func() {
		pager, err := OpenPager(dbPath)
		if err != nil {
			t.Fatalf("Failed to create pager: %v", err)
		}

		pageID, err := pager.AllocatePage()
		if err != nil {
			t.Fatalf("Failed to allocate page: %v", err)
		}

		testData := &Page{}
		copy(testData[:], []byte("Persistent Data Test"))

		if err := pager.WritePage(pageID, testData); err != nil {
			t.Fatalf("Failed to write page: %v", err)
		}

		// Fechar pager (simula restart do servidor)
		if err := pager.Close(); err != nil {
			t.Fatalf("Failed to close pager: %v", err)
		}
	}()

	// Fase 2: Reabrir e verificar se dados persistiram
	pager, err := OpenPager(dbPath)
	if err != nil {
		t.Fatalf("Failed to reopen pager: %v", err)
	}
	defer pager.Close()

	// Verificar meta page
	meta, err := pager.GetMetaPage()
	if err != nil {
		t.Fatalf("Failed to get meta page: %v", err)
	}

	if meta.TotalPages != 2 {
		t.Errorf("Expected 2 pages after reopen, got %d", meta.TotalPages)
	}

	// Ler dados da página 1 (página 0 é meta)
	readPage, err := pager.ReadPage(1)
	if err != nil {
		t.Fatalf("Failed to read page after reopen: %v", err)
	}

	expected := "Persistent Data Test"
	if string(readPage[:len(expected)]) != expected {
		t.Errorf("Data not persisted correctly:\ngot:  %s\nwant: %s",
			readPage[:len(expected)], expected)
	}
}

func TestPagerFsyncGuarantee(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "test.db")

	pager, err := OpenPager(dbPath)
	if err != nil {
		t.Fatalf("Failed to create pager: %v", err)
	}

	pageID, err := pager.AllocatePage()
	if err != nil {
		t.Fatalf("Failed to allocate page: %v", err)
	}

	testData := &Page{}
	copy(testData[:], []byte("Critical Entry Data - Must Survive Crash"))

	// Escrever (com fsync automático)
	if err := pager.WritePage(pageID, testData); err != nil {
		t.Fatalf("Failed to write page: %v", err)
	}

	// Simular crash (fechar sem Close() graceful)
	// Em produção, o fsync garante que os dados já estão no disco
	pager.file.Close()

	// Reabrir para verificar integridade
	pager2, err := OpenPager(dbPath)
	if err != nil {
		t.Fatalf("Failed to reopen after simulated crash: %v", err)
	}
	defer pager2.Close()

	readPage, err := pager2.ReadPage(pageID)
	if err != nil {
		t.Fatalf("Failed to read page after crash: %v", err)
	}

	expected := "Critical Entry Data - Must Survive Crash"
	if string(readPage[:len(expected)]) != expected {
		t.Error("Data was not persisted with fsync - data loss detected!")
	}
}

func TestPagerMetaPageUpdate(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "test.db")

	pager, err := OpenPager(dbPath)
	if err != nil {
		t.Fatalf("Failed to create pager: %v", err)
	}
	defer pager.Close()

	// Atualizar LastSyncedID (simulando sincronização com Firestore)
	meta, err := pager.GetMetaPage()
	if err != nil {
		t.Fatalf("Failed to get meta page: %v", err)
	}

	meta.LastSyncedID = 12345
	meta.RootPageID = 99

	if err := pager.UpdateMetaPage(meta); err != nil {
		t.Fatalf("Failed to update meta page: %v", err)
	}

	// Verificar se atualização foi persistida
	updatedMeta, err := pager.GetMetaPage()
	if err != nil {
		t.Fatalf("Failed to get updated meta page: %v", err)
	}

	if updatedMeta.LastSyncedID != 12345 {
		t.Errorf("LastSyncedID not updated: got %d, want 12345", updatedMeta.LastSyncedID)
	}

	if updatedMeta.RootPageID != 99 {
		t.Errorf("RootPageID not updated: got %d, want 99", updatedMeta.RootPageID)
	}
}

func TestPagerInvalidPageID(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "test.db")

	pager, err := OpenPager(dbPath)
	if err != nil {
		t.Fatalf("Failed to create pager: %v", err)
	}
	defer pager.Close()

	// Tentar ler página que não existe deve retornar erro
	_, err = pager.ReadPage(999)
	if err != ErrInvalidPageID {
		t.Errorf("Expected ErrInvalidPageID on read, got %v", err)
	}

	// Escrever em página além do limite expande o arquivo automaticamente
	// (comportamento necessário para AllocatePage funcionar)
	testPage := &Page{}
	copy(testPage[:], []byte("Auto-expand test"))

	err = pager.WritePage(5, testPage)
	if err != nil {
		t.Errorf("Auto-expand write should succeed, got error: %v", err)
	}

	// Agora deve conseguir ler a página 5
	readBack, err := pager.ReadPage(5)
	if err != nil {
		t.Errorf("Failed to read auto-expanded page: %v", err)
	}

	if string(readBack[:16]) != "Auto-expand test" {
		t.Error("Auto-expanded page data mismatch")
	}
}

func TestPagerCorruptedDatabase(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "corrupted.db")

	// Criar arquivo corrompido (magic number inválido)
	file, err := os.Create(dbPath)
	if err != nil {
		t.Fatalf("Failed to create file: %v", err)
	}

	corruptedData := make([]byte, PageSize)
	// Magic number inválido
	corruptedData[0] = 0xFF
	corruptedData[1] = 0xFF
	corruptedData[2] = 0xFF
	corruptedData[3] = 0xFF

	file.Write(corruptedData)
	file.Close()

	// Tentar abrir banco corrompido
	_, err = OpenPager(dbPath)
	if err != ErrCorruptedDB {
		t.Errorf("Expected ErrCorruptedDB, got %v", err)
	}
}
