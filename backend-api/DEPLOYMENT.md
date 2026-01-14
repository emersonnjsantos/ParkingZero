# Motor de Dados B+Tree - Guia de Deployment

## 🔧 Pré-requisitos

### 1. Gerar Código Protobuf

Como o `protoc` não está instalado no Windows, você precisará gerar o código Go a partir dos protos:

**Opção A: Instalar protoc no Windows**
```powershell
# Via Chocolatey
choco install protoc

# Via Scoop
scoop install protobuf

# Ou baixar binário: https://github.com/protocolbuffers/protobuf/releases
```

**Opção B: Gerar em container Linux**
```bash
docker run --rm -v ${PWD}:/workspace -w /workspace namely/protoc-all:1.51_1 \
  -f protos/parking_service.proto \
  -l go \
  -o pkg
```

**Após instalação, executar:**
```bash
cd d:\ParkingZero
protoc --go_out=./pkg --go-grpc_out=./pkg \
  --go_opt=paths=source_relative \
  --go-grpc_opt=paths=source_relative \
  protos/parking_service.proto
```

### 2. Atualizar go.mod

Certifique-se de que o módulo de database está importável:

```bash
cd d:\ParkingZero\backend-api
go mod tidy
```

---

## 🚀 Como Executar Localmente

### 1. Executar Backend

```bash
cd d:\ParkingZero\backend-api

# Definir variáveis de ambiente
$env:GOOGLE_CLOUD_PROJECT="seu-projeto-id"
$env:LOCAL_DB_PATH="./parkingzero.db"
$env:PORT="8080"

# Rodar servidor
go run main.go
```

**Saída esperada:**
```
📂 Abrindo banco local: ./parkingzero.db
✅ Banco local aberto - 1 páginas, root=0
🔄 Sync Worker iniciado - sincronizando B+Tree → Firestore
🚀 Servidor gRPC rodando em [::]:8080
📊 Serviços disponíveis:
   - ParkingService (Firestore)
   - VehicleService (B+Tree Local)
   - Sync Worker (Background)
```

### 2. Testar Entrada de Veículo

Usando `grpcurl` (ou BloomRPC/Postman):

```bash
# Instalar grpcurl
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# Testar RPC (após protoc gerar código)
grpcurl -plaintext -d '{
  "garage_id": "garage-123",
  "vehicle_plate": "ABC1234",
  "entry_time": 1705234567
}' localhost:8080 parking.ParkingService/RecordVehicleEntry
```

**Resposta esperada:**
```json
{
  "entry_id": "garage-123|ABC1234",
  "success": true,
  "message": "Entrada registrada com sucesso",
  "entry_time": 1705234567
}
```

---

## 📦 Deployment para Cloud Run

### 1. Criar Volume Persistente

O banco `.db` precisa persistir entre restarts. Configurar volume:

```yaml
# cloudbuild.yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'gcr.io/$PROJECT_ID/parkingzero-backend', '.']
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'gcr.io/$PROJECT_ID/parkingzero-backend']
  - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    entrypoint: gcloud
    args:
      - 'run'
      - 'deploy'
      - 'parkingzero-backend'
      - '--image=gcr.io/$PROJECT_ID/parkingzero-backend'
      - '--region=southamerica-east1'
      - '--platform=managed'
      - '--allow-unauthenticated'
      - '--set-env-vars=LOCAL_DB_PATH=/data/parkingzero.db'
      - '--execution-environment=gen2'  # Necessário para volumes
      - 'volume=name=parking-data,type=cloud-storage,bucket=parkingzero-db-backup'
      - '--volume-mount=name=parking-data,mount-path=/data'
```

### 2. Build e Deploy

```bash
# Build
gcloud builds submit --tag gcr.io/seu-projeto/parkingzero-backend

# Deploy
gcloud run deploy parkingzero-backend \
  --image gcr.io/seu-projeto/parkingzero-backend \
  --region southamerica-east1 \
  --platform managed \
  --allow-unauthenticated \
  --set-env-vars LOCAL_DB_PATH=/data/parkingzero.db \
  --execution-environment gen2
```

---

## 🔍 Verificação e Monitoramento

### 1. Verificar Banco Local

```bash
# Estatísticas do banco
curl -X POST http://localhost:8080/admin/db-stats

# Listar veículos ativos (quando implementado)
grpcurl -plaintext -d '{"garage_id": "garage-123"}' \
  localhost:8080 parking.ParkingService/GetActiveVehicles
```

### 2. Monitorar Sincronização

```bash
# Ver logs do Sync Worker
docker logs -f parkingzero-backend 2>&1 | grep "Sync"

# Verificar Firestore Console
# https://console.firebase.google.com/project/seu-projeto/firestore/data/vehicle_entries
```

### 3. Verificar Meta Page

```go
// Código de debug (adicionar endpoint temporário)
meta, _ := localDB.GetMetaPage()
fmt.Printf("LastSyncedID: %d (%s)\n", 
  meta.LastSyncedID, 
  time.Unix(int64(meta.LastSyncedID), 0))
```

---

## ⚠️ Tarefas Pendentes (TODOs)

1. **Protoc Generation**: Gerar código `vehicle_service.pb.go` e `vehicle_service_grpc.pb.go`
2. **Registrar VehicleService**: Descomentar linha em `main.go` após protoc
3. **Scan com Prefixo**: Implementar na B+Tree para `GetActiveVehicles` eficiente
4. **Retry Logic**: Implementar backoff exponencial no Sync Worker
5. **Metrics**: Adicionar Prometheus/OpenTelemetry para monitoramento
6. **Testes de Integração**: Testar fluxo completo Entry → Exit → Firestore

---

## 🎯 Próximos Passos Sugeridos

1. Gerar protos: `protoc ...`
2. Testar localmente: `go run main.go`
3. Fazer uma entrada de teste via grpcurl
4. Verificar no Firestore Console que dado apareceu (após ~5s)
5. Testar saída e verificar cálculo de valor
6. Deploy para Cloud Run com volume persistente

---

## 📚 Arquivos Modificados/Criados

- ✅ `d:\ParkingZero\backend-api\internal\database\*.go` (Pager, BNode, BTree, Database)
- ✅ `d:\ParkingZero\protos\parking_service.proto` (VehicleEntry/Exit messages)
- ✅ `d:\ParkingZero\backend-api\internal\service\vehicle.go` (Service layer)
- ✅ `d:\ParkingZero\backend-api\internal\service\sync_worker.go` (Background sync)
- ✅ `d:\ParkingZero\backend-api\main.go` (Inicialização integrada)
