import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/recovery_card.dart';
import 'package:space_client/src/recovery_spaces.dart';
import 'package:space_client/src/key_vault.dart';

import 'mls_native_test.dart' show MemoryMlsStorage;

Future<DeviceRecord> record(int number) async {
  final root = await Ed25519().newKeyPairFromSeed(List.filled(32, number));
  return DeviceRecord(
    origin: 'https://203.0.113.$number:8443',
    serverId: 'srv_${'$number' * 32}',
    serverKey: url64(List.filled(32, number)),
    rootSeed: await root.extractPrivateKeyBytes(),
    deviceSeed: List.filled(32, number + 10),
  );
}

void main() {
  test('Тип определяется автоматически; набор переносит отдельный доступ каждого пространства', () async {
    final first = await record(1), second = await record(2);
    final payload = await recoverySpacesPayload([first, second]);
    final packet = await sealRecoveryCard(payload, 'пароль');
    final result = await restoreAccessInWorker([packet, 'пароль']);
    expect(result.isSpaceCollection, true);
    final restored = result.records;
    expect(restored.map((value) => value.origin), [
      first.origin,
      second.origin,
    ]);
    expect(restored.map((value) => value.rootSeed), [
      first.rootSeed,
      second.rootSeed,
    ]);
    expect(restored.first.deviceSeed, isNot(first.deviceSeed));
    expect(restored.first.mlsIdentity, isNull);
    final legacy = await sealRecoveryCard(
      await recoveryAccessPayload(first),
      'пароль',
    );
    final singleAccess = await restoreAccessInWorker([legacy, 'пароль']);
    expect(singleAccess.isSpaceCollection, false);
    expect(singleAccess.records.single.origin, first.origin);
  }, timeout: const Timeout(Duration(minutes: 2)));

  test(
    'Второй QR сохраняет уже восстановленные ключи устройства и привязку MLS',
    () async {
      final existing = await record(1), other = await record(2);
      existing.grantId = 'existing-grant';
      final public = await (await Ed25519().newKeyPairFromSeed(
        existing.deviceSeed,
      )).extractPublicKey();
      existing.mlsIdentity = {
        'server_id': existing.serverId,
        'principal_id': (await existing.identity()).principalId,
        'grant_id': 'existing-grant',
        'public_key': public.bytes,
      };
      final vault = KeyIdentityVault(MemoryMlsStorage());
      await vault.save(existing);
      final packet = await sealRecoveryCard(
        await recoverySpacesPayload([existing]),
        'пароль',
      );
      final single = await restoreAccessInWorker([packet, 'пароль']);
      expect(single.isSpaceCollection, true);
      expect(await missingRecoverySpaces(single.records, vault), isEmpty);
      expect(
        (await missingRecoverySpaces([existing, other], vault)).single.origin,
        other.origin,
      );
      expect((await vault.load(existing.origin))!.toJson(), existing.toJson());
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test('Повторы и неполные наборы не допускаются', () async {
    final first = await record(1);
    await expectLater(
      recoverySpacesPayload([first, first]),
      throwsFormatException,
    );
    await expectLater(recoverySpacesPayload([]), throwsFormatException);
    final payload = await recoverySpacesPayload([first]);
    payload['cards'] = [
      await recoveryAccessPayload(first),
      {'v': 999},
    ];
    final packet = await sealRecoveryCard(payload, 'пароль');
    await expectLater(
      restoreAccessInWorker([packet, 'пароль']),
      throwsA(anything),
    );
  }, timeout: const Timeout(Duration(minutes: 2)));
}
