import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:grpc/grpc.dart';
import 'package:fixnum/fixnum.dart';

import 'core.dart';
import 'generated/space/v1/space.pbgrpc.dart';

Future<String> _digest(DeviceRecord record) async => url64(
  (await Sha256().hash(utf8.encode(jsonEncode(record.toJson())))).bytes,
);
List<int> _decode(String value) => base64Url.decode(base64Url.normalize(value));

// До вызова commit серверу журнал должен быть записан и прочитан обратно.
Future<Map<String, dynamic>> prepareRootRotation(
  Discovery server,
  DeviceRecord current,
  RotationJournalVault vault,
  AuthServiceClient auth,
  CallOptions options, {
  bool renew = false,
}) async {
  if (current.rootSeed.length != 32) {
    throw const FormatException('Для смены root нужен исходный корневой ключ');
  }
  checkTrust(server, current);
  final existing = await vault.loadRotation(current.origin);
  if (existing != null && !renew) {
    throw const FormatException('Сначала завершите предыдущую ротацию');
  }
  if (renew && existing == null) {
    throw const FormatException('Нет сохранённого запроса ротации');
  }
  final identity = await current.identity();
  if (current.rootHistory.length >= 16) {
    throw const FormatException(
      'Достигнут предел экспериментальной истории ключей',
    );
  }
  final algorithm = Ed25519();
  final oldRoot = await algorithm.newKeyPairFromSeed(current.rootSeed);
  final saved = existing == null
      ? null
      : DeviceRecord.fromJson(existing['next'] as Map<String, dynamic>);
  if (saved != null) {
    checkTrust(server, saved);
    final checked = await saved.identity();
    if (existing!['old_digest'] != await _digest(current) ||
        checked.principalId != identity.principalId ||
        checked.epoch != identity.epoch + 1 ||
        jsonEncode(
              saved.rootHistory.take(saved.rootHistory.length - 1).toList(),
            ) !=
            jsonEncode(current.rootHistory)) {
      throw const FormatException(
        'Сохранённая ротация относится к другой записи',
      );
    }
  }
  final newRoot = saved == null
          ? await algorithm.newKeyPair()
          : await algorithm.newKeyPairFromSeed(saved.rootSeed),
      device = saved == null
          ? await algorithm.newKeyPair()
          : await algorithm.newKeyPairFromSeed(saved.deviceSeed);
  final public = (await newRoot.extractPublicKey()).bytes;
  final devicePublic = (await device.extractPublicKey()).bytes;
  final operation = saved == null
      ? 'ro_${url64(List<int>.generate(32, (_) => Random.secure().nextInt(256)))}'
      : (jsonDecode(
              utf8.decode(
                _decode(saved.rootHistory.last['transcript'] as String),
              ),
            ) as Map<String, dynamic>)['operation_id']
            as String;
  final challenge = await auth.createRootRotation(
    CreateRootRotationRequest(
      profile: 'root-rotation-v1',
      operationId: operation,
      expectedAuthEpoch: Int64(identity.epoch),
      newRootPublicKey: public,
      newDevicePublicKey: devicePublic,
    ),
    options: options,
  );
  final raw = utf8.decode(challenge.transcript);
  final t = jsonDecode(raw) as Map<String, dynamic>;
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final expectedScopes = [
    'chat.read',
    'chat.write',
    if (current.administrative) 'space.manage',
  ];
  if (t['challenge_id'] != challenge.challengeId ||
      t['operation_id'] != operation ||
      t['principal_id'] != identity.principalId ||
      t['auth_epoch'] != identity.epoch ||
      t['old_root_public_key'] != url64(identity.publicKey) ||
      t['new_root_public_key'] != url64(public) ||
      t['new_device_public_key'] != url64(devicePublic) ||
      t['origin'] != current.origin ||
      t['server_id'] != current.serverId ||
      t['expires_at'] is! int ||
      t['expires_at'] <= now ||
      jsonEncode(t['scopes']) != jsonEncode(expectedScopes)) {
    throw const FormatException(
      'Запрос ротации не соответствует выбранной операции',
    );
  }
  final proof = <String, dynamic>{'transcript': url64(challenge.transcript)};
  for (final role in ['old', 'new']) {
    final signed = [
      ...utf8.encode('space/root.rotate/$role/v1\u0000'),
      ...challenge.transcript,
    ];
    proof['${role}_signature'] = url64(
      (await algorithm.sign(
        signed,
        keyPair: role == 'old' ? oldRoot : newRoot,
      )).bytes,
    );
  }
  final next = DeviceRecord(
    origin: current.origin,
    serverId: current.serverId,
    serverKey: current.serverKey,
    rootSeed: await newRoot.extractPrivateKeyBytes(),
    deviceSeed: await device.extractPrivateKeyBytes(),
    rootPublicKey: public,
    administrative: current.administrative,
    rootHistory: [...current.rootHistory, proof],
  );
  final nextIdentity = await next.identity();
  final recoverySize = utf8
      .encode(
        jsonEncode({
          'v': 2,
          'origin': next.origin,
          'server_id': next.serverId,
          'server_key': next.serverKey,
          'root_public_key': url64(public),
          'credential': 'root',
          'secret': url64(next.rootSeed),
          'root_history': next.rootHistory,
        }),
      )
      .length;
  if (recoverySize > 8176) {
    throw const FormatException(
      'История не помещается в recovery-карточку; смена не отправлена',
    );
  }
  if (nextIdentity.principalId != identity.principalId ||
      nextIdentity.epoch != identity.epoch + 1) {
    throw const FormatException('Ротация меняет идентичность');
  }
  final pending = <String, dynamic>{
    'v': 1,
    'old_digest': await _digest(current),
    'next': next.toJson(),
  };
  await vault.saveRotation(current.origin, pending);
  return pending;
}

Future<DeviceRecord?> finishRootRotation(
  Discovery server,
  RotationJournalVault vault,
  AuthServiceClient auth,
) async {
  final pending = await vault.loadRotation(server.origin.toString());
  if (pending == null) return null;
  if (pending['v'] != 1) {
    throw const FormatException('Неизвестный журнал ротации');
  }
  final next = DeviceRecord.fromJson(pending['next'] as Map<String, dynamic>);
  checkTrust(server, next);
  final identity = await next.identity();
  if (next.rootHistory.isEmpty || next.rootSeed.length != 32) {
    throw const FormatException('В журнале нет нового корневого ключа');
  }
  final proof = next.rootHistory.last;
  final raw = _decode(proof['transcript'] as String);
  final t = jsonDecode(utf8.decode(raw)) as Map<String, dynamic>;
  final device = await Ed25519().newKeyPairFromSeed(next.deviceSeed);
  if (url64((await device.extractPublicKey()).bytes) !=
      t['new_device_public_key']) {
    throw const FormatException('Журнал содержит другое устройство');
  }
  DeviceRecord? current;
  try {
    current = await vault.load(next.origin);
  } catch (_) {
    // Частично записанный active slot после commit восстанавливается из отдельного
    // защищённого журнала, только после проверки обеих подписей и receipt сервера.
    current = null;
  }
  if (current != null) {
    checkTrust(server, current);
  }
  final oldState =
      current == null || await _digest(current) == pending['old_digest'];
  final alreadyActivated =
      current != null &&
      current.grantId.isNotEmpty &&
      jsonEncode(current.rootHistory) == jsonEncode(next.rootHistory) &&
      url64(current.rootSeed) == url64(next.rootSeed) &&
      url64(current.deviceSeed) == url64(next.deviceSeed);
  if (!oldState && !alreadyActivated) {
    throw const FormatException(
      'Хранилище изменилось; автоматическая ротация остановлена',
    );
  }
  final receipt = await auth.completeRootRotation(
    CompleteRootRotationRequest(
      challengeId: t['challenge_id'] as String,
      oldSignature: _decode(proof['old_signature'] as String),
      newSignature: _decode(proof['new_signature'] as String),
    ),
    options: CallOptions(timeout: const Duration(seconds: 10)),
  );
  if (url64(receipt.transcript) != proof['transcript'] ||
      url64(receipt.oldSignature) != proof['old_signature'] ||
      url64(receipt.newSignature) != proof['new_signature'] ||
      receipt.principalId != identity.principalId ||
      receipt.authEpoch.toInt() != identity.epoch ||
      !RegExp(r'^dg_[A-Za-z0-9_-]{43}$').hasMatch(receipt.grantId) ||
      (alreadyActivated && receipt.grantId != current.grantId)) {
    throw const FormatException(
      'Ответ ротации не соответствует сохранённому доказательству',
    );
  }
  next.grantId = receipt.grantId;
  // Если запись или очистка завершатся ошибкой, журнал остаётся для повторного commit.
  await vault.save(next);
  await vault.clearRotation(next.origin);
  return next;
}
