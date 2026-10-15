import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/root_adoption.dart';
import 'package:space_client/src/root_device_proof.dart';
import 'package:space_client/src/root_retention.dart';
import 'package:space_client/src/rpc_clients.dart';

Future<(DeviceRecord, CreateChallengeResponse)> fixture() async {
  final algorithm = Ed25519();
  final root = await algorithm.newKeyPair(),
      next = await algorithm.newKeyPair(),
      device = await algorithm.newKeyPair(),
      source = await algorithm.newKeyPair();
  final oldPublic = (await root.extractPublicKey()).bytes;
  final public = (await device.extractPublicKey()).bytes;
  final nextPublic = (await next.extractPublicKey()).bytes;
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final grant = DeviceGrant(
    id: 'dg_${'a' * 43}',
    publicKey: public,
    scopes: ['chat.read', 'chat.write'],
    expiresAt: Int64(now + 86400),
  );
  final record = DeviceRecord(
    origin: 'http://127.0.0.1:8080',
    serverId: 'srv_${'b' * 32}',
    serverKey: url64(List.filled(32, 1)),
    rootSeed: await root.extractPrivateKeyBytes(),
    rootPublicKey: oldPublic,
    deviceSeed: await device.extractPrivateKeyBytes(),
    grantId: grant.id,
    mlsChannels: {'private': 'cGlu'},
    mlsIdentity: {'grant_id': grant.id},
  );
  final identity = await record.identity();
  final rotation = <String, dynamic>{
    'auth_epoch': 1,
    'challenge_id': 'rc_${'c' * 43}',
    'expires_at': now + 120,
    'issued_at': now,
    'new_device_public_key': url64((await source.extractPublicKey()).bytes),
    'new_root_public_key': url64(nextPublic),
    'nonce': url64(List.filled(32, 4)),
    'old_root_public_key': url64(oldPublic),
    'operation_id': 'ro_${'e' * 43}',
    'origin': record.origin,
    'principal_id': identity.principalId,
    'purpose': 'identity.root.rotate',
    'retained_devices_hash': url64(await retainedDevicesHash([grant])),
    'scopes': ['chat.read', 'chat.write'],
    'server_id': record.serverId,
    'v': 2,
  };
  final raw = utf8.encode(jsonEncode(rotation));
  final proof = RootHistoryProof(
    transcript: raw,
    oldSignature: (await algorithm.sign([
      ...utf8.encode('space/root.rotate/old/v2\u0000'),
      ...raw,
    ], keyPair: root)).bytes,
    newSignature: (await algorithm.sign([
      ...utf8.encode('space/root.rotate/new/v2\u0000'),
      ...raw,
    ], keyPair: next)).bytes,
  );
  final challenge = CreateChallengeResponse(
    transcript: utf8.encode(
      jsonEncode({
        'auth_epoch': 2,
        'root_public_key': url64(nextPublic),
        'grant_id': grant.id,
        'device_public_key': url64(public),
        'scopes': grant.scopes.toList(),
        'grant_expires_at': grant.expiresAt.toInt(),
      }),
    ),
    rootHistory: [proof],
    retentionProof: RetentionProof(
      grantId: grant.id,
      publicKey: public,
      scopes: grant.scopes,
      expiresAt: grant.expiresAt,
      count: 1,
    ),
  );
  return (record, challenge);
}

class _DeviceList extends AuthServiceClient {
  _DeviceList(super.connection, this.devices);
  final List<DeviceGrant> devices;
  @override
  Future<ListDevicesResponse> listDevices(
    ListDevicesRequest request, {
    RpcOptions? options,
  }) async => ListDevicesResponse(devices: devices);
}

void main() {
  test('Сохранённое устройство принимает подписанный root и сохраняет MLS, удаляя старые полномочия', () async {
    final (record, challenge) = await fixture();
    final next = await adoptRetainedRoot(record, challenge);
    expect(next.rootSeed, isEmpty);
    expect(next.recoverySeed, isEmpty);
    expect(next.deviceSeed, record.deviceSeed);
    expect(next.grantId, record.grantId);
    expect(next.mlsChannels, record.mlsChannels);
    expect(next.mlsIdentity, record.mlsIdentity);
    expect((await next.identity()).epoch, 2);
    expect(record.rootSeed, hasLength(32));
  });
  test('Подмена цепочки, устройства, прав, срока и отсутствие доказательств отклоняются', () async {
    final (record, original) = await fixture();
    for (final mutate in <void Function(CreateChallengeResponse)>[
      (p) => p.rootHistory.clear(),
      (p) => p.rootHistory.first.oldSignature[0] ^= 1,
      (p) => p.rootHistory.first.newSignature[0] ^= 1,
      (p) => p.clearRetentionProof(),
      (p) => p.retentionProof.grantId = 'dg_${'b' * 43}',
      (p) => p.retentionProof.publicKey[0] ^= 1,
      (p) => p.retentionProof.scopes.add('space.manage'),
      (p) => p.retentionProof.expiresAt += 1,
    ]) {
      final copy = CreateChallengeResponse.fromBuffer(original.writeToBuffer());
      mutate(copy);
      await expectLater(adoptRetainedRoot(record, copy), throwsException);
    }
    final next = await adoptRetainedRoot(record, original);
    final rollback = CreateChallengeResponse.fromBuffer(
      original.writeToBuffer(),
    );
    final t =
        jsonDecode(utf8.decode(rollback.transcript)) as Map<String, dynamic>;
    t['auth_epoch'] = 1;
    rollback.transcript = utf8.encode(jsonEncode(t));
    await expectLater(adoptRetainedRoot(next, rollback), throwsException);
  });
  test(
    'Сервер не может дописать неподписанное устройство в сохраняемый список',
    () async {
      final (record, _) = await fixture();
      final identity = await record.identity();
      final device = await Ed25519().newKeyPair();
      final public = (await device.extractPublicKey()).bytes;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final t = <String, dynamic>{
        'auth_epoch': 1,
        'challenge_id': 'ac_${'c' * 43}',
        'device_public_key': url64(public),
        'expires_at': now + 60,
        'grant_expires_at': now + 30 * 86400,
        'grant_id': 'dg_${'d' * 43}',
        'issued_at': now,
        'nonce': url64(List.filled(32, 2)),
        'origin': record.origin,
        'principal_id': identity.principalId,
        'purpose': 'device.register',
        'root_public_key': url64(identity.publicKey),
        'scopes': ['chat.read', 'chat.write'],
        'server_id': record.serverId,
        'v': 1,
      };
      final raw = utf8.encode(jsonEncode(t));
      final root = await Ed25519().newKeyPairFromSeed(record.rootSeed);
      final signature = (await Ed25519().sign([
        ...utf8.encode('space/device-register/v1\u0000'),
        ...raw,
      ], keyPair: root)).bytes;
      final d = DeviceGrant(
        id: t['grant_id'] as String,
        publicKey: public,
        scopes: ['chat.read', 'chat.write'],
        expiresAt: Int64(now + 30 * 86400),
        registrationTranscript: raw,
        signature: signature,
        signatureKind: 'root',
      );
      final server = Discovery(
        Uri.parse(record.origin),
        record.serverId,
        List.filled(32, 1),
      );
      await verifyDeviceForRetention(server, record, d);
      final forged = DeviceGrant.fromBuffer(d.writeToBuffer())
        ..publicKey = List.filled(32, 7);
      await expectLater(
        verifyDeviceForRetention(server, record, forged),
        throwsException,
      );
      final elevated = DeviceGrant.fromBuffer(d.writeToBuffer())
        ..scopes.add('space.manage');
      await expectLater(
        verifyDeviceForRetention(server, record, elevated),
        throwsException,
      );
    },
  );
  test('Сервер без нового доказуемого списка не вызывает откат к отзыву всех устройств', () async {
    final (record, _) = await fixture();
    final server = Discovery(
      Uri.parse(record.origin),
      record.serverId,
      List.filled(32, 1),
    );
    final channel = server.openConnection();
    addTearDown(channel.shutdown);
    final source = DeviceGrant(
      id: record.grantId,
      retainable: true,
      authEpoch: Int64(1),
    );
    expect(
      await verifiedRetainedDevices(
        server,
        record,
        _DeviceList(channel, [source]),
        const RpcOptions(),
      ),
      isEmpty,
    );
    await expectLater(
      verifiedRetainedDevices(
        server,
        record,
        _DeviceList(channel, []),
        const RpcOptions(),
      ),
      throwsException,
    );
    source.retainable = false;
    await expectLater(
      verifiedRetainedDevices(
        server,
        record,
        _DeviceList(channel, [source]),
        const RpcOptions(),
      ),
      throwsException,
    );
  });
  test(
    'Порядок полей proof после экспорта не разрывает закреплённую историю',
    () {
      final known = <String, dynamic>{
        'new_signature': 'new',
        'old_signature': 'old',
        'transcript': 'raw',
      };
      final next = <String, dynamic>{
        'transcript': 'raw',
        'old_signature': 'old',
        'new_signature': 'new',
      };
      expect(hasKnownRootHistoryPrefix([next], [known]), isTrue);
      expect(
        hasKnownRootHistoryPrefix(
          [next],
          [
            {...known, 'new_signature': 'forged'},
          ],
        ),
        isFalse,
      );
      expect(hasKnownRootHistoryPrefix([], [known]), isFalse);
    },
  );
}
