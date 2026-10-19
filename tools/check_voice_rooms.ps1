param([Parameter(Mandatory=$true)][string]$Runtime,[switch]$PostgresOnly,[ValidateSet('direct','udp','tcp')][string]$Relay='direct',[switch]$Recovery)
$ErrorActionPreference='Stop'
$appRoot=Split-Path $PSScriptRoot -Parent
$serverRoot=Join-Path (Split-Path $appRoot -Parent) 'space-server'
$id=[guid]::NewGuid().ToString('N')
$work=Join-Path $appRoot ".local/voice-check-$id"
New-Item -ItemType Directory -Path $work | Out-Null
$pgBin=Join-Path $Runtime 'postgres/bin'
$data=Join-Path $work 'postgres'
$serverExe=Join-Path $work 'space-server.exe'
$pgStarted=$false
$server=$null
$turnHelper=$null
$turnExe=Join-Path $work 'turn-check.exe'
$previousTurnCheck=$env:SPACE_VOICE_TURN_CHECK
$previousTurnURLs=$env:SPACE_VOICE_TURN_URLS
$previousTurnSecret=$env:SPACE_VOICE_TURN_SECRET
$previousRelayOnly=$env:SPACE_VOICE_RELAY_ONLY
$extraVoiceEnvironment=@{}
foreach($setting in @('SPACE_VOICE_STUN_URLS','SPACE_VOICE_TURN_SECRET_FILE','SPACE_VOICE_PUBLIC_IP','SPACE_VOICE_UDP_MIN','SPACE_VOICE_UDP_MAX')){
 $extraVoiceEnvironment[$setting]=[Environment]::GetEnvironmentVariable($setting)
 [Environment]::SetEnvironmentVariable($setting,$null)
}
$env:SPACE_VOICE_TURN_URLS=$null
$env:SPACE_VOICE_TURN_SECRET=$null
$env:SPACE_VOICE_RELAY_ONLY=$null
$workers=@()
$captures=@()
$copies=@()
function Free-Port {
 $socket=[Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback,0)
 $socket.Start();$result=$socket.LocalEndpoint.Port;$socket.Stop();return $result
}
$pgPort=Free-Port
$httpPort=Free-Port
$grpcPort=Free-Port
$previousDb=$env:SPACE_DATABASE_URL
$previousTest=$env:SPACE_TEST_DATABASE_URL
$previousProbe=$env:SPACE_VOICE_DESKTOP_CHECK
$previousRecovery=$env:SPACE_VOICE_RECOVERY_CHECK
$env:SPACE_VOICE_RECOVERY_CHECK=if($Recovery){'1'}else{'0'}
try {
 & (Join-Path $pgBin 'initdb.exe') -D $data -U voice_test -A trust --encoding=UTF8 --no-locale > (Join-Path $work 'initdb.log') 2>&1
 if($LASTEXITCODE -ne 0){throw 'initdb failed'}
 $pgControl=Start-Process -FilePath (Join-Path $pgBin 'pg_ctl.exe') -ArgumentList @('-D',('"'+$data+'"'),'-l',('"'+(Join-Path $work 'postgres.log')+'"'),'-o',('"-h 127.0.0.1 -p '+$pgPort+'"'),'start') -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $work 'pg-start.log') -RedirectStandardError (Join-Path $work 'pg-start.stderr.log')
 $pgControl.WaitForExit()
 if($pgControl.ExitCode -ne 0){throw 'PostgreSQL start failed'}
 $pgStarted=$true
 $env:SPACE_DATABASE_URL="postgres://voice_test@127.0.0.1:$pgPort/postgres?sslmode=disable"
 $env:SPACE_TEST_DATABASE_URL=$env:SPACE_DATABASE_URL
 Push-Location $serverRoot
 try {
  go test ./internal/postgres -run 'TestVoice|TestChannelsIsolationPermissionsAndPersistence|TestMlsDeliveryOrderMembershipAndPlaintextRejection' -count=1 -v > (Join-Path $work 'postgres-tests.log') 2>&1
  if($LASTEXITCODE -ne 0){throw 'Voice PostgreSQL tests failed'}
  if($PostgresOnly){Get-Content (Join-Path $work 'postgres-tests.log');return}
  if($Relay -ne 'direct'){go build -o $turnExe ./cmd/space-voice-turn-check;if($LASTEXITCODE -ne 0){throw 'TURN fixture build failed'}}
  go build -o $serverExe ./cmd/space-server
  if($LASTEXITCODE -ne 0){throw 'Server build failed'}
 } finally {Pop-Location}
 & $serverExe -first-owner > (Join-Path $work 'owner-setup.log') 2>&1
 if($LASTEXITCODE -ne 0){throw 'Owner setup failed'}
 if($Relay -ne 'direct'){
  $env:SPACE_VOICE_TURN_CHECK='1'
  $turnHelper=Start-Process -FilePath $turnExe -ArgumentList ('"'+$work+'"') -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $work 'turn.stdout.log') -RedirectStandardError (Join-Path $work 'turn.stderr.log')
  $turnWait=[Diagnostics.Stopwatch]::StartNew()
  while(!(Test-Path -LiteralPath (Join-Path $work 'turn.json'))){
   if($turnHelper.HasExited -or $turnWait.Elapsed.TotalSeconds -gt 10){throw 'TURN fixture startup failed'}
   Start-Sleep -Milliseconds 100
  }
  $turnConfig=Get-Content -LiteralPath (Join-Path $work 'turn.json') -Raw | ConvertFrom-Json
  $env:SPACE_VOICE_TURN_URLS=$turnConfig.$Relay
  $env:SPACE_VOICE_TURN_SECRET=$turnConfig.secret
  $env:SPACE_VOICE_RELAY_ONLY='true'
 }
 $origin="http://127.0.0.1:$httpPort"
 $server=Start-Process -FilePath $serverExe -ArgumentList @('-http',"127.0.0.1:$httpPort",'-grpc',"127.0.0.1:$grpcPort",'-origin',$origin) -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $work 'server.stdout.log') -RedirectStandardError (Join-Path $work 'server.stderr.log')
 $ready=[Diagnostics.Stopwatch]::StartNew()
 while($true){
  if($server.HasExited){throw 'Server exited'}
  try {$response=Invoke-WebRequest "$origin/healthz" -TimeoutSec 1;if($response.StatusCode -eq 204){break}}catch{}
  if($ready.Elapsed.TotalSeconds -gt 30){throw 'Server timeout'}
  Start-Sleep -Milliseconds 100
 }
 . (Join-Path $PSScriptRoot 'mls_environment.ps1')
 Push-Location (Join-Path $appRoot 'client')
 try {
  flutter build windows --release --no-pub --target tool/voice_desktop_probe.dart > (Join-Path $work 'flutter-build.log') 2>&1
  if($LASTEXITCODE -ne 0){throw 'Voice probe build failed'}
 } finally {Pop-Location}
 $bundle=Join-Path $appRoot 'client/build/windows/x64/runner/Release'
 $env:SPACE_VOICE_DESKTOP_CHECK='1'
 foreach($role in @('A','B')){
  $exe=Join-Path $bundle "voice-check-$id-$role.exe"
  Copy-Item -LiteralPath (Join-Path $bundle 'space_client.exe') -Destination $exe
  $copies+=$exe
  $quotedWork='"'+$work+'"'
  # Потоки читаются средствами .NET: ожидание процесса не должно блокировать
  # PowerShell-обработчики вывода и заполнять stderr нативной библиотеки.
  $start=[Diagnostics.ProcessStartInfo]::new($exe)
  $start.Arguments="$origin $quotedWork $role"
  $start.WorkingDirectory=$bundle
  $start.UseShellExecute=$false
  $start.CreateNoWindow=$true
  $start.WindowStyle=[Diagnostics.ProcessWindowStyle]::Hidden
  $start.RedirectStandardOutput=$true
  $start.RedirectStandardError=$true
  $worker=[Diagnostics.Process]::Start($start)
  $output=[IO.File]::Create((Join-Path $work "$role.stdout.log"))
  $errors=[IO.File]::Create((Join-Path $work "$role.stderr.log"))
  $captures+=@{output=$output; errors=$errors; outTask=$worker.StandardOutput.BaseStream.CopyToAsync($output); errTask=$worker.StandardError.BaseStream.CopyToAsync($errors)}
  $workers+=$worker
  if($role -eq 'A'){
   $ready.Restart()
   while(!(Test-Path -LiteralPath (Join-Path $work 'room'))){
    if($worker.HasExited){throw 'First voice client exited'}
    if($ready.Elapsed.TotalSeconds -gt 40){throw 'Voice owner timeout'}
    Start-Sleep -Milliseconds 100
   }
  }
 }
 if($Recovery){
  foreach($phase in @('recovery-ready','reconnecting')){
   $ready.Restart()
   while(!(Test-Path -LiteralPath (Join-Path $work "A-$phase")) -or !(Test-Path -LiteralPath (Join-Path $work "B-$phase"))){
    if(@($workers|Where-Object {$_.HasExited}).Count -gt 0){throw "Voice client exited before $phase; logs: $work"}
    if($ready.Elapsed.TotalSeconds -gt 65){throw "Voice recovery timeout: $phase; logs: $work"}
    Start-Sleep -Milliseconds 100
   }
   if($phase -eq 'recovery-ready'){$server.Kill();$server.WaitForExit()}
  }
  $server=Start-Process -FilePath $serverExe -ArgumentList @('-http',"127.0.0.1:$httpPort",'-grpc',"127.0.0.1:$grpcPort",'-origin',$origin) -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $work 'server-restarted.stdout.log') -RedirectStandardError (Join-Path $work 'server-restarted.stderr.log')
 }
 foreach($worker in $workers){if(!$worker.WaitForExit(90000)){throw 'Voice client timeout'};if($worker.ExitCode -ne 0){throw "Voice client failed; logs: $work"}}
 $reports=@('A','B')|ForEach-Object {Get-Content -LiteralPath (Join-Path $work "$_.json") -Raw|ConvertFrom-Json}
 if(!$reports[0].success -or !$reports[1].success -or $reports[0].pid -eq $reports[1].pid){throw 'Two independent clients were not verified'}
 if($Recovery -and (!$reports[0].reconnected -or !$reports[1].reconnected)){throw 'Recovery was not verified'}
 $reports|Select-Object role,pid,sent,received,samples|Format-Table
 Write-Output "Voice check passed: $work"
} finally {
 foreach($worker in $workers){if(!$worker.HasExited){$worker.Kill();$worker.WaitForExit()}}
 foreach($capture in $captures){
  try{$null=$capture.outTask.GetAwaiter().GetResult();$null=$capture.errTask.GetAwaiter().GetResult()}
  finally{$capture.output.Dispose();$capture.errors.Dispose()}
 }
 if($turnHelper -and !$turnHelper.HasExited){
  [IO.File]::WriteAllText((Join-Path $work 'turn.stop'),'stop')
  if(!$turnHelper.WaitForExit(5000)){$turnHelper.Kill();$turnHelper.WaitForExit()}
 }
 foreach($setting in $extraVoiceEnvironment.Keys){[Environment]::SetEnvironmentVariable($setting,$extraVoiceEnvironment[$setting])}
 $env:SPACE_VOICE_TURN_CHECK=$previousTurnCheck
 $env:SPACE_VOICE_TURN_URLS=$previousTurnURLs
 $env:SPACE_VOICE_TURN_SECRET=$previousTurnSecret
 $env:SPACE_VOICE_RELAY_ONLY=$previousRelayOnly
 if($server -and !$server.HasExited){$server.Kill();$server.WaitForExit()}
 if($pgStarted){& (Join-Path $pgBin 'pg_ctl.exe') -D $data -m fast stop > (Join-Path $work 'pg-stop.log') 2>&1}
 $env:SPACE_DATABASE_URL=$previousDb
 $env:SPACE_TEST_DATABASE_URL=$previousTest
 $env:SPACE_VOICE_DESKTOP_CHECK=$previousProbe
 $env:SPACE_VOICE_RECOVERY_CHECK=$previousRecovery
 foreach($exe in $copies){if(Test-Path -LiteralPath $exe){Remove-Item -LiteralPath $exe}}
 # Только собственные одноразовые данные после остановки PostgreSQL.
 $expectedRoot=[IO.Path]::GetFullPath((Join-Path $appRoot ".local/voice-check-$id"))
 $resolvedData=[IO.Path]::GetFullPath($data)
 if($pgStarted -and $LASTEXITCODE -eq 0 -and [IO.Path]::GetDirectoryName($resolvedData) -eq $expectedRoot -and [IO.Path]::GetFileName($resolvedData) -eq 'postgres'){
  Remove-Item -LiteralPath $resolvedData -Recurse -Force
 }
 if(Test-Path -LiteralPath $serverExe){Remove-Item -LiteralPath $serverExe}
 if(Test-Path -LiteralPath $turnExe){Remove-Item -LiteralPath $turnExe}
}
