import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/root_retention.dart';
import 'package:space_client/src/rpc_clients.dart';

void main() {
  test(
    'Общий Go/Dart вектор, порядок и дубликаты сохраняемых устройств',
    () async {
      final devices = List.generate(
        3,
        (i) => DeviceGrant(
          id: 'dg_${String.fromCharCode(97 + i) * 43}',
          publicKey: List.filled(32, i),
          scopes: ['chat.read', 'chat.write'],
          expiresAt: Int64(1800000000 + i),
        ),
      );
      expect(
        url64(await retainedDevicesHash(devices)),
        '6nKeN-KvIx5zE1tapOJ3VUcTK2VC37hg4vVAR1OpShI',
      );
      final proof = RetentionProof(
        grantId: devices.last.id,
        publicKey: devices.last.publicKey,
        scopes: devices.last.scopes,
        expiresAt: devices.last.expiresAt,
        index: 2,
        count: 3,
        siblings: [
          base64Decode('caio2gYKAQTzWGV5lETAo2eaYK4NDHR3bYOWY/AyvSQ='),
          base64Decode('bjbDlix0+IQyTLPwZn2mBNaNbht1Z4aWo5Tp4PmJKGs='),
        ],
      );
      await verifyRetention(
        '6nKeN-KvIx5zE1tapOJ3VUcTK2VC37hg4vVAR1OpShI',
        proof,
      );
      proof.count = 4;
      await expectLater(
        verifyRetention('6nKeN-KvIx5zE1tapOJ3VUcTK2VC37hg4vVAR1OpShI', proof),
        throwsException,
      );
      await expectLater(
        retainedDevicesHash(devices.reversed.toList()),
        throwsException,
      );
      await expectLater(
        retainedDevicesHash([devices.first, devices.first]),
        throwsException,
      );
      await expectLater(retainedDevicesHash([]), throwsException);
    },
  );
  test(
    'Одно устройство: подписанные ключ, права, срок и размер списка',
    () async {
      final device = DeviceGrant(
        id: 'dg_${'a' * 43}',
        publicKey: List.filled(32, 1),
        scopes: ['chat.read', 'chat.write'],
        expiresAt: Int64(1800000000),
      );
      final hash = url64(await retainedDevicesHash([device]));
      RetentionProof proof() => RetentionProof(
        grantId: device.id,
        publicKey: device.publicKey,
        scopes: device.scopes,
        expiresAt: device.expiresAt,
        count: 1,
      );
      await verifyRetention(hash, proof());
      for (final mutation in <void Function(RetentionProof)>[
        (p) => p.expiresAt += 1,
        (p) => p.scopes.add('space.manage'),
        (p) => p.publicKey[0] ^= 1,
        (p) => p.grantId = 'dg_${'b' * 43}',
        (p) => p.index = 1,
        (p) => p.count = 0,
        (p) => p.count = 257,
        (p) => p.siblings.add(List.filled(32, 0)),
      ]) {
        final p = proof();
        mutation(p);
        await expectLater(verifyRetention(hash, p), throwsException);
      }
    },
  );
  test(
    'Recovery и неизвестные права нельзя скрыто включить в сохраняемый список',
    () async {
      DeviceGrant grant() => DeviceGrant(
        id: 'dg_${'a' * 43}',
        publicKey: List.filled(32, 1),
        expiresAt: Int64(1800000000),
        scopes: ['chat.read', 'chat.write'],
      );
      for (final rights in ['identity.recover', 'unknown.permission']) {
        final invalid = grant()..scopes.add(rights);
        await expectLater(retainedDevicesHash([invalid]), throwsException);
      }
      final invalidKey = grant()..publicKey = [1];
      await expectLater(retainedDevicesHash([invalidKey]), throwsException);
    },
  );
}
