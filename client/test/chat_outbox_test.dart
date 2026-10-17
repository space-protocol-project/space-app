import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';

import 'channels_test.dart'
    show ChannelSession, ChannelVault, MemoryHistory, MemoryPositions;
import 'chat_history_test.dart' show HistoryKeys;
import 'support/chat_outbox.dart';

import 'support/temp_directory.dart';

class OutboxKeys extends HistoryKeys {
  bool fail = false;
  @override
  Future<void> write({required String key, required String value}) async {
    if (fail) throw StateError('Ошибка диска');
    await super.write(key: key, value: value);
  }
}

class FailedHistory extends MemoryHistory {
  bool fail = false;
  @override
  Future<void> write(String origin, dynamic history) async {
    if (fail) throw StateError('Ошибка записи истории');
    await super.write(origin, history);
  }
}

class DelayedRemoval implements ChatOutboxStore {
  DelayedRemoval(this.target);
  final ChatOutboxStore target;
  bool pause = false;
  final entered = Completer<void>(), released = Completer<void>();
  @override
  Future<List<PendingMessage>> read(OutboxScope scope) => target.read(scope);
  @override
  Future<List<PendingMessage>> change(
    OutboxScope scope,
    List<PendingMessage> Function(List<PendingMessage>) update,
  ) async {
    var removed = false;
    final result = await target.change(scope, (saved) {
      final next = update(saved);
      removed = next.length < saved.length;
      return next;
    });
    if (pause && removed) {
      if (!entered.isCompleted) entered.complete();
      await released.future;
    }
    return result;
  }
}

class DeliveryBackend {
  final messages = <String, Content>{};
  final attachments = <String, List<Asset>>{};
  final requests = <(String, String, String)>[];
  bool offline = false, loseAck = false, badAck = false;
  Completer<void>? gate;
  Object? failure;
  Object? responseFailure;
  Future<Content> send(String channel, String text, String key) async {
    requests.add((channel, text, key));
    await gate?.future;
    if (offline) throw const GrpcError.unavailable();
    if (failure != null) throw failure!;
    final message = messages.putIfAbsent(
      key,
      () => Content(
        id: 'message-${messages.length + 1}',
        channelId: channel,
        authorId: 'u_test',
        text: text,
        sequence: Int64(messages.length + 1),
        revision: Int64.ONE,
        attachments: attachments[key],
      ),
    );
    if (responseFailure != null) throw responseFailure!;
    if (loseAck) throw const GrpcError.unavailable('Подтверждение потеряно');
    return badAck
        ? (message.deepCopy()..channelId = 'other')
        : message.deepCopy();
  }
}

class OutboxSession extends ChannelSession implements QueuedMessageSession {
  OutboxSession(this.backend);
  final DeliveryBackend backend;
  Object? loginFailure;
  int logins = 0;
  void Function()? onLogin;
  @override
  Future<void> login() async {
    logins++;
    if (loginFailure != null) throw loginFailure!;
    onLogin?.call();
  }

  @override
  Future<List<Content>> messages() async => backend.messages.values
      .where((entry) => entry.channelId == selectedChannelId)
      .map((entry) => entry.deepCopy())
      .toList();
  @override
  Future<Content> sendQueued(
    String channelId,
    String text,
    String key,
    List<String> attachments,
  ) => backend.send(channelId, text, key);
}

class GrantOutboxSession extends OutboxSession implements DeviceManagement {
  GrantOutboxSession(super.backend);
  String grant = 'grant-a';
  @override
  String get currentGrantId => grant;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> eventually(bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 5));
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) fail('Условие не выполнено');
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  late Directory directory;
  late OutboxKeys keys;
  late DeliveryBackend backend;
  final controllers = <ChatController>[];
  const scope = OutboxScope('http://127.0.0.1:8080', 'srv_test', 'u_test', '');
  LocalChatOutbox store() =>
      LocalChatOutbox(storage: keys, directory: () async => directory);
  Future<ChatController> connect({
    Duration delay = const Duration(hours: 1),
    ChatOutboxStore? outbox,
    MemoryHistory? history,
    OutboxSession? supplied,
  }) async {
    final session = supplied ?? OutboxSession(backend);
    final controller = ChatController(
      ChannelVault(),
      outboxStore: outbox ?? store(),
      fileStore: EmptyQueuedFiles(),
      historyStore: history ?? MemoryHistory(),
      positions: MemoryPositions(),
      openSession: (_, _) async => session,
      retryDelay: (_) => delay,
    );
    controllers.add(controller);
    controller.preview = Discovery(
      localOrigin(scope.origin),
      scope.serverId,
      List.filled(32, 1),
    );
    await controller.connect();
    return controller;
  }

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('space-outbox-');
    keys = OutboxKeys();
    backend = DeliveryBackend();
  });
  tearDown(() async {
    backend.gate?.complete();
    for (final controller in controllers) {
      if (!controller.isClosed) await controller.close();
    }
    controllers.clear();
    await deleteTestDirectory(directory, prefix: 'space-outbox-');
  });

  test(
    'До успешной записи на диск сетевого запроса нет; текст можно повторить',
    () async {
      final controller = await connect();
      keys.fail = true;
      expect(await controller.send('Сохранить сначала'), false);
      expect(backend.requests, isEmpty);
      expect(controller.outboxError, isNotEmpty);
      keys.fail = false;
      await controller.retryPending('');
      expect(await controller.send('Сохранить сначала'), true);
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(backend.messages, hasLength(1));
    },
  );

  test('Перезапуск восстанавливает порядок и разные сообщения с одинаковым текстом', () async {
    backend.offline = true;
    final first = await connect();
    for (final text in ['Первое', 'Одинаковое', 'Одинаковое', 'Последнее']) {
      expect(await first.send(text), true);
    }
    final saved = await store().read(scope);
    expect(saved, hasLength(4));
    expect(saved.map((entry) => entry.key).toSet(), hasLength(4));
    await first.close();
    backend.offline = false;
    final second = await connect();
    await eventually(() => second.pendingMessages.isEmpty);
    expect(backend.messages.values.map((message) => message.text), [
      'Первое',
      'Одинаковое',
      'Одинаковое',
      'Последнее',
    ]);
    expect(backend.messages.keys, saved.map((entry) => entry.key));
  });

  test(
    'Потеря подтверждения и перезапуск повторяют прежний ключ без дубля',
    () async {
      backend.loseAck = true;
      final first = await connect();
      expect(await first.send('Ответ потерян'), true);
      await eventually(() => backend.messages.isNotEmpty);
      final key = first.pendingMessages.single.key;
      await first.close();
      backend.loseAck = false;
      final second = await connect();
      await eventually(() => second.pendingMessages.isEmpty);
      expect(backend.messages, hasLength(1));
      expect(backend.requests.map((entry) => entry.$3), everyElement(key));
      expect(second.messages, hasLength(1));
    },
  );

  test(
    'Повтор после обрыва происходит автоматически без перезапуска',
    () async {
      backend.offline = true;
      final controller = await connect(delay: const Duration(milliseconds: 25));
      await controller.send('После сети');
      await eventually(() => backend.requests.isNotEmpty);
      backend.offline = false;
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(backend.requests.map((entry) => entry.$3).toSet(), hasLength(1));
      expect(backend.messages, hasLength(1));
    },
  );

  test(
    'Смена выбранного канала не перенаправляет ожидающее сообщение',
    () async {
      backend.gate = Completer<void>();
      final controller = await connect();
      await controller.send('В общий');
      await controller.selectChannel('team');
      backend.gate!.complete();
      backend.gate = null;
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(backend.messages.values.single.channelId, 'general');
      expect(controller.messages, isEmpty);
      await controller.send('В команду');
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(backend.messages.values.last.channelId, 'team');
    },
  );

  test(
    'Неверное подтверждение не очищает очередь и не меняет историю',
    () async {
      backend.badAck = true;
      final controller = await connect(delay: const Duration(milliseconds: 10));
      await controller.send('Проверить ответ');
      await eventually(() => controller.pendingMessages.single.blocked);
      expect(controller.messages, isEmpty);
      final calls = backend.requests.length;
      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(backend.requests, hasLength(calls));
      backend.badAck = false;
      await controller.retryPending(controller.pendingMessages.single.key);
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(backend.messages, hasLength(1));
    },
  );

  test('Сбой удаления квитанции сохраняет ключ для восстановления', () async {
    backend.gate = Completer<void>();
    final first = await connect();
    await first.send('Диск после ответа');
    keys.fail = true;
    backend.gate!.complete();
    backend.gate = null;
    await eventually(() => first.outboxError.isNotEmpty);
    expect((await store().read(scope)), hasLength(1));
    await first.close();
    keys.fail = false;
    final second = await connect();
    await eventually(() => second.pendingMessages.isEmpty);
    expect(backend.messages, hasLength(1));
  });

  test('Два хранилища не затирают параллельные добавления', () async {
    final a = store(), b = store();
    await Future.wait(
      List.generate(
        20,
        (index) => (index.isEven ? a : b).change(
          scope,
          (saved) => [
            ...saved,
            PendingMessage(
              key: 'key-$index',
              channelId: 'general',
              text: '$index',
              createdAt: index,
            ),
          ],
        ),
      ),
    );
    expect(await a.read(scope), hasLength(20));
    expect(
      await a.read(const OutboxScope('other', 'srv_test', 'u_test', '')),
      isEmpty,
    );
    expect(
      await a.read(OutboxScope(scope.origin, 'other', 'u_test', '')),
      isEmpty,
    );
    expect(
      await a.read(OutboxScope(scope.origin, scope.serverId, 'other', '')),
      isEmpty,
    );
    expect(
      await a.read(
        OutboxScope(scope.origin, scope.serverId, 'u_test', 'other'),
      ),
      isEmpty,
    );
  });

  test('Повреждённая очередь не удаляется и не заменяется пустой', () async {
    await store().change(
      scope,
      (_) => [
        PendingMessage(
          key: 'key',
          channelId: 'general',
          text: 'Текст',
          createdAt: 0,
        ),
      ],
    );
    final key = keys.values.keys.single;
    keys.values[key] = '{broken';
    final controller = await connect();
    expect(controller.canQueue, false);
    expect(await controller.send('Новый'), false);
    expect(keys.values[key], '{broken');
    expect(backend.requests, isEmpty);
  });
  test(
    'Отключённый клиент сохраняет новые сообщения и отправляет при подключении',
    () async {
      final controller = await connect();
      await controller.disconnect();
      expect(controller.canQueue, true);
      expect(await controller.send('Без сети'), true);
      expect(backend.requests, isEmpty);
      controller.preview = Discovery(
        localOrigin(scope.origin),
        scope.serverId,
        List.filled(32, 1),
      );
      await controller.connect();
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(backend.messages.values.single.text, 'Без сети');
    },
  );

  test(
    'Ошибка прав не повторяется автоматически и не удаляет сообщение',
    () async {
      backend.failure = const GrpcError.permissionDenied();
      final controller = await connect(delay: const Duration(milliseconds: 10));
      await controller.send('После восстановления прав');
      await eventually(() => controller.pendingMessages.single.blocked);
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(backend.requests, hasLength(1));
      expect(
        (await store().read(scope)).single.text,
        'После восстановления прав',
      );
      backend.failure = null;
      await controller.retryPending(controller.pendingMessages.single.key);
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(backend.messages, hasLength(1));
    },
  );

  test(
    'Лимит очереди и неверный текст не вытесняют сохранённые сообщения',
    () async {
      final pending = List.generate(
        maxPendingMessages,
        (index) => PendingMessage(
          key: 'limit-$index',
          channelId: 'general',
          text: '$index',
          createdAt: index,
        ),
      );
      await store().change(scope, (_) => pending);
      await expectLater(
        store().change(
          scope,
          (saved) => [
            ...saved,
            PendingMessage(
              key: 'extra',
              channelId: 'general',
              text: 'Лишнее',
              createdAt: 1,
            ),
          ],
        ),
        throwsFormatException,
      );
      expect(await store().read(scope), hasLength(maxPendingMessages));
      await expectLater(
        store().change(
          scope,
          (_) => [
            PendingMessage(
              key: 'invalid',
              channelId: 'general',
              text: 'Я' * 2049,
              createdAt: 1,
            ),
          ],
        ),
        throwsFormatException,
      );
      expect(await store().read(scope), hasLength(maxPendingMessages));
    },
  );
  test(
    'Поздняя запись старой очереди не попадает в другое пространство',
    () async {
      backend.gate = Completer<void>();
      final delayed = DelayedRemoval(store());
      final controller = await connect(outbox: delayed);
      await controller.send('Первое старого пространства');
      await controller.send('Второе старого пространства');
      delayed.pause = true;
      backend.gate!.complete();
      backend.gate = null;
      await delayed.entered.future;
      controller.preview = Discovery(
        localOrigin('http://127.0.0.1:8081'),
        'srv_other',
        List.filled(32, 2),
      );
      await controller.connect();
      expect(controller.pendingMessages, isEmpty);
      delayed.pause = false;
      delayed.released.complete();
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(controller.pendingMessages, isEmpty);
      expect(backend.messages, hasLength(1));
      expect(
        (await store().read(scope)).single.text,
        'Второе старого пространства',
      );
    },
  );

  test('Ошибка сохранения истории не подтверждает удаление запроса', () async {
    backend.gate = Completer<void>();
    final history = FailedHistory();
    final controller = await connect(history: history);
    await controller.send('История после ответа');
    history.fail = true;
    backend.gate!.complete();
    backend.gate = null;
    await eventually(() => controller.outboxError.isNotEmpty);
    expect(await store().read(scope), hasLength(1));
    history.fail = false;
    await controller.retryPending(controller.pendingMessages.single.key);
    await eventually(() => controller.pendingMessages.isEmpty);
    expect(backend.messages, hasLength(1));
  });
  test(
    'Новый grant не получает автоматическую отправку прежней очереди',
    () async {
      backend.gate = Completer<void>();
      final session = GrantOutboxSession(backend);
      final controller = await connect(supplied: session);
      await controller.send('Первое прежнего устройства');
      await controller.send('Второе прежнего устройства');
      session.grant = 'grant-b';
      backend.gate!.complete();
      backend.gate = null;
      await eventually(() => controller.outboxError == 'identity');
      expect(controller.canQueue, false);
      expect(controller.pendingMessages, hasLength(2));
      expect(
        await store().read(
          OutboxScope(
            scope.origin,
            scope.serverId,
            scope.principalId,
            'grant-a',
          ),
        ),
        hasLength(2),
      );
      expect(backend.requests, hasLength(1));
    },
  );
  test(
    'Отзыв останавливает отправку, но не стирает непринятые сообщения',
    () async {
      backend.offline = true;
      final session = OutboxSession(backend);
      final controller = await connect(supplied: session);
      await controller.send('Сохранить при отзыве');
      session.loginFailure = const GrpcError.unauthenticated();
      session.streams['general']!.last.addError(
        const GrpcError.unauthenticated(),
      );
      await eventually(() => controller.accessRemoved);
      expect(controller.pendingMessages, isEmpty);
      expect(controller.canQueue, false);
      expect(await store().read(scope), hasLength(1));
      await controller.clearOfflineData();
      expect(await store().read(scope), isEmpty);
    },
  );

  test('Архивный канал не принимает новые сообщения в очередь', () async {
    final session = OutboxSession(backend);
    session.availableChannels
            .lastWhere((channel) => channel.id == 'archive')
            .permissions
            .write =
        true;
    final controller = await connect(supplied: session);
    await controller.selectChannel('archive');
    expect(controller.canQueue, false);
    expect(await controller.send('Не ставить в очередь'), false);
  });
  test('Двое суток без сети и перезапуск сохраняют очередь и ключи', () {
    fakeAsync((clock) {
      final memory = MemoryChatOutbox();
      final initial = DateTime.utc(2026, 10, 1);
      ChatController create() {
        final controller =
            ChatController(
                ChannelVault(),
                outboxStore: memory,
                historyStore: MemoryHistory(),
                positions: MemoryPositions(),
                openSession: (_, _) async => OutboxSession(backend),
                now: () => initial.add(clock.elapsed),
              )
              ..preview = Discovery(
                localOrigin(scope.origin),
                scope.serverId,
                List.filled(32, 1),
              );
        controllers.add(controller);
        unawaited(controller.connect());
        clock.flushMicrotasks();
        expect(controller.connected, true);
        return controller;
      }

      backend.offline = true;
      final first = create();
      for (var i = 0; i < 3; i++) {
        unawaited(first.send('Длительный обрыв $i'));
        clock.flushMicrotasks();
      }
      final pending = first.pendingMessages.map((m) => m.key).toList();
      clock.elapse(const Duration(days: 2));
      clock.flushMicrotasks();
      expect(backend.requests.length, inInclusiveRange(5000, 5500));
      expect(backend.requests.map((request) => request.$3).toSet(), {
        pending.first,
      });
      expect(first.pendingMessages.map((m) => m.key), pending);
      expect(first.pendingMessages.any((m) => m.blocked), false);
      unawaited(first.close());
      clock.flushMicrotasks();
      backend.offline = false;
      final restarted = create();
      clock.flushMicrotasks();
      expect(restarted.pendingMessages, isEmpty);
      expect(backend.messages.keys, pending);
      expect(backend.messages, hasLength(3));
      unawaited(restarted.close());
      clock.flushMicrotasks();
    });
  });
  test('Истёкшая сессия обновляется без ручного повтора сообщения', () async {
    backend.failure = const GrpcError.unauthenticated();
    final session = OutboxSession(backend)
      ..onLogin = () => backend.failure = null;
    final controller = await connect(supplied: session);
    expect(await controller.send('После обновления сессии'), true);
    await eventually(() => controller.pendingMessages.isEmpty);
    expect(session.logins, 1);
    expect(backend.requests, hasLength(2));
    expect(backend.requests.first.$3, backend.requests.last.$3);
    expect(backend.messages, hasLength(1));
  });
  test(
    'Оборванный HTTP-ответ повторяется без дубля и ручного вмешательства',
    () async {
      backend.responseFailure = const HttpException(
        'Connection closed while receiving data',
      );
      final controller = await connect(delay: const Duration(milliseconds: 20));
      expect(await controller.send('Ответ оборвался после записи'), true);
      await eventually(() => backend.requests.length >= 2);
      expect(controller.pendingMessages.single.blocked, false);
      backend.responseFailure = null;
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(
        backend.requests.map((request) => request.$3).toSet(),
        hasLength(1),
      );
      expect(backend.messages, hasLength(1));
    },
  );
  test('Повторный отказ авторизации не вызывает бесконечный вход', () async {
    backend.failure = const GrpcError.unauthenticated();
    final session = OutboxSession(backend);
    final controller = await connect(supplied: session);
    expect(await controller.send('Сохранить до восстановления доступа'), true);
    await eventually(() => controller.pendingMessages.single.blocked);
    expect(session.logins, 1);
    expect(backend.requests, hasLength(2));
    expect(await store().read(scope), hasLength(1));
    expect(backend.messages, isEmpty);
  });
  test(
    'Обрыв при обновлении сессии сохраняет запрос для автоматического повтора',
    () async {
      backend.failure = const GrpcError.unauthenticated();
      final session = OutboxSession(backend)
        ..loginFailure = const GrpcError.unavailable();
      final controller = await connect(
        supplied: session,
        delay: const Duration(milliseconds: 20),
      );
      expect(await controller.send('Войти после обрыва'), true);
      await eventually(() => session.logins > 0);
      session.loginFailure = null;
      session.onLogin = () => backend.failure = null;
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(
        backend.requests.map((request) => request.$3).toSet(),
        hasLength(1),
      );
      expect(backend.messages, hasLength(1));
    },
  );
  test('Смена grant во время повторного входа запрещает повтор RPC', () async {
    backend.failure = const GrpcError.unauthenticated();
    final session = GrantOutboxSession(backend);
    session.onLogin = () => session.grant = 'grant-b';
    final controller = await connect(supplied: session);
    expect(await controller.send('Только от исходного устройства'), true);
    await eventually(() => controller.outboxError == 'identity');
    expect(backend.requests, hasLength(1));
    expect(backend.messages, isEmpty);
    final original = OutboxScope(
      scope.origin,
      scope.serverId,
      scope.principalId,
      'grant-a',
    );
    expect(await store().read(original), hasLength(1));
  });
  test(
    'Заполненная очередь продолжает автоматически отправлять прежние сообщения',
    () async {
      await store().change(
        scope,
        (_) => List.generate(
          maxPendingMessages,
          (index) => PendingMessage(
            key: 'queued-$index',
            channelId: 'general',
            text: '$index',
            createdAt: index,
          ),
        ),
      );
      backend.offline = true;
      final controller = await connect(delay: const Duration(milliseconds: 20));
      expect(await controller.send('Не помещается'), false);
      expect(controller.outboxError, 'full');
      backend.offline = false;
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(controller.outboxError, isEmpty);
      expect(backend.messages, hasLength(maxPendingMessages));
      expect(
        backend.messages.values.any(
          (message) => message.text == 'Не помещается',
        ),
        false,
      );
    },
  );
}
