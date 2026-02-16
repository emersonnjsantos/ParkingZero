/**
 * ParkingZero - Teste de Carga gRPC
 * Usa k6 com módulo experimental gRPC
 */

import grpc from 'k6/net/grpc';
import { check, sleep } from 'k6';

// Configuração do servidor gRPC
const GCP_HOST = 'parkingzero-backend-565100147812.southamerica-east1.run.app:443';

// Cliente gRPC
const client = new grpc.Client();

// Carregar proto (se disponível localmente)
// client.load(['../../../protos'], 'parking_service.proto');

export const options = {
    vus: 5,
    duration: '15s',
    thresholds: {
        grpc_req_duration: ['p(95)<2000'],
    },
};

export default function () {
    // Conectar ao servidor gRPC
    if (__ITER === 0) {
        client.connect(GCP_HOST, {
            plaintext: false,  // TLS enabled
            timeout: '10s',
        });
    }

    // Chamar SearchGarages
    const searchRequest = {
        latitude: -23.5505,
        longitude: -46.6333,
        radius_meters: 5000,
    };

    try {
        const response = client.invoke('parking.ParkingService/SearchGarages', searchRequest);

        check(response, {
            'gRPC status OK': (r) => r && r.status === grpc.StatusOK,
            'tem garagens': (r) => r && r.message && r.message.garages,
        });

        console.log('SearchGarages: status=' + (response ? response.status : 'null'));
    } catch (e) {
        console.log('Erro gRPC: ' + e.message);
    }

    sleep(0.5);
}

export function teardown() {
    client.close();
}

export function handleSummary(data) {
    var metrics = data.metrics || {};
    var grpcReqs = metrics.grpc_req_duration || { values: {} };

    var summary = [
        '',
        '╔══════════════════════════════════════════════════════════════════╗',
        '║           🚀 gRPC LOAD TEST - ParkingZero                        ║',
        '╠══════════════════════════════════════════════════════════════════╣',
        '',
        '📊 RESULTADOS gRPC:',
        '─'.repeat(60),
        '  Latência Média: ' + (grpcReqs.values.avg || 0).toFixed(2) + 'ms',
        '  P95:            ' + (grpcReqs.values['p(95)'] || 0).toFixed(2) + 'ms',
        '',
        '╚══════════════════════════════════════════════════════════════════╝',
    ];

    return {
        'stdout': summary.join('\n'),
    };
}
