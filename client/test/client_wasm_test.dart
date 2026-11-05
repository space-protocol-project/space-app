import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as paths;
import 'package:space_client/src/extensions_p1/catalog_grant_cubit.dart';
import 'package:space_client/src/extensions_p1/client_wasm_broker.dart';
import 'package:space_client/src/extensions_p1/client_wasm_process.dart';
import 'package:space_client/src/extensions_p1/desktop_catalog.dart';
import 'package:space_client/src/extensions_p1/git_install_cubit.dart';
import 'package:space_client/src/extensions_p1/installed_extensions_cubit.dart';
import 'package:space_client/src/extensions_p1/local_catalog_types.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_types.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_record.dart';
import 'package:space_client/src/extensions_p1/local_session_cubit.dart';

import 'support/git_install_fixture.dart';

class ScriptWorker implements ClientWasmWorker {
  int calls = 0;
  bool cancelled = false;
  Future<Object?> Function(int, Map<String, dynamic>)? script;
  @override
  Future<Uint8List> invoke(List<int> module, List<int> input) async {
    calls++;
    final reply = await script?.call(
      calls,
      jsonDecode(utf8.decode(input)) as Map<String, dynamic>,
    );
    return Uint8List.fromList(
      utf8.encode(jsonEncode(reply ?? {'op': 'done', 'value': 'ok'})),
    );
  }

  @override
  void cancel() {
    cancelled = true;
  }

  @override
  Future<void> close() async {
    cancel();
  }
}

class TestRoot extends LocalCatalogRoot {
  int reads = 0, lists = 0;
  Completer<void>? gate, entered;
  @override
  String get displayPath => '/fixture';
  @override
  Future<CatalogPage> list(int limit, String? cursor) async {
    lists++;
    return (entries: [(name: 'sample', handle: 'handle')], next: null);
  }

  @override
  Future<CatalogChunk> read(String handle, int offset, int limit) async {
    reads++;
    entered?.complete();
    await gate?.future;
    if (handle != 'handle') throw StateError('PermissionDenied');
    return (
      bytes: Uint8List.fromList(utf8.encode('installed catalog')),
      eof: true,
    );
  }

  @override
  void close() {}
}

class TestPicker extends DesktopCatalogPicker {
  TestPicker(this.root) : super('/unused');
  final TestRoot root;
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

void main() {
  final nativeSupported =
      Platform.isWindows ||
      (Platform.isLinux &&
          Platform.environment['SPACE_CLIENT_WASM_BROKER_TEST'] == '1');
  late Directory directory;
  late LocalSessionCubit access;
  late SpaceCatalogRuntime runtime;
  late InstalledExtensionsCubit owner;
  late ScriptWorker fake;
  late TestRoot files;
  late GitMemoryKeys keys;
  late Future<ClientWasmWorker> Function() factory;
  var created = 0;
  String fixture(String name) =>
      paths.join(Platform.environment['WASM_FIXTURES']!, '$name.wasm');
  InstalledExtensionsCubit create({bool realFiles = false}) =>
      InstalledExtensionsCubit(
        access,
        runtime,
        storage: keys,
        directory: () async => directory.path,
        picker: () async => realFiles
            ? DesktopCatalogPicker(
                Platform.environment['SPACE_CATALOG_BINARY']!,
                choose: () async => paths.join(directory.path, 'files'),
              )
            : TestPicker(files),
        wasm: ClientWasmBroker(
          worker: () async {
            created++;
            return factory();
          },
        ),
      );
  setUp(() async {
    directory = Directory.systemTemp.createTempSync('client-wasm-');
    Directory(paths.join(directory.path, 'files')).createSync();
    File(paths.join(directory.path, 'files', 'sample'))
        .writeAsStringSync('installed catalog');
    access = LocalSessionCubit(
      authenticate: () async =>
          (device: 'device', profile: 'profile', actor: 'owner'),
    )..setForeground(true);
    runtime = SpaceCatalogRuntime();
    keys = GitMemoryKeys();
    files = TestRoot();
    fake = ScriptWorker();
    factory = () async => fake;
    created = 0;
    owner = create();
    await access.unlock();
    await runtime.ensure(access.session);
  });
  tearDown(() async {
    await owner.close();
    await access.close();
    await runtime.close();
    directory.deleteSync(recursive: true);
  });
  Future<void> install([String module = 'catalog']) async {
    final git = FixtureGit();
    git.files['client.wasm'] = File(fixture(module)).readAsBytesSync();
    await git.sign();
    final installer = GitInstallCubit(owner, transport: () => git);
    await installer.prepare(
      fixtureRepository,
      fixtureRef,
      fixturePath,
      'games',
    );
    expect(installer.state, isA<GitReview>());
    await installer.confirm(trustUnknown: true);
    expect(installer.state, isA<GitInstalled>());
    await installer.close();
  }

  Future<String> grant() async {
    final screen = CatalogGrantCubit(access, runtime);
    if (screen.state is! CatalogTargets) {
      await screen.stream
          .firstWhere((state) => state is CatalogTargets)
          .timeout(const Duration(seconds: 3));
    }
    await screen.choose('games');
    await screen.unlock();
    await screen.approve();
    final result = screen.state as CatalogGranted;
    await screen.close();
    return result.root;
  }

  Future<void> revoke(
    String root, [
    LocalLifecycleAction action = LocalLifecycleAction.revoke,
  ]) async {
    final host = runtime.forSession(access.session)!;
    final record = lifecycleOf(host.snapshot(access.session).entries['games']!);
    await host.execute(
      access.session,
      LocalLifecycleCommand(
        action: action,
        installation: 'games',
        instance: 'games',
        revision: record['revision']! as int,
        generation: record['generation']! as String,
        root: action == LocalLifecycleAction.revoke ? root : null,
      ),
    );
  }

  test(
    'без разрешения, чужой экземпляр и чужой корень не запускают worker',
    () async {
      await install();
      await expectLater(
        runtime.invoke(access.session, 'games', 'missing'),
        throwsStateError,
      );
      final root = await grant();
      await expectLater(
        runtime.invoke(access.session, 'other', root),
        throwsStateError,
      );
      await expectLater(
        runtime.invoke(access.session, 'games', 'other'),
        throwsStateError,
      );
      expect(created, 0);
    },
  );
  for (final event in ['revoke', 'disable', 'lock']) {
    test('поздний ответ WASM после $event не доставляется', () async {
      await install();
      final root = await grant();
      final entered = Completer<void>(), reply = Completer<Object?>();
      fake.script = (_, _) {
        entered.complete();
        return reply.future;
      };
      final operation = runtime.invoke(access.session, 'games', root);
      final rejected = expectLater(operation, throwsStateError);
      await entered.future;
      if (event == 'lock') {
        access.lock();
      } else {
        await revoke(
          root,
          event == 'disable'
              ? LocalLifecycleAction.disable
              : LocalLifecycleAction.revoke,
        );
      }
      expect(fake.cancelled, true);
      reply.complete({'op': 'done', 'value': 'secret'});
      await rejected;
      expect(files.reads, 0);
    });
  }
  test('отзыв во время файлового чтения не возвращает байты гостю', () async {
    await install();
    final root = await grant();
    files.gate = Completer<void>();
    files.entered = Completer<void>();
    fake.script = (_, _) async => {
      'op': 'read',
      'handle': 'handle',
      'offset': 0,
      'limit': 64,
      'state': null,
    };
    final rejected = expectLater(
      runtime.invoke(access.session, 'games', root),
      throwsStateError,
    );
    await files.entered!.future;
    await revoke(root);
    files.gate!.complete();
    await rejected;
    expect(fake.calls, 1);
    expect(fake.cancelled, true);
  });
  test('гость не может подменить привязку каталога', () async {
    await install();
    final root = await grant();
    fake.script = (_, _) async => {
      'op': 'list',
      'limit': 1,
      'cursor': null,
      'state': null,
      'root': '/etc',
    };
    await expectLater(
      runtime.invoke(access.session, 'games', root),
      throwsFormatException,
    );
    expect(files.lists, 0);
  });
  test('квота шагов и общий слот исполнения не обходятся', () async {
    await install();
    final root = await grant();
    fake.script = (_, _) async => {
      'op': 'list',
      'limit': 1,
      'cursor': null,
      'state': null,
    };
    await expectLater(
      runtime.invoke(access.session, 'games', root),
      throwsStateError,
    );
    expect(fake.calls, 8);
  });
  test('изменённые байты принятого пакета не компилируются', () async {
    await install();
    final root = await grant();
    final digest = runtime
        .forSession(access.session)!
        .snapshot(access.session)
        .entries['games']!['package'];
    File(
      paths.join(
        directory.path,
        'device',
        'profile',
        'packages',
        '$digest.package',
      ),
    ).writeAsStringSync('corrupt');
    await expectLater(
      runtime.invoke(access.session, 'games', root),
      throwsStateError,
    );
    expect(created, 0);
  });
  test('настоящий изолированный WASM получает каталог и читает файл только через ядро', () async {
    await owner.close();
    factory = () async =>
        ClientWasmProcess(Platform.environment['SPACE_CLIENT_WASM_BINARY']!);
    owner = create(realFiles: true);
    await runtime.ensure(access.session);
    await install();
    final root = await grant();
    if (nativeSupported) {
      expect(
        await runtime.invoke(access.session, 'games', root),
        base64Encode(utf8.encode('installed catalog')),
      );
      await revoke(root);
      await expectLater(
        runtime.invoke(access.session, 'games', root),
        throwsStateError,
      );
    } else {
      await expectLater(
        runtime.invoke(access.session, 'games', root),
        throwsStateError,
      );
    }
  });
  for (final module in ['loop', 'trap']) {
    test(
      'авария или цикл гостя освобождают защищённый слот: $module',
      () async {
        factory = () async => ClientWasmProcess(
          Platform.environment['SPACE_CLIENT_WASM_BINARY']!,
        );
        await install(module);
        final root = await grant();
        await expectLater(
          runtime.invoke(access.session, 'games', root),
          throwsStateError,
        );
        await expectLater(
          runtime.invoke(access.session, 'games', root),
          throwsStateError,
        );
        expect(created, 2);
      },
    );
  }

  test(
    'второе задание не получает отдельный бюджет во время первого',
    () async {
      await install();
      final root = await grant();
      final entered = Completer<void>(), release = Completer<Object?>();
      fake.script = (_, _) {
        entered.complete();
        return release.future;
      };
      final pending = runtime.invoke(access.session, 'games', root);
      await entered.future;
      await expectLater(
        runtime.invoke(access.session, 'games', root),
        throwsStateError,
      );
      expect(created, 1);
      release.complete({'op': 'done', 'value': 'ok'});
      expect(await pending, 'ok');
    },
  );

  test(
    'настоящий гость не получает поздние байты после отзыва чтения',
    () async {
      factory = () async =>
          ClientWasmProcess(Platform.environment['SPACE_CLIENT_WASM_BINARY']!);
      await install();
      final root = await grant();
      files.gate = Completer<void>();
      files.entered = Completer<void>();
      final pending = runtime.invoke(access.session, 'games', root);
      final rejected = expectLater(pending, throwsStateError);
      if (nativeSupported) {
        await files.entered!.future.timeout(const Duration(seconds: 8));
        await revoke(root);
        files.gate!.complete();
      }
      await rejected;
      if (!nativeSupported) expect(files.reads, 0);
    },
  );
}
