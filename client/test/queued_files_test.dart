import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:space_client/src/files.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/attachment_widgets.dart';
import 'package:space_client/src/attachments.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/queued_file.dart';
import 'package:space_client/src/queued_file_store.dart';
import 'package:space_client/src/rpc_clients.dart';

import 'channels_test.dart' show ChannelVault, MemoryHistory, MemoryPositions;
import 'chat_history_test.dart' show HistoryKeys;
import 'chat_outbox_test.dart' show DeliveryBackend, OutboxSession, eventually;

import 'support/temp_directory.dart';

class _Upload {
  _Upload(this.asset);
  final Asset asset;
  final bytes = <int>[];
}

class _FilesSession extends OutboxSession
    implements AttachmentSession, AttachmentPolicy {
  _FilesSession(super.backend);
  @override
  bool attachmentsEnabled = true;
  final uploads = <String, _Upload>{};
  final beginKeys = <String>[], offsets = <int>[];
  bool loseChunk = false, expired = false;
  Completer<void>? chunkGate;
  bool cancelled = false;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<BeginUploadResponse> beginUpload(BeginUploadRequest request) async {
    expect(
      request.name,
      isNotEmpty,
      reason: 'Имя восстановленного SpaceFile должно сохраниться',
    );
    if (backend.offline) throw const GrpcError.unavailable();
    if (!attachmentsEnabled) throw const GrpcError.permissionDenied();
    beginKeys.add(request.idempotencyKey);
    final upload = uploads.putIfAbsent(
      request.idempotencyKey,
      () => _Upload(
        Asset(
          id: 'asset-${uploads.length + 1}',
          channelId: request.channelId,
          name: request.name,
          byteSize: request.byteSize,
          sha256: request.sha256,
          authorId: 'u_test',
        ),
      ),
    );
    return BeginUploadResponse(
      asset: upload.asset,
      chunkSize: 256 * 1024,
      receivedBytes: Int64(upload.bytes.length),
    );
  }

  _Upload byId(String id) =>
      uploads.values.singleWhere((u) => u.asset.id == id);
  @override
  Future<UploadChunkResponse> uploadChunk(UploadChunkRequest request) async {
    final upload = byId(request.assetId);
    await chunkGate?.future;
    offsets.add(request.offset.toInt());
    expect(request.offset.toInt(), upload.bytes.length);
    upload.bytes.addAll(request.data);
    if (loseChunk) {
      loseChunk = false;
      throw const GrpcError.unavailable('Часть принята, ответ потерян');
    }
    return UploadChunkResponse(receivedBytes: Int64(upload.bytes.length));
  }

  @override
  Future<CompleteUploadResponse> completeUpload(
    CompleteUploadRequest request,
  ) async => CompleteUploadResponse(asset: byId(request.assetId).asset);
  @override
  Future<CancelUploadResponse> cancelUpload(CancelUploadRequest request) async {
    cancelled = true;
    return CancelUploadResponse();
  }

  @override
  Future<Content> sendQueued(
    String channelId,
    String text,
    String key,
    List<String> ids,
  ) async {
    if (expired) {
      expired = false;
      uploads.clear();
      throw const GrpcError.notFound();
    }
    backend.attachments[key] = ids.map((id) => byId(id).asset).toList();
    return backend.send(channelId, text, key);
  }
}

class _AmbiguousKeys extends HistoryKeys {
  bool fail = false;
  @override
  Future<void> write({required String key, required String value}) async {
    await super.write(key: key, value: value);
    if (fail) {
      fail = false;
      throw StateError('Подтверждение записи потеряно');
    }
  }
}

void main() {
  const scope = OutboxScope('http://127.0.0.1:8080', 'srv_test', 'u_test', '');
  late Directory root;
  late HistoryKeys fileKeys;
  late _AmbiguousKeys queueKeys;
  late DeliveryBackend backend;
  late _FilesSession session;
  final controllers = <ChatController>[];
  QueuedFileStore files({int maxBytes = maxQueuedFileBytes}) => QueuedFileStore(
    storage: fileKeys,
    directory: () async => root,
    maxBytes: maxBytes,
  );
  LocalChatOutbox outbox() =>
      LocalChatOutbox(storage: queueKeys, directory: () async => root);
  Future<ChatController> connect({
    Duration retry = const Duration(hours: 1),
  }) async {
    final controller =
        ChatController(
            ChannelVault(),
            outboxStore: outbox(),
            fileStore: files(),
            positions: MemoryPositions(),
            historyStore: MemoryHistory(),
            openSession: (_, _) async => session,
            retryDelay: (_) => retry,
          )
          ..preview = Discovery(
            localOrigin(scope.origin),
            scope.serverId,
            List.filled(32, 1),
          );
    controllers.add(controller);
    await controller.connect();
    return controller;
  }

  SpaceFile data([int length = 500000]) => SpaceFile.fromData(
    Uint8List.fromList(List.generate(length, (i) => i % 251)),
    name: 'проверка.bin',
    path: 'проверка.bin',
  );
  Future<List<File>> encrypted() async => root
      .list(recursive: true, followLinks: false)
      .where((f) => f is File && f.path.endsWith('.bin'))
      .cast<File>()
      .toList();

  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-persistent-files-');
    fileKeys = HistoryKeys();
    queueKeys = _AmbiguousKeys();
    backend = DeliveryBackend();
    session = _FilesSession(backend);
  });
  tearDown(() async {
    session.chunkGate?.complete();
    for (final controller in controllers) {
      if (!controller.isClosed) await controller.close();
    }
    controllers.clear();
    await deleteTestDirectory(root, prefix: 'space-persistent-files-');
  });

  test(
    'Неудачная подготовка набора откатывает только созданные копии',
    () async {
      await expectLater(
        files().stage(scope, 'bad-batch', [data(20), data(0)]),
        throwsStateError,
      );
      expect(await encrypted(), isEmpty);
    },
  );
  test(
    'Потерянный ключ не заменяется до явной очистки локальных файлов',
    () async {
      final descriptor = (await files().stage(scope, 'old', [data(20)])).single;
      fileKeys.values.clear();
      await expectLater(files().read(scope, descriptor), throwsStateError);
      await expectLater(
        files().stage(scope, 'new', [data(20)]),
        throwsStateError,
      );
      expect(await encrypted(), hasLength(1));
      await files().clear(scope);
      expect(await files().stage(scope, 'new', [data(20)]), hasLength(1));
    },
  );
  test(
    'Истёкший неиспользованный файл загружается заново из локальной копии',
    () async {
      session.expired = true;
      final controller = await connect(retry: const Duration(milliseconds: 20));
      expect(
        await controller.send('Файл истёк на сервере', files: [data(20)]),
        true,
      );
      await eventually(() => controller.pendingMessages.isEmpty);
      expect(session.beginKeys, hasLength(2));
      expect(session.beginKeys.toSet(), hasLength(1));
      expect(backend.messages, hasLength(1));
      expect(session.uploads.values.single.bytes, await data(20).readAsBytes());
    },
  );
  test(
    'Зашифрованная копия читается новым хранилищем, исходник больше не нужен',
    () async {
      final original = File('${root.path}/original.txt');
      const text = 'Секретные байты локальной очереди — уникальная строка';
      await original.writeAsString(text);
      final staged = await files().stage(scope, 'message', [
        SpaceFile(original.path),
      ]);
      await original.delete();
      final bytes = await files().read(
        scope,
        QueuedFile.fromJson(staged.single.toJson()),
      );
      expect(utf8.decode(bytes), text);
      final raw = await (await encrypted()).single.readAsBytes();
      expect(raw.length, bytes.length + 28);
      expect(String.fromCharCodes(raw).contains('original.txt'), false);
      expect(
        String.fromCharCodes(raw)
            .contains(String.fromCharCodes(utf8.encode(text))),
        false,
      );
      expect(raw, isNot(bytes));
      expect(fileKeys.values, isNotEmpty);
    },
  );

  test('Оставшаяся после аварии копия очищается, подтверждённая очередь сохраняется', () async {
    final orphan = (await files().stage(scope, 'crashed', [data(20)])).single;
    final path = (await encrypted()).single;
    backend.offline = true;
    final controller = await connect();
    expect(await controller.send('Новая очередь', files: [data(21)]), true);
    expect(await path.exists(), false);
    final pending = controller.pendingMessages.single;
    expect(pending.localFiles.single.id, isNot(orphan.id));
    expect(await files().read(scope, pending.localFiles.single), hasLength(21));
    expect(await encrypted(), hasLength(1));
  });
  test(
    'Повреждённые метаданные не разрешают очистку зашифрованных копий',
    () async {
      await files().stage(scope, 'crashed', [data(20)]);
      queueKeys.values['space.outbox.v1.${scope.id}'] = 'corrupt';
      await expectLater(
        files().enqueue(
          scope,
          PendingMessage(
            key: 'new',
            channelId: 'general',
            text: 'Не удалять копию',
            createdAt: 1,
          ),
          [data(21)],
          outbox(),
          active: () => true,
        ),
        throwsA(isA<FormatException>()),
      );
      expect(await encrypted(), hasLength(1));
    },
  );
  for (final language in ['ru', 'zh', 'en']) {
    testWidgets(
      'Локальный файл уходит из поля в постоянную очередь без сети: $language',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controller = (await tester.runAsync(connect))!;
        await tester.runAsync(controller.disconnect);
        final strings = lookupAppLocalizations(Locale(language));
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(language),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.5)),
              child: child!,
            ),
            home: Scaffold(
              body: ChatView(controller: controller, openConnection: () {}),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('attach-file-button')),
          findsOneWidget,
        );
        final queue = tester
            .widget<AttachmentComposer>(find.byType(AttachmentComposer))
            .queue;
        await tester.runAsync(
          () => queue.add(AttachmentFilesAdded([data(20)])),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('chat-draft')),
          'Без сети 不丢失',
        );
        await tester.tap(find.byTooltip(strings.sendMessage));
        await tester.runAsync(() async {
          await eventually(() => controller.pendingMessages.length == 1);
          await Future<void>.delayed(const Duration(milliseconds: 20));
        });
        await tester.pumpAndSettle();
        expect(queue.state.files, isEmpty);
        expect(
          tester
              .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
              .controller!
              .text,
          isEmpty,
        );
        expect(session.beginKeys, isEmpty);
        await tester.tap(find.byKey(const ValueKey('open-outbox')));
        await tester.pumpAndSettle();
        expect(find.textContaining('проверка.bin'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await tester.runAsync(controller.close);
      },
    );
  }

  test(
    'Повреждение, другая область и подмена имени не расшифровываются',
    () async {
      final staged = await files().stage(scope, 'message', [data(32)]);
      final descriptor = staged.single;
      final altered = QueuedFile.fromJson({
        ...descriptor.toJson(),
        'name': 'другой.bin',
      });
      await expectLater(files().read(scope, altered), throwsA(anything));
      final other = OutboxScope(
        scope.origin,
        scope.serverId,
        scope.principalId,
        'other-grant',
      );
      await expectLater(files().read(other, descriptor), throwsA(anything));
      final path = (await encrypted()).single;
      final raw = await path.readAsBytes();
      raw[raw.length - 1] ^= 1;
      await path.writeAsBytes(raw);
      await expectLater(files().read(scope, descriptor), throwsA(anything));
      expect(await path.exists(), true);
    },
  );

  test(
    'Лимит не вытесняет прежний файл; одинаковый слот нельзя перезаписать',
    () async {
      final store = files(maxBytes: 80);
      final first = await store.stage(scope, 'first', [data(32)]);
      expect(await store.stage(scope, 'first', [data(32)]), hasLength(1));
      await expectLater(
        store.stage(scope, 'second', [data(32)]),
        throwsA(isA<FileQueueFull>()),
      );
      await expectLater(
        store.stage(scope, 'first', [data(31)]),
        throwsA(anything),
      );
      expect(
        await store.read(scope, first.single),
        await data(32).readAsBytes(),
      );
    },
  );

  test(
    'Параллельные экземпляры сохраняют один ключ и читаемые копии',
    () async {
      final pair = await Future.wait([
        files().stage(scope, 'a', [data(32)]),
        files().stage(scope, 'b', [data(33)]),
      ]);
      expect(await files().read(scope, pair[0].single), hasLength(32));
      expect(await files().read(scope, pair[1].single), hasLength(33));
    },
  );

  test('Часть с потерянным ответом продолжается после перезапуска с прежнего смещения', () async {
    session.loseChunk = true;
    final first = await connect();
    final original = File('${root.path}/selected.bin');
    await original.writeAsBytes(await data().readAsBytes());
    expect(
      await first.send(
        'Файл переживёт перезапуск',
        files: [SpaceFile(original.path)],
      ),
      true,
    );
    await eventually(() => first.sendStatus == MessageSendStatus.unconfirmed);
    final key = first.pendingMessages.single.key;
    final uploadKey = first.pendingMessages.single.localFiles.single.key;
    expect(session.uploads.values.single.bytes, hasLength(256 * 1024));
    await first.close();
    await original.delete();
    final restarted = await connect();
    await eventually(() => restarted.pendingMessages.isEmpty);
    expect(session.beginKeys, [uploadKey, uploadKey]);
    expect(session.offsets, [0, 256 * 1024]);
    expect(session.uploads.values.single.bytes, await data().readAsBytes());
    expect(session.uploads.values.single.asset.name, 'selected.bin');
    expect(backend.messages.keys, [key]);
    expect(backend.messages.values.single.attachments, hasLength(1));
    await eventually(() => restarted.sendStatus == MessageSendStatus.accepted);
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(await encrypted(), isEmpty);
  });

  test(
    'Потерянное подтверждение сообщения не начинает новую загрузку',
    () async {
      backend.loseAck = true;
      final first = await connect();
      expect(await first.send('', files: [data(31)]), true);
      await eventually(() => first.sendStatus == MessageSendStatus.unconfirmed);
      final key = first.pendingMessages.single.key;
      expect(first.pendingMessages.single.uploadedFiles, hasLength(1));
      await first.close();
      backend.loseAck = false;
      final restarted = await connect();
      await eventually(() => restarted.pendingMessages.isEmpty);
      expect(session.beginKeys, hasLength(1));
      expect(backend.requests.map((r) => r.$3), [key, key]);
      expect(backend.messages, hasLength(1));
    },
  );

  test('Неоднозначная запись не стирает копию, повтор обходится без исходного файла', () async {
    final controller = await connect();
    final original = File('${root.path}/selected.bin');
    await original.writeAsBytes(await data(20).readAsBytes());
    queueKeys.fail = true;
    expect(
      await controller.send(
        'Запись подтверждена не была',
        files: [SpaceFile(original.path)],
      ),
      false,
    );
    expect(session.beginKeys, isEmpty);
    expect(await outbox().read(scope), hasLength(1));
    await original.delete();
    await controller.retryPending('');
    await eventually(() => controller.pendingMessages.isEmpty);
    expect(backend.messages, hasLength(1));
  });

  test(
    'Запрет вложений не позволяет поставить локальный файл в очередь',
    () async {
      session.attachmentsEnabled = false;
      final controller = await connect();
      expect(controller.canQueueFiles, false);
      expect(
        await controller.send('Нельзя прикрепить', files: [data(20)]),
        false,
      );
      expect(await outbox().read(scope), isEmpty);
      expect(await encrypted(), isEmpty);
      await controller.disconnect();
      expect(controller.canAttachFiles, false);
    },
  );

  test(
    'Убрать сообщение во время загрузки — отменить запрос и удалить копию',
    () async {
      session.chunkGate = Completer<void>();
      final controller = await connect();
      expect(await controller.send('Не отправлять', files: [data(20)]), true);
      await eventually(() => session.beginKeys.isNotEmpty);
      final key = controller.pendingMessages.single.key;
      await controller.discardPending(key);
      session.chunkGate!.complete();
      session.chunkGate = null;
      await eventually(() => session.cancelled);
      expect(backend.messages, isEmpty);
      expect(await encrypted(), isEmpty);
    },
  );
}
