import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_backup.dart';
import 'package:space_client/src/local_failure.dart';

import 'home_installation_test.dart' show release;

import 'support/temp_directory.dart';

Future<void> writeBackupManifest(Directory root) async {
  final files = <String, String>{}, directories = <String>[];
  await for (final entry in root.list(recursive: true, followLinks: false)) {
    final name = entry.absolute.uri.path
        .substring(root.absolute.uri.path.length)
        .replaceFirst(RegExp(r'/$'), '');
    if (name == 'backup.json') continue;
    if (entry is File) {
      files[name] = (await sha256.bind(entry.openRead()).first).toString();
    }
    if (entry is Directory) directories.add(name);
  }
  await File('${root.path}/backup.json').writeAsString(
    jsonEncode({
      'format': 1,
      'os': 'windows',
      'arch': 'amd64',
      'postgresMajor': 17,
      'files': files,
      'directories': directories,
    }),
  );
}

void main() {
  late Directory root;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-backup-check-');
    await Directory('${root.path}/data/postgres').create(recursive: true);
    await File('${root.path}/data/postgres/PG_VERSION').writeAsString('17');
    await File('${root.path}/data/database-password').writeAsString('fixture');
    await File('${root.path}/data/server.key').writeAsString('fixture');
    await writeBackupManifest(root);
  });
  tearDown(() => deleteTestDirectory(root, prefix: 'space-backup-check-'));
  test(
    'Полная копия проходит проверку; отсутствие каталога имеет отдельный код',
    () async {
      await verifyHomeBackup(root, release('v0.2.0'));
      await expectLater(
        verifyHomeBackup(Directory('${root.path}/missing'), release('v0.2.0')),
        throwsA(
          isA<LocalFailure>().having(
            (e) => e.code,
            'code',
            LocalFailureCode.homeBackupMissing,
          ),
        ),
      );
    },
  );
  for (final mutation in [
    'changed',
    'missing',
    'extra',
    'manifest',
    'platform',
    'directory',
  ]) {
    test('Повреждённая копия отклоняется: $mutation', () async {
      final key = File('${root.path}/data/server.key');
      switch (mutation) {
        case 'changed':
          await key.writeAsString('changed');
        case 'missing':
          await key.delete();
        case 'extra':
          await File('${root.path}/extra').writeAsString('extra');
        case 'manifest':
          await File('${root.path}/backup.json').writeAsString('{');
        case 'platform':
          final file = File('${root.path}/backup.json');
          final data = jsonDecode(await file.readAsString()) as Map;
          data['os'] = 'linux';
          await file.writeAsString(jsonEncode(data));
        case 'directory':
          await Directory('${root.path}/extra-dir').create();
      }
      await expectLater(
        verifyHomeBackup(root, release('v0.2.0')),
        throwsA(
          isA<LocalFailure>().having(
            (e) => e.code,
            'code',
            LocalFailureCode.homeBackupInvalid,
          ),
        ),
      );
    });
  }
}
