# ParkingZero - Testes de Carga e Desempenho

## Visão Geral

Este diretório contém testes de carga e desempenho para a API do ParkingZero.
Os testes foram projetados para simular cenários reais de uso com milhares de usuários simultâneos.

## Ferramentas Utilizadas

- **k6** - Ferramenta de testes de carga moderna e escalável
- **ghz** - Ferramenta de benchmarking específica para gRPC
- **Go Test Benchmarks** - Benchmarks nativos do Go

## Estrutura do Diretório

```
load-tests/
├── README.md                    # Este arquivo
├── k6/                          # Scripts k6 para testes HTTP
│   ├── config.js                # Configurações compartilhadas
│   ├── scenarios/               # Cenários de teste
│   │   ├── full-flow.js         # Fluxo completo (login → reserva → pagamento → histórico)
│   │   ├── spike-test.js        # Teste de pico de carga
│   │   └── stress-test.js       # Teste de estresse prolongado
│   └── utils/                   # Utilitários
│       └── helpers.js           # Funções auxiliares
├── grpc/                        # Scripts para testes gRPC
│   ├── proto/                   # Arquivos .proto copiados
│   ├── benchmark_test.go        # Benchmarks Go nativos
│   └── ghz-config.json          # Configuração do ghz
├── reports/                     # Relatórios gerados
│   └── .gitkeep
└── scripts/                     # Scripts de automação
    ├── run-all-tests.ps1        # Executar todos os testes (Windows)
    └── analyze-results.ps1      # Analisar resultados
```

## Instalação

### 1. Instalar k6

```powershell
# Via Chocolatey
choco install k6

# Ou download direto
# https://k6.io/docs/getting-started/installation/
```

### 2. Instalar ghz (para testes gRPC)

```powershell
go install github.com/bojand/ghz/cmd/ghz@latest
```

## Execução dos Testes

### Teste Rápido (Validação)

```powershell
cd load-tests
k6 run k6/scenarios/full-flow.js --vus 10 --duration 30s
```

### Teste de Carga Completo (1000 VUs)

```powershell
k6 run k6/scenarios/full-flow.js
```

### Teste de Pico

```powershell
k6 run k6/scenarios/spike-test.js
```

### Teste de Estresse

```powershell
k6 run k6/scenarios/stress-test.js
```

### Benchmarks gRPC

```powershell
# Com ghz
ghz --config grpc/ghz-config.json

# Com Go Benchmarks
go test -bench=. -benchmem ./grpc/...
```

## Cenários de Teste

### 1. Fluxo Completo (full-flow.js)

Simula o uso típico do aplicativo:

1. **Login** → Autenticação do usuário
2. **Buscar Garagens** → Listar garagens próximas
3. **Criar Reserva** → Reservar vaga
4. **Patrocínio** → Loja patrocina estacionamento
5. **Verificar Saída** → Guarda verifica permissão
6. **Histórico** → Consultar reservas anteriores

### 2. Parâmetros do Teste Principal

| Parâmetro | Valor |
|-----------|-------|
| Usuários Virtuais (VUs) | 1.000 |
| Duração Total | 2 minutos |
| Ramp-up | 100 → 1.000 VUs (30s) |
| Carga Sustentada | 1.000 VUs (60s) |
| Ramp-down | 1.000 → 0 VUs (30s) |

## Métricas Coletadas

### Latência
- **http_req_duration** - Tempo total de resposta
- **p95** - Percentil 95 de latência
- **p99** - Percentil 99 de latência
- **avg** - Tempo médio

### Throughput
- **http_reqs** - Requisições por segundo
- **iterations** - Iterações completas por segundo

### Erros
- **http_req_failed** - Taxa de falha
- **checks** - Validações que passaram/falharam

### Por Endpoint
- Todos os endpoints são tagueados para análise individual

## Critérios de Aprovação (Thresholds)

```javascript
thresholds: {
  http_req_duration: ['p(95)<500'],     // 95% das requisições < 500ms
  http_req_failed: ['rate<0.01'],       // < 1% de falhas
  checks: ['rate>0.99'],                // > 99% de validações OK
  
  // Por endpoint (exemplo)
  'http_req_duration{endpoint:login}': ['p(95)<200'],
  'http_req_duration{endpoint:reserve}': ['p(95)<300'],
  'http_req_duration{endpoint:pay}': ['p(95)<400'],
}
```

## Relatórios

### Formato JSON

```powershell
k6 run --out json=reports/results.json k6/scenarios/full-flow.js
```

### Formato HTML (via k6 Cloud ou xk6-dashboard)

```powershell
# Com dashboard local
xk6 build --with github.com/grafana/xk6-dashboard
./k6 run --out dashboard k6/scenarios/full-flow.js
```

## Integração com o Projeto

### Adaptação do Fluxo

O projeto ParkingZero utiliza **gRPC** como protocolo principal. 
Os testes foram adaptados para:

1. **Health Checks HTTP** - Endpoint `/health` na porta 8081
2. **Simulação gRPC** - Via biblioteca `k6/x/grpc` ou ghz
3. **Benchmarks Go** - Testes de unidade com medição de performance

### Considerações

- O backend usa **Firestore** para persistência cloud
- Operações de veículos usam **B+Tree local** (latência crítica)
- O **Sync Worker** sincroniza dados em background
- O **Circuit Breaker** protege contra falhas do Firestore

## Troubleshooting

### Erros de Conexão

```powershell
# Verificar se o servidor está rodando
curl http://localhost:8081/health

# Verificar status detalhado
curl http://localhost:8081/health/sync
```

### Problemas de Performance no Servidor

1. Verificar logs do container/processo
2. Analisar métricas do Circuit Breaker (`/health/sync`)
3. Verificar conexão com Firestore

## Próximos Passos

- [ ] Adicionar testes de resiliência (chaos engineering)
- [ ] Integrar com CI/CD (GitHub Actions)
- [ ] Configurar alertas de regressão de performance
- [ ] Adicionar testes de capacidade do B+Tree local
