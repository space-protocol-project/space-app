param(
    [string]$PostgresBin = (Join-Path $env:APPDATA 'Space Protocol contributors/Space/home-server/runtimes/v0.7.14-windows-x64/postgres/bin'),
    [string]$ServerRoot = (Join-Path $PSScriptRoot '../../space-server'),
    [string]$WorkRoot = (Join-Path $PSScriptRoot '../.local/forum-acceptance'),
    [ValidateSet('forum', 'feed')][string]$Scenario = 'forum'
)

$ErrorActionPreference = 'Stop'
$appRoot = Split-Path $PSScriptRoot -Parent
$clientRoot = Join-Path $appRoot 'client'
$work = [IO.Path]::GetFullPath((Join-Path $WorkRoot ([guid]::NewGuid().ToString('N'))))
$databaseBefore = $env:SPACE_DATABASE_URL
$testDatabaseBefore = $env:SPACE_TEST_DATABASE_URL
$temporaryBefore = $env:TEMP
$tmpBefore = $env:TMP
$postgresStarted = $false
$serverProcess = $null
$appProcess = $null

function Get-TestPort {
    $listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, 0)
    $listener.Start()
    try { return $listener.LocalEndpoint.Port } finally { $listener.Stop() }
}

function Invoke-Checked([string]$Program, [string[]]$Arguments, [string]$Log) {
    & $Program @Arguments > $Log 2>&1
    if ($LASTEXITCODE -ne 0) {
        Get-Content -LiteralPath $Log -Tail 50
        throw "Ошибка команды $Program; журнал: $Log"
    }
}

function Wait-Discovery([string]$Origin) {
    for ($attempt = 0; $attempt -lt 100; $attempt++) {
        try { return Invoke-RestMethod "$Origin/.well-known/space-protocol" } catch {
            Start-Sleep -Milliseconds 100
        }
    }
    throw 'Тестовый сервер не запустился'
}

try {
    if (!(Test-Path (Join-Path $PostgresBin 'pg_ctl.exe'))) {
        throw 'Укажите -PostgresBin с установленной PostgreSQL'
    }
    New-Item -ItemType Directory -Path $work -Force | Out-Null
    $temporary = Join-Path $work 'temporary'
    New-Item -ItemType Directory -Path $temporary -Force | Out-Null
    $env:TEMP = $temporary
    $env:TMP = $temporary
    $data = Join-Path $work 'data'
    Invoke-Checked (Join-Path $PostgresBin 'initdb.exe') @('-D', $data, '-U', 'forum_test', '-A', 'trust', '--encoding=UTF8', '--no-locale') (Join-Path $work 'initdb.log')
    $databasePort = Get-TestPort
    # Start-Process не передаёт путям с пробелами кавычки автоматически.
    $pgArguments = @('-D', ('"' + $data + '"'), '-l', ('"' + (Join-Path $work 'postgres.log') + '"'), '-o', ('"-h 127.0.0.1 -p ' + $databasePort + '"'), 'start')
    $starter = Start-Process -FilePath (Join-Path $PostgresBin 'pg_ctl.exe') -ArgumentList $pgArguments -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $work 'postgres-start.out') -RedirectStandardError (Join-Path $work 'postgres-start.err')
    # -Wait ждёт также дочерний postgres; здесь нужен только выход pg_ctl.
    $starter.WaitForExit()
    if ($starter.ExitCode -ne 0) { throw 'Не запущена изолированная PostgreSQL' }
    $postgresStarted = $true
    $env:SPACE_TEST_DATABASE_URL = "postgres://forum_test@127.0.0.1:$databasePort/postgres?sslmode=disable"
    $env:SPACE_DATABASE_URL = $env:SPACE_TEST_DATABASE_URL
    $serverExe = Join-Path $work 'space-server.exe'
    Push-Location $ServerRoot
    try {
        Invoke-Checked 'go' @('test', './internal/postgres', '-run', 'Feed|Forum', '-count=1', '-v') (Join-Path $work 'postgres-tests.log')
        Invoke-Checked 'go' @('build', '-o', $serverExe, './cmd/space-server') (Join-Path $work 'server-build.log')
    } finally { Pop-Location }
    $httpPort = Get-TestPort
    $grpcPort = Get-TestPort
    $origin = "http://127.0.0.1:$httpPort"
    $serverProcess = Start-Process -FilePath $serverExe -ArgumentList @('-http', "127.0.0.1:$httpPort", '-grpc', "127.0.0.1:$grpcPort", '-origin', $origin) -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $work 'server.out') -RedirectStandardError (Join-Path $work 'server.err')
    $discovery = Wait-Discovery $origin
    if (!$discovery.server_id) { throw 'Нет идентичности тестового сервера' }
    $output = Join-Path $work 'screenshots'
    $defines = Join-Path $work 'defines.json'
    @{
        SPACE_FORUM_NATIVE_ORIGIN = $origin
        SPACE_FORUM_NATIVE_SERVER_ID = $discovery.server_id
        SPACE_FORUM_NATIVE_OUTPUT = $output
    } | ConvertTo-Json | Set-Content -LiteralPath $defines -Encoding utf8
    Push-Location $clientRoot
    try {
        Invoke-Checked 'flutter' @('test', '--no-pub', 'test/feed_test.dart', 'test/forum_test.dart', 'test/forum_navigation_test.dart', 'test/forum_moderation_test.dart', 'test/forum_reports_test.dart') (Join-Path $work 'flutter-tests.log')
        $target = 'test/support/forum_acceptance_native_app.dart'
        if ($Scenario -eq 'feed') { $target = 'test/support/feed_native_app.dart' }
        Invoke-Checked 'flutter' @('build', 'windows', '--debug', '--no-pub', "--target=$target", "--dart-define-from-file=$defines") (Join-Path $work 'windows-build.log')
    } finally { Pop-Location }
    $executable = Join-Path $clientRoot 'build/windows/x64/runner/Debug/space_client.exe'
    $appProcess = Start-Process -FilePath $executable -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $work 'app.out') -RedirectStandardError (Join-Path $work 'app.err')
    $report = Join-Path $output 'acceptance.json'
    $deadline = [DateTime]::UtcNow.AddSeconds(180)
    while (!(Test-Path $report)) {
        if ($appProcess.HasExited -or [DateTime]::UtcNow -gt $deadline) {
            Get-Content (Join-Path $work 'app.out') -Tail 40
            Get-Content (Join-Path $work 'app.err') -Tail 40
            throw 'Windows-приложение не подтвердило приёмку'
        }
        Start-Sleep -Milliseconds 250
    }
    $result = Get-Content -LiteralPath $report -Raw | ConvertFrom-Json
    $required = @('separateModerator', 'dialogRevocation', 'queueRevocation', 'lostResponseReplay')
    if ($Scenario -eq 'feed') { $required = @('separateModerator', 'splitPermissions', 'hiddenFiles', 'restorePreservesComment', 'lostResponseReplay', 'independentProcesses', 'transportResponseLoss', 'midDownloadHide', 'independentRoleFlow') }
    if (!$result.success -or ($required | Where-Object { !$result.$_ })) {
        throw 'Неполный результат приёмки'
    }
    Write-Output "Приёмка $Scenario на Windows прошла. Результаты: $work"
} finally {
    if ($appProcess -and !$appProcess.HasExited) { Stop-Process -Id $appProcess.Id }
    if ($serverProcess -and !$serverProcess.HasExited) { Stop-Process -Id $serverProcess.Id }
    if ($postgresStarted) {
        & (Join-Path $PostgresBin 'pg_ctl.exe') -D $data -m fast stop > (Join-Path $work 'postgres-stop.log') 2>&1
    }
    $env:SPACE_DATABASE_URL = $databaseBefore
    $env:SPACE_TEST_DATABASE_URL = $testDatabaseBefore
    $env:TEMP = $temporaryBefore
    $env:TMP = $tmpBefore
}
