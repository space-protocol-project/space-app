// Сквозная проверка использует отдельный временный каталог: CI или явный локальный запуск.
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:crypto/crypto.dart' as crypto;
import 'package:fixnum/fixnum.dart';
import 'package:space_client/src/attachments.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_runtime.dart';

import 'package:space_client/src/home_update_journal.dart';
import 'package:space_client/src/local_failure.dart';

import 'support/historical_home_runtime.dart';

import 'support/temp_directory.dart';

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
    'Connect runtime → новый кандидат: ключи, сертификат, сообщения и восстановление',
    () async {
      final root = await Directory.systemTemp.createTemp('space-real-upgrade-');
      final platform = (await bundledHomeRelease()).platform;
      final historical = jsonDecode(
        await File('test/fixtures/runtime-v0.2.5.json').readAsString(),
      ) as Map<String, dynamic>;
      final baseline = HomeRelease.fromJson(
        Map<String, dynamic>.from(historical[platform] as Map),
      );
      expect(baseline.version, 'v0.2.5');
      final archives =
          await Directory(
                Platform.environment['SPACE_HOME_CANDIDATE_DIRECTORY']!,
              )
              .list()
              .where((file) => file.path.endsWith('Space-home-$platform.zip'))
              .toList();
      expect(archives, hasLength(1));
      final archive = File(archives.single.path);
      final metadata = jsonDecode(
        await File(
          '${Platform.environment['SPACE_HOME_CANDIDATE_DIRECTORY']}/$platform.json',
        ).readAsString(),
      ) as Map<String, dynamic>;
      expect(
        metadata['sha256'],
        (await crypto.sha256.bind(archive.openRead()).first).toString(),
      );
      // Кандидат локальный; исходный runtime скачивается из закреплённого опубликованного выпуска.
      final candidate = HomeRelease.fromJson({
        ...metadata,
        'version': 'v0.3.1',
        'platform': platform,
        'url':
            'https://github.com/space-protocol-project/space-server/releases/download/v0.3.1/Space-home-$platform.zip',
        'sha256': (await crypto.sha256.bind(archive.openRead()).first)
            .toString(),
        'bytes': await archive.length(),
      });
      final vault = _Vault();
      final original = HistoricalHomeRuntime(root, baseline);
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
        await original.prepare();
        final first = await original.start();
        final discovery = await discover(
          first.localOrigin,
          homeOrigin: first.publicOrigin,
          tlsFingerprint: first.tlsFingerprint,
        );
        session = await SpaceSession.connect(
          discovery,
          vault,
          setupCode: first.setupCode,
        );
        final principal = session.principalId;
        final historicalVault = _Vault();
        await historicalVault.save(session.record);
        await session.send('Сообщение до обновления', 'upgrade-check-1');
        // Подписка остаётся открытой и приостановленной после первого кадра.
        final iterator = StreamIterator(session.subscribe(''));
        expect(
          await iterator.moveNext().timeout(const Duration(seconds: 10)),
          true,
        );
        await session.close().timeout(const Duration(seconds: 7));
        await iterator.cancel();
        session = null;
        await original.stop();
        final stillOld = await updated.start('203.0.113.10');
        expect(stillOld, isNull);
        expect(updated.error, contains('Обновите runtime'));
        expect(updated.installedVersion, baseline.version);
        expect(await updated.prepareUpdate(), true, reason: updated.error);
        expect(updated.running, false);
        await updated.stop();
        expect(updated.error, isEmpty);
        await updated.performUpdate();
        expect(updated.error, isEmpty);
        expect(updated.pendingUpdate, false);
        expect(updated.installedVersion, 'v0.3.1');
        final second = await updated.start('203.0.113.11');
        expect(second, isNotNull, reason: updated.error);
        expect(second!.publicOrigin, first.publicOrigin);
        expect(second.tlsFingerprint, first.tlsFingerprint);
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
        await verifyUpgradedFiles(session);
        await verifyUpgradedReaction(session, active: false);
        await session.close();
        session = null;
        await updated.stop();
        expect(updated.error, isEmpty);
        final restarted = await updated.start('203.0.113.11');
        expect(restarted, isNotNull, reason: updated.error);
        final restartedDiscovery = await discover(
          restarted!.localOrigin,
          homeOrigin: restarted.publicOrigin,
          tlsFingerprint: restarted.tlsFingerprint,
        );
        session = await SpaceSession.connect(restartedDiscovery, vault);
        await verifyUpgradedReaction(session, active: true);
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
        // Повреждённая реальная копия не должна заменять текущую базу.
        final backupKey = File(
          '${root.path}/${record.backupPath}/data/server.key',
        );
        final originalKey = await backupKey.readAsBytes();
        await backupKey.writeAsBytes([...originalKey, 0], flush: true);
        await updated.performUpdate(recover: true);
        expect(updated.failureCode, LocalFailureCode.homeBackupInvalid);
        expect(updated.pendingUpdate, true);
        expect(await Directory('${root.path}/data').exists(), true);
        expect(
          await Directory('${root.path}/failed-data/${record.id}').exists(),
          false,
        );
        await backupKey.writeAsBytes(originalKey, flush: true);
        await updated.load();
        expect(updated.recoveryBlocked, false);
        await updated.performUpdate(recover: true);
        expect(updated.error, isEmpty);
        expect(updated.installedVersion, baseline.version);
        expect((await journal.read())!.step, HomeUpdateStep.completeRestored);
        expect(await updated.start('203.0.113.12'), isNull);
        expect(updated.error, contains('Обновите runtime'));
        final restored = await original.start();
        expect(restored.publicOrigin, first.publicOrigin);
        expect(restored.tlsFingerprint, first.tlsFingerprint);
        final restoredDiscovery = await discover(
          restored.localOrigin,
          homeOrigin: restored.publicOrigin,
          tlsFingerprint: restored.tlsFingerprint,
        );
        expect(restoredDiscovery.serverId, discovery.serverId);
        // Новый профиль не должен принимать откат объявления адресов.
        expect(
          () => checkTrust(restoredDiscovery, vault.record!),
          throwsFormatException,
        );
        session = await SpaceSession.connect(
          restoredDiscovery,
          historicalVault,
        );
        expect(session.principalId, principal);
        expect(session.role, 'owner');
        expect(
          (await readHistoricalMessages(session))
              .any((message) => message.text == 'Сообщение до обновления'),
          true,
        );
      } finally {
        await session?.close();
        await updated.stop();
        await original.stop();
        updated.dispose();
        await removeUpgradeDirectory(root);
      }
    },
    skip: !enabled,
    timeout: const Timeout(Duration(minutes: 15)),
  );
}

// Проверка отката читает старый runtime через существовавший в нём ListContent.
// Современный GetHistoryPage намеренно не добавляется в историческую сборку.
Future<List<Content>> readHistoricalMessages(SpaceSession session) async {
  final options = await session.mlsOptions(
    expectedGrant: session.record.grantId,
  );
  final response = await ContentServiceClient(session.channel).listContent(
    ListContentRequest(channelId: session.selectedChannelId),
    options: options,
  );
  return response.contents;
}

Future<void> removeUpgradeDirectory(Directory root) async {
  final parent = await root.parent.resolveSymbolicLinks();
  final temporary = await Directory.systemTemp.resolveSymbolicLinks();
  if (parent != temporary ||
      !root.path
          .split(Platform.pathSeparator)
          .last
          .startsWith('space-real-upgrade-')) {
    throw StateError('Недопустимый каталог очистки проверки обновления');
  }
  await deleteTestDirectory(root, prefix: 'space-real-upgrade-');
}

Future<void> verifyUpgradedFiles(SpaceSession session) async {
  final bytes = [1, 2, 3, 4, 5];
  final upload = await session.beginUpload(
    BeginUploadRequest(
      channelId: 'general',
      name: 'после-обновления.bin',
      byteSize: Int64(bytes.length),
      sha256: crypto.sha256.convert(bytes).bytes,
      idempotencyKey: 'upgrade-file',
    ),
  );
  await session.uploadChunk(
    UploadChunkRequest(assetId: upload.asset.id, data: bytes),
  );
  final complete = await session.completeUpload(
    CompleteUploadRequest(assetId: upload.asset.id),
  );
  final sent = await session.sendAttachments(
    'general',
    'Файл после обновления',
    'upgrade-file-message',
    [complete.asset.id],
  );
  expect(await downloadAttachment(session, sent.attachments.single), bytes);
  await updateParticipantName(session, 'Владелец после обновления');
  final result = await session.adminRequest('/api/v1/space/members');
  expect(
    (result['members'] as List).any(
      (m) =>
          m['principalId'] == session.principalId &&
          m['nickname'] == 'Владелец после обновления',
    ),
    true,
  );
}

Future<void> verifyUpgradedReaction(
  SpaceSession session, {
  required bool active,
}) async {
  final message = (await session.messages()).singleWhere(
    (message) => message.text == 'Сообщение до обновления',
  );
  if (active) {
    expect(message.reactions.single.emoji, '❤️');
    expect(message.reactions.single.principalIds, [session.principalId]);
    return;
  }
  expect(message.reactions, isEmpty);
  final changed = await session.setReaction(message, '❤️', true);
  expect(changed.reactions.single.emoji, '❤️');
  expect(changed.reactions.single.principalIds, [session.principalId]);
}
