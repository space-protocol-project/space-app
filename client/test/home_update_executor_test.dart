import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_installation.dart';
import 'package:space_client/src/home_update_executor.dart';
import 'package:space_client/src/home_update_journal.dart';
import 'package:space_client/src/home_storage.dart';

import 'home_installation_test.dart' show installed, release;

Future<void> copyFixture(Directory source, Directory destination) async {
  await destination.create(recursive: true);
  await for (final entry in source.list()) {
    final name = entry.uri.pathSegments.where((s) => s.isNotEmpty).last;
    if (entry is Directory) {
      await copyFixture(entry, Directory('${destination.path}/$name'));
    } else if (entry is File) {
      await entry.copy('${destination.path}/$name');
    }
  }
}

void main() {
  late Directory root;
  late HomeInstallation installation;
  late HomeUpdateExecutor executor;
  late List<String> calls;
  var migrationFails = false, restorationFails = false, wrongIdentity = false;
  Future<Map<String, dynamic>> tool(
    Directory runtime,
    List<String> arguments,
  ) async {
    calls.add(arguments.first);
    String value(String flag) => arguments[arguments.indexOf(flag) + 1];
    if (arguments.first == '-runtime-info') {
      return {
        'format': 1,
        'os': 'windows',
        'arch': 'amd64',
        'postgresMajor': 17,
        'protocolVersion': '0.1-experimental',
        'schemaVersion': 11,
      };
    }
    if (arguments.first == '-home-backup') {
      await copyFixture(
        Directory(value('-home-data')),
        Directory('${value('-home-backup')}/data'),
      );
      return {};
    }
    if (arguments.first == '-home-restore') {
      if (restorationFails) throw StateError('Отказ восстановления');
      await copyFixture(
        Directory('${value('-home-restore')}/data'),
        Directory('${value('-home-restore-to')}/data'),
      );
      return {};
    }
    if (arguments.first == '-home-stopped') return {};
    final data = value('-home-data');
    if (arguments.first == '-home-migrate') {
      await File('$data/schema').writeAsString('11');
      if (migrationFails) throw StateError('Сбой после изменения базы');
    }
    return {
      'schemaVersion': int.parse(await File('$data/schema').readAsString()),
      'targetSchemaVersion': 11,
      'postgresMajor': 17,
      'serverId': 'srv_${'1' * 32}',
      'tlsFingerprint':
          (wrongIdentity && arguments.first == '-home-migrate' ? 'b' : 'a') *
          64,
    };
  }

  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-update-executor-');
    installation = HomeInstallation(root);
    await installed(installation, release('v0.1.0'));
    await installed(installation, release('v0.2.0'));
    await installation.selectInitial(release('v0.1.0'));
    await Directory('${root.path}/data').create();
    await File('${root.path}/data/schema').writeAsString('9');
    calls = [];
    migrationFails = false;
    restorationFails = false;
    wrongIdentity = false;
    executor = HomeUpdateExecutor(
      root,
      tool: tool,
      storage: HomeStorage(available: (_) async => 1024 * 1024 * 1024),
    );
  });
  tearDown(() => root.delete(recursive: true));

  test('Продолжение прерванной подготовки повторяет обновление, не создавая цикл ошибок', () async {
    await HomeUpdateJournal(root).begin(release('v0.1.0'), release('v0.2.0'));
    await executor.recover();
    expect(
      (await HomeUpdateJournal(root).read())!.step,
      HomeUpdateStep.completeUpdated,
    );
    expect((await installation.active(release('v0.2.0')))!.version, 'v0.2.0');
  });

  test('Успех: копия до миграций, прежний runtime сохранён, новая версия закреплена', () async {
    await executor.update(release('v0.1.0'), release('v0.2.0'));
    expect(
      calls.indexOf('-home-backup'),
      lessThan(calls.indexOf('-home-migrate')),
    );
    expect((await installation.active(release('v0.2.0')))!.version, 'v0.2.0');
    final selection =
        jsonDecode(await installation.selection.readAsString()) as Map;
    expect((selection['previous'] as Map)['version'], 'v0.1.0');
    expect(
      (await HomeUpdateJournal(root).read())!.step,
      HomeUpdateStep.completeUpdated,
    );
    expect(await File('${root.path}/data/schema').readAsString(), '11');
    expect(await installation.runtime(release('v0.1.0')).exists(), true);
  });
  test('Сбой после миграций восстанавливает копию и сохраняет изменённую базу отдельно', () async {
    migrationFails = true;
    await expectLater(
      executor.update(release('v0.1.0'), release('v0.2.0')),
      throwsFormatException,
    );
    final record = (await HomeUpdateJournal(root).read())!;
    expect(record.step, HomeUpdateStep.completeRestored);
    expect(await File('${root.path}/data/schema').readAsString(), '9');
    expect(
      await File('${root.path}/failed-data/${record.id}/schema').readAsString(),
      '11',
    );
    expect((await installation.active(release('v0.2.0')))!.version, 'v0.1.0');
    expect(calls, contains('-home-stopped'));
  });
  test(
    'Повторное открытие после отказа восстановления завершает прежнюю операцию',
    () async {
      migrationFails = true;
      restorationFails = true;
      await expectLater(
        executor.update(release('v0.1.0'), release('v0.2.0')),
        throwsStateError,
      );
      expect(
        (await HomeUpdateJournal(root).read())!.step,
        HomeUpdateStep.restoring,
      );
      restorationFails = false;
      await HomeUpdateExecutor(
        root,
        tool: tool,
        storage: HomeStorage(available: (_) async => 1024 * 1024 * 1024),
      ).recover();
      expect(
        (await HomeUpdateJournal(root).read())!.step,
        HomeUpdateStep.completeRestored,
      );
      expect(await File('${root.path}/data/schema').readAsString(), '9');
    },
  );
  test(
    'Изменение сертификата блокирует активацию и приводит к восстановлению',
    () async {
      wrongIdentity = true;
      await expectLater(
        executor.update(release('v0.1.0'), release('v0.2.0')),
        throwsFormatException,
      );
      expect((await installation.active(release('v0.2.0')))!.version, 'v0.1.0');
      expect(
        (await HomeUpdateJournal(root).read())!.step,
        HomeUpdateStep.completeRestored,
      );
    },
  );
}
