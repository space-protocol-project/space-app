import 'dart:convert';
import 'dart:io';

import 'home_installation.dart';
import 'home_runtime.dart';
import 'home_runtime_cleanup.dart';
import 'home_update_journal.dart';
import 'local_failure.dart';
import 'home_storage.dart';
import 'home_backup.dart';

typedef HomeTool = Future<Map<String, dynamic>> Function(
  Directory runtime,
  List<String> arguments,
);

Future<Map<String, dynamic>> runHomeTool(
  Directory runtime,
  List<String> arguments,
) async {
  final result = await Process.run(
    '${runtime.path}/${Platform.isWindows ? 'space-server.exe' : 'space-server'}',
    arguments,
  );
  if (result.exitCode != 0) {
    throw const LocalFailure(
      LocalFailureCode.homeUpdateFailed,
      'Проверка или обновление домашнего сервера не выполнены',
    );
  }
  final output = result.stdout as String;
  if (output.length > 16384) throw HomeUpdateJournal.pending;
  return output.trim().isEmpty
      ? {}
      : Map<String, dynamic>.from(jsonDecode(output) as Map);
}

/// Исполнитель вызывается только под process.lock и после остановки сервера.
class HomeUpdateExecutor {
  HomeUpdateExecutor(
    this.root, {
    this.tool = runHomeTool,
    this.storage = const HomeStorage(),
  });
  final Directory root;
  final HomeTool tool;
  final HomeStorage storage;
  HomeInstallation get installation => HomeInstallation(root);
  HomeUpdateJournal get journal => HomeUpdateJournal(root);
  String get data => '${root.path}/data';

  Future<void> verifyCandidate(HomeRelease target) async {
    await installation.verify(target);
    await _capabilities(target);
  }

  List<String> _arguments(Directory runtime, String flag, String directory) => [
    flag,
    '-home-runtime',
    runtime.path,
    '-home-data',
    directory,
  ];

  Future<Map<String, dynamic>> _check(
    Directory runtime,
    String directory, {
    bool migrate = false,
  }) async {
    final info = await tool(
      runtime,
      _arguments(runtime, migrate ? '-home-migrate' : '-home-check', directory),
    );
    if (info['serverId'] is! String ||
        !RegExp(r'^srv_[0-9a-f]{32}$').hasMatch(info['serverId'] as String) ||
        info['tlsFingerprint'] is! String ||
        !RegExp(r'^[0-9a-f]{64}$').hasMatch(info['tlsFingerprint'] as String) ||
        info['postgresMajor'] != 17 ||
        info['schemaVersion'] is! int ||
        (info['schemaVersion'] as int) < 1) {
      throw HomeUpdateJournal.pending;
    }
    return info;
  }

  Future<int> _capabilities(HomeRelease release) async {
    final info = await tool(installation.runtime(release), ['-runtime-info']);
    final parts = release.platform.split('-');
    final os = parts[0] == 'macos' ? 'darwin' : parts[0];
    final arch = parts[1] == 'x64' ? 'amd64' : 'arm64';
    if (info['format'] != 1 ||
        info['os'] != os ||
        info['arch'] != arch ||
        info['postgresMajor'] != 17 ||
        info['protocolVersion'] != '0.1-experimental' ||
        info['schemaVersion'] is! int ||
        (info['schemaVersion'] as int) < 1) {
      throw const LocalFailure(
        LocalFailureCode.releaseInvalid,
        'Несовместимый runtime',
      );
    }
    return info['schemaVersion'] as int;
  }

  File _evidence(HomeUpdateRecord record) =>
      File('${root.path}/${record.id}-baseline.json');
  Future<Map<String, dynamic>> _baseline(HomeUpdateRecord record) async {
    try {
      final file = _evidence(record);
      if (!await file.exists() || await file.length() > 16384) {
        throw HomeUpdateJournal.pending;
      }
      final info = Map<String, dynamic>.from(
        jsonDecode(await file.readAsString()) as Map,
      );
      if (info['serverId'] is! String ||
          !RegExp(r'^srv_[0-9a-f]{32}$').hasMatch(info['serverId']) ||
          info['tlsFingerprint'] is! String ||
          !RegExp(r'^[0-9a-f]{64}$').hasMatch(info['tlsFingerprint']) ||
          info['schemaVersion'] is! int ||
          info['schemaVersion'] < 1 ||
          info['postgresMajor'] != 17) {
        throw HomeUpdateJournal.pending;
      }
      return info;
    } catch (_) {
      throw const LocalFailure(
        LocalFailureCode.homeRecoveryInvalid,
        'Контрольная запись исходной базы отсутствует или повреждена',
      );
    }
  }

  void _sameBaseline(Map<String, dynamic> before, Map<String, dynamic> after) {
    if (before['serverId'] != after['serverId'] ||
        before['tlsFingerprint'] != after['tlsFingerprint'] ||
        before['schemaVersion'] != after['schemaVersion']) {
      throw const LocalFailure(
        LocalFailureCode.homeRecoveryInvalid,
        'Восстановленная схема не соответствует исходной базе',
      );
    }
  }

  Future<HomeUpdateRecord?> inspectRecovery() async {
    final record = await journal.read();
    if (record == null ||
        record.settled ||
        record.recovery == HomeRecoveryAction.resumePreparation) {
      return record;
    }
    await _baseline(record);
    if (record.recovery == HomeRecoveryAction.restoreBackup &&
        !await Directory('${root.path}/${record.restorePath}').exists()) {
      await requireHomeBackup(Directory('${root.path}/${record.backupPath}'));
    }
    return record;
  }

  void _sameIdentity(Map<String, dynamic> before, Map<String, dynamic> after) {
    if (before['serverId'] != after['serverId'] ||
        before['tlsFingerprint'] != after['tlsFingerprint']) {
      throw HomeUpdateJournal.pending;
    }
  }

  void _compatible(Map<String, dynamic> info, int schema) {
    final target = info['targetSchemaVersion'];
    if (target is! int ||
        target != schema ||
        (info['schemaVersion'] as int) > schema) {
      throw const LocalFailure(
        LocalFailureCode.releaseInvalid,
        'Схема базы не соответствует возможностям runtime',
      );
    }
  }

  Future<void> update(HomeRelease source, HomeRelease target) async {
    if (!target.isNewerThan(source)) {
      throw const LocalFailure(
        LocalFailureCode.releaseInvalid,
        'Нельзя обновить сервер на прежнюю версию',
      );
    }
    await installation.verify(source);
    await installation.verify(target);
    final active = await installation.active(target);
    if (active == null ||
        jsonEncode(active.toJson()) != jsonEncode(source.toJson())) {
      throw HomeUpdateJournal.pending;
    }
    final schema = await _capabilities(target);
    await storage.check(root);
    final runtime = installation.runtime(target);
    final record = await journal.begin(source, target);
    try {
      await journal.advance(record.id, HomeUpdateStep.staged);
      final before = await _check(runtime, data);
      await storage.check(root);
      _compatible(before, schema);
      await journal.advance(record.id, HomeUpdateStep.stopped);
      await tool(runtime, [
        '-home-backup',
        '${root.path}/${record.backupPath}',
        '-home-runtime',
        runtime.path,
        '-home-data',
        data,
      ]);
      await _evidence(record).writeAsString(jsonEncode(before), flush: true);
      await journal.advance(record.id, HomeUpdateStep.backedUp);
      // process.lock всё ещё удерживается; проверяем комплект и базу
      // повторно после резервной копии, до первого изменения схемы.
      await installation.verify(target);
      if (await _capabilities(target) != schema) {
        throw const LocalFailure(
          LocalFailureCode.releaseInvalid,
          'Возможности runtime изменились после подготовки',
        );
      }
      final current = await _check(runtime, data);
      _compatible(current, schema);
      _sameIdentity(before, current);
      if (current['schemaVersion'] != before['schemaVersion']) {
        throw const LocalFailure(
          LocalFailureCode.releaseInvalid,
          'Схема базы изменилась после резервного копирования',
        );
      }
      await journal.advance(record.id, HomeUpdateStep.migrating);
      final after = await _check(runtime, data, migrate: true);
      _compatible(after, schema);
      _sameIdentity(before, after);
      if (after['schemaVersion'] != schema) throw HomeUpdateJournal.pending;
      await journal.advance(record.id, HomeUpdateStep.verified);
      await journal.advance(record.id, HomeUpdateStep.activating);
      await installation.activate(source, target);
      await journal.advance(record.id, HomeUpdateStep.completeUpdated);
      await HomeRuntimeCleanup(root).run();
    } catch (problem) {
      await recover(retryPreparation: false);
      final step = (await journal.read())?.step;
      if (step == HomeUpdateStep.completeUpdated) {
        return;
      }
      if (step == HomeUpdateStep.cancelled) {
        if (problem is LocalFailure &&
            problem.code == LocalFailureCode.releaseInvalid) {
          rethrow;
        }
        throw const LocalFailure(
          LocalFailureCode.homeUpdateFailed,
          'Подготовка прервана до миграций; прежний выпуск остаётся активным',
        );
      }
      throw const LocalFailure(
        LocalFailureCode.homeUpdateFailed,
        'Обновление не выполнено; восстановлен прежний выпуск',
      );
    }
  }

  Future<void> recover({bool retryPreparation = true}) async {
    var record = await journal.read();
    if (record == null || record.settled) return;
    if (record.recovery == HomeRecoveryAction.resumePreparation) {
      await journal.advance(record.id, HomeUpdateStep.cancelled);
      if (retryPreparation) await update(record.source, record.target);
      return;
    }
    final runtime = installation.runtime(record.target);
    await installation.verify(record.target);
    final baseline = await _baseline(record);
    if (record.step == HomeUpdateStep.verified ||
        record.step == HomeUpdateStep.activating) {
      try {
        final actual = await _check(runtime, data);
        _sameIdentity(baseline, actual);
        if (actual['schemaVersion'] != await _capabilities(record.target)) {
          throw HomeUpdateJournal.pending;
        }
        await journal.advance(record.id, HomeUpdateStep.activating);
        await installation.activate(record.source, record.target);
        await journal.advance(record.id, HomeUpdateStep.completeUpdated);
        await HomeRuntimeCleanup(root).run();
        return;
      } catch (_) {
        record = await journal.advance(record.id, HomeUpdateStep.restoring);
      }
    }
    if (record.step == HomeUpdateStep.migrating) {
      record = await journal.advance(record.id, HomeUpdateStep.restoring);
    }
    if (record.step == HomeUpdateStep.restoring) {
      await _restoreBackup(record, runtime, baseline);
    }
    final restoredCheck = await _check(runtime, data);
    _sameIdentity(baseline, restoredCheck);
    if (restoredCheck['schemaVersion'] != baseline['schemaVersion']) {
      throw HomeUpdateJournal.pending;
    }
    await installation.activate(record.target, record.source);
    await journal.advance(record.id, HomeUpdateStep.completeRestored);
  }

  Future<void> _restoreBackup(
    HomeUpdateRecord record,
    Directory runtime,
    Map<String, dynamic> baseline,
  ) async {
    final restore = Directory('${root.path}/${record.restorePath}');
    final restoredData = Directory('${restore.path}/data');
    final failed = Directory('${root.path}/failed-data/${record.id}');
    final current = Directory(data);
    if (!await restore.exists()) {
      await verifyHomeBackup(
        Directory('${root.path}/${record.backupPath}'),
        record.target,
      );
      await storage.check(
        root,
        dataCopies: 0,
        additionalBytes: await homeDirectoryBytes(
          Directory('${root.path}/${record.backupPath}/data'),
        ),
      );
      await tool(runtime, [
        '-home-restore',
        '${root.path}/${record.backupPath}',
        '-home-restore-to',
        restore.path,
        '-home-runtime',
        runtime.path,
      ]);
    }
    if (await restoredData.exists()) {
      _sameBaseline(baseline, await _check(runtime, restoredData.path));
      if (!await failed.exists()) {
        await tool(runtime, _arguments(runtime, '-home-stopped', data));
        await failed.parent.create(recursive: true);
        await current.rename(failed.path);
      } else if (await current.exists()) {
        throw HomeUpdateJournal.pending;
      }
      await restoredData.rename(data);
    } else if (!await failed.exists() || !await current.exists()) {
      throw const LocalFailure(
        LocalFailureCode.homeRecoveryInvalid,
        'Каталоги восстановления находятся в неоднозначном состоянии',
      );
    }
    _sameBaseline(baseline, await _check(runtime, data));
    await journal.advance(record.id, HomeUpdateStep.restored);
  }
}
