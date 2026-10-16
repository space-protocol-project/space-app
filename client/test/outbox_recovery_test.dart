import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/queued_file_store.dart';
import 'package:space_client/ui/outbox_recovery.dart';

import 'channels_test.dart' show ChannelVault, MemoryHistory, MemoryPositions;
import 'chat_history_test.dart' show HistoryKeys;
import 'chat_outbox_test.dart'
    show DeliveryBackend, GrantOutboxSession, eventually;

class _FaultOutbox implements ChatOutboxStore {
  _FaultOutbox(this.delegate, this.failScope, {this.after = false});
  final ChatOutboxStore delegate;
  final OutboxScope failScope;
  final bool after;
  bool fail = true;
  @override
  Future<List<PendingMessage>> read(OutboxScope scope) => delegate.read(scope);
  @override
  Future<List<PendingMessage>> change(
    OutboxScope scope,
    List<PendingMessage> Function(List<PendingMessage>) update,
  ) async {
    if (fail && scope.id == failScope.id) {
      fail = false;
      if (after) await delegate.change(scope, update);
      throw const FileSystemException('Ответ на запись потерян');
    }
    return delegate.change(scope, update);
  }
}

void main() {
  const source = OutboxScope(
    'http://127.0.0.1:8080',
    'srv_test',
    'u_test',
    'old',
  );
  const target = OutboxScope(
    'http://127.0.0.1:8080',
    'srv_test',
    'u_test',
    'new',
  );
  late Directory root;
  late HistoryKeys keys;
  late LocalChatOutbox outbox;
  late QueuedFileStore files;
  final controllers = <ChatController>[];
  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-outbox-recovery-');
    keys = HistoryKeys();
    outbox = LocalChatOutbox(storage: keys, directory: () async => root);
    files = QueuedFileStore(storage: keys, directory: () async => root);
  });
  tearDown(() async {
    for (final controller in controllers) {
      if (!controller.isClosed) await controller.close();
    }
    controllers.clear();
    await root.delete(recursive: true);
  });
  PendingMessage message([String key = 'same-key']) => PendingMessage(
    key: key,
    channelId: 'general',
    text: 'Неотправленное',
    createdAt: 1,
  );
  Future<void> save({bool attachment = false}) async {
    if (!attachment) {
      await outbox.change(source, (_) => [message()]);
      return;
    }
    await files.enqueue(
      source,
      message(),
      [
        XFile.fromData(
          Uint8List.fromList(utf8.encode('Вложение после смены grant')),
          name: 'файл.txt',
          path: 'файл.txt',
        ),
      ],
      outbox,
      active: () => true,
    );
  }

  test(
    'Каталог переживает перезапуск и не смешивает серверы и личности',
    () async {
      await save();
      final reopened = LocalChatOutbox(
        storage: keys,
        directory: () async => root,
      );
      expect((await reopened.previousScopes(target)).single.id, source.id);
      expect(
        await reopened.previousScopes(
          OutboxScope(
            source.origin,
            'other-server',
            source.principalId,
            target.grantId,
          ),
        ),
        isEmpty,
      );
      expect(
        await reopened.previousScopes(
          OutboxScope(
            source.origin,
            source.serverId,
            'other-person',
            target.grantId,
          ),
        ),
        isEmpty,
      );
    },
  );

  test('Перенос повторно шифрует файл и сохраняет ключи запросов', () async {
    await save(attachment: true);
    final old = (await outbox.read(source)).single;
    final result = await files.transfer(
      source,
      target,
      outbox,
      active: () => true,
    );
    expect(result.single.key, old.key);
    expect(result.single.localFiles.single.key, old.localFiles.single.key);
    expect(
      utf8.decode(await files.read(target, result.single.localFiles.single)),
      'Вложение после смены grant',
    );
    expect(await outbox.read(source), isEmpty);
    expect(await outbox.previousScopes(target), isEmpty);
    await expectLater(
      files.read(source, old.localFiles.single),
      throwsFormatException,
    );
  });

  for (final after in [false, true]) {
    test(
      'Ошибка записи назначения, after=$after: источник остаётся и повтор безопасен',
      () async {
        await save(attachment: true);
        final fault = _FaultOutbox(outbox, target, after: after);
        await expectLater(
          files.transfer(source, target, fault, active: () => true),
          throwsA(isA<FileSystemException>()),
        );
        final old = (await outbox.read(source)).single;
        expect(await files.read(source, old.localFiles.single), isNotEmpty);
        await files.transfer(source, target, fault, active: () => true);
        expect((await outbox.read(target)).map((entry) => entry.key), [
          'same-key',
        ]);
        expect(await outbox.read(source), isEmpty);
      },
    );
  }

  test('Потеря ответа на очистку источника не теряет назначение', () async {
    await save(attachment: true);
    final fault = _FaultOutbox(outbox, source, after: true);
    await expectLater(
      files.transfer(source, target, fault, active: () => true),
      throwsA(isA<FileSystemException>()),
    );
    final saved = (await outbox.read(target)).single;
    expect(await files.read(target, saved.localFiles.single), isNotEmpty);
    expect(await outbox.read(source), isEmpty);
  });

  test(
    'Чужая личность, сервер и тот же grant отвергаются до изменения',
    () async {
      await save();
      final invalid = [
        source,
        OutboxScope(source.origin, 'other', source.principalId, 'new'),
        OutboxScope(source.origin, source.serverId, 'other', 'new'),
        OutboxScope(
          'http://127.0.0.1:9090',
          source.serverId,
          source.principalId,
          'new',
        ),
      ];
      for (final scope in invalid) {
        expect(
          () => files.transfer(source, scope, outbox, active: () => true),
          throwsFormatException,
        );
      }
      expect(await outbox.read(source), hasLength(1));
    },
  );

  test('Коллизия ключа и отзыв доверия не стирают очереди', () async {
    await save();
    await outbox.change(
      target,
      (_) => [
        PendingMessage(
          key: 'same-key',
          channelId: 'general',
          text: 'Другой запрос',
          createdAt: 1,
        ),
      ],
    );
    await expectLater(
      files.transfer(source, target, outbox, active: () => true),
      throwsFormatException,
    );
    await expectLater(
      files.transfer(source, target, outbox, active: () => false),
      throwsStateError,
    );
    expect((await outbox.read(source)).single.text, 'Неотправленное');
    expect((await outbox.read(target)).single.text, 'Другой запрос');
  });

  test('Без отдельного действия новый grant ничего не отправляет', () async {
    await save();
    final backend = DeliveryBackend();
    final session = GrantOutboxSession(backend)..grant = target.grantId;
    final controller =
        ChatController(
            ChannelVault(),
            outboxStore: outbox,
            fileStore: files,
            historyStore: MemoryHistory(),
            positions: MemoryPositions(),
            openSession: (_, _) async => session,
          )
          ..preview = Discovery(
            localOrigin(target.origin),
            target.serverId,
            List.filled(32, 1),
          );
    try {
      await controller.connect();
      expect(controller.state.outboxSources.single.id, source.id);
      expect(backend.requests, isEmpty);
      final snapshot = outboxSnapshot(await outbox.read(source));
      expect(
        await controller.recoverOutbox(
          source,
          'stale-target',
          snapshot: snapshot,
        ),
        isFalse,
      );
      expect(backend.requests, isEmpty);
      expect(
        await controller.recoverOutbox(
          source,
          controller.outboxRecoveryTarget,
          snapshot: snapshot,
        ),
        isTrue,
      );
      await eventually(
        () =>
            controller.pendingMessages.isEmpty && backend.messages.length == 1,
      );
      expect(backend.requests.single.$3, 'same-key');
    } finally {
      await controller.close();
    }
  });

  test(
    'Изменение очереди после просмотра требует нового подтверждения',
    () async {
      await save();
      final snapshot = outboxSnapshot(await outbox.read(source));
      await outbox.change(
        source,
        (saved) => [...saved, message('added-after-review')],
      );
      await expectLater(
        files.transfer(
          source,
          target,
          outbox,
          active: () => true,
          expectedSource: snapshot,
        ),
        throwsFormatException,
      );
      expect(await outbox.read(source), hasLength(2));
      expect(await outbox.read(target), isEmpty);
    },
  );

  for (final language in ['ru', 'en', 'zh']) {
    testWidgets('Подтверждение доверия и отмена на узком экране: $language', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.runAsync(() => save());
      final backend = DeliveryBackend();
      final session = GrantOutboxSession(backend)..grant = target.grantId;
      late ChatController controller;
      await tester.runAsync(() async {
        controller =
            ChatController(
                ChannelVault(),
                outboxStore: outbox,
                fileStore: files,
                historyStore: MemoryHistory(),
                positions: MemoryPositions(),
                openSession: (_, _) async => session,
              )
              ..preview = Discovery(
                localOrigin(target.origin),
                target.serverId,
                List.filled(32, 1),
              );
        controllers.add(controller);
        await controller.connect();
      });
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(language),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.5)),
            child: child!,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: OutboxRecoveryButton(
              controller: controller,
              source: source,
              target: controller.outboxRecoveryTarget,
              enabled: true,
            ),
          ),
        ),
      );
      await tester.runAsync(() async {
        await tester.tap(find.byType(TextButton).first);
        await Future<void>.delayed(const Duration(milliseconds: 80));
      });
      await tester.pumpAndSettle();
      expect(
        tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
        isFalse,
      );
      final strings = AppLocalizations.of(
        tester.element(find.byType(OutboxRecoveryButton)),
      )!;
      final send = find.widgetWithText(TextButton, strings.outboxRecoverSend);
      expect(tester.widget<TextButton>(send).onPressed, isNull);
      await tester.ensureVisible(find.byType(CheckboxListTile));
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();
      expect(tester.widget<TextButton>(send).onPressed, isNotNull);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(strings.cancelMessageChange));
      await tester.pumpAndSettle();
      expect(backend.requests, isEmpty);
      await tester.runAsync(() => controller.close());
    });
  }
}
