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
    $encodedOrigin=[Text.Encoding]::UTF8.GetBytes("space-vault-drill:$vaultDrillId")
    $originDigest=[Security.Cryptography.SHA256]::HashData($encodedOrigin)
    $urlDigest=[Convert]::ToBase64String($originDigest).TrimEnd('=').Replace('+','-').Replace('/','_')
    $env:SPACE_VAULT_DRILL_KEY="space.identity.v1.$urlDigest"
    $env:SPACE_VAULT_DRILL_READY="$vaultDrillReport.ready"
    $crashing=Start-Process -FilePath $vaultDrillExe -ArgumentList @('crash-active',$vaultDrillId,('"{0}"' -f $vaultDrillReport)) -WorkingDirectory (Split-Path $vaultDrillExe) -WindowStyle Hidden -PassThru
    $deadline=[DateTime]::UtcNow.AddSeconds(20)
    while(-not(Test-Path -LiteralPath $env:SPACE_VAULT_DRILL_READY) -and [DateTime]::UtcNow -lt $deadline -and -not $crashing.HasExited){Start-Sleep -Milliseconds 50}
    # Завершается только созданный здесь процесс с проверенным исполняемым файлом.
    $ownedProcess=Get-Process -Id $crashing.Id -ErrorAction SilentlyContinue
    if($ownedProcess -and $ownedProcess.Path -ne $vaultDrillExe){throw 'Путь проверочного процесса изменился'}
    $checkpointReached=Test-Path -LiteralPath $env:SPACE_VAULT_DRILL_READY
    if($ownedProcess){$ownedProcess.Kill();$crashing.WaitForExit()}
    if(-not $checkpointReached){throw 'Native checkpoint не достигнут'}
    $env:SPACE_VAULT_DRILL_KEY=$null;$env:SPACE_VAULT_DRILL_READY=$null
    Invoke-VaultPhase 'recover-crash'
} finally {
    $env:SPACE_VAULT_DRILL_KEY=$null;$env:SPACE_VAULT_DRILL_READY=$null
    Invoke-VaultPhase 'cleanup'
}
$result = Get-Content -LiteralPath $vaultDrillReport -Raw | ConvertFrom-Json
if (-not ($result.write -and $result.reopen -and $result.cleanup -and $result.crash -and $result.recovered)) { throw 'Неполный результат проверки vault' }
Write-Output 'Windows secure storage: запись, новый процесс, неизменные рабочие ключи и очистка отдельного тестового слота — успешно.'
