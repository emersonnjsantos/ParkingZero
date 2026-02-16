/**
 * ParkingZero - Smoke Test Simples
 * Testa apenas o health check HTTP para validar conectividade
 */

import http from 'k6/http';
import { check, sleep } from 'k6';

// URL do servidor no Cloud Run
const GCP_HOST = 'parkingzero-backend-565100147812.southamerica-east1.run.app';
const BASE_URL = __ENV.BASE_URL || 'https://' + GCP_HOST;

export const options = {
    vus: 5,
    duration: '15s',
    thresholds: {
        http_req_duration: ['p(95)<2000'],  // 2s para Cloud Run cold start
        http_req_failed: ['rate<0.5'],       // Menos de 50% de falha
    },
};

export default function () {
    console.log('🔍 Testando: ' + BASE_URL);

    // Test 1: Root endpoint
    var resRoot = http.get(BASE_URL + '/');
    check(resRoot, {
        'root: responde': (r) => r.status !== 0,
        'root: não é timeout': (r) => r.timings.duration < 30000,
    });
    console.log('Root status: ' + resRoot.status + ' - ' + resRoot.timings.duration + 'ms');

    // Test 2: Health endpoint (se existir)
    var resHealth = http.get(BASE_URL + '/health');
    check(resHealth, {
        'health: responde': (r) => r.status !== 0,
    });
    console.log('Health status: ' + resHealth.status + ' - ' + resHealth.timings.duration + 'ms');

    // Test 3: gRPC-Web preflight (OPTIONS)
    var resOptions = http.options(BASE_URL + '/parking.ParkingService/SearchGarages', null, {
        headers: {
            'Origin': 'https://parkingzero.app',
            'Access-Control-Request-Method': 'POST',
        },
    });
    console.log('gRPC OPTIONS status: ' + resOptions.status);

    sleep(1);
}

export function handleSummary(data) {
    var metrics = data.metrics || {};
    var httpReqs = metrics.http_reqs || { values: {} };
    var httpDuration = metrics.http_req_duration || { values: {} };
    var httpFailed = metrics.http_req_failed || { values: {} };

    var summary = [
        '',
        '╔══════════════════════════════════════════════════════════════════╗',
        '║           🏥 SMOKE TEST - ParkingZero Cloud Run                  ║',
        '╠══════════════════════════════════════════════════════════════════╣',
        '',
        '📊 RESULTADOS:',
        '─'.repeat(60),
        '  Total de Requisições: ' + (httpReqs.values.count || 0),
        '  Requisições/segundo:  ' + (httpReqs.values.rate || 0).toFixed(2),
        '  Taxa de Falha:        ' + ((httpFailed.values.rate || 0) * 100).toFixed(2) + '%',
        '',
        '⏱️  LATÊNCIA:',
        '─'.repeat(60),
        '  Média:     ' + (httpDuration.values.avg || 0).toFixed(2) + 'ms',
        '  P95:       ' + (httpDuration.values['p(95)'] || 0).toFixed(2) + 'ms',
        '  Máximo:    ' + (httpDuration.values.max || 0).toFixed(2) + 'ms',
        '',
        '╚══════════════════════════════════════════════════════════════════╝',
    ];

    return {
        'stdout': summary.join('\n'),
    };
}
