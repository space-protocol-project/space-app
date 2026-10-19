part of 'device_migration.dart';

extension DeviceMigrationImport on DeviceMigration {
  Future<void> restore(String path, String password, {String? publicIP}) async {
    final temporary = await Directory.systemTemp.createTemp('space-migration-');
    try {
      _status('Проверка пароля и всех блоков архива…');
      final bundle = File(p.join(temporary.path, 'files.zip'));
      final payload = await _open(path, password, output: bundle.path);
      _validate(payload);
      if (await deviceFileDigest(bundle) != payload['server_digest']) {
        throw const FormatException('Повреждён набор файлов устройства');
      }
      final records = await _records(payload);
      final id = payload['id'] as String;
      if (await _requireTarget(id)) return;
      await stop();
      if (home.running) throw StateError('Домашний сервер ещё работает');
      await _preflight(records, payload, id);
      final files = Directory(p.join(temporary.path, 'files'));
      final hashes = Map<String, String>.from(payload['files'] as Map);
      await compute(unpackDeviceFiles, <String, dynamic>{
        'source': bundle.path,
        'destination': files.path,
        'hashes': hashes,
      });
      await verifyDeviceFiles(files, hashes);
      final homeFile = hashes.containsKey('home.zip')
          ? File(p.join(files.path, 'home.zip'))
          : null;
      final report = await _inspectHome(homeFile, payload, records);
      final homeSettings = Map<String, dynamic>.from(
        payload['home_settings'] as Map,
      );
      validateMigrationHomeSettings(homeSettings);
      if (report == null &&
          (hashes.containsKey('home-backups.zip') || homeSettings.isNotEmpty)) {
        throw const FormatException(
          'Настройки Эфира без домашнего пространства',
        );
      }
      final secrets = Map<String, String>.from(payload['secrets'] as Map);
      await validateDeviceSecrets(records, secrets);
      await _writeMarker(DeviceMigration.importKey, '$id:pending');
      _status('Восстановление пространств, истории и настроек…');
      if (report != null) {
        await devices.installServer(
          home: home,
          path: homeFile!.path,
          publicIP: publicIP ?? await home.detectIP(),
          report: report,
          id: id,
        );
        await installMigrationHomeSettings(
          await _homeRoot(),
          homeSettings,
          home,
        );
        if (hashes.containsKey('home-backups.zip')) {
          await installHomeBackups(
            File(p.join(files.path, 'home-backups.zip')),
            await _homeRoot(),
          );
        }
      }
      await _installRecords(records, payload, id);
      await writeDeviceSecrets(secrets, storage);
      await installDeviceFiles(files, await directory(), hashes);
      await writeDeviceSettings(
        preferences,
        Map<String, dynamic>.from(payload['settings'] as Map),
      );
      await _writeMarker(DeviceMigration.importKey, '$id:complete');
      _status('Устройство восстановлено. Перезапустите приложение.');
    } finally {
      await removeMigrationTemporary(temporary);
    }
  }

  Future<bool> _requireTarget(String id) async {
    if (await storage.read(key: DeviceMigration.exportKey) != null) {
      throw StateError(
        'Восстановите перенос на новом устройстве, не на исходном',
      );
    }
    final receipt = await storage.read(key: DeviceMigration.importKey);
    if (receipt == '$id:complete') {
      _status('Этот перенос уже восстановлен. Текущие данные сохранены.');
      return true;
    }
    if (receipt == '$id:pending') return false;
    if (receipt != null ||
        (preferences.getStringList('space.ui.origins') ?? []).isNotEmpty ||
        home.ip.isNotEmpty) {
      throw StateError(
        'Полное восстановление доступно в новой установке приложения',
      );
    }
    return false;
  }

  Future<void> _preflight(
    List<DeviceRecord> records,
    Map<String, dynamic> payload,
    String id,
  ) async {
    for (var index = 0; index < records.length; index++) {
      final record = records[index];
      await vault.requireMigrationTarget(record.origin, id, expected: record);
      final store = await devices.deviceStore(record);
      await store?.requireMigrationTarget(id);
      final entry = (payload['devices'] as List)[index] as Map;
      await store?.validateCheckpoint(
        Map<String, dynamic>.from(entry['mls'] as Map),
      );
    }
  }

  Future<HomeArchiveInspection?> _inspectHome(
    File? file,
    Map<String, dynamic> payload,
    List<DeviceRecord> records,
  ) async {
    final origin = payload['home_origin'];
    if ((file == null) != (origin == null)) {
      throw const FormatException('Отсутствуют данные домашнего пространства');
    }
    if (file == null) return null;
    if (!home.supported) {
      throw StateError('Для восстановления Эфира нужен компьютер');
    }
    final report = await home.inspectArchive(file.path);
    final owners = records.where((record) => record.origin == origin);
    if (report == null ||
        owners.length != 1 ||
        report.serverId != owners.single.serverId) {
      throw const FormatException(
        'Домашнее пространство не соответствует ключам',
      );
    }
    return report;
  }

  Future<void> _installRecords(
    List<DeviceRecord> records,
    Map<String, dynamic> payload,
    String id,
  ) async {
    for (var index = 0; index < records.length; index++) {
      final record = records[index];
      final entry = (payload['devices'] as List)[index] as Map;
      final store = await devices.deviceStore(record);
      await store?.restoreCheckpoint(
        Map<String, dynamic>.from(entry['mls'] as Map),
        id,
      );
      if (record.origin == payload['home_origin']) {
        final network = home.network;
        if (network == null || network.identityOrigin != record.origin) {
          throw StateError('Адрес восстановленного Эфира не совпадает');
        }
        record.endpoint = network.endpoints.first.origin.toString();
      }
      await vault.installMigration(record, id);
    }
  }
}
