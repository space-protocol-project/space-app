param([switch]$SharedPool)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'voice_probe_output.ps1')
$clients=@()
$copies=@()
$workerMin=0;$ioMin=0;$workerMax=0;$ioMax=0
[Threading.ThreadPool]::GetMinThreads([ref]$workerMin,[ref]$ioMin)
[Threading.ThreadPool]::GetMaxThreads([ref]$workerMax,[ref]$ioMax)
try {
 # Один ожидающий stdout занимает общий пул. Чтение stderr должно работать
 # независимо: иначе заполненная pipe блокирует сам проверяемый процесс.
 if(![Threading.ThreadPool]::SetMinThreads(1,$ioMin)){throw 'Cannot set minimum threads'}
 if(![Threading.ThreadPool]::SetMaxThreads(1,$ioMax)){throw 'Cannot constrain test pool'}
 foreach($role in 1,2){
  $start=[Diagnostics.ProcessStartInfo]::new((Get-Command python).Source)
  $start.ArgumentList.Add('-c')
  $start.ArgumentList.Add("import os; os.write(2,b'x'*262144); os.write(1,b'ready')")
  $start.UseShellExecute=$false
  $start.CreateNoWindow=$true
  $start.RedirectStandardOutput=$true
  $start.RedirectStandardError=$true
  $process=[Diagnostics.Process]::Start($start)
  $clients+=$process
  foreach($pipe in $process.StandardOutput,$process.StandardError){
   $buffer=[IO.MemoryStream]::new()
   $task=if($SharedPool){$pipe.BaseStream.CopyToAsync($buffer)}else{[SpaceVoiceProbeOutput]::Copy($pipe.BaseStream,$buffer)}
   $copies+=@{buffer=$buffer;task=$task}
  }
 }
 foreach($process in $clients){
  if(!$process.WaitForExit(5000)){throw 'Output pipe blocked the child process'}
  if($process.ExitCode -ne 0){throw 'Output fixture failed'}
 }
 foreach($copy in $copies){$null=$copy.task.GetAwaiter().GetResult()}
 $lengths=@($copies|ForEach-Object {$_.buffer.Length})
 if(($lengths -join ',') -ne '5,262144,5,262144'){throw "Truncated output: $lengths"}
 Write-Output 'Both clients drained stdout/stderr with an occupied shared pool'
} finally {
 [void][Threading.ThreadPool]::SetMaxThreads($workerMax,$ioMax)
 [void][Threading.ThreadPool]::SetMinThreads($workerMin,$ioMin)
 foreach($process in $clients){if(!$process.HasExited){$process.Kill();$process.WaitForExit()}}
 foreach($copy in $copies){
  try{$null=$copy.task.GetAwaiter().GetResult()}finally{$copy.buffer.Dispose()}
 }
 foreach($process in $clients){$process.Dispose()}
}
