$ErrorActionPreference = 'Stop'
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
$visualStudio = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if ($LASTEXITCODE -ne 0 -or !$visualStudio) { throw 'Не найден компилятор Visual Studio' }
$devCommand = Join-Path $visualStudio 'Common7/Tools/VsDevCmd.bat'
$work = Join-Path $env:TEMP ('space-secure-storage-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $work | Out-Null
$binary = Join-Path $work 'atomic-test.exe'
$object = Join-Path $work 'atomic-test.obj'
$source = Join-Path $PSScriptRoot 'secure_storage_atomic_test.cpp'
$batch = Join-Path $work 'build.cmd'
@"
@echo off
call "$devCommand" -arch=x64 >nul
if errorlevel 1 exit /b 1
cl.exe /nologo /std:c++17 /EHsc /W4 /WX /Fe:"$binary" /Fo:"$object" "$source"
"@ | Set-Content -LiteralPath $batch
& cmd.exe /d /c $batch
if ($LASTEXITCODE -ne 0) { throw 'Ошибка сборки проверки хранилища' }
& $binary (Join-Path $work 'records')
if ($LASTEXITCODE -ne 0) { throw 'Проверка атомарного хранилища не прошла' }
Write-Output 'Атомарная замена зашифрованных записей проверена.'
