import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_installation.dart';
import 'package:space_client/src/home_transfer.dart';

import 'home_installation_test.dart' show installed, release;

void main() {
  late Directory root, runtime;
  late File archive;
  late HomeTransfer transfer;
  late List<String> calls;
  var failCheck = false;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-transfer-test-');
    final version = release('v0.2.4');
    await installed(HomeInstallation(root), version);
    runtime = HomeInstallation(root).runtime(version);
    archive = await File('${root.path}/archive.zip').writeAsString('fixture');
    calls = [];
    failCheck = false;
    transfer = HomeTransfer(
      root,
      runtime,
      version,
      tool: (runtime, args) async {
        calls.add(args.first);
        if (args.first == '-runtime-info') {
          return {'portableTransferVersion': 1};
        }
        if (args.first == '-home-check' && failCheck) {
          throw StateError('Сбой проверки');
        }
        if (args.first == '-home-import') {
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
  tearDown(() async => root.delete(recursive: true));

  test(
    'Импорт проверяет данные до переключения каталога и переносит runtime',
    () async {
      final imported = await transfer.importFrom(
        archive.path,
        publicIP: '203.0.113.11',
      );
      expect((await resolveHomeLocation(root)).path, imported.path);
      expect(
        (await HomeInstallation(imported).active(release('v0.2.4')))!.version,
        'v0.2.4',
      );
      expect(calls, ['-runtime-info', '-home-import', '-home-check']);
    },
  );
  test(
    'После сбоя проверка возобновляется без повторного импорта базы',
    () async {
      failCheck = true;
      await expectLater(transfer.importFrom(archive.path), throwsStateError);
      expect((await resolveHomeLocation(root)).path, root.path);
      failCheck = false;
      await transfer.importFrom(archive.path);
      expect(calls.where((call) => call == '-home-import').length, 1);
    },
  );
  test('Другой архив не активирует подготовленный импорт', () async {
    failCheck = true;
    await expectLater(transfer.importFrom(archive.path), throwsStateError);
    await archive.writeAsString('другой архив');
    failCheck = false;
    await expectLater(transfer.importFrom(archive.path), throwsFormatException);
    expect((await resolveHomeLocation(root)).path, root.path);
  });
  test('Действующее пространство не заменяется', () async {
    await Directory('${root.path}/data').create();
    await expectLater(transfer.importFrom(archive.path), throwsFormatException);
    expect(calls, isEmpty);
  });
  test('Указатель не разрешает выход за пределы каталога', () async {
    await File('${root.path}/home-location.json')
        .writeAsString('{"format":1,"path":"../other"}');
    await expectLater(resolveHomeLocation(root), throwsFormatException);
  });
}
