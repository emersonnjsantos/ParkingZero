# ParkingZero Load Tests - Análise de Resultados
# Analisa os relatórios JSON gerados pelos testes k6 e gera relatório consolidado

param(
    [string]$ReportsDir = (Join-Path $PSScriptRoot "..\reports"),
    [string]$OutputFile = "analysis_report.html"
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         📊 Analisador de Resultados de Testes de Carga          ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificar se existem relatórios
if (-not (Test-Path $ReportsDir)) {
    Write-Host "❌ Diretório de relatórios não encontrado: $ReportsDir" -ForegroundColor Red
    exit 1
}

$jsonFiles = Get-ChildItem -Path $ReportsDir -Filter "*.json" | Sort-Object LastWriteTime -Descending
if ($jsonFiles.Count -eq 0) {
    Write-Host "⚠️  Nenhum relatório encontrado em: $ReportsDir" -ForegroundColor Yellow
    Write-Host "   Execute os testes primeiro: .\run-all-tests.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "📁 Encontrados $($jsonFiles.Count) relatório(s) para análise" -ForegroundColor Green
Write-Host ""

# Função para analisar arquivo JSON do k6
function Analyze-K6Report {
    param([string]$FilePath)
    
    $fileName = Split-Path $FilePath -Leaf
    Write-Host "🔍 Analisando: $fileName" -ForegroundColor Yellow
    
    $content = Get-Content $FilePath -Raw
    $lines = $content -split "`n" | Where-Object { $_.Trim() -ne "" }
    
    # Métricas acumuladas
    $metrics = @{
        TotalRequests  = 0
        FailedRequests = 0
        Latencies      = @()
        StartTime      = $null
        EndTime        = $null
        ByEndpoint     = @{}
        HttpCodes      = @{}
    }
    
    foreach ($line in $lines) {
        try {
            $data = $line | ConvertFrom-Json -ErrorAction SilentlyContinue
            if (-not $data) { continue }
            
            # Processar diferentes tipos de métricas
            switch ($data.type) {
                "Point" {
                    if ($data.metric -eq "http_req_duration") {
                        $metrics.Latencies += $data.data.value
                    }
                    if ($data.metric -eq "http_reqs") {
                        $metrics.TotalRequests++
                    }
                    if ($data.metric -eq "http_req_failed" -and $data.data.value -eq 1) {
                        $metrics.FailedRequests++
                    }
                    
                    # Por endpoint
                    if ($data.data.tags -and $data.data.tags.endpoint) {
                        $endpoint = $data.data.tags.endpoint
                        if (-not $metrics.ByEndpoint.ContainsKey($endpoint)) {
                            $metrics.ByEndpoint[$endpoint] = @{
                                Count     = 0
                                Latencies = @()
                                Errors    = 0
                            }
                        }
                        $metrics.ByEndpoint[$endpoint].Count++
                        if ($data.metric -eq "http_req_duration") {
                            $metrics.ByEndpoint[$endpoint].Latencies += $data.data.value
                        }
                    }
                }
                "Metric" {
                    # Resumo final da métrica
                }
            }
            
            # Timestamps
            if ($data.data -and $data.data.time) {
                $timestamp = $data.data.time
                if (-not $metrics.StartTime -or $timestamp -lt $metrics.StartTime) {
                    $metrics.StartTime = $timestamp
                }
                if (-not $metrics.EndTime -or $timestamp -gt $metrics.EndTime) {
                    $metrics.EndTime = $timestamp
                }
            }
        }
        catch {
            # Ignorar linhas inválidas
        }
    }
    
    # Calcular estatísticas
    $sortedLatencies = $metrics.Latencies | Sort-Object
    $count = $sortedLatencies.Count
    
    if ($count -gt 0) {
        $metrics.AvgLatency = ($sortedLatencies | Measure-Object -Average).Average
        $metrics.MinLatency = $sortedLatencies[0]
        $metrics.MaxLatency = $sortedLatencies[-1]
        $metrics.P50Latency = $sortedLatencies[[int]($count * 0.50)]
        $metrics.P95Latency = $sortedLatencies[[int]($count * 0.95)]
        $metrics.P99Latency = $sortedLatencies[[int]($count * 0.99)]
    }
    
    $metrics.SuccessRate = if ($metrics.TotalRequests -gt 0) {
        (($metrics.TotalRequests - $metrics.FailedRequests) / $metrics.TotalRequests) * 100
    }
    else { 0 }
    
    return @{
        FileName = $fileName
        Metrics  = $metrics
    }
}

# Analisar todos os relatórios
$analyses = @()
foreach ($file in $jsonFiles) {
    $analysis = Analyze-K6Report -FilePath $file.FullName
    $analyses += $analysis
}

# Gerar relatório HTML
$htmlOutput = @"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkingZero - Relatório de Testes de Carga</title>
    <style>
        :root {
            --primary: #6366f1;
            --success: #22c55e;
            --warning: #f59e0b;
            --danger: #ef4444;
            --dark: #1e293b;
            --light: #f8fafc;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: var(--light);
            min-height: 100vh;
            padding: 2rem;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .header h1 {
            font-size: 2.5rem;
            background: linear-gradient(90deg, #6366f1, #8b5cf6, #a855f7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }
        
        .header p {
            color: #94a3b8;
        }
        
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .card {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 16px;
            padding: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
        }
        
        .card h3 {
            color: #94a3b8;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }
        
        .card .value {
            font-size: 2rem;
            font-weight: bold;
        }
        
        .card.success .value { color: var(--success); }
        .card.warning .value { color: var(--warning); }
        .card.danger .value { color: var(--danger); }
        
        .table-container {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 16px;
            padding: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 2rem;
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        th {
            color: #94a3b8;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
        }
        
        tr:hover {
            background: rgba(255, 255, 255, 0.02);
        }
        
        .badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .badge.success { background: rgba(34, 197, 94, 0.2); color: var(--success); }
        .badge.warning { background: rgba(245, 158, 11, 0.2); color: var(--warning); }
        .badge.danger { background: rgba(239, 68, 68, 0.2); color: var(--danger); }
        
        .recommendations {
            background: rgba(99, 102, 241, 0.1);
            border-radius: 16px;
            padding: 2rem;
            border: 1px solid rgba(99, 102, 241, 0.3);
        }
        
        .recommendations h2 {
            margin-bottom: 1rem;
        }
        
        .recommendations ul {
            list-style: none;
            padding: 0;
        }
        
        .recommendations li {
            padding: 0.75rem 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
        }
        
        .recommendations li:last-child {
            border-bottom: none;
        }
        
        .icon {
            font-size: 1.25rem;
        }
        
        footer {
            text-align: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #64748b;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 ParkingZero - Relatório de Testes de Carga</h1>
            <p>Gerado em: $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")</p>
        </div>
"@

# Adicionar métricas consolidadas
$totalRequests = ($analyses | ForEach-Object { $_.Metrics.TotalRequests } | Measure-Object -Sum).Sum
$totalFailed = ($analyses | ForEach-Object { $_.Metrics.FailedRequests } | Measure-Object -Sum).Sum
$avgLatency = if ($analyses.Count -gt 0) {
    ($analyses | Where-Object { $_.Metrics.AvgLatency } | ForEach-Object { $_.Metrics.AvgLatency } | Measure-Object -Average).Average
}
else { 0 }
$avgSuccessRate = if ($analyses.Count -gt 0) {
    ($analyses | ForEach-Object { $_.Metrics.SuccessRate } | Measure-Object -Average).Average
}
else { 0 }

$successClass = if ($avgSuccessRate -ge 99) { "success" } elseif ($avgSuccessRate -ge 95) { "warning" } else { "danger" }
$latencyClass = if ($avgLatency -lt 200) { "success" } elseif ($avgLatency -lt 500) { "warning" } else { "danger" }

$htmlOutput += @"
        <div class="grid">
            <div class="card $successClass">
                <h3>Taxa de Sucesso</h3>
                <div class="value">$([math]::Round($avgSuccessRate, 2))%</div>
            </div>
            <div class="card $latencyClass">
                <h3>Latência Média</h3>
                <div class="value">$([math]::Round($avgLatency, 2))ms</div>
            </div>
            <div class="card">
                <h3>Total de Requisições</h3>
                <div class="value" style="color: var(--primary);">$totalRequests</div>
            </div>
            <div class="card">
                <h3>Testes Executados</h3>
                <div class="value" style="color: var(--primary);">$($analyses.Count)</div>
            </div>
        </div>
        
        <div class="table-container">
            <h2 style="margin-bottom: 1rem;">📈 Resultados por Teste</h2>
            <table>
                <thead>
                    <tr>
                        <th>Teste</th>
                        <th>Requisições</th>
                        <th>Taxa de Sucesso</th>
                        <th>Latência Média</th>
                        <th>P95</th>
                        <th>P99</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
"@

foreach ($analysis in $analyses) {
    $m = $analysis.Metrics
    $statusClass = if ($m.SuccessRate -ge 99 -and $m.P95Latency -lt 500) { "success" } 
    elseif ($m.SuccessRate -ge 95) { "warning" } 
    else { "danger" }
    $statusText = if ($statusClass -eq "success") { "PASS" } elseif ($statusClass -eq "warning") { "WARN" } else { "FAIL" }
    
    $htmlOutput += @"
                    <tr>
                        <td>$($analysis.FileName)</td>
                        <td>$($m.TotalRequests)</td>
                        <td>$([math]::Round($m.SuccessRate, 2))%</td>
                        <td>$([math]::Round($m.AvgLatency, 2))ms</td>
                        <td>$([math]::Round($m.P95Latency, 2))ms</td>
                        <td>$([math]::Round($m.P99Latency, 2))ms</td>
                        <td><span class="badge $statusClass">$statusText</span></td>
                    </tr>
"@
}

$htmlOutput += @"
                </tbody>
            </table>
        </div>
"@

# Gerar recomendações
$recommendations = @()

if ($avgSuccessRate -lt 99) {
    $recommendations += @{
        Icon = "⚠️"
        Text = "Taxa de sucesso ($([math]::Round($avgSuccessRate, 2))%) abaixo do ideal (99%). Investigue erros de timeout, conexões rejeitadas ou erros de aplicação."
    }
}

if ($avgLatency -gt 500) {
    $recommendations += @{
        Icon = "🐌"
        Text = "Latência média ($([math]::Round($avgLatency, 2))ms) acima do SLA (500ms). Considere otimização de queries, caching ou escalonamento horizontal."
    }
}

# Analisar endpoints mais lentos
$slowEndpoints = @()
foreach ($analysis in $analyses) {
    foreach ($endpoint in $analysis.Metrics.ByEndpoint.Keys) {
        $endpointData = $analysis.Metrics.ByEndpoint[$endpoint]
        if ($endpointData.Latencies.Count -gt 0) {
            $avgEndpointLatency = ($endpointData.Latencies | Measure-Object -Average).Average
            if ($avgEndpointLatency -gt 300) {
                $slowEndpoints += @{
                    Name    = $endpoint
                    Latency = $avgEndpointLatency
                }
            }
        }
    }
}

if ($slowEndpoints.Count -gt 0) {
    $slowList = ($slowEndpoints | ForEach-Object { "$($_.Name): $([math]::Round($_.Latency, 0))ms" }) -join ", "
    $recommendations += @{
        Icon = "🎯"
        Text = "Endpoints com latência elevada: $slowList. Priorize otimização destes endpoints."
    }
}

if ($recommendations.Count -eq 0) {
    $recommendations += @{
        Icon = "✅"
        Text = "Todos os indicadores estão dentro dos parâmetros esperados. Sistema está bem dimensionado para a carga testada."
    }
}

$htmlOutput += @"
        <div class="recommendations">
            <h2>💡 Recomendações</h2>
            <ul>
"@

foreach ($rec in $recommendations) {
    $htmlOutput += @"
                <li>
                    <span class="icon">$($rec.Icon)</span>
                    <span>$($rec.Text)</span>
                </li>
"@
}

$htmlOutput += @"
            </ul>
        </div>
        
        <footer>
            <p>ParkingZero Load Testing Suite | Relatório gerado automaticamente</p>
        </footer>
    </div>
</body>
</html>
"@

# Salvar relatório HTML
$outputPath = Join-Path $ReportsDir $OutputFile
$htmlOutput | Out-File -FilePath $outputPath -Encoding utf8

Write-Host ""
Write-Host "✅ Relatório gerado com sucesso!" -ForegroundColor Green
Write-Host "📄 Arquivo: $outputPath" -ForegroundColor Cyan
Write-Host ""

# Abrir no navegador
$openBrowser = Read-Host "Deseja abrir o relatório no navegador? (S/N)"
if ($openBrowser -eq "S" -or $openBrowser -eq "s") {
    Start-Process $outputPath
}
