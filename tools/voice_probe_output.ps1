# Непрерывно читаем оба канала: синхронная Windows pipe не должна занимать
# общий ThreadPool и задерживать второй канал или второй процесс.
if (-not ('SpaceVoiceProbeOutput' -as [type])) {
 Add-Type -TypeDefinition @'
using System.IO;
using System.Threading;
using System.Threading.Tasks;

public static class SpaceVoiceProbeOutput {
  public static Task Copy(Stream input, Stream output) {
    return Task.Factory.StartNew(() => {
      var buffer = new byte[4096];
      int count;
      while ((count = input.Read(buffer, 0, buffer.Length)) != 0) {
        output.Write(buffer, 0, count);
        output.Flush();
      }
    }, CancellationToken.None, TaskCreationOptions.LongRunning,
       TaskScheduler.Default);
  }
}
'@
}
