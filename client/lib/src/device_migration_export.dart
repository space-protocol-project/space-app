part of 'device_migration.dart';

extension DeviceMigrationExport on DeviceMigration {
  Future<void> export(String path, String password) async {
    if (await File(path).exists()) {
      throw StateError('Выберите новое имя архива');
    }
    final pending = File('$path.pending');
    final imported = await storage.read(key: DeviceMigration.importKey);
    if (imported != null && imported.endsWith(':pending')) {
      throw StateError('Сначала завершите полное восстановление устройства');
    }
    await stop();
    if (home.running) throw StateError('Домашний сервер ещё работает');
    if (await pending.exists()) {
      await _resume(pending, path, password);
      return;
    }
    if (await storage.read(key: DeviceMigration.exportKey) != null) {
      throw StateError('Продолжите прежний перенос с тем же файлом и паролем');
    }
    final records = await _sourceRecords();
    final stores = <MlsLocalStore?>[];
    final scopes = <String>{};
    for (final record in records) {
      final store = await devices.deviceStore(record);
      if (store != null && !scopes.add(store.storageKey)) {
        throw StateError(
          'Несколько адресов используют одно состояние MLS. Удалите дубликат пространства.',
        );
      }
      stores.add(store);
    }
    final keys = await deviceSecretKeys(records, storage);
    await withDeviceQueuesLocked(await directory(), keys, () async {
      final current = await deviceSecretKeys(records, storage);
      if (!setEquals(keys, current)) {
        throw StateError('Очередь изменилась. Повторите полный перенос.');
      }
      await _exportSnapshot(records, stores, pending, path, password);
    });
  }

  Future<void> _exportSnapshot(
    List<DeviceRecord> records,
    List<MlsLocalStore?> stores,
    File pending,
    String path,
    String password,
  ) async {
    final temporary = await Directory.systemTemp.createTemp('space-migration-');
    try {
      final fileBundle = File(p.join(temporary.path, 'files.zip'));
      final homeFile = await _exportHome(temporary, records);
      final backups = await packHomeBackups(await _homeRoot(), temporary);
      final hashes = await compute(packDeviceFilesInWorker, <String, String?>{
        'root': (await directory()).path,
        'destination': fileBundle.path,
        'home': homeFile?.path,
        'backups': backups?.path,
      });
      final payload = <String, dynamic>{
        'v': 1,
        'kind': 'space-device-migration',
        'id': newRequestKey(),
        'settings': readDeviceSettings(preferences),
        'secrets': await readDeviceSecrets(
          await deviceSecretKeys(records, storage),
          storage,
        ),
        'files': hashes,
        'home_origin': home.network?.identityOrigin,
        'home_settings': await readMigrationHomeSettings(
          await _homeRoot(),
          home.network,
        ),
        'server_digest': await deviceFileDigest(fileBundle),
        'devices': <Map<String, dynamic>>[],
      };
      validateMigrationHomeSettings(
        Map<String, dynamic>.from(payload['home_settings'] as Map),
      );
      validateDeviceSettings(
        Map<String, dynamic>.from(payload['settings'] as Map),
      );
      await validateDeviceSecrets(
        records,
        Map<String, String>.from(payload['secrets'] as Map),
      );
      _status('Сохранение и проверка всех ключей и данных…');
      await _capture(0, records, stores, payload, () async {
        await compute(preserveMigrationInWorker, <String, dynamic>{
          'server': fileBundle.path,
          'device': payload,
          'password': password,
          'destination': pending.path,
        });
        await _writeMarker(DeviceMigration.exportKey, payload['id'] as String);
        await _retireIdentities(records, payload['id'] as String);
      });
      await _finishExport(payload, pending, path);
    } finally {
      await removeMigrationTemporary(temporary);
    }
  }

  Future<List<DeviceRecord>> _sourceRecords() async {
    final origins = <String>{
      ...preferences.getStringList('space.ui.origins') ?? [],
    };
    final homeOrigin = home.network?.identityOrigin;
    if (homeOrigin != null) origins.add(homeOrigin);
    if (origins.length > 256) throw StateError('Слишком много пространств');
    final records = <DeviceRecord>[];
    for (final origin in origins) {
      if (await vault.loadRotation(origin) != null) {
        throw StateError('Сначала завершите смену ключа пространства');
      }
      final record = await vault.load(origin);
      if (record != null) records.add(record);
    }
    return records;
  }

  Future<File?> _exportHome(
    Directory temporary,
    List<DeviceRecord> records,
  ) async {
    if (home.ip.isEmpty) return null;
    _status('Экспорт домашнего пространства…');
    final file = File(p.join(temporary.path, 'home.zip'));
    if (!await home.exportData(file.path)) throw StateError(home.error);
    final report = await home.inspectArchive(file.path);
    final owners = records.where(
      (record) => record.origin == home.network?.identityOrigin,
    );
    if (report == null ||
        owners.length != 1 ||
        report.serverId != owners.single.serverId) {
      throw StateError('Не подтверждён архив домашнего пространства');
    }
    return file;
  }

  Future<void> _capture(
    int index,
    List<DeviceRecord> records,
    List<MlsLocalStore?> stores,
    Map<String, dynamic> payload,
    Future<void> Function() preserve,
  ) async {
    if (index == records.length) return preserve();
    Future<void> next(Map<String, dynamic>? checkpoint) async {
      (payload['devices'] as List).add({
        'record': records[index].toJson(),
        'mls': checkpoint,
      });
      await _capture(index + 1, records, stores, payload, preserve);
    }

    final store = stores[index];
    if (store == null) {
      await next(null);
    } else {
      await store.transferCheckpoint(payload['id'] as String, next);
    }
  }

  Future<void> _retireIdentities(List<DeviceRecord> records, String id) async {
    for (final record in records) {
      await vault.retireForMigration(record.origin, id);
    }
  }

  Future<void> _resume(File pending, String path, String password) async {
    _status('Проверка незавершённого переноса…');
    final payload = await _open(pending.path, password, pending: true);
    _validate(payload);
    final records = await _records(payload);
    final id = payload['id'] as String;
    final marker = await storage.read(key: DeviceMigration.exportKey);
    if (marker != null && marker != id) {
      throw StateError('Начат другой перенос');
    }
    for (final record in records) {
      final current = await vault.migrationSource(record.origin, id);
      final retired = await vault.retiredForMigration(record.origin, id);
      if (!retired &&
          jsonEncode(current?.toJson()) != jsonEncode(record.toJson())) {
        throw StateError('Архив не соответствует исходному устройству');
      }
    }
    await _writeMarker(DeviceMigration.exportKey, id);
    for (var index = 0; index < records.length; index++) {
      final store = await devices.deviceStore(records[index]);
      final entry = (payload['devices'] as List)[index] as Map;
      await store?.completeDeviceTransfer(
        Map<String, dynamic>.from(entry['mls'] as Map),
        id,
      );
    }
    await _retireIdentities(records, id);
    await _finishExport(payload, pending, path);
  }

  Future<void> _finishExport(
    Map<String, dynamic> payload,
    File pending,
    String path,
  ) async {
    if (payload['home_origin'] != null) {
      final root = await home.directory();
      await root.create(recursive: true);
      await File(
        p.join(root.path, 'device-migration-exported.json'),
      ).writeAsString(jsonEncode({'v': 1, 'id': payload['id']}), flush: true);
    }
    await MigrationArchive.commit(pending);
    await pending.rename(path);
    _status('Полный перенос сохранён. Прежнее устройство остановлено.');
  }
}
