/**
 * Funções Auxiliares para Testes de Carga - ParkingZero
 */

import { check, fail } from 'k6';
import { Counter, Trend, Rate, Gauge } from 'k6/metrics';

// ==================== Métricas Customizadas ====================

// Contadores por endpoint
export const loginAttempts = new Counter('login_attempts');
export const reservationCreated = new Counter('reservation_created');
export const sponsorshipRequested = new Counter('sponsorship_requested');
export const exitVerified = new Counter('exit_verified');
export const historyFetched = new Counter('history_fetched');

// Trends (latência por endpoint)
export const loginDuration = new Trend('login_duration', true);
export const reservationDuration = new Trend('reservation_duration', true);
export const sponsorshipDuration = new Trend('sponsorship_duration', true);
export const exitDuration = new Trend('exit_duration', true);
export const historyDuration = new Trend('history_duration', true);

// Taxas de sucesso
export const loginSuccessRate = new Rate('login_success_rate');
export const reservationSuccessRate = new Rate('reservation_success_rate');
export const sponsorshipSuccessRate = new Rate('sponsorship_success_rate');
export const exitSuccessRate = new Rate('exit_success_rate');

// Gauges (valores instantâneos)
export const activeVUs = new Gauge('active_vus');
export const queueSize = new Gauge('queue_size');

// ==================== Validadores ====================

/**
 * Valida resposta de login
 */
export function validateLoginResponse(response, scenario = 'valid') {
    loginAttempts.add(1);
    loginDuration.add(response.timings.duration);

    if (scenario === 'valid') {
        const success = check(response, {
            'login: status é 200': (r) => r.status === 200,
            'login: contém token': (r) => {
                try {
                    const body = JSON.parse(r.body);
                    return body.token !== undefined || body.session_token !== undefined;
                } catch (e) {
                    return false;
                }
            },
            'login: resposta em menos de 200ms': (r) => r.timings.duration < 200,
        });
        loginSuccessRate.add(success);
        return success;
    } else {
        return check(response, {
            'login inválido: status é 401 ou 400': (r) => r.status === 401 || r.status === 400,
        });
    }
}

/**
 * Valida resposta de reserva
 */
export function validateReservationResponse(response, scenario = 'valid') {
    reservationCreated.add(1);
    reservationDuration.add(response.timings.duration);

    if (scenario === 'valid') {
        const success = check(response, {
            'reserva: status é 200': (r) => r.status === 200,
            'reserva: contém ID': (r) => {
                try {
                    const body = JSON.parse(r.body);
                    return body.id !== undefined || body.reservation_id !== undefined;
                } catch (e) {
                    return false;
                }
            },
            'reserva: resposta em menos de 400ms': (r) => r.timings.duration < 400,
        });
        reservationSuccessRate.add(success);
        return success;
    } else {
        return check(response, {
            'reserva inválida: status é 400': (r) => r.status === 400,
            'reserva inválida: contém mensagem de erro': (r) => {
                try {
                    const body = JSON.parse(r.body);
                    return body.error !== undefined || body.message !== undefined;
                } catch (e) {
                    return false;
                }
            },
        });
    }
}

/**
 * Valida resposta de pagamento/patrocínio
 */
export function validatePaymentResponse(response, scenario = 'valid') {
    sponsorshipRequested.add(1);
    sponsorshipDuration.add(response.timings.duration);

    if (scenario === 'valid') {
        const success = check(response, {
            'pagamento: status é 200': (r) => r.status === 200,
            'pagamento: sucesso é true': (r) => {
                try {
                    const body = JSON.parse(r.body);
                    return body.success === true;
                } catch (e) {
                    return false;
                }
            },
            'pagamento: resposta em menos de 500ms': (r) => r.timings.duration < 500,
        });
        sponsorshipSuccessRate.add(success);
        return success;
    } else {
        return check(response, {
            'pagamento inválido: status é 400': (r) => r.status === 400,
        });
    }
}

/**
 * Valida resposta de verificação de saída
 */
export function validateExitResponse(response) {
    exitVerified.add(1);
    exitDuration.add(response.timings.duration);

    const success = check(response, {
        'saída: status é 200': (r) => r.status === 200,
        'saída: contém autorização': (r) => {
            try {
                const body = JSON.parse(r.body);
                return body.authorized !== undefined;
            } catch (e) {
                return false;
            }
        },
        'saída: resposta em menos de 150ms': (r) => r.timings.duration < 150,
    });
    exitSuccessRate.add(success);
    return success;
}

/**
 * Valida resposta de histórico
 */
export function validateHistoryResponse(response) {
    historyFetched.add(1);
    historyDuration.add(response.timings.duration);

    return check(response, {
        'histórico: status é 200': (r) => r.status === 200,
        'histórico: contém lista': (r) => {
            try {
                const body = JSON.parse(r.body);
                return Array.isArray(body.reservations) || Array.isArray(body.history);
            } catch (e) {
                return false;
            }
        },
        'histórico: resposta em menos de 300ms': (r) => r.timings.duration < 300,
    });
}

// ==================== Geradores de Dados ====================

/**
 * Gera payload de login válido
 */
export function generateLoginPayload(email = 'teste@usuario.com', password = 'senhaSegura123') {
    return JSON.stringify({
        email: email,
        password: password,
    });
}

/**
 * Gera payload de reserva válido
 */
export function generateReservationPayload(userId, garageId, vehiclePlate) {
    const now = Math.floor(Date.now() / 1000);
    return JSON.stringify({
        user_id: userId,
        garage_id: garageId,
        vehicle_plate: vehiclePlate,
        start_time: now,
        end_time: now + 3600, // 1 hora depois
    });
}

/**
 * Gera payload de patrocínio válido
 */
export function generateSponsorshipPayload(reservationId, storeId, amount = 250.00) {
    return JSON.stringify({
        reservation_id: reservationId,
        store_id: storeId,
        invoice: {
            invoice_id: `INV_${Date.now()}`,
            amount_usd: amount,
            timestamp: Math.floor(Date.now() / 1000),
            store_name: 'Loja Teste',
        },
        amount_to_sponsor: amount * 0.1, // 10% do valor da compra
    });
}

/**
 * Gera payload de verificação de saída
 */
export function generateExitPayload(garageId, vehiclePlate) {
    return JSON.stringify({
        garage_id: garageId,
        vehicle_plate: vehiclePlate,
    });
}

// ==================== Relatórios ====================

/**
 * Gera resumo customizado
 */
export function handleSummary(data) {
    // Helper para acessar valores de métricas de forma segura (k6 não suporta optional chaining)
    function getMetricValue(metric, prop) {
        if (!data.metrics || !data.metrics[metric] || !data.metrics[metric].values) {
            return 0;
        }
        return data.metrics[metric].values[prop] || 0;
    }

    const summary = {
        timestamp: new Date().toISOString(),
        test_name: 'ParkingZero Load Test',
        metrics: {
            total_requests: getMetricValue('http_reqs', 'count'),
            failed_requests: getMetricValue('http_req_failed', 'passes'),
            avg_duration: getMetricValue('http_req_duration', 'avg'),
            p95_duration: getMetricValue('http_req_duration', 'p(95)'),
            p99_duration: getMetricValue('http_req_duration', 'p(99)'),
            rps: getMetricValue('http_reqs', 'rate'),
        },
        by_endpoint: {
            login: {
                attempts: getMetricValue('login_attempts', 'count'),
                avg_duration: getMetricValue('login_duration', 'avg'),
                success_rate: getMetricValue('login_success_rate', 'rate'),
            },
            reservation: {
                created: getMetricValue('reservation_created', 'count'),
                avg_duration: getMetricValue('reservation_duration', 'avg'),
                success_rate: getMetricValue('reservation_success_rate', 'rate'),
            },
            sponsorship: {
                requested: getMetricValue('sponsorship_requested', 'count'),
                avg_duration: getMetricValue('sponsorship_duration', 'avg'),
                success_rate: getMetricValue('sponsorship_success_rate', 'rate'),
            },
            exit: {
                verified: getMetricValue('exit_verified', 'count'),
                avg_duration: getMetricValue('exit_duration', 'avg'),
                success_rate: getMetricValue('exit_success_rate', 'rate'),
            },
        },
        thresholds: data.thresholds || {},
    };

    return {
        'reports/summary.json': JSON.stringify(summary, null, 2),
        'stdout': textSummary(data, { indent: ' ', enableColors: true }),
    };
}

/**
 * Gera resumo em texto
 */
function textSummary(data, options) {
    // Helper para acessar valores de métricas de forma segura
    function getValue(metric, prop) {
        var metrics = data.metrics || {};
        if (!metrics[metric] || !metrics[metric].values) {
            return 0;
        }
        return metrics[metric].values[prop] || 0;
    }

    var lines = [
        '',
        '╔══════════════════════════════════════════════════════════════════╗',
        '║           📊 RELATÓRIO DE TESTES DE CARGA - ParkingZero          ║',
        '╠══════════════════════════════════════════════════════════════════╣',
        '',
    ];

    lines.push('📈 MÉTRICAS GLOBAIS');
    lines.push('─'.repeat(60));
    lines.push('  Total de Requisições: ' + getValue('http_reqs', 'count'));
    lines.push('  Requisições/segundo:  ' + getValue('http_reqs', 'rate').toFixed(2));
    lines.push('  Taxa de Falha:        ' + (getValue('http_req_failed', 'rate') * 100).toFixed(2) + '%');
    lines.push('');

    lines.push('⏱️  LATÊNCIA');
    lines.push('─'.repeat(60));
    lines.push('  Média:     ' + getValue('http_req_duration', 'avg').toFixed(2) + 'ms');
    lines.push('  P50:       ' + getValue('http_req_duration', 'med').toFixed(2) + 'ms');
    lines.push('  P95:       ' + getValue('http_req_duration', 'p(95)').toFixed(2) + 'ms');
    lines.push('  P99:       ' + getValue('http_req_duration', 'p(99)').toFixed(2) + 'ms');
    lines.push('  Máximo:    ' + getValue('http_req_duration', 'max').toFixed(2) + 'ms');
    lines.push('');

    lines.push('✅ VALIDAÇÕES');
    lines.push('─'.repeat(60));
    lines.push('  Taxa de Sucesso: ' + (getValue('checks', 'rate') * 100).toFixed(2) + '%');
    lines.push('');

    lines.push('╚══════════════════════════════════════════════════════════════════╝');

    return lines.join('\n');
}
