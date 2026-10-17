import 'dart:io';

import 'package:path/path.dart' as path;

// Только каталоги, созданные тестом непосредственно в системном Temp.
Future<void> deleteTestDirectory(
  Directory directory, {
  required String prefix,
  bool? windows,
  Future<void> Function(Directory)? remove,
  Future<void> Function(Duration)? pause,
}) async {
  final target = path.normalize(directory.absolute.path);
  final temporary = path.normalize(Directory.systemTemp.absolute.path);
  if (!path.equals(path.dirname(target), temporary) ||
      !(prefix.startsWith('space-') ||
          prefix.startsWith('space ') ||
          prefix.startsWith('mls-')) ||
      !path.basename(target).startsWith(prefix)) {
    throw ArgumentError(
      'Очистка разрешена только для временного каталога теста',
    );
  }
  for (var attempt = 0; ; attempt++) {
    final type = await FileSystemEntity.type(target, followLinks: false);
    if (type == FileSystemEntityType.notFound) return;
    if (type != FileSystemEntityType.directory) {
      throw StateError('Временный каталог подменён ссылкой или файлом');
    }
    try {
      await (remove ?? _removeDirectory)(directory);
      return;
    } on FileSystemException catch (error) {
      if (!_retryCleanup(error, windows ?? Platform.isWindows, attempt)) {
        rethrow;
      }
      await (pause ?? Future<void>.delayed)(
        Duration(milliseconds: 25 << attempt),
      );
    }
  }
}

Future<void> _removeDirectory(Directory directory) async {
  await directory.delete(recursive: true);
}

bool _retryCleanup(FileSystemException error, bool windows, int attempt) =>
    windows &&
    attempt < 5 &&
    const [5, 32, 145].contains(error.osError?.errorCode);
