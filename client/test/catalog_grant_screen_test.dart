import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/extensions_p1/catalog_grant_cubit.dart';
import 'package:space_client/src/extensions_p1/local_catalog_types.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_host.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_types.dart';
import 'package:space_client/src/extensions_p1/local_session_cubit.dart';

import 'support/local_lifecycle_fixture.dart';

class Root extends LocalCatalogRoot {
  bool closed = false;
  @override
  String get displayPath => '/Selected/Games';
  @override
  void close() {
    closed = true;
  }

  @override
  Future<CatalogPage> list(int limit, String? cursor) =>
      throw UnimplementedError();
  @override
  Future<CatalogChunk> read(String handle, int offset, int limit) =>
      throw UnimplementedError();
}

class Picker implements LocalCatalogPicker {
  final root = Root();
  @override
  Future<LocalCatalogRoot> select(
    String instance,
    String package,
    void Function() guard,
  ) async {
    guard();
    return root;
  }
}

class Harness {
  final dir = Directory.systemTemp.createTempSync();
  final runtime = SpaceCatalogRuntime();
  final authority = FixtureAuthority();
  final picker = Picker();
  String actor = 'owner';
  String profile = 'profile';
  late final access = LocalSessionCubit(
    authenticate: () async =>
        (profile: profile, device: 'device', actor: actor),
  );
  late LocalLifecycleHost host;
  Future<void> init() async {
    access.setForeground(true);
    await access.unlock();
    final session = access.session;
    host = LocalLifecycleHost.open(
      '${dir.path}/registry',
      device: 'device',
      profile: 'profile',
      sessions: access.sessions,
      authority: authority,
      picker: picker,
    );
    await host.execute(
      session,
      LocalLifecycleCommand(
        action: LocalLifecycleAction.install,
        installation: 'games',
        instance: 'games',
        package: 'a' * 64,
        generation: host.snapshot(session).generation,
        revision: 0,
      ),
    );
    runtime.attach(session, host);
  }

  Future<void> close() async {
    host.close();
    await access.close();
    dir.deleteSync(recursive: true);
  }
}

void main() {
  testWidgets(
    'маршрут SpaceApp требует повторной разблокировки и явного согласия',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1440, 900);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      final h = Harness();
      await tester.pumpWidget(
        SpaceApp(extensionAccess: h.access, catalogRuntime: h.runtime),
      );
      await tester.pumpAndSettle();
      await h.init();
      await tester.ensureVisible(
        find.byKey(const ValueKey('my-device-tab')).first,
      );
      await tester.tap(find.byKey(const ValueKey('my-device-tab')).first);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('device-catalogs')));
      await tester.tap(find.byKey(const ValueKey('device-catalogs')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('catalog-target-games')));
      await tester.pumpAndSettle();
      expect(h.access.state, LocalSessionStatus.locked);
      expect(find.text('/Selected/Games'), findsNothing);
      await tester.tap(find.byKey(const ValueKey('catalog-unlock')));
      await tester.pumpAndSettle();
      expect(find.text('/Selected/Games'), findsOneWidget);
      expect(
        h.host.snapshot(h.access.session).entries['games']!['state'],
        'disabled',
      );
      await tester.tap(find.byKey(const ValueKey('catalog-approve')));
      await tester.pumpAndSettle();
      expect(
        h.host.snapshot(h.access.session).entries['games']!['state'],
        'enabled',
      );
      h.access.lock();
      expect(h.picker.root.closed, true);
      await tester.pumpWidget(const SizedBox());
      await h.close();
    },
  );
  test('смена автора закрывает выбранный корень', () async {
    final h = Harness();
    await h.init();
    final c = CatalogGrantCubit(h.access, h.runtime);
    await c.choose('games');
    h.actor = 'another';
    await c.unlock();
    expect(c.state, isA<CatalogFailed>());
    expect(h.picker.root.closed, true);
    await c.close();
    await h.close();
  });
  test('смена профиля требует нового выбора папки', () async {
    final h = Harness();
    await h.init();
    final c = CatalogGrantCubit(h.access, h.runtime);
    await c.choose('games');
    h.profile = 'other';
    await c.unlock();
    expect(c.state, isA<CatalogFailed>());
    expect(h.picker.root.closed, true);
    await c.close();
    await h.close();
  });
  test('отключённый во время согласия хост не публикует доступ', () async {
    final h = Harness();
    await h.init();
    final c = CatalogGrantCubit(h.access, h.runtime);
    await c.choose('games');
    await c.unlock();
    final before = h.host.snapshot(h.access.session);
    h.authority.beforeGrantConsent = () async {
      h.runtime.detach(h.host);
    };
    await c.approve();
    expect(h.host.snapshot(h.access.session).revision, before.revision);
    expect(h.picker.root.closed, true);
    await c.close();
    await h.close();
  });
  test('отказ при выдаче не публикует включение', () async {
    final h = Harness();
    await h.init();
    final c = CatalogGrantCubit(h.access, h.runtime);
    await c.choose('games');
    await c.unlock();
    final before = h.host.snapshot(h.access.session);
    h.authority.beforeGrantConsent = () async {
      h.authority.consent = false;
    };
    await c.approve();
    final after = h.host.snapshot(h.access.session);
    expect(after.revision, before.revision);
    expect(after.entries, before.entries);
    expect(h.picker.root.closed, true);
    await c.close();
    await h.close();
  });
  test('блокировка до COMMIT отклоняет позднее согласие', () async {
    final h = Harness();
    await h.init();
    final c = CatalogGrantCubit(h.access, h.runtime);
    await c.choose('games');
    await c.unlock();
    h.authority.beforeGrantConsent = () async {
      h.access.lock();
    };
    await c.approve();
    expect(c.state, isA<CatalogLocked>());
    expect(h.picker.root.closed, true);
    await h.access.unlock();
    expect(
      h.host.snapshot(h.access.session).entries['games']!['state'],
      'disabled',
    );
    await c.close();
    await h.close();
  });
}
