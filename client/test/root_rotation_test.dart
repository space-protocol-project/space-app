import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/root_history.dart';
import 'package:space_client/src/secure_vault.dart';

class FaultStorage implements SecureKeyStorage {
  final values = <String, String>{};
  bool failWrite = false, failDelete = false;
  @override
  Future<String?> read({required String key}) async => values[key];
  @override
  Future<void> write({required String key, required String value}) async {
    if (failWrite) throw StateError('Сбой записи');
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    if (failDelete) throw StateError('Сбой очистки');
    values.remove(key);
  }
}

void main() {
  test(
    'История root сохраняет исходный ID и отвергает подмену и перестановку',
    () async {
      final algorithm = Ed25519();
      final first = await algorithm.newKeyPair(),
          second = await algorithm.newKeyPair(),
          third = await algorithm.newKeyPair();
      final device = await algorithm.newKeyPair();
      final a = (await first.extractPublicKey()).bytes,
          b = (await second.extractPublicKey()).bytes,
          c = (await third.extractPublicKey()).bytes;
      final principal = await rootPrincipal(a);
      const origin = 'http://127.0.0.1:8080';
      final server = 'srv_${'a' * 32}';
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      Future<Map<String, dynamic>> certificate(
        int epoch,
        SimpleKeyPair old,
        SimpleKeyPair next,
      ) async {
        final data = <String, dynamic>{
          'auth_epoch': epoch,
          'challenge_id': 'rc_${'a' * 43}',
          'expires_at': now + 120,
          'issued_at': now,
          'new_device_public_key': url64(
            (await device.extractPublicKey()).bytes,
          ),
          'new_root_public_key': url64((await next.extractPublicKey()).bytes),
          'nonce': url64(List.filled(32, 4)),
          'old_root_public_key': url64((await old.extractPublicKey()).bytes),
          'operation_id': 'ro_${'c' * 43}',
          'origin': origin,
          'principal_id': principal,
          'purpose': 'identity.root.rotate',
          'scopes': ['chat.read', 'chat.write'],
          'server_id': server,
          'v': 1,
        };
        final raw = utf8.encode(jsonEncode(data));
        return {
          'transcript': url64(raw),
          'old_signature': url64(
            (await algorithm.sign([
              ...utf8.encode('space/root.rotate/old/v1\u0000'),
              ...raw,
            ], keyPair: old)).bytes,
          ),
          'new_signature': url64(
            (await algorithm.sign([
              ...utf8.encode('space/root.rotate/new/v1\u0000'),
              ...raw,
            ], keyPair: next)).bytes,
          ),
        };
      }

      final one = await certificate(1, first, second),
          two = await certificate(2, second, third);
      final checked = await verifyRootHistory([one, two], c, origin, server);
      expect(checked.principalId, principal);
      expect(checked.epoch, 3);
      expect(await rootPrincipal(c), isNot(principal));
      await expectLater(
        verifyRootHistory([two, one], c, origin, server),
        throwsFormatException,
      );
      await expectLater(
        verifyRootHistory([one, two], b, origin, server),
        throwsFormatException,
      );
      await expectLater(
        verifyRootHistory([one, two], c, 'http://127.0.0.1:8081', server),
        throwsFormatException,
      );
      final broken = {...one, 'new_signature': url64(List.filled(64, 0))};
      await expectLater(
        verifyRootHistory([broken, two], c, origin, server),
        throwsFormatException,
      );
    },
  );
  test('Сбой записи журнала оставляет старые ключи, очистка не удаляет активную запись', () async {
    final storage = FaultStorage();
    final vault = SecureIdentityVault(storage: storage);
    final record = DeviceRecord(
      origin: 'http://127.0.0.1:8080',
      serverId: 'srv_${'a' * 32}',
      serverKey: url64(List.filled(32, 1)),
      rootSeed: List.filled(32, 2),
      deviceSeed: List.filled(32, 3),
    );
    await vault.save(record);
    storage.failWrite = true;
    await expectLater(
      vault.saveRotation(record.origin, {'v': 1, 'next': record.toJson()}),
      throwsStateError,
    );
    expect(await vault.loadRotation(record.origin), isNull);
    expect((await vault.load(record.origin))!.toJson(), record.toJson());
    storage.failWrite = false;
    await vault.saveRotation(record.origin, {'v': 1, 'next': record.toJson()});
    final restarted = SecureIdentityVault(storage: storage);
    expect(await restarted.loadRotation(record.origin), isNotNull);
    storage.failDelete = true;
    await expectLater(restarted.clearRotation(record.origin), throwsStateError);
    expect(await restarted.loadRotation(record.origin), isNotNull);
    expect((await restarted.load(record.origin))!.toJson(), record.toJson());
    storage.failDelete = false;
    await restarted.clearRotation(record.origin);
    expect(await restarted.loadRotation(record.origin), isNull);
    expect(await restarted.load(record.origin), isNotNull);
  });
}
