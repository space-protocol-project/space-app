import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:space_client/ui/recovery_panel.dart'
    show restoreRecordInWorker, rootCardPayloadInWorker;
import 'package:space_client/src/core.dart';
import 'package:space_client/src/recovery_card.dart';

void main() {
  test('Пароль допускает любую длину, пустое значение и Unicode', () async {
    for (final password in ['', 'я🔑\n ', '密' * 600]) {
      final card = await sealRecoveryCard({'test': 'payload'}, password);
      expect(await openRecoveryCard(card, password), {'test': 'payload'});
    }
  });
  test(
    'Карточка защищает секрет, проверяет параметры и создаёт новый device key',
    () async {
      final root = await Ed25519().newKeyPair();
      final payload = <String, dynamic>{
        'v': 1,
        'credential': 'root',
        'origin': 'https://203.0.113.10:8443',
        'tls_fingerprint': 'b' * 64,
        'server_id': 'srv_${'a' * 32}',
        'server_key': url64(List.filled(32, 1)),
        'root_public_key': url64((await root.extractPublicKey()).bytes),
        'secret': url64(await root.extractPrivateKeyBytes()),
      };
      const password = 'Several random test words 2026';
      final packet = await sealRecoveryCard(payload, password);
      expect(packet.contains(payload['secret'] as String), false);
      final decoded = await openRecoveryCard(packet, password);
      final workerRecord = await compute(restoreRecordInWorker, [
        packet,
        password,
      ]);
      expect(workerRecord.origin, payload['origin']);
      final first = await recordFromRecovery(decoded),
          second = await recordFromRecovery(decoded);
      final localPayload = await compute(rootCardPayloadInWorker, first);
      expect(localPayload['origin'], payload['origin']);
      expect(localPayload['secret'], payload['secret']);
      expect(first.rootSeed, second.rootSeed);
      expect(first.deviceSeed, isNot(second.deviceSeed));
      expect(first.grantId, isEmpty);
      expect(first.tlsFingerprint, 'b' * 64);
      await expectLater(
        openRecoveryCard(packet, 'Wrong password for the card'),
        throwsFormatException,
      );
      final altered = jsonDecode(packet) as Map<String, dynamic>;
      altered['iterations'] = 999999999;
      await expectLater(
        openRecoveryCard(jsonEncode(altered), password),
        throwsFormatException,
      );
      altered['iterations'] = cardIterations;
      final cipher = altered['ciphertext'] as String;
      altered['ciphertext'] =
          '${cipher[0] == 'A' ? 'B' : 'A'}${cipher.substring(1)}';
      await expectLater(
        openRecoveryCard(jsonEncode(altered), password),
        throwsFormatException,
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
