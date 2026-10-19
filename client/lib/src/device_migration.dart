import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import 'core.dart';
import 'device_migration_files.dart';
import 'device_migration_secrets.dart';
import 'device_migration_settings.dart';
import 'home_controller.dart';
import 'home_migration.dart';
import 'home_transfer.dart';
import 'device_migration_home.dart';
import 'device_migration_locks.dart';
import 'key_vault.dart';
import 'migration_archive.dart';
import 'migration_temporary.dart';
import 'mls/local_store.dart';

part 'device_migration_export.dart';
part 'device_migration_import.dart';

class DeviceMigration {
  DeviceMigration({
    required this.home,
    required this.devices,
    required this.preferences,
    required this.directory,
    required this.stop,
    this.progress,
  });
  final HomeController home;
  final HomeMigration devices;
  final SharedPreferences preferences;
  final Future<Directory> Function() directory;
  final Future<void> Function() stop;
  final void Function(String)? progress;
  static const exportKey = 'space.device-migration.export';
  static const importKey = 'space.device-migration.import';

  SecureKeyStorage get storage => devices.storage;
  KeyIdentityVault get vault => devices.vault;
  void _status(String text) => progress?.call(text);

  Future<Map<String, dynamic>> _open(
    String path,
    String password, {
    String? output,
    bool pending = false,
  }) => compute(openMigrationInWorker, <String, dynamic>{
    'source': path,
    'password': password,
    'server': output,
    'allow_uncommitted': pending,
  });

  Future<void> _writeMarker(String key, String value) async {
    await storage.write(key: key, value: value);
    if (await storage.read(key: key) != value) {
      throw StateError('Не удалось подтвердить этап переноса устройства');
    }
  }

  Future<Directory> _homeRoot() async =>
      resolveHomeLocation(await home.directory());

  Future<List<DeviceRecord>> _records(Map<String, dynamic> payload) async {
    final entries = (payload['devices'] as List).cast<Map>();
    final records = <DeviceRecord>[];
    final origins = <String>{};
    for (final entry in entries) {
      final record = DeviceRecord.fromJson(
        Map<String, dynamic>.from(entry['record'] as Map),
      );
      await record.identity();
      if (!origins.add(record.origin) ||
          (record.mlsIdentity == null) != (entry['mls'] == null)) {
        throw const FormatException('Неполный или повторный снимок устройства');
      }
      records.add(record);
    }
    return records;
  }

  void _validate(Map<String, dynamic> payload) {
    if (payload['v'] != 1 ||
        payload['kind'] != 'space-device-migration' ||
        payload['id'] is! String ||
        !RegExp(r'^[A-Za-z0-9_-]{32}$').hasMatch(payload['id'] as String) ||
        payload['devices'] is! List ||
        (payload['devices'] as List).length > 256) {
      throw const FormatException('Это не полный перенос устройства');
    }
    validateDeviceSettings(
      Map<String, dynamic>.from(payload['settings'] as Map),
    );
  }
}
