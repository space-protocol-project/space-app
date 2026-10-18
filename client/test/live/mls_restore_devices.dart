import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/mls/files.dart';

import '../../tool/home_transfer_drill.dart' as transfer;
import '../mls_native_test.dart' show MemoryMlsStorage;
import 'mls_server_test.dart' as live;

class RestorePeer {
  final vault = transfer.TransferVault();
  final storage = MemoryMlsStorage();
  SpaceSession? session;
  late MlsClient mls;
  Future<void> connect(transfer.RunningSpace space, {String? token}) async {
    session = await SpaceSession.connect(
      space.discovery,
      vault,
      invitationToken: token ?? '',
    );
    mls = await live.client(session!, storage);
    await mls.initialize();
  }

  Future<void> close() async {
    await session?.close();
    session = null;
  }
}

final restoreBytes = Uint8List.fromList(List.generate(300000, (i) => i % 251));

Future<void> seedRestorePeers(
  SpaceSession owner,
  MlsClient mls,
  List<RestorePeer> peers,
  transfer.RunningSpace space,
  List<int> group,
) async {
  for (final peer in peers) {
    final invite = await owner.adminRequest(
      '/api/v1/space/invites',
      method: 'POST',
      body: {'role': 'member', 'ttlSeconds': 3600, 'maxUses': 1},
    );
    await peer.connect(space, token: invite['token'] as String);
  }
  final roster = await mls.devices('private');
  for (final device in roster) {
    await mls.trust(device);
    for (final peer in peers) {
      await peer.mls.trust(device);
    }
  }
  for (final peer in peers) {
    await mls.invite(
      'private',
      roster.firstWhere((d) => d.grantId == peer.session!.record.grantId),
    );
    await peer.mls.refresh('private', group);
  }
  for (final peer in peers) {
    await peer.mls.refresh('private', group);
  }
  await MlsFiles(peers.first.mls).send('private', group, 'Зашифрованный файл', [
    XFile.fromData(restoreBytes, name: 'проверка.bin', path: 'проверка.bin'),
  ]);
  for (final peer in peers) {
    await verifyRestoreFile(peer.mls, group);
  }
  await verifyRestoreFile(mls, group);
}

Future<void> verifyRestoreFile(MlsClient mls, List<int> group) async {
  final view = await mls.refresh('private', group);
  final message = view.messages
      .map((m) => m['message'] as Map)
      .singleWhere((m) => m['text'] == 'Зашифрованный файл');
  final descriptor = Map<String, dynamic>.from(
    (message['files'] as List).single as Map,
  );
  expect(descriptor['name'], 'проверка.bin');
  final bytes = await MlsFiles(mls)
      .download(group, (message['id'] as List).cast<int>(), descriptor);
  expect(bytes, orderedEquals(restoreBytes));
}
