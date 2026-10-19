import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/device_migration_files.dart';

import 'support/temp_directory.dart';

void main() {
  for (final name in [
    '../outside',
    '/absolute',
    'home.zip/../outside',
    'outbox-files/bad/file.bin',
  ]) {
    test('Посторонний путь $name отклоняется до извлечения', () async {
      final root = await Directory.systemTemp.createTemp(
        'space-migration-files-',
      );
      addTearDown(
        () => deleteTestDirectory(root, prefix: 'space-migration-files-'),
      );
      final zip = File('${root.path}/bad.zip');
      await zip.writeAsBytes(
        ZipEncoder().encode(Archive()..add(ArchiveFile(name, 1, [1]))),
      );
      expect(
        () => unpackDeviceFiles({
          'source': zip.path,
          'destination': '${root.path}/target',
          'hashes': {name: 'hash'},
        }),
        throwsFormatException,
      );
      expect(await Directory('${root.path}/target').exists(), false);
    });
  }

  test('Повтор файла ZIP отклоняется до извлечения', () async {
    final root = await Directory.systemTemp.createTemp(
      'space-migration-files-',
    );
    addTearDown(
      () => deleteTestDirectory(root, prefix: 'space-migration-files-'),
    );
    final zip = File('${root.path}/extra.zip');
    await zip.writeAsBytes(
      ZipEncoder().encode(Archive()..add(ArchiveFile('home.zip', 1, [1]))),
    );
    expect(
      () => unpackDeviceFiles({
        'source': zip.path,
        'destination': '${root.path}/target',
        'hashes': <String, String>{},
      }),
      throwsFormatException,
    );
    expect(await Directory('${root.path}/target').exists(), false);
  });
}
