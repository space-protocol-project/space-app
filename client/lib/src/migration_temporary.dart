import 'dart:io';

import 'package:path/path.dart' as path;

Future<void> removeMigrationTemporary(Directory directory) async {
  final target = path.normalize(directory.absolute.path);
  final temporary = path.normalize(Directory.systemTemp.absolute.path);
  if (!path.equals(path.dirname(target), temporary) ||
      !path.basename(target).startsWith('space-migration-') ||
      await FileSystemEntity.type(target, followLinks: false) !=
          FileSystemEntityType.directory) {
    throw StateError('Не подтверждён временный каталог переноса');
  }
  await directory.delete(recursive: true);
}
