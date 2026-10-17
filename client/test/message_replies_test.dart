import 'dart:convert';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/message_reply.dart';

import 'channels_test.dart' show ChannelVault, MemoryHistory, MemoryPositions;
import 'chat_outbox_test.dart'
    show DeliveryBackend, GrantOutboxSession, OutboxKeys, eventually;
import 'support/chat_outbox.dart' show EmptyQueuedFiles;

import 'support/temp_directory.dart';

class ReplyBackend extends DeliveryBackend {
  final targets = <String, String>{};
  bool badTarget = false;
  @override
  Future<Content> send(String channel, String text, String key) async {
    try {
      final result = await super.send(channel, text, key);
      result.replyToId = badTarget ? 'wrong' : targets[key] ?? '';
      return result;
    } finally {
      messages[key]?.replyToId = targets[key] ?? '';
    }
  }
}

class ReplySession extends GrantOutboxSession implements ReplyMessageSession {
  ReplySession(ReplyBackend super.backend);
  @override
  bool repliesSupported = true;
  int replyCalls = 0;
  @override
  Future<Content> sendReplyQueued(
    String channelId,
    String text,
    String key,
    List<String> attachments,
    String replyTo,
  ) {
    replyCalls++;
    final data = backend as ReplyBackend;
    data.targets.putIfAbsent(key, () => replyTo);
    if (data.targets[key] != replyTo) throw const GrpcError.alreadyExists();
    return data.send(channelId, text, key);
  }
}

void main() {
  late Directory root;
  late OutboxKeys keys;
  late ReplyBackend backend;
  final controllers = <ChatController>[];
  const scope = OutboxScope(
    'http://127.0.0.1:8080',
    'srv_test',
    'u_test',
    'grant-a',
  );
  LocalChatOutbox store() =>
      LocalChatOutbox(storage: keys, directory: () async => root);
  Future<ChatController> start({
    ReplySession? session,
    MemoryHistory? history,
  }) async {
    final controller =
        ChatController(
            ChannelVault(),
            outboxStore: store(),
            fileStore: EmptyQueuedFiles(),
            positions: MemoryPositions(),
            historyStore: history ?? MemoryHistory(),
            retryDelay: (_) => const Duration(hours: 1),
            openSession: (_, _) async => session ?? ReplySession(backend),
          )
          ..preview = Discovery(
            localOrigin(scope.origin),
            scope.serverId,
            List.filled(32, 1),
          );
    controllers.add(controller);
    await controller.connect();
    expect(controller.connected, isTrue, reason: controller.error);
    return controller;
  }

  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-replies-');
    keys = OutboxKeys();
    backend = ReplyBackend();
    backend.messages['parent'] = Content(
      id: 'message-1',
      channelId: 'general',
      authorId: 'other',
      text: 'Исходный текст',
      sequence: Int64.ONE,
      revision: Int64.ONE,
    );
  });
  tearDown(() async {
    for (final controller in controllers) {
      if (!controller.isClosed) await controller.close();
    }
    controllers.clear();
    await deleteTestDirectory(root, prefix: 'space-replies-');
  });

  test(
    'Ответ сохраняет цель после потерянного подтверждения и перезапуска',
    () async {
      backend.loseAck = true;
      final first = await start();
      expect(await first.send('Ответ', replyTo: 'message-1'), isTrue);
      await eventually(() => backend.messages.length == 2);
      final entry = (await store().read(scope)).single;
      expect(entry.replyTo, 'message-1');
      await first.close();
      backend.loseAck = false;
      final next = await start();
      await eventually(() => next.pendingMessages.isEmpty);
      expect(backend.messages, hasLength(2));
      expect(backend.messages[entry.key]!.replyToId, 'message-1');
      expect(backend.requests.map((r) => r.$3).toSet(), {entry.key});
    },
  );

  test(
    'Отсутствие поддержки runtime блокирует восстановленную очередь до RPC',
    () async {
      backend.offline = true;
      final first = await start();
      expect(await first.send('Ответ', replyTo: 'message-1'), isTrue);
      await first.close();
      backend.offline = false;
      backend.requests.clear();
      final session = ReplySession(backend)..repliesSupported = false;
      final next = await start(session: session);
      await eventually(() => next.pendingMessages.single.blocked);
      expect(session.replyCalls, 0);
      expect(backend.requests, isEmpty);
      expect((await store().read(scope)).single.replyTo, 'message-1');
    },
  );

  test('Подмена цели подтверждения не очищает очередь', () async {
    backend.badTarget = true;
    final controller = await start();
    expect(await controller.send('Ответ', replyTo: 'message-1'), isTrue);
    await eventually(() => controller.pendingMessages.single.blocked);
    expect((await store().read(scope)).single.replyTo, 'message-1');
  });

  test('Ошибка сохранения не отправляет ответ', () async {
    final controller = await start();
    keys.fail = true;
    expect(await controller.send('Ответ', replyTo: 'message-1'), isFalse);
    expect(backend.requests, isEmpty);
  });

  test('Цель сохраняется при преобразованиях записи; прежний формат её не принимает', () async {
    final entry = PendingMessage(
      key: 'reply',
      channelId: 'general',
      text: 'Ответ',
      createdAt: 1,
      replyTo: 'message-1',
    );
    expect(
      entry.withBlocked(true).withFiles([]).withUploaded([]).replyTo,
      'message-1',
    );
    await store().change(scope, (_) => [entry]);
    final storageKey = 'space.outbox.v1.${scope.id}';
    final json = jsonDecode(keys.values[storageKey]!) as Map<String, dynamic>;
    expect(json['v'], 3);
    json['v'] = 2;
    keys.values[storageKey] = jsonEncode(json);
    await expectLater(store().read(scope), throwsFormatException);
  });

  for (final language in ['ru', 'en', 'zh']) {
    testWidgets('Ответ в общем поле, отмена без потери черновика: $language', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = await tester.runAsync(start);
      backend.offline = true;
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(language),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.5)),
            child: child!,
          ),
          home: Scaffold(
            body: ChatView(controller: controller!, openConnection: () {}),
          ),
        ),
      );
      final strings = AppLocalizations.of(
        tester.element(find.byType(ChatView)),
      )!;
      final field = find.byKey(const ValueKey('chat-draft'));
      await tester.enterText(field, 'Мой черновик');
      await tester.longPress(find.text('Исходный текст'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(strings.replyMessage));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('composer-reply')), findsOneWidget);
      expect(tester.widget<TextField>(field).controller!.text, 'Мой черновик');
      await tester.tap(find.byTooltip(strings.cancelReply));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('composer-reply')), findsNothing);
      expect(tester.widget<TextField>(field).controller!.text, 'Мой черновик');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Удалённый исходник не раскрывается в предпросмотре', (
    tester,
  ) async {
    final target = backend.messages['parent']!..deleted = true;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: MessageReply(message: target)),
      ),
    );
    expect(find.text('Исходный текст'), findsNothing);
    expect(find.text('Сообщение удалено'), findsOneWidget);
  });
}
