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
  Future<HomeRelease?> active(HomeRelease offered) async {
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
        } else if (_sameDirectory(item, runtime(offered)) &&
            saved['sha256'] == offered.sha256) {
          release = offered;
        } else {
          // Не угадываем версию старой базы при изменившемся манифесте.
          throw _invalid;
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
      await selectInitial(candidates.single);
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
}
