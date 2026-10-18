import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_installation.dart';
import 'package:space_client/src/home_storage.dart';
import 'package:space_client/src/home_update_journal.dart';

import 'home_installation_test.dart' show installed, release;
import 'support/temp_directory.dart';

String backupId(int i) => 'update-${i.toRadixString(16).padLeft(32, '0')}';

Future<Directory> backup(Directory root, int i) async {
  final folder = await Directory('${root.path}/backups/${backupId(i)}')
      .create(recursive: true);
  final entries = {
    'data/postgres/PG_VERSION': '17',
    'data/database-password': 'fixture',
  };
  for (final entry in entries.entries) {
    final file = File('${folder.path}/${entry.key}');
    await file.parent.create(recursive: true);
    await file.writeAsString(entry.value);
  }
  final manifest = File('${folder.path}/backup.json');
  await manifest.writeAsString(
    jsonEncode({
      'format': 1,
      'os': 'windows',
      'arch': 'amd64',
      'postgresMajor': 17,
      'directories': ['data', 'data/postgres'],
      'files': {
        for (final entry in entries.entries)
          entry.key: sha256.convert(utf8.encode(entry.value)).toString(),
      },
    }),
  );
  await manifest.setLastModified(DateTime(2025, 1, i));
  return folder;
}

void main() {
  late Directory root;
  late HomeInstallation installation;
  late HomeDiskManager manager;
  final storage = HomeStorage(available: (_) async => 1234567890);
  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-disk-test-');
    installation = HomeInstallation(root);
    for (final version in ['v0.1.0', 'v0.2.0', 'v0.3.0']) {
      await installed(installation, release(version));
    }
    await installation.selectInitial(release('v0.2.0'));
    await installation.activate(release('v0.2.0'), release('v0.3.0'));
    await HomeUpdateJournal(root).file.writeAsString(
      jsonEncode(
        HomeUpdateRecord(
          backupId(1),
          release('v0.2.0'),
          release('v0.3.0'),
          HomeUpdateStep.completeUpdated,
        ).toJson(),
      ),
    );
    for (var i = 1; i <= 5; i++) {
      await backup(root, i);
    }
    for (final name in ['data', 'recoveries', 'backups/manual']) {
      await Directory('${root.path}/$name').create(recursive: true);
      await File('${root.path}/$name/keep').writeAsString('keep');
    }
    manager = HomeDiskManager(
      root,
      storage: storage,
      clock: () => DateTime(2026, 10, 18),
    );
  });
  tearDown(() => deleteTestDirectory(root, prefix: 'space-disk-test-'));

  test('Размеры и предпросмотр не изменяют файлы; текущая копия и три новые защищены', () async {
    final report = await manager.scan();
    expect(report.dataBytes, 4);
    expect(report.recoveryBytes, 4);
    expect(report.availableBytes, 1234567890);
    expect(report.backupBytes, greaterThan(4));
    expect(
      report.candidates.map((e) => e.id),
      unorderedEquals([
        'runtimes/v0.1.0-windows-x64',
        'backups/${backupId(2)}',
      ]),
    );
    expect(
      await Directory('${root.path}/backups/${backupId(2)}').exists(),
      true,
    );
    await manager.clean(report, report.candidates.map((e) => e.id).toSet());
    expect(await installation.runtime(release('v0.1.0')).exists(), false);
    for (final version in ['v0.2.0', 'v0.3.0']) {
      expect(await installation.runtime(release(version)).exists(), true);
    }
    for (final i in [1, 3, 4, 5]) {
      expect(
        await Directory('${root.path}/backups/${backupId(i)}').exists(),
        true,
      );
    }
    for (final name in ['data', 'recoveries', 'backups/manual']) {
      expect(await File('${root.path}/$name/keep').readAsString(), 'keep');
    }
  });

  test('Изменение файлов после предпросмотра отменяет удаление всего выбранного списка', () async {
    final report = await manager.scan();
    await File('${root.path}/backups/${backupId(2)}/data/database-password')
        .writeAsString('changed');
    await expectLater(
      manager.clean(report, report.candidates.map((e) => e.id).toSet()),
      throwsA(anything),
    );
    expect(await installation.runtime(release('v0.1.0')).exists(), true);
    expect(
      await Directory('${root.path}/backups/${backupId(2)}').exists(),
      true,
    );
  });

  test('Незавершённое восстановление блокирует старое подтверждение', () async {
    final report = await manager.scan();
    await HomeUpdateJournal(root).file.writeAsString(
      jsonEncode(
        HomeUpdateRecord(
          backupId(1),
          release('v0.2.0'),
          release('v0.3.0'),
          HomeUpdateStep.restoring,
        ).toJson(),
      ),
    );
    expect((await manager.scan()).candidates, isEmpty);
    await expectLater(
      manager.clean(report, {report.candidates.first.id}),
      throwsFormatException,
    );
  });

  test('Изменение выбранного runtime отменяет старый список очистки', () async {
    final report = await manager.scan();
    final selection =
        jsonDecode(await installation.selection.readAsString()) as Map;
    selection['format'] = 2;
    await installation.selection.writeAsString(jsonEncode(selection));
    await expectLater(
      manager.clean(report, {report.candidates.first.id}),
      throwsFormatException,
    );
    expect(await installation.runtime(release('v0.1.0')).exists(), true);
  });

  test(
    'Низкое свободное место не мешает освобождать устаревшие runtime',
    () async {
      final fullDisk = HomeDiskManager(
        root,
        storage: HomeStorage(available: (_) async => 0),
        clock: () => DateTime(2026, 10, 18),
      );
      final report = await fullDisk.scan();
      expect(report.availableBytes, 0);
      await fullDisk.clean(report, {'runtimes/v0.1.0-windows-x64'});
      expect(await installation.runtime(release('v0.1.0')).exists(), false);
      expect(await File('${root.path}/data/keep').readAsString(), 'keep');
    },
  );

  test(
    'Контроллер запрещает очистку при работающем сервере и другой операции',
    () async {
      final report = await manager.scan();
      final home = HomeController(
        directory: () async => root,
        storage: storage,
      );
      addTearDown(home.dispose);
      home.running = true;
      expect(await home.cleanDisk(report, {report.candidates.first.id}), false);
      home.running = false;
      home.busy = true;
      expect(await home.cleanDisk(report, {report.candidates.first.id}), false);
      home.busy = false;
      expect(await installation.runtime(release('v0.1.0')).exists(), true);
    },
  );

  test('Новая копия и повреждённая копия не предлагаются к удалению', () async {
    await File('${root.path}/backups/${backupId(2)}/backup.json')
        .setLastModified(DateTime(2026, 10, 17));
    await File('${root.path}/backups/${backupId(4)}/data/postgres/PG_VERSION')
        .writeAsString('bad');
    final report = await manager.scan();
    expect(report.candidates.where((e) => e.category == 'backups'), isEmpty);
  });

  test('Неподтверждённый путь и ссылка никогда не удаляются', () async {
    final report = await manager.scan();
    await expectLater(manager.clean(report, {'../data'}), throwsA(anything));
    final link = Link('${root.path}/runtimes/link');
    try {
      await link.create('${root.path}/data');
    } on FileSystemException {
      markTestSkipped('Нет права создавать ссылки');
      return;
    }
    try {
      await expectLater(manager.scan(), throwsA(anything));
    } finally {
      await link.delete();
    }
    expect(await File('${root.path}/data/keep').readAsString(), 'keep');
  });

  test('Windows junction не открывает доступ к данным при очистке', () async {
    final junction = '${root.path}/runtimes/junction';
    final result = await Process.run(
      'powershell.exe',
      [
        '-NoProfile',
        '-NonInteractive',
        '-Command',
        r'New-Item -ItemType Junction -Path $env:SPACE_DISK_LINK -Target $env:SPACE_DISK_TARGET | Out-Null',
      ],
      environment: {
        'SPACE_DISK_LINK': junction,
        'SPACE_DISK_TARGET': '${root.path}/data',
      },
    );
    expect(result.exitCode, 0, reason: '${result.stderr}');
    try {
      await expectLater(manager.scan(), throwsA(anything));
    } finally {
      await Link(junction).delete();
    }
    expect(await File('${root.path}/data/keep').readAsString(), 'keep');
  }, skip: !Platform.isWindows);
}
