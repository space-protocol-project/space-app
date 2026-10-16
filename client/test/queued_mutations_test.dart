import 'dart:convert';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/queued_mutation.dart';
import 'package:space_client/src/queued_mutation_projection.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/chat_view.dart';

import 'channels_test.dart' show ChannelVault, MemoryHistory, MemoryPositions;
import 'chat_outbox_test.dart'
    show
        DeliveryBackend,
        GrantOutboxSession,
        OutboxKeys,
        FailedHistory,
        eventually;
import 'support/chat_outbox.dart' show EmptyQueuedFiles;

class MutationBackend extends DeliveryBackend {
  final receipts = <String, (String, int)>{};
  final calls = <(String, int, MutationKind)>[];
  bool loseMutationAck = false;
  MutationReceipt Function(MutationReceipt)? tamper;
  int changes = 0;
  Content get current => messages['initial']!;

  Future<MutationReceipt> apply(
    String channel,
    String key,
    String text,
    QueuedMutation change,
  ) async {
    calls.add((key, change.revision, change.kind));
    await gate?.future;
    if (offline) throw const GrpcError.unavailable();
    if (failure != null) throw failure!;
    final signature = jsonEncode([
      channel,
      change.kind.name,
      change.id,
      change.revision,
      text,
      change.emoji,
      change.active,
    ]);
    final previous = receipts[key];
    if (previous != null) {
      if (previous.$1 != signature) throw const GrpcError.alreadyExists();
      return _reply(key, previous.$2);
    }
    if (change.revision != current.revision.toInt()) {
      throw const GrpcError.aborted();
    }
    if (current.deleted) throw const GrpcError.failedPrecondition();
    final before = current;
    final entry = PendingMessage(
      key: key,
      channelId: channel,
      text: text,
      createdAt: 1,
      mutation: change,
    );
    final next = projectQueuedMutations([before], [entry], 'u_test').single;
    final noop =
        change.kind == MutationKind.reaction &&
        jsonEncode(
              before.reactions.map((item) => item.toProto3Json()).toList(),
            ) ==
            jsonEncode(
              next.reactions.map((item) => item.toProto3Json()).toList(),
            );
    next.revision = before.revision + (noop ? 0 : 1);
    if (!noop) changes++;
    messages['initial'] = next;
    receipts[key] = (signature, next.revision.toInt());
    return _reply(key, next.revision.toInt());
  }

  MutationReceipt _reply(String key, int applied) {
    if (loseMutationAck) throw const HttpException('Подтверждение потеряно');
    final result = MutationReceipt(current.deepCopy(), key, applied);
    return tamper?.call(result) ?? result;
  }
}

class MutatingSession extends GrantOutboxSession
    implements QueuedMutationSession {
  MutatingSession(MutationBackend super.backend);
  @override
  Future<MutationReceipt> mutateQueued(
    String channelId,
    String key,
    String text,
    QueuedMutation mutation,
  ) => (backend as MutationBackend).apply(channelId, key, text, mutation);
}

void main() {
  late Directory root;
  late OutboxKeys keys;
  late MutationBackend backend;
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
    MutatingSession? session,
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
            openSession: (_, _) async => session ?? MutatingSession(backend),
          )
          ..preview = Discovery(
            localOrigin(scope.origin),
            scope.serverId,
            List.filled(32, 1),
          );
    controllers.add(controller);
    await controller.connect();
    expect(controller.connected, true, reason: controller.error);
    return controller;
  }

  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-mutation-queue-');
    keys = OutboxKeys();
    backend = MutationBackend();
    backend.messages['initial'] = Content(
      id: 'message-1',
      channelId: 'general',
      authorId: 'u_test',
      text: 'До изменения',
      sequence: Int64.ONE,
      revision: Int64.ONE,
    );
  });
  tearDown(() async {
    if (backend.gate?.isCompleted == false) backend.gate!.complete();
    for (final controller in controllers) {
      if (!controller.isClosed) await controller.close();
    }
    controllers.clear();
    await root.delete(recursive: true);
  });

  test(
    'Ошибка диска не отправляет изменение и сохраняет исходный текст',
    () async {
      final controller = await start();
      keys.fail = true;
      expect(
        await controller.updateMessage(controller.messages.single, 'Правка'),
        false,
      );
      expect(backend.calls, isEmpty);
      expect(controller.messages.single.text, 'До изменения');
    },
  );

  test(
    'Правка, реакция и удаление переживают перезапуск и сохраняют порядок',
    () async {
      backend.offline = true;
      final first = await start();
      expect(
        await first.updateMessage(first.messages.single, 'После изменения'),
        true,
      );
      expect(first.messages.single.text, 'После изменения');
      expect(await first.setReaction(first.messages.single, '👍', true), true);
      expect(first.messages.single.reactions.single.principalIds, ['u_test']);
      expect(await first.deleteMessage(first.messages.single), true);
      expect(first.messages.single.deleted, true);
      final saved = await store().read(scope);
      expect(saved.map((entry) => entry.mutation!.kind), [
        MutationKind.edit,
        MutationKind.reaction,
        MutationKind.delete,
      ]);
      await first.close();
      backend.offline = false;
      final restored = await start();
      await eventually(() => restored.pendingMessages.isEmpty);
      expect(backend.current.deleted, true);
      expect(backend.current.revision.toInt(), 4);
      expect(
        backend.receipts.keys.toSet(),
        saved.map((entry) => entry.key).toSet(),
      );
      expect(
        backend.calls
            .where((call) => backend.receipts.containsKey(call.$1))
            .map((call) => call.$2)
            .toList()
            .sublist(backend.calls.length - 3),
        [1, 2, 3],
      );
    },
  );

  test(
    'Документ изменений имеет v2: откат не отправляет правку новым сообщением',
    () async {
      backend.offline = true;
      final controller = await start();
      await controller.updateMessage(
        controller.messages.single,
        'Не новое сообщение',
      );
      final slot = 'space.outbox.v1.${scope.id}';
      final data = jsonDecode(keys.values[slot]!) as Map<String, dynamic>;
      expect(data['v'], 2);
      expect(
        (await store().read(scope)).single.mutation!.kind,
        MutationKind.edit,
      );
      data['v'] = 1;
      final downgraded = jsonEncode(data);
      keys.values[slot] = downgraded;
      await expectLater(store().read(scope), throwsFormatException);
      expect(keys.values[slot], downgraded);
    },
  );

  for (final kind in MutationKind.values) {
    test(
      'Потерянный ответ $kind: после перезапуска действие не повторяется',
      () async {
        backend.loseMutationAck = true;
        final first = await start();
        final target = first.messages.single;
        final accepted = switch (kind) {
          MutationKind.edit => await first.updateMessage(target, 'Правка'),
          MutationKind.delete => await first.deleteMessage(target),
          MutationKind.reaction => await first.setReaction(target, '👍', true),
        };
        expect(accepted, true);
        await eventually(
          () => first.sendStatus == MessageSendStatus.unconfirmed,
        );
        final key = first.pendingMessages.single.key;
        expect(backend.changes, 1);
        await first.close();
        backend.loseMutationAck = false;
        final second = await start();
        await eventually(() => second.pendingMessages.isEmpty);
        expect(backend.changes, 1);
        expect(backend.calls.map((call) => call.$1), [key, key]);
      },
    );
  }

  test('Два решения о реакции сохраняют порядок, включая no-op', () async {
    backend.offline = true;
    final first = await start();
    await first.setReaction(first.messages.single, '👍', false);
    await first.setReaction(first.messages.single, '👍', true);
    await first.setReaction(first.messages.single, '👍', false);
    await first.close();
    backend.offline = false;
    final second = await start();
    await eventually(() => second.pendingMessages.isEmpty);
    expect(backend.current.reactions, isEmpty);
    expect(backend.current.revision.toInt(), 3);
  });

  test('Чужая правка блокирует очередь и не перезаписывается', () async {
    backend.offline = true;
    final first = await start();
    await first.updateMessage(first.messages.single, 'Локальная правка');
    await first.close();
    backend.current.text = 'Правка с другого устройства';
    backend.current.revision = Int64(2);
    backend.offline = false;
    final second = await start();
    await eventually(() => second.pendingMessages.single.blocked);
    expect(backend.current.text, 'Правка с другого устройства');
    expect(second.messages.single.text, 'Правка с другого устройства');
    expect(second.pendingMessages.single.text, 'Локальная правка');
  });

  test(
    'Повтор старого подтверждения не перезаписывает последующую чужую правку',
    () async {
      backend.loseMutationAck = true;
      final first = await start();
      await first.updateMessage(first.messages.single, 'Локальная правка');
      await eventually(() => first.sendStatus == MessageSendStatus.unconfirmed);
      await first.close();
      backend.current.text = 'Более новая правка';
      backend.current.revision = Int64(3);
      backend.loseMutationAck = false;
      final second = await start();
      await eventually(() => second.pendingMessages.isEmpty);
      expect(second.messages.single.text, 'Более новая правка');
      expect(backend.changes, 1);
    },
  );

  test('Подмена ключа квитанции оставляет запрос в очереди', () async {
    backend.tamper = (receipt) =>
        MutationReceipt(receipt.content, 'wrong-key', receipt.appliedRevision);
    final controller = await start();
    await controller.updateMessage(controller.messages.single, 'Правка');
    await eventually(() => controller.pendingMessages.single.blocked);
    expect(await store().read(scope), hasLength(1));
  });

  test(
    'Зависимое действие использует версию квитанции, а не чужую новую версию',
    () async {
      backend.loseMutationAck = true;
      final first = await start();
      await first.updateMessage(first.messages.single, 'Первая правка');
      await eventually(() => first.sendStatus == MessageSendStatus.unconfirmed);
      await first.updateMessage(first.messages.single, 'Вторая правка');
      await first.close();
      backend.current.text = 'Конкурентная правка';
      backend.current.revision = Int64(3);
      backend.loseMutationAck = false;
      final second = await start();
      await eventually(
        () =>
            second.pendingMessages.length == 1 &&
            second.pendingMessages.single.blocked,
      );
      expect(second.pendingMessages.single.mutation!.revision, 2);
      expect(backend.current.text, 'Конкурентная правка');
      expect(second.pendingMessages.single.text, 'Вторая правка');
    },
  );

  test('Старый runtime отклоняет действие, очередь сохраняется', () async {
    backend.failure = const GrpcError.unimplemented('Нужен новый runtime');
    final controller = await start();
    await controller.updateMessage(controller.messages.single, 'Правка');
    await eventually(() => controller.pendingMessages.single.blocked);
    expect(backend.changes, 0);
    expect(await store().read(scope), hasLength(1));
  });

  test(
    'Удаление родительского запроса не отправляет зависимые изменения',
    () async {
      backend.offline = true;
      final controller = await start();
      await controller.updateMessage(controller.messages.single, 'Один');
      await controller.updateMessage(controller.messages.single, 'Два');
      final first = controller.pendingMessages.first.key;
      await controller.discardPending(first);
      expect(controller.pendingMessages.single.blocked, true);
      backend.offline = false;
      await controller.retryPending(controller.pendingMessages.single.key);
      expect(controller.pendingMessages.single.blocked, true);
      expect(backend.changes, 0);
    },
  );

  test(
    'Отозванное устройство не повторяет изменение от нового grant',
    () async {
      backend.loseMutationAck = true;
      final session = MutatingSession(backend);
      final controller = await start(session: session);
      await controller.setReaction(controller.messages.single, '🔥', true);
      await eventually(
        () => controller.sendStatus == MessageSendStatus.unconfirmed,
      );
      final key = controller.pendingMessages.single.key;
      session.grant = 'grant-b';
      backend.loseMutationAck = false;
      await controller.retryPending(key);
      expect(controller.outboxError, 'identity');
      expect(await store().read(scope), hasLength(1));
      expect(backend.calls, hasLength(1));
    },
  );

  test(
    'Офлайн-действия доступны по доверенному кешу после отключения',
    () async {
      final controller = await start();
      await controller.disconnect();
      expect(controller.canChangeMessage(controller.messages.single), true);
      expect(controller.canReact, true);
      await controller.updateMessage(controller.messages.single, 'Без сети');
      await controller.setReaction(controller.messages.single, '👍', true);
      expect(await store().read(scope), hasLength(2));
      expect(backend.calls, isEmpty);
    },
  );

  test(
    'Ошибка сохранения истории не очищает подтверждённое изменение',
    () async {
      final history = FailedHistory();
      final controller = await start(history: history);
      history.fail = true;
      await controller.updateMessage(
        controller.messages.single,
        'Сохранить до очистки',
      );
      await eventually(() => controller.outboxError == 'storage');
      expect(controller.pendingMessages, hasLength(1));
      expect(backend.changes, 1);
      history.fail = false;
      await controller.retryPending('');
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(backend.changes, 1);
    },
  );

  for (final language in ['ru', 'en', 'zh']) {
    testWidgets('Офлайн-редактор сохраняет ввод при ошибке диска: $language', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = (await tester.runAsync(() async {
        final result = await start();
        await result.disconnect();
        return result;
      }))!;
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
            body: ChatView(controller: controller, openConnection: () {}),
          ),
        ),
      );
      final strings = AppLocalizations.of(
        tester.element(find.byType(ChatView)),
      )!;
      final field = find.byKey(const ValueKey('chat-draft'));
      await tester.enterText(field, 'Отдельный черновик');
      await tester.tap(find.byTooltip(strings.messageActions));
      await tester.pumpAndSettle();
      await tester.tap(find.text(strings.editMessage));
      await tester.pumpAndSettle();
      await tester.enterText(field, 'Новая правка');
      keys.fail = true;
      await tester.runAsync(() async {
        await tester.tap(find.byTooltip(strings.saveMessage));
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(field).controller!.text, 'Новая правка');
      expect(backend.calls, isEmpty);
      keys.fail = false;
      await tester.runAsync(() => controller.retryPending(''));
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await tester.tap(find.byTooltip(strings.saveMessage));
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(field).controller!.text,
        'Отдельный черновик',
      );
      expect(
        controller.pendingMessages.single.mutation!.kind,
        MutationKind.edit,
      );
      expect(controller.pendingMessages.single.text, 'Новая правка');
      expect(backend.calls, isEmpty);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(() => controller.close());
    });
  }
}
