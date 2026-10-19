import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' show Sha256;

import 'chat_outbox.dart';
import 'core.dart';
import 'key_vault.dart';

Future<Set<String>> deviceSecretKeys(
  List<DeviceRecord> records,
  SecureKeyStorage storage,
) async {
  final keys = <String>{'space.drafts.v1'};
  for (final record in records) {
    final digest = await Sha256().hash(utf8.encode(record.origin));
    keys.add('space.history.key.${base64Url.encode(digest.bytes)}');
    final identity = await record.identity();
    final scope = OutboxScope(
      record.origin,
      record.serverId,
      identity.principalId,
      record.grantId,
    );
    final family = sha256
        .convert(
          utf8.encode(
            jsonEncode([scope.origin, scope.serverId, scope.principalId]),
          ),
        )
        .toString();
    final catalog = 'space.outbox.sources.v1.$family';
    keys.add(catalog);
    final raw = await storage.read(key: catalog);
    final grants = <String>{scope.grantId};
    if (raw != null) {
      grants.addAll((jsonDecode(raw)['grants'] as List).cast<String>());
    }
    for (final grant in grants) {
      final id = OutboxScope(
        scope.origin,
        scope.serverId,
        scope.principalId,
        grant,
      ).id;
      keys.addAll(['space.outbox.v1.$id', 'space.outbox.files.key.v1.$id']);
    }
  }
  return keys;
}

Future<Map<String, String>> readDeviceSecrets(
  Set<String> keys,
  SecureKeyStorage storage,
) async {
  final values = <String, String>{};
  for (final key in keys) {
    final value = await storage.read(key: key);
    if (value != null) values[key] = value;
  }
  return values;
}

Future<void> writeDeviceSecrets(
  Map<String, String> secrets,
  SecureKeyStorage storage,
) async {
  for (final entry in secrets.entries) {
    final existing = await storage.read(key: entry.key);
    if (existing != null && existing != entry.value) {
      throw StateError('На устройстве уже есть другая очередь или история');
    }
    await storage.write(key: entry.key, value: entry.value);
    if (await storage.read(key: entry.key) != entry.value) {
      throw StateError('Не подтверждено сохранение ключей устройства');
    }
  }
}

Future<void> validateDeviceSecrets(
  List<DeviceRecord> records,
  Map<String, String> values,
) async {
  final allowed = await deviceSecretKeys(records, _SnapshotStorage(values));
  if (values.keys.any((key) => !allowed.contains(key))) {
    throw const FormatException('Посторонние ключи в переносе устройства');
  }
}

class _SnapshotStorage implements SecureKeyStorage {
  _SnapshotStorage(this.values);
  final Map<String, String> values;
  @override
  Future<String?> read({required String key}) async => values[key];
  @override
  Future<void> write({required String key, required String value}) async =>
      throw UnsupportedError('Только чтение');
  @override
  Future<void> delete({required String key}) async =>
      throw UnsupportedError('Только чтение');
}
