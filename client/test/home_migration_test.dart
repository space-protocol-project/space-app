import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_migration.dart';
import 'package:space_client/src/home_network.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/migration_archive.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/native.dart';

import 'mls_native_test.dart' show MemoryMlsStorage;
import 'recovery_spaces_test.dart' show record;
import 'support/temp_directory.dart';

class MigrationHome extends HomeController {
  MigrationHome(this.root, this.serverId) : super(directory: () async => root);
  final Directory root;
  final String serverId;
  int imports = 0;
  bool fail = false;
  @override
  Future<bool> exportData(String path) async {
    await File(path).writeAsString('server-private-data');
    return true;
  }

  @override
  Future<HomeArchiveInspection?> inspectArchive(String path) async =>
      HomeArchiveInspection(
        path: File(path).absolute.path,
        digest: await homeArchiveDigest(path),
        serverId: serverId,
        schemaVersion: 1,
        files: 5,
        unpackedBytes: 1024,
      );
  @override
  Future<bool> importData(
    String path, {
    String publicIP = '',
    HomeArchiveInspection? inspection,
  }) async {
    imports++;
    if (fail) return false;
    expect(await File(path).readAsString(), 'server-private-data');
    await Directory('${root.path}/transferred').create();
    await File('${root.path}/transferred/import-source.sha256')
        .writeAsString(inspection!.digest);
    network = HomeNetwork([ServerEndpoint.parse('203.0.113.1', 8443)]);
    ip = '203.0.113.1';
    return true;
  }
}

class RetirementFailureStorage extends MemoryMlsStorage {
  bool failRetirement = true;
  bool failAfterRetirement = false;
  @override
  Future<void> write({required String key, required String value}) async {
    if (failRetirement && key.endsWith('.transferred')) {
      throw StateError('Сбой подтверждения остановки устройства');
    }
    await super.write(key: key, value: value);
    if (failAfterRetirement && value.startsWith('{"v":"transferred"')) {
      throw StateError('Сбой после замены рабочих ключей');
    }
  }
}

void main() {
  for (final afterRetirement in [false, true]) {
    test(
      'Возобновление переноса после остановки MLS; ключи заменены: $afterRetirement',
      () async {
        final root = await Directory.systemTemp.createTemp(
          'space-migration-resume-',
        );
        addTearDown(
          () => deleteTestDirectory(root, prefix: 'space-migration-resume-'),
        );
        final device = await record(1);
        device.grantId = 'grant-1';
        final storage = RetirementFailureStorage();
        storage.failRetirement = !afterRetirement;
        storage.failAfterRetirement = afterRetirement;
        final vault = KeyIdentityVault(storage);
        final store = await _sourceStore(
          device,
          storage,
          (await device.identity()).principalId,
          root,
        );
        await store.read();
        await vault.save(device);
        final home = MigrationHome(root, device.serverId);
        home.network = HomeNetwork([ServerEndpoint.parse('203.0.113.1', 8443)]);
        addTearDown(home.close);
        final migration = HomeMigration(
          vault: vault,
          storage: storage,
          locks: () async => Directory('${root.path}/source-locks'),
        );
        final path = '${root.path}/full.spacebackup';
        const password = 'Длинный пароль переноса';
        await expectLater(
          migration.export(
            home: home,
            path: path,
            password: password,
            stop: () async {},
          ),
          throwsStateError,
        );
        expect(await File(path).exists(), false);
        final pending = File('$path.pending');
        expect(await pending.exists(), true);
        await expectLater(
          MigrationArchive.read(source: pending, password: password),
          throwsFormatException,
        );
        await expectLater(store.read(), throwsStateError);
        storage.failRetirement = false;
        storage.failAfterRetirement = false;
        await migration.export(
          home: home,
          path: path,
          password: password,
          stop: () async {},
        );
        expect(await File(path).exists(), true);
        expect(await pending.exists(), false);
        expect(
          (await MigrationArchive.read(
            source: File(path),
            password: password,
          ))['device'],
          device.toJson(),
        );
        await expectLater(vault.load(device.origin), throwsStateError);
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );
  }
  test(
    'Полный перенос: остановка источника, MLS и повтор без отката',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'space-migration-flow-',
      );
      addTearDown(
        () => deleteTestDirectory(root, prefix: 'space-migration-flow-'),
      );
      var device = await record(1);
      final storage = MemoryMlsStorage(), targetStorage = MemoryMlsStorage();
      final vault = KeyIdentityVault(storage),
          targetVault = KeyIdentityVault(targetStorage);
      final identity = await device.identity();
      device.grantId = 'grant-1';
      final seedStore = await _sourceStore(
        device,
        storage,
        identity.principalId,
        root,
      );
      await seedStore.read();
      await seedStore.change(
        (doc) => doc['channels']['history'] = {
          'messages': [
            {'text': 'saved'},
          ],
        },
      );
      device = DeviceRecord.fromJson({
        ...device.toJson(),
        'deviceSeed': url64(List.filled(32, 77)),
        'grantId': 'rotated-authentication-grant',
      });
      await vault.save(device);
      final source = MigrationHome(
        await Directory('${root.path}/source').create(),
        device.serverId,
      );
      source.network = HomeNetwork([ServerEndpoint.parse('203.0.113.1', 8443)]);
      source.ip = '203.0.113.1';
      final target = MigrationHome(
        await Directory('${root.path}/target').create(),
        device.serverId,
      );
      addTearDown(source.close);
      addTearDown(target.close);
      final exporter = HomeMigration(
        vault: vault,
        storage: storage,
        locks: () async => Directory('${root.path}/source-locks'),
      );
      final importer = HomeMigration(
        vault: targetVault,
        storage: targetStorage,
        locks: () async => Directory('${root.path}/target-locks'),
      );
      final path = '${root.path}/full.spacebackup';
      var stopped = false;
      await exporter.export(
        home: source,
        path: path,
        password: 'Длинный пароль переноса',
        stop: () async => stopped = true,
      );
      expect(stopped, true);
      await expectLater(vault.load(device.origin), throwsStateError);
      await expectLater(seedStore.read(), throwsStateError);
      expect(
        await File('${source.root.path}/device-migration-exported.json')
            .exists(),
        true,
      );
      expect(await source.start('203.0.113.1'), isNull);
      expect(source.error, contains('перенесено'));
      final remembered = <String>[];
      target.fail = true;
      await expectLater(
        importer.import(
          home: target,
          path: path,
          password: 'Длинный пароль переноса',
          publicIP: '',
          confirm: (_) async => true,
          remember: (origin) async => remembered.add(origin),
        ),
        throwsStateError,
      );
      expect(await targetVault.load(device.origin), isNull);
      target.fail = false;
      expect(
        await importer.import(
          home: target,
          path: path,
          password: 'Длинный пароль переноса',
          publicIP: '',
          confirm: (_) async => true,
          remember: (origin) async => remembered.add(origin),
        ),
        true,
      );
      expect(
        (await targetVault.load(device.origin))!.deviceSeed,
        device.deviceSeed,
      );
      expect(remembered, [device.origin]);
      final restored = MlsLocalStore(
        storage: targetStorage,
        engine: NativeMlsEngine(),
        scope: device.mlsIdentity!,
        deviceSeed: device.deviceSeed,
        lockDirectory: Directory('${root.path}/target-locks'),
        requireExisting: true,
      );
      expect(
        (await restored.read())['channels']['history']['messages'][0]['text'],
        'saved',
      );
      await restored.update('key_package', {});
      final advanced = jsonEncode(await restored.read());
      expect(
        await importer.import(
          home: target,
          path: path,
          password: 'Длинный пароль переноса',
          publicIP: '',
          confirm: (_) async => true,
          remember: (_) async {},
        ),
        true,
      );
      expect(jsonEncode(await restored.read()), advanced);
      expect(target.imports, 2);
      expect(await MigrationArchive.recognizes(path), true);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

Future<MlsLocalStore> _sourceStore(
  DeviceRecord device,
  MemoryMlsStorage storage,
  String principal,
  Directory root,
) async {
  final engine = NativeMlsEngine();
  final public = (await (await Ed25519().newKeyPairFromSeed(
    device.deviceSeed,
  )).extractPublicKey()).bytes;
  device.mlsIdentity = {
    'server_id': device.serverId,
    'principal_id': principal,
    'grant_id': device.grantId,
    'public_key': public,
  };
  return MlsLocalStore(
    storage: storage,
    engine: engine,
    scope: device.mlsIdentity!,
    deviceSeed: device.deviceSeed,
    lockDirectory: Directory('${root.path}/source-locks'),
  );
}
