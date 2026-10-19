import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/home_archive_inspection.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/migration_archive.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/mls/native.dart';
import 'package:space_client/src/root_rotation.dart' as rotation;
import 'package:space_client/src/rpc_clients.dart' show AuthServiceClient;

import '../../tool/home_transfer_drill.dart' as transfer;
import '../mls_native_test.dart' show MemoryMlsStorage;
import '../support/temp_directory.dart';
import 'mls_server_test.dart' as live;
import 'mls_restore_devices.dart';

void main() {
  final runtime = Platform.environment['SPACE_HOME_RUNTIME'];
  final executable = Platform.environment['SPACE_RESTORE_EXECUTABLE'];
  test(
    'Полный зашифрованный перенос: настоящие PostgreSQL, сервер, MLS и файл',
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
          bindHost: '127.0.0.2',
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
        final zip = File('${root.path}/server.zip');
        await transfer.maintenance(executable, runtime, [
          '-home-export',
          zip.path,
          '-home-data',
          '${original.path}/data',
        ]);
        await transfer.inspectTransferArchive(executable, zip.path);
        final archive = File('${root.path}/full.spacebackup');
        const id = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
        const password = 'Проверочный пароль полного переноса';
        final source = MlsLocalStore(
          storage: sourceStorage,
          engine: NativeMlsEngine(),
          scope: record.mlsIdentity!,
          deviceSeed: record.deviceSeed,
          lockDirectory: Directory('${root.path}/source-locks'),
          requireExisting: true,
        );
        await source.transferCheckpoint(id, (checkpoint) async {
          await MigrationArchive.write(
            server: zip,
            password: password,
            destination: archive,
            device: {
              'v': 1,
              'id': id,
              'device': record.toJson(),
              'mls': checkpoint,
              'server_digest': await homeArchiveDigest(zip.path),
            },
          );
          await MigrationArchive.read(
            source: archive,
            password: password,
            allowUncommitted: true,
          );
        });
        await sourceVault.retireForMigration(record.origin, id);
        await MigrationArchive.commit(archive);
        await expectLater(source.read(), throwsStateError);
        await expectLater(sourceVault.load(record.origin), throwsStateError);
        final restoredZip = File('${root.path}/restored.zip');
        final payload = await MigrationArchive.read(
          source: archive,
          password: password,
          server: restoredZip,
        );
        expect(
          await homeArchiveDigest(restoredZip.path),
          payload['server_digest'],
        );
        final restoredRecord = DeviceRecord.fromJson(
          Map<String, dynamic>.from(payload['device'] as Map),
        );
        final targetStorage = MemoryMlsStorage();
        final targetVault = KeyIdentityVault(targetStorage);
        final target = MlsLocalStore(
          storage: targetStorage,
          engine: NativeMlsEngine(),
          scope: restoredRecord.mlsIdentity!,
          deviceSeed: restoredRecord.deviceSeed,
          lockDirectory: Directory('${root.path}/target-locks'),
          requireExisting: true,
        );
        await target.restoreCheckpoint(
          Map<String, dynamic>.from(payload['mls'] as Map),
          id,
        );
        await targetVault.installMigration(restoredRecord, id);
        final restored = Directory('${root.path}/restored');
        await transfer.maintenance(executable, runtime, [
          '-home-import',
          restoredZip.path,
          '-home-import-to',
          restored.path,
          '-public-ip',
          '203.0.113.10',
        ]);
        running = await transfer.startSpace(
          executable,
          runtime,
          restored,
          '203.0.113.10',
          bindHost: '127.0.0.2',
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
