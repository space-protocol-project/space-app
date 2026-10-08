import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'key_vault.dart';
export 'key_vault.dart' show SecureKeyStorage;

class _PartitionOptions extends WindowsOptions {
  const _PartitionOptions(this.partition);
  final String partition;
  @override
  Map<String, String> toMap() => {
    ...super.toMap(),
    'spaceStoragePartition': partition,
  };
}

class PlatformKeyStorage implements SecureKeyStorage {
  const PlatformKeyStorage();
  static const _storage = FlutterSecureStorage();
  WindowsOptions options(String key) => Platform.isWindows
      ? _PartitionOptions(key)
      : WindowsOptions.defaultOptions;
  @override
  Future<String?> read({required String key}) async {
    final selected = options(key);
    var value = await _storage.read(key: key, wOptions: selected);
    if (value == null && Platform.isWindows) {
      value = await _storage.read(key: key);
      if (value != null) {
        await _storage.write(key: key, value: value, wOptions: selected);
        await _storage.delete(key: key);
      }
    }
    return value;
  }

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value, wOptions: options(key));
  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key, wOptions: options(key));
    if (Platform.isWindows && await _storage.read(key:key)!=null) await _storage.delete(key:key);
  }
}

class SecureIdentityVault extends KeyIdentityVault {
  SecureIdentityVault({SecureKeyStorage? storage})
    : super(storage ?? const PlatformKeyStorage());
}
