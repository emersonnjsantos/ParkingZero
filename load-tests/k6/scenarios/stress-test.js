/**
 * ParkingZero - Teste de Estresse (Stress Test)
 * 
 * Objetivo: Encontrar o ponto de ruptura do sistema.
 * Este teste aumenta gradualmente a carga até o sistema começar a falhar.
 * 
 * Cenário:
 * - Aumentar carga progressivamente: 500 → 1000 → 1500 → 2000 VUs
 * - Identificar quando o sistema começa a degradar
 * - Medir tempo de recuperação
 */

import http from 'k6/http';
import { check, sleep, group } from 'k6';
import { Counter, Trend, Rate, Gauge } from 'k6/metrics';

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
    generateSponsorshipPayload,
    generateExitPayload,
} from '../utils/helpers.js';

// ==================== Métricas Customizadas ====================
const stressLatency = new Trend('stress_latency');
const errorCount = new Counter('error_count');
const successRate = new Rate('success_rate');
const breakingPointVUs = new Gauge('breaking_point_vus');
const systemStatus = new Gauge('system_status'); // 0=healthy, 1=degraded, 2=down

// Métricas por fase de carga
const phase500Latency = new Trend('phase_500_latency');
const phase1000Latency = new Trend('phase_1000_latency');
const phase1500Latency = new Trend('phase_1500_latency');
const phase2000Latency = new Trend('phase_2000_latency');

// ==================== Opções do Teste ====================
export const options = {
    scenarios: {
        stress_test: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: SCENARIO_CONFIGS.stress.stages,
            gracefulRampDown: '30s',
        },
    },

    thresholds: {
        // Thresholds graduais
        http_req_duration: ['p(95)<2000'],  // 2s máximo
        http_req_failed: ['rate<0.10'],     // Até 10% de falha
        checks: ['rate>0.90'],

        // Por fase
        phase_500_latency: ['p(95)<500'],
        phase_1000_latency: ['p(95)<800'],
        phase_1500_latency: ['p(95)<1200'],
        phase_2000_latency: ['p(95)<2000'],
    },

    tags: {
        test_name: 'stress_test',
        environment: __ENV.ENVIRONMENT || 'development',
    },
};

// ==================== Estado Global ====================
let maxVUsReached = 0;
let breakingPointDetected = false;
let lastHealthyVUs = 0;

// ==================== Setup ====================
export function setup() {
    console.log('💪 Iniciando Teste de Estresse');
    console.log('📊 Objetivo: Encontrar o ponto de ruptura do sistema');
    console.log('📈 Fases: 500 → 1000 → 1500 → 2000 VUs');

    // Status inicial do sistema
    const healthRes = http.get(`${HEALTH_URL}/health`);
    const syncRes = http.get(`${HEALTH_URL}/health/sync`);

    console.log(`🏥 Status Inicial: ${healthRes.status === 200 ? 'SAUDÁVEL' : 'ALERTA'}`);

    return {
        startTime: new Date().toISOString(),
        testUsers: TEST_USERS,
        testGarages: TEST_GARAGES,
        phases: {
            500: { startTime: null, errors: 0, requests: 0 },
            1000: { startTime: null, errors: 0, requests: 0 },
            1500: { startTime: null, errors: 0, requests: 0 },
            2000: { startTime: null, errors: 0, requests: 0 },
        },
    };
}

// ==================== Função Auxiliar: Determinar Fase ====================
function getCurrentPhase(vus) {
    if (vus >= 1750) return 2000;
    if (vus >= 1250) return 1500;
    if (vus >= 750) return 1000;
    return 500;
}

function getPhaseLatencyMetric(phase) {
    switch (phase) {
        case 2000: return phase2000Latency;
        case 1500: return phase1500Latency;
        case 1000: return phase1000Latency;
        default: return phase500Latency;
    }
}

// ==================== Função Principal ====================
export default function (data) {
    const user = randomFromArray(data.testUsers);
    const garage = randomFromArray(data.testGarages);
    const vehiclePlate = generatePlate();
    const currentVUs = __VU;
    const currentPhase = getCurrentPhase(currentVUs);
    const phaseLatencyMetric = getPhaseLatencyMetric(currentPhase);

    // Atualizar máximo de VUs
    if (currentVUs > maxVUsReached) {
        maxVUsReached = currentVUs;
    }

    let allSuccess = true;

    // ==================== 1. Health Check (Monitoramento Contínuo) ====================
    group('stress_health', function () {
        const res = http.get(`${HEALTH_URL}/health/sync`, {
            tags: { endpoint: 'health', phase: `${currentPhase}` },
            timeout: '5s',
        });

        try {
            const syncData = JSON.parse(res.body);
            const circuitState = syncData.circuit_state;

            if (circuitState === 'open') {
                systemStatus.add(2); // DOWN
                if (!breakingPointDetected) {
                    breakingPointDetected = true;
                    breakingPointVUs.add(currentVUs);
                    console.log(`🔴 PONTO DE RUPTURA DETECTADO @ ${currentVUs} VUs`);
                    console.log(`   Circuit Breaker: OPEN`);
                }
            } else if (circuitState === 'half-open') {
                systemStatus.add(1); // DEGRADED
            } else {
                systemStatus.add(0); // HEALTHY
                if (!breakingPointDetected) {
                    lastHealthyVUs = currentVUs;
                }
            }
        } catch (e) {
            systemStatus.add(2);
        }
    });

    // ==================== 2. Login Sob Estresse ====================
    group('stress_login', function () {
        const payload = generateLoginPayload(user.email, user.password);
        const start = Date.now();

        const res = http.post(`${BASE_URL}/auth/login`, payload, {
            headers: DEFAULT_HEADERS,
            tags: { endpoint: 'login', phase: `${currentPhase}` },
            timeout: '15s',
        });

        const duration = Date.now() - start;
        stressLatency.add(duration);
        phaseLatencyMetric.add(duration);

        const success = check(res, {
            'stress_login: resposta válida': (r) => r.status === 200 || r.status === 429 || r.status === 503,
            'stress_login: não timeout': (r) => r.timings.duration < 15000,
        });

        if (!success) {
            errorCount.add(1);
            allSuccess = false;
        }
        successRate.add(success);
    });

    sleep(0.05);

    // ==================== 3. Reserva Sob Estresse ====================
    group('stress_reservation', function () {
        const payload = generateReservationPayload(user.userId, garage.id, vehiclePlate);
        const start = Date.now();

        const res = http.post(`${BASE_URL}/parking/reserve`, payload, {
            headers: getAuthHeaders(user.userId),
            tags: { endpoint: 'reserve', phase: `${currentPhase}` },
            timeout: '15s',
        });

        const duration = Date.now() - start;
        stressLatency.add(duration);
        phaseLatencyMetric.add(duration);

        const success = check(res, {
            'stress_reserve: resposta válida': (r) => r.status === 200 || r.status === 400 || r.status === 429 || r.status === 503,
        });

        if (!success) {
            errorCount.add(1);
            allSuccess = false;
        }
        successRate.add(success);
    });

    sleep(0.05);

    // ==================== 4. Pagamento Sob Estresse ====================
    group('stress_payment', function () {
        const storePartner = TEST_USERS.find(u => u.role === 'PARTNER_STORE') || { userId: 'store_001' };
        const payload = generateSponsorshipPayload(`res_${__VU}_${__ITER}`, storePartner.userId);
        const start = Date.now();

        const res = http.post(`${BASE_URL}/parking/pay`, payload, {
            headers: getAuthHeaders(user.userId),
            tags: { endpoint: 'pay', phase: `${currentPhase}` },
            timeout: '20s',
        });

        const duration = Date.now() - start;
        stressLatency.add(duration);
        phaseLatencyMetric.add(duration);

        const success = check(res, {
            'stress_pay: resposta válida': (r) => r.status === 200 || r.status === 400 || r.status === 429 || r.status === 503,
        });

        if (!success) {
            errorCount.add(1);
            allSuccess = false;
        }
        successRate.add(success);
    });

    sleep(0.05);

    // ==================== 5. Verificar Saída Sob Estresse ====================
    group('stress_exit', function () {
        const payload = generateExitPayload(garage.id, vehiclePlate);
        const start = Date.now();

        const res = http.post(`${BASE_URL}/parking/verify-exit`, payload, {
            headers: getAuthHeaders(user.userId),
            tags: { endpoint: 'verify_exit', phase: `${currentPhase}` },
            timeout: '10s',
        });

        const duration = Date.now() - start;
        stressLatency.add(duration);
        phaseLatencyMetric.add(duration);

        const success = check(res, {
            'stress_exit: resposta válida': (r) => r.status === 200 || r.status === 400 || r.status === 429 || r.status === 503,
        });

        if (!success) {
            errorCount.add(1);
            allSuccess = false;
        }
        successRate.add(success);
    });

    // Think time mínimo para maximizar estresse
    sleep(0.1);
}

// ==================== Teardown ====================
export function teardown(data) {
    console.log('');
    console.log('═══════════════════════════════════════════════════════════════');
    console.log('💪 TESTE DE ESTRESSE FINALIZADO');
    console.log('═══════════════════════════════════════════════════════════════');
    console.log(`⏱️  Duração: ${data.startTime} → ${new Date().toISOString()}`);
    console.log(`📊 Máximo de VUs alcançado: ${maxVUsReached}`);
    console.log(`🔴 Ponto de ruptura detectado: ${breakingPointDetected ? 'SIM' : 'NÃO'}`);
    console.log(`💚 Último estado saudável: ${lastHealthyVUs} VUs`);
    console.log('═══════════════════════════════════════════════════════════════');
}

// ==================== Resumo Customizado ====================
export function handleSummary(data) {
    const summary = {
        timestamp: new Date().toISOString(),
        test_name: 'Stress Test',
        breaking_point: {
            detected: breakingPointDetected,
            vus: breakingPointDetected ? data.metrics.breaking_point_vus?.values?.value : null,
            last_healthy_vus: lastHealthyVUs,
            max_vus_reached: maxVUsReached,
        },
        performance_by_phase: {
            '500_vus': {
                latency_p95: data.metrics.phase_500_latency?.values?.['p(95)'] || 0,
                latency_avg: data.metrics.phase_500_latency?.values?.avg || 0,
            },
            '1000_vus': {
                latency_p95: data.metrics.phase_1000_latency?.values?.['p(95)'] || 0,
                latency_avg: data.metrics.phase_1000_latency?.values?.avg || 0,
            },
            '1500_vus': {
                latency_p95: data.metrics.phase_1500_latency?.values?.['p(95)'] || 0,
                latency_avg: data.metrics.phase_1500_latency?.values?.avg || 0,
            },
            '2000_vus': {
                latency_p95: data.metrics.phase_2000_latency?.values?.['p(95)'] || 0,
                latency_avg: data.metrics.phase_2000_latency?.values?.avg || 0,
            },
        },
        overall: {
            total_requests: data.metrics.http_reqs?.values?.count || 0,
            total_errors: data.metrics.error_count?.values?.count || 0,
            success_rate: ((data.metrics.success_rate?.values?.rate || 0) * 100).toFixed(2) + '%',
            avg_latency: (data.metrics.stress_latency?.values?.avg || 0).toFixed(2) + 'ms',
            p95_latency: (data.metrics.stress_latency?.values?.['p(95)'] || 0).toFixed(2) + 'ms',
            p99_latency: (data.metrics.stress_latency?.values?.['p(99)'] || 0).toFixed(2) + 'ms',
        },
        recommendations: generateRecommendations(data),
    };

    return {
        'reports/stress-test-summary.json': JSON.stringify(summary, null, 2),
        'stdout': generateTextReport(summary),
    };
}

function generateRecommendations(data) {
    const recommendations = [];

    // Analisar resultados e gerar recomendações
    const errorRate = 1 - (data.metrics.success_rate?.values?.rate || 1);
    const p95 = data.metrics.stress_latency?.values?.['p(95)'] || 0;

    if (breakingPointDetected) {
        recommendations.push({
            severity: 'HIGH',
            area: 'Escalabilidade',
            message: `Sistema atingiu ponto de ruptura em ${lastHealthyVUs} VUs. ` +
                `Considere: horizontal scaling, cache distribuído, database connection pooling.`,
        });
    }

    if (errorRate > 0.05) {
        recommendations.push({
            severity: 'MEDIUM',
            area: 'Resiliência',
            message: `Taxa de erro ${(errorRate * 100).toFixed(2)}% acima do ideal. ` +
                `Considere: circuit breaker, retry policies, graceful degradation.`,
        });
    }

    if (p95 > 1000) {
        recommendations.push({
            severity: 'MEDIUM',
            area: 'Performance',
            message: `P95 de latência ${p95.toFixed(0)}ms acima do SLA. ` +
                `Considere: query optimization, caching, async processing.`,
        });
    }

    // Comparar fases
    const phase500P95 = data.metrics.phase_500_latency?.values?.['p(95)'] || 0;
    const phase2000P95 = data.metrics.phase_2000_latency?.values?.['p(95)'] || 0;

    if (phase2000P95 > phase500P95 * 4) {
        recommendations.push({
            severity: 'HIGH',
            area: 'Escalabilidade Linear',
            message: `Latência cresceu ${(phase2000P95 / phase500P95).toFixed(1)}x entre 500→2000 VUs. ` +
                `Sistema não escala linearmente. Investigar bottlenecks.`,
        });
    }

    return recommendations;
}

function generateTextReport(summary) {
    const lines = [
        '',
        '╔══════════════════════════════════════════════════════════════════╗',
        '║         💪 RELATÓRIO DE TESTE DE ESTRESSE - ParkingZero          ║',
        '╠══════════════════════════════════════════════════════════════════╣',
        '',
        '📊 PONTO DE RUPTURA',
        '─'.repeat(60),
        `  Detectado: ${summary.breaking_point.detected ? '🔴 SIM' : '🟢 NÃO'}`,
        `  Máximo de VUs: ${summary.breaking_point.max_vus_reached}`,
        `  Último estado saudável: ${summary.breaking_point.last_healthy_vus} VUs`,
        '',
        '📈 PERFORMANCE POR FASE',
        '─'.repeat(60),
        `  500 VUs:  P95=${summary.performance_by_phase['500_vus'].latency_p95.toFixed(0)}ms`,
        `  1000 VUs: P95=${summary.performance_by_phase['1000_vus'].latency_p95.toFixed(0)}ms`,
        `  1500 VUs: P95=${summary.performance_by_phase['1500_vus'].latency_p95.toFixed(0)}ms`,
        `  2000 VUs: P95=${summary.performance_by_phase['2000_vus'].latency_p95.toFixed(0)}ms`,
        '',
        '🎯 MÉTRICAS GERAIS',
        '─'.repeat(60),
        `  Total de Requisições: ${summary.overall.total_requests}`,
        `  Total de Erros: ${summary.overall.total_errors}`,
        `  Taxa de Sucesso: ${summary.overall.success_rate}`,
        `  Latência Média: ${summary.overall.avg_latency}`,
        `  Latência P95: ${summary.overall.p95_latency}`,
        '',
        '💡 RECOMENDAÇÕES',
        '─'.repeat(60),
    ];

    for (const rec of summary.recommendations) {
        const icon = rec.severity === 'HIGH' ? '🔴' : rec.severity === 'MEDIUM' ? '🟡' : '🟢';
        lines.push(`  ${icon} [${rec.area}] ${rec.message}`);
    }

    if (summary.recommendations.length === 0) {
        lines.push('  ✅ Nenhuma recomendação crítica. Sistema bem dimensionado!');
    }

    lines.push('');
    lines.push('╚══════════════════════════════════════════════════════════════════╝');

    return lines.join('\n');
}
