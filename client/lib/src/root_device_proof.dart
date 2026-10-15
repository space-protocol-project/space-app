import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'core.dart';
import 'root_retention.dart';
import 'rpc_clients.dart';

Future<List<DeviceGrant>> verifiedRetainedDevices(
  Discovery server,
  DeviceRecord current,
  AuthServiceClient auth,
  RpcOptions options,
) async {
  final identity = await current.identity();
  final devices = (await auth.listDevices(
    ListDevicesRequest(),
    options: options,
  )).devices;
  _requireSourceDevice(devices, current, identity.epoch);
  final selected = <DeviceGrant>[];
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  for (final d in devices) {
    if (d.id == current.grantId || !d.retainable) continue;
    if (d.revoked ||
        d.recovery ||
        d.expiresAt.toInt() <= now ||
        d.authEpoch.toInt() != identity.epoch ||
        d.publicKey.length != 32) {
      invalidRetention();
    }
    validateRetainedDevice(d);
    await verifyDeviceForRetention(server, current, d);
    selected.add(d);
  }
  selected.sort((a, b) => a.id.compareTo(b.id));
  if (selected.length > 256) invalidRetention();
  return selected;
}

Future<void> verifyDeviceForRetention(
  Discovery server,
  DeviceRecord current,
  DeviceGrant d,
) async {
  switch (d.signatureKind) {
    case 'retained':
      if (current.rootHistory.isEmpty) invalidRetention();
      await verifyRetainedGrant(current, d);
    case 'rotation':
      await _verifyRotationDevice(current, d);
    case 'root':
    case 'recovery':
      await _verifyRegistration(server, current, d);
    default:
      invalidRetention();
  }
}

Future<void> _verifyRotationDevice(DeviceRecord current, DeviceGrant d) async {
  if (current.rootHistory.isEmpty) invalidRetention();
  final proof = current.rootHistory.last;
  final t = lastRotation(current);
  if (url64(d.registrationTranscript) != proof['transcript'] ||
      url64(d.signature) != proof['new_signature'] ||
      url64(d.publicKey) != t['new_device_public_key'] ||
      jsonEncode(d.scopes) != jsonEncode(t['scopes']) ||
      d.expiresAt.toInt() < (t['issued_at'] as int) ||
      d.expiresAt.toInt() > (t['expires_at'] as int) + 30 * 86400) {
    invalidRetention();
  }
}

Future<void> _verifyRegistration(
  Discovery server,
  DeviceRecord current,
  DeviceGrant d,
) async {
  final identity = await current.identity();
  final t =
      jsonDecode(utf8.decode(d.registrationTranscript)) as Map<String, dynamic>;
  if (t['grant_id'] != d.id || t['grant_expires_at'] != d.expiresAt.toInt()) {
    invalidRetention();
  }
  var signer = identity.publicKey;
  final delegated = d.signatureKind == 'recovery';
  if (delegated) signer = await _verifyParent(server, current, d, t);
  final bytes = await checkedSigningBytes(
    CreateChallengeResponse(
      challengeId: t['challenge_id'] as String,
      transcript: d.registrationTranscript,
    ),
    server,
    identity.publicKey,
    d.publicKey,
    delegated ? 'device.delegate' : 'device.register',
    '',
    expectedScopes: d.scopes,
    authorizerGrantId: delegated ? d.parentGrantId : '',
    pairingId: t['pairing_id'] as String? ?? '',
    allowHistorical: true,
    expectedPrincipal: identity.principalId,
    expectedEpoch: identity.epoch,
  );
  await _signature(bytes, d.signature, signer);
}

Future<List<int>> _verifyParent(
  Discovery server,
  DeviceRecord current,
  DeviceGrant d,
  Map<String, dynamic> child,
) async {
  final identity = await current.identity();
  final t = jsonDecode(utf8.decode(d.parentTranscript)) as Map<String, dynamic>;
  final scopes = (t['scopes'] as List).cast<String>();
  if (t['grant_id'] != d.parentGrantId ||
      child['authorizer_grant_id'] != d.parentGrantId ||
      !scopes.contains('identity.recover') ||
      (d.scopes.contains('space.manage') && !scopes.contains('space.manage')) ||
      (t['issued_at'] as int) > (child['issued_at'] as int) + 5 ||
      (t['grant_expires_at'] as int) < d.expiresAt.toInt()) {
    invalidRetention();
  }
  final key = base64Url.decode(
    base64Url.normalize(t['device_public_key'] as String),
  );
  final bytes = await checkedSigningBytes(
    CreateChallengeResponse(
      challengeId: t['challenge_id'] as String,
      transcript: d.parentTranscript,
    ),
    server,
    identity.publicKey,
    key,
    'device.register',
    '',
    expectedScopes: scopes,
    allowHistorical: true,
    registrationDays: 3650,
    expectedPrincipal: identity.principalId,
    expectedEpoch: identity.epoch,
  );
  await _signature(bytes, d.parentSignature, identity.publicKey);
  return key;
}

Future<void> _signature(
  List<int> bytes,
  List<int> signature,
  List<int> key,
) async {
  if (signature.length != 64 ||
      !await Ed25519().verify(
        bytes,
        signature: Signature(
          signature,
          publicKey: SimplePublicKey(key, type: KeyPairType.ed25519),
        ),
      )) {
    invalidRetention();
  }
}

void _requireSourceDevice(
  List<DeviceGrant> devices,
  DeviceRecord current,
  int epoch,
) {
  final source = devices.where((d) => d.id == current.grantId).toList();
  if (source.length != 1 ||
      !source.single.retainable ||
      source.single.authEpoch.toInt() != epoch) {
    invalidRetention();
  }
}
