param([Parameter(Mandatory)][string]$OutputDirectory)
$ErrorActionPreference = 'Stop'
if ($env:GITHUB_ACTIONS -ne 'true') { throw 'Стенд разрешён только в GitHub CI.' }
$appRoot = Split-Path $PSScriptRoot -Parent
$work = [IO.Path]::GetFullPath($OutputDirectory)
$temporary = [IO.Path]::GetFullPath($env:RUNNER_TEMP).TrimEnd('\') + '\'
if (!$work.StartsWith($temporary, [StringComparison]::OrdinalIgnoreCase)) { throw 'Нужен каталог RUNNER_TEMP.' }
if (Test-Path -LiteralPath $work) { throw 'Нужен новый каталог сценария.' }
New-Item -ItemType Directory -Path $work | Out-Null
$manifest = Get-Content -LiteralPath (Join-Path $appRoot 'client/assets/home/runtime-manifest.json') -Raw | ConvertFrom-Json
$descriptor = $manifest.'windows-x64'
$expectedUrl = 'https://github.com/space-protocol-project/space-server/releases/download/' + $descriptor.version + '/Space-home-windows-x64.zip'
if ($descriptor.url -ne $expectedUrl -or $descriptor.version -notmatch '^v\d+\.\d+\.\d+$') { throw 'Недопустимый источник runtime.' }
$archive = Join-Path $work 'runtime.zip'
Invoke-WebRequest -Uri $descriptor.url -OutFile $archive
if ((Get-Item -LiteralPath $archive).Length -ne $descriptor.bytes -or
    (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant() -ne $descriptor.sha256) { throw 'Не совпадает runtime.' }
$runtime = Join-Path $work 'runtime'
Expand-Archive -LiteralPath $archive -DestinationPath $runtime
$env:SPACE_HOME_RUNTIME = $runtime
$env:SPACE_RESTORE_EXECUTABLE = Join-Path $runtime 'space-server.exe'
if ($env:CLEAN_INSTALL_SERVER) { $env:SPACE_RESTORE_EXECUTABLE = $env:CLEAN_INSTALL_SERVER }
$env:CLEAN_INSTALL_WORK = $work
$probe = Join-Path $appRoot 'client/build/windows/x64/runner/Debug/space_client.exe'
$source = Join-Path $work 'source'
$target = Join-Path $work 'target'
$results = @()
foreach ($phase in @('source', 'source-check', 'restore', 'verify', 'verify-again')) {
    $env:CLEAN_INSTALL_PHASE = $phase
    $env:DIRECTORY_CRASH_PROFILE = if ($phase -in @('source', 'source-check')) { $source } else { $target }
    $process = Start-Process -FilePath $probe -WindowStyle Hidden -PassThru `
        -RedirectStandardOutput (Join-Path $work "$phase.log") -RedirectStandardError (Join-Path $work "$phase-error.log")
    if (!$process.WaitForExit(600000)) {
        Stop-Process -Id $process.Id -Force
        throw "Превышено время фазы $phase."
    }
    if ($process.ExitCode -ne 0) {
        Get-Content -LiteralPath (Join-Path $work "$phase-error.log") -Tail 50
        throw "Ошибка фазы $phase, код $($process.ExitCode)."
    }
    $result = Get-Content -LiteralPath (Join-Path $work "done-$phase.json") -Raw | ConvertFrom-Json
    if (!$result.success -or $result.phase -ne $phase) { throw 'Нет подтверждения фазы.' }
    $results += $result
    if ($phase -eq 'source-check') {
        $resolvedSource = [IO.Path]::GetFullPath($source)
        if (!$resolvedSource.StartsWith($work.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Исходный профиль вне стенда.' }
        Remove-Item -LiteralPath $resolvedSource -Recurse -Force
        if (Test-Path -LiteralPath $source) { throw 'Исходный профиль не удалён.' }
    }
}
if (($results.pid | Select-Object -Unique).Count -ne 5) { throw 'Фазы не подтвердили независимые процессы.' }
@{ success = $true; backend = 'Windows DPAPI'; source_deleted = $true; empty_password = $true;
    phases = $results; runtime = $descriptor.version } | ConvertTo-Json -Depth 6 |
    Set-Content -LiteralPath (Join-Path $work 'report.json') -Encoding utf8
Write-Output 'Чистое восстановление: DPAPI, PostgreSQL, MLS, вложение и два холодных запуска прошли.'
