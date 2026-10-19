import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/migration_archive.dart';

import 'support/temp_directory.dart';

void main() {
  test(
    'Полный архив шифрует сервер и ключи; подмена и обрезка отвергаются',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'space-migration-test-',
      );
      addTearDown(
        () => deleteTestDirectory(directory, prefix: 'space-migration-test-'),
      );
      final bytes = List.generate(
        MigrationArchive.chunkBytes + 41,
        (i) => i % 251,
      );
      final server = await File('${directory.path}/source.zip')
          .writeAsBytes(bytes);
      final archive = File('${directory.path}/full.spacebackup');
      final device = {
        'kind': 'test',
        'secret': 'private-device-key',
        'mls': {'snapshot': 'private-mls-key'},
      };
      const password = 'Длинный пароль переноса';
      await MigrationArchive.write(
        server: server,
        device: device,
        password: password,
        destination: archive,
      );
      await expectLater(
        MigrationArchive.read(source: archive, password: password),
        throwsFormatException,
      );
      expect(
        await MigrationArchive.read(
          source: archive,
          password: password,
          allowUncommitted: true,
        ),
        device,
      );
      await MigrationArchive.commit(archive);
      expect(await MigrationArchive.recognizes(archive.path), true);
      final encoded = await archive.readAsBytes();
      expect(
        utf8.decode(encoded, allowMalformed: true),
        isNot(contains('private-device-key')),
      );
      final restored = File('${directory.path}/restored.zip');
      expect(
        await MigrationArchive.read(
          source: archive,
          password: password,
          server: restored,
        ),
        device,
      );
      expect(await restored.readAsBytes(), bytes);
      await expectLater(
        MigrationArchive.read(
          source: archive,
          password: 'wrong',
          server: File('${directory.path}/wrong.zip'),
        ),
        throwsA(anything),
      );
      expect(await File('${directory.path}/wrong.zip').exists(), false);
      final changed = List<int>.from(encoded)..[encoded.length - 100] ^= 1;
      final damaged = await File('${directory.path}/damaged')
          .writeAsBytes(changed);
      await expectLater(
        MigrationArchive.read(
          source: damaged,
          password: password,
          server: File('${directory.path}/bad.zip'),
        ),
        throwsA(anything),
      );
      await damaged.writeAsBytes(encoded.sublist(0, encoded.length - 2));
      await expectLater(
        MigrationArchive.read(
          source: damaged,
          password: password,
          server: File('${directory.path}/short.zip'),
        ),
        throwsA(anything),
      );
      await damaged.writeAsBytes(encoded.sublist(0, encoded.length - 2));
      expect(
        await MigrationArchive.read(
          source: damaged,
          password: password,
          allowUncommitted: true,
        ),
        device,
      );
      await MigrationArchive.commit(damaged);
      await MigrationArchive.commit(damaged);
      expect(await damaged.readAsBytes(), encoded);
      await damaged.writeAsBytes([...encoded, 0]);
      await expectLater(
        MigrationArchive.read(
          source: damaged,
          password: password,
          server: File('${directory.path}/trailing.zip'),
        ),
        throwsFormatException,
      );
      await expectLater(
        MigrationArchive.write(
          server: server,
          device: device,
          password: password,
          destination: archive,
        ),
        throwsA(isA<FileSystemException>()),
      );
      expect(await archive.readAsBytes(), encoded);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
