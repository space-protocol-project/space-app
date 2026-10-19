import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/recovery_card.dart';
import 'package:space_client/src/recovery_spaces.dart';

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
    final restored = await restoreAccessInWorker([packet, 'пароль']);
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
    expect(
      (await restoreAccessInWorker([legacy, 'пароль'])).single.origin,
      first.origin,
    );
  }, timeout: const Timeout(Duration(minutes: 2)));

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
