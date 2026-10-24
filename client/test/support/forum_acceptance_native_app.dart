// Инструментальная приёмка Windows: реальные RPC, три личности и открытые формы.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/ui/forum.dart';
import 'package:space_client/ui/forum_composer.dart';
import 'package:space_client/ui/forum_moderation.dart';
import 'package:space_client/ui/forum_reports.dart';
import 'package:space_client/ui/shell.dart';

import '../../tool/native_management_scenarios.dart' show ScenarioStorage;
import 'forum_moderation_native_app.dart' as native;

void require(bool value, String message) {
  if (!value) throw StateError(message);
}

Future<void> setModerator(
  SpaceSession owner,
  SpaceSession moderator,
  bool manage,
) async {
  final previous = await owner.adminRequest('/api/v1/channels/forum/access');
  final rules = List<Map<String, dynamic>>.from(
    (previous['rules'] as List? ?? []).map(
      (r) => Map<String, dynamic>.from(r as Map),
    ),
  )..removeWhere((r) => r['principalId'] == moderator.principalId);
  rules.add({
    'principalId': moderator.principalId,
    'permissions': {
      'visible': true,
      'read': true,
      'write': true,
      'manage': manage,
    },
  });
  await owner.adminRequest(
    '/api/v1/channels/forum/access',
    method: 'PUT',
    body: {'expectedRevision': previous['revision'], 'rules': rules},
  );
}

BuildContext get forumContext => (native.stateOf(ForumArea) as State).context;

Future<void> openDecision(SessionForumApi api, Int64 report) async {
  unawaited(
    showDialog<void>(
      context: forumContext,
      builder: (_) => ForumModerationDialog(
        title: 'Решение после отзыва прав',
        submit: (reason) async {
          await api.resolveReport(
            'forum',
            report,
            'dismiss',
            reason,
            Int64.ZERO,
          );
          return true;
        },
      ),
    ),
  );
  await native.waitFor(() => native.stateOf(ForumModerationDialog) != null);
}

Future<void> verifyDecisionRevocation(
  SpaceSession owner,
  SpaceSession moderator,
  Int64 report,
) async {
  final api = SessionForumApi(moderator);
  await openDecision(api, report);
  final dynamic dialog = native.stateOf(ForumModerationDialog);
  const reason = 'Причина сохраняется после отказа сервера';
  dialog.reason.text = reason;
  await setModerator(owner, moderator, false);
  await dialog.save();
  require(native.stateOf(ForumModerationDialog) != null, 'Диалог закрылся');
  require(dialog.failed == true, 'Нет сообщения об отказе');
  require(dialog.reason.text == reason, 'Причина потеряна');
  final pending = await SessionForumApi(owner)
      .reports('forum', Int64.ZERO, false);
  require(pending.reports.any((r) => r.id == report), 'Отказ изменил жалобу');
  await native.capture('decision-permission-revoked');
  if (forumContext.mounted) Navigator.of(forumContext).pop();
}

Future<void> verifyQueueRevocation(
  SpaceSession owner,
  SpaceSession moderator,
) async {
  await setModerator(owner, moderator, true);
  final api = SessionForumApi(moderator);
  unawaited(
    showDialog<void>(
      context: forumContext,
      builder: (_) => ForumReportsQueue(
        api: api,
        forum: api,
        channel: 'forum',
        open: (_) async {},
      ),
    ),
  );
  await native.waitFor(() => native.stateOf(ForumReportsQueue)?.busy == false);
  final dynamic queue = native.stateOf(ForumReportsQueue);
  require(queue.items.isNotEmpty == true, 'Очередь не загружена');
  await setModerator(owner, moderator, false);
  await queue.load(reset: true);
  require(queue.failed == true, 'Очередь не показала отказ');
  require(queue.items.isEmpty == true, 'Недоступная очередь осталась в памяти');
  await native.capture('queue-permission-revoked');
  if (forumContext.mounted) Navigator.of(forumContext).pop();
}

Future<void> verifyLostResponse(SpaceSession peer) async {
  final api = SessionForumApi(peer);
  final ids = <String>[], keys = <String>[];
  unawaited(
    showDialog<void>(
      context: forumContext,
      builder: (_) => AlertDialog(
        title: const Text('Повтор после потерянного ответа'),
        content: SizedBox(
          width: 480,
          child: ForumComposer(
            newTopic: true,
            submit: (title, text, key, files) async {
              keys.add(key);
              final topic = await api.create('forum', title, text, key, files);
              ids.add(topic.id);
              // Потеря ответа после настоящего commit, до подтверждения формы.
              if (ids.length == 1) throw const GrpcError.unavailable();
              return true;
            },
          ),
        ),
      ),
    ),
  );
  await native.waitFor(() => native.stateOf(ForumComposer) != null);
  final dynamic composer = native.stateOf(ForumComposer);
  composer.title.text = 'Проверка потерянного ответа';
  composer.text.text = 'Запись принимается один раз';
  await composer.send();
  require(composer.failed == true, 'Первая отправка не показала отказ');
  require(composer.text.text.isNotEmpty == true, 'Черновик потерян');
  await native.capture('lost-response-draft');
  await composer.send();
  require(ids.length == 2 && ids.first == ids.last, 'Создан дубль темы');
  require(keys.first == keys.last, 'Ключ повтора изменился');
  require(composer.text.text.isEmpty == true, 'Подтверждённый текст не очищен');
  final topics = await api.threads('forum', Int64.ZERO);
  require(
    topics.threads.where((t) => t.id == ids.first).length == 1,
    'Повтор продублировал список тем',
  );
  if (forumContext.mounted) Navigator.of(forumContext).pop();
}

Future<void> acceptForum(SpaceSession owner, SpaceSession peer) async {
  final dynamic shell = native.stateOf(SpaceShell);
  shell.select(Section.forum);
  await native.waitFor(() => native.stateOf(ForumArea) != null);
  final moderator = await SpaceSession.connect(
    owner.server,
    KeyIdentityVault(ScenarioStorage()),
  );
  try {
    require(
      moderator.role == 'member',
      'Модератор должен оставаться участником',
    );
    await moderator.authorizeAdministration();
    await setModerator(owner, moderator, true);
    final topic = (await SessionForumApi(
      owner,
    ).threads('forum', Int64.ZERO)).threads.first;
    await SessionForumApi(peer)
        .reportContent('forum', topic.id, '', 'Проверка отзыва прав');
    final pending = await SessionForumApi(moderator)
        .reports('forum', Int64.ZERO, false);
    await verifyDecisionRevocation(owner, moderator, pending.reports.single.id);
    await verifyQueueRevocation(owner, moderator);
    await verifyLostResponse(peer);
    await File('${native.output.path}/acceptance.json').writeAsString(
      jsonEncode({
        'success': true,
        'principals': 3,
        'separateModerator': moderator.principalId != owner.principalId,
        'dialogRevocation': true,
        'queueRevocation': true,
        'lostResponseReplay': true,
        'android': 'deferred',
      }),
      flush: true,
    );
    debugPrint(
      'FORUM_ACCEPTANCE_READY: отзыв прав и повтор без дубля проверены',
    );
  } finally {
    await moderator.close();
  }
}

Future<void> main() => native.runNativeForum(acceptForum);
