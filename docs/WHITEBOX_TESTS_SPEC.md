# Especificação de Testes de Caixa Branca
# ParkingZero - Backend API

**Documento conforme ISO/IEC/IEEE 29119-4:2021**

| Versão | Data | Autor |
|--------|------|-------|
| 1.0 | 2026-01-30 | Equipe ParkingZero |

---

## 1. INTRODUÇÃO

### 1.1 Objetivo
Este documento especifica os testes de **Caixa Branca (White Box Testing)** para os componentes críticos do backend ParkingZero, analisando a estrutura interna do código.

### 1.2 Escopo
- **VehicleService**: Entrada/saída de veículos
- **VoucherService**: Geração e validação de vouchers JWT
- **Database (B+Tree)**: Estrutura de dados local

### 1.3 Técnicas Utilizadas

| Técnica | Descrição | Norma |
|---------|-----------|-------|
| Statement Coverage | Cobertura de todos os comandos | ISO 29119-4 §8.1 |
| Branch Coverage | Cobertura de todas as ramificações | ISO 29119-4 §8.2 |
| Path Coverage | Cobertura de todos os caminhos | ISO 29119-4 §8.3 |
| Condition Coverage | Cobertura de condições individuais | ISO 29119-4 §8.4 |
| MC/DC | Modified Condition/Decision Coverage | DO-178C |
| Data Flow | Análise de fluxo de dados | ISO 29119-4 §8.5 |

---

## 2. MATRIZ DE COBERTURA

### 2.1 VehicleService (vehicle.go)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     GRAFO DE FLUXO - RecordVehicleEntry                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                              ┌─────────┐                                    │
│                              │  START  │                                    │
│                              └────┬────┘                                    │
│                                   │                                         │
│                              ┌────▼────┐                                    │
│                         ┌────┤ L35-37  ├────┐                               │
│                         │    │garage==""│    │                               │
│                         │N   └─────────┘   Y│                               │
│                         │                   │                               │
│                    ┌────▼────┐         ┌────▼────┐                          │
│               ┌────┤ L38-40  │         │  ERROR  │                          │
│               │    │plate=="" │         │InvalidArg│                         │
│               │N   └─────────┘Y        └─────────┘                          │
│               │         │                                                   │
│          ┌────▼────┐    │                                                   │
│          │ L42-54  ◄────┼───────────────────┐                               │
│          │CreateEntry│   │                   │                               │
│          └────┬────┘    │              ┌────▼────┐                          │
│               │         └──────────────►  ERROR  │                          │
│          ┌────▼────┐                   │InvalidArg│                         │
│     ┌────┤ L57-59  ├────┐              └─────────┘                          │
│     │    │time==0  │    │                                                   │
│     │N   └─────────┘   Y│                                                   │
│     │                   │                                                   │
│     │              ┌────▼────┐                                              │
│     │              │time=Now │                                              │
│     │              └────┬────┘                                              │
│     │                   │                                                   │
│     └────────┬──────────┘                                                   │
│              │                                                              │
│         ┌────▼────┐                                                         │
│    ┌────┤ L68-74  ├────┐                                                    │
│    │    │db.Put() │    │                                                    │
│    │OK  └─────────┘  ERR                                                    │
│    │                   │                                                    │
│    │              ┌────▼────┐                                               │
│    │         ┌────┤Duplicate├────┐                                          │
│    │         │    └─────────┘    │                                          │
│    │         │Y                 N│                                          │
│    │    ┌────▼────┐         ┌────▼────┐                                     │
│    │    │AlreadyEx│         │Internal │                                     │
│    │    └─────────┘         └─────────┘                                     │
│    │                                                                        │
│    ├───────────────────────────┐                                            │
│    │                           │                                            │
│    │                      ┌────▼────┐                                       │
│    │                 ┌────┤ L77-84  ├────┐                                  │
│    │                 │    │syncQueue│    │                                  │
│    │                 │OK  └─────────┘FULL│                                  │
│    │                 │                   │                                  │
│    │            ┌────▼────┐         ┌────▼────┐                             │
│    │            │Enqueued │         │WarningLog│                            │
│    │            └────┬────┘         └────┬────┘                             │
│    │                 │                   │                                  │
│    └─────────────────┴───────────────────┘                                  │
│                      │                                                      │
│                 ┌────▼────┐                                                 │
│                 │ SUCCESS │                                                 │
│                 └─────────┘                                                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### Casos de Teste - RecordVehicleEntry

| ID | Descrição | Linha | Branch | Input | Expected | Status |
|----|-----------|-------|--------|-------|----------|--------|
| TC-WB-VEH-001-A | garage_id vazio | 35-37 | TRUE | garage="" | Error InvalidArgument | ⬜ |
| TC-WB-VEH-001-B | plate vazia | 38-40 | TRUE | plate="" | Error InvalidArgument | ⬜ |
| TC-WB-VEH-001-C | Entrada válida | 35,38 | FALSE,FALSE | Válido | Success | ⬜ |
| TC-WB-VEH-002-A | entry_time fornecido | 57 | FALSE | time=X | EntryTime=X | ⬜ |
| TC-WB-VEH-002-B | entry_time default | 57-59 | TRUE | time=0 | EntryTime≈Now | ⬜ |
| TC-WB-VEH-003-A | Chave duplicada | 70-71 | TRUE | Dup | Error AlreadyExists | ⬜ |
| TC-WB-VEH-004-A | SyncQueue ok | 78 | case | Normal | Enqueued | ⬜ |
| TC-WB-VEH-004-B | SyncQueue cheio | 80-83 | default | Full | Warning log | ⬜ |

---

#### Casos de Teste - RecordVehicleExit

| ID | Descrição | Linha | Branch | Input | Expected | Status |
|----|-----------|-------|--------|-------|----------|--------|
| TC-WB-VEH-005-A | garage_id vazio | 98-100 | TRUE | garage="" | Error | ⬜ |
| TC-WB-VEH-005-B | plate vazia | 101-103 | TRUE | plate="" | Error | ⬜ |
| TC-WB-VEH-005-C | Não encontrado | 108-110 | TRUE | NotFound | Error NotFound | ⬜ |
| TC-WB-VEH-005-D | Já saiu | 119-121 | TRUE | EXITED | Error FailedPrecond | ⬜ |
| TC-WB-VEH-005-E | exit < entry | 131-133 | TRUE | Invalid | Error InvalidArg | ⬜ |
| TC-WB-VEH-005-F | exit_time default | 125-127 | TRUE | time=0 | ExitTime≈Now | ⬜ |
| TC-WB-VEH-005-G | Saída válida | All | FALSE | Valid | Success | ⬜ |

---

### 2.2 VoucherService (voucher.go)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     GRAFO DE FLUXO - NewVoucherService                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                              ┌─────────┐                                    │
│                              │  START  │                                    │
│                              └────┬────┘                                    │
│                                   │                                         │
│                              ┌────▼────┐                                    │
│                         ┌────┤ L61     ├────┐                               │
│                         │    │priv&&pub│    │                               │
│                         │Y   └─────────┘   N│                               │
│                         │                   │                               │
│                    ┌────▼────┐         ┌────▼────┐                          │
│               ┌────┤ L63-66  │         │ L72-77  │                          │
│               │    │DecodePriv│         │Generate │                          │
│               │OK  └─────────┘ERR      └────┬────┘                          │
│               │         │                   │                               │
│          ┌────▼────┐    │              ┌────▼────┐                          │
│     ┌────┤ L67-70  │    │              │ Return  │                          │
│     │    │DecodePub│    │              │ Service │                          │
│     │OK  └─────────┘ERR │              └─────────┘                          │
│     │         │         │                                                   │
│     │         ▼         ▼                                                   │
│     │    ┌─────────────────┐                                                │
│     │    │  Error Decode   │                                                │
│     │    └─────────────────┘                                                │
│     │                                                                       │
│     └───────────────────────────────────────────────────────────────────────►
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### Casos de Teste - VoucherService

| ID | Descrição | Linha | Branch | Input | Expected | Status |
|----|-----------|-------|--------|-------|----------|--------|
| TC-WB-VOU-001-A | Chaves do ambiente | 61-70 | TRUE | Env set | Decoded keys | ⬜ |
| TC-WB-VOU-001-B | Gerar novas chaves | 71-82 | FALSE | Env empty | Generated | ⬜ |
| TC-WB-VOU-001-C | PrivKey inválida | 64-66 | ERR | Bad base64 | Error decode | ⬜ |
| TC-WB-VOU-001-D | PubKey inválida | 67-70 | ERR | Bad base64 | Error decode | ⬜ |
| TC-WB-VOU-002-A | PrivKey nil | 98-100 | TRUE | nil | Error | ⬜ |
| TC-WB-VOU-002-B | Gerar sucesso | 102-131 | OK | Valid | VoucherResult | ⬜ |
| TC-WB-VOU-003-A | PubKey nil | 137-139 | TRUE | nil | Error | ⬜ |
| TC-WB-VOU-003-B | Token inválido | 148-150 | ERR | Bad JWT | Error parse | ⬜ |
| TC-WB-VOU-003-C | Algoritmo errado | 142-144 | ERR | HS256 | Error method | ⬜ |
| TC-WB-VOU-003-D | Token válido | 152-154 | OK | Valid JWT | Claims | ⬜ |

---

## 3. MÉTRICAS DE COBERTURA

### 3.1 Cobertura de Código Alvo

| Arquivo | Linhas | Branches | Paths | Target |
|---------|--------|----------|-------|--------|
| vehicle.go | 239 | 18 | 12 | 100% |
| voucher.go | 164 | 12 | 8 | 100% |
| btree.go | 424 | 24 | 16 | 80% |
| sponsorship.go | 711 | 42 | 28 | 80% |

### 3.2 Critérios de Aceite

| Critério | Mínimo | Alvo |
|----------|--------|------|
| Statement Coverage | 80% | 95% |
| Branch Coverage | 75% | 90% |
| Path Coverage | 60% | 80% |
| MC/DC | 70% | 85% |

---

## 4. CASOS DE TESTE DETALHADOS

### 4.1 TC-WB-VEH-001: Validações de Entrada de Veículo

**Objetivo**: Verificar todas as branches de validação em RecordVehicleEntry

**Pré-condições**:
- VehicleService inicializado com banco de teste
- SyncQueue disponível

**Procedimento**:

| Passo | Ação | Dados | Resultado Esperado |
|-------|------|-------|-------------------|
| 1 | Chamar RecordVehicleEntry | garage_id="" | Error InvalidArgument "garage_id é obrigatório" |
| 2 | Chamar RecordVehicleEntry | plate="" | Error InvalidArgument "vehicle_plate é obrigatória" |
| 3 | Chamar RecordVehicleEntry | Dados válidos | Success=true, EntryId preenchido |

**Cobertura**:
- Linha 35-37: Branch TRUE (garage vazio)
- Linha 38-40: Branch TRUE (plate vazia)
- Linha 35,38: Branch FALSE,FALSE (caminho feliz)

---

### 4.2 TC-WB-VEH-002: Default de EntryTime

**Objetivo**: Verificar branch de timestamp automático

**Cenários**:

| Cenário | entry_time | Resultado |
|---------|------------|-----------|
| A | 1704067200 | EntryTime=1704067200 |
| B | 0 | EntryTime≈time.Now() |

**Cobertura**:
- Linha 57: Condição `entry.EntryTime == 0`
- Linha 58: Atribuição `entry.EntryTime = time.Now().Unix()`

---

### 4.3 TC-WB-VOU-003: Validação de Voucher

**Objetivo**: Testar todos os caminhos de validação JWT

**Matriz de Decisão**:

| PubKey | Token | Algoritmo | Válido | Resultado |
|--------|-------|-----------|--------|-----------|
| nil | - | - | - | Error "public key not initialized" |
| OK | Inválido | - | - | Error "failed to parse" |
| OK | Válido | HS256 | - | Error "unexpected signing method" |
| OK | Válido | EdDSA | Expirado | Error "token expired" |
| OK | Válido | EdDSA | OK | Claims extraídos |

---

## 5. ANÁLISE DE FLUXO DE DADOS

### 5.1 Variáveis Críticas - VehicleService

```
┌─────────────────────────────────────────────────────────────────┐
│                   DEFINIÇÃO-USO DE VARIÁVEIS                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  VARIÁVEL: entry (VehicleEntry)                                 │
│  ─────────────────────────────────────────────────────────────  │
│  DEF: Linha 45-54 (criação do objeto)                           │
│  USE: Linha 57 (verifica EntryTime)                             │
│  DEF: Linha 58 (atualiza EntryTime se zero)                     │
│  USE: Linha 62 (serialização proto.Marshal)                     │
│  USE: Linha 67 (extrai ID para key)                             │
│  USE: Linha 78 (envia para syncQueue)                           │
│  USE: Linha 91 (retorna EntryTime na resposta)                  │
│                                                                 │
│  VARIÁVEL: key ([]byte)                                         │
│  ─────────────────────────────────────────────────────────────  │
│  DEF: Linha 67 (key = []byte(entry.Id))                         │
│  USE: Linha 68 (s.localDB.Put(key, protoBytes))                 │
│  USE: Linha 88 (retorna como EntryId)                           │
│                                                                 │
│  VARIÁVEL: protoBytes ([]byte)                                  │
│  ─────────────────────────────────────────────────────────────  │
│  DEF: Linha 62 (serialização)                                   │
│  USE: Linha 68 (persistência no banco)                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 5.2 Caminhos de Dados - VoucherService

```
┌─────────────────────────────────────────────────────────────────┐
│                FLUXO DE DADOS - GenerateVoucher                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  INPUT                                                          │
│    │                                                            │
│    ├── reservationID ──────────────────────┐                    │
│    ├── garageID ───────────────────────────┤                    │
│    ├── vehiclePlate ───────────────────────┼───► VoucherClaims  │
│    ├── originalPrice ──────────────────────┤                    │
│    └── sponsors[] ─────────────────────────┘                    │
│                                              │                  │
│                                              ▼                  │
│                                     jwt.NewWithClaims()         │
│                                              │                  │
│                                              ▼                  │
│                                     token.SignedString()        │
│                                              │                  │
│                                              ▼                  │
│                                     VoucherResult {             │
│                                       JWT: signedToken,         │
│                                       JTI: uuid.New(),          │
│                                       ExpiresAt: now+60min      │
│                                     }                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 6. COMANDOS PARA EXECUTAR TESTES

### 6.1 Executar Todos os Testes de Caixa Branca

```bash
cd d:\ParkingZero\backend-api

# Executar com cobertura
go test -v -cover ./internal/service/... -run "^Test.*_"

# Gerar relatório de cobertura HTML
go test -coverprofile=coverage.out ./internal/service/...
go tool cover -html=coverage.out -o coverage.html

# Ver cobertura por função
go tool cover -func=coverage.out
```

### 6.2 Executar Testes Específicos

```bash
# Apenas VehicleService
go test -v ./internal/service/... -run "TestRecordVehicle"

# Apenas VoucherService
go test -v ./internal/service/... -run "TestVoucher"

# Com race detection
go test -v -race ./internal/service/...
```

### 6.3 Benchmark

```bash
go test -bench=. -benchmem ./internal/service/...
```

---

## 7. RELATÓRIO DE EXECUÇÃO

| Teste | Status | Cobertura | Tempo |
|-------|--------|-----------|-------|
| TC-WB-VEH-001 | ⬜ Pending | - | - |
| TC-WB-VEH-002 | ⬜ Pending | - | - |
| TC-WB-VEH-003 | ⬜ Pending | - | - |
| TC-WB-VEH-004 | ⬜ Pending | - | - |
| TC-WB-VEH-005 | ⬜ Pending | - | - |
| TC-WB-VEH-006 | ⬜ Pending | - | - |
| TC-WB-VEH-007 | ⬜ Pending | - | - |
| TC-WB-VEH-008 | ⬜ Pending | - | - |
| TC-WB-VOU-001 | ⬜ Pending | - | - |
| TC-WB-VOU-002 | ⬜ Pending | - | - |
| TC-WB-VOU-003 | ⬜ Pending | - | - |
| TC-WB-VOU-004 | ⬜ Pending | - | - |
| TC-WB-VOU-005 | ⬜ Pending | - | - |
| TC-WB-VOU-006 | ⬜ Pending | - | - |

---

## 8. APROVAÇÃO

| Papel | Nome | Data | Assinatura |
|-------|------|------|------------|
| Testador | | | |
| Desenvolvedor | | | |
| QA Lead | | | |

---

**Fim do Documento de Testes de Caixa Branca**
