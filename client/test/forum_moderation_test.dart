import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/forum_api.dart';
import 'package:space_client/src/forum_controller.dart';
import 'package:space_client/src/generated/space/v1/forum.pb.dart';
import 'package:space_client/ui/forum.dart';
import 'package:space_client/ui/forum_moderation.dart';

import 'forum_navigation_test.dart' show NavigationForum;

class ModerationForum extends NavigationForum implements ForumModeration {
  @override
  bool moderationSupported = true;
  final events = <ForumModerationEvent>[];
  String lastReason = '';
  @override
  ForumThread view(ForumThread t) {
    final result = super.view(t);
    if (t.hidden) {
      result.title = '';
      result.text = '';
      result.authorName = '';
      result.authorId = '';
      result.attachments.clear();
    }
    return result;
  }

  @override
  Future<GetForumThreadResponse> thread(
    String channel,
    String id,
    Int64 after,
  ) async {
    final result = await super.thread(channel, id, after);
    for (final r in result.replies) {
      if (r.hidden || result.thread.hidden) {
        r.text = '';
        r.authorId = '';
        r.authorName = '';
        r.attachments.clear();
      }
    }
    return result;
  }

  void record(
    ForumThread t,
    String action,
    String reason,
    Int64 revision, [
    String reply = '',
  ]) {
    lastReason = reason;
    events.add(
      ForumModerationEvent(
        id: Int64(events.length + 1),
        threadId: t.id,
        replyId: reply,
        action: action,
        reason: reason,
        actorId: 'moderator',
        revision: revision,
        createdAtUnix: Int64(1792713600 + events.length * 60),
      ),
    );
  }

  @override
  Future<ForumThread> moderateTopic(
    String channel,
    String id,
    String action,
    String reason,
    Int64 revision,
  ) async {
    check();
    final topic = topics.firstWhere((t) => t.id == id);
    if (topic.revision != revision) throw const GrpcError.aborted();
    if (action == 'reopen') {
      topic.closed = false;
    } else {
      topic.hidden = action == 'hide';
    }
    topic.revision += Int64.ONE;
    record(topic, action, reason, topic.revision);
    return view(topic);
  }

  @override
  Future<ModerateForumReplyResponse> moderateReply(
    String channel,
    String thread,
    String id,
    bool hidden,
    String reason,
    Int64 revision,
  ) async {
    check();
    final reply = replies.firstWhere((r) => r.id == id);
    final topic = topics.firstWhere((t) => t.id == thread);
    if (reply.revision != revision) throw const GrpcError.aborted();
    reply.hidden = hidden;
    reply.revision += Int64.ONE;
    topic.revision += Int64.ONE;
    record(
      topic,
      hidden ? 'hide_reply' : 'restore_reply',
      reason,
      reply.revision,
      id,
    );
    final result = (await this.thread(
      channel,
      thread,
      reply.sequence - Int64.ONE,
    )).replies.first;
    return ModerateForumReplyResponse(reply: result, thread: view(topic));
  }

  @override
  Future<ListForumModerationResponse> moderationLog(
    String channel,
    String thread,
    Int64 after,
  ) async {
    check();
    return ListForumModerationResponse(
      events: events.where((e) => e.threadId == thread && e.id > after),
    );
  }
}

Future<ModerationForum> moderationExample() async {
  final api = ModerationForum()..pageSize = 50;
  final topic = await api.create(
    'forum',
    'Планы сообщества',
    'Предлагаем идеи для следующей встречи и обсуждаем их вместе.',
    'topic',
  );
  topic.authorName = 'Алиса';
  topic.createdAtUnix = Int64(1792710000);
  topic.closed = true;
  api.topics[0] = topic;
  await api.reply(
    'forum',
    topic.id,
    'Давайте соберём вопросы заранее.',
    'first',
  );
  await api.reply(
    'forum',
    topic.id,
    'Сообщение на проверке модератора.',
    'second',
  );
  for (final r in api.replies) {
    r.revision = Int64.ONE;
    r.authorName = 'Борис';
    r.createdAtUnix = Int64(1792710300);
  }
  return api;
}

Future<void> openModerationMenu(WidgetTester tester, String title) async {
  await tester.tap(find.byKey(const ValueKey('forum-actions')));
  await tester.pumpAndSettle();
  await tester.tap(find.text(title));
  await tester.pumpAndSettle();
}

Future<void> submitModeration(WidgetTester tester, String reason) async {
  await tester.enterText(
    find.byKey(const ValueKey('forum-moderation-reason')),
    reason,
  );
  await tester.tap(find.widgetWithText(FilledButton, 'Подтвердить'));
  await tester.pumpAndSettle();
}

void main() {
  test('синхронизация заменяет уже загруженные ответы после скрытия на другом устройстве', () async {
    final api = (await moderationExample())..pageSize = 1;
    final c = ForumController(api);
    addTearDown(c.close);
    await c.refresh();
    await c.openTopic(api.topics.first.id);
    await c.moreReplies();
    final reply = api.replies.first;
    await api.moderateReply(
      'forum',
      reply.threadId,
      reply.id,
      true,
      'Проверка',
      reply.revision,
    );
    await c.synchronize();
    expect(c.state.replies.first.hidden, true);
    expect(c.state.replies.first.text, isEmpty);
    expect(c.state.replies.length, 2);
    expect(
      await c.moderateReply(c.state.replies.first, 'Проверка завершена'),
      true,
    );
    expect(c.state.replies.first.text, isNotEmpty);
    expect(await c.moderateTopic('reopen', 'Продолжаем'), true);
    expect(c.state.topic!.closed, false);
  });
  testWidgets('повторное открытие, причина, скрытие, восстановление и журнал', (
    tester,
  ) async {
    final api = await moderationExample();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ForumArea(api: api)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Планы сообщества'));
    await tester.pumpAndSettle();
    await openModerationMenu(tester, 'Открыть тему снова');
    await tester.tap(find.widgetWithText(FilledButton, 'Подтвердить'));
    await tester.pumpAndSettle();
    expect(find.text('Укажите причину, не более 1024 байт'), findsOneWidget);
    await submitModeration(tester, 'Продолжаем обсуждение');
    expect(api.lastReason, 'Продолжаем обсуждение');
    expect(api.topics.first.closed, false);
    await openModerationMenu(tester, 'Скрыть тему');
    await submitModeration(tester, 'Проверяем публикацию');
    expect(find.text('Тема скрыта модератором'), findsWidgets);
    expect(find.textContaining('Предлагаем идеи'), findsNothing);
    await openModerationMenu(tester, 'Восстановить тему');
    await submitModeration(tester, 'Проверка завершена');
    expect(find.textContaining('Предлагаем идеи'), findsOneWidget);
    await openModerationMenu(tester, 'Журнал модерации');
    expect(find.text('Проверяем публикацию'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets(
    'отказ сервера сохраняет причину, старый runtime не показывает новые действия',
    (tester) async {
      final api = await moderationExample();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ForumArea(api: api)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Планы сообщества'));
      await tester.pumpAndSettle();
      await openModerationMenu(tester, 'Скрыть тему');
      api.failure = const GrpcError.permissionDenied();
      await submitModeration(tester, 'Сохраняем причину');
      expect(find.byType(ForumModerationDialog), findsOneWidget);
      expect(find.text('Сохраняем причину'), findsOneWidget);
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      api.failure = null;
      api.moderationSupported = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ForumArea(key: const ValueKey('legacy'), api: api),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Планы сообщества'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('forum-actions')));
      await tester.pumpAndSettle();
      expect(find.text('Скрыть тему'), findsNothing);
      expect(find.text('Открыть тему снова'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
