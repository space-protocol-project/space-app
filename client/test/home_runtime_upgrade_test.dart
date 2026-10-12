// Сквозная проверка выполняется только на одноразовом CI runner.
import 'dart:io';
import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_runtime.dart';
import 'package:space_client/src/home_update_journal.dart';

class _Binding extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get overrideHttpClient => false;
}

class _Vault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async =>
      record = DeviceRecord.fromJson(value.toJson());
}

void main() {
  final enabled = Platform.environment['SPACE_HOME_UPGRADE_CHECK'] == '1';
  if (enabled) {
    _Binding();
  } else {
    TestWidgetsFlutterBinding.ensureInitialized();
  }
  test(
    'Публичный v0.1.0 → собранный кандидат: миграции, ключи, сертификат и сообщения',
    () async {
      final root = await Directory.systemTemp.createTemp('space-real-upgrade-');
      final platform = (await bundledHomeRelease()).platform;
      final old = (await legacyHomeReleases()).singleWhere(
        (release) =>
            release.version == 'v0.1.0' && release.platform == platform,
      );
      final archives =
          await Directory(
                Platform.environment['SPACE_HOME_CANDIDATE_DIRECTORY']!,
              )
              .list()
              .where(
                (file) => file.path.endsWith('Space-home-${old.platform}.zip'),
              )
              .toList();
      expect(archives, hasLength(1));
      final archive = File(archives.single.path);
      // v0.2.0 здесь — имя локального CI-кандидата, а не опубликованный выпуск.
      final candidate = HomeRelease.fromJson({
        'version': 'v0.2.0',
        'platform': old.platform,
        'url':
            'https://github.com/space-protocol-project/space-server/releases/download/v0.2.0/Space-home-${old.platform}.zip',
        'sha256': (await crypto.sha256.bind(archive.openRead()).first)
            .toString(),
        'bytes': await archive.length(),
      });
      final vault = _Vault();
      final original = HomeController(
        directory: () async => root,
        release: () async => old,
      );
      final updated = HomeController(
        directory: () async => root,
        release: () async => candidate,
        download: (_, destination, progress) async {
          await archive.copy(destination.path);
          progress(1);
        },
      );
      SpaceSession? session;
      try {
        final first = await original.start('203.0.113.10');
        expect(first, isNotNull, reason: original.error);
        final discovery = await discover(
          first!.localOrigin,
          homeOrigin: first.publicOrigin,
          tlsFingerprint: first.tlsFingerprint,
        );
        session = await SpaceSession.connect(
          discovery,
          vault,
          setupCode: first.setupCode,
        );
        final principal = session.principalId;
        await session.send('Сообщение до обновления', 'upgrade-check-1');
        await session.close();
        session = null;
        await original.stop();
        expect(original.error, isEmpty);
        expect(await updated.prepareUpdate(), true, reason: updated.error);
        await updated.performUpdate();
        expect(updated.error, isEmpty);
        expect(updated.pendingUpdate, false);
        expect(updated.installedVersion, 'v0.2.0');
        final second = await updated.start('203.0.113.11');
        expect(second, isNotNull, reason: updated.error);
        expect(second!.link, first.link);
        final next = await discover(
          second.localOrigin,
          homeOrigin: second.publicOrigin,
          tlsFingerprint: second.tlsFingerprint,
        );
        expect(next.serverId, discovery.serverId);
        session = await SpaceSession.connect(next, vault);
        expect(session.principalId, principal);
        expect(session.role, 'owner');
        expect(
          (await session.messages()).any(
            (message) => message.text == 'Сообщение до обновления',
          ),
          true,
        );
        expect(session.serverIcon, isNotNull);
        await session.close();
        session = null;
        await updated.stop();
        expect(updated.error, isEmpty);
        // Воспроизводим сохранённое состояние прерывания после миграций.
        final journal = HomeUpdateJournal(root);
        final record = (await journal.read())!;
        await journal.file.writeAsString(
          jsonEncode({...record.toJson(), 'step': 'migrating'}),
          flush: true,
        );
        await updated.performUpdate(recover: true);
        expect(updated.error, isEmpty);
        expect(updated.installedVersion, 'v0.1.0');
        expect((await journal.read())!.step, HomeUpdateStep.completeRestored);
        final restored = await updated.start('203.0.113.12');
        expect(restored, isNotNull, reason: updated.error);
        expect(restored!.link, first.link);
        final restoredDiscovery = await discover(
          restored.localOrigin,
          homeOrigin: restored.publicOrigin,
          tlsFingerprint: restored.tlsFingerprint,
        );
        expect(restoredDiscovery.serverId, discovery.serverId);
        session = await SpaceSession.connect(restoredDiscovery, vault);
        expect(session.principalId, principal);
        expect(session.role, 'owner');
        expect(
          (await session.messages()).any(
            (message) => message.text == 'Сообщение до обновления',
          ),
          true,
        );
      } finally {
        await session?.close();
        await updated.stop();
        await original.stop();
        updated.dispose();
        original.dispose();
        await root.delete(recursive: true);
      }
    },
    skip: !enabled,
    timeout: const Timeout(Duration(minutes: 15)),
  );
}
