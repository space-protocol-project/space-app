// Снимки всей оболочки: настоящий сервер, PostgreSQL и два участника.
import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/forum_controller.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' as sp;
import 'package:space_client/ui/forum.dart';
import 'package:space_client/ui/forum_moderation.dart';
import 'package:space_client/ui/forum_reports.dart';
import 'package:space_client/ui/shell.dart';

import 'forum_moderation_native_app.dart' as native;

Future<void> capturePair(String name) async {
  await windowManager.setSize(const Size(1440, 1000));
  await Future<void>.delayed(const Duration(milliseconds: 600));
  await native.capture('$name-desktop');
  await windowManager.setSize(const Size(500, 1200));
  await Future<void>.delayed(const Duration(milliseconds: 600));
  await native.capture('$name-compact');
}

Future<void> screenshotReports(SpaceSession owner, SpaceSession peer) async {
  final dynamic shell = native.stateOf(SpaceShell);
  shell.select(Section.forum);
  await native.waitFor(() => native.stateOf(ForumArea) != null);
  final ForumController forum = native.stateOf(ForumArea).controller;
  await forum.refresh();
  final plans = forum.state.threads.firstWhere(
    (t) => t.title == 'Планы сообщества',
  );
  final help = forum.state.threads.firstWhere(
    (t) => t.title == 'Вопросы по настройке Space',
  );
  await capturePair('forum-topics');
  await forum.openTopic(plans.id);
  final answer = forum.state.replies.last;
  final asset = answer.attachments.single.id;
  final api = SessionForumApi(owner);
  final areaContext = (native.stateOf(ForumArea) as State).context;
  final navigator = Navigator.of(areaContext);
  unawaited(
    showDialog<void>(
      context: areaContext,
      builder: (_) => ForumModerationDialog(
        title: 'Пожаловаться',
        notice:
            'Опишите нарушение. Данные заявителя не показываются модераторам.',
        submit: (reason) async {
          await api.reportContent('forum', plans.id, '', reason);
          return true;
        },
      ),
    ),
  );
  await native.waitFor(() => native.stateOf(ForumModerationDialog) != null);
  final dynamic reportDialog = native.stateOf(ForumModerationDialog);
  reportDialog.reason.text =
      'Проверьте, пожалуйста, соответствует ли тема правилам раздела.';
  await capturePair('forum-report-form');
  await reportDialog.save();
  await SessionForumApi(peer).reportContent(
    'forum',
    plans.id,
    answer.id,
    'В приложенном файле указаны персональные данные. Прошу скрыть ответ на время проверки.',
  );
  await api.reportContent(
    'forum',
    help.id,
    '',
    'Тема размещена не в том разделе.',
  );
  if (!areaContext.mounted) throw StateError('Окно закрыто');
  unawaited(
    showDialog<void>(
      context: areaContext,
      builder: (_) => ForumReportsQueue(
        api: api,
        forum: api,
        channel: 'forum',
        open: (id) async {
          await forum.openTopic(id);
        },
      ),
    ),
  );
  await native.waitFor(
    () =>
        native.stateOf(ForumReportsQueue) != null &&
        native.stateOf(ForumReportsQueue).busy == false,
  );
  await capturePair('forum-report-queue');
  final dynamic queue = native.stateOf(ForumReportsQueue);
  final report = queue.items.firstWhere((dynamic r) => r.replyId == answer.id);
  unawaited(queue.decide(report, 'hide') as Future<void>);
  await native.waitFor(() => native.stateOf(ForumModerationDialog) != null);
  final dynamic decision = native.stateOf(ForumModerationDialog);
  decision.reason.text = 'Вложение содержит персональные данные. Ответ скрыт до исправления автором.';
  await capturePair('forum-report-decision');
  await decision.save();
  await native.waitFor(
    () => native.stateOf(ForumModerationDialog) == null && queue.busy == false,
  );
  final pending = await api.reports('forum', Int64.ZERO, false);
  final topicReport = pending.reports.firstWhere((r) => r.threadId == plans.id);
  await api.resolveReport(
    'forum',
    topicReport.id,
    'dismiss',
    'Тема соответствует правилам; нарушение было только в ответе.',
    Int64.ZERO,
  );
  queue.resolved = true;
  await queue.load(reset: true);
  await capturePair('forum-report-history');
  if (navigator.mounted) navigator.pop();
  await forum.synchronize();
  await capturePair('forum-reported-reply-hidden');
  try {
    await owner.downloadChunk(sp.DownloadChunkRequest(assetId: asset));
    throw StateError('Скрытое вложение доступно');
  } on GrpcError catch (error) {
    if (error.code != StatusCode.notFound) rethrow;
  }
  if (!areaContext.mounted) throw StateError('Окно закрыто');
  unawaited(
    showDialog<void>(
      context: areaContext,
      builder: (_) => ForumModerationLog(
        load: (after) => api.moderationLog('forum', plans.id, after),
      ),
    ),
  );
  await native.waitFor(
    () =>
        native.stateOf(ForumModerationLog) != null &&
        native.stateOf(ForumModerationLog).busy == false,
  );
  await capturePair('forum-report-audit');
  if (navigator.mounted) navigator.pop();
  await native.captureNavigation();
  debugPrint(
    'FORUM_REPORTS_READY: 15 снимков полной оболочки; решения, аудит и защита файла проверены реальными RPC',
  );
}

Future<void> main() => native.runNativeForum(screenshotReports);
