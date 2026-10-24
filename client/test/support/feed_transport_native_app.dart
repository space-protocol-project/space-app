// Два процесса, настоящий обрыв HTTP после commit и отзыв между чанками.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/attachments.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/feed_controller.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' as sp;
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/queued_file_store.dart';
import 'package:space_client/ui/feed.dart';
import 'package:space_client/ui/shell.dart';

import '../../tool/native_management_scenarios.dart' show ScenarioStorage;
import '../channels_test.dart' show MemoryHistory, MemoryPositions;
import 'chat_outbox.dart' show MemoryChatOutbox;
import 'forum_acceptance_native_app.dart' show require;
import 'forum_moderation_native_app.dart' as native;

bool get isPeer => Platform.environment['SPACE_FEED_PEER'] == '1';
const replayText = 'Публикация после разрыва HTTP-соединения';
late Directory work;
File marker(String name) => File('${work.path}/$name.json');

Future<void> signal(
  String name, [
  Map<String, dynamic> value = const {},
]) async {
  final temporary = File('${marker(name).path}.tmp');
  await temporary.writeAsString(jsonEncode(value), flush: true);
  await temporary.rename(marker(name).path);
}

Future<Map<String, dynamic>> wait(String name) async {
  await native.waitFor(() {
    if (marker('failure').existsSync()) {
      throw StateError(marker('failure').readAsStringSync());
    }
    return marker(name).existsSync();
  });
  return jsonDecode(await marker(name).readAsString()) as Map<String, dynamic>;
}

class ResponseCutProxy {
  ResponseCutProxy(this.origin);
  final Uri origin;
  final client = HttpClient()..autoUncompress = false;
  late HttpServer server;
  bool cutNextPublish = true;
  int droppedResponses = 0;
  final errors = <Object>[];

  Future<void> start() async {
    require(InternetAddress(origin.host).isLoopback, 'Нужен loopback');
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) => unawaited(forward(request)));
  }

  Future<void> forward(HttpRequest request) async {
    try {
      final upstream = await client.openUrl(
        request.method,
        origin.resolve(request.uri.toString()),
      );
      request.headers.forEach((key, values) {
        if (key != HttpHeaders.hostHeader) upstream.headers.set(key, values);
      });
      upstream.headers.set(HttpHeaders.acceptEncodingHeader, 'identity');
      await upstream.addStream(request);
      final response = await upstream.close();
      final bytes = await response.fold<List<int>>(
        [],
        (all, part) => all..addAll(part),
      );
      if (cutNextPublish && request.uri.path.endsWith('/CreateFeedPost')) {
        require(response.statusCode == 200, 'Сервер не подтвердил commit');
        cutNextPublish = false;
        droppedResponses++;
        final socket = await request.response.detachSocket(writeHeaders: false);
        socket.destroy();
        return;
      }
      request.response.statusCode = response.statusCode;
      response.headers.forEach((key, values) {
        if (key != HttpHeaders.transferEncodingHeader) {
          request.response.headers.set(key, values);
        }
      });
      request.response.add(bytes);
      await request.response.close();
    } catch (error) {
      errors.add(error);
      request.response.statusCode = 502;
      await request.response.close();
    }
  }

  Future<void> close() async {
    await server.close(force: true);
    client.close(force: true);
  }
}

Future<void> accept(SpaceSession owner, SpaceSession moderator) async {
  work = Directory('${native.output.path}/transport');
  await work.create(recursive: true);
  final proxy = ResponseCutProxy(owner.server.connectOrigin);
  await proxy.start();
  // Mutex Windows привязан к пути exe: отдельное имя даёт независимое окно.
  final executable = await File(Platform.resolvedExecutable).copy(
    '${File(Platform.resolvedExecutable).parent.path}/space_feed_peer_$pid.exe',
  );
  Process? peer;
  try {
    peer = await Process.start(
      executable.path,
      [],
      environment: {
        'SPACE_FEED_PEER': '1',
        'SPACE_FEED_WORK': work.path,
        'SPACE_FEED_PROXY': 'http://127.0.0.1:${proxy.server.port}',
      },
    );
    final out = peer.stdout.pipe(File('${work.path}/peer.out').openWrite());
    final err = peer.stderr.pipe(File('${work.path}/peer.err').openWrite());
    final identity = await wait('ready');
    require(
      identity['pid'] != pid && identity['principal'] != owner.principalId,
      'Клиент не независим',
    );
    require(
      identity['role'] == 'member' &&
          moderator.role == 'member' &&
          moderator.principalId != owner.principalId &&
          moderator.principalId != identity['principal'],
      'Публикация и модерация должны выполняться обычными участниками',
    );
    await signal('start');
    await wait('lost');
    final posts = await SessionFeedApi(owner).posts('feed', Int64.ZERO);
    final committed = posts.posts.where((p) => p.text == replayText).toList();
    require(committed.length == 1, 'Не подтверждён единственный commit');
    final post = committed.single;
    require(
      post.authorId == identity['principal'] && post.attachments.length == 1,
      'Участник не опубликовал файл',
    );
    require(proxy.droppedResponses == 1, 'HTTP-ответ не оборван');
    await signal('retry', {'id': committed.single.id});
    await wait('published');
    final dynamic ownerArea = native.stateOf(FeedArea);
    await ownerArea.controller.open(post.id);
    final FeedDraftCubit comment = ownerArea.controller.draft();
    comment.change('Комментарий из другого окна');
    require(await comment.send(), 'Второй участник не отправил комментарий');
    await signal('commented');
    await wait('partial');
    require(
      ownerArea.controller.state.comments.length == 1,
      'Первое окно не получило комментарий',
    );
    final hidden = await SessionFeedApi(moderator).moderatePost(
      ModerateFeedPostRequest(
        channelId: 'feed',
        postId: post.id,
        expectedRevision: ownerArea.controller.state.post.revision as Int64,
        hidden: true,
        reason: 'Отзыв во время скачивания',
      ),
    );
    await ownerArea.controller.refresh();
    require(
      ownerArea.controller.state.post.hidden &&
          ownerArea.controller.state.comments.isEmpty,
      'Первое окно не скрыло содержимое',
    );
    await signal('hidden');
    await wait('denied');
    await SessionFeedApi(moderator).moderatePost(
      ModerateFeedPostRequest(
        channelId: 'feed',
        postId: post.id,
        expectedRevision: hidden.post.revision,
        hidden: false,
        reason: 'Проверка полного скачивания',
      ),
    );
    await signal('restored');
    final result = await wait('result');
    require(
      result['success'] == true && proxy.errors.isEmpty,
      'Проверка второго процесса не завершена',
    );
    require(
      await peer.exitCode.timeout(const Duration(seconds: 15)) == 0,
      'Второй процесс завершился с ошибкой',
    );
    await Future.wait([out, err]);
    await signal('acceptance', {
      ...result,
      'ownerPid': pid,
      'peerPid': identity['pid'],
      'droppedResponses': proxy.droppedResponses,
      'memberPublishesFile': true,
      'separateModerator':
          moderator.principalId != post.authorId &&
          moderator.principalId != owner.principalId,
    });
  } finally {
    peer?.kill();
    if (peer != null) await peer.exitCode;
    await proxy.close();
    await executable.delete();
  }
}

Future<void> showPeer(SpaceSession session, ScenarioStorage keys) async {
  final vault = KeyIdentityVault(keys);
  final chat = ChatController(
    vault,
    openSession: (_, _) async => session,
    positions: MemoryPositions(),
    historyStore: MemoryHistory(),
    outboxStore: MemoryChatOutbox(),
    fileStore: QueuedFileStore(
      storage: keys,
      directory: () async => Directory('${work.path}/temporary'),
    ),
  );
  await chat.inspect(session.server.origin.toString());
  await chat.connect();
  require(chat.connected, 'Второе окно не подключилось');
  await windowManager.ensureInitialized();
  runApp(
    RepaintBoundary(
      key: native.boundary,
      child: SpaceApp(controller: chat),
    ),
  );
  await windowManager.waitUntilReadyToShow(
    const WindowOptions(size: Size(1280, 900), center: true),
  );
  await windowManager.setTitle('Space — независимый участник');
  await windowManager.show();
  await native.waitFor(() => native.stateOf(SpaceShell) != null);
  final dynamic shell = native.stateOf(SpaceShell);
  shell.select(Section.feed);
  await native.waitFor(
    () => native.stateOf(FeedArea)?.controller.state.loading == false,
  );
}

Future<void> peerReplay(SpaceSession session) async {
  final api = SessionFeedApi(session);
  final draft = FeedDraftCubit(
    api: api,
    channel: 'feed',
    post: '',
    sent: () async {},
  );
  try {
    final bytes = Uint8List.fromList(
      List.generate(2 * 1024 * 1024, (i) => i % 251),
    );
    final source = await File('${work.path}/large-test.bin')
        .writeAsBytes(bytes, flush: true);
    await draft.queue.add(AttachmentFilesAdded([XFile(source.path)]));
    draft.change(replayText);
    require(!await draft.send(), 'Разрыв HTTP не дошёл до черновика');
    require(
      draft.state.text == replayText && draft.state.key.isNotEmpty,
      'Черновик потерян после разрыва',
    );
    require(
      draft.queue.state.files.single.asset != null,
      'Файл не загрузился: ${draft.queue.state.error}',
    );
    final asset = draft.queue.state.files.single.asset!;
    await signal('lost');
    final previous = await wait('retry');
    require(await draft.send(), 'Повтор после восстановления не прошёл');
    final posts = await api.posts('feed', Int64.ZERO);
    final matches = posts.posts.where((p) => p.text == replayText).toList();
    require(
      matches.length == 1 &&
          matches.single.id == previous['id'] &&
          matches.single.attachments.single.id == asset.id,
      'Повтор создал дубль',
    );
    final dynamic area = native.stateOf(FeedArea);
    await area.controller.refresh();
    await native.capture('peer-network-restored');
    await signal('file', {
      'asset': asset.id,
      'post': previous['id'],
      'size': bytes.length,
      'sha256': sha256.convert(bytes).toString(),
    });
    await signal('published');
  } finally {
    await draft.close();
  }
}

Future<void> peerDownload(SpaceSession session) async {
  final file = await wait('file');
  await wait('commented');
  final dynamic area = native.stateOf(FeedArea);
  await area.controller.open(file['post'] as String);
  require(
    area.controller.state.comments.length == 1,
    'Второе окно не получило комментарий',
  );
  final first = await session.downloadChunk(
    sp.DownloadChunkRequest(assetId: file['asset'] as String),
  );
  require(
    first.data.isNotEmpty && first.nextOffset < Int64(file['size'] as int),
    'Файл должен состоять из нескольких чанков',
  );
  await signal('partial', {'bytes': first.data.length});
  await wait('hidden');
  await area.controller.refresh();
  require(
    area.controller.state.post.hidden && area.controller.state.comments.isEmpty,
    'Второе окно не скрыло содержимое',
  );
  await native.capture('peer-hidden-mid-download');
  try {
    await session.downloadChunk(
      sp.DownloadChunkRequest(
        assetId: file['asset'] as String,
        offset: first.nextOffset,
      ),
    );
    throw StateError('Следующий чанк скрытой публикации доступен');
  } on GrpcError catch (error) {
    require(error.code == StatusCode.notFound, 'Неверный отказ скачивания');
  }
  await signal('denied');
  await wait('restored');
  final bytes = BytesBuilder()..add(first.data);
  var offset = first.nextOffset;
  while (offset < Int64(file['size'] as int)) {
    final chunk = await session.downloadChunk(
      sp.DownloadChunkRequest(assetId: file['asset'] as String, offset: offset),
    );
    require(chunk.nextOffset > offset, 'Скачивание остановилось');
    bytes.add(chunk.data);
    offset = chunk.nextOffset;
  }
  final downloaded = bytes.takeBytes();
  require(
    downloaded.length == file['size'] &&
        sha256.convert(downloaded).toString() == file['sha256'],
    'Полное скачивание не совпало по размеру или SHA-256',
  );
  await signal('result', {
    'success': true,
    'independentProcesses': true,
    'transportResponseLoss': true,
    'midDownloadHide': true,
    'downloadBytes': downloaded.length,
    'sha256': file['sha256'],
    'retainedFirstChunkBytes': first.data.length,
  });
}

Future<void> runPeer() async {
  WidgetsFlutterBinding.ensureInitialized();
  work = Directory(Platform.environment['SPACE_FEED_WORK']!);
  native.output = work;
  try {
    SharedPreferences.setMockInitialValues({
      'space.ui.dark': true,
      'space.ui.language': 'ru',
    });
    final origin = const String.fromEnvironment('SPACE_FORUM_NATIVE_ORIGIN');
    final discovered = await discover(origin);
    require(
      discovered.serverId ==
          const String.fromEnvironment('SPACE_FORUM_NATIVE_SERVER_ID'),
      'Неверный сервер второго процесса',
    );
    final proxy = Uri.parse(Platform.environment['SPACE_FEED_PROXY']!);
    require(
      InternetAddress(proxy.host).isLoopback && proxy.scheme == 'http',
      'Нужен loopback proxy',
    );
    final routed = Discovery(
      discovered.origin,
      discovered.serverId,
      discovered.publicKey,
      connectOrigin: proxy,
      voiceRoomsVersion: discovered.voiceRoomsVersion,
    );
    final keys = ScenarioStorage();
    final session = await SpaceSession.connect(routed, KeyIdentityVault(keys));
    await showPeer(session, keys);
    await signal('ready', {
      'pid': pid,
      'principal': session.principalId,
      'role': session.role,
    });
    await wait('start');
    await peerReplay(session);
    await peerDownload(session);
    await session.close();
    exit(0);
  } catch (error, stack) {
    await signal('failure', {'error': '$error', 'stack': '$stack'});
    exit(1);
  }
}
