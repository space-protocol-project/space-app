import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/forum_api.dart';
import 'package:space_client/src/forum_controller.dart';
import 'package:space_client/src/generated/space/v1/forum.pb.dart';
import 'package:space_client/ui/forum.dart';
import 'package:space_client/ui/forum_device_permission.dart';

import 'forum_test.dart' show FakeForum;

class NavigationForum extends FakeForum implements ForumNavigation {
  @override
  bool navigationSupported = true;
  Int64 lastAfter = Int64.ZERO;
  final readCalls = <Int64>[];
  ForumThread view(ForumThread t) => t.deepCopy()
    ..readStateSupported = true
    ..unreadCount =
        t.replyCount - t.readSequence + (t.seen ? Int64.ZERO : Int64.ONE);
  @override
  Future<ListForumThreadsResponse> navigationPage(
    String channel,
    Int64 after,
    bool afterPinned,
  ) async {
    check();
    final ordered = topics.toList()..sort(ForumController.compareTopics);
    final remaining = ordered
        .where(
          (t) =>
              after == Int64.ZERO ||
              (t.pinned == afterPinned && t.sequence > after) ||
              (afterPinned && !t.pinned),
        )
        .toList();
    final page = remaining.take(pageSize).toList();
    return ListForumThreadsResponse(
      threads: page.map(view),
      nextSequence: remaining.length > pageSize
          ? page.last.sequence
          : Int64.ZERO,
      nextPinned: remaining.length > pageSize && page.last.pinned,
    );
  }

  @override
  Future<GetForumThreadResponse> thread(
    String channel,
    String id,
    Int64 after,
  ) async {
    check();
    lastAfter = after;
    final remaining = replies
        .where((r) => r.threadId == id && r.sequence > after)
        .toList();
    final page = remaining.take(pageSize).toList();
    return GetForumThreadResponse(
      thread: view(topics.firstWhere((t) => t.id == id)),
      replies: page.map((r) => r.deepCopy()),
      nextSequence: remaining.length > pageSize
          ? page.last.sequence
          : Int64.ZERO,
    );
  }

  @override
  Future<ForumThread> pinTopic(
    String channel,
    String id,
    bool pinned,
    Int64 revision,
  ) async {
    check();
    final topic = topics.firstWhere((t) => t.id == id);
    if (topic.revision != revision) throw const GrpcError.aborted();
    topic.pinned = pinned;
    topic.revision += Int64.ONE;
    return view(topic);
  }

  @override
  Future<ForumThread> markRead(String channel, String id, Int64 through) async {
    check();
    final topic = topics.firstWhere((t) => t.id == id);
    if (through < Int64.ZERO || through > topic.replyCount) {
      throw const GrpcError.invalidArgument();
    }
    readCalls.add(through);
    topic.seen = true;
    if (through > topic.readSequence) topic.readSequence = through;
    return view(topic);
  }
}

void main() {
  test('закрепления идут первыми на нескольких страницах и обновляются после открепления', () async {
    final api = NavigationForum()..pageSize = 1;
    await api.create('forum', 'Обычная', 'Текст', 'one');
    await api.create('forum', 'Важная', 'Текст', 'two');
    api.topics.last.pinned = true;
    final c = ForumController(api);
    addTearDown(c.close);
    await c.refresh();
    expect(c.state.threads.single.title, 'Важная');
    await c.moreThreads();
    expect(c.state.threads.map((t) => t.title), ['Важная', 'Обычная']);
    await c.openTopic(api.topics.last.id);
    await c.pinTopic();
    expect(c.state.threads.first.title, 'Обычная');
    expect(c.state.topic!.pinned, false);
  });
  test('два устройства синхронизируют чтение, открытие страницы само не отмечает ответы', () async {
    final api = NavigationForum()..pageSize = 1;
    final t = await api.create('forum', 'Тема', 'Текст', 'one');
    await api.reply('forum', t.id, 'Первый', 'r1');
    await api.reply('forum', t.id, 'Второй', 'r2');
    final one = ForumController(api), two = ForumController(api);
    addTearDown(one.close);
    addTearDown(two.close);
    await one.refresh();
    await two.refresh();
    await one.openTopic(t.id);
    expect(api.readCalls, isEmpty);
    expect(one.state.replies.single.sequence, Int64.ONE);
    await one.markRead();
    expect(one.state.topic!.unreadCount, Int64.ONE);
    await two.synchronize();
    expect(two.state.threads.single.readSequence, Int64.ONE);
    await two.openTopic(t.id);
    expect(api.lastAfter, Int64.ONE);
    expect(two.state.replies.single.text, 'Второй');
    await two.markRead();
    await one.synchronize();
    expect(one.state.topic!.unreadCount, Int64.ZERO);
    expect(api.readCalls, [Int64.ONE, Int64(2)]);
    await two.fromBeginning();
    expect(api.lastAfter, Int64.ZERO);
    expect(two.state.replies.first.sequence, Int64.ONE);
    api.failure = const GrpcError.permissionDenied();
    await one.synchronize();
    expect(one.state.topic, isNull);
    expect(one.state.threads, isEmpty);
  });
  test('ошибка отметки сохраняет непрочитанное; старый runtime не вызывает новые методы', () async {
    final api = NavigationForum();
    await api.create('forum', 'Тема', 'Текст', 'one');
    final c = ForumController(api);
    addTearDown(c.close);
    await c.refresh();
    await c.openTopic(api.topics.first.id);
    api.failure = const GrpcError.unavailable();
    expect(await c.markRead(), false);
    expect(c.state.topic!.unreadCount, Int64.ONE);
    api.failure = null;
    api.navigationSupported = false;
    await c.synchronize();
    expect(api.readCalls, isEmpty);
    expect(c.navigation, isNull);
  });
  test(
    'синхронизация добавляет новые ответы, не подтверждая их загрузкой',
    () async {
      final api = NavigationForum();
      final t = await api.create('forum', 'Тема', 'Текст', 'one');
      final c = ForumController(api);
      addTearDown(c.close);
      await c.refresh();
      await c.openTopic(t.id);
      await c.markRead();
      await api.reply('forum', t.id, 'Новый ответ', 'new');
      await c.synchronize();
      expect(c.state.replies.single.text, 'Новый ответ');
      expect(c.state.topic!.unreadCount, Int64.ONE);
      expect(api.readCalls, [Int64.ZERO]);
    },
  );
  testWidgets(
    'авточтение подтверждает видимую тему, но не весь загруженный список',
    (tester) async {
      final api = NavigationForum()..pageSize = 50;
      final topic = await api.create('forum', 'Важная тема', 'Текст', 'one');
      api.topics.first.pinned = true;
      for (var i = 0; i < 12; i++) {
        await api.reply(
          'forum',
          topic.id,
          'Ответ $i: ${'Длинное сообщение. ' * 12}',
          'r$i',
        );
      }
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ForumArea(api: api)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Закреплено'), findsOneWidget);
      expect(find.text('Непрочитано: 13'), findsOneWidget);
      expect(api.readCalls, isEmpty);
      await tester.tap(find.text('Важная тема'));
      await tester.pumpAndSettle();
      expect(api.readCalls, isNotEmpty);
      expect(api.readCalls.last < Int64(12), true);
      await tester.ensureVisible(find.textContaining('Ответ 11:'));
      await tester.pumpAndSettle();
      expect(api.readCalls.last, Int64(12));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets('неактивная вкладка не подтверждает чтение', (tester) async {
    final api = NavigationForum();
    await api.create('forum', 'Тема', 'Текст', 'one');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ForumArea(api: api, active: false)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Тема'));
    await tester.pumpAndSettle();
    expect(api.readCalls, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets(
    'выдача разрешения требует подтверждения и предлагает пароль корневой карточки',
    (tester) async {
      final password = TextEditingController();
      bool? confirmed;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: const Text('Модерация'),
                onPressed: () async {
                  confirmed = await showDialog<bool>(
                    context: context,
                    builder: (_) => ForumDevicePermissionDialog(
                      password: password,
                      requiresCard: true,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Модерация'));
      await tester.pumpAndSettle();
      expect(confirmed, isNull);
      expect(find.text('Пароль корневой карточки'), findsOneWidget);
      expect(find.textContaining('не выдаёт роль'), findsOneWidget);
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(confirmed, false);
      await tester.pumpWidget(const SizedBox.shrink());
      password.dispose();
    },
  );
}
