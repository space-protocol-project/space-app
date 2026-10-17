import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

import 'support/temp_directory.dart';

void main() {
  const prefix = 'space-cleanup-helper-';
  late Directory root;
  setUp(() async {
    root = await Directory.systemTemp.createTemp(prefix);
  });
  tearDown(() => deleteTestDirectory(root, prefix: prefix));

  test(
    'Временная ошибка Windows повторяется с ограниченной задержкой',
    () async {
      final file = File(path.join(root.path, 'данные.txt'));
      await file.writeAsString('Тест');
      var attempts = 0;
      final pauses = <Duration>[];
      await deleteTestDirectory(
        root,
        prefix: prefix,
        windows: true,
        remove: (directory) async {
          attempts++;
          if (attempts <= 2) {
            throw FileSystemException(
              'Временно занято',
              directory.path,
              const OSError('Папка не пуста', 145),
            );
          }
          await directory.delete(recursive: true);
        },
        pause: (duration) async {
          pauses.add(duration);
        },
      );
      expect(attempts, 3);
      expect(pauses, [
        const Duration(milliseconds: 25),
        const Duration(milliseconds: 50),
      ]);
      expect(await root.exists(), isFalse);
    },
  );

  test('Постоянная блокировка не скрывается и не удаляет данные', () async {
    final file = File(path.join(root.path, 'data.txt'));
    await file.writeAsString('Оставить');
    var attempts = 0;
    await expectLater(
      deleteTestDirectory(
        root,
        prefix: prefix,
        windows: true,
        remove: (directory) async {
          attempts++;
          throw FileSystemException(
            'Занято',
            directory.path,
            const OSError('Sharing violation', 32),
          );
        },
        pause: (_) async {},
      ),
      throwsA(isA<FileSystemException>()),
    );
    expect(attempts, 6);
    expect(await file.readAsString(), 'Оставить');
  });

  test('Другие ошибки и другие ОС не получают повторов', () async {
    for (final entry in [(true, 13), (false, 145)]) {
      var attempts = 0;
      await expectLater(
        deleteTestDirectory(
          root,
          prefix: prefix,
          windows: entry.$1,
          remove: (directory) async {
            attempts++;
            throw FileSystemException(
              'Ошибка',
              directory.path,
              OSError('Ошибка', entry.$2),
            );
          },
          pause: (_) async {
            fail('Не должно быть задержки');
          },
        ),
        throwsA(isA<FileSystemException>()),
      );
      expect(attempts, 1);
    }
  });

  test('Нельзя удалить Temp целиком или каталог с другим префиксом', () async {
    for (final directory in [Directory.systemTemp, root]) {
      await expectLater(
        deleteTestDirectory(
          directory,
          prefix: 'space-another-',
          remove: (_) async {
            fail('Удаление не должно вызываться');
          },
        ),
        throwsArgumentError,
      );
    }
    expect(await root.exists(), isTrue);
  });

  test(
    'Исчезнувший каталог считается очищенным, обычный файл не удаляется',
    () async {
      await root.delete();
      await deleteTestDirectory(root, prefix: prefix);
      final file = File(root.path);
      await file.writeAsString('Не каталог');
      try {
        await expectLater(
          deleteTestDirectory(root, prefix: prefix),
          throwsStateError,
        );
        expect(await file.readAsString(), 'Не каталог');
      } finally {
        await file.delete();
      }
    },
  );
}
