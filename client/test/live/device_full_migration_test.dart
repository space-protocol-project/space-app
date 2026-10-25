import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/device_migration.dart';
import 'package:space_client/src/home_migration.dart';
import 'package:space_client/src/home_network.dart';

import 'device_migration_home.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/root_rotation.dart' as rotation;
import 'package:space_client/src/rpc_clients.dart' show AuthServiceClient;

import '../../tool/home_transfer_drill.dart' as transfer;
import '../mls_native_test.dart' show MemoryMlsStorage;
import '../support/temp_directory.dart';
import 'mls_server_test.dart' as live;
import 'mls_restore_devices.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;
  final runtime = Platform.environment['SPACE_HOME_RUNTIME'];
  final executable = Platform.environment['SPACE_RESTORE_EXECUTABLE'];
  test(
    'Перенос всего устройства: настоящие PostgreSQL, сервер, MLS и файл',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'space-full-migration-',
      );
      transfer.RunningSpace? running;
      SpaceSession? session;
      final peer = RestorePeer();
      try {
        final original = await Directory('${root.path}/original').create();
        await File('${original.path}/config.json')
            .writeAsString('{"ip":"203.0.113.10"}');
        running = await transfer.startSpace(
          executable!,
          runtime!,
          original,
          '203.0.113.10',
          bindHost: '127.0.0.3',
        );
        final sourceStorage = MemoryMlsStorage();
        final sourceVault = KeyIdentityVault(sourceStorage);
        session = await SpaceSession.connect(
          running.discovery,
          sourceVault,
          setupCode: running.setupCode,
        );
        var mls = await live.client(session, sourceStorage);
        await mls.createChannel('private', 'Полный перенос');
        await session.refreshChannels();
        final group = session.availableChannels
            .firstWhere((c) => c.id == 'private')
            .mlsGroupId;
        await mls.send('private', 'Сообщение до переустановки');
        await seedRestorePeers(session, mls, [peer], running, group);
        await mls.refresh('private', group);
        final previousSeed = List<int>.from(session.record.deviceSeed);
        await session.prepareRotation();
        await rotation.finishRootRotation(
          running.discovery,
          sourceVault,
          AuthServiceClient(session.channel),
        );
        await session.close();
        session = await SpaceSession.connect(running.discovery, sourceVault);
        expect(session.record.deviceSeed, isNot(previousSeed));
        mls = await live.client(session, sourceStorage);
        await mls.refresh('private', group);
        final record = session.record;
        await session.close();
        session = null;
        await peer.close();
        await running.stop();
        running = null;
        final sourceHome = NativeMigrationHome(original, executable, runtime);
        sourceHome.network = HomeNetwork([
          ServerEndpoint.parse('203.0.113.10', 8443),
        ], identityOrigin: record.origin);
        sourceHome.ip = '203.0.113.10';
        addTearDown(sourceHome.close);
        SharedPreferences.setMockInitialValues({
          'space.ui.origins': [record.origin],
          'space.ui.palette': 'iris',
        });
        final exporter = DeviceMigration(
          home: sourceHome,
          devices: HomeMigration(
            vault: sourceVault,
            storage: sourceStorage,
            locks: () async => Directory('${root.path}/source-locks'),
          ),
          preferences: await SharedPreferences.getInstance(),
          directory: () async => original,
          stop: () async {},
        );
        final path = '${root.path}/device.spacedevice';
        const password = 'Проверочный пароль полного устройства';
        await exporter.export(path, password);
        await expectLater(sourceVault.load(record.origin), throwsStateError);
        final targetStorage = MemoryMlsStorage();
        final targetVault = KeyIdentityVault(targetStorage);
        final targetRoot = await Directory('${root.path}/device-target')
            .create();
        final targetHome = NativeMigrationHome(targetRoot, executable, runtime);
        addTearDown(targetHome.close);
        SharedPreferences.setMockInitialValues({});
        final importer = DeviceMigration(
          home: targetHome,
          devices: HomeMigration(
            vault: targetVault,
            storage: targetStorage,
            locks: () async => Directory('${root.path}/target-locks'),
          ),
          preferences: await SharedPreferences.getInstance(),
          directory: () async => targetRoot,
          stop: () async {},
        );
        await importer.restore(path, password, publicIP: '203.0.113.10');
        expect(
          (await SharedPreferences.getInstance()).getString('space.ui.palette'),
          'iris',
        );
        final restored = Directory('${targetRoot.path}/transferred');
        running = await transfer.startSpace(
          executable,
          runtime,
          restored,
          '203.0.113.10',
          bindHost: '127.0.0.3',
        );
        session = await SpaceSession.connect(running.discovery, targetVault);
        expect(session.record.grantId, record.grantId);
        expect(session.record.deviceSeed, record.deviceSeed);
        final migrated = await live.client(session, targetStorage);
        final history = await migrated.refresh('private', group);
        expect(
          history.messages.where(
            (m) =>
                (m['message'] as Map)['text'] == 'Сообщение до переустановки',
          ),
          hasLength(1),
        );
        await verifyRestoreFile(migrated, group);
        await peer.connect(running);
        await migrated.send('private', 'После переноса');
        final received = await peer.mls.refresh('private', group);
        expect(
          received.messages.where(
            (m) => (m['message'] as Map)['text'] == 'После переноса',
          ),
          hasLength(1),
        );
        await peer.mls.send('private', 'Ответ после переноса');
        final reply = await migrated.refresh('private', group);
        expect(
          reply.messages.where(
            (m) => (m['message'] as Map)['text'] == 'Ответ после переноса',
          ),
          hasLength(1),
        );
      } finally {
        await session?.close();
        await peer.close();
        await running?.stop();
        await deleteTestDirectory(root, prefix: 'space-full-migration-');
      }
    },
    skip: runtime == null || executable == null,
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
