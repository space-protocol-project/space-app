import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/recovery_card.dart';

void main() {
  test(
    'Карточка защищает секрет, проверяет параметры и создаёт новый device key',
    () async {
      final root = await Ed25519().newKeyPair();
      final payload = <String, dynamic>{
        'v': 1,
        'credential': 'root',
        'origin': 'http://127.0.0.1:8080',
        'server_id': 'srv_${'a' * 32}',
        'server_key': url64(List.filled(32, 1)),
        'root_public_key': url64((await root.extractPublicKey()).bytes),
        'secret': url64(await root.extractPrivateKeyBytes()),
      };
      const password = 'Several random test words 2026';
      final packet = await sealRecoveryCard(payload, password);
      expect(packet.contains(payload['secret'] as String), false);
      final decoded = await openRecoveryCard(packet, password);
      final first = await recordFromRecovery(decoded),
          second = await recordFromRecovery(decoded);
      expect(first.rootSeed, second.rootSeed);
      expect(first.deviceSeed, isNot(second.deviceSeed));
      expect(first.grantId, isEmpty);
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
