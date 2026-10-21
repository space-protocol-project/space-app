param([string]$AndroidRoot)
$project = Split-Path $PSScriptRoot -Parent
$android = $AndroidRoot
if (-not $android) { $android = Join-Path $project '.local/android' }
if (-not (Test-Path -LiteralPath $android)) {
    $android = Join-Path (Split-Path $project -Parent) 'android'
}
$env:ANDROID_HOME = Join-Path $android 'sdk'
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$env:JAVA_HOME = Join-Path $android 'java/jdk-21.0.12.1+1'
$env:GRADLE_USER_HOME = Join-Path $android 'gradle-home'
$env:TEMP = Join-Path $project '.local/temp'
$env:TMP = $env:TEMP
New-Item -ItemType Directory -Path $env:TEMP -Force | Out-Null
$env:PATH = "$env:JAVA_HOME/bin;$env:ANDROID_HOME/platform-tools;$env:PATH"
