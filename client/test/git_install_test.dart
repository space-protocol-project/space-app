import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as paths;
import 'package:space_client/src/extensions_p1/git_install_cubit.dart';
import 'package:space_client/src/extensions_p1/git_manifest.dart';
import 'package:space_client/src/extensions_p1/github_transport.dart';
import 'package:space_client/src/extensions_p1/git_source.dart';
import 'package:space_client/src/extensions_p1/installed_extensions_cubit.dart';
import 'package:space_client/src/extensions_p1/installed_packages.dart';
import 'package:space_client/src/extensions_p1/catalog_grant_cubit.dart';
import 'package:space_client/src/extensions_p1/desktop_catalog.dart';
import 'package:space_client/src/extensions_p1/local_session_cubit.dart';
import 'package:space_client/ui/git_install_page.dart';

import 'support/git_install_fixture.dart';

void main() {
  late Directory root;
  late FixtureGit git;
  late GitMemoryKeys keys;
  late LocalSessionCubit access;
  late SpaceCatalogRuntime runtime;
  late InstalledExtensionsCubit owner;
  late GitInstallCubit installer;
  var profile = 'profile';
  InstalledExtensionsCubit createOwner() => InstalledExtensionsCubit(
    access,
    runtime,
    storage: keys,
    directory: () async => root.path,
    picker: () async => DesktopCatalogPicker(paths.join(root.path, 'unused')),
  );
  setUp(() async {
    root = Directory.systemTemp.createTempSync('git-installer-');
    git = FixtureGit();
    keys = GitMemoryKeys();
    profile = 'profile';
    access = LocalSessionCubit(
      authenticate: () async =>
          (device: 'device', profile: profile, actor: 'owner'),
    )..setForeground(true);
    runtime = SpaceCatalogRuntime();
    owner = createOwner();
    await access.unlock();
    await owner.ensure(access.session);
    installer = GitInstallCubit(owner, transport: () => git);
  });
  tearDown(() async {
    await installer.close();
    await owner.close();
    await access.close();
    await runtime.close();
    root.deleteSync(recursive: true);
  });
  Future<void> prepare([String instance = 'games']) =>
      installer.prepare(fixtureRepository, fixtureRef, fixturePath, instance);
  Map<String, Map<String, Object?>> entries() =>
      runtime.forSession(access.session)!.snapshot(access.session).entries;

  test(
    'подписи, commit и digest связывают пакет; согласие требуется явно',
    () async {
      await prepare();
      final review = installer.state as GitReview;
      expect(review.known, false);
      expect(review.candidate.source.json['commit'], git.packageCommit);
      expect(review.candidate.source.json['ref_commit'], git.selectedCommit);
      expect(() => review.candidate.bytes[0] = 0, throwsUnsupportedError);
      await installer.confirm();
      expect(entries(), isEmpty);
      expect(keys.values, isEmpty);
      await installer.confirm(trustUnknown: true);
      expect(installer.state, isA<GitInstalled>());
      expect(entries()['games']!['state'], 'disabled');
      final store = InstalledPackages(
        paths.join(root.path, 'device', 'profile', 'packages'),
        'device/profile',
        keys,
      );
      final verified = await store.verify(review.candidate.package.digest);
      expect(verified.source!.json, review.candidate.source.json);
      await installer.close();
      await owner.close();
      owner = createOwner();
      installer = GitInstallCubit(owner, transport: () => FixtureGit());
      await owner.ensure(access.session);
      expect(entries()['games']!['state'], 'disabled');
      await prepare('second');
      expect((installer.state as GitReview).known, true);
      await installer.confirm();
      expect(entries().keys, containsAll(['games', 'second']));
    },
  );

  for (final url in [
    'http://github.com/o/r',
    'https://user:secret@github.com/o/r',
    'https://127.0.0.1/o/r',
    'https://github.com/o/r?token=x',
    'https://github.com:443/o/r',
    'https://github.com.evil.test/o/r',
  ]) {
    test('источник отклоняется до сети: $url', () async {
      await installer.prepare(url, fixtureRef, fixturePath, 'games');
      expect(installer.state, isA<GitFailed>());
      expect(git.calls, isEmpty);
      expect(entries(), isEmpty);
    });
  }
  test('полные refs, нормализация URL и запрет обхода пути', () {
    expect(
      gitRepository('https://GitHub.com/OWNER/REPO.git'),
      'https://github.com/owner/repo',
    );
    gitRef('refs/tags/v0.1.0');
    for (final ref in ['main', 'refs/heads/../x', 'refs/tags/x.lock']) {
      expect(() => gitRef(ref), throwsFormatException);
    }
    for (final path in ['../x', '/tmp/x', 'a\\b', 'a//b']) {
      expect(() => gitPath(path), throwsFormatException);
    }
  });
  test('DNS-адреса внутренней сети и IPv6 не допускаются', () {
    for (final ip in [
      '0.0.0.0',
      '10.1.2.3',
      '100.64.0.1',
      '127.0.0.1',
      '169.254.169.254',
      '172.16.0.1',
      '192.168.1.1',
      '192.0.2.1',
      '198.18.0.1',
      '198.51.100.1',
      '203.0.113.1',
      '224.0.0.1',
      '::1',
      '::ffff:127.0.0.1',
    ]) {
      expect(publicGitAddress(InternetAddress(ip)), false, reason: ip);
    }
    expect(publicGitAddress(InternetAddress('140.82.112.5')), true);
  });
  for (final mode in ['120000', '160000']) {
    test('ссылка или submodule не принимаются: $mode', () async {
      git.mode = mode;
      await prepare();
      expect(installer.state, isA<GitFailed>());
      expect(entries(), isEmpty);
    });
  }
  test('усечённое дерево и подмена Git blob отклоняются', () async {
    git.truncated = true;
    await prepare();
    expect(installer.state, isA<GitFailed>());
    git.truncated = false;
    git.corruptBlob = true;
    await prepare();
    expect(installer.state, isA<GitFailed>());
    expect(keys.values, isEmpty);
  });
  for (final file in ['index.sig', 'client.wasm', 'provenance.json']) {
    test('подмена $file не создаёт установку и доверие', () async {
      git.files[file] = Uint8List.fromList([0]);
      await prepare();
      expect(installer.state, isA<GitFailed>());
      expect(entries(), isEmpty);
      expect(keys.values, isEmpty);
    });
  }
  test('подписанный документ с чужим источником отклоняется', () async {
    await git.sign(
      originChanges: {'repository': 'https://github.com/other/repository'},
    );
    await prepare();
    expect(installer.state, isA<GitFailed>());
    expect(keys.values, isEmpty);
  });
  test('новый подписывающий ключ не наследует сохранённое доверие', () async {
    await prepare();
    await installer.confirm(trustUnknown: true);
    await git.sign(seedText: 'different public CI fixture key');
    await prepare('second');
    expect((installer.state as GitFailed).reason, 'PublisherChanged');
    expect(entries().length, 1);
  });
  test('другой профиль не наследует доверие', () async {
    await prepare();
    await installer.confirm(trustUnknown: true);
    profile = 'other';
    await access.unlock();
    await owner.ensure(access.session);
    await prepare();
    expect((installer.state as GitReview).known, false);
    expect(entries(), isEmpty);
  });
  test('блокировка во время загрузки отклоняет поздний ответ', () async {
    final entered = Completer<void>(), gate = Completer<void>();
    git.before = (_) async {
      if (!entered.isCompleted) entered.complete();
      await gate.future;
    };
    final operation = prepare();
    await entered.future;
    access.lock();
    gate.complete();
    await operation;
    expect(installer.state, isA<GitLocked>());
    expect(git.closed, true);
    expect(keys.values, isEmpty);
  });
  test('отмена при записи доверия не публикует установку', () async {
    await prepare();
    keys.afterWrite = (_) => installer.cancel();
    await installer.confirm(trustUnknown: true);
    expect(installer.state, isA<GitIdle>());
    expect(entries(), isEmpty);
    expect(
      keys.values.keys.every((key) => key.startsWith('space.git.trust.')),
      true,
    );
  });
  test('блокировка при записи принятия не публикует установку', () async {
    await prepare();
    keys.afterWrite = (key) {
      if (key.startsWith('space.extensions.accepted.')) access.lock();
    };
    await installer.confirm(trustUnknown: true);
    expect(installer.state, isA<GitLocked>());
    await access.unlock();
    await owner.ensure(access.session);
    expect(entries(), isEmpty);
  });
  test(
    'изменение реестра между проверкой и согласием требует повторения',
    () async {
      await prepare();
      final candidate = (installer.state as GitReview).candidate;
      await owner.installAccepted(
        access.session,
        candidate.package,
        candidate.bytes,
        installation: 'other',
        instance: 'other',
      );
      await installer.confirm(trustUnknown: true);
      expect((installer.state as GitFailed).reason, 'Conflict');
      expect(entries().keys, ['other']);
      expect(
        keys.values.keys.any((key) => key.startsWith('space.git.trust.')),
        false,
      );
    },
  );
  test(
    'незаявленный ABI, лишние и повторные поля манифеста отвергаются',
    () async {
      final data = jsonDecode(utf8.decode(git.files['manifest.json']!)) as Map;
      (data['modules']['client'] as Map)['host_api'] = 'unknown';
      git.files['manifest.json'] = Uint8List.fromList(
        utf8.encode(jsonEncode(data)),
      );
      await git.sign();
      await prepare();
      expect(installer.state, isA<GitFailed>());
      expect(
        () => gitManifest(utf8.encode('{"format":1,"format":2}')),
        throwsFormatException,
      );
    },
  );
  test(
    'неподдерживаемые импорты, start и повреждённые секции WASM отвергаются',
    () {
      final header = [0, 97, 115, 109, 1, 0, 0, 0];
      for (final tail in [
        [2, 1, 1],
        [8, 1, 0],
        [1, 127],
        [1, 0, 1, 0],
        [13, 0],
      ]) {
        expect(() => gitWasmShape([...header, ...tail]), throwsFormatException);
      }
    },
  );
  testWidgets(
    'экран связывает отдельное доверие и подтверждение с кандидатом',
    (tester) async {
      await tester.runAsync(prepare);
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: installer,
            child: const GitInstallView(),
          ),
        ),
      );
      final button = find.byKey(const ValueKey('git-confirm'));
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      await tester.ensureVisible(find.byKey(const ValueKey('git-trust')));
      await tester.tap(find.byKey(const ValueKey('git-trust')));
      await tester.pump();
      expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
      installer.cancel();
      await tester.pump();
      await tester.runAsync(prepare);
      await tester.pump();
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
