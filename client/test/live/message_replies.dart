import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/attachments.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/queued_file_store.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/src/rpc_connection.dart';

import '../channels_test.dart' show MemoryHistory, MemoryPositions;
import '../chat_history_test.dart' show HistoryKeys;
import '../support/rpc_fault_proxy.dart';
import 'ordinary_sync.dart' show pairOrdinaryDevice;

import '../support/temp_directory.dart';

class _ReplyNetwork extends Discovery {
  _ReplyNetwork(Discovery source)
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
    return RpcFaultProxy(super.openConnection(setupCode: setupCode))
      ..beforeRequest = (request) {
        if (request is CreateContentRequest && request.replyToId.isNotEmpty) {
          keys.add(request.idempotencyKey);
        }
      }
      ..mutate = (method, response) {
        if (lose && method == 'CreateContentRequest') {
          throw const HttpException('Ответ принят, подтверждение потеряно');
        }
        return response;
      };
  }
}

class _ReplyFiles extends QueuedFileStore {
  _ReplyFiles({super.storage, super.directory, required this.onFailure});
  final void Function(Object) onFailure;
  @override
  Future<List<PendingMessage>> enqueue(
    OutboxScope scope,
    PendingMessage entry,
    List<XFile> files,
    ChatOutboxStore outbox, {
    required bool Function() active,
  }) async {
    try {
      return await super.enqueue(scope, entry, files, outbox, active: active);
    } catch (error) {
      onFailure(error);
      rethrow;
    }
  }
}

Future<void> _wait(ChatController controller, bool Function() ready) async {
  final deadline = DateTime.now().add(const Duration(seconds: 15));
  while (!ready()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('Очередь ответа: ${controller.outboxError}');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

Future<void> verifyMessageReplies(
  Discovery server,
  IdentityVault vault,
  SpaceSession owner,
) async {
  final root = await Directory.systemTemp.createTemp('space-live-replies-');
  final keys = HistoryKeys();
  final network = _ReplyNetwork(server);
  final controllers = <ChatController>[];
  Object? saveFailure;
  Future<ChatController> start() async {
    final controller = ChatController(
      vault,
      outboxStore: LocalChatOutbox(storage: keys, directory: () async => root),
      fileStore: _ReplyFiles(
        storage: keys,
        directory: () async => root,
        onFailure: (error) => saveFailure = error,
      ),
      historyStore: MemoryHistory(),
      positions: MemoryPositions(),
      retryDelay: (_) => const Duration(hours: 1),
    )..preview = network;
    controllers.add(controller);
    await controller.connect();
    expect(controller.connected, isTrue, reason: controller.error);
    expect(controller.repliesSupported, isTrue);
    return controller;
  }

  try {
    final parent = await owner.send(
      'Исходник ответа ${newRequestKey()}',
      newRequestKey(),
    );
    final text = 'Ответ с файлом ${newRequestKey()}';
    final bytes = Uint8List.fromList(List.generate(32768, (i) => i % 251));
    final original = await File('${root.path}/reply.bin').writeAsBytes(bytes);
    final first = await start();
    await first.disconnect();
    expect(
      await first.send(text, replyTo: parent.id, files: [XFile(original.path)]),
      isTrue,
      reason:
          'queue=${first.canQueue}, files=${first.canQueueFiles}, replies=${first.repliesSupported}, error=${first.outboxError}, save=$saveFailure',
    );
    final pending = first.pendingMessages.single;
    expect(pending.replyTo, parent.id);
    expect(pending.localFiles, hasLength(1));
    await original.delete();
    await first.close();

    network.lose = true;
    final second = await start();
    await _wait(
      second,
      () => second.sendStatus == MessageSendStatus.unconfirmed,
    );
    expect(second.pendingMessages.single.replyTo, parent.id);
    await second.close();

    final pairedVault = await pairOrdinaryDevice(server, owner);
    final other = await SpaceSession.connect(server, pairedVault);
    try {
      final before = (await other.messages()).singleWhere(
        (m) => m.text == text,
      );
      expect(before.replyToId, parent.id);
      expect(before.attachments, hasLength(1));
      expect(await downloadAttachment(other, before.attachments.single), bytes);
      await owner.deleteMessage(parent);
      network.lose = false;
      final third = await start();
      await _wait(third, () => third.pendingMessages.isEmpty);
      final history = await other.messages();
      final replies = history.where((m) => m.text == text).toList();
      expect(replies, hasLength(1));
      expect(replies.single.id, before.id);
      expect(replies.single.replyToId, parent.id);
      expect(
        replies.single.attachments.single.id,
        before.attachments.single.id,
      );
      expect(history.singleWhere((m) => m.id == parent.id).deleted, isTrue);
      expect(network.keys, [pending.key, pending.key]);
    } finally {
      await other.close();
    }
  } finally {
    for (final controller in controllers) {
      if (!controller.isClosed) await controller.close();
    }
    await deleteTestDirectory(root, prefix: 'space-live-replies-');
  }
}
