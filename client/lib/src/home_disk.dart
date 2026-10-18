import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'home_backup.dart';
import 'home_disk_tree.dart';
import 'home_installation.dart';
import 'home_runtime.dart';
import 'home_runtime_cleanup.dart';
import 'home_storage.dart';
import 'home_update_journal.dart';

class HomeDiskItem {
  const HomeDiskItem(
    this.category,
    this.name,
    this.bytes,
    this.fingerprint, {
    this.modifiedAt,
  });
  final String category, name, fingerprint;
  final int bytes;
  final DateTime? modifiedAt;
  String get id => '$category/$name';
}

class HomeDiskReport {
  HomeDiskReport({
    required this.root,
    required this.dataBytes,
    required this.runtimeBytes,
    required this.backupBytes,
    required this.recoveryBytes,
    required this.availableBytes,
    required Iterable<HomeDiskItem> candidates,
    required this.context,
  }) : candidates = List.unmodifiable(candidates);
  final String root, context;
  final int dataBytes, runtimeBytes, backupBytes, recoveryBytes, availableBytes;
  final List<HomeDiskItem> candidates;
}

/// Вызывается под process.lock; удаление разрешено только при остановленном сервере.
class HomeDiskManager {
  HomeDiskManager(
    this.root, {
    this.storage = const HomeStorage(),
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;
  final Directory root;
  final HomeStorage storage;
  final DateTime Function() clock;
  static const keepBackups = 3;
  static const minimumAge = Duration(days: 30);

  Future<HomeDiskReport> scan() async {
    await requireHomeDiskDirectory(root);
    final sizes = <String, int>{};
    for (final name in ['data', 'runtimes', 'backups', 'recoveries']) {
      sizes[name] = await homeDirectoryBytes(
        Directory(path.join(root.path, name)),
      );
    }
    final candidates = <HomeDiskItem>[];
    final context = await _context();
    if (context.isNotEmpty) {
      for (final folder in await HomeRuntimeCleanup(root).obsolete()) {
        candidates.add(await _item(folder, 'runtimes'));
      }
      candidates.addAll(await _oldBackups());
    }
    return HomeDiskReport(
      root: await root.resolveSymbolicLinks(),
      dataBytes: sizes['data']!,
      runtimeBytes: sizes['runtimes']!,
      backupBytes:
          sizes['backups']! +
          await homeDirectoryBytes(
            Directory(path.join(root.path, 'scheduled-backups')),
          ),
      recoveryBytes: sizes['recoveries']!,
      availableBytes: await storage.available(root),
      candidates: candidates,
      context: context,
    );
  }

  Future<String> _context() async {
    try {
      await HomeUpdateJournal(root).requireSettled();
      final selection = HomeInstallation(root).selection;
      if (!await selection.exists()) return '';
      final record = HomeUpdateJournal(root).file;
      if (await selection.length() > 65536) return '';
      if (await record.exists() && await record.length() > 65536) return '';
      return jsonEncode([
        await selection.readAsString(),
        await record.exists() ? await record.readAsString() : '',
      ]);
    } on Object {
      return '';
    }
  }

  Future<HomeDiskItem> _item(Directory folder, String category) async {
    final (bytes, fingerprint) = await homeDiskTree(folder);
    return HomeDiskItem(
      category,
      path.basename(folder.path),
      bytes,
      fingerprint,
      modifiedAt:
          (await FileSystemEntity.isFile(path.join(folder.path, 'backup.json')))
          ? (await File(path.join(folder.path, 'backup.json')).stat()).modified
          : (await folder.stat()).modified,
    );
  }

  Future<List<HomeDiskItem>> _oldBackups() async {
    final folder = Directory(path.join(root.path, 'backups'));
    if (!await folder.exists()) return [];
    await requireHomeDiskDirectory(folder);
    final saved = jsonDecode(
      await HomeInstallation(root).selection.readAsString(),
    ) as Map;
    if (saved['format'] != 1) return [];
    final release = HomeRelease.fromJson(
      Map<String, dynamic>.from(saved['active'] as Map),
    );
    await HomeInstallation(root).verify(release);
    final current = await HomeUpdateJournal(root).read();
    final valid = <(Directory, DateTime)>[];
    await for (final entry in folder.list(followLinks: false)) {
      final candidate = await _backupCandidate(entry, release);
      if (candidate != null) valid.add(candidate);
    }
    valid.sort((a, b) {
      final order = b.$2.compareTo(a.$2);
      return order != 0 ? order : a.$1.path.compareTo(b.$1.path);
    });
    final result = <HomeDiskItem>[];
    for (final (directory, modified) in valid.skip(keepBackups)) {
      if (path.basename(directory.path) == current?.id ||
          clock().difference(modified) < minimumAge) {
        continue;
      }
      result.add(await _item(directory, 'backups'));
    }
    return result;
  }

  Future<(Directory, DateTime)?> _backupCandidate(
    FileSystemEntity entry,
    HomeRelease release,
  ) async {
    if (entry is! Directory ||
        !RegExp(r'^update-[a-f0-9]{32}$').hasMatch(path.basename(entry.path))) {
      return null;
    }
    try {
      final folder = await homeDiskChild(
        root,
        'backups',
        path.basename(entry.path),
      );
      await verifyHomeBackup(folder, release);
      return (
        folder,
        (await File(path.join(folder.path, 'backup.json')).stat()).modified,
      );
    } on Object {
      return null;
    }
  }

  Future<List<String>> clean(
    HomeDiskReport approved,
    Set<String> selected,
  ) async {
    if (selected.isEmpty) return [];
    final fresh = await scan();
    if (fresh.context.isEmpty ||
        fresh.context != approved.context ||
        fresh.root != approved.root) {
      throw const FormatException(
        'Состояние сервера изменилось. Повторите проверку диска',
      );
    }
    final targets = <HomeDiskItem>[];
    for (final id in selected) {
      final before = approved.candidates.where((item) => item.id == id).single;
      final now = fresh.candidates.where((item) => item.id == id).single;
      if (before.fingerprint != now.fingerprint || before.bytes != now.bytes) {
        throw const FormatException(
          'Файлы изменились. Повторите проверку диска',
        );
      }
      targets.add(now);
    }
    final removed = <String>[];
    for (final item in targets) {
      final folder = await homeDiskChild(root, item.category, item.name);
      if ((await homeDiskTree(folder)).$2 != item.fingerprint) {
        throw const FormatException('Файлы изменились. Очистка остановлена');
      }
      await deleteHomeDiskTree(folder);
      removed.add(item.id);
    }
    return removed;
  }
}
