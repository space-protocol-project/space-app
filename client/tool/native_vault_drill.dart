// Отдельная точка входа для проверки настоящего Windows secure storage.
// Production main.dart не содержит тестовых флагов или файлового fallback.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:space_client/src/files.dart';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/widgets.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/chat_history.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/queued_file_store.dart';
import 'package:space_client/src/queued_mutation.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/secure_vault.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isWindows ||
      args.length != 3 ||
      !RegExp(r'^[a-f0-9]{32}$').hasMatch(args[1]) ||
      ![
        'write',
        'reopen',
        'cleanup',
        'crash-active',
        'recover-crash',
      ].contains(args[0])) {
    exit(2);
  }
  // Этот origin никогда не используется подключением: отдельный случайный test slot.
  final origin = 'space-vault-drill:${args[1]}';
  final report = File(args[2]);
  final vault = SecureIdentityVault();
  try {
    if (args[0] == 'crash-active') {
      final record = await vault.load(origin);
      if (record == null || await vault.loadRotation(origin) == null) {
        throw StateError('Нет исходного состояния');
      }
      await vault.save(record);
      throw StateError('Crash checkpoint не включён');
    } else if (args[0] == 'recover-crash') {
      bool unreadable = false;
      try {
        unreadable = await vault.load(origin) == null;
      } catch (_) {
        unreadable = true;
      }
      if (unreadable) {
        throw StateError('Атомарная запись повредила прежний active slot');
      }
      final journal = await vault.loadRotation(origin);
      if (journal == null) throw StateError('Отдельный journal потерян');
      final record = DeviceRecord.fromJson(
        journal['next'] as Map<String, dynamic>,
      );
      await vault.save(record);
      final expected =
          jsonDecode(await report.readAsString()) as Map<String, dynamic>;
      final digest = url64(
        (await Sha256().hash(
          utf8.encode(jsonEncode((await vault.load(origin))!.toJson())),
        )).bytes,
      );
      if (digest != expected['digest']) {
        throw StateError('Восстановлены другие ключи');
      }
      await report.writeAsString(
        jsonEncode({...expected, 'crash': true, 'recovered': true}),
      );
    } else if (args[0] == 'write') {
      if (await vault.load(origin) != null) {
        throw StateError('Тестовый слот уже занят');
      }
      final algorithm = Ed25519();
      final root = await algorithm.newKeyPair();
      final device = await algorithm.newKeyPair();
      final record = DeviceRecord(
        origin: origin,
        serverId: 'srv_${'a' * 32}',
        serverKey: url64(List.filled(32, 1)),
        rootSeed: [],
        rootPublicKey: (await root.extractPublicKey()).bytes,
        deviceSeed: await device.extractPrivateKeyBytes(),
        grantId: 'dg_${url64(List.filled(32, 2))}',
      );
      await vault.save(record);
      await vault.saveRotation(origin, {
        'v': 1,
        'next': record.toJson(),
        'test_only': true,
      });
      final digest = url64(
        (await Sha256().hash(utf8.encode(jsonEncode(record.toJson())))).bytes,
      );
      final history =
          ChatHistory(
              serverId: record.serverId,
              principalId: (await record.identity()).principalId,
              grantId: record.grantId,
            )
            ..channels = [
              Channel(
                id: 'general',
                permissions: ChannelPermissions(read: true),
              ),
            ];
      history.merge([
        Content(
          id: 'favorite-test',
          channelId: 'general',
          text: 'Проверка избранного',
        ),
      ], DateTime.now());
      history.favorites.add('general/favorite-test');
      await LocalChatHistory().write(origin, history);
      final scope = await outboxScope(record);
      if ((await LocalChatOutbox().read(scope)).isNotEmpty) {
        throw StateError('Тестовый слот очереди уже занят');
      }
      final queuedFiles = await QueuedFileStore().stage(
        scope,
        'ordinary-pending',
        [
          SpaceFile.fromData(
            Uint8List.fromList(
              utf8.encode('Файл переживает завершение процесса'),
            ),
            name: 'pending.txt',
            path: 'pending.txt',
          ),
        ],
      );
      await LocalChatOutbox().change(
        scope,
        (_) => [
          PendingMessage(
            key: 'ordinary-pending',
            channelId: 'general',
            text: 'Неотправленное сообщение',
            createdAt: DateTime.now().millisecondsSinceEpoch,
            attachments: ['asset-pending'],
            localFiles: queuedFiles,
          ),
          PendingMessage(
            key: 'pending-edit',
            channelId: 'general',
            text: 'Правка после перезапуска',
            createdAt: 1,
            mutation: QueuedMutation(
              kind: MutationKind.edit,
              id: 'existing',
              author: scope.principalId,
              sequence: 1,
              revision: 2,
            ),
          ),
          PendingMessage(
            key: 'pending-reaction',
            channelId: 'general',
            text: '',
            createdAt: 2,
            mutation: QueuedMutation(
              kind: MutationKind.reaction,
              id: 'existing',
              author: scope.principalId,
              sequence: 1,
              revision: 2,
              emoji: '👍',
              active: true,
              after: 'pending-edit',
            ),
          ),
        ],
      );
      await report.writeAsString(
        jsonEncode({
          'digest': digest,
          'write': true,
          'favoriteWrite': true,
          'outboxWrite': true,
          'filesWrite': true,
          'mutationsWrite': true,
        }),
      );
    } else if (args[0] == 'reopen') {
      final expected =
          jsonDecode(await report.readAsString()) as Map<String, dynamic>;
      final record = await vault.load(origin);
      if (record == null ||
          record.rootSeed.isNotEmpty ||
          record.recoverySeed.isNotEmpty) {
        throw StateError(
          'Рабочая запись после перезапуска потеряна или содержит root',
        );
      }
      final digest = url64(
        (await Sha256().hash(utf8.encode(jsonEncode(record.toJson())))).bytes,
      );
      if (digest != expected['digest']) {
        throw StateError('Системное хранилище изменило ключи');
      }
      final journal = await vault.loadRotation(origin);
      if (journal == null ||
          jsonEncode(journal['next']) != jsonEncode(record.toJson())) {
        throw StateError('Журнал не сохранился после перезапуска');
      }
      final history = await LocalChatHistory().read(origin);
      if (history == null ||
          !history.favorites.contains('general/favorite-test') ||
          history.messages('general', DateTime.now()).single.id !=
              'favorite-test') {
        throw StateError('Избранное не сохранилось после завершения процесса');
      }
      final pending = await LocalChatOutbox().read(await outboxScope(record));
      if (pending.length != 3 ||
          pending.first.key != 'ordinary-pending' ||
          pending.first.text != 'Неотправленное сообщение' ||
          pending.first.attachments.single != 'asset-pending') {
        throw StateError('Очередь не сохранилась после завершения процесса');
      }
      final file = await QueuedFileStore().read(
        await outboxScope(record),
        pending.first.localFiles.single,
      );
      if (utf8.decode(file) != 'Файл переживает завершение процесса') {
        throw StateError('Копия файла не пережила завершение процесса');
      }
      if (pending[1].mutation?.kind != MutationKind.edit ||
          pending[1].text != 'Правка после перезапуска' ||
          pending[2].mutation?.kind != MutationKind.reaction ||
          pending[2].mutation?.emoji != '👍' ||
          pending[2].mutation?.after != 'pending-edit') {
        throw StateError('Очередь изменений не пережила завершение процесса');
      }
      await report.writeAsString(
        jsonEncode({
          ...expected,
          'reopen': true,
          'favoriteReopen': true,
          'outboxReopen': true,
          'filesReopen': true,
          'mutationsReopen': true,
        }),
      );
    } else {
      final record = await vault.load(origin);
      if (record != null) {
        final scope = await outboxScope(record);
        await LocalChatOutbox().change(scope, (_) => []);
        await QueuedFileStore().clear(scope);
        await const PlatformKeyStorage().delete(
          key: 'space.outbox.v1.${scope.id}',
        );
      }
      await LocalChatHistory().delete(origin);
      await vault.clearRotation(origin);
      if (await vault.loadRotation(origin) != null ||
          await vault.load(origin) == null) {
        throw StateError('Очистка журнала затронула active slot');
      }
      final key =
          'space.identity.v1.${url64((await Sha256().hash(utf8.encode(origin))).bytes)}';
      await const PlatformKeyStorage().delete(key: key);
      if (await vault.load(origin) != null) {
        throw StateError('Тестовый слот не удалён');
      }
      final expected = await report.exists()
          ? jsonDecode(await report.readAsString()) as Map<String, dynamic>
          : <String, dynamic>{};
      await report.writeAsString(jsonEncode({...expected, 'cleanup': true}));
    }
    exit(0);
  } catch (error, trace) {
    // Приватные данные и содержимое vault в отчёт не попадают.
    await File('${args[2]}.error')
        .writeAsString('Ошибка фазы ${args[0]}: ${error.runtimeType}\n$trace');
    exit(1);
  }
}

Future<OutboxScope> outboxScope(DeviceRecord record) async => OutboxScope(
  record.origin,
  record.serverId,
  (await record.identity()).principalId,
  record.grantId,
);
