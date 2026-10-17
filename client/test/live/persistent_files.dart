import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/attachments.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/pairing.dart';
import 'package:space_client/src/queued_file_store.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/src/rpc_connection.dart';

import '../channels_test.dart' show MemoryHistory, MemoryPositions;
import '../chat_history_test.dart' show HistoryKeys;
import '../support/rpc_fault_proxy.dart';

import '../support/temp_directory.dart';

class _ReplacementVault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async => record = value;
}

Future<IdentityVault> _replaceDevice(
  Discovery server,
  SpaceSession owner,
) async {
  final pairing = await PendingPairing.start(server);
  try {
    await owner.preparePairing(pairing.request.pairing);
    await pairing.poll();
    await owner.approvePairing(pairing.request.pairing);
    final record = await pairing.verifiedRecord(await pairing.poll());
    final vault = _ReplacementVault();
    final session = await SpaceSession.connect(
      server,
      vault,
      restoredRecord: record,
      pairingId: pairing.request.pairing.id,
    );
    pairing.claimed = true;
    expect(session.principalId, owner.principalId);
    expect(session.currentGrantId, isNot(owner.currentGrantId));
    await session.close();
    await owner.revoke();
    return vault;
  } finally {
    await pairing.close();
  }
}

class _FileFault extends Discovery {
  _FileFault(Discovery source)
    : super(
        source.origin,
        source.serverId,
        source.publicKey,
        connectOrigin: source.connectOrigin,
        endpoint: source.endpoint,
        tlsFingerprint: source.tlsFingerprint,
        dialHost: source.dialHost,
        announcement: source.announcement,
      );
  bool loseChunk = true, loseMessage = true;
  final beginKeys = <String>[], createKeys = <String>[], offsets = <int>[];
  @override
  RpcConnection openConnection({String setupCode = ''}) {
    final proxy = RpcFaultProxy(super.openConnection(setupCode: setupCode));
    proxy.beforeRequest = (request) {
      if (request is BeginUploadRequest) beginKeys.add(request.idempotencyKey);
      if (request is UploadChunkRequest) offsets.add(request.offset.toInt());
      if (request is CreateContentRequest) {
        createKeys.add(request.idempotencyKey);
      }
    };
    proxy.mutate = (method, response) {
      if (method == 'UploadChunkRequest' && loseChunk) {
        loseChunk = false;
        throw const GrpcError.unavailable(
          'Сервер сохранил часть; ответ потерян',
        );
      }
      if (method == 'CreateContentRequest' && loseMessage) {
        throw const HttpException('Сообщение сохранено; ответ потерян');
      }
      return response;
    };
    return proxy;
  }
}

Future<void> _wait(
  ChatController controller,
  bool Function() condition,
  String phase,
) async {
  final deadline = DateTime.now().add(const Duration(seconds: 20));
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException(
        '$phase: ${controller.sendStatus}, ${controller.outboxError}, '
        'pending=${controller.pendingMessages.length}, error=${controller.error}',
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

Future<void> verifyPersistentFiles(
  Discovery server,
  IdentityVault vault,
  SpaceSession owner,
  SpaceSession observer,
  List<int> bytes,
) async {
  final root = await Directory.systemTemp.createTemp(
    'space-live-persistent-files-',
  );
  final keys = HistoryKeys(), fileKeys = HistoryKeys();
  final remote = _FileFault(server);
  final controllers = <ChatController>[];
  Future<ChatController> start({IdentityVault? replacement}) async {
    final controller = ChatController(
      replacement ?? vault,
      historyStore: MemoryHistory(),
      positions: MemoryPositions(),
      outboxStore: LocalChatOutbox(storage: keys, directory: () async => root),
      fileStore: QueuedFileStore(
        storage: fileKeys,
        directory: () async => root,
      ),
      retryDelay: (_) => const Duration(hours: 1),
    )..preview = remote;
    controllers.add(controller);
    await controller.connect();
    expect(controller.connected, true, reason: controller.error);
    return controller;
  }

  try {
    final first = await start();
    final original = File('${root.path}/исходник.bin');
    await original.writeAsBytes(bytes);
    final text = 'Файловая очередь ${newRequestKey()}';
    expect(
      await first.send(text, files: [XFile(original.path)]),
      true,
      reason:
          'canQueueFiles=${first.canQueueFiles}, queue=${first.outboxError}',
    );
    await original.delete();
    await _wait(
      first,
      () => first.sendStatus == MessageSendStatus.unconfirmed,
      'Потеря части',
    );
    final pending = first.pendingMessages.single;
    expect(pending.localFiles, hasLength(1));
    expect(
      pending.blocked,
      false,
      reason: 'begin=${remote.beginKeys.length}, offsets=${remote.offsets}',
    );
    expect(pending.uploadedFiles, isEmpty);
    await first.close();
    final second = await start();
    await _wait(
      second,
      () => second.sendStatus == MessageSendStatus.unconfirmed,
      'Потеря подтверждения сообщения',
    );
    expect(second.pendingMessages.single.uploadedFiles, hasLength(1));
    await second.close();
    remote.loseMessage = false;
    final replacement = await _replaceDevice(server, owner);
    final third = await start(replacement: replacement);
    expect(third.pendingMessages, isEmpty);
    expect(remote.createKeys, [
      pending.key,
    ], reason: 'Новый grant не отправляет прежнюю очередь сам');
    expect(
      await third.recoverOutbox(
        third.state.outboxSources.single,
        third.outboxRecoveryTarget,
        snapshot: outboxSnapshot(
          await third.outboxStore.read(third.state.outboxSources.single),
        ),
      ),
      true,
    );
    await _wait(third, () => third.pendingMessages.isEmpty, 'Повтор сообщения');
    expect(remote.beginKeys, [
      pending.localFiles.single.key,
      pending.localFiles.single.key,
    ]);
    expect(remote.offsets, [0, 256 * 1024]);
    expect(remote.createKeys, [pending.key, pending.key]);
    final received = (await observer.messages())
        .where((m) => m.text == text)
        .toList();
    expect(received, hasLength(1));
    expect(
      await downloadAttachment(observer, received.single.attachments.single),
      bytes,
    );
    await third.close();
    expect(
      await root
          .list(recursive: true)
          .where((f) => f.path.endsWith('.bin'))
          .isEmpty,
      true,
    );
  } finally {
    for (final controller in controllers) {
      if (!controller.isClosed) await controller.close();
    }
    await deleteTestDirectory(root, prefix: 'space-live-persistent-files-');
  }
}
