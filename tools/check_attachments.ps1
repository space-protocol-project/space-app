param(
    [string]$DatabaseUrl = $env:SPACE_TEST_DATABASE_URL,
    [string]$PostgresBin = $env:SPACE_TEST_POSTGRES_BIN,
    [string]$OutputDirectory = $env:TEMP,
    [ValidateSet("attachments","mls","desktop")][string]$Scenario="attachments"
)

$ErrorActionPreference = 'Stop'

function Get-FreePort {
    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, 0)
    $listener.Start()
    $port = $listener.LocalEndpoint.Port
    $listener.Stop()
    return $port
}

function Wait-TestServer($process, [string]$origin) {
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    while ($timer.Elapsed.TotalSeconds -lt 30) {
        if ($process.HasExited) { throw 'Тестовый сервер завершился до запуска. Проверьте server.stderr.log.' }
        try {
            $response = Invoke-WebRequest "$origin/.well-known/space-protocol" -TimeoutSec 1
            if ($response.StatusCode -eq 200) { return ($response.Content | ConvertFrom-Json) }
        } catch { Start-Sleep -Milliseconds 200 }
    }
    throw 'Тестовый сервер не запустился за 30 секунд.'
}

if (!$DatabaseUrl -or !$PostgresBin) {
    throw 'Задайте SPACE_TEST_DATABASE_URL и SPACE_TEST_POSTGRES_BIN для отдельной локальной PostgreSQL.'
}
$databaseUri = [uri]$DatabaseUrl
if ($databaseUri.Host -notin @('127.0.0.1', 'localhost', '[::1]', '::1')) {
    throw 'Проверка разрешена только с локальной тестовой PostgreSQL.'
}
if ($databaseUri.Query -match 'search_path') { throw 'URL тестовой PostgreSQL не должен содержать search_path.' }
$psql = Join-Path $PostgresBin 'psql.exe'
if (!(Test-Path -LiteralPath $psql)) { throw 'Не найден psql.exe.' }
$appRoot = Split-Path $PSScriptRoot -Parent
$serverRoot = Join-Path (Split-Path $appRoot -Parent) 'space-server'
if (!(Test-Path -LiteralPath (Join-Path $serverRoot 'go.mod'))) { throw 'Рядом с space-app нужен checkout space-server.' }
$schema = 'space_v03_' + [guid]::NewGuid().ToString('N')
$work = Join-Path $OutputDirectory $schema
New-Item -ItemType Directory -Path $work | Out-Null
$serverExe = Join-Path $work 'space-server.exe'
$created = $false
$server = $null
$previousDatabase = $env:SPACE_DATABASE_URL
$previousOrigin = $env:SPACE_ATTACHMENTS_TEST_ORIGIN
$previousMlsOrigin=$env:SPACE_MLS_TEST_ORIGIN
$previousDesktopOrigin=$env:SPACE_DESKTOP_CHAT_TEST_ORIGIN
try {
    & $psql $DatabaseUrl -X -q -v ON_ERROR_STOP=1 -c "CREATE SCHEMA $schema"
    if ($LASTEXITCODE -ne 0) { throw 'Не удалось создать отдельную тестовую схему.' }
    $created = $true
    Push-Location $serverRoot
    try {
        go build -o $serverExe ./cmd/space-server
        if ($LASTEXITCODE -ne 0) { throw 'Сборка тестового сервера завершилась ошибкой.' }
    } finally { Pop-Location }
    $separator = if ($DatabaseUrl.Contains('?')) { '&' } else { '?' }
    $env:SPACE_DATABASE_URL = $DatabaseUrl + $separator + 'search_path=' + $schema
    $httpPort = Get-FreePort
    $grpcPort = Get-FreePort
    while ($grpcPort -eq $httpPort) { $grpcPort = Get-FreePort }
    $origin = "http://127.0.0.1:$httpPort"
    $server = Start-Process -FilePath $serverExe -ArgumentList @('-http', "127.0.0.1:$httpPort", '-grpc', "127.0.0.1:$grpcPort", '-origin', $origin) -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $work 'server.stdout.log') -RedirectStandardError (Join-Path $work 'server.stderr.log')
    $discovery = Wait-TestServer $server $origin
    $expectedId = & $psql $DatabaseUrl -X -q -A -t -v ON_ERROR_STOP=1 -c "SELECT server_id FROM $schema.server_state WHERE singleton=true"
    if ($LASTEXITCODE -ne 0 -or !$expectedId -or $expectedId.Trim() -ne $discovery.server_id) {
        throw 'Discovery не соответствует отдельной тестовой базе. Проверка остановлена.'
    }
    $env:SPACE_ATTACHMENTS_TEST_ORIGIN = $origin
    if($Scenario -eq "mls"){$env:SPACE_MLS_TEST_ORIGIN=$origin}
    if($Scenario -eq "desktop"){$env:SPACE_DESKTOP_CHAT_TEST_ORIGIN=$origin}
    Push-Location (Join-Path $appRoot 'client')
    try {
        $testFile = switch ($Scenario) {
            "mls" { "test/live/mls_server_test.dart" }
            "desktop" { "test/live/desktop_chat_server_test.dart" }
            default { "test/live/attachments_server_test.dart" }
        }
        flutter test $testFile --reporter expanded
        if ($LASTEXITCODE -ne 0) { throw "Сквозная проверка $Scenario завершилась ошибкой." }
    } finally { Pop-Location }
    Write-Output "Сквозная проверка $Scenario пройдена. Журналы: $work"
} finally {
    if ($null -ne $server -and !$server.HasExited) {
        $server.Kill()
        $server.WaitForExit()
    }
    # Сохраняем журналы, но не отдельный исполняемый файл каждого прогона.
    $expectedWork = [IO.Path]::GetFullPath($work)
    $expectedExe = [IO.Path]::GetFullPath($serverExe)
    if ([IO.Path]::GetDirectoryName($expectedExe) -eq $expectedWork -and
        [IO.Path]::GetFileName($expectedWork) -match '^space_v03_[0-9a-f]{32}$' -and
        [IO.Path]::GetFileName($expectedExe) -eq 'space-server.exe' -and
        (Test-Path -LiteralPath $expectedExe)) {
        try { Remove-Item -LiteralPath $expectedExe -ErrorAction Stop }
        catch { Write-Warning "Не удалось убрать тестовую сборку: $expectedExe" }
    }
    $env:SPACE_DATABASE_URL = $previousDatabase
    $env:SPACE_ATTACHMENTS_TEST_ORIGIN = $previousOrigin
    $env:SPACE_MLS_TEST_ORIGIN=$previousMlsOrigin
    $env:SPACE_DESKTOP_CHAT_TEST_ORIGIN=$previousDesktopOrigin
    if ($created -and $schema -match '^space_v03_[0-9a-f]{32}$') {
        & $psql $DatabaseUrl -X -q -v ON_ERROR_STOP=1 -c "SET client_min_messages=warning; DROP SCHEMA $schema CASCADE"
        if ($LASTEXITCODE -ne 0) { Write-Warning 'Не удалось удалить собственную тестовую схему.' }
    }
}
