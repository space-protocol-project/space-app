import 'dart:convert';
import 'dart:io';

import 'package:space_client/src/core.dart';
import 'package:space_client/src/recovery_card.dart';
import 'package:space_client/src/recovery_qr.dart';

class RecoveryTestVault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async {
    record = DeviceRecord.fromJson(value.toJson());
  }
}

void check(bool value, String message) {
  if (!value) throw StateError(message);
}

Future<void> main(List<String> args) async {
  if (args.length == 4 && args[0] == '--reopen') {
    final vault = RecoveryTestVault()
      ..record = DeviceRecord.fromJson(
        jsonDecode(await File(args[1]).readAsString()) as Map<String, dynamic>,
      );
    check(
      vault.record!.rootSeed.isEmpty && vault.record!.recoverySeed.isEmpty,
      'Запись после перезапуска содержит управляющий секрет',
    );
    final server = await discover(args[2]);
    checkTrust(server, vault.record!);
    final expectedGrantId = vault.record!.grantId;
    final session = await SpaceSession.connect(server, vault);
    try {
      check(session.principalId == args[3], 'Перезапуск изменил principal');
      check(session.role == 'owner', 'Перезапуск изменил роль');
      check(
        session.currentGrantId == expectedGrantId,
        'Перезапуск создал другое разрешение',
      );
      await session.messages();
    } finally {
      await session.close();
    }
    stdout.writeln(
      'Dart: новый процесс сохранил principal, owner и рабочий grant.',
    );
    return;
  }
  if (args.length != 3) {
    throw ArgumentError(
      'Нужны тестовая карточка, пароль и ожидаемый principal',
    );
  }
  final payload = await openRecoveryCard(
    cardFromArtifact(await File(args[0]).readAsBytes()),
    args[1],
  );
  final record = await recordFromRecovery(payload);
  final nativePacket = await sealRecoveryCard(payload, args[1]);
  await File('${args[0]}.dart.json').writeAsString(nativePacket);
  await File('${args[0]}.dart.png').writeAsBytes(recoveryPng(nativePacket));
  final server = await discover(record.origin);
  checkTrust(server, record);
  final vault = RecoveryTestVault();
  final session = await SpaceSession.connect(
    server,
    vault,
    restoredRecord: record,
  );
  try {
    check(
      session.principalId == args[2],
      'Идентичность после восстановления изменилась',
    );
    check(session.role == 'owner', 'Роль владельца потеряна');
    check(session.canManageSpace, 'Управление не доступно владельцу');
    final adminIdentity = await session.adminIdentity();
    check(
      adminIdentity['principalId'] == session.principalId,
      'Управление создало другую identity',
    );
    final adminSettings = await session.adminRequest('/api/v1/space/settings');
    final values = adminSettings['settings'] as Map;
    await session.adminRequest(
      '/api/v1/space/settings',
      method: 'PATCH',
      body: {
        'title': values['title'],
        'chatTitle': values['chatTitle'],
        'chatEnabled': values['chatEnabled'] ?? false,
        'registrationPolicy': values['registrationPolicy'],
        'expectedRevision': values['revision'],
      },
    );

    check(
      vault.record!.rootSeed.isEmpty && vault.record!.recoverySeed.isEmpty,
      'Рабочее устройство сохранило управляющий секрет',
    );
    final channelId =
        'native-admin-${newRequestKey().toLowerCase().replaceAll('_', 'a').replaceAll('-', 'b')}';
    final made = await session.adminRequest(
      '/api/v1/channels',
      method: 'POST',
      body: {
        'channelId': channelId,
        'title': 'Проверка управления из приложения',
        'position': 100,
        'viewType': 'chat',
      },
    );
    final channelMap = made['channel'] as Map;
    final acl = await session.adminRequest(
      '/api/v1/channels/$channelId/access',
    );
    final privateAcl = await session.adminRequest(
      '/api/v1/channels/$channelId/access',
      method: 'PUT',
      body: {'expectedRevision': acl['revision'], 'rules': []},
    );
    await session.adminRequest(
      '/api/v1/channels/$channelId',
      method: 'PATCH',
      body: {
        'title': channelMap['title'],
        'position': 100,
        'archived': true,
        'publicPreview': false,
        'expectedRevision': privateAcl['revision'],
      },
    );
    final allChannels = await session.adminRequest(
      '/api/v1/channels?includeArchived=true',
    );
    check(
      (allChannels['channels'] as List).any(
        (c) => c['id'] == channelId && c['archived'] == true,
      ),
      'Архив канала не сохранён',
    );
    check(
      (await session.adminRequest('/api/v1/space/members'))
          .containsKey('members'),
      'Нет списка участников для правил',
    );
    final grants = await session.listDevices();
    check(
      grants.any(
        (g) =>
            g.id == session.currentGrantId &&
            g.parentGrantId == payload['recovery_grant_id'],
      ),
      'Нет ссылки на recovery grant',
    );
    await session.messages();
  } finally {
    await session.close();
  }
  final restartPath = '${args[0]}.working-device.json';
  await File(restartPath).writeAsString(jsonEncode(vault.record!.toJson()));
  final restart = await Process.run(Platform.resolvedExecutable, [
    'run',
    'tool/recovery_interoperability.dart',
    '--reopen',
    restartPath,
    record.origin,
    args[2],
  ]);
  check(
    restart.exitCode == 0,
    'Проверка нового процесса не прошла: ${restart.stderr}',
  );
  stdout.write(restart.stdout);
  final reopened = await SpaceSession.connect(server, vault);
  try {
    check(
      reopened.principalId == args[2],
      'Повторный вход не сохранил идентичность',
    );
    await reopened.revoke();
    var denied = false;
    try {
      await reopened.messages();
    } catch (_) {
      denied = true;
    }
    check(denied, 'Отозванное устройство продолжает работать');
  } finally {
    await reopened.close();
  }
  stdout.writeln(
    'Dart/WebCrypto/Go: карточка совместима, owner сохранён, управляющий секрет не сохранён, повторный вход и отзыв — успешно.',
  );
}
