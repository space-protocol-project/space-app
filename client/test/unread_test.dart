import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart' hide View;
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/message_bubble.dart';
import 'package:space_client/ui/measure_size.dart';

import 'channels_test.dart'
    show CatalogSession, MemoryPositions, connected, chat, settle;

class SequencedSession extends CatalogSession {
  SequencedSession({this.identity = 'u_test'}) {
    availableChannels = [
      chat('general')..latestMessageSequence = Int64(5),
      chat('team')..latestMessageSequence = Int64(3),
    ];
  }
  final String identity;
  @override
  String get principalId => identity;
  @override
  Future<List<Content>> messages() async => canRead
      ? [
          for (var i = 1; i <= 5; i++)
            Content(
              id: 'm-$i',
              channelId: selectedChannelId,
              text: 'Сообщение $i',
              sequence: Int64(i),
            ),
        ]
      : [];
}

class LongSession extends SequencedSession {
  LongSession() {
    availableChannels.first.latestMessageSequence = Int64(50);
  }
  @override
  Future<List<Content>> messages() async => [
    for (var i = 1; i <= 50; i++)
      Content(
        id: 'm-$i',
        channelId: selectedChannelId,
        text: 'Сообщение $i: ${'длинная строка ' * (i % 4 + 1)}',
        sequence: Int64(i),
      ),
  ];
}

void main() {
  testWidgets(
    'Прочтение учитывает заголовок и плавающее поле после прокрутки',
    (tester) async {
      tester.view.physicalSize = const Size(390, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = await tester.runAsync(
        () => connected(LongSession(), MemoryPositions()),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatView(
              controller: controller!,
              openConnection: () {},
              topInset: 120,
              showHeader: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final history = find.descendant(
        of: find.byType(ChatView),
        matching: find.byType(ListView),
      );
      for (var step = 0; step < 3; step++) {
        if (step > 0) await tester.drag(history, const Offset(0, -180));
        await tester.pumpAndSettle();
        final top = tester.getRect(find.byType(ChatView)).top + 120;
        final bottom = tester.getRect(find.byType(MeasureSize)).top - 8;
        final rows = find.descendant(
          of: find.byType(ChatView),
          matching: find.byWidgetPredicate(
            (widget) => widget is MessageBubble && widget.key is GlobalKey,
          ),
        );
        final visible = <int>[];
        for (final row in rows.evaluate()) {
          final rect = tester.getRect(find.byWidget(row.widget));
          if (rect.top < top || rect.bottom > bottom) continue;
          final text = (row.widget as MessageBubble).text;
          visible.add(
            int.parse(RegExp(r'Сообщение (\d+):').firstMatch(text)!.group(1)!),
          );
        }
        expect(visible, isNotEmpty);
        expect(controller.readSequence('general'), visible.last);
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(controller.disconnect);
      controller.dispose();
    },
  );
  testWidgets('Диалог поверх чата не отмечает новое сообщение прочитанным', (
    tester,
  ) async {
    final session = SequencedSession();
    final c = await tester.runAsync(
      () => connected(session, MemoryPositions()),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatView(controller: c!, openConnection: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final previous = c.readThrough;
    final previousUnread = c.unreadCount('general');
    showDialog<void>(
      context: tester.element(find.byType(ChatView)),
      builder: (context) => AlertDialog(
        title: const Text('Окно'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    session.streams['general']!.last.add(
      SubscribeResponse(
        cursor: 'event-6',
        event: Event(
          cursor: 'event-6',
          type: 'content.created',
          content: Content(
            id: 'm-6',
            channelId: 'general',
            text: 'Новое под диалогом',
            sequence: Int64(6),
          ),
        ),
      ),
    );
    await tester.runAsync(settle);
    await tester.pumpAndSettle();
    expect(c.readThrough, previous);
    expect(c.unreadCount('general'), previousUnread + 1);
    await tester.tap(find.text('Закрыть'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(c.disconnect);
    c.dispose();
  });

  testWidgets('Переход к новым сообщениям не отмечает всю длинную историю', (
    tester,
  ) async {
    final positions = MemoryPositions();
    positions.data['scope-u_test'] = {
      'channels': {
        'general': {'readThrough': 'm-30', 'readSequence': 30},
      },
      'selected': 'general',
    };
    final c = await tester.runAsync(() => connected(LongSession(), positions));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatView(controller: c!, openConnection: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(c.readSequence('general'), 30);
    expect(c.unreadCount('general'), 20);
    await tester.tap(find.text('Новые сообщения: 20'));
    await tester.pumpAndSettle();
    expect(c.readSequence('general'), greaterThan(30));
    expect(c.readSequence('general'), lessThan(50));
    expect(find.textContaining('Сообщение 31:'), findsWidgets);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(c.disconnect);
    c.dispose();
  });

  test(
    'Счётчики, монотонное чтение, перезапуск, другой пользователь и отзыв',
    () async {
      final positions = MemoryPositions(), session = SequencedSession();
      final c = await connected(session, positions);
      expect(c.unreadCount('general'), 5);
      expect(c.unreadCount('team'), 3);
      await c.markRead('m-3');
      expect(c.unreadCount('general'), 2);
      expect(c.readSequence('general'), 3);
      await c.markRead('m-2');
      await c.markRead('unknown');
      expect(c.readSequence('general'), 3);
      await c.disconnect();
      c.dispose();
      final reopened = await connected(SequencedSession(), positions);
      expect(reopened.unreadCount('general'), 2);
      await reopened.disconnect();
      reopened.dispose();
      final other = await connected(
        SequencedSession(identity: 'u_other'),
        positions,
      );
      expect(other.unreadCount('general'), 5);
      await other.disconnect();
      other.dispose();
      final restrictedSession = SequencedSession();
      final restricted = await connected(restrictedSession, positions);
      restrictedSession.change([
        chat('general', read: false)..latestMessageSequence = Int64(100),
      ]);
      await settle();
      expect(restricted.unreadCount('general'), 0);
      expect(restricted.messages, isEmpty);
      await restricted.disconnect();
      restricted.dispose();
    },
  );
  testWidgets('Скрытый чат и фоновое окно не помечают сообщения прочитанными', (
    tester,
  ) async {
    final c = await tester.runAsync(
      () => connected(SequencedSession(), MemoryPositions()),
    );
    Widget frame(bool active) => MaterialApp(
      home: Scaffold(
        body: ChatView(controller: c!, openConnection: () {}, active: active),
      ),
    );
    await tester.pumpWidget(frame(false));
    await tester.pumpAndSettle();
    expect(c!.readThrough, isEmpty);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pumpWidget(frame(true));
    await tester.pumpAndSettle();
    expect(c.readThrough, isEmpty);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(c.readThrough, isNotEmpty);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(c.disconnect);
    c.dispose();
  });
}
