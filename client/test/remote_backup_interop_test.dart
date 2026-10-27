import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/remote_backup.dart';
import 'package:space_client/src/remote_backup_models.dart';
import 'package:space_client/src/remote_backup_rpc.dart';

import 'fixtures/directory.dart';

class RemoteNetworkBinding extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get overrideHttpClient => false;
}

class LostBackupReply extends RpcRemoteBackup {
  LostBackupReply(super.endpoint);
  static bool lose = true;
  @override
  Future<BackupHead> put(PutBackupRequest request) async {
    final result = await super.put(request);
    if (lose) {
      lose = false;
      throw const SocketException('Ответ commit потерян');
    }
    return result;
  }
}

Future<void> waitRemoteRestart(String marker) async {
  await File('$marker.ready').writeAsString('ready', flush: true);
  final deadline = DateTime.now().add(const Duration(seconds: 60));
  while (!await File('$marker.resume').exists()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('Перезапуск серверов');
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

void main() {
  RemoteNetworkBinding();
  const origin = String.fromEnvironment('REMOTE_SPACE');
  const tls = String.fromEnvironment('REMOTE_SPACE_TLS');
  const authOrigin = String.fromEnvironment('REMOTE_SPACE_AUTH');
  const restart = String.fromEnvironment('REMOTE_RESTART');
  test(
    'Один сервер пространства: атомарная копия и восстановление после перезапуска',
    () async {
      SharedPreferences.setMockInitialValues({});
      final server = await discover(origin, tlsFingerprint: tls);
      final sourceVault = DirectoryVault();
      final session = await SpaceSession.connect(
        await discover(authOrigin),
        sourceVault,
      );
      addTearDown(session.close);
      expect(session.server.publicKey, server.publicKey);
      final kit = RemoteBackupKit.parse(
        RemoteBackupKit(
          url64(List.filled(16, 17)),
          RemoteBackupEndpoint.create(origin, tls, url64(server.publicKey)),
        ).encode(),
      );
      await session.createRemoteBackupSlot(
        CreateBackupSlotRequest(
          id: kit.id,
          readHash: (await Sha256().hash(utf8.encode(kit.space.readToken)))
              .bytes,
          writeHash: (await Sha256().hash(utf8.encode(kit.space.writeToken)))
              .bytes,
        ),
      );
      final sourcePrefs = AppPreferences(), targetPrefs = AppPreferences();
      addTearDown(sourcePrefs.close);
      addTearDown(targetPrefs.close);
      final source = DirectoryBackupService(
        DirectoryRepository(DirectoryStorage()),
        sourceVault,
        sourcePrefs,
        () => {},
      );
      final targetVault = DirectoryVault();
      final target = DirectoryBackupService(
        DirectoryRepository(DirectoryStorage()),
        targetVault,
        targetPrefs,
        () => {},
      );
      await source.apply(
        await source.preview(directoryDocument(count: 3)),
        mergeSettings: true,
      );
      final publisher = RemoteBackupService(
        source,
        connect: LostBackupReply.new,
      );
      await publisher.saveKit(kit);
      await expectLater(
        publisher.publish(kit, 'Отдельный длинный пароль'),
        throwsA(isA<SocketException>()),
      );
      final recovery = RemoteBackupService(target);
      await recovery.saveKit(RemoteBackupKit.parse(kit.encode()));
      final before = await recovery.preview(kit, 'Отдельный длинный пароль');
      expect(before.head.revision.toInt(), 1);
      expect(targetPrefs.origins, isEmpty);
      await waitRemoteRestart(restart);
      await RemoteBackupService(source)
          .publish(kit, 'Отдельный длинный пароль');
      final plan = await recovery.preview(
        RemoteBackupKit.parse(kit.encode()),
        'Отдельный длинный пароль',
      );
      expect(plan.head.revision.toInt(), 1);
      expect(targetPrefs.origins, isEmpty);
      expect(targetVault.records, isEmpty);
      await recovery.apply(plan, mergeSettings: false);
      expect(targetPrefs.origins, ['https://space.example']);
      expect(targetPrefs.palette, 'gruvbox');
      expect(targetVault.records, isEmpty);
      expect(plan.plan.document.spaces.single['following'], hasLength(3));
      final shared = RpcRemoteBackup.session(session);
      await shared.read(
        ReadBackupHeadRequest(
          id: kit.id,
          token: kit.space.readToken,
          challenge: url64(List.filled(32, 29)),
        ),
      );
      await shared.close();
      await session.revokeRemoteBackupSlot(kit.id);
      await session.revokeRemoteBackupSlot(kit.id);
      await session.revokeRemoteBackupSlot(kit.id);
      await expectLater(
        recovery.preview(kit, 'Отдельный длинный пароль'),
        throwsA(anything),
      );
    },
    skip: origin.isEmpty,
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
