import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'core.dart';
import 'home_controller.dart';
import 'key_vault.dart';
import 'migration_archive.dart';
import 'migration_temporary.dart';
import 'mls/local_store.dart';
import 'mls/native.dart';

class HomeMigration {
  HomeMigration({
    required this.vault,
    required this.storage,
    required this.locks,
    MlsEngine? engine,
  }) : engine = engine ?? NativeMlsEngine();
  final KeyIdentityVault vault;
  final SecureKeyStorage storage;
  final Future<Directory> Function() locks;
  final MlsEngine engine;

  Future<MlsLocalStore?> deviceStore(DeviceRecord record) => _store(record);

  Future<void> installServer({
    required HomeController home,
    required String path,
    required String publicIP,
    required HomeArchiveInspection report,
    required String id,
  }) => _installServer(home, path, publicIP, report, id);

  Future<MlsLocalStore?> _store(DeviceRecord record) async {
    final scope = record.mlsIdentity;
    if (scope == null) {
      if (record.mlsChannels.isNotEmpty) {
        throw StateError('Отсутствует состояние MLS');
      }
      return null;
    }
    final identity = await record.identity();
    // После смены root/device аутентификация использует новый ключ, а MLS
    // сохраняет прежнюю привязку. Её подпись проверяет нативный модуль.
    if (scope['server_id'] != record.serverId ||
        scope['principal_id'] != identity.principalId) {
      throw const FormatException('Ключ MLS не соответствует устройству');
    }
    return MlsLocalStore(
      storage: storage,
      engine: engine,
      scope: scope,
      deviceSeed: record.deviceSeed,
      lockDirectory: await locks(),
      requireExisting: true,
    );
  }

  Future<void> export({
    required HomeController home,
    required String path,
    required String password,
    required Future<void> Function() stop,
  }) async {
    final origin = home.network?.identityOrigin;
    if (origin == null) throw StateError('Адрес пространства не найден');
    if (await vault.loadRotation(origin) != null) {
      throw StateError('Сначала завершите смену ключа пространства');
    }
    final pending = File('$path.pending');
    if (await pending.exists() && !await File(path).exists()) {
      await _resumeExport(home, pending, path, password, origin, stop);
      return;
    }
    await _requireNewFiles(path, pending.path);
    await stop();
    if (home.running) throw StateError('Сервер не остановлен');
    final record = await vault.load(origin);
    if (record == null) {
      throw StateError('Ключи этого пространства не найдены на устройстве');
    }
    await record.identity();
    final store = await _store(record);
    final temporary = await Directory.systemTemp.createTemp('space-migration-');
    try {
      final server = File('${temporary.path}/server.zip');
      if (!await home.exportData(server.path)) throw StateError(home.error);
      final inspection = await home.inspectArchive(server.path);
      if (inspection == null || inspection.serverId != record.serverId) {
        throw StateError('Серверный архив не соответствует ключам устройства');
      }
      final id = newRequestKey();
      Future<void> preserve(Map<String, dynamic>? checkpoint) async {
        await compute(preserveMigrationInWorker, <String, dynamic>{
          'server': server.path,
          'password': password,
          'destination': pending.path,
          'device': {
            'v': 1,
            'kind': 'space-full-migration',
            'id': id,
            'server_digest': inspection.digest,
            'device': record.toJson(),
            'mls': checkpoint,
          },
        });
      }

      if (store == null) {
        await preserve(null);
      } else {
        await store.transferCheckpoint(id, preserve);
      }
      // Готовый .pending остаётся пригодным для импорта и при сбое публикации.
      await vault.retireForMigration(origin, id);
      await File(
        '${(await home.directory()).path}/device-migration-exported.json',
      ).writeAsString(jsonEncode({'v': 1, 'id': id}), flush: true);
      await MigrationArchive.commit(pending);
      if (await File(path).exists()) {
        throw StateError('Файл назначения уже существует; сохранён .pending');
      }
      await pending.rename(path);
    } finally {
      await removeMigrationTemporary(temporary);
    }
  }

  Future<void> _resumeExport(
    HomeController home,
    File pending,
    String path,
    String password,
    String origin,
    Future<void> Function() stop,
  ) async {
    final payload = await _open(pending.path, password, allowUncommitted: true);
    final archived = await _record(payload);
    final id = payload['id'] as String;
    final current = await vault.migrationSource(origin, id);
    if (archived.origin != origin ||
        !await _matchesSource(current, archived, id)) {
      throw StateError(
        'Незавершённый архив не соответствует исходному устройству',
      );
    }
    final store = await _store(archived);
    if (store != null &&
        !await store.resumeTransfer(
          Map<String, dynamic>.from(payload['mls'] as Map),
          id,
        )) {
      throw StateError(
        'Прежнее устройство не остановлено. Выберите новое имя архива и повторите экспорт.',
      );
    }
    await stop();
    if (home.running) throw StateError('Сервер не остановлен');
    await vault.retireForMigration(origin, id);
    await File(
      '${(await home.directory()).path}/device-migration-exported.json',
    ).writeAsString(jsonEncode({'v': 1, 'id': id}), flush: true);
    // При сбое после commit повторно дописывать отметку нельзя.
    try {
      await _open(pending.path, password);
    } on FormatException {
      await MigrationArchive.commit(pending);
    }
    if (await File(path).exists()) {
      throw StateError('Файл назначения уже существует');
    }
    await pending.rename(path);
  }

  Future<void> _requireNewFiles(String path, String pending) async {
    if (await FileSystemEntity.type(path, followLinks: false) !=
            FileSystemEntityType.notFound ||
        await FileSystemEntity.type(pending, followLinks: false) !=
            FileSystemEntityType.notFound) {
      throw StateError(
        'Выберите новое имя файла: существующие архивы не заменяются',
      );
    }
  }

  Future<bool> _matchesSource(
    DeviceRecord? current,
    DeviceRecord archived,
    String id,
  ) async {
    if (current == null) return vault.retiredForMigration(archived.origin, id);
    return jsonEncode(current.toJson()) == jsonEncode(archived.toJson());
  }

  Future<bool> import({
    required HomeController home,
    required String path,
    required String password,
    required String publicIP,
    required Future<bool> Function(HomeArchiveInspection) confirm,
    required Future<void> Function(String) remember,
  }) async {
    final temporary = await Directory.systemTemp.createTemp('space-migration-');
    try {
      final server = File('${temporary.path}/server.zip');
      final payload = await _open(path, password, server: server.path);
      final record = await _record(payload);
      final id = payload['id'] as String;
      await vault.requireMigrationTarget(record.origin, id, expected: record);
      final store = await _store(record);
      await store?.requireMigrationTarget(id);
      if (store != null) {
        await store.validateCheckpoint(
          Map<String, dynamic>.from(payload['mls'] as Map),
        );
      }
      final report = await home.inspectArchive(server.path);
      if (report == null ||
          report.digest != payload['server_digest'] ||
          report.serverId != record.serverId) {
        throw const FormatException(
          'Данные сервера не соответствуют устройству',
        );
      }
      if (!await confirm(report)) return false;
      await _installServer(home, server.path, publicIP, report, id);
      if (store != null) {
        await store.restoreCheckpoint(
          Map<String, dynamic>.from(payload['mls'] as Map),
          id,
        );
      }
      final network = home.network;
      if (network == null || network.identityOrigin != record.origin) {
        throw const FormatException(
          'Адрес восстановленного пространства не совпадает',
        );
      }
      record.endpoint = network.endpoints.first.origin.toString();
      await vault.installMigration(record, id);
      await remember(record.origin);
      return true;
    } finally {
      await removeMigrationTemporary(temporary);
    }
  }

  Future<Map<String, dynamic>> _open(
    String path,
    String password, {
    String? server,
    bool allowUncommitted = false,
  }) => compute(openMigrationInWorker, <String, dynamic>{
    'source': path,
    'password': password,
    'server': server,
    'allow_uncommitted': allowUncommitted,
  });

  Future<DeviceRecord> _record(Map<String, dynamic> payload) async {
    final id = payload['id'];
    if (payload['v'] != 1 ||
        payload['kind'] != 'space-full-migration' ||
        id is! String ||
        !RegExp(r'^[A-Za-z0-9_-]{32}$').hasMatch(id)) {
      throw const FormatException('Неподдерживаемый архив переноса');
    }
    final record = DeviceRecord.fromJson(
      Map<String, dynamic>.from(payload['device'] as Map),
    );
    await record.identity();
    if ((record.mlsIdentity == null) != (payload['mls'] == null)) {
      throw const FormatException('Архив содержит неполное состояние MLS');
    }
    return record;
  }

  Future<void> _installServer(
    HomeController home,
    String path,
    String publicIP,
    HomeArchiveInspection report,
    String id,
  ) async {
    final root = await home.directory();
    final receipt = File('${root.path}/device-migration.json');
    final expected = jsonEncode({'v': 1, 'id': id, 'digest': report.digest});
    await root.create(recursive: true);
    if (await receipt.exists()) {
      if (await receipt.readAsString() != expected) {
        throw StateError('Начат перенос другого архива');
      }
    } else {
      if (home.ip.isNotEmpty) {
        throw StateError('Пространство уже создано на этом компьютере');
      }
      await receipt.create(exclusive: true);
      await receipt.writeAsString(expected, flush: true);
    }
    if (home.ip.isNotEmpty) {
      final imported = File('${root.path}/transferred/import-source.sha256');
      if (!await imported.exists() ||
          await imported.readAsString() != report.digest) {
        throw StateError('Не подтверждён прежний импорт сервера');
      }
      return;
    }
    if (!await home.importData(path, publicIP: publicIP, inspection: report)) {
      throw StateError(home.error);
    }
  }
}
