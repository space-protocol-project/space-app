import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/managed_process.dart';

Future<Process> _child({bool hang = false, int code = 0}) async {
  final script = Platform.isWindows
      ? "Write-Output 'ready'; [Console]::Out.Flush(); \$null = [Console]::In.ReadToEnd(); ${hang ? 'Start-Sleep -Seconds 60;' : ''} Write-Output 'flushed'; exit $code"
      : "echo ready; cat >/dev/null; ${hang ? 'while :; do :; done;' : ''} echo flushed; exit $code";
  final process = await Process.start(
    Platform.isWindows ? 'powershell.exe' : '/bin/sh',
    Platform.isWindows
        ? ['-NoProfile', '-NonInteractive', '-Command', script]
        : ['-c', script],
  );
  addTearDown(() async {
    process.kill();
    await process.exitCode;
  });
  return process;
}

void main() {
  test(
    'EOF дожидается сохранения и штатного выхода настоящего дочернего процесса',
    () async {
      final process = await _child();
      final output = utf8.decoder.bind(process.stdout).join();
      final errors = utf8.decoder.bind(process.stderr).join();
      var inputClosed = false;
      await stopManagedProcess(
        process,
        onInputClosed: () => inputClosed = true,
      );
      expect(inputClosed, true);
      expect(await output, contains('flushed'));
      expect(await errors, isEmpty);
      expect(await process.exitCode, 0);
    },
  );

  test('Ненулевой код не считается подтверждением остановки', () async {
    final process = await _child(code: 7);
    process.stdout.drain<void>();
    process.stderr.drain<void>();
    await expectLater(stopManagedProcess(process), throwsStateError);
    expect(await process.exitCode, 7);
  });

  test('Таймаут ограничивает ожидание и не убивает процесс', () async {
    final process = await _child(hang: true);
    final ready = Completer<void>();
    process.stdout.transform(utf8.decoder).listen((data) {
      if (data.contains('ready') && !ready.isCompleted) ready.complete();
    });
    process.stderr.drain<void>();
    await ready.future.timeout(const Duration(seconds: 10));
    var exited = false;
    unawaited(process.exitCode.then((_) => exited = true));
    await expectLater(
      stopManagedProcess(
        process,
        exitTimeout: const Duration(milliseconds: 30),
      ),
      throwsA(isA<TimeoutException>()),
    );
    expect(exited, false);
    expect(process.kill(), true);
  });
}
