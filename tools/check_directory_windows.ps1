param([Parameter(Mandatory)][string]$Server, [Parameter(Mandatory)][string]$OutputDirectory)
$ErrorActionPreference = 'Stop'
if ($env:GITHUB_ACTIONS -ne 'true') { throw 'Стенд разрешён только в GitHub CI.' }
$appRoot = Split-Path $PSScriptRoot -Parent
$work = [IO.Path]::GetFullPath($OutputDirectory)
$temporary = [IO.Path]::GetFullPath($env:RUNNER_TEMP).TrimEnd('\') + '\'
if (!$work.StartsWith($temporary, [StringComparison]::OrdinalIgnoreCase)) { throw 'Нужен отдельный каталог RUNNER_TEMP.' }
New-Item -ItemType Directory -Path $work | Out-Null
$runtime = Join-Path $work 'runtime'
$archive = Join-Path $work 'runtime.zip'
$manifest = Get-Content -LiteralPath (Join-Path $appRoot 'client/assets/home/runtime-manifest.json') -Raw | ConvertFrom-Json
$descriptor = $manifest.'windows-x64'
$expectedUrl = 'https://github.com/space-protocol-project/space-server/releases/download/' + $descriptor.version + '/Space-home-windows-x64.zip'
if ($descriptor.url -ne $expectedUrl -or $descriptor.version -notmatch '^v\d+\.\d+\.\d+$') { throw 'Недопустимый источник PostgreSQL.' }
Invoke-WebRequest -Uri $descriptor.url -OutFile $archive
if ((Get-Item -LiteralPath $archive).Length -ne $descriptor.bytes -or
    (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant() -ne $descriptor.sha256) { throw 'Размер или SHA-256 PostgreSQL не совпадает.' }
Expand-Archive -LiteralPath $archive -DestinationPath $runtime
$pgBin = Join-Path $runtime 'postgres/bin'
$database = Join-Path $work 'database'
$pgCtl = Join-Path $pgBin 'pg_ctl.exe'
$listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, 0)
$listener.Start()
$port = $listener.LocalEndpoint.Port
$listener.Stop()
$started = $false
try {
    & (Join-Path $pgBin 'initdb.exe') -D $database -U space_test -A trust --encoding=UTF8 --no-locale > (Join-Path $work 'initdb.log') 2>&1
    if ($LASTEXITCODE) { throw 'Не создана тестовая PostgreSQL.' }
    # -Wait здесь не используется: postgres является долгоживущим потомком pg_ctl.
    $starter = Start-Process -FilePath $pgCtl -ArgumentList @('-D', ('"' + $database + '"'), '-l', ('"' + (Join-Path $work 'postgres.log') + '"'), '-o', ('"-h 127.0.0.1 -p ' + $port + '"'), 'start') -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $work 'postgres-start.log') -RedirectStandardError (Join-Path $work 'postgres-start-error.log')
    if (!$starter.WaitForExit(60000) -or $starter.ExitCode -ne 0) { throw 'PostgreSQL не запущена.' }
    $started = $true
    $env:SPACE_DATABASE_URL = "postgres://space_test@127.0.0.1:$port/postgres?sslmode=disable"
    python (Join-Path $PSScriptRoot 'check_directory_crash.py') --app (Join-Path $appRoot 'client/build/windows/x64/runner/Debug/space_client.exe') --server $Server --output (Join-Path $work 'cases')
    if ($LASTEXITCODE) { throw 'Аварийное восстановление не прошло.' }
    Copy-Item -LiteralPath (Join-Path $work 'cases/report.json') -Destination (Join-Path $work 'report.json')
} finally {
    if ($started) {
        & $pgCtl -D $database -m fast stop > (Join-Path $work 'postgres-stop.log') 2>&1
        if ($LASTEXITCODE) { throw 'Тестовая PostgreSQL не остановлена.' }
    }
}
