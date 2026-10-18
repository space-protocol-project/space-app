import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/mls/client.dart';

import '../../tool/home_transfer_drill.dart' as transfer;
import '../mls_native_test.dart' show MemoryMlsStorage;
import 'mls_server_test.dart' as live;
import 'mls_restore_devices.dart';

void main() {
  final runtime = Platform.environment['SPACE_HOME_RUNTIME'];
  final executable = Platform.environment['SPACE_RESTORE_EXECUTABLE'];
  test(
    'MLS: архив сервера и отдельное состояние устройства',
    () async {
      final root = await Directory.systemTemp.createTemp('space-mls-restore-');
      transfer.RunningSpace? running;
      final vault = transfer.TransferVault();
      final storage = MemoryMlsStorage();
      final peers = List.generate(2, (_) => RestorePeer());
      SpaceSession? activeSession;
      try {
        final original = await Directory('${root.path}/original').create();
        await File('${original.path}/config.json')
            .writeAsString('{"ip":"203.0.113.10"}');
        running = await transfer.startSpace(
          executable!,
          runtime!,
          original,
          '203.0.113.10',
        );
        var session = await SpaceSession.connect(
          running.discovery,
          vault,
          setupCode: running.setupCode,
        );
        activeSession = session;
        var mls = await live.client(session, storage);
        await mls.createChannel('private', 'Архив MLS');
        await session.refreshChannels();
        final group = session.availableChannels
            .firstWhere((c) => c.id == 'private')
            .mlsGroupId;
        await mls.send('private', 'До архива');
        await seedRestorePeers(session, mls, peers, running, group);
        await mls.refresh('private', group);
        final saved = Map<String, String>.from(storage.values);
        for (final peer in peers) {
          await peer.close();
        }
        await session.close();
        await running.stop();
        running = null;
        final archive = '${root.path}/space.zip';
        await transfer.maintenance(executable, runtime, [
          '-home-export',
          archive,
          '-home-data',
          '${original.path}/data',
        ]);
        await transfer.inspectTransferArchive(executable, archive);
        final restored = '${root.path}/restored';
        await transfer.maintenance(executable, runtime, [
          '-home-import',
          archive,
          '-home-import-to',
          restored,
          '-public-ip',
          '203.0.113.10',
        ]);
        running = await transfer.startSpace(
          executable,
          runtime,
          Directory(restored),
          '203.0.113.10',
        );
        session = await SpaceSession.connect(running.discovery, vault);
        activeSession = session;
        mls = await live.client(session, storage);
        final view = await mls.refresh('private', group);
        expect(
          view.messages.where(
            (m) => (m['message'] as Map)['text'] == 'До архива',
          ),
          hasLength(1),
        );
        await verifyRestoreFile(mls, group);
        for (final peer in peers) {
          await peer.connect(running);
          await verifyRestoreFile(peer.mls, group);
        }
        await mls.selfUpdate('private');
        await mls.send('private', 'После архива');
        await mls.refresh('private', group);
        for (final peer in peers) {
          await peer.mls.refresh('private', group);
          await peer.mls.send(
            'private',
            'После восстановления ${peer.session!.principalId}',
          );
        }
        await mls.refresh('private', group);
        final peerStates = <String>[];
        for (final peer in peers) {
          await peer.mls.refresh('private', group);
          peerStates.add(jsonEncode((await peer.mls.local.read())['channels']));
          await peer.close();
        }
        final forward = jsonEncode((await mls.local.read())['channels']);
        await session.close();
        await running.stop();
        running = null;
        final older = '${root.path}/older';
        running = await transfer.startSpace(
          executable,
          runtime,
          Directory(restored),
          '203.0.113.10',
        );
        session = await SpaceSession.connect(running.discovery, vault);
        activeSession = session;
        mls = await live.client(session, storage);
        await verifyRestoreFile(mls, group);
        for (final peer in peers) {
          await peer.connect(running);
          await verifyRestoreFile(peer.mls, group);
          final history = await peer.mls.refresh('private', group);
          expect(
            history.messages.where(
              (m) => (m['message'] as Map)['text'] == 'После архива',
            ),
            hasLength(1),
          );
          await peer.close();
        }
        await session.close();
        await running.stop();
        running = null;
        await transfer.maintenance(executable, runtime, [
          '-home-import',
          archive,
          '-home-import-to',
          older,
        ]);
        running = await transfer.startSpace(
          executable,
          runtime,
          Directory(older),
          '203.0.113.10',
        );
        session = await SpaceSession.connect(running.discovery, vault);
        activeSession = session;
        mls = await live.client(session, storage);
        await expectLater(
          mls.refresh('private', group),
          throwsA(
            isA<GrpcError>().having(
              (e) => e.code,
              'code',
              StatusCode.failedPrecondition,
            ),
          ),
        );
        expect(jsonEncode((await mls.local.read())['channels']), forward);
        expect(storage.values, isNot(equals(saved)));
        for (var i = 0; i < peers.length; i++) {
          final peer = peers[i];
          await peer.connect(running);
          await expectLater(
            peer.mls.refresh('private', group),
            throwsA(
              isA<GrpcError>().having(
                (e) => e.code,
                'code',
                StatusCode.failedPrecondition,
              ),
            ),
          );
          expect(
            jsonEncode((await peer.mls.local.read())['channels']),
            peerStates[i],
          );
        }
        await session.close();
      } finally {
        await activeSession?.close();
        for (final peer in peers) {
          await peer.close();
        }
        await running?.stop();
        await root.delete(recursive: true);
      }
    },
    skip: runtime == null || executable == null,
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
