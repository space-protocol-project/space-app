import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/chat_history.dart';
import 'package:space_client/src/device_migration.dart';
import 'package:space_client/src/device_migration_secrets.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_migration.dart';
import 'package:space_client/src/home_network.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/native.dart';

import 'home_migration_test.dart' show MigrationHome, RetirementFailureStorage;
import 'mls_native_test.dart' show MemoryMlsStorage;
import 'recovery_spaces_test.dart' show record;
import 'support/temp_directory.dart';

const password = 'Полный перенос устройства';

Future<MlsLocalStore> seedStore(
  DeviceRecord record,
  MemoryMlsStorage storage,
  Directory root,
) async {
  final public = await (await Ed25519().newKeyPairFromSeed(record.deviceSeed))
      .extractPublicKey();
  record.mlsIdentity = {
    'server_id': record.serverId,
    'principal_id': (await record.identity()).principalId,
    'grant_id': record.grantId,
    'public_key': public.bytes,
  };
  final store = MlsLocalStore(
    storage: storage,
    engine: NativeMlsEngine(),
    scope: record.mlsIdentity!,
    deviceSeed: record.deviceSeed,
    lockDirectory: Directory('${root.path}/locks'),
  );
  await store.read();
  await store.change((doc) => doc['history'] = {'saved': record.origin});
  return store;
}

Future<DeviceMigration> service(
  Directory root,
  MemoryMlsStorage storage, {
  HomeController? home,
  Future<void> Function()? stop,
}) async {
  final controller =
      home ??
      HomeController(directory: () async => Directory('${root.path}/home'));
  addTearDown(controller.close);
  return DeviceMigration(
    home: controller,
    devices: HomeMigration(
      vault: KeyIdentityVault(storage),
      storage: storage,
      locks: () async => Directory('${root.path}/locks'),
    ),
    preferences: await SharedPreferences.getInstance(),
    directory: () async => root,
    stop: stop ?? () async {},
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Два пространства, MLS, Эфир, настройки, черновики и файлы переносятся вместе', () async {
    final root = await Directory.systemTemp.createTemp(
      'space-migration-device-',
    );
    addTearDown(
      () => deleteTestDirectory(root, prefix: 'space-migration-device-'),
    );
    final sourceRoot = await Directory('${root.path}/source').create();
    final targetRoot = await Directory('${root.path}/target').create();
    final source = MemoryMlsStorage(), target = MemoryMlsStorage();
    final records = [await record(1), await record(2)];
    final sourceStores = <MlsLocalStore>[];
    for (final item in records) {
      item.grantId = 'grant-${item.serverId}';
      sourceStores.add(await seedStore(item, source, sourceRoot));
      await KeyIdentityVault(source).save(item);
    }
    SharedPreferences.setMockInitialValues({
      'space.ui.origins': records.map((item) => item.origin).toList(),
      'space.ui.palette': 'iris',
      'space.ui.dark': false,
      'space.voice.devices': '{"audio":{"pushToTalk":true}}',
      'space.history.data.test': 'encrypted-history',
      'space.update.resumeHome': true,
    });
    final keys = await deviceSecretKeys(records, source);
    for (final key in keys) {
      if (!key.contains('sources')) source.values[key] = 'saved-$key';
    }
    final history = ChatHistory(
      serverId: records.first.serverId,
      principalId: (await records.first.identity()).principalId,
      grantId: records.first.grantId,
    )..title = 'Сохранённая история';
    // Генерация настоящего ключа AES истории вместо тестовой строки.
    for (final key in keys.where(
      (key) => key.startsWith('space.history.key.'),
    )) {
      source.values.remove(key);
    }
    await LocalChatHistory(storage: source)
        .write(records.first.origin, history);
    final queueKey = keys.firstWhere(
      (key) => key.startsWith('space.outbox.files.key.v1.'),
    );
    final scope = queueKey.split('.').last;
    final name = '${'a' * 64}.bin';
    final queued = File('${sourceRoot.path}/outbox-files/$scope/$name');
    await queued.parent.create(recursive: true);
    await queued.writeAsString('encrypted-attachment');
    final home = MigrationHome(
      await Directory('${sourceRoot.path}/home').create(),
      records.first.serverId,
    );
    home.network = HomeNetwork([ServerEndpoint.parse('203.0.113.1', 8443)]);
    home.ip = '203.0.113.1';
    final backup = File('${home.root.path}/backups/point/data.bin');
    await backup.parent.create(recursive: true);
    await backup.writeAsString('Прежняя резервная копия');
    await Directory('${home.root.path}/backups/point/empty').create();
    await File('${home.root.path}/backup-policy.json').writeAsString(
      '{"format":1,"enabled":true,"prune":false,"intervalHours":12,"keepCount":7,"keepDays":30,"maxBytes":0}',
    );
    var stopped = false;
    final exporter = await service(
      sourceRoot,
      source,
      home: home,
      stop: () async => stopped = true,
    );
    final path = '${root.path}/device.spacedevice';
    await exporter.export(path, password);
    expect(stopped, true);
    for (final store in sourceStores) {
      await expectLater(store.read(), throwsStateError);
    }
    await expectLater(
      KeyIdentityVault(source).load(records.last.origin),
      throwsStateError,
    );
    SharedPreferences.setMockInitialValues({});
    final targetHome = MigrationHome(
      await Directory('${targetRoot.path}/home').create(),
      records.first.serverId,
    );
    final importer = await service(targetRoot, target, home: targetHome);
    await expectLater(
      importer.restore(path, 'Неправильный пароль'),
      throwsA(anything),
    );
    expect(target.values, isEmpty);
    expect(targetHome.imports, 0);
    await importer.restore(path, password, publicIP: '203.0.113.1');
    expect(targetHome.imports, 1);
    expect(
      await File('${targetHome.root.path}/backups/point/data.bin')
          .readAsString(),
      'Прежняя резервная копия',
    );
    expect(
      await Directory('${targetHome.root.path}/backups/point/empty').exists(),
      true,
    );
    expect(
      await File('${targetHome.root.path}/backup-policy.json').exists(),
      true,
    );
    expect(
      (await LocalChatHistory(storage: target).read(records.first.origin))!
          .title,
      'Сохранённая история',
    );
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getStringList('space.ui.origins'),
      records.map((item) => item.origin).toList(),
    );
    expect(prefs.getString('space.ui.palette'), 'iris');
    expect(prefs.getBool('space.ui.dark'), false);
    expect(prefs.containsKey('space.update.resumeHome'), false);
    expect(
      await File('${targetRoot.path}/outbox-files/$scope/$name').readAsString(),
      'encrypted-attachment',
    );
    for (final item in records) {
      final restored = (await KeyIdentityVault(target).load(item.origin))!;
      expect(restored.deviceSeed, item.deviceSeed);
      final store = (await importer.devices.deviceStore(restored))!;
      expect((await store.read())['history'], {'saved': item.origin});
      await store.update('key_package', {});
    }
    final state = Map.of(target.values);
    await prefs.setString('space.ui.palette', 'ocean');
    await importer.restore(path, password);
    expect(target.values, state);
    expect(prefs.getString('space.ui.palette'), 'ocean');
    await expectLater(exporter.restore(path, password), throwsStateError);
  }, timeout: const Timeout(Duration(minutes: 4)));

  test(
    'Обрыв остановки нескольких MLS завершается повторным экспортом',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'space-migration-device-',
      );
      addTearDown(
        () => deleteTestDirectory(root, prefix: 'space-migration-device-'),
      );
      final storage = RetirementFailureStorage();
      final records = [await record(3), await record(4)];
      for (final item in records) {
        item.grantId = 'grant-${item.serverId}';
        await seedStore(item, storage, root);
        await KeyIdentityVault(storage).save(item);
      }
      SharedPreferences.setMockInitialValues({
        'space.ui.origins': records.map((item) => item.origin).toList(),
      });
      final migration = await service(root, storage);
      final path = '${root.path}/all.spacedevice';
      await expectLater(migration.export(path, password), throwsStateError);
      expect(await File('$path.pending').exists(), true);
      expect(await File(path).exists(), false);
      storage.failRetirement = false;
      await migration.export(path, password);
      expect(await File(path).exists(), true);
      expect(await File('$path.pending').exists(), false);
      for (final item in records) {
        await expectLater(
          KeyIdentityVault(storage).load(item.origin),
          throwsStateError,
        );
        final store = (await migration.devices.deviceStore(item))!;
        await expectLater(store.read(), throwsStateError);
      }
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
