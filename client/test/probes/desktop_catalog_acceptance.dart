import 'dart:async';
import 'dart:io';

import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/desktop_catalog.dart';
import 'package:space_client/src/extensions_p1/local_catalog_types.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_host.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_types.dart';

import '../support/local_lifecycle_fixture.dart';

class Selector extends FileSelectorPlatform {
  String? path;
  Future<void> Function()? wait;
  @override
  Future<String?> getDirectoryPath({
    String? initialDirectory,
    String? confirmButtonText,
  }) async {
    await wait?.call();
    return path;
  }
}

class PausingPicker implements LocalCatalogPicker {
  PausingPicker(this.delegate);
  final DesktopCatalogPicker delegate;
  final received = Completer<void>();
  final release = Completer<void>();
  @override
  Future<LocalCatalogRoot> select(
    String instance,
    String package,
    void Function() guard,
  ) async => PausingRoot(await delegate.select(instance, package, guard), this);
}

class PausingRoot extends LocalCatalogRoot {
  PausingRoot(this.delegate, this.picker);
  final LocalCatalogRoot delegate;
  final PausingPicker picker;
  @override
  String get id => delegate.id;
  @override
  Future<CatalogPage> list(int limit, String? cursor) =>
      delegate.list(limit, cursor);
  @override
  Future<CatalogChunk> read(String handle, int offset, int limit) async {
    final bytes = await delegate.read(handle, offset, limit);
    picker.received.complete();
    await picker.release.future;
    return bytes;
  }

  @override
  void close() => delegate.close();
}

void main() {
  late Directory temp;
  late Directory folder;
  late Selector selector;
  late FileSelectorPlatform original;
  late DesktopCatalogPicker picker;
  late LifecycleFixture f;
  Future<void> setup({LocalCatalogPicker? override}) async {
    f = LifecycleFixture('${temp.path}/registry', picker: override ?? picker);
    addTearDown(f.host.close);
    await f.act(LocalLifecycleAction.install);
    await f.act(LocalLifecycleAction.enable);
  }

  Future<String> grant() async {
    await f.act(LocalLifecycleAction.grant);
    return f.authority.confirmedRoot!;
  }

  Future<CatalogPage> page(
    String root, {
    String? cursor,
    int limit = 128,
  }) async {
    late CatalogPage result;
    await f.host.listCatalog(
      f.session,
      'games',
      root,
      (p) => result = p,
      limit: limit,
      cursor: cursor,
    );
    return result;
  }

  setUp(() {
    temp = Directory.systemTemp.createTempSync('space-catalog-');
    folder = Directory('${temp.path}/library')..createSync();
    original = FileSelectorPlatform.instance;
    selector = Selector()..path = folder.path;
    FileSelectorPlatform.instance = selector;
    picker = DesktopCatalogPicker(
      Platform.environment['SPACE_CATALOG_HELPER']!,
    );
    addTearDown(() async {
      await picker.stopped;
      FileSelectorPlatform.instance = original;
      temp.deleteSync(recursive: true);
    });
  });
  test(
    'выбор через системный порт, страницы, чтение и отказ чужому дескриптору',
    () async {
      File('${folder.path}/a').writeAsStringSync('abcdef');
      File('${folder.path}/b').writeAsStringSync('abcdef');
      await setup();
      final root = await grant();
      expect(picker.selectedPath(root), folder.path);
      final first = await page(root, limit: 1);
      final second = await page(root, cursor: first.next, limit: 1);
      expect(
        {
          ...first.entries.map((e) => e.name),
          ...second.entries.map((e) => e.name),
        },
        {'a', 'b'},
      );
      expect(second.next, isNull);
      await expectLater(page(root, cursor: first.next), throwsStateError);
      final handle = first.entries.single.handle;
      late CatalogChunk chunk;
      await f.host.readCatalog(
        f.session,
        'games',
        root,
        handle,
        (v) => chunk = v,
        offset: 2,
        limit: 3,
      );
      expect(chunk.bytes, [99, 100, 101]);
      expect(chunk.eof, false);
      await expectLater(
        f.host.readCatalog(
          f.session,
          'games',
          root,
          '0' * 32,
          (_) => fail('чужие данные'),
          offset: 0,
          limit: 1,
        ),
        throwsStateError,
      );
      await f.act(LocalLifecycleAction.revoke, root: root);
      expect(picker.selectedPath(root), isNull);
      await expectLater(page(root), throwsStateError);
    },
  );
  test('отзыв после нативного чтения до выдачи отбрасывает байты', () async {
    File('${folder.path}/game').writeAsStringSync('game');
    final pause = PausingPicker(picker);
    await setup(override: pause);
    final root = await grant();
    final handle = (await page(root)).entries.single.handle;
    var delivered = false;
    final request = f.host.readCatalog(
      f.session,
      'games',
      root,
      handle,
      (_) => delivered = true,
      offset: 0,
      limit: 4,
    );
    await pause.received.future;
    await f.act(LocalLifecycleAction.revoke, root: root);
    expect(picker.selectedPath(root), isNull);
    pause.release.complete();
    await expectLater(request, throwsStateError);
    expect(delivered, false);
  });
  test('отмена и отказ в согласии освобождают выбранный корень', () async {
    await setup();
    selector.path = null;
    await expectLater(grant(), throwsStateError);
    selector.path = folder.path;
    f.authority.consent = false;
    await expectLater(grant(), throwsStateError);
    expect(picker.selectedPath(f.authority.confirmedRoot!), isNull);
    expect(f.record['grants'], isEmpty);
  });
  test('блокировка во время выбора запрещает подтверждение', () async {
    await setup();
    final calls = f.authority.confirmations;
    selector.wait = () async => f.sessions.lock();
    await expectLater(grant(), throwsStateError);
    expect(f.authority.confirmations, calls);
  });
}
