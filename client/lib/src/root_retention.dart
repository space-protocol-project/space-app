import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'core.dart';
import 'local_failure.dart';
import 'rpc_clients.dart';

Never invalidRetention() => throw const LocalFailure(
  LocalFailureCode.identityInvalid,
  'Не удалось подтвердить сохранение доступа устройства при смене root',
);

Map<String, dynamic> retainedEntry(RetentionProof proof) => {
  'expires_at': proof.expiresAt.toInt(),
  'grant_id': proof.grantId,
  'public_key': url64(proof.publicKey),
  'scopes': proof.scopes.toList(),
};

Future<List<int>> _leaf(Map<String, dynamic> entry) async =>
    (await Sha256().hash([
      ...utf8.encode('space/root-retained/leaf/v1\u0000'),
      ...utf8.encode(jsonEncode(entry)),
    ])).bytes;

Future<List<int>> _node(List<int> left, List<int> right) async =>
    (await Sha256().hash([
      ...utf8.encode('space/root-retained/node/v1\u0000'),
      ...left,
      ...right,
    ])).bytes;

Future<List<int>> retainedDevicesHash(List<DeviceGrant> devices) async {
  if (devices.isEmpty || devices.length > 256) invalidRetention();
  var previous = '';
  var nodes = <List<int>>[];
  for (final d in devices) {
    validateRetainedDevice(d);
    if (d.id.compareTo(previous) <= 0) invalidRetention();
    previous = d.id;
    nodes.add(
      await _leaf({
        'expires_at': d.expiresAt.toInt(),
        'grant_id': d.id,
        'public_key': url64(d.publicKey),
        'scopes': d.scopes.toList(),
      }),
    );
  }
  while (nodes.length > 1) {
    final next = <List<int>>[];
    for (var i = 0; i < nodes.length; i += 2) {
      next.add(await _node(nodes[i], nodes[i + 1 < nodes.length ? i + 1 : i]));
    }
    nodes = next;
  }
  return _commitment(nodes.single, devices.length);
}

Future<void> verifyRetention(String root, RetentionProof proof) async {
  _checkRetentionFields(
    proof.grantId,
    proof.publicKey,
    proof.scopes,
    proof.expiresAt.toInt(),
  );
  var count = proof.count, index = proof.index, depth = 0;
  if (count < 1 ||
      count > 256 ||
      index >= count ||
      proof.publicKey.length != 32 ||
      !RegExp(r'^dg_[A-Za-z0-9_-]{43}$').hasMatch(proof.grantId)) {
    invalidRetention();
  }
  var node = await _leaf(retainedEntry(proof));
  while (count > 1) {
    if (depth >= proof.siblings.length) invalidRetention();
    final sibling = proof.siblings[depth++];
    if (sibling.length != 32 ||
        ((index ^ 1) >= count && url64(sibling) != url64(node))) {
      invalidRetention();
    }
    node = index.isEven
        ? await _node(node, sibling)
        : await _node(sibling, node);
    index ~/= 2;
    count = (count + 1) ~/ 2;
  }
  if (depth != proof.siblings.length ||
      url64(await _commitment(node, proof.count)) != root) {
    invalidRetention();
  }
}

Map<String, dynamic> lastRotation(DeviceRecord current) => jsonDecode(
  utf8.decode(
    base64Url.decode(
      base64Url.normalize(current.rootHistory.last['transcript'] as String),
    ),
  ),
) as Map<String, dynamic>;

Future<void> verifyRetainedGrant(
  DeviceRecord current,
  DeviceGrant grant,
) async {
  final t = lastRotation(current);
  if (t['v'] != 2 || !grant.hasRetentionProof()) invalidRetention();
  final proof = grant.retentionProof;
  if (proof.grantId != grant.id ||
      url64(proof.publicKey) != url64(grant.publicKey) ||
      proof.expiresAt != grant.expiresAt ||
      jsonEncode(proof.scopes) != jsonEncode(grant.scopes)) {
    invalidRetention();
  }
  await verifyRetention(t['retained_devices_hash'] as String, proof);
}

Future<List<int>> _commitment(List<int> root, int count) async =>
    (await Sha256().hash([
      ...utf8.encode('space/root-retained/root/v1\u0000'),
      (count >> 24) & 255,
      (count >> 16) & 255,
      (count >> 8) & 255,
      count & 255,
      ...root,
    ])).bytes;

void validateRetainedDevice(DeviceGrant device) => _checkRetentionFields(
  device.id,
  device.publicKey,
  device.scopes,
  device.expiresAt.toInt(),
);

void _checkRetentionFields(
  String id,
  List<int> key,
  List<String> scopes,
  int expiry,
) {
  final rights = jsonEncode(scopes);
  final workingRights =
      rights == '["chat.read","chat.write"]' ||
      rights == '["chat.read","chat.write","space.manage"]';
  if (!RegExp(r'^dg_[A-Za-z0-9_-]{43}$').hasMatch(id) ||
      key.length != 32 ||
      expiry < 1 ||
      expiry >= 9007199254740991 ||
      !workingRights) {
    invalidRetention();
  }
}
