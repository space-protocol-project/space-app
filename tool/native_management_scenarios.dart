import 'dart:io';
import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/pairing.dart';
import 'package:space_client/src/recovery_card.dart';
import 'package:space_client/src/recovery_qr.dart';
import 'package:space_client/src/root_rotation.dart';
import 'package:space_client/src/generated/space/v1/space.pbgrpc.dart';

class ScenarioVault implements IdentityVault {
  Map<String, dynamic>? data;
  @override
  Future<DeviceRecord?> load(String origin) async =>
      data == null ? null : DeviceRecord.fromJson(data!);
  @override
  Future<void> save(DeviceRecord record) async {
    data = record.toJson();
  }
}

class ScenarioStorage implements SecureKeyStorage {
  final values = <String, String>{};
  @override
  Future<String?> read({required String key}) async => values[key];
  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }
}

void require(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

Future<void> denied(Future<void> Function() action) async {
  try {
    await action();
  } on GrpcError catch (e) {
    require(
      [
        StatusCode.permissionDenied,
        StatusCode.unauthenticated,
      ].contains(e.code),
      'Неожиданная ошибка доступа',
    );
    return;
  }
  throw StateError('Сервер разрешил запрещённую операцию');
}

// Только CI: случайные тестовые ключи, без пользовательского vault и браузера.
Future<void> nativeManagementScenarios(SpaceSession owner) async {
  final server = owner.server, principal = owner.principalId;
  final http = HttpClient();
  try {
    for (final path in ['/space', '/space/', '/space/identity.mjs']) {
      final response = await (await http.getUrl(server.origin.resolve(path)))
          .close();
      require(
        response.statusCode == 404,
        'Сценарий должен выполняться без HTML-панели',
      );
      await response.drain<void>();
    }
  } finally {
    http.close(force: true);
  }
  final updates = StreamIterator(owner.watchChannelChanges());
  try {
    require(
      await updates.moveNext().timeout(const Duration(seconds: 5)),
      'Нет исходного каталога',
    );
    final watched = await owner.adminRequest(
      '/api/v1/channels',
      method: 'POST',
      body: {
        'channelId': 'native-watch',
        'title': 'До изменения',
        'viewType': 'chat',
        'position': 300,
      },
    );
    require(
      await updates.moveNext().timeout(const Duration(seconds: 5)),
      'Нет обновления нового канала',
    );
    final entry = owner.availableChannels.firstWhere(
      (c) => c.id == 'native-watch',
    );
    require(
      entry.title == 'До изменения',
      'Новый канал не появился автоматически',
    );
    await owner.adminRequest(
      '/api/v1/channels/native-watch',
      method: 'PATCH',
      body: {
        'title': 'После изменения',
        'position': 300,
        'archived': true,
        'publicPreview': false,
        'expectedRevision': (watched['channel'] as Map)['revision'],
      },
    );
    require(
      await updates.moveNext().timeout(const Duration(seconds: 5)),
      'Нет обновления метаданных',
    );
    final renamed = owner.availableChannels.firstWhere(
      (c) => c.id == 'native-watch',
    );
    require(
      renamed.title == 'После изменения' && renamed.archived,
      'Название или архив не обновились',
    );
  } finally {
    await updates.cancel();
  }
  final created = await owner.adminRequest(
    '/api/v1/channels',
    method: 'POST',
    body: {
      'channelId': 'native-check',
      'title': 'Native проверка',
      'viewType': 'chat',
      'position': 200,
    },
  );
  final channel = created['channel'] as Map;
  await owner.adminRequest(
    '/api/v1/channels/native-check/access',
    method: 'PUT',
    body: {'expectedRevision': channel['revision'], 'rules': []},
  );
  final invite = await owner.adminRequest(
    '/api/v1/space/invites',
    method: 'POST',
    body: {'role': 'member', 'ttlSeconds': 3600, 'maxUses': 1},
  );
  final guestVault = ScenarioVault();
  final guest = await SpaceSession.connect(
    server,
    guestVault,
    invitationToken: invite['token'] as String,
  );
  try {
    await guest.refreshChannels();
    require(
      !guest.availableChannels.any((c) => c.id == 'native-check'),
      'Приватный канал виден участнику без ACL',
    );
    await denied(() async {
      await guest.adminRequest('/api/v1/space/settings');
    });
    final members =
        (await owner.adminRequest('/api/v1/space/members'))['members'] as List;
    final member = members.cast<Map>().firstWhere(
      (m) => m['principalId'] == guest.principalId,
    );
    await owner.adminRequest(
      '/api/v1/space/members/${guest.principalId}',
      method: 'PATCH',
      body: {
        'role': 'member',
        'blocked': true,
        'expectedRevision': member['revision'],
      },
    );
    await denied(() async {
      await guest.messages();
    });
    await owner.adminRequest(
      '/api/v1/space/invites/${(invite['invite'] as Map)['id']}/revoke',
      method: 'POST',
      body: {},
    );
  } finally {
    await guest.close();
  }

  final payload = await owner.recoveryPayload();
  const password = 'Disposable native scenario password';
  final packet = await sealRecoveryCard(payload, password);
  final pngPacket = cardFromArtifact(recoveryPng(packet));
  require(packet == pngPacket, 'QR-карточка не прошла локальный round trip');
  var wrongPasswordDenied = false;
  try {
    await openRecoveryCard(pngPacket, 'Incorrect disposable password');
  } catch (_) {
    wrongPasswordDenied = true;
  }
  require(wrongPasswordDenied, 'Неверный пароль открыл карточку');
  final restoredRecord = await recordFromRecovery(
    await openRecoveryCard(pngPacket, password),
  );
  final restoredVault = KeyIdentityVault(ScenarioStorage());
  final restored = await SpaceSession.connect(
    server,
    restoredVault,
    restoredRecord: restoredRecord,
  );
  try {
    require(
      restored.principalId == principal && restored.role == 'owner',
      'Карточка потеряла identity или владение',
    );
    require(
      restored.currentGrantId != owner.currentGrantId,
      'Восстановление повторно использовало рабочий grant',
    );
    final pending = await PendingPairing.start(server);
    SpaceSession? paired;
    try {
      final pair = await inspectPairing(server, pending.request.code);
      final code = await restored.preparePairing(pair);
      final proposal = await pending.poll();
      final independent = await pairVerificationCode(
        server.serverId,
        pair.id,
        proposal.rootPublicKey,
        pair.publicKey,
      );
      require(code == independent, 'Независимые коды сопряжения не совпали');
      await restored.approvePairing(pair);
      final record = await pending.verifiedRecord(await pending.poll());
      require(
        record.rootSeed.isEmpty && record.recoverySeed.isEmpty,
        'Сопряжение скопировало управляющий секрет',
      );
      paired = await SpaceSession.connect(
        server,
        ScenarioVault(),
        restoredRecord: record,
        pairingId: pair.id,
      );
      pending.claimed = true;
      require(
        paired.principalId == principal,
        'Сопряжение создало другую identity',
      );
      final ownGrant = (await paired.listDevices()).firstWhere(
        (g) => g.id == paired!.currentGrantId,
      );
      await paired.revokeDevice(ownGrant);
      await denied(() async {
        await paired!.messages();
      });
    } finally {
      await paired?.close();
      await pending.close();
    }
    await restored.authorizeAdministration();
    await restored.prepareRotation();
    final next = await finishRootRotation(
      server,
      restoredVault,
      AuthServiceClient(restored.channel),
    );
    require(next != null, 'Ротация не завершилась');
    await denied(() async {
      await owner.messages();
    });
  } finally {
    await restored.close();
  }
  final reopened = await SpaceSession.connect(server, restoredVault);
  try {
    require(
      reopened.principalId == principal && reopened.role == 'owner',
      'Перезапуск после ротации потерял владение',
    );
    await reopened.adminRequest('/api/v1/space/settings');
    final nextPacket = await sealRecoveryCard(
      await reopened.recoveryPayload(),
      password,
    );
    final nextRecord = await recordFromRecovery(
      await openRecoveryCard(nextPacket, password),
    );
    require(
      (await nextRecord.identity()).principalId == principal,
      'Новая карточка изменила identity',
    );
  } finally {
    await reopened.close();
  }
  stdout.writeln(
    'Native без /space: ACL, приглашения, блокировка, QR recovery, pairing, self revoke, rotation и restart.',
  );
}
