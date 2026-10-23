// Изолированный инструментальный запуск полного Windows-приложения.
// Только loopback, новая схема PostgreSQL и ключи в памяти; реальные RPC и виджеты.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart' as crypto;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/forum_controller.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' as sp;
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/queued_file_store.dart';
import 'package:space_client/ui/forum.dart';
import 'package:space_client/ui/forum_moderation.dart';
import 'package:space_client/ui/shell.dart';

import '../channels_test.dart' show MemoryHistory, MemoryPositions;
import 'chat_outbox.dart' show MemoryChatOutbox;
import '../../tool/native_management_scenarios.dart' show ScenarioStorage;

final boundary = GlobalKey();
late Directory output;

dynamic stateOf(Type type) {
  final root = boundary.currentContext;
  if (root == null) return null;
  dynamic found;
  void visit(Element element) {
    if (element.widget.runtimeType == type && element is StatefulElement) {
      found = element.state;
    }
    element.visitChildren(visit);
  }

  (root as Element).visitChildren(visit);
  return found;
}

Future<void> waitFor(bool Function() condition) async {
  final timer = Stopwatch()..start();
  while (!condition()) {
    if (timer.elapsed > const Duration(seconds: 30)) {
      throw StateError('Интерфейс не готов за 30 секунд');
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  await Future<void>.delayed(const Duration(milliseconds: 300));
}

Future<void> capture(String name) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await Future<void>.delayed(const Duration(milliseconds: 400));
  await WidgetsBinding.instance.endOfFrame;
  final context = boundary.currentContext!;
  if (!context.mounted) return;
  final render = context.findRenderObject()! as RenderRepaintBoundary;
  final image = await render.toImage(
    pixelRatio: View.of(context).devicePixelRatio,
  );
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  await File('${output.path}/$name.png')
      .writeAsBytes(bytes!.buffer.asUint8List(), flush: true);
  debugPrint('FORUM_NATIVE_CAPTURE $name ${image.width}x${image.height}');
  image.dispose();
}

Future<void> seedSpace(SpaceSession owner, SpaceSession peer) async {
  await owner.setNickname('Алиса');
  await peer.setNickname('Борис');
  final response = await owner.adminRequest('/api/v1/space/settings');
  final settings = Map<String, dynamic>.from(response['settings'] as Map);
  await owner.adminRequest(
    '/api/v1/space/settings',
    method: 'PATCH',
    body: {
      ...settings,
      'title': 'Клуб Space',
      'expectedRevision': settings['revision'],
      'registrationPolicy': 'open',
      'attachmentsEnabled': true,
    }..remove('revision'),
  );
  await owner.adminRequest(
    '/api/v1/channels',
    method: 'POST',
    body: {
      'channelId': 'forum',
      'title': 'Обсуждения сообщества',
      'viewType': 'forum',
      'position': 2,
    },
  );
  await owner.refreshChannels();
  await peer.refreshChannels();
  final api = SessionForumApi(owner);
  await api.create(
    'forum',
    'Правила сообщества',
    'Уважайте собеседников и оставайтесь в рамках темы.',
    'rules',
  );
  final rules = (await api.threads('forum', Int64.ZERO)).threads.first;
  await api.pinTopic('forum', rules.id, true, rules.revision);
  await api.create(
    'forum',
    'Планы сообщества',
    'Предлагаем идеи для следующей встречи и обсуждаем их вместе.',
    'plans',
  );
  final topic = (await api.threads('forum', Int64.ZERO)).threads.last;
  await SessionForumApi(peer)
      .reply('forum', topic.id, 'Давайте соберём вопросы заранее.', 'first');
  final data = utf8.encode(
    'Тестовый файл форума. Скрывается вместе с ответом.',
  );
  final upload = await peer.beginUpload(
    sp.BeginUploadRequest(
      channelId: 'forum',
      name: 'план-встречи.txt',
      byteSize: Int64(data.length),
      sha256: crypto.sha256.convert(data).bytes,
      idempotencyKey: 'attachment',
    ),
  );
  await peer.uploadChunk(
    sp.UploadChunkRequest(assetId: upload.asset.id, data: data),
  );
  await peer.completeUpload(sp.CompleteUploadRequest(assetId: upload.asset.id));
  await SessionForumApi(peer).reply(
    'forum',
    topic.id,
    'Предлагаю обсудить эти пункты.',
    'second',
    [upload.asset.id],
  );
  await api.create(
    'forum',
    'Вопросы по настройке Space',
    'Делимся опытом и помогаем новичкам.',
    'help',
  );
  await api.create(
    'forum',
    'Знакомимся с участниками',
    'Расскажите о себе и своих интересах.',
    'welcome',
  );
}

Future<void> reasonDialog(ForumController forum, String size) async {
  final context = boundary.currentContext!;
  // Контекст MaterialApp нужен для Navigator и локализации.
  final areaContext = (stateOf(ForumArea) as State).context;
  unawaited(
    showDialog<void>(
      context: areaContext,
      barrierDismissible: false,
      builder: (_) => ForumModerationDialog(
        title: 'Скрыть тему',
        submit: (reason) => forum.moderateTopic('hide', reason),
      ),
    ),
  );
  await waitFor(() => stateOf(ForumModerationDialog) != null);
  final dynamic dialog = stateOf(ForumModerationDialog);
  dialog.reason.text = 'Проверяем соответствие правилам сообщества.';
  if (!context.mounted) throw StateError('Окно закрыто');
  await capture('forum-moderation-reason-$size');
  await dialog.save();
  await waitFor(() => stateOf(ForumModerationDialog) == null);
}

Future<void> captureSize(
  SpaceSession owner,
  String size,
  Size dimensions,
) async {
  await windowManager.setSize(dimensions);
  await Future<void>.delayed(const Duration(milliseconds: 600));
  final dynamic shell = stateOf(SpaceShell);
  shell.select(Section.forum);
  await waitFor(() => stateOf(ForumArea) != null);
  final ForumController forum = stateOf(ForumArea).controller;
  await forum.refresh();
  final topic = forum.state.threads.firstWhere(
    (t) => t.title == 'Планы сообщества',
  );
  await forum.openTopic(topic.id);
  for (final reply in forum.state.replies.where((r) => r.hidden).toList()) {
    if (!await forum.moderateReply(reply, 'Сценарий следующего размера окна')) {
      throw StateError('Ответ не восстановлен');
    }
  }
  if (!forum.state.topic!.closed) await forum.closeTopic();
  forum.back();
  await capture('forum-topics-$size');
  await forum.openTopic(topic.id);
  if (!await forum.moderateTopic(
    'reopen',
    'Встреча перенесена: продолжаем обсуждение.',
  )) {
    throw StateError('Не удалось открыть тему');
  }
  await capture('forum-reopened-$size');
  final reply = forum.state.replies.last;
  final asset = reply.attachments.single.id;
  if (!await forum.moderateReply(
    reply,
    'В ответе опубликованы персональные данные.',
  )) {
    throw StateError('Ответ не скрыт');
  }
  try {
    await owner.downloadChunk(sp.DownloadChunkRequest(assetId: asset));
    throw StateError('Скрытый файл доступен');
  } on GrpcError catch (e) {
    if (e.code != StatusCode.notFound) rethrow;
  }
  await capture('forum-hidden-reply-$size');
  await reasonDialog(forum, size);
  await capture('forum-hidden-topic-$size');
  if (!await forum.moderateTopic(
    'restore',
    'Проверка завершена, тема восстановлена.',
  )) {
    throw StateError('Тема не восстановлена');
  }
  final areaContext = (stateOf(ForumArea) as State).context;
  if (!areaContext.mounted) return;
  final navigator = Navigator.of(areaContext);
  unawaited(
    showDialog<void>(
      context: areaContext,
      builder: (_) => ForumModerationLog(
        load: (after) =>
            SessionForumApi(owner).moderationLog('forum', topic.id, after),
      ),
    ),
  );
  await waitFor(() => stateOf(ForumModerationLog) != null);
  await Future<void>.delayed(const Duration(milliseconds: 500));
  await capture('forum-moderation-log-$size');
  if (navigator.mounted) navigator.pop();
}

Future<void> runNativeForum(
  Future<void> Function(SpaceSession owner, SpaceSession peer) screenshots,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  final origin = const String.fromEnvironment('SPACE_FORUM_NATIVE_ORIGIN');
  final expected = const String.fromEnvironment('SPACE_FORUM_NATIVE_SERVER_ID');
  final uri = Uri.parse(origin);
  if (!Platform.isWindows ||
      uri.scheme != 'http' ||
      InternetAddress.tryParse(uri.host)?.isLoopback != true ||
      expected.isEmpty) {
    throw StateError('Нужен отдельный loopback-сервер');
  }
  output = Directory(const String.fromEnvironment('SPACE_FORUM_NATIVE_OUTPUT'));
  await output.create(recursive: true);
  SharedPreferences.setMockInitialValues({
    'space.ui.dark': true,
    'space.ui.language': 'ru',
    'space.ui.origins': [origin],
  });
  final discovery = await discover(origin);
  if (discovery.serverId != expected) {
    throw StateError('Неверная тестовая база');
  }
  final keys = ScenarioStorage();
  final vault = KeyIdentityVault(keys);
  final owner = await SpaceSession.connect(discovery, vault);
  if (owner.role != 'owner') throw StateError('Нужна новая тестовая схема');
  final peer = await SpaceSession.connect(
    discovery,
    KeyIdentityVault(ScenarioStorage()),
  );
  await seedSpace(owner, peer);
  final chat = ChatController(
    vault,
    openSession: (_, _) async => owner,
    positions: MemoryPositions(),
    historyStore: MemoryHistory(),
    outboxStore: MemoryChatOutbox(),
    fileStore: QueuedFileStore(
      storage: keys,
      directory: () async => Directory('${output.path}/temporary'),
    ),
  );
  await chat.inspect(origin);
  await chat.connect();
  if (!chat.connected) throw StateError(chat.error);
  await windowManager.ensureInitialized();
  await windowManager.setMinimumSize(const Size(390, 640));
  runApp(
    RepaintBoundary(
      key: boundary,
      child: SpaceApp(controller: chat),
    ),
  );
  await windowManager.waitUntilReadyToShow(
    const WindowOptions(size: Size(1440, 1000), center: true),
  );
  await windowManager.show();
  await waitFor(() => stateOf(SpaceShell) != null);
  await screenshots(owner, peer);
  await peer.close();
}

Future<void> captureOverview(String size) async {
  final dynamic shell = stateOf(SpaceShell);
  shell.select(Section.overview);
  await capture('space-overview-$size');
}

Future<void> captureNavigation() async {
  final dynamic shell = stateOf(SpaceShell);
  shell.openNavigation();
  await capture('forum-navigation-compact');
  shell.closeNavigation();
}

Future<void> recaptureCompact() async {
  final ForumController forum = stateOf(ForumArea).controller;
  final owner = (forum.api as SessionForumApi).session;
  await captureSize(owner, 'compact', const Size(500, 1200));
  await captureNavigation();
  debugPrint('FORUM_NATIVE_COMPACT_READY');
}

Future<void> main() => runNativeForum((owner, peer) async {
  await captureSize(owner, 'desktop', const Size(1440, 1000));
  await captureOverview('desktop');
  await captureSize(owner, 'compact', const Size(500, 1200));
  await captureOverview('compact');
  final dynamic shell = stateOf(SpaceShell);
  shell.openForumSection('forum');
  await waitFor(() => stateOf(ForumArea) != null);
  await captureNavigation();
  debugPrint(
    'FORUM_NATIVE_READY: 15 снимков полного приложения; скрытый файл проверен реальным RPC',
  );
});
