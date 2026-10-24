// Изолированная проверка ленты в Windows-приложении с настоящими RPC.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/feed_controller.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' as sp;
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/ui/feed.dart';
import 'package:space_client/ui/feed_management.dart';
import 'package:space_client/ui/forum_moderation.dart';
import 'package:space_client/ui/shell.dart';

import '../../tool/native_management_scenarios.dart' show ScenarioStorage;
import 'forum_acceptance_native_app.dart' show require;
import 'forum_moderation_native_app.dart' as native;
import 'feed_transport_native_app.dart' as transport;

Future<String> upload(SpaceSession session, String key) async {
  final data = utf8.encode('Файл публикации — $key');
  final started = await session.beginUpload(
    sp.BeginUploadRequest(
      channelId: 'feed',
      name: '$key.txt',
      byteSize: Int64(data.length),
      sha256: crypto.sha256.convert(data).bytes,
      idempotencyKey: key,
    ),
  );
  await session.uploadChunk(
    sp.UploadChunkRequest(assetId: started.asset.id, data: data),
  );
  await session.completeUpload(
    sp.CompleteUploadRequest(assetId: started.asset.id),
  );
  return started.asset.id;
}

Future<void> policy(SpaceSession owner, bool publish) async {
  final api = SessionFeedApi(owner);
  final previous = await api.access('feed');
  await api.saveAccess(
    UpdateFeedAccessRequest(
      channelId: 'feed',
      expectedRevision: previous.revision,
      rules: [
        FeedAccessRule(
          role: 'member',
          permissions: FeedPermissions(publish: publish, comment: true),
        ),
      ],
    ),
  );
}

Future<SpaceSession> moderator(SpaceSession owner) async {
  final session = await SpaceSession.connect(
    owner.server,
    KeyIdentityVault(ScenarioStorage()),
  );
  await session.authorizeAdministration();
  final previous = await owner.adminRequest('/api/v1/channels/feed/access');
  final rules = List<dynamic>.from(previous['rules'] as List? ?? []);
  rules.add({
    'principalId': session.principalId,
    'permissions': {
      'visible': true,
      'read': true,
      'write': true,
      'manage': true,
    },
  });
  await owner.adminRequest(
    '/api/v1/channels/feed/access',
    method: 'PUT',
    body: {'expectedRevision': previous['revision'], 'rules': rules},
  );
  require(session.role == 'member', 'Модератор не должен быть администратором');
  return session;
}

Future<void> capturePair(String name) async {
  await windowManager.setSize(const Size(1440, 1000));
  await Future<void>.delayed(const Duration(milliseconds: 400));
  await native.capture('$name-desktop');
  await windowManager.setSize(const Size(500, 1200));
  await Future<void>.delayed(const Duration(milliseconds: 400));
  await native.capture('$name-compact');
}

Future<void> resolveInWindow(SpaceSession session, BuildContext context) async {
  final dialog = showFeedManagement(
    context,
    SessionFeedApi(session),
    'feed',
    action: 'reports',
  );
  unawaited(dialog);
  await native.waitFor(
    () => native.stateOf(FeedManagementDialog)?.controller.state.busy == false,
  );
  final dynamic queue = native.stateOf(FeedManagementDialog);
  final report = queue.controller.state.reports.single as FeedReport;
  await capturePair('feed-reports');
  final decision = queue.decide(report, 'hide') as Future<void>;
  unawaited(decision);
  await native.waitFor(() => native.stateOf(ForumModerationDialog) != null);
  final dynamic reason = native.stateOf(ForumModerationDialog);
  reason.reason.text = 'Публикация скрыта по правилам пространства';
  await reason.save();
  await decision;
  require(
    queue.controller.state.reports.isEmpty == true,
    'Жалоба не рассмотрена',
  );
  if (context.mounted) Navigator.of(context).pop();
  await dialog;
}

class LostFeedResponse extends SessionFeedApi {
  LostFeedResponse(super.session);
  bool lose = true;
  final keys = <String>[], ids = <String>[];
  @override
  Future<CreateFeedPostResponse> publish(CreateFeedPostRequest request) async {
    keys.add(request.idempotencyKey);
    final response = await super.publish(request);
    ids.add(response.post.id);
    if (lose) {
      lose = false;
      throw const GrpcError.unavailable();
    }
    return response;
  }
}

Future<void> verifyReplay(SpaceSession owner, SpaceSession peer) async {
  await policy(owner, true);
  final api = LostFeedResponse(peer);
  final draft = FeedDraftCubit(
    api: api,
    channel: 'feed',
    post: '',
    sent: () async {},
  );
  try {
    draft.change('Повтор после потерянного ответа');
    require(!await draft.send(), 'Потеря ответа не воспроизведена');
    require(draft.state.text.isNotEmpty, 'Черновик потерян');
    require(await draft.send(), 'Повтор не прошёл');
    require(
      api.keys.first == api.keys.last && api.ids.first == api.ids.last,
      'Повтор создал дубль',
    );
  } finally {
    await draft.close();
  }
}

Future<void> verifyFiles(SpaceSession peer, List<String> ids) async {
  for (final id in ids) {
    try {
      await peer.downloadChunk(sp.DownloadChunkRequest(assetId: id));
      throw StateError('Скрытый файл доступен');
    } on GrpcError catch (error) {
      require(error.code == StatusCode.notFound, 'Неверный отказ файла');
    }
  }
  final files = await peer.listMyAssets(
    sp.ListMyAssetsRequest(channelId: 'feed'),
  );
  require(files.assets.isEmpty, 'Каталог выдал скрытые файлы');
}

Future<void> acceptFeed(SpaceSession owner, SpaceSession peer) async {
  require(owner.feedSupported && peer.feedSupported, 'Нет capability ленты');
  await owner.adminRequest(
    '/api/v1/channels',
    method: 'POST',
    body: {
      'channelId': 'feed',
      'title': 'Новости сообщества',
      'viewType': 'feed',
      'position': 3,
    },
  );
  await policy(owner, false);
  final mod = await moderator(owner);
  try {
    final peerApi = SessionFeedApi(peer);
    try {
      await peerApi.publish(
        CreateFeedPostRequest(
          channelId: 'feed',
          text: 'Запрещено',
          idempotencyKey: 'denied',
        ),
      );
      throw StateError('Комментатор опубликовал запись');
    } on GrpcError catch (error) {
      require(
        error.code == StatusCode.permissionDenied,
        'Неверный отказ публикации',
      );
    }
    final file = await upload(owner, 'announcement');
    final post = await SessionFeedApi(owner).publish(
      CreateFeedPostRequest(
        channelId: 'feed',
        text: 'В субботу встречаемся в голосовой комнате. Здесь будут новости сообщества и полезные материалы.',
        idempotencyKey: 'announcement',
        attachmentIds: [file],
      ),
    );
    final commentFile = await upload(peer, 'questions');
    await peerApi.comment(
      CommentFeedPostRequest(
        channelId: 'feed',
        postId: post.post.id,
        text: 'Подготовил вопросы к встрече.',
        idempotencyKey: 'questions',
        attachmentIds: [commentFile],
      ),
    );
    final dynamic shell = native.stateOf(SpaceShell);
    shell.select(Section.feed);
    await native.waitFor(
      () => native.stateOf(FeedArea)?.controller.state.loading == false,
    );
    final dynamic area = native.stateOf(FeedArea);
    final FeedController controller = area.controller;
    require(controller.state.posts.isNotEmpty, 'Лента не загружена');
    await capturePair('feed-posts');
    await controller.open(post.post.id);
    require(controller.state.comments.length == 1, 'Комментарий отсутствует');
    await capturePair('feed-discussion');
    require(
      await controller.moderate(
        comment: controller.state.comments.single,
        reason: 'Проверка отдельного скрытия',
      ),
      'Комментарий не скрыт',
    );
    await peerApi.report(
      ReportFeedContentRequest(
        channelId: 'feed',
        postId: post.post.id,
        reason: 'Проверка публикации',
      ),
    );
    await resolveInWindow(mod, area.context as BuildContext);
    await controller.refresh();
    require(
      controller.state.post!.hidden && controller.state.comments.isEmpty,
      'Скрытая запись осталась открытой',
    );
    await capturePair('feed-hidden');
    await verifyFiles(peer, [file, commentFile]);
    require(
      await controller.moderate(reason: 'Проверка завершена'),
      'Публикация не восстановлена',
    );
    require(
      controller.state.comments.single.hidden,
      'Восстановление сняло скрытие комментария',
    );
    await peer.downloadChunk(sp.DownloadChunkRequest(assetId: file));
    await verifyReplay(owner, peer);
    await transport.accept(owner, mod);
    await File('${native.output.path}/acceptance.json').writeAsString(
      jsonEncode({
        'success': true,
        'separateModerator': mod.principalId != owner.principalId,
        'splitPermissions': true,
        'hiddenFiles': true,
        'restorePreservesComment': true,
        'lostResponseReplay': true,
        'independentProcesses': true,
        'transportResponseLoss': true,
        'midDownloadHide': true,
        'independentRoleFlow': true,
        'android': 'deferred',
      }),
      flush: true,
    );
    debugPrint(
      'FEED_ACCEPTANCE_READY: права, файлы, модерация и повтор проверены',
    );
  } finally {
    await mod.close();
  }
}

Future<void> main() async {
  try {
    if (transport.isPeer) {
      await transport.runPeer();
    } else {
      await native.runNativeForum(acceptFeed);
    }
  } catch (error, stack) {
    stderr.writeln('$error\n$stack');
    exit(1);
  }
}
