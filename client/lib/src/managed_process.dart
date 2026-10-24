import 'dart:io';

/// EOF переносим между ОС. Таймаут сохраняет процесс для диагностики и повтора.
Future<void> stopManagedProcess(
  Process process, {
  Duration inputTimeout = const Duration(seconds: 3),
  Duration exitTimeout = const Duration(seconds: 55),
  void Function()? onInputClosed,
}) async {
  await process.stdin.close().timeout(inputTimeout);
  onInputClosed?.call();
  final code = await process.exitCode.timeout(exitTimeout);
  if (code != 0) {
    throw StateError('Управляемый сервер завершился с кодом $code');
  }
}
