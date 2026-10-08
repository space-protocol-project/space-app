// Отдельная точка входа для проверки настоящего Windows secure storage.
// Production main.dart не содержит тестовых флагов или файлового fallback.
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/widgets.dart';
import 'package:space_client/src/core.dart';
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
      if (unreadable) throw StateError('Атомарная запись повредила прежний active slot');
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
      await report.writeAsString(jsonEncode({'digest': digest, 'write': true}));
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
      await report.writeAsString(jsonEncode({...expected, 'reopen': true}));
    } else {
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
      final expected =
          jsonDecode(await report.readAsString()) as Map<String, dynamic>;
      await report.writeAsString(jsonEncode({...expected, 'cleanup': true}));
    }
    exit(0);
  } catch (_) {
    // Приватные данные и содержимое vault в отчёт не попадают.
    await File('${args[2]}.error')
        .writeAsString('Ошибка фазы ${args[0]} системного vault');
    exit(1);
  }
}
