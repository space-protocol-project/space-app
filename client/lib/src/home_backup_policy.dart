import 'dart:convert';
import 'dart:io';

import 'home_disk_tree.dart';
import 'home_update_executor.dart';

class HomeBackupPolicy {
  const HomeBackupPolicy({
    this.enabled = false,
    this.prune = false,
    this.intervalHours = 24,
    this.keepCount = 7,
    this.keepDays = 30,
    this.maxBytes = 0,
  });
  final bool enabled, prune;
  final int intervalHours, keepCount, keepDays, maxBytes;
  Map<String, dynamic> toJson() => {
    'format': 1,
    'enabled': enabled,
    'prune': prune,
    'intervalHours': intervalHours,
    'keepCount': keepCount,
    'keepDays': keepDays,
    'maxBytes': maxBytes,
  };
  factory HomeBackupPolicy.fromJson(Map<String, dynamic> value) {
    if (value['format'] != 1 ||
        value['enabled'] is! bool ||
        (value['prune'] != null && value['prune'] is! bool)) {
      throw const FormatException('Некорректные настройки копирования');
    }
    return HomeBackupPolicy(
      enabled: value['enabled'] as bool,
      prune: value['prune'] as bool? ?? false,
      intervalHours: _backupNumber(value['intervalHours'], 1, 168),
      keepCount: _backupNumber(value['keepCount'], 3, 100),
      keepDays: _backupNumber(value['keepDays'], 1, 3650),
      maxBytes: _backupNumber(value['maxBytes'], 0, 1 << 40),
    );
  }
}

int _backupNumber(Object? value, int minimum, int maximum) {
  if (value is! int || value < minimum || value > maximum) {
    throw const FormatException('Недопустимое значение настройки копирования');
  }
  return value;
}

class HomeBackupStatus {
  const HomeBackupStatus({
    this.code = 'waiting',
    this.lastSuccessAt = 0,
    this.nextAt = 0,
    this.count = 0,
    this.bytes = 0,
    this.protected = 0,
    this.limited = false,
  });
  final String code;
  final int lastSuccessAt, nextAt, count, bytes, protected;
  final bool limited;
  factory HomeBackupStatus.fromJson(Map<String, dynamic> value) {
    const codes = {
      'disabled',
      'waiting',
      'running',
      'ok',
      'failed',
      'space_low',
      'invalid_policy',
    };
    if (value['format'] != 1 ||
        !codes.contains(value['code']) ||
        value['limited'] is! bool) {
      throw const FormatException('Некорректный статус копирования');
    }
    return HomeBackupStatus(
      code: value['code'] as String,
      lastSuccessAt: _backupNumber(value['lastSuccessAt'], 0, 8640000000000000),
      nextAt: _backupNumber(value['nextAt'], 0, 8640000000000000),
      count: _backupNumber(value['count'], 0, 10000),
      bytes: _backupNumber(value['bytes'], 0, 1 << 50),
      protected: _backupNumber(value['protected'], 0, 10000),
      limited: value['limited'] as bool,
    );
  }
}

class HomeBackupSettings {
  const HomeBackupSettings(this.policy, this.status, this.supported);
  final HomeBackupPolicy policy;
  final HomeBackupStatus status;
  final bool supported;
}

class HomeBackupPreferences {
  HomeBackupPreferences(this.root, this.runtime, {this.tool = runHomeTool});
  final Directory root;
  final Directory? runtime;
  final HomeTool tool;
  Future<Map<String, dynamic>?> _read(String name) async {
    final file = File('${root.path}/$name');
    final type = await FileSystemEntity.type(file.path, followLinks: false);
    if (type == FileSystemEntityType.notFound) return null;
    if (type != FileSystemEntityType.file || await file.length() > 65536) {
      throw const FormatException('Не удалось проверить настройки копирования');
    }
    return jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  }

  Future<bool> _supported() async {
    final selected = runtime;
    return selected != null &&
        (await tool(selected, ['-runtime-info']))['scheduledBackupsVersion'] ==
            1;
  }

  Future<HomeBackupSettings> load() async {
    final policy = await _read('backup-policy.json');
    final status = await _read('backup-status.json');
    return HomeBackupSettings(
      policy == null
          ? const HomeBackupPolicy()
          : HomeBackupPolicy.fromJson(policy),
      status == null
          ? const HomeBackupStatus()
          : HomeBackupStatus.fromJson(status),
      await _supported(),
    );
  }

  Future<void> save(HomeBackupPolicy policy) async {
    HomeBackupPolicy.fromJson(policy.toJson());
    if (policy.enabled && !await _supported()) {
      throw const FormatException(
        'Установите или обновите runtime для копирования по расписанию',
      );
    }
    final temporary = await root.createTemp('.backup-settings-');
    try {
      final file = File('${temporary.path}/policy.json');
      await file.writeAsString(jsonEncode(policy.toJson()), flush: true);
      await file.rename('${root.path}/backup-policy.json');
    } finally {
      await deleteHomeDiskTree(temporary);
    }
  }
}
