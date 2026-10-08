import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core.dart';

abstract interface class SecureKeyStorage {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
  Future<void> delete({required String key});
}

class PlatformKeyStorage implements SecureKeyStorage {
  const PlatformKeyStorage();
  static const _storage = FlutterSecureStorage();
  @override
  Future<String?> read({required String key}) => _storage.read(key: key);
  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);
  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);
}

class SecureIdentityVault implements RotationJournalVault {
  SecureIdentityVault({SecureKeyStorage? storage})
    : _storage = storage ?? const PlatformKeyStorage();
  final SecureKeyStorage _storage;
  Future<String> _key(String origin) async =>
      'space.identity.v1.${url64((await Sha256().hash(utf8.encode(origin))).bytes)}';
  @override
  Future<DeviceRecord?> load(String origin) async {
    final value = await _storage.read(key: await _key(origin));
    if (value == null) return null;
    final record = DeviceRecord.fromJson(
      jsonDecode(value) as Map<String, dynamic>,
    );
    if (record.origin != origin) {
      throw const FormatException('Запись ключей принадлежит другому адресу');
    }
    return record;
  }

  @override
  Future<void> save(DeviceRecord record) async {
    final key = await _key(record.origin);
    final encoded = jsonEncode(record.toJson());
    await _storage.write(key: key, value: encoded);
    if (await _storage.read(key: key) != encoded) {
      throw const FormatException(
        'Системное хранилище не подтвердило сохранение ключей',
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> loadRotation(String origin) async {
    final value = await _storage.read(key: '${await _key(origin)}.rotation');
    if (value == null) return null;
    if (utf8.encode(value).length > 65536) {
      throw const FormatException('Журнал ротации слишком большой');
    }
    return jsonDecode(value) as Map<String, dynamic>;
  }

  @override
  Future<void> saveRotation(String origin, Map<String, dynamic> pending) async {
    final value = jsonEncode(pending);
    if (utf8.encode(value).length > 65536) {
      throw const FormatException('Журнал ротации слишком большой');
    }
    final key = '${await _key(origin)}.rotation';
    await _storage.write(key: key, value: value);
    if (await _storage.read(key: key) != value) {
      throw const FormatException(
        'Новый ключ не сохранён; ротация не отправлена',
      );
    }
  }

  @override
  Future<void> clearRotation(String origin) async =>
      _storage.delete(key: '${await _key(origin)}.rotation');
}
