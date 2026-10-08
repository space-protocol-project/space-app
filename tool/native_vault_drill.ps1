param([string]$Binary = (Join-Path $PSScriptRoot '../build/windows/x64/runner/Release/space_client.exe'))
$ErrorActionPreference = 'Stop'
$vaultDrillExe = (Resolve-Path -LiteralPath $Binary).Path
$vaultDrillId = [guid]::NewGuid().ToString('N')
$vaultDrillReport = Join-Path $env:TEMP "space-vault-drill-$vaultDrillId.json"
function Invoke-VaultPhase([string]$Phase) {
    $process = Start-Process -FilePath $vaultDrillExe -ArgumentList @($Phase, $vaultDrillId, ('"{0}"' -f $vaultDrillReport)) -WorkingDirectory (Split-Path $vaultDrillExe) -WindowStyle Hidden -PassThru
    if (-not $process.WaitForExit(20000)) {
        Stop-Process -Id $process.Id
        throw "Тестовый процесс превысил время: $Phase"
    }
    if ($process.ExitCode -ne 0) { throw "Ошибка Windows vault: $Phase" }
}
try {
    Invoke-VaultPhase 'write'
    Invoke-VaultPhase 'reopen'
} finally {
    Invoke-VaultPhase 'cleanup'
}
$result = Get-Content -LiteralPath $vaultDrillReport -Raw | ConvertFrom-Json
if (-not ($result.write -and $result.reopen -and $result.cleanup)) { throw 'Неполный результат проверки vault' }
Write-Output 'Windows secure storage: запись, новый процесс, неизменные рабочие ключи и очистка отдельного тестового слота — успешно.'
