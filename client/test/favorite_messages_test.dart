import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_history.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/favorite_messages.dart';
import 'package:space_client/ui/message_bubble.dart';
import 'package:space_client/ui/chat_view.dart';

import 'channels_test.dart'
    show ChannelSession, ChannelVault, MemoryHistory, MemoryPositions, chat;

void main() {
  testWidgets('Избранное открывается долгим нажатием и доступно с клавиатуры', (
    tester,
  ) async {
    var removed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FavoriteMessages(
            messages: [
              Content(
                id: 'keyboard',
                authorId: 'Мария',
                text: 'Карточка с клавиатуры',
              ),
            ],
            principalId: 'я',
            onJump: (_) {},
            onRemove: (_) => removed = true,
          ),
        ),
      ),
    );
    final marker = find
        .descendant(
          of: find.byType(FavoriteMessages),
          matching: find.byType(InkWell),
        )
        .first;
    await tester.longPress(marker);
    await tester.pumpAndSettle();
    expect(find.text('Карточка с клавиатуры'), findsNWidgets(2));
    for (var count = 0; count < 12; count++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      if (Focus.of(tester.element(find.byIcon(Icons.bookmark)))
          .hasPrimaryFocus) {
        break;
      }
    }
    expect(
      Focus.of(tester.element(find.byIcon(Icons.bookmark))).hasPrimaryFocus,
      true,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Карточка с клавиатуры'), findsNothing);
    await tester.longPress(marker);
    await tester.pumpAndSettle();
    for (var count = 0; count < 12; count++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      if (Focus.of(tester.element(find.byIcon(Icons.bookmark)))
          .hasPrimaryFocus) {
        break;
      }
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(removed, true);
    expect(tester.takeException(), isNull);
  });

  for (final width in [390.0, 1100.0]) {
    testWidgets('Закладка появляется слева по центру чата на ширине $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = ChatController(
        ChannelVault(),
        openSession: (_, _) async => ChannelSession(),
        historyStore: MemoryHistory(),
        positions: MemoryPositions(),
      );
      controller.preview = Discovery(
        Uri.parse('http://127.0.0.1:8080'),
        'srv_test',
        List.filled(32, 1),
      );
      await controller.connect();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocBuilder<ChatController, ChatState>(
              bloc: controller,
              builder: (_, _) =>
                  ChatView(controller: controller, openConnection: () {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();
      expect(find.byType(FavoriteMessages), findsOneWidget);
      expect(controller.isFavorite(controller.messages.single), isTrue);
      final rail = tester.getRect(find.byType(FavoriteMessages));
      final marker = find.descendant(
        of: find.byType(FavoriteMessages),
        matching: find.byType(InkWell),
      );
      expect(tester.getCenter(marker).dy, closeTo(rail.center.dy, 1));
      expect(tester.getCenter(marker).dx, lessThan(40));
      await tester.tap(marker);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();
      expect(find.byType(FavoriteMessages), findsNothing);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    });
  }
  test('Избранное сохраняется после истечения обычной истории', () {
    final now = DateTime.now();
    final history = ChatHistory(serverId: 's', principalId: 'u', grantId: 'g')
      ..channels = [chat('general')];
    history.merge([
      Content(id: '1', channelId: 'general'),
      Content(id: '2', channelId: 'general'),
    ], now);
    history.favorites.add('general/1');
    final later = now.add(const Duration(days: 15));
    final restored = ChatHistory.fromJson(history.toJson(), later);
    expect(restored.messages('general', later).single.id, '1');
    expect(restored.favorites, {'general/1'});
    restored.favorites.clear();
    restored.prune(later);
    expect(restored.entries, isEmpty);
  });
  test('Избранное сохраняется, разделяется по каналам и удаляется', () async {
    final store = MemoryHistory();
    final controller = ChatController(
      ChannelVault(),
      openSession: (_, _) async => ChannelSession(),
      historyStore: store,
      positions: MemoryPositions(),
    );
    controller.preview = Discovery(
      Uri.parse('http://127.0.0.1:8080'),
      'srv_test',
      List.filled(32, 1),
    );
    await controller.connect();
    final message = controller.messages.single;
    await controller.toggleFavorite(message);
    expect(controller.isFavorite(message), isTrue);
    final saved = store.data.values.single;
    final restored = ChatHistory.fromJson(saved.toJson(), DateTime.now());
    expect(restored.favorites, {'general/message-1'});
    final legacy = saved.toJson()..remove('favorites');
    expect(ChatHistory.fromJson(legacy, DateTime.now()).favorites, isEmpty);
    await controller.selectChannel('team');
    expect(controller.isFavorite(controller.messages.single), isFalse);
    await controller.selectChannel('general');
    expect(controller.isFavorite(controller.messages.single), isTrue);
    await controller.toggleFavorite(controller.messages.single);
    expect(controller.isFavorite(message), isFalse);
    await controller.toggleFavorite(controller.messages.single);
    await controller.clearOfflineData();
    expect(controller.isFavorite(message), isFalse);
    controller.dispose();
  });

  test('Отметки исчезают при потере доступа к каналу', () {
    final history = ChatHistory(serverId: 's', principalId: 'u', grantId: 'g')
      ..channels = [chat('general')];
    history.merge([Content(id: '1', channelId: 'general')], DateTime.now());
    history.favorites.add('general/1');
    history.channels = [chat('general', read: false)];
    history.merge([], DateTime.now());
    expect(history.favorites, isEmpty);
  });

  testWidgets('Наведение показывает карточку, переход и удаление работают', (
    tester,
  ) async {
    final message = Content(
      id: '1',
      authorId: 'Мария',
      text: 'Важное сообщение',
    );
    var jumped = false, removed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FavoriteMessages(
            messages: [message],
            principalId: 'я',
            onJump: (_) => jumped = true,
            onRemove: (_) => removed = true,
          ),
        ),
      ),
    );
    final marker = find.byType(InkWell).first;
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(700, 100));
    await mouse.moveTo(tester.getCenter(marker));
    await tester.pumpAndSettle();
    expect(find.text('Важное сообщение'), findsNWidgets(2));
    await tester.tap(find.text('Важное сообщение').first);
    expect(jumped, isTrue);
    await mouse.moveTo(const Offset(700, 100));
    await tester.pumpAndSettle();
    await mouse.moveTo(tester.getCenter(marker));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.bookmark));
    expect(removed, isTrue);
    await mouse.moveTo(const Offset(700, 100));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('Важное сообщение'), findsNothing);
    await mouse.removePointer();
  });

  testWidgets(
    'Карточка переключается между маркерами и переживает обновление списка',
    (tester) async {
      final semantics = tester.ensureSemantics();
      var messages = [
        Content(id: '1', text: 'Первое'),
        Content(id: '2', text: 'Второе'),
      ];
      late StateSetter change;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                change = setState;
                return FavoriteMessages(
                  messages: messages,
                  principalId: 'я',
                  onJump: (_) {},
                  onRemove: (message) => change(
                    () => messages = messages
                        .where((m) => m.id != message.id)
                        .toList(),
                  ),
                );
              },
            ),
          ),
        ),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: const Offset(700, 100));
      for (var i = 0; i < 10; i++) {
        final markers = find.descendant(
          of: find.byType(FavoriteMessages),
          matching: find.byType(InkWell),
        );
        await mouse.moveTo(tester.getCenter(markers.at(i % 2)));
        await tester.pumpAndSettle();
        expect(find.text(i.isEven ? 'Первое' : 'Второе'), findsNWidgets(2));
        expect(find.text(i.isEven ? 'Второе' : 'Первое'), findsNothing);
        expect(tester.takeException(), isNull);
      }
      change(
        () => messages = [
          Content(id: '2', text: 'Второе обновлено'),
          Content(id: '1', text: 'Первое'),
        ],
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await mouse.moveTo(const Offset(700, 100));
      await tester.pumpAndSettle();
      final first = find
          .descendant(
            of: find.byType(FavoriteMessages),
            matching: find.byType(InkWell),
          )
          .first;
      await mouse.moveTo(tester.getCenter(first));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();
      expect(messages.length, 1);
      expect(tester.takeException(), isNull);
      change(() => messages = []);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await mouse.removePointer();
      semantics.dispose();
    },
  );

  test('Цвета своих и чужих сообщений различаются во всех палитрах', () {
    final preferences = AppPreferences();
    for (final dark in [true, false]) {
      for (final palette in ['ocean', 'iris', 'amber']) {
        preferences.dark = dark;
        preferences.palette = palette;
        final colors = preferences.theme.colorScheme;
        expect(
          messageBubbleColor(colors, true),
          isNot(messageBubbleColor(colors, false)),
        );
        expect(
          messageMarkerColor(colors, true),
          isNot(messageMarkerColor(colors, false)),
        );
      }
    }
  });
}
