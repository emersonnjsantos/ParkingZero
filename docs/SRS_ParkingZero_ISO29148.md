# Software Requirements Specification (SRS)
# ParkingZero

**Documento conforme ISO/IEC/IEEE 29148:2018**

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-01-30 | Equipe ParkingZero | Versão inicial |

---

## 1. INTRODUÇÃO

### 1.1 Propósito

Este documento especifica os requisitos de software para o sistema **ParkingZero**, uma plataforma de estacionamento inteligente com sistema de patrocínio (cashback) de lojas parceiras. O documento destina-se a desenvolvedores, testadores, gerentes de projeto e stakeholders.

### 1.2 Escopo

O **ParkingZero** é um sistema composto por:

- **Backend API**: Servidor gRPC em Go com persistência híbrida (Firestore + B+Tree local)
- **Mobile App**: Aplicativo Flutter multiplataforma para usuários finais
- **Sistema de Patrocínio**: Modelo Multi-Sponsor com vouchers JWT offline

**Benefícios:**
- Usuários ganham estacionamento grátis ao comprar em lojas parceiras
- Lojas aumentam vendas oferecendo benefício de estacionamento
- Estacionamentos aumentam fluxo de clientes

**Objetivos:**
- OBJ-01: Permitir busca e reserva de vagas de estacionamento
- OBJ-02: Implementar sistema de patrocínio multi-sponsor
- OBJ-03: Garantir operação offline na guarita via vouchers JWT
- OBJ-04: Manter latência < 10ms para operações de entrada/saída

### 1.3 Definições, Acrônimos e Abreviações

| Termo | Definição |
|-------|-----------|
| **B+Tree** | Estrutura de dados de árvore balanceada para armazenamento local |
| **Circuit Breaker** | Padrão de resiliência que interrompe chamadas a serviços falhos |
| **DLQ** | Dead Letter Queue - fila para mensagens que falharam |
| **FCM** | Firebase Cloud Messaging - serviço de notificações push |
| **Firestore** | Banco de dados NoSQL do Google Firebase |
| **gRPC** | Google Remote Procedure Call - protocolo de comunicação |
| **JWT** | JSON Web Token - token de autenticação assinado |
| **Ledger** | Registro contábil de transações de patrocínio |
| **RBAC** | Role-Based Access Control - controle de acesso baseado em papéis |
| **Sponsor** | Loja parceira que patrocina estacionamento |
| **Voucher** | Comprovante digital de estacionamento patrocinado |

### 1.4 Referências

| ID | Documento | Descrição |
|----|-----------|-----------|
| REF-01 | ISO/IEC/IEEE 29148:2018 | Engenharia de requisitos |
| REF-02 | parking_service.proto | Definição de contratos gRPC |
| REF-03 | WALKTHROUGH.md | Documentação técnica do sistema |
| REF-04 | DEPLOYMENT.md | Guia de implantação |

### 1.5 Visão Geral do Documento

- **Seção 2**: Descrição geral do produto e contexto
- **Seção 3**: Requisitos funcionais detalhados
- **Seção 4**: Requisitos não-funcionais
- **Seção 5**: Requisitos de interface
- **Seção 6**: Verificação e critérios de aceitação
- **Apêndices**: Matriz de rastreabilidade e glossário

---

## 2. DESCRIÇÃO GERAL

### 2.1 Perspectiva do Produto

O ParkingZero é um sistema novo que integra três domínios:

```
┌─────────────────────────────────────────────────────────────────┐
│                    ECOSSISTEMA PARKINGZERO                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐   │
│  │   USUÁRIO     │    │    LOJA       │    │ ESTACIONAMENTO│   │
│  │   (App)       │    │  (Parceiro)   │    │   (Guarita)   │   │
│  └───────┬───────┘    └───────┬───────┘    └───────┬───────┘   │
│          │                    │                    │           │
│          └────────────────────┼────────────────────┘           │
│                               │                                │
│                     ┌─────────▼─────────┐                      │
│                     │   BACKEND API     │                      │
│                     │   (Go/gRPC)       │                      │
│                     └─────────┬─────────┘                      │
│                               │                                │
│              ┌────────────────┼────────────────┐               │
│              │                │                │               │
│     ┌────────▼────────┐ ┌─────▼─────┐ ┌───────▼───────┐       │
│     │   Firestore     │ │  B+Tree   │ │    Firebase   │       │
│     │   (Cloud)       │ │  (Local)  │ │    Auth/FCM   │       │
│     └─────────────────┘ └───────────┘ └───────────────┘       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Funções do Produto

| ID | Função | Descrição |
|----|--------|-----------|
| FN-01 | Busca de Garagens | Localizar estacionamentos por geolocalização |
| FN-02 | Reservas | Criar, listar e cancelar reservas |
| FN-03 | Entrada/Saída | Registrar movimento de veículos |
| FN-04 | Patrocínio | Lojas pagam estacionamento de clientes |
| FN-05 | Voucher Offline | Validação de saída sem internet |
| FN-06 | Notificações | Alertas push sobre status de patrocínio |

### 2.3 Características do Usuário

| Classe | Descrição | Nível Técnico |
|--------|-----------|---------------|
| Usuário Final | Cliente que estaciona e compra em lojas | Básico |
| Operador de Loja | Funcionário que processa patrocínios | Intermediário |
| Guarda de Estacionamento | Valida saídas na guarita | Básico |
| Administrador | Gerencia sistema e parceiros | Avançado |

### 2.4 Restrições

| ID | Restrição | Justificativa |
|----|-----------|---------------|
| RES-01 | Backend deve usar Go 1.21+ | Compatibilidade com Cloud Run |
| RES-02 | Mobile deve suportar Android 8+ e iOS 14+ | Cobertura de mercado |
| RES-03 | Comunicação via gRPC com TLS | Segurança e performance |
| RES-04 | Dados sensíveis criptografados | Conformidade LGPD |

### 2.5 Suposições e Dependências

| ID | Suposição/Dependência |
|----|----------------------|
| DEP-01 | Google Cloud Platform disponível 99.9% |
| DEP-02 | Firebase Auth para autenticação |
| DEP-03 | Dispositivos com GPS funcional |
| DEP-04 | Conexão internet para operações normais |
| SUP-01 | Lojas possuem sistema de emissão de NF |
| SUP-02 | Guardas possuem dispositivo com câmera |

---

## 3. REQUISITOS FUNCIONAIS

### 3.1 Módulo: Busca de Garagens

#### REQ-FUNC-001: Buscar Garagens por Localização

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-001 |
| **Nome** | Buscar Garagens por Localização |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve permitir buscar garagens próximas a uma coordenada geográfica dentro de um raio especificado |
| **Entrada** | Latitude (double), Longitude (double), Raio em metros (int32) |
| **Saída** | Lista de objetos Garage ordenados por distância |
| **Regras** | RN-001: Raio máximo de 10.000 metros |
| **Origem** | Stakeholder: Usuário Final |

#### REQ-FUNC-002: Obter Detalhes da Garagem

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-002 |
| **Nome** | Obter Detalhes da Garagem |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve retornar informações detalhadas de uma garagem específica |
| **Entrada** | garage_id (string) |
| **Saída** | Objeto Garage com: name, base_price, latitude, longitude, address, phone, total_spots, available_spots, amenities[], campaigns[] |
| **Origem** | Stakeholder: Usuário Final |

### 3.2 Módulo: Sistema de Reservas

#### REQ-FUNC-003: Criar Reserva

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-003 |
| **Nome** | Criar Reserva de Vaga |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve permitir criar uma reserva de vaga com período definido |
| **Entrada** | user_id, garage_id, start_time, end_time, vehicle_plate |
| **Saída** | Objeto Reservation com ID gerado e status PENDING |
| **Regras** | RN-002: Período mínimo de 30 minutos; RN-003: Não pode ter mais de 3 reservas ativas |
| **Origem** | Stakeholder: Usuário Final |

#### REQ-FUNC-004: Listar Reservas do Usuário

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-004 |
| **Nome** | Listar Reservas |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve listar todas as reservas de um usuário, opcionalmente filtradas por status |
| **Entrada** | user_id, status_filter (opcional) |
| **Saída** | Lista de objetos Reservation |
| **Origem** | Stakeholder: Usuário Final |

#### REQ-FUNC-005: Cancelar Reserva

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-005 |
| **Nome** | Cancelar Reserva |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve permitir cancelar uma reserva existente |
| **Entrada** | reservation_id, user_id |
| **Saída** | success (boolean), message (string) |
| **Regras** | RN-004: Só pode cancelar reservas próprias; RN-005: Não pode cancelar se status = COMPLETED |
| **Origem** | Stakeholder: Usuário Final |

### 3.3 Módulo: Entrada/Saída de Veículos

#### REQ-FUNC-006: Registrar Entrada de Veículo

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-006 |
| **Nome** | Registrar Entrada de Veículo |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve registrar a entrada de um veículo com latência < 10ms usando armazenamento local B+Tree |
| **Entrada** | garage_id, vehicle_plate, entry_time, user_id (opcional) |
| **Saída** | entry_id, success, message, entry_time |
| **Regras** | RN-006: Veículo não pode ter entrada ativa na mesma garagem |
| **Requisitos Relacionados** | REQ-NFR-001 (Performance) |
| **Origem** | Stakeholder: Operador de Estacionamento |

#### REQ-FUNC-007: Registrar Saída de Veículo

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-007 |
| **Nome** | Registrar Saída de Veículo |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve registrar a saída e calcular o valor a pagar baseado no tempo de permanência |
| **Entrada** | garage_id, vehicle_plate, exit_time |
| **Saída** | entry_id, total_amount, duration_seconds, entry_time, exit_time, success |
| **Regras** | RN-007: Valor = (duration_hours * base_price); RN-008: Primeira hora = valor cheio |
| **Origem** | Stakeholder: Operador de Estacionamento |

#### REQ-FUNC-008: Listar Veículos Ativos

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-008 |
| **Nome** | Listar Veículos Estacionados |
| **Prioridade** | Desejável |
| **Descrição** | O sistema deve listar todos os veículos atualmente estacionados em uma garagem |
| **Entrada** | garage_id |
| **Saída** | Lista de VehicleEntry, total_active (int32) |
| **Origem** | Stakeholder: Operador de Estacionamento |

### 3.4 Módulo: Sistema de Patrocínio

#### REQ-FUNC-009: Solicitar Patrocínio

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-009 |
| **Nome** | Solicitar Patrocínio de Estacionamento |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve permitir que lojas patrocinem o estacionamento de clientes mediante validação de nota fiscal |
| **Entrada** | reservation_id, store_id, invoice (invoice_id, amount_usd, timestamp, store_name), sync_id, amount_to_sponsor |
| **Saída** | success, message, new_status, ledger_entry_id, amount_sponsored, current_balance, total_sponsored, voucher (se balance=0) |
| **Regras** | RN-009: Valor mínimo da NF = R$ 200,00; RN-010: Cada NF só pode ser usada uma vez; RN-011: Múltiplas lojas podem patrocinar mesma reserva |
| **Origem** | Stakeholder: Loja Parceira |

#### REQ-FUNC-010: Consultar Status do Voucher

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-010 |
| **Nome** | Consultar Status do Voucher |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve retornar o status atual de patrocínio de uma reserva |
| **Entrada** | reservation_id |
| **Saída** | reservation_id, status, original_price, current_balance, total_sponsored, sponsors_summary[], voucher (se disponível) |
| **Origem** | Stakeholder: Usuário Final |

#### REQ-FUNC-011: Verificar Permissão de Saída

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-011 |
| **Nome** | Verificar Permissão de Saída |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve verificar se um veículo tem permissão para sair (patrocinado ou pagamento necessário) |
| **Entrada** | garage_id, vehicle_plate |
| **Saída** | authorized, message, display_message, status, payer_name, action_required, amount_due |
| **Regras** | RN-012: Se status = SPONSORED, authorized = true |
| **Origem** | Stakeholder: Guarda de Estacionamento |

#### REQ-FUNC-012: Confirmar Saída Física

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-012 |
| **Nome** | Confirmar Saída Física do Veículo |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve registrar a saída física confirmada pelo guarda |
| **Entrada** | garage_id, vehicle_plate, agent_id |
| **Saída** | success, message, final_status (COMPLETED) |
| **Origem** | Stakeholder: Guarda de Estacionamento |

### 3.5 Módulo: Voucher Offline

#### REQ-FUNC-013: Gerar Voucher JWT

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-013 |
| **Nome** | Gerar Voucher JWT Assinado |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve gerar um voucher JWT assinado quando o saldo da reserva chegar a zero |
| **Entrada** | (Automático quando current_balance = 0) |
| **Saída** | SignedVoucher (jwt, jti, expires_at, qr_code_data) |
| **Regras** | RN-013: Validade de 60 minutos; RN-014: Assinatura Ed25519 |
| **Origem** | REQ-FUNC-009 |

#### REQ-FUNC-014: Registrar Voucher Usado

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-014 |
| **Nome** | Registrar Uso de Voucher (Anti-Fraude) |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve registrar quando um voucher é usado para prevenir reutilização |
| **Entrada** | jti, reservation_id, garage_id, agent_id, used_at, vehicle_plate, sync_id |
| **Saída** | success, message, error_code (se já usado) |
| **Regras** | RN-015: Cada JTI só pode ser registrado uma vez |
| **Origem** | Stakeholder: Guarda de Estacionamento |

#### REQ-FUNC-015: Consultar Histórico de Patrocínios

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-FUNC-015 |
| **Nome** | Consultar Ledger de Patrocínios |
| **Prioridade** | Desejável |
| **Descrição** | O sistema deve retornar o histórico completo de patrocínios de uma reserva |
| **Entrada** | reservation_id |
| **Saída** | reservation_id, original_price, current_balance, total_sponsored, status, entries[], voucher, entry_count |
| **Origem** | Stakeholder: Administrador |

---

## 4. REQUISITOS NÃO-FUNCIONAIS

### 4.1 Requisitos de Performance

#### REQ-NFR-001: Latência de Entrada/Saída

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-001 |
| **Nome** | Latência Crítica para Operações de Veículos |
| **Prioridade** | Essencial |
| **Descrição** | Operações de entrada e saída de veículos devem ter latência inferior a 10ms |
| **Métrica** | P99 < 10ms para RecordVehicleEntry e RecordVehicleExit |
| **Método de Verificação** | Teste de carga com 1000 operações simultâneas |

#### REQ-NFR-002: Throughput do Sistema

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-002 |
| **Nome** | Capacidade de Processamento |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve suportar no mínimo 100 operações por segundo |
| **Métrica** | > 100 TPS sustentado por 10 minutos |

### 4.2 Requisitos de Disponibilidade

#### REQ-NFR-003: Disponibilidade do Sistema

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-003 |
| **Nome** | Alta Disponibilidade |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve ter disponibilidade de 99.9% (excluindo manutenções programadas) |
| **Métrica** | Downtime máximo de 8.76 horas/ano |

#### REQ-NFR-004: Operação Offline

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-004 |
| **Nome** | Capacidade Offline na Guarita |
| **Prioridade** | Essencial |
| **Descrição** | A validação de vouchers deve funcionar sem conexão internet |
| **Método** | Validação criptográfica local usando chave pública Ed25519 |

### 4.3 Requisitos de Resiliência

#### REQ-NFR-005: Circuit Breaker

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-005 |
| **Nome** | Proteção contra Falhas em Cascata |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve implementar Circuit Breaker para chamadas ao Firestore |
| **Estados** | CLOSED (normal) → OPEN (5 falhas) → HALF_OPEN (teste) |

#### REQ-NFR-006: Dead Letter Queue

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-006 |
| **Nome** | Fila de Mensagens Mortas |
| **Prioridade** | Essencial |
| **Descrição** | Entradas que falharem na sincronização devem ser armazenadas para reprocessamento |
| **Formato** | Arquivo JSON local em /data/dlq.json |

#### REQ-NFR-007: Graceful Shutdown

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-007 |
| **Nome** | Encerramento Gracioso |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve finalizar operações pendentes antes de encerrar |
| **Comportamento** | Ao receber SIGTERM: parar sync worker, aguardar batch atual, fsync banco local |

### 4.4 Requisitos de Segurança

#### REQ-NFR-008: Autenticação

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-008 |
| **Nome** | Autenticação Obrigatória |
| **Prioridade** | Essencial |
| **Descrição** | Todas as operações sensíveis devem exigir autenticação via Firebase Auth |
| **Método** | Token Bearer no header Authorization |

#### REQ-NFR-009: Autorização RBAC

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-009 |
| **Nome** | Controle de Acesso Baseado em Papéis |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve implementar RBAC com os papéis: USER, PARTNER_STORE, PARTNER_PARKING, ADMIN |
| **Regras** | Cada endpoint deve validar papéis permitidos |

#### REQ-NFR-010: Idempotência

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-010 |
| **Nome** | Operações Idempotentes |
| **Prioridade** | Essencial |
| **Descrição** | Operações de patrocínio devem ser idempotentes usando sync_id |
| **Método** | UUID gerado pelo cliente, verificado antes de processar |

### 4.5 Requisitos de Manutenibilidade

#### REQ-NFR-011: Logs Estruturados

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-011 |
| **Nome** | Logging Padronizado |
| **Prioridade** | Desejável |
| **Descrição** | Todos os eventos devem ser logados em formato estruturado |
| **Formato** | JSON com timestamp, level, message, context |

#### REQ-NFR-012: Health Checks

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-NFR-012 |
| **Nome** | Endpoints de Saúde |
| **Prioridade** | Essencial |
| **Descrição** | O sistema deve expor endpoints /health e /ready |
| **Porta** | 8081 (separada do gRPC) |

---

## 5. REQUISITOS DE INTERFACE

### 5.1 Interfaces de Usuário

#### REQ-INT-001: App Mobile

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-INT-001 |
| **Nome** | Interface Mobile Flutter |
| **Plataformas** | Android 8.0+, iOS 14.0+ |
| **Telas** | Splash, Login, Home (Carousel), Mapa, Reservas, Wallet |

### 5.2 Interfaces de Hardware

#### REQ-INT-002: GPS

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-INT-002 |
| **Nome** | Acesso a GPS |
| **Descrição** | O app deve acessar localização GPS para busca de garagens |
| **Permissões** | ACCESS_FINE_LOCATION (Android), NSLocationWhenInUseUsageDescription (iOS) |

#### REQ-INT-003: Câmera

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-INT-003 |
| **Nome** | Acesso a Câmera |
| **Descrição** | O app do guarda deve acessar câmera para escanear QR codes |

### 5.3 Interfaces de Software

#### REQ-INT-004: Firebase

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-INT-004 |
| **Nome** | Integração Firebase |
| **Serviços** | Authentication, Firestore, Cloud Messaging |

#### REQ-INT-005: Google Maps

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-INT-005 |
| **Nome** | Integração Google Maps |
| **Uso** | Exibição de mapa, marcadores de garagens, navegação |

### 5.4 Interfaces de Comunicação

#### REQ-INT-006: Protocolo gRPC

| Atributo | Valor |
|----------|-------|
| **ID** | REQ-INT-006 |
| **Nome** | Comunicação via gRPC |
| **Porta** | 8080 |
| **Serialização** | Protocol Buffers v3 |
| **Segurança** | TLS 1.3 em produção |

---

## 6. VERIFICAÇÃO

### 6.1 Critérios de Aceitação

| Requisito | Critério de Verificação | Método |
|-----------|------------------------|--------|
| REQ-FUNC-001 | Retorna garagens dentro do raio especificado | Teste automatizado |
| REQ-FUNC-006 | Latência < 10ms em P99 | Teste de carga |
| REQ-FUNC-009 | NF < R$200 rejeitada com código AMOUNT_INSUFFICIENT | Teste unitário |
| REQ-FUNC-013 | Voucher válido por 60 minutos | Teste unitário |
| REQ-FUNC-014 | Segundo registro do mesmo JTI retorna VOUCHER_ALREADY_USED | Teste de integração |
| REQ-NFR-004 | Validação bem-sucedida sem conexão internet | Teste manual |
| REQ-NFR-005 | Após 5 falhas, Circuit Breaker abre | Teste de integração |

### 6.2 Matriz de Rastreabilidade

| Requisito | Origem | Implementação | Teste |
|-----------|--------|---------------|-------|
| REQ-FUNC-001 | Stakeholder | parking.go:SearchGarages | test_search.go |
| REQ-FUNC-006 | Stakeholder | vehicle.go:RecordVehicleEntry | test_vehicle.go |
| REQ-FUNC-009 | Regra de Negócio | sponsorship.go:RequestSponsorship | test_sponsorship.go |
| REQ-FUNC-013 | REQ-FUNC-009 | voucher.go:GenerateVoucher | test_voucher.go |
| REQ-NFR-001 | Arquitetura | database/btree.go | benchmark_test.go |
| REQ-NFR-005 | Arquitetura | sync_worker.go | test_circuit_breaker.go |
| REQ-NFR-009 | Segurança | auth/rbac.go | test_rbac.go |

---

## APÊNDICE A: Modelo de Dados

### A.1 Coleções Firestore

```
garages/
  {garage_id}/
    - name: string
    - base_price: number
    - latitude: number
    - longitude: number
    - geohash: string
    - address: string
    - phone: string
    - total_spots: number
    - available_spots: number
    - amenities: array<string>
    - campaigns/
        {campaign_id}/
          - partner_name: string
          - discount_rule: string

reservations/
  {reservation_id}/
    - user_id: string
    - garage_id: string
    - vehicle_plate: string
    - start_time: timestamp
    - end_time: timestamp
    - status: enum
    - total_price: number
    - current_balance: number
    - sponsorship_ledger/
        {entry_id}/
          - store_id: string
          - store_name: string
          - amount: number
          - invoice_id: string
          - timestamp: timestamp
          - sync_id: string

users/
  {user_id}/
    - email: string
    - role: string
    - partner_id: string (opcional)

vehicle_entries/
  {garage_id|plate}/
    - garage_id: string
    - vehicle_plate: string
    - entry_time: timestamp
    - exit_time: timestamp
    - status: enum
    - amount_paid: number

used_vouchers/
  {jti}/
    - reservation_id: string
    - garage_id: string
    - used_at: timestamp
    - agent_id: string

bi_events/
  {event_id}/
    - type: string
    - data: map
    - timestamp: timestamp
```

---

## APÊNDICE B: Glossário Completo

| Termo | Definição |
|-------|-----------|
| **Amenities** | Facilidades oferecidas pela garagem (WiFi, carregador EV, etc.) |
| **Campaign** | Campanha promocional de desconto de uma loja parceira |
| **Current Balance** | Valor restante a pagar após patrocínios |
| **Entry** | Registro de entrada de veículo no estacionamento |
| **Geohash** | Codificação de coordenadas geográficas para busca eficiente |
| **Half-Open** | Estado do Circuit Breaker onde uma requisição de teste é permitida |
| **Invoice** | Nota fiscal emitida pela loja parceira |
| **JTI** | JWT ID - Identificador único do voucher |
| **Ledger Entry** | Registro individual de patrocínio no histórico |
| **Partner** | Loja ou estacionamento parceiro do sistema |
| **Reservation** | Agendamento de uso de vaga de estacionamento |
| **Sponsor** | Entidade que paga pelo estacionamento (loja parceira) |
| **Sync Worker** | Processo em background que sincroniza dados locais com Firestore |
| **Voucher** | Comprovante digital de estacionamento patrocinado |

---

## Histórico de Revisões

| Versão | Data | Alterações |
|--------|------|------------|
| 1.0 | 2026-01-30 | Documento inicial baseado na análise do código-fonte |

---

**Fim do Documento SRS - ParkingZero**
