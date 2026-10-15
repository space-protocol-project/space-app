import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'core.dart';
import 'root_retention.dart';
import 'rpc_clients.dart';

// Обновляется только публичная цепочка доверия. MLS-состояние и ключ устройства остаются прежними.
Future<DeviceRecord> adoptRetainedRoot(
  DeviceRecord current,
  CreateChallengeResponse challenge,
) async {
  final old = await current.identity();
  final t =
      jsonDecode(utf8.decode(challenge.transcript)) as Map<String, dynamic>;
  if (t['auth_epoch'] == old.epoch) return current;
  final history = challenge.rootHistory
      .map(
        (p) => <String, dynamic>{
          'transcript': url64(p.transcript),
          'old_signature': url64(p.oldSignature),
          'new_signature': url64(p.newSignature),
        },
      )
      .toList();
  if (history.length <= current.rootHistory.length ||
      history.length > 16 ||
      !hasKnownRootHistoryPrefix(history, current.rootHistory)) {
    invalidRetention();
  }
  final firstNew = jsonDecode(
    utf8.decode(
      base64Url.decode(
        base64Url.normalize(
          history[current.rootHistory.length]['transcript'] as String,
        ),
      ),
    ),
  ) as Map<String, dynamic>;
  if (firstNew['old_root_public_key'] != url64(old.publicKey)) {
    invalidRetention();
  }
  final newRoot = base64Url.decode(
    base64Url.normalize(t['root_public_key'] as String),
  );
  final next = DeviceRecord.fromJson({
    ...current.toJson(),
    'rootSeed': '',
    'recoverySeed': '',
    'recoveryGrantId': '',
    'rootPublicKey': url64(newRoot),
    'rootHistory': history,
  });
  final identity = await next.identity();
  if (identity.principalId != old.principalId ||
      identity.epoch <= old.epoch ||
      identity.epoch != t['auth_epoch'] ||
      !challenge.hasRetentionProof()) {
    invalidRetention();
  }
  final key = await Ed25519().newKeyPairFromSeed(current.deviceSeed);
  final public = (await key.extractPublicKey()).bytes;
  final proof = challenge.retentionProof;
  final scopes = [
    'chat.read',
    'chat.write',
    if (current.administrative) 'space.manage',
  ];
  if (proof.grantId != current.grantId ||
      t['grant_id'] != current.grantId ||
      url64(proof.publicKey) != url64(public) ||
      t['device_public_key'] != url64(public) ||
      proof.expiresAt.toInt() != t['grant_expires_at'] ||
      jsonEncode(proof.scopes) != jsonEncode(scopes) ||
      jsonEncode(t['scopes']) != jsonEncode(scopes)) {
    invalidRetention();
  }
  final grant = DeviceGrant(
    id: current.grantId,
    publicKey: public,
    scopes: scopes,
    expiresAt: proof.expiresAt,
    retentionProof: proof,
  );
  await verifyRetainedGrant(next, grant);
  return next;
}

// Порядок полей оболочки может меняться при экспорте; подписанные байты не меняются.
bool hasKnownRootHistoryPrefix(
  List<Map<String, dynamic>> history,
  List<Map<String, dynamic>> known,
) {
  if (history.length < known.length) return false;
  for (var i = 0; i < known.length; i++) {
    for (final field in ['transcript', 'old_signature', 'new_signature']) {
      if (history[i][field] != known[i][field]) return false;
    }
  }
  return true;
}
