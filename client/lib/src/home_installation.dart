import 'dart:convert';
import 'dart:io';

import 'home_runtime.dart';
import 'local_failure.dart';

/// Выбор установленного выпуска выполняется под блокировкой HomeController.
class HomeInstallation {
  HomeInstallation(this.root);
  final Directory root;

  File get selection => File('${root.path}/active-runtime.json');
  bool _sameDirectory(Directory left, Directory right) =>
      left.absolute.uri.normalizePath() == right.absolute.uri.normalizePath();
  Directory runtime(HomeRelease release) =>
      Directory('${root.path}/runtimes/${release.version}-${release.platform}');

  Future<Map<String, dynamic>> _read(File file) async {
    if (await file.length() > 8192) throw _invalid;
    final value = jsonDecode(await file.readAsString());
    if (value is! Map<String, dynamic>) throw _invalid;
    return value;
  }

  static const _invalid = LocalFailure(
    LocalFailureCode.releaseInvalid,
    'Не удалось проверить установленную версию сервера; автоматическая замена запрещена',
  );

  Future<void> verify(HomeRelease release) async {
    final folder = runtime(release);
    final marker = File('${folder.path}/installed.json');
    final executable = File(
      '${folder.path}/${Platform.isWindows ? 'space-server.exe' : 'space-server'}',
    );
    if (!await marker.exists() || !await executable.exists()) throw _invalid;
    if ((await _read(marker))['sha256'] != release.sha256) throw _invalid;
  }

  /// Новый манифест приложения не заменяет уже выбранный выпуск.
  Future<HomeRelease?> active(
    HomeRelease offered, {
    Iterable<HomeRelease> legacy = const [],
    bool persist = true,
  }) async {
    if (await selection.exists()) {
      final saved = await _read(selection);
      if (saved['format'] != 1) throw _invalid;
      final release = HomeRelease.fromJson(
        Map<String, dynamic>.from(saved['active'] as Map),
      );
      if (release.platform != offered.platform) throw _invalid;
      await verify(release);
      return release;
    }

    // Прежние установки не имели active-runtime.json. Только один
    // подтверждённый выпуск можно перенести без выбора за владельца.
    final folder = Directory('${root.path}/runtimes');
    final candidates = <HomeRelease>[];
    if (await folder.exists()) {
      await for (final item in folder.list()) {
        if (item is! Directory) continue;
        final marker = File('${item.path}/installed.json');
        if (!await marker.exists()) continue;
        final saved = await _read(marker);
        final HomeRelease release;
        if (saved['release'] is Map) {
          release = HomeRelease.fromJson(
            Map<String, dynamic>.from(saved['release'] as Map),
          );
        } else {
          final matches =
              [
                    offered,
                    ...legacy.where(
                      (known) =>
                          known.version != offered.version ||
                          known.platform != offered.platform,
                    ),
                  ]
                  .where(
                    (known) =>
                        _sameDirectory(item, runtime(known)) &&
                        saved['sha256'] == known.sha256,
                  )
                  .toList();
          if (matches.length != 1) throw _invalid;
          release = matches.single;
        }
        if (!_sameDirectory(item, runtime(release)) ||
            release.platform != offered.platform) {
          throw _invalid;
        }
        await verify(release);
        candidates.add(release);
      }
    }
    if (candidates.length > 1) throw _invalid;
    if (candidates.isNotEmpty) {
      if (persist) await selectInitial(candidates.single);
      return candidates.single;
    }
    if (await Directory('${root.path}/data').exists()) throw _invalid;
    return null;
  }

  Future<void> selectInitial(HomeRelease release) async {
    await verify(release);
    if (await selection.exists()) throw _invalid;
    final pending = File('${selection.path}.tmp');
    await pending.writeAsString(
      jsonEncode({'format': 1, 'active': release.toJson()}),
      flush: true,
    );
    await pending.rename(selection.path);
  }

  Future<void> activate(HomeRelease expected, HomeRelease next) async {
    await verify(next);
    final saved = await _read(selection);
    final current = HomeRelease.fromJson(
      Map<String, dynamic>.from(saved['active'] as Map),
    );
    bool same(HomeRelease a, HomeRelease b) =>
        jsonEncode(a.toJson()) == jsonEncode(b.toJson());
    if (same(current, next)) return;
    if (!same(current, expected)) throw _invalid;
    await verify(expected);
    final temporary = File('${selection.path}.tmp');
    await temporary.writeAsString(
      jsonEncode({
        'format': 1,
        'active': next.toJson(),
        'previous': expected.toJson(),
      }),
      flush: true,
    );
    await temporary.rename(selection.path);
  }

  Future<Directory> prepare(
    HomeRelease release, {
    required Future<void> Function(HomeRelease, File, void Function(double))
    download,
    required void Function(double) progress,
    required void Function() extracting,
  }) async {
    final target = runtime(release);
    if (await target.exists()) {
      await verify(release);
      return target;
    }
    final folder = await Directory('${root.path}/runtimes')
        .create(recursive: true);
    final temporary = await folder.createTemp('download-');
    try {
      final archive = File('${temporary.path}/runtime.zip');
      await download(release, archive, progress);
      extracting();
      final unpacked = await Directory('${temporary.path}/unpacked').create();
      await extractHomeRelease(archive, unpacked, release.sha256);
      if (!await File(
        '${unpacked.path}/${Platform.isWindows ? 'space-server.exe' : 'space-server'}',
      ).exists()) {
        throw const LocalFailure(
          LocalFailureCode.releaseInvalid,
          'В выпуске нет сервера',
        );
      }
      await File('${unpacked.path}/installed.json').writeAsString(
        jsonEncode({'sha256': release.sha256, 'release': release.toJson()}),
        flush: true,
      );
      await unpacked.rename(target.path);
      await verify(release);
      return target;
    } finally {
      await temporary.delete(recursive: true);
    }
  }
}
