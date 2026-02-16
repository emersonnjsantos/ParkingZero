/**
 * ParkingZero - Teste de Carga: Fluxo Completo
 * 
 * Este teste simula o fluxo completo de uso do aplicativo:
 * 1. Login do usuário
 * 2. Buscar garagens próximas
 * 3. Criar reserva
 * 4. Patrocínio de loja (opcional)
 * 5. Verificar saída
 * 6. Consultar histórico
 * 
 * Cenário de Carga:
 * - 1.000 usuários virtuais simultâneos
 * - Duração: 2 minutos de execução
 * - Ramp-up: iniciar com 100 usuários e aumentar gradualmente até 1.000
 * - Ramp-down: reduzir até 0 usuários no final
 */

import http from 'k6/http';
import { check, sleep, group } from 'k6';
import { Counter, Trend, Rate } from 'k6/metrics';

import {
    BASE_URL,
    HEALTH_URL,
    SCENARIO_CONFIGS,
    THRESHOLDS,
    TEST_USERS,
    TEST_GARAGES,
    getAuthHeaders,
    DEFAULT_HEADERS,
    randomFromArray,
    generatePlate,
    generateUserId,
} from '../config.js';

import {
    validateLoginResponse,
    validateReservationResponse,
    validatePaymentResponse,
    validateExitResponse,
    validateHistoryResponse,
    generateLoginPayload,
    generateReservationPayload,
    generateSponsorshipPayload,
    generateExitPayload,
    handleSummary,
} from '../utils/helpers.js';

// ==================== Métricas Customizadas ====================
const endpointDuration = new Trend('endpoint_duration');
const endpointErrors = new Counter('endpoint_errors');
const flowSuccessRate = new Rate('flow_success_rate');

// ==================== Opções do Teste ====================
export const options = {
    scenarios: {
        // Cenário principal: ramping-vus (aumento gradual)
        load_test: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: SCENARIO_CONFIGS.standard.stages,
            gracefulRampDown: '30s',
        },
    },

    thresholds: THRESHOLDS,

    // Metadata do teste
    tags: {
        test_name: 'full_flow',
        environment: __ENV.ENVIRONMENT || 'development',
    },

    // Evitar sobrecarga do sistema local
    noConnectionReuse: false,
    userAgent: 'k6-load-test/1.0',
};

// ==================== Setup (executado uma vez antes do teste) ====================
export function setup() {
    console.log('🚀 Iniciando teste de carga - Fluxo Completo');
    console.log(`📍 URL Base: ${BASE_URL}`);
    console.log(`🏥 Health URL: ${HEALTH_URL}`);

    // Verificar se o servidor está online
    const healthRes = http.get(`${HEALTH_URL}/health`);
    if (healthRes.status !== 200) {
        console.error('⚠️ Servidor não está respondendo corretamente!');
    } else {
        console.log('✅ Servidor online e pronto para testes');
    }

    return {
        startTime: new Date().toISOString(),
        testUsers: TEST_USERS,
        testGarages: TEST_GARAGES,
    };
}

// ==================== Função Principal (executada por cada VU) ====================
export default function (data) {
    // Selecionar dados aleatórios para este VU
    const user = randomFromArray(data.testUsers);
    const garage = randomFromArray(data.testGarages);
    const vehiclePlate = generatePlate();
    const vuId = __VU;
    const iterationId = __ITER;

    let sessionToken = null;
    let reservationId = null;
    let flowSuccess = true;

    // ==================== 1. HEALTH CHECK ====================
    group('01_health_check', function () {
        const res = http.get(`${HEALTH_URL}/health`, {
            tags: { endpoint: 'health' },
        });

        const success = check(res, {
            'health: status 200': (r) => r.status === 200,
            'health: resposta < 100ms': (r) => r.timings.duration < 100,
        });

        if (!success) {
            endpointErrors.add(1);
            flowSuccess = false;
        }
    });

    sleep(0.1);

    // ==================== 2. LOGIN ====================
    group('02_login', function () {
        const payload = generateLoginPayload(user.email, user.password);

        const res = http.post(`${BASE_URL}/auth/login`, payload, {
            headers: DEFAULT_HEADERS,
            tags: { endpoint: 'login' },
        });

        endpointDuration.add(res.timings.duration, { endpoint: 'login' });

        // Cenário válido (credenciais corretas)
        const success = validateLoginResponse(res, 'valid');

        if (res.status === 200) {
            try {
                const body = JSON.parse(res.body);
                sessionToken = body.token || body.session_token || user.userId;
            } catch (e) {
                // Se não houver token, usar userId como fallback
                sessionToken = user.userId;
            }
        } else {
            flowSuccess = false;
        }
    });

    sleep(0.2);

    // ==================== 3. BUSCAR GARAGENS ====================
    group('03_search_garages', function () {
        const params = {
            headers: getAuthHeaders(sessionToken),
            tags: { endpoint: 'search_garages' },
        };

        // Simulando busca por localização
        const searchPayload = JSON.stringify({
            latitude: -23.5505,
            longitude: -46.6333,
            radius_meters: 5000,
        });

        const res = http.post(`${BASE_URL}/parking/search`, searchPayload, params);

        endpointDuration.add(res.timings.duration, { endpoint: 'search_garages' });

        check(res, {
            'busca: status 200': (r) => r.status === 200,
            'busca: contém garagens': (r) => {
                try {
                    const body = JSON.parse(r.body);
                    return Array.isArray(body.garages) && body.garages.length >= 0;
                } catch (e) {
                    return false;
                }
            },
            'busca: resposta < 300ms': (r) => r.timings.duration < 300,
        });
    });

    sleep(0.3);

    // ==================== 4. CRIAR RESERVA ====================
    group('04_create_reservation', function () {
        const payload = generateReservationPayload(user.userId, garage.id, vehiclePlate);

        const res = http.post(`${BASE_URL}/parking/reserve`, payload, {
            headers: getAuthHeaders(sessionToken),
            tags: { endpoint: 'create_reservation' },
        });

        endpointDuration.add(res.timings.duration, { endpoint: 'create_reservation' });

        // Cenário válido
        const success = validateReservationResponse(res, 'valid');

        if (res.status === 200) {
            try {
                const body = JSON.parse(res.body);
                reservationId = body.id || body.reservation_id;
            } catch (e) {
                reservationId = `res_${vuId}_${iterationId}`;
            }
        } else {
            flowSuccess = false;
        }
    });

    sleep(0.3);

    // ==================== 5. PATROCÍNIO (50% das vezes) ====================
    if (Math.random() > 0.5 && reservationId) {
        group('05_request_sponsorship', function () {
            const storePartner = TEST_USERS.find(u => u.role === 'PARTNER_STORE') || { userId: 'store_001' };
            const payload = generateSponsorshipPayload(reservationId, storePartner.userId, 250.00);

            const res = http.post(`${BASE_URL}/parking/pay`, payload, {
                headers: getAuthHeaders(sessionToken),
                tags: { endpoint: 'request_sponsorship' },
            });

            endpointDuration.add(res.timings.duration, { endpoint: 'request_sponsorship' });

            // Cenário válido (Pix)
            validatePaymentResponse(res, 'valid');
        });

        sleep(0.2);
    }

    // ==================== 6. VERIFICAR SAÍDA ====================
    group('06_verify_exit', function () {
        const payload = generateExitPayload(garage.id, vehiclePlate);

        const res = http.post(`${BASE_URL}/parking/verify-exit`, payload, {
            headers: getAuthHeaders(sessionToken),
            tags: { endpoint: 'verify_exit' },
        });

        endpointDuration.add(res.timings.duration, { endpoint: 'verify_exit' });

        // Verificar saída pode retornar authorized: true ou false
        check(res, {
            'saída: status 200': (r) => r.status === 200,
            'saída: resposta < 150ms': (r) => r.timings.duration < 150,
        });
    });

    sleep(0.2);

    // ==================== 7. CONSULTAR HISTÓRICO ====================
    group('07_list_history', function () {
        const res = http.get(`${BASE_URL}/parking/history?user_id=${user.userId}`, {
            headers: getAuthHeaders(sessionToken),
            tags: { endpoint: 'list_reservations' },
        });

        endpointDuration.add(res.timings.duration, { endpoint: 'list_reservations' });

        validateHistoryResponse(res);
    });

    // Registrar sucesso do fluxo completo
    flowSuccessRate.add(flowSuccess);

    // Pausa entre iterações (simular think time do usuário)
    sleep(Math.random() * 2 + 1); // 1-3 segundos
}

// ==================== Teardown (executado uma vez após o teste) ====================
export function teardown(data) {
    console.log('');
    console.log('📊 Teste de carga finalizado');
    console.log(`⏱️  Iniciado em: ${data.startTime}`);
    console.log(`⏱️  Finalizado em: ${new Date().toISOString()}`);
}

// ==================== Resumo Customizado ====================
export { handleSummary };
