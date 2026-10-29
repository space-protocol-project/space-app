import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

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
  static const androidOptions = AndroidOptions(resetOnError: false);
  static const macOptions = MacOsOptions(usesDataProtectionKeychain: false);
  static const _storage = FlutterSecureStorage(
    aOptions: androidOptions,
    mOptions: macOptions,
  );
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
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value, wOptions: options(key));
    await syncSecureStorage(android: Platform.isAndroid);
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key, wOptions: options(key));
    await syncSecureStorage(android: Platform.isAndroid);
    if (Platform.isWindows && await _storage.read(key: key) != null) {
      await _storage.delete(key: key);
    }
  }
}

Future<void> syncSecureStorage({required bool android}) async {
  if (!android) return;
  await const MethodChannel('space/secure-storage')
      .invokeMethod<void>('flush', PlatformKeyStorage.androidOptions.toMap());
}

class SecureIdentityVault extends KeyIdentityVault {
  SecureIdentityVault({SecureKeyStorage? storage})
    : super(storage ?? const PlatformKeyStorage());
}
