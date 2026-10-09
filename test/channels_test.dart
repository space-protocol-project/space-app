import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart' hide View;
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/channel_positions.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/ui/chat_view.dart';

class ChannelVault implements IdentityVault {
  @override
  Future<DeviceRecord?> load(String origin) async => null;
  @override
  Future<void> save(DeviceRecord record) async {}
}

class MemoryPositions implements ChannelPositionStore {
  final data = <String, Map<String, dynamic>>{};
  @override
  Future<Map<String, dynamic>> load(String scope) async => data[scope] ?? {};
  @override
  Future<void> save(String scope, Map<String, dynamic> value) async {
    data[scope] = jsonDecode(jsonEncode(value));
  }
}

Channel chat(String id, {bool archived = false, bool read = true}) => Channel(
  id: id,
  title: 'Чат $id',
  views: [View(id: 'chat', type: 'chat')],
  archived: archived,
  permissions: ChannelPermissions(
    visible: true,
    read: read,
    write: read && !archived,
  ),
);

class ChannelSession
    implements LiveSession, ChannelNavigation, SpaceAccess, SpacePresentation {
  @override
  List<Channel> availableChannels = [
    chat('general'),
    chat('team'),
    chat('archive', archived: true),
    chat('visible', read: false),
  ];
  @override
  String selectedChannelId = 'general';
  @override
  String get positionScope => 'scope-$principalId';
  @override
  String get principalId => 'u_test';
  @override
  String get spaceTitle => 'Тестовое пространство';
  @override
  String get chatTitle =>
      availableChannels
          .where((c) => c.id == selectedChannelId)
          .firstOrNull
          ?.title ??
      'Недоступен';
  Channel? get selected =>
      availableChannels.where((c) => c.id == selectedChannelId).firstOrNull;
  @override
  bool get canRead => selected?.permissions.read ?? false;
  @override
  bool get canWrite => selected?.permissions.write ?? false;
  final streams = <String, List<StreamController<SubscribeResponse>>>{};
  final cursors = <(String, String)>[];
  final requestKeys = <String>[];
  bool failSend = false;
  @override
  void selectChannel(String id) {
    if (!availableChannels.any((c) => c.id == id)) {
      throw const FormatException('Канал недоступен');
    }
    selectedChannelId = id;
  }

  @override
  Future<void> refreshChannels() async {}
  @override
  Future<void> login() async {}
  @override
  Future<List<Content>> messages() async => canRead
      ? [
          Content(
            id: 'message-1',
            channelId: selectedChannelId,
            text: 'История $selectedChannelId',
          ),
        ]
      : [];
  @override
  Future<Content> send(String text, String key) async {
    requestKeys.add(key);
    if (failSend) throw const GrpcError.unavailable();
    return Content(id: 'sent', channelId: selectedChannelId, text: text);
  }

  @override
  Stream<SubscribeResponse> subscribe(String after) {
    final id = selectedChannelId;
    cursors.add((id, after));
    final stream = StreamController<SubscribeResponse>();
    streams.putIfAbsent(id, () => []).add(stream);
    return stream.stream;
  }

  @override
  Future<void> revoke() async {}
  @override
  Future<void> close() async {
    for (final group in streams.values) {
      for (final stream in group) {
        unawaited(stream.close());
      }
    }
  }

  void event(String id, String cursor, String message) {
    streams[id]!.last.add(
      SubscribeResponse(
        cursor: cursor,
        event: Event(
          cursor: cursor,
          type: 'content.created',
          content: Content(id: message, channelId: id, text: 'Событие $id'),
        ),
      ),
    );
  }
}

class CatalogSession extends ChannelSession implements ChannelUpdates {
  final catalog = StreamController<void>.broadcast();
  int watchStarts = 0;
  @override
  Stream<void> watchChannelChanges() {
    watchStarts++;
    return catalog.stream;
  }

  void change(List<Channel> channels) {
    availableChannels = channels;
    catalog.add(null);
  }

  @override
  Future<void> close() async {
    await catalog.close();
    await super.close();
  }
}

Future<void> settle() async =>
    Future<void>.delayed(const Duration(milliseconds: 20));
Future<ChatController> connected(
  ChannelSession session,
  MemoryPositions positions,
) async {
  final c = ChatController(
    ChannelVault(),
    openSession: (_, _) async => session,
    positions: positions,
  );
  c.preview = Discovery(
    localOrigin('http://127.0.0.1:8080'),
    'srv_test',
    List.filled(32, 1),
    9090,
  );
  await c.connect();
  await settle();
  return c;
}

void main() {
  test(
    'Каталог переподключается после сбоя и отменяет retry при отключении',
    () async {
      final session = CatalogSession();
      final controller = ChatController(
        ChannelVault(),
        openSession: (_, _) async => session,
        positions: MemoryPositions(),
        retryDelay: (_) => const Duration(milliseconds: 5),
      );
      controller.preview = Discovery(
        localOrigin('http://127.0.0.1:8080'),
        'srv_test',
        List.filled(32, 1),
        9090,
      );
      await controller.connect();
      await settle();
      session.catalog.addError(const GrpcError.unavailable('Сбой сети'));
      await settle();
      await settle();
      expect(session.watchStarts, greaterThanOrEqualTo(2));
      expect(controller.connected, isTrue);
      session.change([chat('general')..title = 'После reconnect']);
      await settle();
      expect(controller.chatTitle, 'После reconnect');
      await controller.disconnect();
      final starts = session.watchStarts;
      await settle();
      expect(session.watchStarts, starts);
      expect(session.catalog.hasListener, isFalse);
      controller.dispose();
    },
  );

  test(
    'Каталог обновляется без читаемого чата и переживает отзыв/возврат прав',
    () async {
      final session = CatalogSession()
        ..availableChannels = []
        ..selectedChannelId = '';
      final controller = await connected(session, MemoryPositions());
      var notifications = 0;
      controller.addListener(() => notifications++);
      session.change([chat('general')]);
      session.selectedChannelId = 'general';
      await settle();
      await settle();
      expect(controller.canRead, isTrue);
      expect(controller.messages, isNotEmpty);
      final renamed = chat('general')..title = 'Новое название';
      session.change([renamed, chat('new')]);
      await settle();
      expect(controller.chatTitle, 'Новое название');
      expect(controller.navigation!.availableChannels.length, 2);
      session.change([chat('general', read: false), chat('new')]);
      await settle();
      expect(controller.canRead, isFalse);
      expect(controller.messages, isEmpty);
      expect(session.catalog.hasListener, isTrue);
      session.change([chat('general'), chat('new')]);
      await settle();
      await settle();
      expect(controller.messages, isNotEmpty);
      expect(controller.canWrite, isTrue);
      expect(notifications, greaterThan(3));
      await controller.disconnect();
      expect(session.catalog.hasListener, isFalse);
      controller.dispose();
    },
  );

  test('Переключение изолирует одинаковые id, отменяет старый поток и сохраняет позиции', () async {
    final positions = MemoryPositions();
    final session = ChannelSession();
    final c = await connected(session, positions);
    session.event('general', 'event-1', 'message-2');
    await settle();
    c.markRead('message-2');
    await c.selectChannel('team');
    await settle();
    expect(c.messages.single.text, 'История team');
    expect(c.cursor, '');
    session.event('general', 'event-2', 'old');
    await settle();
    expect(c.messages.any((m) => m.id == 'old'), false);
    session.event('team', 'event-3', 'team-2');
    await settle();
    c.markRead('team-2');
    await c.selectChannel('general');
    await settle();
    expect(c.cursor, 'event-1');
    expect(c.readThrough, 'message-2');
    await c.disconnect();
    c.dispose();
    final again = await connected(ChannelSession(), positions);
    expect(again.channelId, 'general');
    expect(again.cursor, 'event-1');
    expect(again.readThrough, 'message-2');
    await again.selectChannel('team');
    expect(again.cursor, 'event-3');
    expect(again.readThrough, 'team-2');
    await again.disconnect();
    again.dispose();
  });
  test('Отзыв чтения очищает историю, сохраняет подключение и позволяет выбрать другой чат', () async {
    final session = ChannelSession();
    final c = await connected(session, MemoryPositions());
    session.availableChannels[0].permissions.read = false;
    session.availableChannels[0].permissions.write = false;
    session.streams['general']!.last.addError(
      const GrpcError.permissionDenied(),
    );
    await settle();
    expect(c.connected, true);
    expect(c.messages, isEmpty);
    expect(c.canWrite, false);
    await c.selectChannel('team');
    expect(c.messages.single.channelId, 'team');
    await c.selectChannel('archive');
    expect(c.canRead, true);
    expect(c.canWrite, false);
    await c.selectChannel('visible');
    expect(c.messages, isEmpty);
    expect(c.canRead, false);
    await c.disconnect();
    c.dispose();
  });
  test('Повтор запроса ограничен каналом; отклонённый курсор очищается перед следующим входом', () async {
    final session = ChannelSession()..failSend = true;
    final positions = MemoryPositions();
    final c = await connected(session, positions);
    await c.send('Повтор');
    await c.send('Повтор');
    expect(session.requestKeys[0], session.requestKeys[1]);
    await c.selectChannel('team');
    await c.send('Повтор');
    expect(session.requestKeys[2], isNot(session.requestKeys[0]));
    session.streams['team']!.last.addError(const GrpcError.invalidArgument());
    await settle();
    expect(c.connected, false);
    expect(
      (positions.data[session.positionScope]!['channels']
          as Map)['team']['cursor'],
      '',
    );
    await c.disconnect();
    c.dispose();
  });
  test('Локальные позиции разделены по серверу и пользователю и переживают повторное чтение', () async {
    SharedPreferences.setMockInitialValues({});
    final store = LocalChannelPositions();
    await store.save('server-a|user-a', {
      'selected': 'selected',
      'channels': {
        'selected': {'cursor': 'event-4', 'readThrough': 'message-3'},
      },
    });
    expect(await store.load('server-a|user-b'), isEmpty);
    expect(
      (await LocalChannelPositions().load('server-a|user-a'))['selected'],
      'selected',
    );
  });
  testWidgets(
    'Узкий чат: выбор канала, отдельные черновики, архив и отсутствие переполнения',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final session = ChannelSession();
      late ChatController c;
      await tester.runAsync(() async {
        c = await connected(session, MemoryPositions());
      });
      final theme = AppPreferences();
      await tester.pumpWidget(
        MaterialApp(
          theme: theme.theme,
          home: Scaffold(
            body: ListenableBuilder(
              listenable: c,
              builder: (_, _) => ChatView(controller: c, openConnection: () {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('chat-draft')),
        'Черновик general',
      );
      await tester.runAsync(() => c.selectChannel('team'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
            .controller!
            .text,
        isEmpty,
      );
      await tester.enterText(
        find.byKey(const ValueKey('chat-draft')),
        'Черновик team',
      );
      await tester.runAsync(() => c.selectChannel('general'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
            .controller!
            .text,
        'Черновик general',
      );
      await tester.runAsync(() => c.selectChannel('archive'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
            .enabled,
        false,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(c.disconnect);
      c.dispose();
      theme.dispose();
    },
  );
}
