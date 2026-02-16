/**
 * ParkingZero - Teste de Pico (Spike Test)
 * 
 * Objetivo: Verificar como o sistema se comporta com picos repentinos de carga.
 * Este teste simula situações como:
 * - Eventos promocionais
 * - Horário de pico (final de expediente)
 * - Black Friday / datas especiais
 * 
 * Cenário:
 * - Base: 100 usuários
 * - Pico: 2.000 usuários
 * - Verificar recuperação após o pico
 */

import http from 'k6/http';
import { check, sleep, group } from 'k6';
import { Counter, Trend, Rate } from 'k6/metrics';

import {
    BASE_URL,
    HEALTH_URL,
    SCENARIO_CONFIGS,
    TEST_USERS,
    TEST_GARAGES,
    getAuthHeaders,
    DEFAULT_HEADERS,
    randomFromArray,
    generatePlate,
} from '../config.js';

import {
    generateLoginPayload,
    generateReservationPayload,
} from '../utils/helpers.js';

// ==================== Métricas Customizadas ====================
const spikeRecoveryTime = new Trend('spike_recovery_time');
const peakLatency = new Trend('peak_latency');
const errorsDuringPeak = new Counter('errors_during_peak');
const successRateDuringPeak = new Rate('success_rate_during_peak');

// ==================== Opções do Teste ====================
export const options = {
    scenarios: {
        spike_test: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: SCENARIO_CONFIGS.spike.stages,
            gracefulRampDown: '10s',
        },
    },

    thresholds: {
        // Thresholds mais permissivos durante pico
        http_req_duration: ['p(95)<1000', 'p(99)<2000'],
        http_req_failed: ['rate<0.05'],  // Até 5% de falha aceitável durante pico
        checks: ['rate>0.95'],

        // Latência durante o pico
        peak_latency: ['p(95)<1500'],

        // Recuperação
        spike_recovery_time: ['avg<500'],
    },

    tags: {
        test_name: 'spike_test',
        environment: __ENV.ENVIRONMENT || 'development',
    },
};

// ==================== Variáveis de Estado ====================
let isPeakPhase = false;
let peakStartTime = 0;

// ==================== Setup ====================
export function setup() {
    console.log('⚡ Iniciando Teste de Pico (Spike Test)');
    console.log('📊 Cenário: 100 VUs → 2000 VUs → 100 VUs');

    // Verificar saúde do sistema antes do teste
    const healthRes = http.get(`${HEALTH_URL}/health`);
    const syncRes = http.get(`${HEALTH_URL}/health/sync`);

    let circuitState = 'unknown';
    try {
        const syncData = JSON.parse(syncRes.body);
        circuitState = syncData.circuit_state || 'unknown';
    } catch (e) { }

    console.log(`🏥 Health: ${healthRes.status === 200 ? 'OK' : 'FALHA'}`);
    console.log(`🔌 Circuit Breaker: ${circuitState}`);

    return {
        startTime: new Date().toISOString(),
        testUsers: TEST_USERS,
        testGarages: TEST_GARAGES,
    };
}

// ==================== Função Principal ====================
export default function (data) {
    const user = randomFromArray(data.testUsers);
    const garage = randomFromArray(data.testGarages);
    const vehiclePlate = generatePlate();

    // Detectar se estamos na fase de pico (>500 VUs ativos)
    const currentVUs = __VU;
    const nowMs = Date.now();

    if (currentVUs > 500 && !isPeakPhase) {
        isPeakPhase = true;
        peakStartTime = nowMs;
        console.log(`🔥 PICO DETECTADO - VUs: ${currentVUs}`);
    } else if (currentVUs < 500 && isPeakPhase) {
        isPeakPhase = false;
        const recoveryTime = nowMs - peakStartTime;
        spikeRecoveryTime.add(recoveryTime);
        console.log(`✅ RECUPERAÇÃO - Tempo: ${recoveryTime}ms`);
    }

    // ==================== Operações Críticas Durante Pico ====================

    group('spike_login', function () {
        const payload = generateLoginPayload(user.email, user.password);
        const start = Date.now();

        const res = http.post(`${BASE_URL}/auth/login`, payload, {
            headers: DEFAULT_HEADERS,
            tags: { endpoint: 'login', phase: isPeakPhase ? 'peak' : 'normal' },
            timeout: '10s',  // Timeout maior durante pico
        });

        const duration = Date.now() - start;

        if (isPeakPhase) {
            peakLatency.add(duration);
        }

        const success = check(res, {
            'spike_login: status 200 ou 429': (r) => r.status === 200 || r.status === 429,
            'spike_login: resposta < 2s': (r) => r.timings.duration < 2000,
        });

        if (isPeakPhase) {
            successRateDuringPeak.add(success);
            if (!success) {
                errorsDuringPeak.add(1);
            }
        }
    });

    sleep(0.1);

    group('spike_reservation', function () {
        const payload = generateReservationPayload(user.userId, garage.id, vehiclePlate);
        const start = Date.now();

        const res = http.post(`${BASE_URL}/parking/reserve`, payload, {
            headers: getAuthHeaders(user.userId),
            tags: { endpoint: 'reserve', phase: isPeakPhase ? 'peak' : 'normal' },
            timeout: '10s',
        });

        const duration = Date.now() - start;

        if (isPeakPhase) {
            peakLatency.add(duration);
        }

        const success = check(res, {
            'spike_reserve: status OK': (r) => r.status === 200 || r.status === 429 || r.status === 503,
            'spike_reserve: resposta < 3s': (r) => r.timings.duration < 3000,
        });

        if (isPeakPhase && !success) {
            errorsDuringPeak.add(1);
        }
    });

    // Think time variável (mais curto durante pico para simular usuários impacientes)
    sleep(isPeakPhase ? 0.5 : 1.5);
}

// ==================== Teardown ====================
export function teardown(data) {
    console.log('');
    console.log('⚡ Teste de Pico Finalizado');
    console.log(`⏱️  Duração: ${data.startTime} → ${new Date().toISOString()}`);

    // Verificar saúde do sistema após o pico
    const healthRes = http.get(`${HEALTH_URL}/health/sync`);
    try {
        const syncData = JSON.parse(healthRes.body);
        console.log(`🔌 Circuit Breaker Final: ${syncData.circuit_state}`);
        console.log(`📊 Falhas Consecutivas: ${syncData.consecutive_failures}`);
    } catch (e) {
        console.log('⚠️ Não foi possível obter status do Circuit Breaker');
    }
}

// ==================== Resumo Customizado ====================
export function handleSummary(data) {
    const summary = {
        timestamp: new Date().toISOString(),
        test_name: 'Spike Test',
        metrics: {
            total_requests: data.metrics.http_reqs?.values?.count || 0,
            failed_during_peak: data.metrics.errors_during_peak?.values?.count || 0,
            peak_latency_p95: data.metrics.peak_latency?.values?.['p(95)'] || 0,
            recovery_time_avg: data.metrics.spike_recovery_time?.values?.avg || 0,
            success_rate_peak: data.metrics.success_rate_during_peak?.values?.rate || 0,
        },
        recommendations: [],
    };

    // Adicionar recomendações baseadas nos resultados
    const peakP95 = data.metrics.peak_latency?.values?.['p(95)'] || 0;
    const failRate = data.metrics.errors_during_peak?.values?.count || 0;

    if (peakP95 > 1000) {
        summary.recommendations.push(
            '⚠️ Latência durante pico > 1s. Considere: autoscaling, cache, otimização de queries.'
        );
    }

    if (failRate > 100) {
        summary.recommendations.push(
            '⚠️ Muitos erros durante pico. Considere: rate limiting, circuit breaker, bulkhead pattern.'
        );
    }

    return {
        'reports/spike-test-summary.json': JSON.stringify(summary, null, 2),
        'stdout': JSON.stringify(summary, null, 2),
    };
}
