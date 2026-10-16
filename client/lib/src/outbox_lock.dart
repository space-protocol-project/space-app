import 'dart:async';
import 'dart:io';

/// Общая очередь операций процесса и блокировка между процессами.
class OutboxLock {
  static final _operations = <String, Future<void>>{};

  static Future<T> run<T>(String path, Future<T> Function() action) async {
    final previous = _operations[path] ?? Future<void>.value();
    final done = Completer<void>();
    _operations[path] = done.future;
    await previous;
    RandomAccessFile? file;
    try {
      file = await File(path).open(mode: FileMode.append);
      await file.lock(FileLock.blockingExclusive);
      return await action();
    } finally {
      try {
        await file?.close();
      } finally {
        done.complete();
        if (identical(_operations[path], done.future)) _operations.remove(path);
      }
    }
  }
}
