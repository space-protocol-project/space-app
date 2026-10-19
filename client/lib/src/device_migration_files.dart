import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

bool deviceFileName(String name) =>
    name == 'home.zip' ||
    name == 'home-backups.zip' ||
    RegExp(r'^outbox-files/[a-f0-9]{64}/[a-f0-9]{64}\.bin$').hasMatch(name);

Future<String> deviceFileDigest(File file) async =>
    (await sha256.bind(file.openRead()).first).toString();

Future<Map<String, String>> packDeviceFilesInWorker(
  Map<String, String?> args,
) => packDeviceFiles(
  root: Directory(args['root']!),
  destination: File(args['destination']!),
  home: args['home'] == null ? null : File(args['home']!),
  backups: args['backups'] == null ? null : File(args['backups']!),
);

Future<Map<String, String>> packDeviceFiles({
  required Directory root,
  required File destination,
  File? home,
  File? backups,
}) async {
  final encoder = ZipFileEncoder()..create(destination.path, level: 0);
  final hashes = <String, String>{};
  try {
    if (home != null) {
      hashes['home.zip'] = await deviceFileDigest(home);
      await encoder.addFile(home, 'home.zip');
    }
    if (backups != null) {
      hashes['home-backups.zip'] = await deviceFileDigest(backups);
      await encoder.addFile(backups, 'home-backups.zip');
    }
    final folder = Directory(p.join(root.path, 'outbox-files'));
    if (await folder.exists()) {
      if (await FileSystemEntity.type(folder.path, followLinks: false) !=
          FileSystemEntityType.directory) {
        throw StateError('Недопустимый каталог очереди файлов');
      }
      await _packQueue(folder, encoder, hashes);
    }
  } finally {
    encoder.closeSync();
  }
  final input = InputFileStream(destination.path);
  try {
    _validateEntries(ZipDecoder().decodeStream(input), hashes);
  } finally {
    input.closeSync();
  }
  return hashes;
}

Future<void> _packQueue(
  Directory folder,
  ZipFileEncoder encoder,
  Map<String, String> hashes,
) async {
  final base = await folder.resolveSymbolicLinks();
  await for (final entity in folder.list(recursive: true, followLinks: false)) {
    if (entity is Link) {
      throw StateError('Ссылки в очереди файлов не переносятся');
    }
    if (entity is! File) continue;
    final resolved = await entity.resolveSymbolicLinks();
    if (!p.isWithin(base, resolved)) throw StateError('Файл вне очереди');
    final name =
        'outbox-files/${p.relative(resolved, from: base).replaceAll('\\', '/')}';
    if (!deviceFileName(name)) {
      throw StateError('Сначала завершите добавление вложений в очередь');
    }
    hashes[name] = await deviceFileDigest(entity);
    await encoder.addFile(entity, name);
  }
}

void unpackDeviceFiles(Map<String, dynamic> args) {
  final input = InputFileStream(args['source'] as String);
  try {
    final archive = ZipDecoder().decodeStream(input);
    final hashes = Map<String, String>.from(args['hashes'] as Map);
    _validateEntries(archive, hashes);
    for (final entry in archive) {
      _extract(entry, args['destination'] as String);
    }
  } finally {
    input.closeSync();
  }
}

void _validateEntries(Archive archive, Map<String, String> hashes) {
  var size = 0;
  final names = <String>{};
  for (final entry in archive) {
    size += entry.size;
    if (!entry.isFile ||
        entry.isSymbolicLink ||
        !deviceFileName(entry.name) ||
        !names.add(entry.name) ||
        !hashes.containsKey(entry.name) ||
        entry.size < 0 ||
        size > MigrationFileLimits.maxBytes) {
      throw const FormatException(
        'Недопустимое содержимое переноса устройства',
      );
    }
  }
  if (names.length != hashes.length || names.length > 50000) {
    throw const FormatException('Неполный набор файлов устройства');
  }
}

void _extract(ArchiveFile entry, String destination) {
  final file = File(p.join(destination, entry.name));
  file.parent.createSync(recursive: true);
  final output = OutputFileStream(file.path);
  try {
    entry.writeContent(output);
  } finally {
    output.closeSync();
  }
}

class MigrationFileLimits {
  static const maxBytes = 2 * 1024 * 1024 * 1024;
}

Future<void> verifyDeviceFiles(
  Directory folder,
  Map<String, String> hashes,
) async {
  for (final entry in hashes.entries) {
    if (!deviceFileName(entry.key) ||
        await deviceFileDigest(File(p.join(folder.path, entry.key))) !=
            entry.value) {
      throw const FormatException('Повреждены файлы переноса устройства');
    }
  }
}

Future<void> installDeviceFiles(
  Directory source,
  Directory target,
  Map<String, String> hashes,
) async {
  for (final name in hashes.keys.where(
    (name) => name.startsWith('outbox-files/'),
  )) {
    final file = File(p.join(target.path, name));
    await _requireSafeParent(target, file.parent);
    if (await file.exists()) {
      if (await deviceFileDigest(file) != hashes[name]) {
        throw StateError('На новом устройстве уже есть другое вложение');
      }
      continue;
    }
    if (await FileSystemEntity.type(file.path, followLinks: false) !=
        FileSystemEntityType.notFound) {
      throw StateError('Недопустимый файл');
    }
    final pending = File('${file.path}.migration');
    final type = await FileSystemEntity.type(pending.path, followLinks: false);
    if (type != FileSystemEntityType.notFound &&
        type != FileSystemEntityType.file) {
      throw StateError('Недопустимый временный файл вложения');
    }
    await File(p.join(source.path, name)).copy(pending.path);
    if (await deviceFileDigest(pending) != hashes[name]) {
      throw StateError('Не подтверждено сохранение вложения');
    }
    await pending.rename(file.path);
  }
}

Future<void> _requireSafeParent(Directory root, Directory folder) async {
  await root.create(recursive: true);
  final base = await root.resolveSymbolicLinks();
  final relative = p.relative(folder.path, from: root.path);
  var parent = root.path;
  for (final part in p.split(relative)) {
    parent = p.join(parent, part);
    final type = await FileSystemEntity.type(parent, followLinks: false);
    if (type == FileSystemEntityType.notFound) await Directory(parent).create();
    if (!p.isWithin(base, await Directory(parent).resolveSymbolicLinks())) {
      throw StateError('Каталог вложений находится вне приложения');
    }
  }
}
