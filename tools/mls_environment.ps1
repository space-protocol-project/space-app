$project = Split-Path $PSScriptRoot -Parent
$mls = Join-Path $project '.local/mls'
$env:RUSTUP_HOME = Join-Path $mls 'space-mls-tools/rustup'
$env:CARGO_HOME = Join-Path $mls 'space-mls-tools/cargo'
$env:CARGO_TARGET_DIR = Join-Path $mls 'space-mls-target'
$env:TEMP = Join-Path $mls 'temp'
$env:TMP = $env:TEMP
New-Item -ItemType Directory -Path $env:TEMP -Force | Out-Null
$env:PATH = "$env:CARGO_HOME/bin;$env:PATH"
