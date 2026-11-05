import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as paths;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/app_shutdown.dart';
import 'package:space_client/src/extensions_p1/bundled_catalog.dart';
import 'package:space_client/src/extensions_p1/catalog_grant_cubit.dart';
import 'package:space_client/src/extensions_p1/desktop_catalog.dart';
import 'package:space_client/src/extensions_p1/installed_extensions_cubit.dart';
import 'package:space_client/src/extensions_p1/installed_packages.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_host.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_types.dart';
import 'package:space_client/src/extensions_p1/local_session_cubit.dart';
import 'package:space_client/src/secure_vault.dart';
import 'package:space_client/ui/local_extension_session_scope.dart';

class MemoryKeys implements SecureKeyStorage {
  final values = <String, String>{};
  @override
  Future<String?> read({required String key}) async => values[key];
  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }
}

void main() {
  final bytes = utf8.encode('synthetic accepted package');
  final package = LocalVerifiedPackage(sha256.convert(bytes).toString(), 1, [
    'device.catalog.read',
  ]);
  late Directory root;
  late MemoryKeys keys;
  late LocalSessionCubit access;
  late SpaceCatalogRuntime runtime;
  late InstalledExtensionsCubit owner;
  var profile = 'profile';
  InstalledExtensionsCubit create() => InstalledExtensionsCubit(
    access,
    runtime,
    storage: keys,
    directory: () async => root.path,
    picker: () async =>
        DesktopCatalogPicker(paths.join(root.path, 'unused-helper')),
  );
  setUp(() async {
    root = Directory.systemTemp.createTempSync('installed-extensions-');
    keys = MemoryKeys();
    profile = 'profile';
    access = LocalSessionCubit(
      authenticate: () async =>
          (device: 'device', profile: profile, actor: 'owner'),
    )..setForeground(true);
    runtime = SpaceCatalogRuntime();
    owner = create();
    await access.unlock();
    await runtime.ensure(access.session);
  });
  tearDown(() async {
    await owner.close();
    await access.close();
    await runtime.close();
    root.deleteSync(recursive: true);
  });
  Future<void> install() => owner.installAccepted(
    access.session,
    package,
    bytes,
    installation: 'games',
    instance: 'games',
  );

  test(
    'принятая установка подключается и восстанавливается после открытия',
    () async {
      await install();
      expect(
        runtime.forSession(access.session)!.catalogInstances(access.session),
        ['games'],
      );
      await owner.close();
      expect(runtime.forSession(access.session), isNull);
      owner = create();
      await runtime.ensure(access.session);
      expect(
        runtime
            .forSession(access.session)!
            .snapshot(access.session)
            .entries['games']!['state'],
        'disabled',
      );
    },
  );
  test(
    'блокировка сохраняет хост для выбора, смена профиля закрывает его',
    () async {
      await install();
      final old = access.session;
      final host = runtime.forSession(old)!;
      access.lock();
      await access.unlock();
      await runtime.ensure(access.session);
      expect(runtime.forSession(access.session), same(host));
      expect(() => host.snapshot(old), throwsStateError);
      profile = 'other';
      await access.unlock();
      await runtime.ensure(access.session);
      expect(runtime.forSession(old), isNull);
      expect(
        runtime.forSession(access.session)!.snapshot(access.session).entries,
        isEmpty,
      );
    },
  );
  test('подмена пакета не подключает хост после перезапуска', () async {
    await install();
    await owner.close();
    File(
      paths.join(
        root.path,
        'device',
        'profile',
        'packages',
        '${package.digest}.package',
      ),
    ).writeAsStringSync('changed');
    owner = create();
    await expectLater(runtime.ensure(access.session), throwsStateError);
    expect(runtime.forSession(access.session), isNull);
  });
  test('файл без защищённой записи и прямое согласие не разрешены', () async {
    final store = InstalledPackages(root.path, 'device/profile', keys);
    File(paths.join(root.path, '${package.digest}.package'))
        .writeAsBytesSync(bytes);
    await expectLater(store.verify(package.digest), throwsStateError);
    final authority = InstalledPackageAuthority(store);
    expect(await authority.confirm('enable', 'games', package.digest), false);
    final scoped = authority.catalogConsent('games', package.digest, 'root');
    expect(
      await scoped.confirm('grant', 'other', package.digest, root: 'root'),
      false,
    );
    expect(
      await scoped.confirm('grant', 'games', package.digest, root: 'different'),
      false,
    );
  });
  test('ошибка хеша не публикует установку', () async {
    await expectLater(
      owner.installAccepted(
        access.session,
        package,
        [0],
        installation: 'games',
        instance: 'games',
      ),
      throwsStateError,
    );
    expect(
      runtime.forSession(access.session)!.snapshot(access.session).entries,
      isEmpty,
    );
  });
  test('поздняя подготовка после блокировки не подключает хост', () async {
    await owner.close();
    final gate = Completer<String>();
    owner = InstalledExtensionsCubit(
      access,
      runtime,
      storage: keys,
      directory: () => gate.future,
      picker: () async => DesktopCatalogPicker(paths.join(root.path, 'unused')),
    );
    final future = runtime.ensure(access.session);
    final rejected = expectLater(future, throwsStateError);
    final session = access.session;
    access.lock();
    gate.complete(root.path);
    await rejected;
    expect(runtime.forSession(session), isNull);
  });
  test('выход ждёт освобождения ресурсов до prepare', () async {
    final shutdown = AppShutdown();
    final gate = Completer<void>();
    var stopped = false, prepared = false;
    shutdown.addStopBarrier(() => stopped = true);
    shutdown.addDrainBarrier(() => gate.future);
    shutdown.prepare = () async {
      prepared = true;
    };
    final ending = shutdown.request();
    expect(stopped, true);
    expect(prepared, false);
    gate.complete();
    expect(await ending, true);
    expect(prepared, true);
    await shutdown.close();
  });
  test(
    'поставляемый процесс не ищется в PATH и повторно проверяет хеш',
    () async {
      final name = Platform.isWindows ? 'space-catalog.exe' : 'space-catalog';
      final helper = File(paths.join(root.path, name));
      await expectLater(
        BundledCatalog.resolve(application: paths.join(root.path, 'app')),
        throwsStateError,
      );
      helper.writeAsBytesSync(bytes);
      File('${helper.path}.sha256').writeAsStringSync(package.digest);
      final bundled = await BundledCatalog.resolve(
        application: paths.join(root.path, 'app'),
      );
      expect(bundled.executable, helper.path);
      helper.writeAsBytesSync([1]);
      await expectLater(bundled.verify(), throwsStateError);
    },
  );
  testWidgets('SpaceApp предоставляет владельца установок через Bloc', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(SpaceApp(extensionAccess: access));
    await tester.pumpAndSettle();
    final provider = find.byType(BlocProvider<InstalledExtensionsCubit>);
    expect(provider, findsOneWidget);
    final supplied = tester
        .element(find.byType(LocalExtensionSessionScope))
        .read<InstalledExtensionsCubit>();
    expect(supplied.access, same(access));
    await tester.pumpWidget(const SizedBox());
  });
}
