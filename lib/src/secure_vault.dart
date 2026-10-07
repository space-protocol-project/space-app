import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core.dart';

class SecureIdentityVault implements IdentityVault {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
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
  Future<void> save(DeviceRecord record) async => _storage.write(
    key: await _key(record.origin),
    value: jsonEncode(record.toJson()),
  );
}
