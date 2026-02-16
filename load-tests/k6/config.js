/**
 * Configuração Global para Testes de Carga - ParkingZero
 * 
 * Este arquivo contém todas as configurações compartilhadas entre os cenários de teste.
 */

// ==================== URLs Base ====================
// URL do servidor no Cloud Run (GCP)
export const GCP_HOST = 'parkingzero-backend-565100147812.southamerica-east1.run.app';
export const BASE_URL = __ENV.BASE_URL || `https://${GCP_HOST}`;
export const HEALTH_URL = __ENV.HEALTH_URL || `https://${GCP_HOST}`;
export const GRPC_URL = __ENV.GRPC_URL || `${GCP_HOST}:443`;

// ==================== Credenciais de Teste ====================
export const TEST_USERS = [
    { email: 'teste@usuario.com', password: 'senhaSegura123', userId: 'user_001' },
    { email: 'teste2@usuario.com', password: 'senhaSegura456', userId: 'user_002' },
    { email: 'teste3@usuario.com', password: 'senhaSegura789', userId: 'user_003' },
    { email: 'loja@parceira.com', password: 'lojaSegura123', userId: 'partner_001', role: 'PARTNER_STORE' },
    { email: 'guarda@estacionamento.com', password: 'guardaSegura123', userId: 'partner_002', role: 'PARTNER_PARKING' },
];

// ==================== Dados de Teste ====================
export const TEST_GARAGES = [
    { id: 'garage_001', name: 'Shopping Center Parking', basePrice: 5.00 },
    { id: 'garage_002', name: 'Centro Comercial', basePrice: 4.50 },
    { id: 'garage_003', name: 'Estacionamento Premium', basePrice: 8.00 },
];

export const TEST_VEHICLES = [
    { plate: 'ABC1234', userId: 'user_001' },
    { plate: 'DEF5678', userId: 'user_002' },
    { plate: 'GHI9012', userId: 'user_003' },
];

export const PAYMENT_METHODS = ['pix', 'credit_card', 'debit_card'];

// ==================== Configurações de Cenário ====================
export const SCENARIO_CONFIGS = {
    // Teste padrão: 1000 VUs, 2 minutos
    standard: {
        stages: [
            { duration: '30s', target: 100 },    // Ramp-up gradual
            { duration: '30s', target: 500 },    // Aumentar para 500
            { duration: '30s', target: 1000 },   // Carga máxima
            { duration: '60s', target: 1000 },   // Sustentar carga
            { duration: '30s', target: 0 },      // Ramp-down
        ],
    },

    // Teste rápido de validação
    smoke: {
        stages: [
            { duration: '10s', target: 10 },
            { duration: '20s', target: 10 },
            { duration: '10s', target: 0 },
        ],
    },

    // Teste de pico (spike test)
    spike: {
        stages: [
            { duration: '10s', target: 100 },    // Base
            { duration: '5s', target: 2000 },    // SPIKE!
            { duration: '30s', target: 2000 },   // Sustentar pico
            { duration: '5s', target: 100 },     // Recuperar
            { duration: '30s', target: 100 },    // Estabilizar
            { duration: '10s', target: 0 },      // Finalizar
        ],
    },

    // Teste de estresse
    stress: {
        stages: [
            { duration: '2m', target: 500 },     // Warm-up
            { duration: '5m', target: 1000 },    // Carga moderada
            { duration: '5m', target: 1500 },    // Carga alta
            { duration: '5m', target: 2000 },    // Carga extrema
            { duration: '3m', target: 0 },       // Recuperação
        ],
    },

    // Teste de resistência (soak test)
    soak: {
        stages: [
            { duration: '5m', target: 500 },     // Ramp-up
            { duration: '4h', target: 500 },     // Carga sustentada por 4 horas
            { duration: '5m', target: 0 },       // Ramp-down
        ],
    },
};

// ==================== Thresholds (Critérios de Aprovação) ====================
export const THRESHOLDS = {
    // Globais
    http_req_duration: ['p(95)<500', 'p(99)<1000', 'avg<200'],
    http_req_failed: ['rate<0.01'],
    checks: ['rate>0.99'],

    // Por endpoint (usando tags)
    'http_req_duration{endpoint:health}': ['p(95)<100'],
    'http_req_duration{endpoint:login}': ['p(95)<200'],
    'http_req_duration{endpoint:search_garages}': ['p(95)<300'],
    'http_req_duration{endpoint:create_reservation}': ['p(95)<400'],
    'http_req_duration{endpoint:request_sponsorship}': ['p(95)<500'],
    'http_req_duration{endpoint:verify_exit}': ['p(95)<150'],
    'http_req_duration{endpoint:list_reservations}': ['p(95)<300'],

    // gRPC específicos
    'grpc_req_duration{endpoint:RecordVehicleEntry}': ['p(95)<50'],   // Latência crítica!
    'grpc_req_duration{endpoint:RecordVehicleExit}': ['p(95)<50'],    // Latência crítica!
    'grpc_req_duration{endpoint:GetActiveVehicles}': ['p(95)<100'],
};

// ==================== Headers Padrão ====================
export function getAuthHeaders(token) {
    return {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
    };
}

export const DEFAULT_HEADERS = {
    'Content-Type': 'application/json',
};

// ==================== Funções Utilitárias ====================
export function randomFromArray(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

export function generatePlate() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    let plate = '';
    for (let i = 0; i < 3; i++) plate += letters[Math.floor(Math.random() * 26)];
    for (let i = 0; i < 4; i++) plate += numbers[Math.floor(Math.random() * 10)];
    return plate;
}

export function generateUserId() {
    return `load_test_user_${Date.now()}_${Math.random().toString(36).substring(7)}`;
}

export function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
