param(
    [switch]$Apply,
    [switch]$IncludeAndroidBuild
)

$ErrorActionPreference = 'Stop'
$projectRoot = [IO.Path]::GetFullPath((Split-Path $PSScriptRoot -Parent))
$rootPrefix = $projectRoot + [IO.Path]::DirectorySeparatorChar

# По умолчанию только список. Ключи, базы, исходники и общие кэши не затрагиваются.
$activeBuilds = @(Get-CimInstance Win32_Process | Where-Object {
    $_.Name -in @('dart.exe', 'dartvm.exe', 'dartaotruntime.exe',
        'flutter_tester.exe', 'space_client.exe', 'cmake.exe', 'MSBuild.exe', 'java.exe') -and
    $_.CommandLine -and $_.CommandLine.IndexOf($projectRoot,
        [StringComparison]::OrdinalIgnoreCase) -ge 0
})
if ($activeBuilds.Count) { throw 'Сначала завершите сборки и проверочное приложение проекта.' }

$temporaryRoot = Join-Path $projectRoot '.local/mls/temp'
$flutterRoot = Join-Path $projectRoot 'client/.dart_tool/flutter_build'
$targets = @()
if (Test-Path -LiteralPath $temporaryRoot) {
    $targets += @(Get-ChildItem -LiteralPath $temporaryRoot -Directory |
        Where-Object { $_.Name -match '^flutter_tools\.[0-9a-f]+$' })
}
if (Test-Path -LiteralPath $flutterRoot) {
    # Два последних снимка оставляем для текущих проверок.
    $targets += @(Get-ChildItem -LiteralPath $flutterRoot -Directory |
        Where-Object { $_.Name -match '^[0-9a-f]{32}$' } |
        Sort-Object LastWriteTime -Descending | Select-Object -Skip 2)
}
if ($IncludeAndroidBuild) {
    $androidBuild = Join-Path $projectRoot 'client/build/app'
    if (Test-Path -LiteralPath $androidBuild) {
        $targets += Get-Item -LiteralPath $androidBuild
    }
}

$plan = foreach ($target in $targets) {
    $absolute = [IO.Path]::GetFullPath($target.FullName)
    if (!$absolute.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Путь вне проекта: $absolute"
    }
    # Проверяем также родителей: удаление не должно проходить через junction.
    $ancestor = $target
    while ($ancestor -and $ancestor.FullName -ne $projectRoot) {
        if ($ancestor.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            throw "Обнаружена ссылка: $($ancestor.FullName)"
        }
        $ancestor = $ancestor.Parent
    }
    $children = @(Get-ChildItem -LiteralPath $absolute -Recurse -Force)
    if ($children | Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint }) {
        throw "Внутри каталога обнаружена ссылка: $absolute"
    }
    [pscustomobject]@{
        Path = $absolute
        Bytes = ($children | Where-Object { !$_.PSIsContainer } |
            Measure-Object Length -Sum).Sum
    }
}

$plan | Select-Object Path, @{Name='GiB';Expression={[math]::Round($_.Bytes / 1GB, 2)}} |
    Format-Table -AutoSize
$total = ($plan | Measure-Object Bytes -Sum).Sum
Write-Output ('Всего: {0:N2} ГиБ' -f ($total / 1GB))
if (!$Apply) { Write-Output 'Удаления не было. Для очистки укажите -Apply.'; return }

foreach ($entry in $plan) {
    Remove-Item -LiteralPath $entry.Path -Recurse -Force -ErrorAction Stop
}
Write-Output ('Удалено: {0:N2} ГиБ. Свободно на C: {1:N2} ГиБ' -f
    ($total / 1GB), ((Get-PSDrive C).Free / 1GB))
