import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_installation.dart';
import 'package:space_client/src/home_transfer.dart';
import 'package:space_client/src/home_archive_inspection.dart';
import 'package:space_client/src/home_storage.dart';

import 'home_installation_test.dart' show installed, release;

import 'support/temp_directory.dart';

void main() {
  late Directory root, runtime;
  late File archive;
  late HomeTransfer transfer;
  late List<String> calls;
  var failCheck = false;
  var inspectionSupported = true;
  var changeDuringImport = false;
  var changeDuringInspection = false;
  var invalidReport = false;
  var freeBytes = 1 << 40;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-transfer-test-');
    final version = release('v0.2.4');
    await installed(HomeInstallation(root), version);
    runtime = HomeInstallation(root).runtime(version);
    archive = await File('${root.path}/archive.zip').writeAsString('fixture');
    calls = [];
    failCheck = false;
    inspectionSupported = true;
    changeDuringImport = false;
    changeDuringInspection = false;
    invalidReport = false;
    freeBytes = 1 << 40;
    transfer = HomeTransfer(
      root,
      runtime,
      version,
      storage: HomeStorage(available: (_) async => freeBytes),
      tool: (runtime, args) async {
        calls.add(args.first);
        if (args.first == '-runtime-info') {
          return {
            'portableTransferVersion': 1,
            if (inspectionSupported) 'portableInspectionVersion': 1,
          };
        }
        if (args.first == '-home-verify-export') {
          if (changeDuringInspection) await archive.writeAsString('changed');
          if (invalidReport) return {'format': 1};
          return {
            'format': 1,
            'schemaVersion': 22,
            'serverId': 'space-test',
            'files': 5,
            'unpackedBytes': 1024,
          };
        }
        if (args.first == '-home-check' && failCheck) {
          throw StateError('Сбой проверки');
        }
        if (args.first == '-home-import') {
          if (changeDuringImport) await archive.writeAsString('changed');
          final imported = Directory(args[args.indexOf('-home-import-to') + 1]);
          await Directory('${imported.path}/data').create(recursive: true);
          await File('${imported.path}/config.json')
              .writeAsString(jsonEncode({'ip': '203.0.113.11'}));
          await File('${imported.path}/import-source.sha256').writeAsString(
            sha256.convert(await archive.readAsBytes()).toString(),
          );
        }
        return {};
      },
    );
  });
  tearDown(
    () async => deleteTestDirectory(root, prefix: 'space-transfer-test-'),
  );

  test(
    'Нехватка места отменяет импорт до запуска PostgreSQL и публикации',
    () async {
      final report = await transfer.inspect(archive.path);
      freeBytes = 0;
      await expectLater(
        transfer.importFrom(archive.path, inspection: report),
        throwsA(isA<HomeSpaceFailure>()),
      );
      expect(calls, isNot(contains('-home-import')));
      expect(await File('${root.path}/home-location.json').exists(), false);
    },
  );

  test('Экспорт не запускается без места на диске назначения', () async {
    final destination = await Directory('${root.path}/external').create();
    final checked = <String>[];
    final exporter = HomeTransfer(
      root,
      runtime,
      transfer.release,
      tool: transfer.tool,
      storage: HomeStorage(
        available: (folder) async {
          checked.add(folder.path);
          return folder.path == root.path ? 1 << 40 : 0;
        },
      ),
    );
    await expectLater(
      exporter.exportTo('${destination.path}/copy.zip'),
      throwsA(isA<HomeSpaceFailure>()),
    );
    expect(checked, [root.path, destination.absolute.path]);
    expect(calls, isNot(contains('-home-export')));
    expect(await File('${destination.path}/copy.zip').exists(), false);
  });

  test(
    'Импорт проверяет данные до переключения каталога и переносит runtime',
    () async {
      final imported = await transfer.importFrom(
        archive.path,
        inspection: await transfer.inspect(archive.path),
        publicIP: '203.0.113.11',
      );
      expect((await resolveHomeLocation(root)).path, imported.path);
      expect(
        (await HomeInstallation(imported).active(release('v0.2.4')))!.version,
        'v0.2.4',
      );
      expect(calls, [
        '-runtime-info',
        '-home-verify-export',
        '-runtime-info',
        '-home-import',
        '-home-check',
      ]);
    },
  );
  test(
    'После сбоя проверка возобновляется без повторного импорта базы',
    () async {
      failCheck = true;
      await expectLater(
        transfer.importFrom(
          archive.path,
          inspection: await transfer.inspect(archive.path),
        ),
        throwsStateError,
      );
      expect((await resolveHomeLocation(root)).path, root.path);
      failCheck = false;
      await transfer.importFrom(
        archive.path,
        inspection: await transfer.inspect(archive.path),
      );
      expect(calls.where((call) => call == '-home-import').length, 1);
    },
  );
  test('Другой архив не активирует подготовленный импорт', () async {
    failCheck = true;
    await expectLater(
      transfer.importFrom(
        archive.path,
        inspection: await transfer.inspect(archive.path),
      ),
      throwsStateError,
    );
    await archive.writeAsString('другой архив');
    failCheck = false;
    await expectLater(
      transfer.importFrom(
        archive.path,
        inspection: await transfer.inspect(archive.path),
      ),
      throwsFormatException,
    );
    expect((await resolveHomeLocation(root)).path, root.path);
  });
  test('Действующее пространство не заменяется', () async {
    await Directory('${root.path}/data').create();
    await expectLater(
      transfer.importFrom(
        archive.path,
        inspection: await transfer.inspect(archive.path),
      ),
      throwsFormatException,
    );
    expect(calls, ['-runtime-info', '-home-verify-export']);
  });
  test('Проверка не восстанавливает и не активирует пространство', () async {
    final report = await transfer.inspect(archive.path);
    expect(report.serverId, 'space-test');
    expect(report.schemaVersion, 22);
    expect(await archive.readAsString(), 'fixture');
    expect(await Directory('${root.path}/transferred').exists(), isFalse);
    expect((await resolveHomeLocation(root)).path, root.path);
    expect(calls, ['-runtime-info', '-home-verify-export']);
  });
  test('Старый runtime отклоняется до восстановления', () async {
    inspectionSupported = false;
    await expectLater(
      transfer.inspect(archive.path),
      throwsA(isA<HomeArchiveInspectionUnsupported>()),
    );
    expect(calls, ['-runtime-info']);
  });
  test('Изменение после подтверждения не запускает импорт', () async {
    final report = await transfer.inspect(archive.path);
    await archive.writeAsString('changed');
    await expectLater(
      transfer.importFrom(archive.path, inspection: report),
      throwsFormatException,
    );
    expect(calls, isNot(contains('-home-import')));
  });
  test(
    'Изменение во время восстановления не активирует пространство',
    () async {
      final report = await transfer.inspect(archive.path);
      changeDuringImport = true;
      await expectLater(
        transfer.importFrom(archive.path, inspection: report),
        throwsFormatException,
      );
      expect((await resolveHomeLocation(root)).path, root.path);
    },
  );
  test('Повреждённый отчёт не разрешает восстановление', () async {
    invalidReport = true;
    await expectLater(transfer.inspect(archive.path), throwsFormatException);
    expect(calls, isNot(contains('-home-import')));
  });
  test('Изменение во время проверки отклоняется', () async {
    changeDuringInspection = true;
    await expectLater(transfer.inspect(archive.path), throwsFormatException);
    expect(calls, isNot(contains('-home-import')));
  });
  test('Без проверки импорт запрещён', () async {
    await expectLater(transfer.importFrom(archive.path), throwsFormatException);
    expect(calls, isEmpty);
  });
  test('Указатель не разрешает выход за пределы каталога', () async {
    await File('${root.path}/home-location.json')
        .writeAsString('{"format":1,"path":"../other"}');
    await expectLater(resolveHomeLocation(root), throwsFormatException);
  });
}
