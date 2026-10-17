param([string]$OutputDirectory = $env:RUNNER_TEMP)

$ErrorActionPreference = 'Stop'
if (!$OutputDirectory) { throw 'Нужен отдельный временный каталог CI.' }
$appRoot = Split-Path $PSScriptRoot -Parent
$work = Join-Path $OutputDirectory ('desktop-chat-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $work | Out-Null
$runtime = Join-Path $work 'runtime'
$database = Join-Path $work 'database'
$archive = Join-Path $work 'runtime.zip'
$manifest = Get-Content -LiteralPath (Join-Path $appRoot 'client/assets/home/runtime-manifest.json') -Raw | ConvertFrom-Json
$descriptor = $manifest.'windows-x64'
$expectedUrl = 'https://github.com/space-protocol-project/space-server/releases/download/' + $descriptor.version + '/Space-home-windows-x64.zip'
if ($descriptor.url -ne $expectedUrl -or $descriptor.version -notmatch '^v\d+\.\d+\.\d+$') {
    throw 'Недопустимый источник комплекта PostgreSQL.'
}
Invoke-WebRequest -Uri $descriptor.url -OutFile $archive
if ((Get-Item -LiteralPath $archive).Length -ne $descriptor.bytes -or
    (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant() -ne $descriptor.sha256) {
    throw 'Размер или SHA-256 комплекта не совпадает с закреплённым manifest.'
}
Expand-Archive -LiteralPath $archive -DestinationPath $runtime
$postgresBin = Join-Path $runtime 'postgres/bin'
$pgCtl = Join-Path $postgresBin 'pg_ctl.exe'
$listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, 0)
$listener.Start()
$port = $listener.LocalEndpoint.Port
$listener.Stop()
$started = $false
$previousRequired = $env:SPACE_REQUIRE_DESKTOP_CHAT_TEST
try {
    & (Join-Path $postgresBin 'initdb.exe') -D $database -U space_test -A trust --encoding=UTF8 --no-locale
    if ($LASTEXITCODE -ne 0) { throw 'Не удалось создать отдельную PostgreSQL CI.' }
    & $pgCtl -D $database -l (Join-Path $work 'postgres.log') -o "-h 127.0.0.1 -p $port" start
    if ($LASTEXITCODE -ne 0) { throw 'Не удалось запустить отдельную PostgreSQL CI.' }
    $started = $true
    $env:SPACE_REQUIRE_DESKTOP_CHAT_TEST = '1'
    & (Join-Path $PSScriptRoot 'check_attachments.ps1') -Scenario desktop `
        -DatabaseUrl "postgres://space_test@127.0.0.1:$port/postgres?sslmode=disable" `
        -PostgresBin $postgresBin -OutputDirectory $work
} finally {
    $env:SPACE_REQUIRE_DESKTOP_CHAT_TEST = $previousRequired
    if ($started) {
        & $pgCtl -D $database -m fast stop
        if ($LASTEXITCODE -ne 0) { throw 'Не удалось остановить тестовую PostgreSQL.' }
    }
    # Большие файлы не нужны в диагностических артефактах.
    if (Test-Path -LiteralPath $archive) { Remove-Item -LiteralPath $archive }
}
