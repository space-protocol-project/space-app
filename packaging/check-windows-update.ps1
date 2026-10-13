param(
    [Parameter(Mandatory)][string]$Probe,
    [Parameter(Mandatory)][string]$Installer,
    [Parameter(Mandatory)][string]$CandidateExecutable
)
$ErrorActionPreference = 'Stop'
if ($env:GITHUB_ACTIONS -ne 'true' -or $env:RUNNER_OS -ne 'Windows') {
    throw 'Этот сценарий разрешён только на отдельном Windows runner GitHub CI'
}
$registration = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{A1D164D7-8CE9-4FF1-98B7-3D9970218441}_is1'
if (Test-Path -LiteralPath $registration) { throw 'Runner уже содержит установленный Space' }
$probeExe = (Resolve-Path -LiteralPath $Probe).Path
$setupExe = (Resolve-Path -LiteralPath $Installer).Path
$candidateHash = (Get-FileHash -LiteralPath $CandidateExecutable -Algorithm SHA256).Hash
$setupHash = (Get-FileHash -LiteralPath $setupExe -Algorithm SHA256).Hash.ToLower()
$probeId = [guid]::NewGuid().ToString('N')
$probeRoot = Join-Path $env:RUNNER_TEMP "Space update check $probeId"
$installDirectory = Join-Path $probeRoot 'Installed Space'
New-Item -ItemType Directory -Path $probeRoot | Out-Null
$report = Join-Path $probeRoot 'result.json'
$oldSetup = Join-Path $probeRoot 'old-setup.exe'
$installedExe = Join-Path $installDirectory 'space_client.exe'

function Invoke-Probe([string]$Phase) {
    $arguments = @($Phase, $probeId, ('"{0}"' -f $report), ('"{0}"' -f $installDirectory), ('"{0}"' -f $setupExe), $setupHash)
    $process = Start-Process -FilePath $probeExe -ArgumentList $arguments -WorkingDirectory (Split-Path $probeExe) -WindowStyle Hidden -PassThru
    if (-not $process.WaitForExit(45000)) {
        if ((Get-Process -Id $process.Id).Path -ne $probeExe) { throw 'Путь проверочного процесса изменился' }
        Stop-Process -Id $process.Id
        throw "Превышено время проверочной фазы: $Phase"
    }
    if ($process.ExitCode -ne 0) { throw "Ошибка проверочной фазы: $Phase" }
}

function Stop-OwnedApp($Process) {
    if ($null -eq $Process -or $Process.HasExited) { return }
    if ($Process.Path -ne $installedExe) { throw 'Нельзя завершить посторонний процесс' }
    [void]$Process.CloseMainWindow()
    if (-not $Process.WaitForExit(10000)) {
        Stop-Process -Id $Process.Id
        $Process.WaitForExit()
    }
}

$headers = @{ Accept = 'application/vnd.github+json'; 'User-Agent' = 'Space-update-CI' }
if ($env:GH_TOKEN) { $headers.Authorization = "Bearer $env:GH_TOKEN" }
$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/space-protocol-project/space-app/releases/tags/v0.2.1' -Headers $headers
$asset = @($release.assets | Where-Object name -eq 'Space-Setup-windows-x64.exe')
if ($asset.Count -ne 1 -or $release.draft -or $asset[0].digest -notmatch '^sha256:[0-9a-f]{64}$') { throw 'Неверные метаданные исходного выпуска' }
$expectedUrl = 'https://github.com/space-protocol-project/space-app/releases/download/v0.2.1/Space-Setup-windows-x64.exe'
if ($asset[0].browser_download_url -ne $expectedUrl) { throw 'Неверный адрес исходного установщика' }
Invoke-WebRequest -Uri $expectedUrl -OutFile $oldSetup
if ((Get-Item -LiteralPath $oldSetup).Length -ne $asset[0].size -or 'sha256:' + (Get-FileHash -LiteralPath $oldSetup -Algorithm SHA256).Hash.ToLower() -ne $asset[0].digest) { throw 'Исходный установщик не прошёл проверку' }
$baseline = Start-Process -FilePath $oldSetup -ArgumentList @('/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', '/NOICONS', '/TASKS=""', ('/DIR="{0}"' -f $installDirectory), ('/LOG="{0}"' -f (Join-Path $probeRoot 'baseline-install.log'))) -WindowStyle Hidden -PassThru
if (-not $baseline.WaitForExit(90000)) { throw 'Исходная установка не завершилась вовремя' }
if ($baseline.ExitCode -ne 0 -or -not (Test-Path -LiteralPath $installedExe)) { throw 'Не установлена исходная версия' }
$oldHash = (Get-FileHash -LiteralPath $installedExe -Algorithm SHA256).Hash
if ($oldHash -eq $candidateHash) { throw 'Исходный и новый исполняемые файлы совпали' }
$running = $null
$original = $null
try {
    Invoke-Probe 'write'
    $original = Start-Process -FilePath $installedExe -WorkingDirectory $installDirectory -WindowStyle Hidden -PassThru
    Start-Sleep -Seconds 5
    if ($original.HasExited) { throw 'Исходное приложение не запустилось' }
    Stop-OwnedApp $original
    Invoke-Probe 'install'
    $deadline = [DateTime]::UtcNow.AddSeconds(120)
    do {
        $running = @(Get-Process -Name space_client -ErrorAction SilentlyContinue | Where-Object Path -eq $installedExe) | Select-Object -First 1
        if ($null -ne $running) { break }
        Start-Sleep -Milliseconds 500
    } while ([DateTime]::UtcNow -lt $deadline)
    if ($null -eq $running) { throw 'Приложение не перезапустилось после установки' }
    Start-Sleep -Seconds 5
    if ($running.HasExited) { throw 'Новое приложение завершилось после запуска' }
    if ((Get-FileHash -LiteralPath $installedExe -Algorithm SHA256).Hash -ne $candidateHash) { throw 'Установлена другая сборка' }
    $savedDirectory = (Get-ItemProperty -LiteralPath $registration).InstallLocation.TrimEnd('\')
    if ($savedDirectory -ne $installDirectory) { throw 'Установщик изменил каталог или регистрацию приложения' }
    if (-not (Test-Path -LiteralPath (Join-Path $probeRoot 'install.log'))) { throw 'Нет журнала обновления' }
    Stop-OwnedApp $running
    Invoke-Probe 'read'
    $result = Get-Content -LiteralPath $report -Raw | ConvertFrom-Json
    if (-not ($result.write -and $result.launched -and $result.preserved)) { throw 'Неполный результат проверки' }
    Write-Output 'Обновление v0.2.1 -> main: прежний каталог/AppId, перезапуск, настройки, системный vault и домашние данные сохранены.'
} finally {
    Stop-OwnedApp $original
    Stop-OwnedApp $running
    Invoke-Probe 'cleanup'
}
