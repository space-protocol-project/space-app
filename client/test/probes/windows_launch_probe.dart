import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as paths;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_windows/shared_preferences_windows.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/desktop_window.dart';
import 'package:space_client/src/extensions_p1/local_profile_record.dart';
import 'package:space_client/src/extensions_p1/local_session_cubit.dart';
import 'package:space_client/src/notification_targets.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/secure_vault.dart';
import 'package:space_client/src/system_notifications.dart';
import 'package:space_client/ui/shell.dart';
import 'package:window_manager/window_manager.dart';

import 'catalog_focus_probe.dart' show findWidget;
import 'directory_crash_windows.dart' show CrashWindowsPaths;

late Directory root;
const secret = 'synthetic launch profile password';
final focusEvents = <String>[];

class LaunchFocus with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    focusEvents.add(state.name);
  }
}

Future<void> until(bool Function() ready) async {
  final deadline = DateTime.now().add(const Duration(seconds: 35));
  while (!ready()) {
    if (DateTime.now().isAfter(deadline)) throw StateError('launch timeout');
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

Future<void> write(String name, Object data) async {
  final pending = File(paths.join(root.path, '$name.pending'));
  await pending.writeAsString(jsonEncode(data), flush: true);
  await pending.rename(paths.join(root.path, '$name.json'));
}

Future<void> password(String value, {bool create = false}) async {
  await until(() => findWidget<TextField>('local-profile-password') != null);
  findWidget<TextField>('local-profile-password')!.controller!.text = value;
  if (create) {
    findWidget<TextField>('local-profile-confirm')!.controller!.text = value;
  }
  findWidget<FilledButton>('local-profile-submit')!.onPressed!();
}

Future<void> unlock(LocalSessionCubit access) async {
  if (access.state != LocalSessionStatus.locked) {
    throw StateError('activation unlocked profile');
  }
  final marker = File(paths.join(root.path, 'profile.created'));
  final create = !marker.existsSync();
  final result = access.unlock();
  if (!create) {
    await password('incorrect launch password');
    await until(() => findWidget<Text>(LocalProfileFailure.denied) != null);
  }
  await password(secret, create: create);
  if (!await result) throw StateError('unlock failed');
  await marker.writeAsString('created');
}

Future<Map<String, Object?>> snapshot(LocalSessionCubit access) async {
  final raw = await const PlatformKeyStorage().read(
    key: NotificationTargets.key,
  );
  final tokens = raw == null ? <String, dynamic>{} : jsonDecode(raw) as Map;
  return {
    'pid': pid,
    'state': access.state.name,
    'lifecycle': WidgetsBinding.instance.lifecycleState?.name,
    'focus': List<String>.of(focusEvents),
    'pending_targets': tokens.length,
  };
}

Future<void> command(Map request, LocalSessionCubit access) async {
  final action = request['action'];
  if (action == 'unlock') await unlock(access);
  if (action == 'maximize') await windowManager.maximize();
  if (action == 'toast-warm' || action == 'toast-cold') {
    await windowManager.minimize();
    await until(() => access.state == LocalSessionStatus.locked);
    final service = SystemNotifications(appName: 'SpaceLaunchCI');
    await service.show(
      id: 1,
      title: 'Space launch ${request['id']}',
      body: 'Synthetic CI notification',
      target: ['https://fixture.invalid', 'test-user', 'general', 1],
    );
  }
  await write('reply', {'id': request['id'], ...await snapshot(access)});
  if (action == 'toast-cold' || action == 'quit') exit(0);
}

Future<void> main() async {
  if (!const bool.fromEnvironment('SPACE_LAUNCH_CI')) exit(2);
  final config = File(
    paths.join(paths.dirname(Platform.resolvedExecutable), 'launch-ci.json'),
  );
  root = Directory(
    (jsonDecode(await config.readAsString()) as Map)['root'] as String,
  );
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(LaunchFocus());
  final directory = Directory(paths.join(root.path, 'system-storage'));
  await directory.create(recursive: true);
  final provider = CrashWindowsPaths(directory.path);
  PathProviderPlatform.instance = provider;
  SharedPreferencesStorePlatform.instance = SharedPreferencesWindows()
    ..pathProvider = provider;
  try {
    final preferences = AppPreferences();
    await preferences.load();
    await preferences.changeNotifications(1);
    await preferences.close();
    final desktop = await DesktopWindowState.initialize();
    runApp(const SpaceApp());
    await desktop?.restore();
    await until(
      () =>
          findWidget<SpaceShell>() != null &&
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed,
    );
    final access = findWidget<SpaceShell>()!.extensionAccess!;
    if (access.state != LocalSessionStatus.locked)
      throw StateError('startup unlocked');
    await write('boot', await snapshot(access));
    final commandFile = File(paths.join(root.path, 'command.json'));
    String? previous = commandFile.existsSync()
        ? (jsonDecode(commandFile.readAsStringSync()) as Map)['id'] as String
        : null;
    while (true) {
      await write('state', await snapshot(access));
      final file = File(paths.join(root.path, 'command.json'));
      if (file.existsSync()) {
        final request = jsonDecode(await file.readAsString()) as Map;
        if (request['id'] != previous) {
          previous = request['id'] as String;
          await command(request, access);
        }
      }
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
  } catch (error, stack) {
    await write('error', {
      'error': '$error',
      'stack': '$stack',
      'focus': focusEvents,
    });
    exit(1);
  }
}
