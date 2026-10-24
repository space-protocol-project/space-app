param(
    [string]$WorkRoot = (Join-Path $PSScriptRoot '../.local/android-feed'),
    [string]$AndroidSdk = 'C:/Users/vostr/code/android/sdk',
    [string]$JavaHome = 'C:/Users/vostr/code/android/java/jdk-21.0.12.1+1',
    [string]$GradleCache = 'C:/Users/vostr/code/android/gradle-home',
    [string]$PubCache = (Join-Path $env:LOCALAPPDATA 'Pub/Cache'),
    [string]$ResumeWork = ''
)

$ErrorActionPreference = 'Stop'
$appRoot = Split-Path $PSScriptRoot -Parent
$work = if ($ResumeWork) { [IO.Path]::GetFullPath($ResumeWork) } else {
    [IO.Path]::GetFullPath((Join-Path $WorkRoot ([guid]::NewGuid().ToString('N'))))
}
if ($ResumeWork -and (!$work.StartsWith([IO.Path]::GetFullPath($WorkRoot).TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar) -or !(Test-Path -LiteralPath (Join-Path $work 'source/client/pubspec.yaml')))) {
    throw 'ResumeWork должен указывать на прежний каталог стенда внутри WorkRoot'
}
$source = Join-Path $work 'source'
$gradleUsed = $false
$saved = @{}
$variables = @('TEMP', 'TMP', 'JAVA_HOME', 'ANDROID_HOME', 'ANDROID_SDK_ROOT', 'GRADLE_USER_HOME', 'PUB_CACHE', 'CARGO_TARGET_DIR', 'SPACE_VOICE_TARGET_DIR')
foreach ($name in $variables) { $saved[$name] = [Environment]::GetEnvironmentVariable($name, 'Process') }

function Invoke-Checked([string]$Program, [string[]]$Arguments, [string]$Log) {
    & $Program @Arguments > $Log 2>&1
    if ($LASTEXITCODE -ne 0) {
        Get-Content -LiteralPath $Log -Tail 60
        throw "Ошибка команды $Program; журнал: $Log"
    }
}

function Copy-Sources([string]$From, [string]$To, [string]$Log) {
    & robocopy $From $To /E /XD .git .local build .dart_tool target .gradle .kotlin .cxx /XF key.properties *.jks *.keystore /R:1 /W:1 /NFL /NDL /NJH /NJS > $Log 2>&1
    if ($LASTEXITCODE -lt 0 -or $LASTEXITCODE -ge 8) { throw "Не скопированы исходники: $Log" }
}

function Copy-PubDependencies {
    $configFile = Join-Path $appRoot 'client/.dart_tool/package_config.json'
    if (!(Test-Path -LiteralPath $configFile)) { throw 'Сначала выполните flutter pub get из исходного client' }
    $configHash = (Get-FileHash -LiteralPath $configFile -Algorithm SHA256).Hash
    $ready = Join-Path $work 'pub-cache-ready.txt'
    if ((Test-Path -LiteralPath $ready) -and (Get-Content -LiteralPath $ready -Raw).Trim() -eq $configHash) { return }
    $cacheRoot = [IO.Path]::GetFullPath($PubCache).TrimEnd('\', '/')
    $config = Get-Content -LiteralPath $configFile -Raw | ConvertFrom-Json
    foreach ($package in $config.packages) {
        $uri = [uri]$package.rootUri
        if (!$uri.IsAbsoluteUri -or !$uri.IsFile) { continue }
        $packagePath = [IO.Path]::GetFullPath($uri.LocalPath).TrimEnd('\', '/')
        if (!$packagePath.StartsWith($cacheRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { continue }
        $relative = [IO.Path]::GetRelativePath($cacheRoot, $packagePath)
        Copy-Sources $packagePath (Join-Path $env:PUB_CACHE $relative) (Join-Path $work "copy-pub-$($package.name).log")
    }
    foreach ($metadata in @('hosted-hashes', 'hosted/pub.dev/.cache')) {
        if (Test-Path -LiteralPath (Join-Path $cacheRoot $metadata)) {
            Copy-Sources (Join-Path $cacheRoot $metadata) (Join-Path $env:PUB_CACHE $metadata) (Join-Path $work 'copy-pub-metadata.log')
        }
    }
    Set-Content -LiteralPath $ready -Value $configHash -Encoding ascii
}

function Test-Apk([string]$Path, [string]$Abi) {
    $buildTools = Get-ChildItem (Join-Path $AndroidSdk 'build-tools') -Directory |
        Where-Object Name -Match '^\d+\.\d+\.\d+$' |
        Sort-Object { [version]$_.Name } -Descending | Select-Object -First 1
    Invoke-Checked (Join-Path $buildTools.FullName 'apksigner.bat') @('verify', '--verbose', '--print-certs', $Path) (Join-Path $work "signature-$Abi.log")
    $badging = Join-Path $work "badging-$Abi.log"
    Invoke-Checked (Join-Path $buildTools.FullName 'aapt.exe') @('dump', 'badging', $Path) $badging
    if ((Get-Content -LiteralPath $badging -Raw) -notmatch "native-code: '$Abi'") { throw "Неверная архитектура APK: $Abi" }
    $archive = [IO.Compression.ZipFile]::OpenRead($Path)
    try {
        foreach ($library in @('libflutter.so', 'libspace_mls_bridge.so', 'libspace_voice.so')) {
            if (!$archive.GetEntry("lib/$Abi/$library")) { throw "В APK нет $library для $Abi" }
        }
    } finally { $archive.Dispose() }
}

function Get-NativeTestCount {
    $count = 0
    foreach ($module in @('app', 'flutter_webrtc')) {
        $reports = Join-Path $source "client/build/$module/test-results/testDebugUnitTest"
        $files = @(Get-ChildItem -LiteralPath $reports -Filter 'TEST-*.xml')
        if (!$files.Count) { throw "Нет результатов Android-тестов: $module" }
        foreach ($file in $files) {
            [xml]$result = Get-Content -LiteralPath $file.FullName -Raw
            if ([int]$result.testsuite.failures -ne 0 -or [int]$result.testsuite.errors -ne 0) { throw 'Android-тесты завершились с ошибкой' }
            $count += [int]$result.testsuite.tests
        }
    }
    return $count
}

try {
    if (!(Test-Path -LiteralPath (Join-Path $JavaHome 'bin/java.exe'))) { throw 'Не найден JDK: задайте JavaHome' }
    if (!(Test-Path -LiteralPath (Join-Path $AndroidSdk 'build-tools'))) { throw 'Не найден Android SDK: задайте AndroidSdk' }
    New-Item -ItemType Directory -Path $source -Force | Out-Null
    foreach ($directory in @('client', 'packages', 'native')) {
        Copy-Sources (Join-Path $appRoot $directory) (Join-Path $source $directory) (Join-Path $work "copy-$directory.log")
    }
    $temporary = Join-Path $work 'temporary'
    New-Item -ItemType Directory -Path $temporary -Force | Out-Null
    $env:TEMP = $temporary
    $env:TMP = $temporary
    $env:JAVA_HOME = $JavaHome
    $env:ANDROID_HOME = $AndroidSdk
    $env:ANDROID_SDK_ROOT = $AndroidSdk
    $env:GRADLE_USER_HOME = Join-Path $work 'gradle-home'
    $env:PUB_CACHE = Join-Path $work 'pub-cache'
    $env:CARGO_TARGET_DIR = Join-Path $work 'mls-native'
    $env:SPACE_VOICE_TARGET_DIR = Join-Path $work 'voice-native'
    Copy-PubDependencies
    # Копируем зависимости, сохраняя исходный пользовательский кеш.
    if (!$ResumeWork -and (Test-Path -LiteralPath $GradleCache)) {
        & robocopy $GradleCache $env:GRADLE_USER_HOME /E /XD daemon workers notifications .tmp /XF *.lock *.lck /R:1 /W:1 /NFL /NDL /NJH /NJS > (Join-Path $work 'copy-gradle.log') 2>&1
        if ($LASTEXITCODE -lt 0 -or $LASTEXITCODE -ge 8) { throw 'Не скопирован кеш Gradle' }
    }
    Push-Location (Join-Path $source 'client')
    try {
        Invoke-Checked 'flutter' @('pub', 'get', '--offline') (Join-Path $work 'pub-get.log')
        $gradleUsed = $true
        # Kotlin не умеет считать относительные пути между исходниками E: и Pub-кешем C:.
        Invoke-Checked 'flutter' @('build', 'apk', '--debug', '--no-pub', '--split-per-abi', '--android-project-arg=kotlin.incremental=false') (Join-Path $work 'apk-build.log')
        Push-Location 'android'
        try {
            Invoke-Checked './gradlew.bat' @('--no-daemon', '-Pkotlin.incremental=false', ':app:testDebugUnitTest', ':flutter_webrtc:testDebugUnitTest') (Join-Path $work 'android-unit-tests.log')
        } finally { Pop-Location }
        $output = Join-Path $work 'apk'
        New-Item -ItemType Directory -Path $output -Force | Out-Null
        $records = @()
        foreach ($abi in @('armeabi-v7a', 'arm64-v8a', 'x86_64')) {
            $apk = Join-Path $output "Space-feed-local-$abi-debug.apk"
            Copy-Item -LiteralPath "build/app/outputs/flutter-apk/app-$abi-debug.apk" -Destination $apk
            $item = Get-Item -LiteralPath $apk
            Test-Apk $apk $abi
            $hash = (Get-FileHash -LiteralPath $apk -Algorithm SHA256).Hash.ToLowerInvariant()
            $records += @{ abi = $abi; file = $item.Name; bytes = $item.Length; sha256 = $hash; signatureVerified = $true; nativeLibrariesVerified = $true }
        }
        @{ success = $true; mode = 'debug'; physicalDeviceTested = $false; nativeTestsPassed = (Get-NativeTestCount); artifacts = $records } |
            ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $output 'acceptance.json') -Encoding utf8
        Write-Output "Android APK и модульные тесты готовы: $output"
    } finally { Pop-Location }
} finally {
    if ($gradleUsed) {
        Push-Location (Join-Path $source 'client/android')
        try { & ./gradlew.bat --stop > (Join-Path $work 'gradle-stop.log') 2>&1 } finally { Pop-Location }
    }
    foreach ($name in $variables) { [Environment]::SetEnvironmentVariable($name, $saved[$name], 'Process') }
}
