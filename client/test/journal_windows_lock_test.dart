import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_update_journal.dart';

import 'home_installation_test.dart' show release;

import 'support/temp_directory.dart';

typedef _OpenNative = IntPtr Function(
  Pointer<Utf16>,
  Uint32,
  Uint32,
  Pointer<Void>,
  Uint32,
  Uint32,
  IntPtr,
);
typedef _Open = int Function(
  Pointer<Utf16>,
  int,
  int,
  Pointer<Void>,
  int,
  int,
  int,
);
typedef _CloseNative = Int32 Function(IntPtr);

void main() {
  test(
    'Заблокированный журнал сохраняет прежнюю запись до атомарной замены',
    () async {
      final root = await Directory.systemTemp.createTemp('space-journal-lock-');
      addTearDown(
        () => deleteTestDirectory(root, prefix: 'space-journal-lock-'),
      );
      final journal = HomeUpdateJournal(root);
      final original = await journal.begin(
        release('v0.1.0'),
        release('v0.2.0'),
      );
      final kernel = DynamicLibrary.open('kernel32.dll');
      final open = kernel.lookupFunction<_OpenNative, _Open>('CreateFileW');
      final close = kernel.lookupFunction<_CloseNative, int Function(int)>(
        'CloseHandle',
      );
      final path = journal.file.path.toNativeUtf16(allocator: calloc);
      // Разрешаем чтение и запись, удерживая запрет удаления/переименования.
      final handle = open(path, 0x80000000, 3, nullptr, 3, 0x80, 0);
      calloc.free(path);
      expect(handle, isNot(-1));
      var completed = false;
      final pending = journal.advance(original.id, HomeUpdateStep.staged).then((
        record,
      ) {
        completed = true;
        return record;
      });
      try {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(completed, isFalse);
        expect((await journal.read())!.step, HomeUpdateStep.preparing);
      } finally {
        close(handle);
      }
      expect((await pending).step, HomeUpdateStep.staged);
      expect((await journal.read())!.step, HomeUpdateStep.staged);
      final nextPath = journal.file.path.toNativeUtf16(allocator: calloc);
      final held = open(nextPath, 0x80000000, 3, nullptr, 3, 0x80, 0);
      calloc.free(nextPath);
      expect(held, isNot(-1));
      try {
        await expectLater(
          journal
              .advance(original.id, HomeUpdateStep.stopped)
              .timeout(const Duration(seconds: 5)),
          throwsA(isA<FileSystemException>()),
        );
        expect((await journal.read())!.step, HomeUpdateStep.staged);
      } finally {
        close(held);
      }
      expect(
        (await journal.advance(original.id, HomeUpdateStep.stopped)).step,
        HomeUpdateStep.stopped,
      );
    },
    skip: !Platform.isWindows,
  );
}
