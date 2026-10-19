import 'local_failure.dart';

import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'core.dart';

abstract interface class SecureKeyStorage {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
  Future<void> delete({required String key});
}

class KeyIdentityVault implements RotationJournalVault {
  KeyIdentityVault(this._storage);
  final SecureKeyStorage _storage;
  Future<String> _key(String origin) async =>
      'space.identity.v1.${url64((await Sha256().hash(utf8.encode(origin))).bytes)}';
  @override
  Future<DeviceRecord?> load(String origin) async {
    await _requireActive(origin);
    final value = await _storage.read(key: await _key(origin));
    if (value == null) return null;
    final record = DeviceRecord.fromJson(
      jsonDecode(value) as Map<String, dynamic>,
    );
    if (record.origin != origin) {
      throw const LocalFailure(
        LocalFailureCode.keyStorageMismatch,
        'Запись ключей принадлежит другому адресу',
      );
    }
    return record;
  }

  @override
  Future<void> save(DeviceRecord record) async {
    await _requireActive(record.origin);
    final key = await _key(record.origin);
    final encoded = jsonEncode(record.toJson());
    await _storage.write(key: key, value: encoded);
    if (await _storage.read(key: key) != encoded) {
      throw const LocalFailure(
        LocalFailureCode.keyStorageSave,
        'Системное хранилище не подтвердило сохранение ключей',
      );
    }
  }

  Future<void> _requireActive(String origin) async {
    if (await _storage.read(key: '${await _key(origin)}.transferred') != null) {
      throw StateError(
        'Устройство перенесено. Восстановите архив на новом устройстве.',
      );
    }
  }

  Future<void> retireForMigration(String origin, String transferId) async {
    final key = '${await _key(origin)}.transferred';
    await _storage.write(key: key, value: transferId);
    if (await _storage.read(key: key) != transferId) {
      throw StateError('Не удалось подтвердить остановку прежнего устройства');
    }
    final identityKey = await _key(origin);
    final tombstone = jsonEncode({
      'v': 'transferred',
      'origin': origin,
      'id': transferId,
    });
    await _storage.write(key: identityKey, value: tombstone);
    if (await _storage.read(key: identityKey) != tombstone) {
      throw StateError('Не удалось удалить рабочие ключи прежнего устройства');
    }
  }

  Future<bool> retiredForMigration(String origin, String transferId) async =>
      await _storage.read(key: '${await _key(origin)}.transferred') ==
      transferId;

  Future<DeviceRecord?> migrationSource(
    String origin,
    String transferId,
  ) async {
    final key = await _key(origin);
    final retired = await _storage.read(key: '$key.transferred');
    if (retired != null && retired != transferId) {
      throw StateError('Начат другой перенос устройства');
    }
    final raw = await _storage.read(key: key);
    if (raw == null) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    if (retired == transferId &&
        data['v'] == 'transferred' &&
        data['id'] == transferId) {
      return null;
    }
    final record = DeviceRecord.fromJson(data);
    if (record.origin != origin) {
      throw StateError('Адрес устройства не совпадает');
    }
    return record;
  }

  Future<void> requireMigrationTarget(
    String origin,
    String transferId, {
    DeviceRecord? expected,
  }) async {
    await _requireActive(origin);
    final key = await _key(origin);
    final receipt = await _storage.read(key: '$key.imported-transfer');
    if (receipt != null && receipt != transferId ||
        receipt == null && await _storage.read(key: key) != null) {
      throw StateError(
        'Перенос доступен только без существующего устройства этого пространства',
      );
    }
    final existing = await _storage.read(key: key);
    if (existing != null && expected != null) {
      final record = DeviceRecord.fromJson(
        jsonDecode(existing) as Map<String, dynamic>,
      );
      if (record.serverId != expected.serverId ||
          record.serverKey != expected.serverKey ||
          url64(record.deviceSeed) != url64(expected.deviceSeed)) {
        throw StateError('На этом компьютере сохранено другое устройство');
      }
    }
  }

  Future<void> installMigration(DeviceRecord record, String transferId) async {
    await requireMigrationTarget(record.origin, transferId, expected: record);
    final key = await _key(record.origin);
    await _storage.write(key: '$key.imported-transfer', value: transferId);
    if (await _storage.read(key: '$key.imported-transfer') != transferId) {
      throw StateError('Не удалось сохранить журнал переноса устройства');
    }
    if (await _storage.read(key: key) == null) await save(record);
  }

  @override
  Future<Map<String, dynamic>?> loadRotation(String origin) async {
    final value = await _storage.read(key: '${await _key(origin)}.rotation');
    if (value == null) return null;
    if (utf8.encode(value).length > 65536) {
      throw const LocalFailure(
        LocalFailureCode.keyJournalInvalid,
        'Журнал ротации слишком большой',
      );
    }
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      throw const LocalFailure(
        LocalFailureCode.keyJournalInvalid,
        'Повреждён журнал ротации',
      );
    }
    throw const LocalFailure(
      LocalFailureCode.keyJournalInvalid,
      'Неверный тип журнала ротации',
    );
  }

  @override
  Future<void> saveRotation(String origin, Map<String, dynamic> pending) async {
    final value = jsonEncode(pending);
    if (utf8.encode(value).length > 65536) {
      throw const LocalFailure(
        LocalFailureCode.keyJournalInvalid,
        'Журнал ротации слишком большой',
      );
    }
    final key = '${await _key(origin)}.rotation';
    await _storage.write(key: key, value: value);
    if (await _storage.read(key: key) != value) {
      throw const LocalFailure(
        LocalFailureCode.keyStorageSave,
        'Новый ключ не сохранён; ротация не отправлена',
      );
    }
  }

  @override
  Future<void> clearRotation(String origin) async =>
      _storage.delete(key: '${await _key(origin)}.rotation');
}
