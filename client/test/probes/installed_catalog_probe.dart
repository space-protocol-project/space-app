import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as paths;
import 'package:space_client/app.dart';
import 'package:space_client/src/app_shutdown.dart';
import 'package:space_client/src/extensions_p1/bundled_catalog.dart';
import 'package:space_client/src/extensions_p1/catalog_grant_cubit.dart';
import 'package:space_client/src/extensions_p1/installed_extensions_cubit.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_host.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_types.dart';
import 'package:space_client/src/extensions_p1/local_session_cubit.dart';

import 'directory_crash_windows.dart' show initializeCrashWindows;
import 'local_profile_native_probe.dart' show NativeProfileStorage;

Future<void> main() async {
  if (Platform.environment['GITHUB_ACTIONS'] != 'true') exit(2);
  WidgetsFlutterBinding.ensureInitialized();
  await initializeCrashWindows();
  final root = Platform.environment['DIRECTORY_CRASH_CONTROL']!;
  final role = Platform.environment['DIRECTORY_CRASH_ROLE']!;
  final access = LocalSessionCubit(
    authenticate: () async =>
        (device: 'device', profile: 'profile', actor: 'owner'),
  );
  final runtime = SpaceCatalogRuntime();
  final shutdown = AppShutdown();
  final helper = await BundledCatalog.resolve();
  final picker = helper.picker(choose: () async => paths.join(root, 'Games'));
  final owner = InstalledExtensionsCubit(
    access,
    runtime,
    storage: NativeProfileStorage(),
    directory: () async => paths.join(root, 'extensions'),
    picker: () async => picker,
    shutdown: shutdown,
  );
  CatalogGrantCubit? screen;
  try {
    runApp(
      SpaceApp(
        extensionAccess: access,
        catalogRuntime: runtime,
        shutdown: shutdown,
      ),
    );
    final deadline = DateTime.now().add(const Duration(seconds: 30));
    while (WidgetsBinding.instance.lifecycleState !=
        AppLifecycleState.resumed) {
      if (DateTime.now().isAfter(deadline)) throw StateError('focus timeout');
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    if (!await access.unlock()) throw StateError('session');
    if (role == 'corrupt') {
      try {
        await runtime.ensure(access.session);
        throw StateError('accepted corrupt package');
      } catch (_) {
        if (runtime.forSession(access.session) != null ||
            owner.state != InstalledExtensionsState.unavailable) {
          rethrow;
        }
      }
    } else {
      await runtime.ensure(access.session);
      final bytes = [0, 97, 115, 109, 1, 0, 0, 0];
      if (role == 'install') {
        await owner.installAccepted(
          access.session,
          LocalVerifiedPackage(sha256.convert(bytes).toString(), 1, [
            'device.catalog.read',
          ]),
          bytes,
          installation: 'games',
          instance: 'games',
        );
      }
      final host = runtime.forSession(access.session)!;
      if (host.snapshot(access.session).entries['games']!['state'] !=
          'disabled') {
        throw StateError('restored access');
      }
      screen = CatalogGrantCubit(access, runtime);
      final ready = DateTime.now().add(const Duration(seconds: 10));
      while (screen.state is! CatalogTargets) {
        if (DateTime.now().isAfter(ready)) throw StateError('targets timeout');
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
      await screen.choose('games');
      await screen.unlock();
      await screen.approve();
      final granted = screen.state;
      if (granted is! CatalogGranted) throw StateError('grant ${screen.state}');
      late String handle;
      await host.listCatalog(access.session, 'games', granted.root, (page) {
        if (page.entries.single.name != 'sample') throw StateError('entries');
        handle = page.entries.single.handle;
      });
      late String data;
      await host.readCatalog(
        access.session,
        'games',
        granted.root,
        handle,
        (chunk) => data = utf8.decode(chunk.bytes),
        offset: 0,
        limit: 64,
      );
      if (data != 'installed catalog') throw StateError('bytes');
      final lease = host.beginRead(access.session, 'games', granted.root);
      final session = access.session;
      if (!await shutdown.request()) throw StateError('shutdown');
      if (!lease.isCancelled || runtime.forSession(session) != null) {
        throw StateError('leaked owner');
      }
      lease.close();
    }
    await owner.close();
    await File(paths.join(root, '$role.json')).writeAsString(
      jsonEncode({
        'role': role,
        'pid': pid,
        'helper': helper.executable,
        'sha256': helper.digest,
        'passed': true,
      }),
      flush: true,
    );
  } catch (error, stack) {
    await File(paths.join(root, 'error.json'))
        .writeAsString(jsonEncode({'error': '$error', 'stack': '$stack'}));
    exitCode = 1;
  } finally {
    await screen?.close();
    await owner.close();
    await access.close();
    await runtime.close();
    await shutdown.close();
  }
  exit(exitCode);
}
