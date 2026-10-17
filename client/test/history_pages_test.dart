import 'dart:async';
import 'dart:math' as math;

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_history.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/history_pages.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/message_bubble.dart';

import 'channels_test.dart'
    show CatalogSession, ChannelVault, MemoryHistory, MemoryPositions;
import 'support/chat_outbox.dart';
import 'chat_history_test.dart' show RecordVault;

Content historyItem(
  int sequence, {
  String channel = 'general',
  int revision = 1,
  bool deleted = false,
}) => Content(
  id: 'id-$sequence',
  channelId: channel,
  sequence: Int64(sequence),
  revision: Int64(revision),
  authorId: 'peer-${sequence % 3}',
  text: deleted
      ? ''
      : 'Сообщение $sequence${sequence % 5 == 0 ? '\nДлинная строка ' * 8 : ''}',
  deleted: deleted,
);

class PagedSession extends CatalogSession implements HistoryPageSession {
  PagedSession({this.total = 1250});
  final int total;
  String actor = 'u_test';
  @override
  String get principalId => actor;
  final requests = <(String, int)>[];
  Completer<void>? olderGate;
  Object? failure;
  GetHistoryPageResponse Function(GetHistoryPageResponse)? mutate;
  @override
  Future<List<Content>> messages() async =>
      throw StateError('Полная загрузка не должна вызываться');
  @override
  Future<HistoryPage> historyPage(String channel, {int before = 0}) async {
    requests.add((channel, before));
    final end = before == 0 ? total + 1 : math.min(before, total + 1);
    final start = math.max(1, end - 100);
    var response = GetHistoryPageResponse(
      contents: [
        for (var i = start; i < end; i++) historyItem(i, channel: channel),
      ],
      nextBeforeSequence: Int64(start > 1 ? start : 0),
      eventCursor: 'snapshot-$total',
    );
    final responseMutator = mutate;
    if (responseMutator != null) response = responseMutator(response);
    if (before > 0) {
      await olderGate?.future;
      if (failure != null) throw failure!;
    }
    return checkedHistoryPage(response, channel, before);
  }

  void frame(
    Content message,
    String cursor, {
    String type = 'content.updated',
  }) {
    streams[message.channelId]!.last.add(
      SubscribeResponse(
        cursor: cursor,
        event: Event(cursor: cursor, type: type, content: message),
      ),
    );
  }
}

Future<ChatController> pagedController(
  PagedSession session, {
  MemoryHistory? history,
  MemoryPositions? positions,
  IdentityVault? vault,
}) async {
  final controller = ChatController(
    vault ?? ChannelVault(),
    openSession: (_, _) async => session,
    positions: positions ?? MemoryPositions(),
    historyStore: history ?? MemoryHistory(),
    outboxStore: MemoryChatOutbox(),
  );
  controller.preview = Discovery(
    localOrigin('http://127.0.0.1:8080'),
    'srv_test',
    List.filled(32, 1),
  );
  await controller.connect();
  await Future<void>.delayed(const Duration(milliseconds: 20));
  return controller;
}

void main() {
  test(
    'История: подключение одной страницей и загрузка больше 1100 без дублей',
    () async {
      final session = PagedSession();
      final controller = await pagedController(session);
      addTearDown(controller.close);
      expect(controller.connected, isTrue, reason: controller.error);
      expect(controller.messages, hasLength(100));
      expect(controller.messages.first.sequence.toInt(), 1151);
      expect(session.requests, hasLength(1));
      expect(session.cursors.last.$2, 'snapshot-1250');
      while (controller.hasOlderHistory) {
        await controller.loadOlderHistory();
      }
      expect(controller.messages, hasLength(1250));
      expect(controller.messages.map((m) => m.id).toSet(), hasLength(1250));
      expect(controller.messages.first.sequence, Int64.ONE);
    },
  );
  for (final problem in ['network', 'invalid']) {
    test('История: $problem не продвигает границу, повтор безопасен', () async {
      final session = PagedSession();
      final controller = await pagedController(session);
      addTearDown(controller.close);
      if (problem == 'network') {
        session.failure = StateError('Сеть');
      } else {
        session.mutate = (page) => page..contents.first.channelId = 'other';
      }
      await controller.loadOlderHistory();
      expect(controller.messages, hasLength(100));
      expect(controller.historyError, isNotEmpty);
      final cursor = session.requests.last.$2;
      session.failure = null;
      session.mutate = null;
      await controller.loadOlderHistory();
      expect(session.requests.last.$2, cursor);
      expect(controller.messages, hasLength(200));
    });
  }
  test('История: одновременный запрос объединяется, смена канала отбрасывает ответ', () async {
    final session = PagedSession()..olderGate = Completer<void>();
    final controller = await pagedController(session);
    addTearDown(controller.close);
    final pending = controller.loadOlderHistory();
    await Future<void>.delayed(Duration.zero);
    await controller.loadOlderHistory();
    expect(session.requests, hasLength(2));
    await controller.selectChannel('team');
    session.olderGate!.complete();
    await pending;
    expect(controller.messages.every((m) => m.channelId == 'team'), isTrue);
    expect(controller.messages, hasLength(100));
  });
  test('История: правка и удаление во время загрузки не теряются', () async {
    final session = PagedSession()..olderGate = Completer<void>();
    final controller = await pagedController(session);
    addTearDown(controller.close);
    final pending = controller.loadOlderHistory();
    await Future<void>.delayed(Duration.zero);
    session.frame(
      historyItem(1080, revision: 2)..text = 'Правка во время страницы',
      'edit-1080',
    );
    session.frame(
      historyItem(1081, revision: 2, deleted: true),
      'delete-1081',
      type: 'content.deleted',
    );
    session.frame(historyItem(1251), 'new-1251', type: 'content.created');
    await Future<void>.delayed(const Duration(milliseconds: 20));
    session.olderGate!.complete();
    await pending;
    expect(
      controller.messages.singleWhere((m) => m.id == 'id-1080').text,
      'Правка во время страницы',
    );
    expect(
      controller.messages.singleWhere((m) => m.id == 'id-1081').deleted,
      isTrue,
    );
    expect(controller.messages.last.id, 'id-1251');
  });
  test(
    'История: переполнение правок отменяет страницу с возможностью повторить',
    () async {
      final session = PagedSession()..olderGate = Completer<void>();
      final controller = await pagedController(session);
      addTearDown(controller.close);
      final pending = controller.loadOlderHistory();
      await Future<void>.delayed(Duration.zero);
      for (var i = 1; i <= 201; i++) {
        session.frame(historyItem(i, revision: 2), 'edit-$i');
      }
      await Future<void>.delayed(const Duration(milliseconds: 50));
      session.olderGate!.complete();
      await pending;
      expect(controller.messages, hasLength(100));
      expect(controller.historyError, isNotEmpty);
      session.olderGate = null;
      await controller.loadOlderHistory();
      expect(controller.messages, hasLength(200));
    },
  );
  test('История: курсор кэша защищён вместе с данными, старые события не раздувают окно', () async {
    final session = PagedSession();
    final history = MemoryHistory();
    final positions = MemoryPositions();
    final record = DeviceRecord(
      origin: 'http://127.0.0.1:8080',
      serverId: 'srv_test',
      serverKey: 'key',
      rootSeed: List.filled(32, 2),
      deviceSeed: List.filled(32, 3),
    );
    session.actor = (await record.identity()).principalId;
    final saved =
        ChatHistory(
            serverId: 'srv_test',
            principalId: session.principalId,
            grantId: '',
          )
          ..channels = session.availableChannels
          ..eventCursors = {'general': 'cache-checkpoint'};
    saved.entries['general/id-5'] = CachedMessage(
      historyItem(5),
      DateTime.now().millisecondsSinceEpoch,
    );
    saved.entries['general/id-150'] = CachedMessage(
      historyItem(150),
      DateTime.now().millisecondsSinceEpoch,
    );
    saved.favorites.add('general/id-5');
    history.data['http://127.0.0.1:8080'] = saved;
    positions.data[session.positionScope] = {
      'channels': {
        'general': {'cursor': 'ahead-of-cache'},
      },
    };
    final controller = await pagedController(
      session,
      history: history,
      positions: positions,
      vault: RecordVault(record),
    );
    addTearDown(controller.close);
    expect(session.cursors.last.$2, 'cache-checkpoint');
    session.frame(
      historyItem(5, revision: 2, deleted: true),
      'delete-5',
      type: 'content.deleted',
    );
    for (var i = 6; i <= 150; i++) {
      session.frame(historyItem(i), 'old-$i', type: 'content.created');
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.messages, hasLength(102));
    expect(
      controller.messages.singleWhere((m) => m.id == 'id-5').deleted,
      isTrue,
    );
    expect(saved.favorites, isEmpty);
    expect(saved.eventCursors['general'], 'old-150');
    final roundtrip = ChatHistory.fromJson(saved.toJson(), DateTime.now());
    expect(roundtrip.eventCursors['general'], 'old-150');
  });
  test('История: проверка порядка, границы и пустой страницы', () {
    for (final invalid in [
      GetHistoryPageResponse(contents: [historyItem(2), historyItem(1)]),
      GetHistoryPageResponse(contents: [historyItem(2), historyItem(2)]),
      GetHistoryPageResponse(contents: [historyItem(2, channel: 'other')]),
      GetHistoryPageResponse(contents: [historyItem(0)]),
      GetHistoryPageResponse(
        contents: [historyItem(2)],
        nextBeforeSequence: Int64(2),
      ),
    ]) {
      expect(() => checkedHistoryPage(invalid, 'general', 0), throwsStateError);
    }
    expect(
      checkedHistoryPage(GetHistoryPageResponse(), 'general', 0).nextBefore,
      0,
    );
  });
  testWidgets(
    'История: загрузка сохраняет положение пузырька при разной высоте строк',
    (tester) async {
      final session = PagedSession(total: 220);
      late ChatController controller;
      await tester.runAsync(() async {
        controller = await pagedController(session);
      });
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: ChatView(
              controller: controller,
              openConnection: () {},
              showHeader: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final row = find.byKey(const ValueKey(('history-message', 'id-121')));
      final bubble = find.descendant(
        of: row,
        matching: find.byType(MessageBubble),
      );
      final before = tester.getTopLeft(bubble).dy;
      await tester.tap(find.text('Загрузить предыдущие сообщения'));
      for (var i = 0; i < 35; i++) {
        await tester.pump();
        await tester.runAsync(
          () async => Future<void>.delayed(const Duration(milliseconds: 2)),
        );
      }
      await tester.pumpAndSettle();
      expect(controller.messages, hasLength(200));
      expect(tester.getTopLeft(bubble).dy, closeTo(before, 2));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
}
