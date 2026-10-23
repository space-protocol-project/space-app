import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/forum_api.dart';
import 'package:space_client/src/generated/space/v1/forum.pb.dart';
import 'package:space_client/ui/forum.dart';
import 'package:space_client/ui/forum_reports.dart';
import 'package:space_client/ui/forum_moderation.dart';

import 'forum_moderation_test.dart'
    show ModerationForum, openModerationMenu, submitModeration;

class ReportsForum extends ModerationForum implements ForumReports {
  @override
  bool reportsSupported = true;
  final complaints = <ForumReport>[];
  final requested = <Int64>[];
  int reportsPageSize = 1;
  @override
  Future<void> reportContent(
    String channel,
    String thread,
    String reply,
    String reason,
  ) async {
    check();
    complaints.add(
      ForumReport(
        id: Int64(complaints.length + 1),
        threadId: thread,
        replyId: reply,
        reason: reason,
        threadTitle: topics.first.title,
      ),
    );
  }

  @override
  Future<ListForumReportsResponse> reports(
    String channel,
    Int64 after,
    bool resolved,
  ) async {
    check();
    final remaining = complaints
        .where((r) => r.id > after && r.decision.isNotEmpty == resolved)
        .toList();
    final page = remaining.take(reportsPageSize).toList();
    return ListForumReportsResponse(
      reports: page.map((r) => r.deepCopy()),
      nextId: remaining.length > reportsPageSize ? page.last.id : Int64.ZERO,
    );
  }

  @override
  Future<void> resolveReport(
    String channel,
    Int64 id,
    String decision,
    String reason,
    Int64 revision,
  ) async {
    check();
    requested.add(revision);
    final report = complaints.firstWhere((r) => r.id == id);
    report.decision = decision;
    report.decisionReason = reason;
    report.moderatorId = 'moderator';
  }
}

Future<ReportsForum> reportsExample({bool manage = true}) async {
  final api = ReportsForum();
  api.sections.first.permissions.manage = manage;
  final topic = await api.create(
    'forum',
    'Планы сообщества',
    'Обсуждаем встречу',
    'topic',
  );
  await api.reply('forum', topic.id, 'Предложение участника', 'reply');
  api.replies.first.revision = Int64(3);
  return api;
}

Future<void> showForum(WidgetTester tester, ReportsForum api) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: ForumArea(api: api)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('очередь и причина решения помещаются на экране 360 px', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final api = await reportsExample();
    await api.reportContent(
      'forum',
      api.topics.first.id,
      '',
      'Длинная причина жалобы для проверки узкого экрана и переноса текста.',
    );
    await showForum(tester, api);
    await openModerationMenu(tester, 'Очередь жалоб');
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Скрыть содержимое'));
    await tester.tap(find.text('Скрыть содержимое'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await submitModeration(tester, 'Проверка узкого экрана');
    expect(api.complaints.single.decision, 'hide');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('участник жалуется на тему и ответ, очередь ему недоступна', (
    tester,
  ) async {
    final api = await reportsExample(manage: false);
    await showForum(tester, api);
    await tester.tap(find.text('Планы сообщества'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('forum-actions')));
    await tester.pumpAndSettle();
    expect(find.text('Очередь жалоб'), findsNothing);
    await tester.tap(find.text('Пожаловаться'));
    await tester.pumpAndSettle();
    await submitModeration(tester, 'Нарушение правил в теме');
    expect(api.complaints.single.replyId, isEmpty);
    await tester.ensureVisible(
      find.byKey(ValueKey('forum-reply-actions-${api.replies.first.id}')),
    );
    await tester.tap(
      find.byKey(ValueKey('forum-reply-actions-${api.replies.first.id}')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Скрыть ответ'), findsNothing);
    await tester.tap(find.text('Пожаловаться'));
    await tester.pumpAndSettle();
    await submitModeration(tester, 'Нарушение в ответе');
    expect(api.complaints.last.replyId, api.replies.first.id);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('очередь: страницы, причина решения, история и отказ сервера', (
    tester,
  ) async {
    final api = await reportsExample();
    for (final reason in ['Первая жалоба', 'Вторая жалоба']) {
      await api.reportContent('forum', api.topics.first.id, '', reason);
    }
    await showForum(tester, api);
    await openModerationMenu(tester, 'Очередь жалоб');
    expect(find.text('Первая жалоба'), findsOneWidget);
    expect(find.text('Вторая жалоба'), findsNothing);
    await tester.tap(find.text('Загрузить ещё'));
    await tester.pumpAndSettle();
    expect(find.text('Вторая жалоба'), findsOneWidget);
    await tester.tap(find.text('Отклонить жалобу').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Подтвердить'));
    await tester.pumpAndSettle();
    expect(find.text('Укажите причину, не более 1024 байт'), findsOneWidget);
    api.failure = const GrpcError.permissionDenied();
    await submitModeration(tester, 'Проверка: нарушения нет');
    expect(find.byType(ForumModerationDialog), findsOneWidget);
    expect(find.text('Проверка: нарушения нет'), findsOneWidget);
    api.failure = null;
    await tester.tap(find.widgetWithText(FilledButton, 'Подтвердить'));
    await tester.pumpAndSettle();
    expect(api.complaints.first.decision, 'dismiss');
    expect(api.requested.single, Int64.ZERO);
    await tester.tap(find.text('Решения'));
    await tester.pumpAndSettle();
    expect(find.text('Проверка: нарушения нет'), findsOneWidget);
    api.failure = const GrpcError.permissionDenied();
    await tester.tap(find.text('Обновить').last);
    await tester.pumpAndSettle();
    expect(find.text('Проверка: нарушения нет'), findsNothing);
    expect(find.byType(ForumReportsQueue), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'решение по ответу использует его ревизию, старый сервер скрывает действия',
    (tester) async {
      final api = await reportsExample();
      await api.reportContent(
        'forum',
        api.topics.first.id,
        api.replies.first.id,
        'Проверить ответ',
      );
      await showForum(tester, api);
      await openModerationMenu(tester, 'Очередь жалоб');
      await tester.tap(find.text('Скрыть содержимое'));
      await tester.pumpAndSettle();
      await submitModeration(tester, 'Нарушение подтверждено');
      expect(api.requested.single, Int64(3));
      await tester.pumpWidget(const SizedBox.shrink());
      api.reportsSupported = false;
      await showForum(tester, api);
      await tester.tap(find.text('Планы сообщества'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('forum-actions')));
      await tester.pumpAndSettle();
      expect(find.text('Пожаловаться'), findsNothing);
      expect(find.text('Очередь жалоб'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
