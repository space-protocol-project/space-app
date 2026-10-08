import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'key_vault.dart';
export 'key_vault.dart' show SecureKeyStorage;

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

class SecureIdentityVault extends KeyIdentityVault {
  SecureIdentityVault({SecureKeyStorage? storage})
    : super(storage ?? const PlatformKeyStorage());
}
