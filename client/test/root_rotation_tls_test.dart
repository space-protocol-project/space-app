import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/root_rotation.dart' as rotation;
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/src/secure_vault.dart';

import 'root_rotation_test.dart' show FaultStorage;

class _RotationAuth extends AuthServiceClient {
  _RotationAuth(super.connection, this.record);
  final DeviceRecord record;

  @override
  Future<ListDevicesResponse> listDevices(
    ListDevicesRequest request, {
    RpcOptions? options,
  }) async => ListDevicesResponse(
    devices: [
      DeviceGrant(id: record.grantId, retainable: true, authEpoch: Int64(1)),
    ],
  );

  @override
  Future<CreateRootRotationResponse> createRootRotation(
    CreateRootRotationRequest request, {
    RpcOptions? options,
  }) async {
    final identity = await record.identity();
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final t = <String, dynamic>{
      'auth_epoch': 1,
      'challenge_id': 'rc_${'b' * 43}',
      'expires_at': now + 120,
      'issued_at': now,
      'new_device_public_key': url64(request.newDevicePublicKey),
      'new_root_public_key': url64(request.newRootPublicKey),
      'nonce': url64(List.filled(32, 4)),
      'old_root_public_key': url64(identity.publicKey),
      'operation_id': request.operationId,
      'origin': record.origin,
      'principal_id': identity.principalId,
      'purpose': 'identity.root.rotate',
      'scopes': ['chat.read', 'chat.write'],
      'server_id': record.serverId,
      'v': 1,
    };
    return CreateRootRotationResponse(
      challengeId: t['challenge_id'] as String,
      transcript: utf8.encode(jsonEncode(t)),
    );
  }
}

void main() {
  test('Смена root сохраняет TLS-отпечаток, адрес подключения и идентичность сервера', () async {
    final record = DeviceRecord(
      origin: 'https://space.example:8443',
      endpoint: 'https://127.0.0.1:8443',
      serverId: 'srv_${'a' * 32}',
      serverKey: url64(List.filled(32, 1)),
      tlsFingerprint: 'a' * 64,
      rootSeed: List.filled(32, 2),
      deviceSeed: List.filled(32, 3),
      grantId: 'dg_${'a' * 43}',
    );
    final server = Discovery(
      Uri.parse(record.origin),
      record.serverId,
      List.filled(32, 1),
      tlsFingerprint: record.tlsFingerprint,
    );
    final channel = server.openConnection();
    addTearDown(channel.shutdown);
    final vault = SecureIdentityVault(storage: FaultStorage());
    await vault.save(record);
    final pending = await rotation.prepareRootRotation(
      server,
      record,
      vault,
      _RotationAuth(channel, record),
      const RpcOptions(),
    );
    final next = DeviceRecord.fromJson(pending['next'] as Map<String, dynamic>);
    expect(next.tlsFingerprint, record.tlsFingerprint);
    expect(next.endpoint, record.endpoint);
    expect(next.serverKey, record.serverKey);
    expect(next.serverId, record.serverId);
    expect(
      (await next.identity()).principalId,
      (await record.identity()).principalId,
    );
    expect(next.rootSeed, isNot(record.rootSeed));
    checkTrust(server, next);
  });
}
