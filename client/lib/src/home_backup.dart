import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'home_runtime.dart';
import 'local_failure.dart';

const missingHomeBackup = LocalFailure(
  LocalFailureCode.homeBackupMissing,
  'Резервная копия отсутствует; автоматическое восстановление заблокировано',
);
const invalidHomeBackup = LocalFailure(
  LocalFailureCode.homeBackupInvalid,
  'Резервная копия повреждена, неполна или недоступна',
);

Future<void> requireHomeBackup(Directory backup) async {
  try {
    final type = await FileSystemEntity.type(backup.path, followLinks: false);
    if (type == FileSystemEntityType.notFound) {
      throw missingHomeBackup;
    }
    if (type != FileSystemEntityType.directory ||
        await FileSystemEntity.type(
              '${backup.path}/backup.json',
              followLinks: false,
            ) !=
            FileSystemEntityType.file) {
      throw invalidHomeBackup;
    }
  } on LocalFailure {
    rethrow;
  } catch (_) {
    throw invalidHomeBackup;
  }
}

// Проверяем точный состав и SHA-256 до запуска восстановления и замены данных.
Future<void> verifyHomeBackup(Directory backup, HomeRelease release) async {
  await requireHomeBackup(backup);
  try {
    final manifest = File('${backup.path}/backup.json');
    if (await FileSystemEntity.type(backup.path, followLinks: false) !=
            FileSystemEntityType.directory ||
        await FileSystemEntity.type(manifest.path, followLinks: false) !=
            FileSystemEntityType.file ||
        await manifest.length() > 16 * 1024 * 1024) {
      throw invalidHomeBackup;
    }
    final saved = jsonDecode(await manifest.readAsString()) as Map;
    final platform = release.platform.split('-');
    if (saved['format'] != 1 ||
        saved['os'] !=
            (platform.first == 'macos' ? 'darwin' : platform.first) ||
        saved['arch'] != (platform.last == 'x64' ? 'amd64' : 'arm64') ||
        saved['postgresMajor'] != 17) {
      throw invalidHomeBackup;
    }
    final files = Map<String, dynamic>.from(saved['files'] as Map);
    final directories = (saved['directories'] as List).cast<String>();
    if (files.length + directories.length > 100000 ||
        directories.toSet().length != directories.length ||
        !files.containsKey('data/postgres/PG_VERSION') ||
        !files.containsKey('data/database-password')) {
      throw invalidHomeBackup;
    }
    final actualFiles = <String>{}, actualDirectories = <String>{};
    await for (final entry in backup.list(
      recursive: true,
      followLinks: false,
    )) {
      final name = entry.absolute.uri.path
          .substring(backup.absolute.uri.path.length)
          .replaceFirst(RegExp(r'/$'), '');
      if (name == 'backup.json') continue;
      if (entry is Directory) {
        actualDirectories.add(name);
      } else if (entry is File) {
        actualFiles.add(name);
        final expected = files[name];
        if (expected is! String ||
            !RegExp(r'^[0-9a-f]{64}$').hasMatch(expected) ||
            (await sha256.bind(entry.openRead()).first).toString() !=
                expected) {
          throw invalidHomeBackup;
        }
      } else {
        throw invalidHomeBackup;
      }
      if (actualFiles.length + actualDirectories.length > 100000) {
        throw invalidHomeBackup;
      }
    }
    if (actualFiles.length != files.length ||
        actualDirectories.length != directories.length ||
        !actualDirectories.containsAll(directories)) {
      throw invalidHomeBackup;
    }
  } catch (_) {
    throw invalidHomeBackup;
  }
}
