import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:space_client/src/home_installation.dart';
import 'package:space_client/src/home_runtime_cleanup.dart';
import 'package:space_client/src/home_update_journal.dart';

import 'home_installation_test.dart' show installed, release;

void main() {
  late Directory root;
  late HomeInstallation installation;
  late HomeRuntimeCleanup cleanup;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-runtime-cleanup-');
    installation = HomeInstallation(root);
    cleanup = HomeRuntimeCleanup(root);
    for (final version in ['v0.1.0', 'v0.2.0', 'v0.3.0']) {
      await installed(installation, release(version));
    }
    await installation.selectInitial(release('v0.2.0'));
    await installation.activate(release('v0.2.0'), release('v0.3.0'));
    await HomeUpdateJournal(root).file.writeAsString(
      jsonEncode(
        HomeUpdateRecord(
          'update-${'a' * 32}',
          release('v0.2.0'),
          release('v0.3.0'),
          HomeUpdateStep.completeUpdated,
        ).toJson(),
      ),
    );
  });
  tearDown(() async {
    final resolved = await root.resolveSymbolicLinks();
    expect(
      path.dirname(resolved),
      await Directory.systemTemp.resolveSymbolicLinks(),
    );
    expect(path.basename(resolved), startsWith('space-runtime-cleanup-'));
    await root.delete(recursive: true);
  });

  test(
    'Остаются текущий и предыдущий runtime, данные и резервные копии',
    () async {
      await installed(installation, release('v0.0.1'), legacy: true);
      for (final name in [
        'data',
        'backups',
        'recoveries',
        'runtimes/unknown',
        'runtimes/download-partial',
      ]) {
        await Directory('${root.path}/$name').create(recursive: true);
        await File('${root.path}/$name/keep').writeAsString('keep');
      }
      expect(
        await cleanup.run(),
        unorderedEquals(['v0.1.0-windows-x64', 'v0.0.1-windows-x64']),
      );
      expect(await installation.runtime(release('v0.2.0')).exists(), true);
      expect(await installation.runtime(release('v0.3.0')).exists(), true);
      expect(await cleanup.run(), isEmpty);
      for (final name in [
        'data',
        'backups',
        'recoveries',
        'runtimes/unknown',
        'runtimes/download-partial',
      ]) {
        expect(await File('${root.path}/$name/keep').readAsString(), 'keep');
      }
    },
  );

  for (final step in HomeUpdateStep.values.where(
    (s) => s != HomeUpdateStep.completeUpdated,
  )) {
    test('Очистка запрещена на шаге ${step.name}', () async {
      await HomeUpdateJournal(root).file.writeAsString(
        jsonEncode(
          HomeUpdateRecord(
            'update-${'a' * 32}',
            release('v0.2.0'),
            release('v0.3.0'),
            step,
          ).toJson(),
        ),
      );
      expect(await cleanup.run(), isEmpty);
      expect(await installation.runtime(release('v0.1.0')).exists(), true);
    });
  }

  test('Повреждённая сохранённая версия блокирует удаление', () async {
    await File('${installation.runtime(release('v0.2.0')).path}/installed.json')
        .writeAsString('{}');
    expect(await cleanup.run(), isEmpty);
    expect(await installation.runtime(release('v0.1.0')).exists(), true);
  });

  test('Неизвестные папки и каталог другой платформы не удаляются', () async {
    await installed(installation, release('v0.0.1', 'linux-x64'));
    await File('${installation.runtime(release('v0.1.0')).path}/installed.json')
        .writeAsString('{');
    expect(await cleanup.run(), isEmpty);
    expect(await installation.runtime(release('v0.1.0')).exists(), true);
    expect(
      await installation.runtime(release('v0.0.1', 'linux-x64')).exists(),
      true,
    );
  });

  test('Runtime со ссылкой на данные не удаляется', () async {
    final data = await Directory('${root.path}/data').create();
    await File('${data.path}/keep').writeAsString('keep');
    try {
      await Link('${installation.runtime(release('v0.1.0')).path}/linked-data')
          .create(data.path);
    } on FileSystemException {
      markTestSkipped('Система не разрешает создавать символические ссылки');
      return;
    }
    expect(await cleanup.run(), isEmpty);
    expect(await File('${data.path}/keep').readAsString(), 'keep');
    expect(await installation.runtime(release('v0.1.0')).exists(), true);
  });
}
