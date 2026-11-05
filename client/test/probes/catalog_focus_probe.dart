import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/extensions_p1/catalog_grant_cubit.dart';
import 'package:space_client/src/extensions_p1/desktop_catalog.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_host.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_types.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_record.dart';
import 'package:space_client/src/extensions_p1/local_profile_verifier.dart';
import 'package:space_client/src/extensions_p1/local_profile_record.dart';
import 'package:space_client/src/extensions_p1/local_session_cubit.dart';
import 'package:space_client/ui/shell.dart';

import '../support/local_lifecycle_fixture.dart';
import 'local_profile_native_probe.dart' show NativeProfileStorage, secret;

class FocusTrace with WidgetsBindingObserver {
  final events = <String>[];
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    events.add(state.name);
    stderr.writeln('focus: ${state.name}');
  }
}

T? findWidget<T extends Widget>([Object? key]) {
  T? found;
  void visit(Element e) {
    final widgetKey = e.widget.key;
    if (e.widget is T &&
        (key == null || widgetKey is ValueKey && widgetKey.value == key)) {
      found = e.widget as T;
    }
    if (found == null) e.visitChildren(visit);
  }

  WidgetsBinding.instance.rootElement?.visitChildren(visit);
  return found;
}

Future<void> until(String reason, bool Function() test) async {
  final deadline = DateTime.now().add(const Duration(seconds: 40));
  while (!test()) {
    if (DateTime.now().isAfter(deadline)) throw StateError(reason);
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

Future<void> password(String value, {bool create = false}) async {
  await until(
    'password form',
    () => findWidget<TextField>('local-profile-password') != null,
  );
  findWidget<TextField>('local-profile-password')!.controller!.text = value;
  if (create) {
    findWidget<TextField>('local-profile-confirm')!.controller!.text = value;
  }
  findWidget<FilledButton>('local-profile-submit')!.onPressed!();
}

Future<void> button(String key) async {
  await until(key, () => findWidget<FilledButton>(key)?.onPressed != null);
  findWidget<FilledButton>(key)!.onPressed!();
}

Future<void> main() async {
  if (Platform.environment['GITHUB_ACTIONS'] != 'true') exit(2);
  WidgetsFlutterBinding.ensureInitialized();
  final trace = FocusTrace();
  WidgetsBinding.instance.addObserver(trace);
  final root = Platform.environment['CATALOG_DRILL']!;
  final folder = '$root/Games';
  final runtime = SpaceCatalogRuntime();
  final storage = NativeProfileStorage();
  final service = LocalProfileVerifier(
    storage,
    lockPath: () async => '$root/profile.lock',
  );
  LocalLifecycleHost? owner;
  try {
    runApp(SpaceApp(catalogRuntime: runtime, profileVerifier: service));
    await until(
      'active SpaceApp',
      () =>
          findWidget<SpaceShell>() != null &&
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed,
    );
    final access = findWidget<SpaceShell>()!.extensionAccess!;
    final first = access.unlock();
    await password(secret, create: true);
    if (!await first) throw StateError('first unlock');
    final session = access.session;
    final picker = DesktopCatalogPicker(
      Platform.environment['SPACE_CATALOG_HELPER']!,
      choose: () =>
          getDirectoryPath(initialDirectory: Directory(folder).absolute.path),
    );
    final authority = FixtureAuthority();
    final host = LocalLifecycleHost.open(
      '$root/registry',
      device: session.device,
      profile: session.profile,
      sessions: access.sessions,
      authority: authority,
      picker: picker,
    );
    owner = host;
    await host.execute(
      session,
      LocalLifecycleCommand(
        action: LocalLifecycleAction.install,
        installation: 'games',
        instance: 'games',
        revision: 0,
        generation: host.snapshot(session).generation,
        package: 'a' * 64,
      ),
    );
    final record = lifecycleOf(host.snapshot(session).entries['games']!);
    await host.execute(
      session,
      LocalLifecycleCommand(
        action: LocalLifecycleAction.enable,
        installation: 'games',
        instance: 'games',
        revision: record['revision']! as int,
        generation: record['generation']! as String,
      ),
    );
    runtime.attach(session, host);
    final nav = findWidget<MaterialApp>()!.navigatorKey!.currentState!;
    unawaited(nav.pushNamed('/device/catalogs'));
    await until(
      'target',
      () => findWidget<ListTile>('catalog-target-games') != null,
    );
    trace.events.clear();
    findWidget<ListTile>('catalog-target-games')!.onTap!();
    await until(
      'picker returned',
      () =>
          findWidget<FilledButton>('catalog-unlock') != null &&
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed,
    );
    if (access.state != LocalSessionStatus.locked ||
        !trace.events.contains('inactive') ||
        !trace.events.contains('resumed')) {
      throw StateError('missing real focus transition ${trace.events}');
    }
    await button('catalog-unlock');
    await password('incorrect CI password');
    await until(
      'wrong password rejected',
      () =>
          findWidget<TextField>('local-profile-password') != null &&
          access.state == LocalSessionStatus.authenticating,
    );
    // Контроллеры очищаются сразу, ждём повторной готовности после KDF.
    await until(
      'password denial',
      () => findWidget<Text>(LocalProfileFailure.denied) != null,
    );
    await password(secret);
    await until(
      'review',
      () => findWidget<FilledButton>('catalog-approve') != null,
    );
    final fresh = access.session;
    if (identical(fresh, session) ||
        host.snapshot(fresh).entries['games']!['state'] != 'disabled') {
      throw StateError('premature enable');
    }
    await button('catalog-approve');
    await until(
      'committed',
      () => host.snapshot(fresh).entries['games']!['state'] == 'enabled',
    );
    final id = authority.confirmedRoot!;
    late String handle;
    await host.listCatalog(
      fresh,
      'games',
      id,
      (p) => handle = p.entries.single.handle,
    );
    late String data;
    await host.readCatalog(
      fresh,
      'games',
      id,
      handle,
      (c) => data = utf8.decode(c.bytes),
      offset: 0,
      limit: 64,
    );
    if (data != 'catalog-focus-ci') throw StateError('wrong folder');
    access.lock();
    await picker.stopped;
    await File('$root/report.json').writeAsString(
      jsonEncode({
        'os': Platform.operatingSystem,
        'focus': trace.events,
        'wrong_password_rejected': true,
        'fresh_session': true,
        'confirmed_read': true,
        'relocked': true,
      }),
    );
  } catch (error, stack) {
    stderr.writeln('$error\n$stack');
    exitCode = 1;
  } finally {
    owner?.close();
    await storage.delete(key: LocalProfileVerifier.storageKey);
  }
  exit(exitCode);
}
