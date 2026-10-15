import 'server_endpoints.dart';

import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'local_failure.dart';

Future<Uri> verifiedIdentityOrigin(
  Map<String, dynamic> discovery,
  Uri endpoint,
  String fingerprint,
  List<int> serverKey,
) async {
  final value = discovery['identity_origin'];
  if (value == null) return endpoint;
  try {
    final origin = Uri.parse(value as String);
    if (origin.scheme != 'https' ||
        origin.host.isEmpty ||
        origin.userInfo.isNotEmpty ||
        origin.path.isNotEmpty ||
        origin.hasQuery ||
        origin.hasFragment ||
        (discovery['endpoints'] == null &&
            discovery['network_origin'] != endpoint.toString()) ||
        discovery['tls_fingerprint'] != fingerprint ||
        !RegExp(r'^[0-9a-f]{64}$').hasMatch(fingerprint)) {
      throw const FormatException();
    }
    if (discovery['endpoints'] != null) {
      await EndpointAnnouncement.verify(
        discovery,
        endpoint,
        fingerprint,
        serverKey,
      );
      return origin;
    }
    final signature = base64Url.decode(
      base64Url.normalize(discovery['origin_signature'] as String),
    );
    final payload = jsonEncode([
      discovery['server_id'],
      value,
      endpoint.toString(),
      fingerprint,
    ]);
    final valid = await Ed25519().verify(
      utf8.encode('space/origin-binding/v1\u0000$payload'),
      signature: Signature(
        signature,
        publicKey: SimplePublicKey(serverKey, type: KeyPairType.ed25519),
      ),
    );
    if (!valid) throw const FormatException();
    return origin;
  } catch (_) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Подпись нового адреса пространства недействительна',
    );
  }
}
