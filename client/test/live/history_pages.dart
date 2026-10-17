import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_history.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/queued_file_store.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/src/rpc_connection.dart';

import '../channels_test.dart' show MemoryPositions;
import '../chat_history_test.dart' show HistoryKeys;
import '../support/rpc_fault_proxy.dart';
import '../support/temp_directory.dart';

class _HistoryNetwork extends Discovery {
  _HistoryNetwork(Discovery source)
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
  int lost = 0;
  int pages = 0;
  @override
  RpcConnection openConnection({String setupCode = ''}) =>
      RpcFaultProxy(super.openConnection(setupCode: setupCode))
        ..beforeRequest = (request) {
          if (request is GetHistoryPageRequest) pages++;
        }
        ..mutate = (method, response) {
          if (lose && method == 'CreateContentRequest') {
            lost++;
            throw const HttpException('Подтверждение потеряно');
          }
          return response;
        };
}

Future<void> _waitHistory(bool Function() ready) async {
  final deadline = DateTime.now().add(const Duration(seconds: 15));
  while (!ready()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('История/очередь не восстановилась');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

Future<void> verifyHistoryPages(Discovery server, IdentityVault vault) async {
  SharedPreferences.setMockInitialValues({});
  final sender = await SpaceSession.connect(server, vault);
  final root = await Directory.systemTemp.createTemp('space-live-history-');
  final keys = HistoryKeys(), positions = MemoryPositions();
  final history = LocalChatHistory(storage: keys);
  final network = _HistoryNetwork(server);
  final controllers = <ChatController>[];
  Future<ChatController> start() async {
    final controller = ChatController(
      vault,
      historyStore: history,
      positions: positions,
      outboxStore: LocalChatOutbox(storage: keys, directory: () async => root),
      fileStore: QueuedFileStore(
        storage: keys,
        directory: () async => Directory.fromUri(root.uri.resolve('files/')),
      ),
      retryDelay: (_) => const Duration(hours: 1),
    )..preview = network;
    controllers.add(controller);
    await controller.connect();
    expect(controller.connected, isTrue, reason: controller.error);
    if (controller.channelId != 'history_pages') {
      await controller.selectChannel('history_pages');
    }
    expect(controller.connected, isTrue, reason: controller.error);
    return controller;
  }

  try {
    await ChannelServiceClient(sender.channel).createChannel(
      CreateChannelRequest(
        channelId: 'history_pages',
        title: 'Большая история',
        viewType: 'chat',
      ),
      options: await sender.mlsOptions(expectedGrant: sender.record.grantId),
    );
    await sender.refreshChannels();
    Content? first, middle;
    for (var i = 1; i <= 1205; i++) {
      final item = await sender.sendQueued(
        'history_pages',
        'История $i',
        'history-live-$i',
        [],
      );
      if (i == 1) first = item;
      if (i == 650) middle = item;
    }
    final current = await start();
    expect(network.pages, 2);
    expect(current.messages, hasLength(100));
    await Future<void>.delayed(const Duration(milliseconds: 600));
    expect(
      current.messages,
      hasLength(100),
      reason: 'Подписка не должна заново загружать весь журнал',
    );
    while (current.hasOlderHistory) {
      await current.loadOlderHistory();
      expect(current.historyError, isEmpty);
    }
    expect(current.messages, hasLength(1205));
    await current.toggleFavorite(current.messages.first);
    await current.flushHistory();
    const pendingText = 'Очередь после большой истории';
    network.lose = true;
    expect(await current.send(pendingText), isTrue);
    await _waitHistory(() => network.lost > 0);
    await current.flushHistory();
    await current.close();
    network.lose = false;
    await sender.deleteMessage(first!);
    await sender.updateMessage(
      middle!,
      'Правка за пределами последней страницы',
    );
    final latest = await sender.historyPage('history_pages');
    final state = positions.data[sender.positionScope]!;
    ((state['channels'] as Map)['history_pages'] as Map)['cursor'] =
        latest.eventCursor;
    final restarted = await start();
    await _waitHistory(
      () =>
          restarted.pendingMessages.isEmpty &&
          restarted.messages.any(
            (item) => item.id == first!.id && item.deleted,
          ) &&
          restarted.messages.any(
            (item) =>
                item.id == middle!.id &&
                item.text == 'Правка за пределами последней страницы',
          ),
    );
    expect(restarted.messages, hasLength(1206));
    expect(restarted.messages.map((item) => item.id).toSet(), hasLength(1206));
    expect(restarted.messages.where(restarted.isFavorite), isEmpty);
    final matches = await sender.searchMessages(
      'history_pages',
      pendingText,
      '',
    );
    expect(
      matches.messages,
      hasLength(1),
      reason: 'Потеря квитанции не создаёт дубль',
    );
    await restarted.flushHistory();
    final restored = await history.read(server.origin.toString());
    expect(restored!.eventCursors['history_pages'], isNotEmpty);
    expect(
      restored.entries['history_pages/${first.id}']!.content.deleted,
      isTrue,
    );
  } finally {
    for (final controller in controllers) {
      if (!controller.isClosed) await controller.close();
    }
    await sender.close();
    await deleteTestDirectory(root, prefix: 'space-live-history-');
  }
}
