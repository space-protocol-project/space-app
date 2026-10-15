import 'local_failure.dart';

import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

import 'package:fixnum/fixnum.dart';

import 'core.dart';
import 'root_history.dart';
import 'root_retention.dart';
import 'root_device_proof.dart';
import 'rpc_clients.dart';

Future<String> _digest(DeviceRecord record) async {
  // Смена маршрута не меняет ключи и не отменяет подготовленную ротацию.
  final identity = record.toJson()
    ..remove('endpoint')
    ..remove('endpoints')
    ..remove('endpointRevision')
    ..remove('endpointDigest')
    ..remove('mlsChannels')
    ..remove('mlsIdentity');
  return url64((await Sha256().hash(utf8.encode(jsonEncode(identity)))).bytes);
}

List<int> _decode(String value) => base64Url.decode(base64Url.normalize(value));

// До вызова commit серверу журнал должен быть записан и прочитан обратно.
Future<Map<String, dynamic>> prepareRootRotation(
  Discovery server,
  DeviceRecord current,
  RotationJournalVault vault,
  AuthServiceClient auth,
  RpcOptions options, {
  bool renew = false,
  List<DeviceGrant>? retainedDevices,
}) async {
  if (current.rootSeed.length != 32) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Для смены root нужен исходный корневой ключ',
    );
  }
  checkTrust(server, current);
  final existing = await vault.loadRotation(current.origin);
  if (existing != null && !renew) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Сначала завершите предыдущую ротацию',
    );
  }
  if (renew && existing == null) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Нет сохранённого запроса ротации',
    );
  }
  final identity = await current.identity();
  if (current.rootHistory.length >= 16) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Достигнут предел экспериментальной истории ключей',
    );
  }
  final algorithm = Ed25519();
  final oldRoot = await algorithm.newKeyPairFromSeed(current.rootSeed);
  final saved = existing == null
      ? null
      : DeviceRecord.fromJson(existing['next'] as Map<String, dynamic>);
  if (saved != null) {
    await _validateSavedRotation(server, saved, current, existing!, identity);
  }
  final newRoot = saved == null
          ? await algorithm.newKeyPair()
          : await algorithm.newKeyPairFromSeed(saved.rootSeed),
      device = saved == null
          ? await algorithm.newKeyPair()
          : await algorithm.newKeyPairFromSeed(saved.deviceSeed);
  final public = (await newRoot.extractPublicKey()).bytes;
  final devicePublic = (await device.extractPublicKey()).bytes;
  final operation = _rotationOperation(saved);
  final retained = await verifiedRetainedDevices(
    server,
    current,
    auth,
    options,
  );
  final retentionHash = retained.isEmpty
      ? <int>[]
      : await retainedDevicesHash(retained);
  await _checkReviewedDevices(retainedDevices, retentionHash);
  final version = retained.isEmpty ? 1 : 2;
  final challenge = await auth.createRootRotation(
    CreateRootRotationRequest(
      profile: 'root-rotation-v$version',
      retainedGrantIds: retained.map((d) => d.id),
      retainedDevicesHash: retentionHash,
      operationId: operation,
      expectedAuthEpoch: Int64(identity.epoch),
      newRootPublicKey: public,
      newDevicePublicKey: devicePublic,
    ),
    options: options,
  );
  final raw = utf8.decode(challenge.transcript);
  final t = jsonDecode(raw) as Map<String, dynamic>;
  _validateRotationChallenge(
    t,
    challenge,
    operation,
    identity,
    current,
    public,
    devicePublic,
  );
  if (t['v'] != version ||
      (t['retained_devices_hash'] ?? '') != url64(retentionHash)) {
    invalidRetention();
  }
  final proof = await _signedRotationProof(
    challenge,
    version,
    oldRoot,
    newRoot,
  );
  final next = DeviceRecord(
    origin: current.origin,
    endpoint: current.endpoint,
    endpoints: current.endpoints,
    endpointRevision: current.endpointRevision,
    endpointDigest: current.endpointDigest,
    serverId: current.serverId,
    serverKey: current.serverKey,
    tlsFingerprint: current.tlsFingerprint,
    rootSeed: await newRoot.extractPrivateKeyBytes(),
    deviceSeed: await device.extractPrivateKeyBytes(),
    rootPublicKey: public,
    administrative: current.administrative,
    rootHistory: [...current.rootHistory, proof],
    mlsChannels: current.mlsChannels,
    mlsIdentity: current.mlsIdentity,
  );
  await _verifyPreparedRotation(next, identity, public);
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
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Неизвестный журнал ротации',
    );
  }
  final next = DeviceRecord.fromJson(pending['next'] as Map<String, dynamic>);
  checkTrust(server, next);
  rememberServerRoute(next, server);
  final identity = await next.identity();
  if (next.rootHistory.isEmpty || next.rootSeed.length != 32) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'В журнале нет нового корневого ключа',
    );
  }
  final proof = next.rootHistory.last;
  final raw = _decode(proof['transcript'] as String);
  final t = jsonDecode(utf8.decode(raw)) as Map<String, dynamic>;
  final device = await Ed25519().newKeyPairFromSeed(next.deviceSeed);
  if (url64((await device.extractPublicKey()).bytes) !=
      t['new_device_public_key']) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Журнал содержит другое устройство',
    );
  }
  final current = await _currentRotationRecord(server, vault, next);
  final oldState =
      current == null || await _digest(current) == pending['old_digest'];
  final alreadyActivated =
      current != null &&
      current.grantId.isNotEmpty &&
      jsonEncode(current.rootHistory) == jsonEncode(next.rootHistory) &&
      url64(current.rootSeed) == url64(next.rootSeed) &&
      url64(current.deviceSeed) == url64(next.deviceSeed);
  if (!oldState && !alreadyActivated) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Хранилище изменилось; автоматическая ротация остановлена',
    );
  }
  final receipt = await auth.completeRootRotation(
    CompleteRootRotationRequest(
      challengeId: t['challenge_id'] as String,
      oldSignature: _decode(proof['old_signature'] as String),
      newSignature: _decode(proof['new_signature'] as String),
    ),
    options: RpcOptions(timeout: const Duration(seconds: 10)),
  );
  if (url64(receipt.transcript) != proof['transcript'] ||
      url64(receipt.oldSignature) != proof['old_signature'] ||
      url64(receipt.newSignature) != proof['new_signature'] ||
      receipt.principalId != identity.principalId ||
      receipt.authEpoch.toInt() != identity.epoch ||
      !RegExp(r'^dg_[A-Za-z0-9_-]{43}$').hasMatch(receipt.grantId) ||
      (alreadyActivated && receipt.grantId != current.grantId)) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Ответ ротации не соответствует сохранённому доказательству',
    );
  }
  next.grantId = receipt.grantId;
  next.mlsChannels.addAll(current?.mlsChannels ?? {});
  next.mlsIdentity ??= current?.mlsIdentity;
  // Если запись или очистка завершатся ошибкой, журнал остаётся для повторного commit.
  await vault.save(next);
  await vault.clearRotation(next.origin);
  return next;
}

void _validateRotationChallenge(
  Map<String, dynamic> t,
  CreateRootRotationResponse challenge,
  String operation,
  RootIdentity identity,
  DeviceRecord current,
  List<int> public,
  List<int> devicePublic,
) {
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
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Запрос ротации не соответствует выбранной операции',
    );
  }
}

Future<DeviceRecord?> _currentRotationRecord(
  Discovery server,
  RotationJournalVault vault,
  DeviceRecord next,
) async {
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
  return current;
}

Future<void> _verifyPreparedRotation(
  DeviceRecord next,
  RootIdentity identity,
  List<int> public,
) async {
  final nextIdentity = await next.identity();
  final recoverySize = utf8
      .encode(
        jsonEncode({
          'v': 2,
          'origin': next.origin,
          'endpoint': next.connectionAddress,
          if (next.tlsFingerprint.isNotEmpty)
            'tls_fingerprint': next.tlsFingerprint,
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
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'История не помещается в recovery-карточку; смена не отправлена',
    );
  }
  if (nextIdentity.principalId != identity.principalId ||
      nextIdentity.epoch != identity.epoch + 1) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Ротация меняет идентичность',
    );
  }
}

Future<void> _validateSavedRotation(
  Discovery server,
  DeviceRecord saved,
  DeviceRecord current,
  Map<String, dynamic> existing,
  RootIdentity identity,
) async {
  checkTrust(server, saved);
  final checked = await saved.identity();
  if (existing['old_digest'] != await _digest(current) ||
      checked.principalId != identity.principalId ||
      checked.epoch != identity.epoch + 1 ||
      jsonEncode(
            saved.rootHistory.take(saved.rootHistory.length - 1).toList(),
          ) !=
          jsonEncode(current.rootHistory)) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Сохранённая ротация относится к другой записи',
    );
  }
}

Future<Map<String, dynamic>> _signedRotationProof(
  CreateRootRotationResponse challenge,
  int version,
  KeyPair oldRoot,
  KeyPair newRoot,
) async {
  final algorithm = Ed25519();
  final proof = <String, dynamic>{'transcript': url64(challenge.transcript)};
  for (final role in ['old', 'new']) {
    final signed = [
      ...utf8.encode('space/root.rotate/$role/v$version\u0000'),
      ...challenge.transcript,
    ];
    proof['${role}_signature'] = url64(
      (await algorithm.sign(
        signed,
        keyPair: role == 'old' ? oldRoot : newRoot,
      )).bytes,
    );
  }
  return proof;
}

String _rotationOperation(DeviceRecord? saved) {
  return saved == null
      ? 'ro_${url64(List<int>.generate(32, (_) => Random.secure().nextInt(256)))}'
      : (jsonDecode(
              utf8.decode(
                _decode(saved.rootHistory.last['transcript'] as String),
              ),
            ) as Map<String, dynamic>)['operation_id']
            as String;
}

Future<void> _checkReviewedDevices(
  List<DeviceGrant>? reviewed,
  List<int> currentHash,
) async {
  if (reviewed == null) return;
  final hash = reviewed.isEmpty ? <int>[] : await retainedDevicesHash(reviewed);
  if (url64(hash) != url64(currentHash)) invalidRetention();
}
