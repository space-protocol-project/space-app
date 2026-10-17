import 'dart:io';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart' as crypto;

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_storage.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_installation.dart';
import 'package:space_client/src/home_runtime.dart';

import 'home_installation_test.dart' show installed, release;

import 'support/temp_directory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory root;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('space storage проверка ');
    await Directory('${root.path}/data').create();
    await File('${root.path}/data/probe').writeAsBytes(List.filled(100, 1));
  });
  tearDown(() => deleteTestDirectory(root, prefix: 'space storage проверка '));
  test('Оценка включает копии данных, архив/runtime и запас; измеряется указанный каталог', () async {
    final storage = HomeStorage(
      available: (directory) async {
        expect(directory.path, root.path);
        return HomeStorage.reserve + 500;
      },
    );
    final report = await storage.check(root, additionalBytes: 200);
    expect(report.requiredBytes, HomeStorage.reserve + 500);
    expect(report.availableBytes, report.requiredBytes);
  });
  test('Нехватка места возвращает размеры и не изменяет файлы', () async {
    final storage = HomeStorage(available: (_) async => 0);
    try {
      await storage.check(root);
      fail('Проверка разрешила операцию');
    } on HomeSpaceFailure catch (error) {
      expect(error.report.requiredBytes, HomeStorage.reserve + 300);
      expect(error.report.availableBytes, 0);
    }
    expect(await File('${root.path}/data/probe').length(), 100);
  });
  test('Нехватка места до подготовки не запускает скачивание и не выключает сервер', () async {
    final store = HomeInstallation(root);
    await installed(store, release('v0.1.0'));
    await store.selectInitial(release('v0.1.0'));
    var downloads = 0;
    final home = HomeController(
      directory: () async => root,
      release: () async => release('v0.2.0'),
      storage: HomeStorage(available: (_) async => 0),
      download: (_, _, _) async {
        downloads++;
      },
    );
    home.running = true;
    addTearDown(home.dispose);
    expect(await home.prepareUpdate(), false);
    expect(downloads, 0);
    expect(home.running, true);
    expect(home.spaceReport, isNotNull);
    expect((await store.active(release('v0.2.0')))!.version, 'v0.1.0');
  });
  test('Нативный способ определяет свободное место для пути с пробелами и кириллицей', () async {
    expect(await availableHomeBytes(root), greaterThanOrEqualTo(0));
  });
  test('Метаданные старого выпуска имеют безопасный предел; размер и текст нового ограничены', () {
    final old = release('v0.1.0');
    expect(old.unpackedBytes, 2 * 1024 * 1024 * 1024);
    final json = old.toJson();
    final described = HomeRelease.fromJson({
      ...json,
      'unpackedBytes': 100,
      'releaseNotes': 'Из Changelog',
    });
    expect(described.releaseNotes, 'Из Changelog');
    expect(described.unpackedBytes, 100);
    expect(
      () => HomeRelease.fromJson({...json, 'releaseNotes': 'я' * 5000}),
      throwsFormatException,
    );
    expect(
      () => HomeRelease.fromJson({...json, 'unpackedBytes': 0}),
      throwsFormatException,
    );
    expect(utf8.encode(described.releaseNotes).length, lessThan(8192));
  });
  test('Архив не распаковывается сверх объявленного предела', () async {
    final bytes = ZipEncoder().encode(
      Archive()..addFile(ArchiveFile('space-server.exe', 4, [1, 2, 3, 4])),
    );
    final archive = await File('${root.path}/runtime.zip').writeAsBytes(bytes);
    final destination = await Directory('${root.path}/unpacked').create();
    await expectLater(
      extractHomeRelease(
        archive,
        destination,
        crypto.sha256.convert(bytes).toString(),
        maximumBytes: 1,
      ),
      throwsFormatException,
    );
    expect(await destination.list().toList(), isEmpty);
  });
}
