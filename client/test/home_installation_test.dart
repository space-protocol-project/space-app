import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_installation.dart';
import 'package:space_client/src/home_runtime.dart';

import 'support/temp_directory.dart';

HomeRelease release(
  String version, [
  String platform = 'windows-x64',
]) => HomeRelease.fromJson({
  'version': version,
  'platform': platform,
  'url':
      'https://github.com/space-protocol-project/space-server/releases/download/$version/Space-home-$platform.zip',
  'sha256': 'a' * 64,
  'bytes': 1,
});

Future<void> installed(
  HomeInstallation store,
  HomeRelease version, {
  bool legacy = false,
}) async {
  final folder = await store.runtime(version).create(recursive: true);
  await File(
    '${folder.path}/${Platform.isWindows ? 'space-server.exe' : 'space-server'}',
  ).writeAsString('fixture');
  await File('${folder.path}/installed.json').writeAsString(
    jsonEncode({
      'sha256': version.sha256,
      if (!legacy) 'release': version.toJson(),
    }),
  );
}

void main() {
  test('Выпуски сравниваются как версии, без незаметного понижения', () {
    expect(release('v0.10.0').isNewerThan(release('v0.2.0')), true);
    expect(release('v0.1.0').isNewerThan(release('v0.2.0')), false);
    expect(release('v0.2.0').isNewerThan(release('v0.2.0')), false);
    expect(release('v0.2.0').isNewerThan(release('v0.2.0-rc.1')), true);
    expect(release('v0.2.0-rc.2').isNewerThan(release('v0.2.0-rc.1')), true);
  });
  late Directory root;
  late HomeInstallation store;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-runtime-selection-');
    store = HomeInstallation(root);
  });
  tearDown(
    () async => deleteTestDirectory(root, prefix: 'space-runtime-selection-'),
  );

  test('Новая установка ещё не выбирает версию', () async {
    expect(await store.active(release('v0.1.0')), isNull);
    expect(await store.selection.exists(), false);
  });
  test('Новый манифест не меняет активный выпуск и данные', () async {
    final old = release('v0.1.0');
    await installed(store, old);
    await store.selectInitial(old);
    final data = await Directory('${root.path}/data').create();
    final identity = await File('${data.path}/server.crt')
        .writeAsString('same certificate');
    final reopened = HomeInstallation(root);
    expect((await reopened.active(release('v0.2.0')))!.version, old.version);
    expect(await identity.readAsString(), 'same certificate');
  });
  test('Прежний marker переносится без загрузки и смены выпуска', () async {
    final old = release('v0.1.0');
    await installed(store, old, legacy: true);
    expect((await store.active(old))!.version, old.version);
    expect(await store.selection.exists(), true);
  });

  test('Старый marker распознаётся новым приложением по закреплённому legacy descriptor', () async {
    final old = release('v0.1.0');
    await installed(store, old, legacy: true);
    expect(
      (await store.active(
        release('v0.2.0'),
        legacy: [old],
        persist: false,
      ))!.version,
      'v0.1.0',
    );
    expect(await store.selection.exists(), false);
    expect(
      (await store.active(release('v0.2.0'), legacy: [old]))!.version,
      'v0.1.0',
    );
    expect(await store.selection.exists(), true);
  });
  test(
    'Потерянный или повреждённый активный выпуск не заменяется новым',
    () async {
      final old = release('v0.1.0');
      await installed(store, old);
      await store.selectInitial(old);
      await File('${store.runtime(old).path}/installed.json')
          .writeAsString('{');
      await expectLater(store.active(release('v0.2.0')), throwsFormatException);
      await store.runtime(old).delete(recursive: true);
      await expectLater(store.active(release('v0.2.0')), throwsFormatException);
    },
  );
  test(
    'База без установленного выпуска не запускается на новой версии',
    () async {
      await Directory('${root.path}/data').create();
      await expectLater(store.active(release('v0.2.0')), throwsFormatException);
    },
  );
  test('Два выпуска без активного выбора требуют восстановления', () async {
    await installed(store, release('v0.1.0'));
    await installed(store, release('v0.2.0'));
    await expectLater(store.active(release('v0.2.0')), throwsFormatException);
  });
  test('Неподходящая платформа блокируется', () async {
    final old = release('v0.1.0');
    await installed(store, old);
    await store.selectInitial(old);
    await expectLater(
      store.active(release('v0.1.0', 'linux-x64')),
      throwsFormatException,
    );
  });
  test('Описатель выпуска не разрешает установку в чужом каталоге', () async {
    final version = release('v0.1.0');
    await installed(store, version);
    await store.runtime(version).rename('${root.path}/runtimes/other');
    await expectLater(store.active(version), throwsFormatException);
    expect(await store.selection.exists(), false);
  });

  test('Старый marker с чужой контрольной суммой не выбирается', () async {
    final version = release('v0.1.0');
    await installed(store, version, legacy: true);
    await File('${store.runtime(version).path}/installed.json')
        .writeAsString(jsonEncode({'sha256': 'b' * 64}));
    await expectLater(store.active(version), throwsFormatException);
    expect(await store.selection.exists(), false);
  });
}
