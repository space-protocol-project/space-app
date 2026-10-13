// Проверочный процесс CI: production main.dart не содержит тестовых режимов.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/app_updates.dart';
import 'package:space_client/src/secure_vault.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isWindows ||
      Platform.environment['GITHUB_ACTIONS'] != 'true' ||
      args.length != 6 ||
      !['write', 'install', 'read', 'cleanup'].contains(args[0]) ||
      !RegExp(r'^[a-f0-9]{32}$').hasMatch(args[1])) {
    exit(2);
  }
  final phase = args[0], id = args[1];
  final report = File(args[2]);
  final installed = Directory(args[3]);
  final setup = File(args[4]);
  final expectedDigest = args[5];
  final preferences = await SharedPreferences.getInstance();
  final storage = const PlatformKeyStorage();
  final key = 'space.update.probe.$id';
  final support = await getApplicationSupportDirectory();
  final marker = File('${support.path}/home-server/data/update-probe-$id.txt');
  try {
    if (phase == 'write') {
      if (await storage.read(key: key) != null ||
          preferences.containsKey(key) ||
          await marker.exists()) {
        throw StateError('Проверочный слот уже занят');
      }
      await storage.write(key: key, value: id);
      if (!await preferences.setString(key, id)) {
        throw StateError('Настройки не сохранены');
      }
      await marker.parent.create(recursive: true);
      await marker.writeAsString(id, flush: true);
      await report.writeAsString(
        jsonEncode({'write': true, 'support': support.path}),
        flush: true,
      );
    } else if (phase == 'install') {
      if (!await File('${installed.path}/unins000.exe').exists()) {
        throw StateError('Нет исходной установки');
      }
      final package = AppPackage(
        'Space-Setup-windows-x64.exe',
        Uri.parse('https://github.com'),
        await setup.length(),
        'sha256:$expectedDigest',
      );
      final updates =
          AppUpdates(
              platform: 'windows-x64',
              installationDirectory: () async => installed,
              downloadDirectory: () async => report.parent,
              closeApplication: () {
                report.writeAsStringSync(
                  jsonEncode({
                    'write': true,
                    'launched': true,
                    'support': support.path,
                  }),
                  flush: true,
                );
                exit(0);
              },
            )
            ..downloadedPackage = setup
            ..status = AppUpdateStatus.available
            ..release = AppRelease(
              'v0.2.1',
              Uri.parse('https://github.com'),
              '',
              AppVersion.parse('0.2.1')!,
              {package.name: package},
            );
      await updates.install(
        prepare: () async {
          if (preferences.getString(key) != id ||
              await storage.read(key: key) != id ||
              await marker.readAsString() != id) {
            throw StateError('Исходные данные изменились');
          }
        },
      );
      throw StateError('Установщик не запущен');
    } else if (phase == 'read') {
      if (preferences.getString(key) != id ||
          await storage.read(key: key) != id ||
          await marker.readAsString() != id) {
        throw StateError('Данные после установки изменились');
      }
      final previous = jsonDecode(await report.readAsString()) as Map;
      if (previous['support'] != support.path || previous['launched'] != true) {
        throw StateError('Каталог поддержки или запуск не подтверждены');
      }
      await report.writeAsString(
        jsonEncode({...previous, 'preserved': true}),
        flush: true,
      );
    } else {
      await storage.delete(key: key);
      await preferences.remove(key);
      if (await marker.exists()) await marker.delete();
    }
    exit(0);
  } catch (_) {
    await File('${report.path}.error').writeAsString('Ошибка фазы $phase');
    exit(1);
  }
}
