import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'device_migration_files.dart';
import 'home_controller.dart';
import 'home_disk_tree.dart';
import 'home_network.dart';
import 'home_runtime.dart';
import 'migration_temporary.dart';

Future<Map<String, dynamic>> readMigrationHomeSettings(
  Directory root,
  HomeNetwork? network,
) async {
  if (network == null) return {};
  final policy = File(p.join(root.path, 'backup-policy.json'));
  return {
    'network': network.toJson(),
    if (await policy.exists())
      'backup_policy': jsonDecode(await policy.readAsString()),
  };
}

void validateMigrationHomeSettings(Map<String, dynamic> settings) {
  if (settings.isEmpty) return;
  HomeNetwork.fromJson(Map<String, dynamic>.from(settings['network'] as Map));
  if (settings['backup_policy'] != null) {
    HomeBackupPolicy.fromJson(
      Map<String, dynamic>.from(settings['backup_policy'] as Map),
    );
  }
}

Future<void> installMigrationHomeSettings(
  Directory root,
  Map<String, dynamic> settings,
  HomeController home,
) async {
  validateMigrationHomeSettings(settings);
  if (settings.isEmpty) return;
  final saved = HomeNetwork.fromJson(
    Map<String, dynamic>.from(settings['network'] as Map),
  );
  final current = home.network!;
  if (saved.identityOrigin != current.identityOrigin) {
    throw const FormatException('Настройки принадлежат другому Эфиру');
  }
  final adapted = saved.changed(
    [current.endpoints.first, ...saved.endpoints.skip(1)],
    saved.listenHost,
    saved.listenPort,
  );
  await adapted.write(root);
  home.network = adapted;
  if (settings['backup_policy'] != null) {
    await File(p.join(root.path, 'backup-policy.json'))
        .writeAsString(jsonEncode(settings['backup_policy']), flush: true);
  }
}

Future<File?> packHomeBackups(Directory home, Directory temporary) async {
  final backups = Directory(p.join(home.path, 'backups'));
  if (!await backups.exists()) return null;
  final (bytes, _) = await homeDiskTree(backups);
  if (bytes > MigrationFileLimits.maxBytes) {
    throw StateError('Резервные копии превышают предел полного переноса 2 ГиБ');
  }
  if (await backups.list(recursive: true, followLinks: false).length > 50000) {
    throw StateError('Слишком много файлов в резервных копиях для переноса');
  }
  final file = File(p.join(temporary.path, 'home-backups.zip'));
  await compute(_packBackups, {
    'source': backups.path,
    'destination': file.path,
  });
  return file;
}

Future<void> _packBackups(Map<String, String> args) async {
  final file = File(args['destination']!);
  final backups = Directory(args['source']!);
  final encoder = ZipFileEncoder()..create(file.path);
  try {
    await encoder.addDirectory(backups, includeDirName: false);
  } finally {
    encoder.closeSync();
  }
}

Future<void> installHomeBackups(File archive, Directory home) async {
  final digest = await deviceFileDigest(archive);
  final receipt = File(p.join(home.path, 'device-backups.sha256'));
  if (await receipt.exists()) {
    if (await receipt.readAsString() != digest) {
      throw StateError('Другой архив резервных копий');
    }
    return;
  }
  final target = Directory(p.join(home.path, 'backups'));
  await target.create(recursive: true);
  await homeDiskTree(target);
  final temporary = await Directory.systemTemp.createTemp('space-migration-');
  try {
    await compute(_restoreBackups, {
      'archive': archive.path,
      'target': temporary.path,
    });
    await _installBackupTree(temporary, target);
    await receipt.writeAsString(digest, flush: true);
  } finally {
    await removeMigrationTemporary(temporary);
  }
}

void _restoreBackups(Map<String, String> args) =>
    extractVerifiedHomeArchive(args['archive']!, args['target']!);

Future<void> _installBackupTree(Directory source, Directory target) async {
  await for (final entry in source.list(recursive: true, followLinks: false)) {
    final destination = p.join(
      target.path,
      p.relative(entry.path, from: source.path),
    );
    if (entry is Directory) {
      await Directory(destination).create(recursive: true);
    } else if (entry is File) {
      await _installBackupFile(entry, File(destination));
    }
  }
}

Future<void> _installBackupFile(File source, File target) async {
  final digest = await deviceFileDigest(source);
  if (await target.exists()) {
    if (await deviceFileDigest(target) != digest) {
      throw StateError('На новом устройстве уже есть другая резервная копия');
    }
    return;
  }
  await target.parent.create(recursive: true);
  final pending = File('${target.path}.migration');
  await source.copy(pending.path);
  if (await deviceFileDigest(pending) != digest) {
    throw StateError('Повреждена резервная копия');
  }
  await pending.rename(target.path);
}
