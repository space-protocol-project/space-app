import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/origin_binding.dart';

void main() {
  test(
    'Смена адреса сохраняет идентичность только с подписью и прежним TLS',
    () async {
      final algorithm = Ed25519();
      final key = await algorithm.newKeyPair();
      final public = (await key.extractPublicKey()).bytes;
      const identity = 'https://203.0.113.10:8443';
      final endpoint = Uri.parse('https://203.0.113.11:8443');
      final pin = 'a' * 64;
      final data = <String, dynamic>{
        'server_id': 'srv_${'1' * 32}',
        'identity_origin': identity,
        'network_origin': endpoint.toString(),
        'tls_fingerprint': pin,
      };
      final payload = jsonEncode([
        data['server_id'],
        identity,
        endpoint.toString(),
        pin,
      ]);
      final signature = await algorithm.sign(
        utf8.encode('space/origin-binding/v1\u0000$payload'),
        keyPair: key,
      );
      data['origin_signature'] = url64(signature.bytes);
      expect(
        await verifiedIdentityOrigin(data, endpoint, pin, public),
        Uri.parse(identity),
      );
      for (final field in [
        'identity_origin',
        'network_origin',
        'server_id',
        'tls_fingerprint',
        'origin_signature',
      ]) {
        final tampered = {...data, field: 'подмена'};
        await expectLater(
          verifiedIdentityOrigin(tampered, endpoint, pin, public),
          throwsA(isA<Exception>()),
        );
      }
      final wrongKey =
          (await (await algorithm.newKeyPair()).extractPublicKey()).bytes;
      await expectLater(
        verifiedIdentityOrigin(data, endpoint, pin, wrongKey),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        verifiedIdentityOrigin(data, endpoint, 'b' * 64, public),
        throwsA(isA<Exception>()),
      );
    },
  );
}
