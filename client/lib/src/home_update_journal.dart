import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'home_runtime.dart';
import 'local_failure.dart';

enum HomeUpdateStep {
  preparing,
  staged,
  stopped,
  backedUp,
  migrating,
  verified,
  activating,
  restoring,
  restored,
  completeUpdated,
  completeRestored,
  cancelled,
}

enum HomeRecoveryAction {
  resumePreparation,
  restoreBackup,
  finishActivation,
  none,
}

class HomeUpdateRecord {
  HomeUpdateRecord(this.id, this.source, this.target, this.step);
  final String id;
  final HomeRelease source, target;
  final HomeUpdateStep step;
  bool get settled => [
    HomeUpdateStep.completeUpdated,
    HomeUpdateStep.completeRestored,
    HomeUpdateStep.cancelled,
  ].contains(step);
  String get backupPath => 'backups/$id';
  String get restorePath => 'recoveries/$id';
  HomeRecoveryAction get recovery => switch (step) {
    HomeUpdateStep.preparing ||
    HomeUpdateStep.staged ||
    HomeUpdateStep.stopped ||
    HomeUpdateStep.backedUp => HomeRecoveryAction.resumePreparation,
    HomeUpdateStep.migrating ||
    HomeUpdateStep.restoring => HomeRecoveryAction.restoreBackup,
    HomeUpdateStep.verified ||
    HomeUpdateStep.activating ||
    HomeUpdateStep.restored => HomeRecoveryAction.finishActivation,
    HomeUpdateStep.completeUpdated ||
    HomeUpdateStep.completeRestored ||
    HomeUpdateStep.cancelled => HomeRecoveryAction.none,
  };
  Map<String, dynamic> toJson() => {
    'format': 1,
    'id': id,
    'source': source.toJson(),
    'target': target.toJson(),
    'step': step.name,
  };
  factory HomeUpdateRecord.fromJson(Map<String, dynamic> json) {
    if (json['format'] != 1 ||
        json['id'] is! String ||
        !RegExp(r'^update-[a-f0-9]{32}$').hasMatch(json['id'] as String)) {
      throw const FormatException('Повреждён журнал обновления');
    }
    final source = HomeRelease.fromJson(
      Map<String, dynamic>.from(json['source'] as Map),
    );
    final target = HomeRelease.fromJson(
      Map<String, dynamic>.from(json['target'] as Map),
    );
    if (source.platform != target.platform || !target.isNewerThan(source)) {
      throw const FormatException('Недопустимая пара выпусков');
    }
    return HomeUpdateRecord(
      json['id'] as String,
      source,
      target,
      HomeUpdateStep.values.byName(json['step'] as String),
    );
  }
}

/// Журнал хранится под той же блокировкой, что и запуск домашнего сервера.
/// Запись шага не выполняет саму операцию: управляющий процесс пишет её
/// до потенциального изменения данных и подтверждает результат после проверки.
class HomeUpdateJournal {
  HomeUpdateJournal(this.root);
  final Directory root;
  File get file => File('${root.path}/update-operation.json');
  static const pending = LocalFailure(
    LocalFailureCode.homeUpdatePending,
    'Обновление домашнего сервера не завершено; сначала восстановите операцию',
  );
  static const invalid = LocalFailure(
    LocalFailureCode.homeJournalInvalid,
    'Журнал обновления повреждён или недоступен; требуется ручная проверка',
  );

  Future<HomeUpdateRecord?> read() async {
    try {
      if (!await file.exists()) {
        if (await File('${file.path}.tmp').exists()) throw invalid;
        return null;
      }
      if (await file.length() > 65536) throw invalid;
      return HomeUpdateRecord.fromJson(
        Map<String, dynamic>.from(jsonDecode(await file.readAsString()) as Map),
      );
    } catch (_) {
      throw invalid;
    }
  }

  Future<void> requireSettled() async {
    if ((await read())?.settled == false) throw pending;
  }

  Future<HomeUpdateRecord> begin(HomeRelease source, HomeRelease target) async {
    await requireSettled();
    final random = Random.secure();
    final id =
        'update-${List.generate(16, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join()}';
    final record = HomeUpdateRecord.fromJson(
      HomeUpdateRecord(id, source, target, HomeUpdateStep.preparing).toJson(),
    );
    await _write(record);
    return record;
  }

  Future<HomeUpdateRecord> advance(String id, HomeUpdateStep next) async {
    final record = await read();
    if (record == null || record.id != id) {
      throw pending;
    }
    if (record.step == next) return record;
    if (!_allowed(record.step, next)) {
      throw pending;
    }
    final updated = HomeUpdateRecord(id, record.source, record.target, next);
    await _write(updated);
    return updated;
  }

  bool _allowed(HomeUpdateStep current, HomeUpdateStep next) {
    if (next == HomeUpdateStep.cancelled) {
      return [
        HomeUpdateStep.preparing,
        HomeUpdateStep.staged,
        HomeUpdateStep.stopped,
        HomeUpdateStep.backedUp,
      ].contains(current);
    }
    if (next == HomeUpdateStep.restoring) {
      return [
        HomeUpdateStep.migrating,
        HomeUpdateStep.verified,
        HomeUpdateStep.activating,
      ].contains(current);
    }
    return switch (current) {
      HomeUpdateStep.preparing => next == HomeUpdateStep.staged,
      HomeUpdateStep.staged => next == HomeUpdateStep.stopped,
      HomeUpdateStep.stopped => next == HomeUpdateStep.backedUp,
      HomeUpdateStep.backedUp => next == HomeUpdateStep.migrating,
      HomeUpdateStep.migrating => next == HomeUpdateStep.verified,
      HomeUpdateStep.verified => next == HomeUpdateStep.activating,
      HomeUpdateStep.activating => next == HomeUpdateStep.completeUpdated,
      HomeUpdateStep.restoring => next == HomeUpdateStep.restored,
      HomeUpdateStep.restored => next == HomeUpdateStep.completeRestored,
      HomeUpdateStep.completeUpdated ||
      HomeUpdateStep.completeRestored ||
      HomeUpdateStep.cancelled => false,
    };
  }

  Future<void> _write(HomeUpdateRecord record) async {
    final temporary = File('${file.path}.tmp');
    await temporary.writeAsString(jsonEncode(record.toJson()), flush: true);
    await temporary.rename(file.path);
  }
}
