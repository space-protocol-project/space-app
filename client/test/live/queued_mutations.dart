import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/queued_file_store.dart';
import 'package:space_client/src/queued_mutation.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/src/rpc_connection.dart';

import '../channels_test.dart' show MemoryHistory, MemoryPositions;
import '../chat_history_test.dart' show HistoryKeys;
import '../support/rpc_fault_proxy.dart';
import 'ordinary_sync.dart' show pairOrdinaryDevice;

class _MutationNetwork extends Discovery {
  _MutationNetwork(Discovery source)
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
  bool lose = false;
  final keys = <String>[];
  @override
  RpcConnection openConnection({String setupCode = ''}) {
    final proxy = RpcFaultProxy(super.openConnection(setupCode: setupCode));
    proxy.beforeRequest = (request) {
      if (request is! ApplyContentMutationRequest) return;
      final key = switch (request.whichAction()) {
        ApplyContentMutationRequest_Action.update =>
          request.update.idempotencyKey,
        ApplyContentMutationRequest_Action.delete =>
          request.delete.idempotencyKey,
        ApplyContentMutationRequest_Action.reaction =>
          request.reaction.idempotencyKey,
        _ => '',
      };
      keys.add(key);
    };
    proxy.mutate = (method, response) {
      if (lose && method == 'ApplyContentMutationRequest') {
        throw const HttpException('Изменение применено, ответ потерян');
      }
      return response;
    };
    return proxy;
  }
}

Future<void> _waitForMutation(
  ChatController controller,
  bool Function() ready,
) async {
  final deadline = DateTime.now().add(const Duration(seconds: 15));
  while (!ready()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException(
        'Очередь изменений: ${controller.sendStatus}, '
        '${controller.outboxError}, ${controller.error}',
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

Future<void> verifyQueuedMutations(
  Discovery server,
  IdentityVault vault,
  SpaceSession owner,
  SpaceSession observer,
) async {
  final root = await Directory.systemTemp.createTemp('space-live-mutations-');
  final keys = HistoryKeys();
  final remote = _MutationNetwork(server);
  final controllers = <ChatController>[];
  Future<ChatController> start() async {
    final controller = ChatController(
      vault,
      outboxStore: LocalChatOutbox(storage: keys, directory: () async => root),
      fileStore: QueuedFileStore(storage: keys, directory: () async => root),
      historyStore: MemoryHistory(),
      positions: MemoryPositions(),
      retryDelay: (_) => const Duration(hours: 1),
    )..preview = remote;
    controllers.add(controller);
    await controller.connect();
    expect(controller.connected, true, reason: controller.error);
    return controller;
  }

  Content target(ChatController controller, String id) =>
      controller.messages.singleWhere((item) => item.id == id);
  try {
    final original = await owner.send(
      'Очередь изменений ${newRequestKey()}',
      newRequestKey(),
    );
    final first = await start();
    await first.disconnect();
    expect(
      await first.updateMessage(target(first, original.id), 'Правка без сети'),
      true,
    );
    expect(
      await first.setReaction(target(first, original.id), '👍', true),
      true,
    );
    expect(
      await first.setReaction(target(first, original.id), '👍', false),
      true,
    );
    expect(await first.deleteMessage(target(first, original.id)), true);
    final pending = first.pendingMessages;
    expect(pending.map((entry) => entry.mutation!.kind), [
      MutationKind.edit,
      MutationKind.reaction,
      MutationKind.reaction,
      MutationKind.delete,
    ]);
    expect(remote.keys, isEmpty);
    await first.close();
    remote.lose = true;
    final second = await start();
    await _waitForMutation(
      second,
      () => second.sendStatus == MessageSendStatus.unconfirmed,
    );
    expect(second.pendingMessages.length, 4);
    await second.close();
    remote.lose = false;
    final third = await start();
    await _waitForMutation(third, () => third.pendingMessages.isEmpty);
    expect(remote.keys, [
      pending.first.key,
      ...pending.map((entry) => entry.key),
    ]);
    final tombstone = (await observer.messages()).singleWhere(
      (item) => item.id == original.id,
    );
    expect(tombstone.deleted, true);
    expect(tombstone.revision.toInt(), 5);
    expect(tombstone.sequence, original.sequence);
    await third.close();

    final conflicting = await owner.send(
      'Конкурентная правка ${newRequestKey()}',
      newRequestKey(),
    );
    final fourth = await start();
    await fourth.disconnect();
    expect(
      await fourth.updateMessage(
        target(fourth, conflicting.id),
        'Мой черновик',
      ),
      true,
    );
    await fourth.close();
    final pairedVault = await pairOrdinaryDevice(server, owner);
    final other = await SpaceSession.connect(server, pairedVault);
    try {
      expect(other.currentGrantId, isNot(owner.currentGrantId));
      await other.updateMessage(conflicting, 'Правка другого устройства');
    } finally {
      await other.close();
    }
    final fifth = await start();
    await _waitForMutation(fifth, () => fifth.pendingMessages.single.blocked);
    expect(fifth.pendingMessages.single.text, 'Мой черновик');
    final actual = (await observer.messages()).singleWhere(
      (item) => item.id == conflicting.id,
    );
    expect(actual.text, 'Правка другого устройства');
    expect(actual.revision.toInt(), 2);
    await fifth.discardPending(fifth.pendingMessages.single.key);
  } finally {
    for (final controller in controllers) {
      if (!controller.isClosed) await controller.close();
    }
    await root.delete(recursive: true);
  }
}
