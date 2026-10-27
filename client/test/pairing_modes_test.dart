import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/pairing.dart';
import 'package:space_client/src/pairing_qr.dart';

import 'pairing_transport_test.dart' show PairingServer;

void main() {
  test('Режим меняет код проверки даже при одинаковых ключах', () async {
    final root = List.filled(32, 1), device = List.filled(32, 2);
    final limited = await pairVerificationCode(
      'server',
      'pair',
      root,
      device,
      administrative: true,
    );
    final full = await pairVerificationCode(
      'server',
      'pair',
      root,
      device,
      administrative: true,
      fullManagement: true,
    );
    expect(full, isNot(limited));
  });
  test('Полный запрос и QR связывают режим, но не содержат секреты', () async {
    final server = PairingServer(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    addTearDown(server.close);
    final pending = await PendingPairing.start(
      server.discovery,
      fullManagement: true,
    );
    addTearDown(pending.close);
    expect(pending.request.pairing.fullManagement, isTrue);
    expect(pending.request.pairing.administrative, isTrue);
    final encoded = PairingQr.request(
      server.discovery,
      pending.request,
    ).encode();
    final qr = PairingQr.parse(encoded);
    expect(qr.fullManagement, isTrue);
    qr.checkPair(pending.request.pairing);
    final changed = pending.request.pairing.deepCopy()..fullManagement = false;
    expect(() => qr.checkPair(changed), throwsFormatException);
    expect(encoded, isNot(contains(pending.request.pollToken)));
  });
  test('Полный рабочий профиль не содержит root или recovery секретов', () {
    final record = DeviceRecord(
      origin: 'http://localhost:8080',
      serverId: 's',
      serverKey: '',
      rootSeed: [],
      rootPublicKey: List.filled(32, 3),
      deviceSeed: List.filled(32, 7),
      grantId: 'dg_${'a' * 43}',
      administrative: true,
      fullManagement: true,
    );
    final restored = DeviceRecord.fromJson(record.toJson());
    expect(restored.fullManagement, isTrue);
    expect(restored.managementSeed, restored.deviceSeed);
    expect(restored.managementGrantId, restored.grantId);
    expect(restored.rootSeed, isEmpty);
    expect(restored.recoverySeed, isEmpty);
  });
  test('Ограниченный профиль не обладает управляющим ключом', () {
    final record = DeviceRecord(
      origin: 'http://localhost',
      serverId: 's',
      serverKey: '',
      rootSeed: [],
      deviceSeed: List.filled(32, 7),
    );
    expect(record.canManageDevices, isFalse);
    expect(record.managementSeed, isEmpty);
  });
}
