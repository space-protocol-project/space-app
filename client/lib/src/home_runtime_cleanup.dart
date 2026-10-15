import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'home_installation.dart';
import 'home_runtime.dart';
import 'home_update_journal.dart';

/// Вызывается под process.lock. Ошибка очистки не отменяет обновление.
class HomeRuntimeCleanup {
  HomeRuntimeCleanup(this.root);
  final Directory root;

  Future<List<String>> run() async {
    final removed = <String>[];
    try {
      final candidates = await obsolete();
      for (final folder in candidates) {
        try {
          await folder.delete(recursive: true);
          removed.add(path.basename(folder.path));
        } on FileSystemException {
          // Занятые или недоступные файлы остаются до следующей очистки.
        }
      }
    } on Object {
      // При неоднозначном выборе версии ничего не удаляем.
    }
    return removed;
  }

  Future<List<Directory>> obsolete() async {
    final record = await HomeUpdateJournal(root).read();
    if (record?.step != HomeUpdateStep.completeUpdated) return [];
    final installation = HomeInstallation(root);
    final saved = await _read(installation.selection);
    final active = HomeRelease.fromJson(
      Map<String, dynamic>.from(saved['active'] as Map),
    );
    final previous = HomeRelease.fromJson(
      Map<String, dynamic>.from(saved['previous'] as Map),
    );
    if (saved['format'] != 1 ||
        !_sameRelease(active, record!.target) ||
        !_sameRelease(previous, record.source)) {
      return [];
    }
    await installation.verify(active);
    await installation.verify(previous);
    final canonicalRoot = await root.resolveSymbolicLinks();
    final runtimes = Directory('${root.path}/runtimes');
    if (await FileSystemEntity.type(runtimes.path, followLinks: false) !=
        FileSystemEntityType.directory) {
      return [];
    }
    final canonicalRuntimes = await runtimes.resolveSymbolicLinks();
    if (!path.equals(path.dirname(canonicalRuntimes), canonicalRoot)) return [];
    final keep = {
      path.basename(installation.runtime(active).path),
      path.basename(installation.runtime(previous).path),
    };
    final candidates = <Directory>[];
    await for (final item in runtimes.list(followLinks: false)) {
      if (item is! Directory || keep.contains(path.basename(item.path))) {
        continue;
      }
      if (await _isRuntime(item, active.platform, canonicalRuntimes)) {
        candidates.add(item);
      }
    }
    return candidates;
  }

  bool _sameRelease(HomeRelease left, HomeRelease right) =>
      left.version == right.version &&
      left.platform == right.platform &&
      left.sha256 == right.sha256;

  Future<Map<String, dynamic>> _read(File file) async {
    if (await file.length() > 65536) {
      throw const FormatException('Слишком большой файл runtime');
    }
    return Map<String, dynamic>.from(
      jsonDecode(await file.readAsString()) as Map,
    );
  }

  Future<bool> _isRuntime(
    Directory folder,
    String platform,
    String parent,
  ) async {
    try {
      final name = path.basename(folder.path);
      if (!RegExp(
        r'^v[0-9]+\.[0-9]+\.[0-9]+(?:-[A-Za-z0-9.-]+)?-' + platform + r'$',
      ).hasMatch(name)) {
        return false;
      }
      if (!path.equals(
        path.dirname(await folder.resolveSymbolicLinks()),
        parent,
      )) {
        return false;
      }
      final marker = await _read(File('${folder.path}/installed.json'));
      if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(marker['sha256'] as String)) {
        return false;
      }
      if (marker['release'] != null) {
        final release = HomeRelease.fromJson(
          Map<String, dynamic>.from(marker['release'] as Map),
        );
        if (name != '${release.version}-${release.platform}' ||
            marker['sha256'] != release.sha256) {
          return false;
        }
      }
      if (!await File(
        '${folder.path}/${Platform.isWindows ? 'space-server.exe' : 'space-server'}',
      ).exists()) {
        return false;
      }
      await for (final item in folder.list(
        recursive: true,
        followLinks: false,
      )) {
        if (item is Link) return false;
      }
      return true;
    } on Object {
      return false;
    }
  }
}
