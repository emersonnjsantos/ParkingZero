# ParkingZero Load Tests - Script de Execução Completo
# Executa todos os testes de carga e gera relatórios
# Suporta testes contra servidor local ou Cloud Run (GCP)

param(
    [string]$TestType = "smoke",         # smoke, standard, spike, stress, all
    [string]$BaseUrl = "",               # URL do servidor (detecta automaticamente)
    [string]$HealthUrl = "",             # URL para health check
    [int]$Concurrency = 1000,
    [int]$Duration = 120,                # segundos
    [switch]$UseGCP = $false             # Usar servidor no GCP em vez de local
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir
$ReportsDir = Join-Path $RootDir "reports"
$K6Path = Join-Path $RootDir "bin\k6-v0.49.0-windows-amd64\k6.exe"

# Verificar se k6 existe
if (-not (Test-Path $K6Path)) {
    Write-Host "⚠️  k6 não encontrado. Baixando..." -ForegroundColor Yellow
    
    $zipPath = Join-Path $env:TEMP "k6.zip"
    $binDir = Join-Path $RootDir "bin"
    
    Invoke-WebRequest -Uri "https://github.com/grafana/k6/releases/download/v0.49.0/k6-v0.49.0-windows-amd64.zip" -OutFile $zipPath -UseBasicParsing
    Expand-Archive -Path $zipPath -DestinationPath $binDir -Force
    
    Write-Host "✅ k6 instalado com sucesso!" -ForegroundColor Green
}

# Detectar URL do servidor
if (-not $BaseUrl) {
    if ($UseGCP) {
        # Tentar obter URL do Cloud Run (requer gcloud configurado)
        try {
            $gcpUrl = gcloud run services describe parkingzero-backend --region=southamerica-east1 --format="value(status.url)" 2>$null
            if ($gcpUrl) {
                $BaseUrl = $gcpUrl
                Write-Host "🌐 Detectada URL do Cloud Run: $BaseUrl" -ForegroundColor Green
            }
        }
        catch {
            Write-Host "⚠️  Não foi possível detectar URL do Cloud Run" -ForegroundColor Yellow
            Write-Host "   Use: -BaseUrl 'https://seu-servico.run.app'" -ForegroundColor Yellow
            exit 1
        }
    }
    else {
        $BaseUrl = "http://localhost:8080"
    }
}

if (-not $HealthUrl) {
    if ($UseGCP -or $BaseUrl -match "\.run\.app") {
        # Cloud Run usa a mesma URL para health
        $HealthUrl = $BaseUrl
    }
    else {
        $HealthUrl = "http://localhost:8081"
    }
}

# Cores para output
function Write-Color($text, $color) {
    Write-Host $text -ForegroundColor $color
}

# Banner inicial
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         🚀 ParkingZero - Testes de Carga e Desempenho           ║" -ForegroundColor Cyan
Write-Host "╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
Write-Host "║  Tipo de Teste: $TestType" -ForegroundColor Cyan
Write-Host "║  URL Base: $BaseUrl" -ForegroundColor Cyan
Write-Host "║  Concorrência: $Concurrency VUs" -ForegroundColor Cyan
Write-Host "║  Duração: $Duration segundos" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Criar diretório de relatórios se não existir
if (-not (Test-Path $ReportsDir)) {
    New-Item -ItemType Directory -Path $ReportsDir -Force | Out-Null
}

# Verificar se o servidor está online
Write-Host "🏥 Verificando saúde do servidor..." -ForegroundColor Yellow

$healthEndpoint = if ($BaseUrl -match "\.run\.app") { "$BaseUrl/health" } else { "$HealthUrl/health" }

try {
    $healthResponse = Invoke-RestMethod -Uri $healthEndpoint -TimeoutSec 10
    Write-Host "✅ Servidor online: $($healthResponse.status)" -ForegroundColor Green
}
catch {
    Write-Host "❌ Servidor não está respondendo em $healthEndpoint" -ForegroundColor Red
    Write-Host "   Erro: $($_.Exception.Message)" -ForegroundColor Yellow
    
    if (-not $UseGCP) {
        Write-Host ""
        Write-Host "   💡 Se o servidor está no GCP, use:" -ForegroundColor Cyan
        Write-Host "      .\run-all-tests.ps1 -UseGCP" -ForegroundColor Cyan
        Write-Host "      ou" -ForegroundColor Cyan
        Write-Host "      .\run-all-tests.ps1 -BaseUrl 'https://seu-servico.run.app'" -ForegroundColor Cyan
    }
    exit 1
}

# Verificar status do Circuit Breaker (se disponível)
$syncEndpoint = if ($BaseUrl -match "\.run\.app") { "$BaseUrl/health/sync" } else { "$HealthUrl/health/sync" }
try {
    $syncResponse = Invoke-RestMethod -Uri $syncEndpoint -TimeoutSec 5
    Write-Host "🔌 Circuit Breaker: $($syncResponse.circuit_state)" -ForegroundColor Yellow
    if ($syncResponse.circuit_state -ne "closed") {
        Write-Host "⚠️  Circuit Breaker não está CLOSED. Resultados podem ser impactados." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "ℹ️  Endpoint de sync não disponível (normal para alguns deployments)" -ForegroundColor Gray
}

Write-Host ""

# Função para executar teste k6
function Run-K6Test {
    param(
        [string]$ScenarioName,
        [string]$ScriptPath,
        [hashtable]$EnvVars = @{}
    )
    
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "🧪 Executando: $ScenarioName" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $outputFile = Join-Path $ReportsDir "$ScenarioName`_$timestamp.json"
    
    $k6Args = @(
        "run"
        "--out", "json=$outputFile"
        "-e", "BASE_URL=$BaseUrl"
        "-e", "HEALTH_URL=$HealthUrl"
    )
    
    # Adicionar variáveis extras
    foreach ($key in $EnvVars.Keys) {
        $k6Args += "-e"
        $k6Args += "$key=$($EnvVars[$key])"
    }
    
    $k6Args += $ScriptPath
    
    $startTime = Get-Date
    
    try {
        & $K6Path @k6Args
        $exitCode = $LASTEXITCODE
    }
    catch {
        $exitCode = 1
        Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    $endTime = Get-Date
    $duration = $endTime - $startTime
    
    if ($exitCode -eq 0) {
        Write-Host "✅ $ScenarioName concluído com sucesso!" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  $ScenarioName teve alguns problemas (código: $exitCode)" -ForegroundColor Yellow
    }
    
    Write-Host "⏱️  Duração: $($duration.TotalSeconds.ToString('F2')) segundos" -ForegroundColor Yellow
    Write-Host "📄 Relatório: $outputFile" -ForegroundColor Yellow
    Write-Host ""
    
    return @{
        Scenario   = $ScenarioName
        Success    = ($exitCode -eq 0)
        Duration   = $duration
        ReportFile = $outputFile
    }
}

# Array para armazenar resultados
$results = @()

# Diretório dos cenários
$scenariosDir = Join-Path $RootDir "k6\scenarios"

switch ($TestType.ToLower()) {
    "smoke" {
        Write-Host "🔥 Modo Smoke Test: validação rápida com 10 VUs" -ForegroundColor Cyan
        
        # Executar com poucos VUs para validação
        $k6Args = @(
            "run"
            "--vus", "10"
            "--duration", "30s"
            "-e", "BASE_URL=$BaseUrl"
            "-e", "HEALTH_URL=$HealthUrl"
            "$scenariosDir\full-flow.js"
        )
        
        & $K6Path @k6Args
        
        $results += @{
            Scenario   = "smoke_test"
            Success    = ($LASTEXITCODE -eq 0)
            Duration   = [TimeSpan]::FromSeconds(30)
            ReportFile = "N/A"
        }
    }
    "standard" {
        $results += Run-K6Test -ScenarioName "full_flow" -ScriptPath "$scenariosDir\full-flow.js"
    }
    "spike" {
        $results += Run-K6Test -ScenarioName "spike_test" -ScriptPath "$scenariosDir\spike-test.js"
    }
    "stress" {
        $results += Run-K6Test -ScenarioName "stress_test" -ScriptPath "$scenariosDir\stress-test.js"
    }
    "all" {
        Write-Host "📋 Executando todos os cenários de teste..." -ForegroundColor Cyan
        Write-Host ""
        
        # 1. Smoke test (validação rápida)
        $results += Run-K6Test -ScenarioName "smoke_test" -ScriptPath "$scenariosDir\full-flow.js" -EnvVars @{
            "SCENARIO" = "smoke"
        }
        
        # 2. Standard test (carga normal)
        $results += Run-K6Test -ScenarioName "full_flow" -ScriptPath "$scenariosDir\full-flow.js"
        
        # 3. Spike test
        $results += Run-K6Test -ScenarioName "spike_test" -ScriptPath "$scenariosDir\spike-test.js"
        
        # 4. Stress test
        $results += Run-K6Test -ScenarioName "stress_test" -ScriptPath "$scenariosDir\stress-test.js"
    }
    default {
        Write-Host "❌ Tipo de teste inválido: $TestType" -ForegroundColor Red
        Write-Host "   Use: smoke, standard, spike, stress, all" -ForegroundColor Yellow
        exit 1
    }
}

# Sumário final
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                    📊 SUMÁRIO DOS TESTES                         ║" -ForegroundColor Cyan
Write-Host "╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan

$totalSuccess = 0
$totalFailed = 0

foreach ($result in $results) {
    if ($result -is [hashtable]) {
        $status = if ($result.Success) { "✅ PASS" } else { "⚠️  WARN" }
        $color = if ($result.Success) { "Green" } else { "Yellow" }
        
        Write-Host "║  $status - $($result.Scenario)" -ForegroundColor $color
        
        if ($result.Success) { $totalSuccess++ } else { $totalFailed++ }
    }
}

Write-Host "╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
Write-Host "║  Total: $($results.Count) | Sucesso: $totalSuccess | Avisos: $totalFailed" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificar saúde do servidor após os testes
Write-Host "🏥 Verificando saúde do servidor após os testes..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri $healthEndpoint -TimeoutSec 10
    Write-Host "✅ Servidor: $($healthResponse.status)" -ForegroundColor Green
}
catch {
    Write-Host "⚠️  Servidor pode estar sobrecarregado" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📁 Relatórios salvos em: $ReportsDir" -ForegroundColor Cyan
Write-Host ""

# Retornar código de saída
exit 0
