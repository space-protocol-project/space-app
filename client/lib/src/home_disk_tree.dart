import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

/// Обход без ссылок; тот же снимок используется при подтверждении очистки.
Future<(int, String)> homeDiskTree(Directory folder) async {
  await requireHomeDiskDirectory(folder);
  var bytes = 0;
  final entries = <String>[];
  await for (final entry in folder.list(recursive: true, followLinks: false)) {
    final type = await FileSystemEntity.type(entry.path, followLinks: false);
    if (type != FileSystemEntityType.file &&
        type != FileSystemEntityType.directory) {
      throw const FormatException(
        'Каталог содержит ссылки или недоступные файлы',
      );
    }
    final stat = await entry.stat();
    if (type == FileSystemEntityType.file) bytes += stat.size;
    entries.add(
      jsonEncode([
        path.relative(entry.path, from: folder.path),
        type.toString(),
        stat.size,
        stat.modified.microsecondsSinceEpoch,
      ]),
    );
    if (entries.length > 200000) {
      throw const FormatException('Слишком большой каталог для очистки');
    }
  }
  entries.sort();
  return (bytes, sha256.convert(utf8.encode(entries.join('\n'))).toString());
}

Future<void> requireHomeDiskDirectory(Directory folder) async {
  if (await FileSystemEntity.type(folder.path, followLinks: false) !=
      FileSystemEntityType.directory) {
    throw const FormatException('Очистка каталога со ссылками запрещена');
  }
}

/// Только непосредственный потомок известного управляемого каталога.
Future<Directory> homeDiskChild(
  Directory root,
  String category,
  String name,
) async {
  await requireHomeDiskDirectory(root);
  final parent = Directory(path.join(root.path, category));
  await requireHomeDiskDirectory(parent);
  if (!path.equals(
    path.dirname(await parent.resolveSymbolicLinks()),
    await root.resolveSymbolicLinks(),
  )) {
    throw const FormatException('Каталог выходит за границы хранилища');
  }
  if (name != path.basename(name) || name == '.' || name == '..') {
    throw const FormatException('Недопустимый путь очистки');
  }
  final child = Directory(path.join(parent.path, name));
  await requireHomeDiskDirectory(child);
  if (!path.equals(
    path.dirname(await child.resolveSymbolicLinks()),
    await parent.resolveSymbolicLinks(),
  )) {
    throw const FormatException('Каталог выходит за границы хранилища');
  }
  return Directory(await child.resolveSymbolicLinks());
}

/// Без recursive delete: ссылка, появившаяся после проверки, останавливает обход.
Future<void> deleteHomeDiskTree(Directory folder) async {
  await requireHomeDiskDirectory(folder);
  final canonical = Directory(await folder.resolveSymbolicLinks());
  await for (final entry in canonical.list(followLinks: false)) {
    final type = await FileSystemEntity.type(entry.path, followLinks: false);
    if (type == FileSystemEntityType.directory) {
      await deleteHomeDiskTree(Directory(entry.path));
    } else if (type == FileSystemEntityType.file) {
      await File(entry.path).delete();
    } else {
      throw const FormatException(
        'Состав каталога изменился; очистка остановлена',
      );
    }
  }
  await canonical.delete();
}
