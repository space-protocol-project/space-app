import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';

void main() {
  test('Внешний URL и credentials в адресе отклоняются', () {
    expect(localOrigin('http://127.0.0.1:8080').port, 8080);
    for (final address in [
      'http://example.com',
      'http://user:password@127.0.0.1:8080',
      'http://127.0.0.1:8080/path',
      'http://127.0.0.1:8080?token=secret',
    ]) {
      expect(() => localOrigin(address), throwsFormatException);
    }
  });
  test('Замена server ID или ключа блокирует сохранённую identity', () {
    final server = Discovery(
      localOrigin('http://127.0.0.1:8080'),
      'srv_test',
      List.filled(32, 1),
      9090,
    );
    final record = DeviceRecord(
      origin: server.origin.toString(),
      serverId: 'srv_test',
      serverKey: url64(server.publicKey),
      rootSeed: List.filled(32, 2),
      deviceSeed: List.filled(32, 3),
    );
    checkTrust(server, record);
    expect(
      () => checkTrust(
        Discovery(server.origin, 'srv_changed', server.publicKey, 9090),
        record,
      ),
      throwsFormatException,
    );
    expect(
      () => checkTrust(
        Discovery(server.origin, 'srv_test', List.filled(32, 4), 9090),
        record,
      ),
      throwsFormatException,
    );
    expect(DeviceRecord.fromJson(record.toJson()).rootSeed, record.rootSeed);
  });
  test('Transcript подписывается только после проверки контекста', () async {
    final root = List<int>.filled(32, 2), device = List<int>.filled(32, 3);
    final server = Discovery(
      localOrigin('http://127.0.0.1:8080'),
      'srv_test',
      List.filled(32, 1),
      9090,
    );
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = (await Sha256().hash(root)).bytes
        .map((v) => v.toRadixString(16).padLeft(2, '0'))
        .join();
    final data = <String, dynamic>{
      'auth_epoch': 1,
      'challenge_id': 'ac_${url64(List.filled(32, 0))}',
      'device_public_key': url64(device),
      'expires_at': now + 60,
      'grant_expires_at': now + 30 * 86400,
      'grant_id': 'dg_${url64(List.filled(32, 1))}',
      'issued_at': now,
      'nonce': url64(List.filled(32, 5)),
      'origin': server.origin.toString(),
      'principal_id': 'u_$hash',
      'purpose': 'device.register',
      'root_public_key': url64(root),
      'scopes': ['chat.read', 'chat.write'],
      'server_id': server.serverId,
      'v': 1,
    };
    CreateChallengeResponse response() => CreateChallengeResponse(
      challengeId: data['challenge_id'] as String,
      transcript: utf8.encode(jsonEncode(data)),
    );
    final signing = await checkedSigningBytes(
      response(),
      server,
      root,
      device,
      'device.register',
      '',
    );
    expect(
      utf8.decode(signing).startsWith('space/device-register/v1\u0000'),
      isTrue,
    );
    for (final entry in {
      'origin': 'http://127.0.0.1:9999',
      'server_id': 'srv_other',
      'purpose': 'auth.login',
      'device_public_key': url64(root),
    }.entries) {
      final previous = data[entry.key];
      data[entry.key] = entry.value;
      await expectLater(
        checkedSigningBytes(
          response(),
          server,
          root,
          device,
          'device.register',
          '',
        ),
        throwsFormatException,
      );
      data[entry.key] = previous;
    }
    data['untrusted'] = 'extra';
    await expectLater(
      checkedSigningBytes(
        response(),
        server,
        root,
        device,
        'device.register',
        '',
      ),
      throwsFormatException,
    );
  });
}
