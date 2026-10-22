import 'dart:async';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:space_client/src/attachments.dart';
import 'package:space_client/ui/attachment_widgets.dart';
import 'package:space_client/ui/message_composer_controls.dart';
import 'package:space_client/ui/emoji_picker.dart';

import 'attachments_test.dart' show FilesSession;

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart' hide View;
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/forum_api.dart';
import 'package:space_client/src/forum_controller.dart';
import 'package:space_client/src/generated/space/v1/forum.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/ui/forum.dart';
import 'package:space_client/ui/forum_composer.dart';

class FakeForum implements ForumApi, ForumMedia {
  final files = FilesSession();
  @override
  bool attachmentsEnabled = true;
  @override
  FilesSession get attachmentSession => files;
  List<String> lastAttachments = [];
  @override
  bool supported = true;
  @override
  List<Channel> sections = [
    Channel(
      id: 'forum',
      title: 'Обсуждения',
      views: [View(type: 'forum')],
      permissions: ChannelPermissions(
        visible: true,
        read: true,
        write: true,
        manage: true,
      ),
    ),
  ];
  Object? failure;
  Completer<void>? waiting;
  int calls = 0;
  int pageSize = 2;
  final topics = <ForumThread>[];
  final replies = <ForumReply>[];
  void check() {
    if (failure != null) throw failure!;
  }

  @override
  Future<void> refresh() async {
    await waiting?.future;
    check();
  }

  @override
  Future<ListForumThreadsResponse> threads(String channel, Int64 after) async {
    check();
    calls++;
    final page = topics
        .where((t) => t.sequence > after)
        .take(pageSize)
        .toList();
    return ListForumThreadsResponse(
      threads: page.map((t) => t.deepCopy()),
      nextSequence: topics.where((t) => t.sequence > after).length > pageSize
          ? page.last.sequence
          : Int64.ZERO,
    );
  }

  @override
  Future<GetForumThreadResponse> thread(
    String channel,
    String id,
    Int64 after,
  ) async {
    check();
    return GetForumThreadResponse(
      thread: topics.firstWhere((t) => t.id == id).deepCopy(),
      replies: replies
          .where((r) => r.threadId == id && r.sequence > after)
          .map((r) => r.deepCopy()),
    );
  }

  @override
  Future<ForumThread> create(
    String channel,
    String title,
    String text,
    String key, [
    List<String> attachments = const [],
  ]) async {
    check();
    lastAttachments = attachments;
    final topic = ForumThread(
      id: 'topic-${topics.length}',
      channelId: channel,
      title: title,
      text: text,
      authorId: 'author',
      revision: Int64.ONE,
      sequence: Int64(topics.length + 1),
    );
    topics.add(topic);
    return topic.deepCopy();
  }

  @override
  Future<ReplyForumThreadResponse> reply(
    String channel,
    String id,
    String text,
    String key, [
    List<String> attachments = const [],
  ]) async {
    check();
    lastAttachments = attachments;
    final topic = topics.firstWhere((t) => t.id == id);
    final reply = ForumReply(
      id: 'reply-${replies.length}',
      threadId: id,
      text: text,
      sequence: Int64(replies.length + 1),
    );
    if (attachments.isNotEmpty && files.asset != null) {
      reply.attachments.add(files.asset!.deepCopy());
    }
    replies.add(reply);
    topic.replyCount += Int64.ONE;
    topic.revision += Int64.ONE;
    return ReplyForumThreadResponse(
      reply: reply.deepCopy(),
      thread: topic.deepCopy(),
    );
  }

  @override
  Future<ForumThread> closeTopic(
    String channel,
    String id,
    Int64 revision,
  ) async {
    check();
    final topic = topics.firstWhere((t) => t.id == id);
    expect(revision, topic.revision);
    topic.closed = true;
    topic.revision += Int64.ONE;
    return topic.deepCopy();
  }
}

void main() {
  test('старый runtime не вызывает форумный RPC', () async {
    final api = FakeForum()..supported = false;
    final c = ForumController(api);
    addTearDown(c.close);
    await c.refresh();
    expect(c.state.supported, false);
    expect(api.calls, 0);
  });
  test('страницы, ответ и закрытие обновляют тему', () async {
    final api = FakeForum();
    for (var i = 0; i < 3; i++) {
      await api.create('forum', 'Тема $i', 'Текст', '$i');
    }
    final c = ForumController(api);
    addTearDown(c.close);
    await c.refresh();
    expect(c.state.threads.length, 2);
    expect(c.state.nextThreads, 2);
    await c.moreThreads();
    expect(c.state.threads.length, 3);
    expect(c.state.nextThreads, 0);
    await c.openTopic(api.topics.first.id);
    await c.reply('Ответ', 'reply');
    expect(c.state.replies.single.text, 'Ответ');
    await c.closeTopic();
    expect(c.state.topic!.closed, true);
    expect(c.state.threads.first.closed, true);
  });
  test('отзыв доступа очищает ранее загруженное обсуждение', () async {
    final api = FakeForum();
    await api.create('forum', 'Тайна', 'Текст', 'key');
    final c = ForumController(api);
    addTearDown(c.close);
    await c.refresh();
    await c.openTopic(api.topics.first.id);
    api.failure = const GrpcError.permissionDenied('Отозвано');
    expect(await c.refresh(), false);
    expect(c.state.topic, isNull);
    expect(c.state.threads, isEmpty);
    expect(c.state.sections, isEmpty);
  });
  test('завершение запроса после dispose не публикует состояние', () async {
    final api = FakeForum()..waiting = Completer<void>();
    final c = ForumController(api);
    final load = c.refresh();
    await c.close();
    api.waiting!.complete();
    await load;
    expect(c.isClosed, true);
  });
  testWidgets('неудачная отправка сохраняет черновик и ключ для повтора', (
    tester,
  ) async {
    final keys = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ForumComposer(
            submit: (_, text, key, attachments) async {
              keys.add(key);
              return keys.length > 1;
            },
          ),
        ),
      ),
    );
    await tester.enterText(
      find.byKey(const ValueKey('forum-text')),
      'Черновик',
    );
    await tester.tap(find.byKey(const ValueKey('forum-send')));
    await tester.pumpAndSettle();
    expect(find.text('Черновик'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('forum-send')));
    await tester.pumpAndSettle();
    expect(keys.length, 2);
    expect(keys[0], keys[1]);
    expect(find.text('Черновик'), findsNothing);
  });
  testWidgets('темы, ответы и закрытие в интерфейсе', (tester) async {
    tester.view.physicalSize = const Size(1200, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final api = FakeForum();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ForumArea(api: api)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Создать тему'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('forum-title')),
      'Первая тема',
    );
    await tester.enterText(
      find.byKey(const ValueKey('forum-text')),
      'Корень обсуждения',
    );
    await tester.tap(find.byKey(const ValueKey('forum-send')));
    await tester.pumpAndSettle();
    expect(find.text('Первая тема'), findsOneWidget);
    expect(find.text('Корень обсуждения'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('forum-text')),
      'Первый ответ',
    );
    await tester.tap(find.byKey(const ValueKey('forum-send')));
    await tester.pumpAndSettle();
    expect(find.text('Первый ответ'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('forum-actions')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Закрыть тему'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Закрыть тему'));
    await tester.pumpAndSettle();
    expect(find.text('Тема закрыта'), findsWidgets);
    expect(find.byKey(const ValueKey('forum-text')), findsNothing);
  });
  testWidgets('читатель не видит действий записи и модерации', (tester) async {
    final api = FakeForum();
    api.sections.single.permissions
      ..write = false
      ..manage = false;
    await api.create('forum', 'Тема', 'Текст', 'key');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ForumArea(api: api)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Создать тему'), findsNothing);
    await tester.tap(find.text('Тема'));
    await tester.pumpAndSettle();
    expect(find.text('Закрыть тему'), findsNothing);
    expect(find.byKey(const ValueKey('forum-text')), findsNothing);
  });
  testWidgets(
    'Форум использует поле чата, эмодзи и настоящую очередь вложений',
    (tester) async {
      final api = FakeForum();
      await api.create('forum', 'Файлы', 'Обсуждаем', 'key');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ForumArea(api: api)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Файлы'));
      await tester.pumpAndSettle();
      expect(find.byType(MessageDraftField), findsOneWidget);
      expect(find.byType(EmojiButton), findsOneWidget);
      final picker = tester.widget<AttachFileButton>(
        find.byType(AttachFileButton),
      );
      await picker.queue.add(
        AttachmentFilesAdded([
          XFile.fromData(
            Uint8List.fromList([1, 2, 3]),
            name: 'план.txt',
            path: 'план.txt',
          ),
        ]),
      );
      await tester.pumpAndSettle();
      expect(find.text('план.txt'), findsOneWidget);
      final send = find.byKey(const ValueKey('forum-send'));
      await tester.ensureVisible(send);
      await tester.tap(send);
      await tester.pumpAndSettle();
      expect(api.lastAttachments, ['asset']);
      expect(api.files.data, [1, 2, 3]);
      expect(api.replies.single.attachments.single.name, 'план.txt');
      expect(picker.queue.state.files, isEmpty);
    },
  );
}
