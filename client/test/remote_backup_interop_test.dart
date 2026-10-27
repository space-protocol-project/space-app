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
    if (DateTime.now().isAfter(deadline))
      throw TimeoutException('Перезапуск серверов');
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

void main() {
  RemoteNetworkBinding();
  const storageOrigin = String.fromEnvironment('REMOTE_STORAGE');
  const witnessOrigin = String.fromEnvironment('REMOTE_WITNESS');
  const storageTls = String.fromEnvironment('REMOTE_STORAGE_TLS');
  const witnessTls = String.fromEnvironment('REMOTE_WITNESS_TLS');
  const storageAuth = String.fromEnvironment('REMOTE_STORAGE_AUTH');
  const witnessAuth = String.fromEnvironment('REMOTE_WITNESS_AUTH');
  const restart = String.fromEnvironment('REMOTE_RESTART');
  test(
    'Два HTTPS/Connect сервера, отдельные БД, потерянный ответ и восстановление после перезапуска',
    () async {
      SharedPreferences.setMockInitialValues({});
      final server = await discover(storageOrigin, tlsFingerprint: storageTls);
      final witnessServer = await discover(
        witnessOrigin,
        tlsFingerprint: witnessTls,
      );
      final sourceVault = DirectoryVault();
      final storageSession = await SpaceSession.connect(
        await discover(storageAuth),
        sourceVault,
      );
      addTearDown(storageSession.close);
      final witnessSession = await SpaceSession.connect(
        await discover(witnessAuth),
        sourceVault,
      );
      addTearDown(witnessSession.close);
      expect(storageSession.server.publicKey, server.publicKey);
      expect(witnessSession.server.publicKey, witnessServer.publicKey);
      final kit = RemoteBackupKit.parse(
        RemoteBackupKit(
          url64(List.filled(16, 17)),
          RemoteBackupEndpoint.create(
            storageOrigin,
            storageTls,
            url64(server.publicKey),
          ),
          RemoteBackupEndpoint.create(
            witnessOrigin,
            witnessTls,
            url64(witnessServer.publicKey),
          ),
        ).encode(),
      );
      for (final (endpoint, session, witness) in [
        (kit.storage, storageSession, false),
        (kit.witness, witnessSession, true),
      ]) {
        await session.createRemoteBackupSlot(
          CreateBackupSlotRequest(
            id: kit.id,
            witness: witness,
            readHash: (await Sha256().hash(utf8.encode(endpoint.readToken)))
                .bytes,
            writeHash: (await Sha256().hash(utf8.encode(endpoint.writeToken)))
                .bytes,
          ),
        );
      }
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
        replaceSettings: true,
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
      await expectLater(
        recovery.preview(kit, 'Отдельный длинный пароль'),
        throwsFormatException,
      );
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
      await recovery.apply(plan, replaceSettings: false);
      expect(targetPrefs.origins, ['https://space.example']);
      expect(targetPrefs.palette, 'gruvbox');
      expect(targetVault.records, isEmpty);
      expect(plan.plan.document.spaces.single['following'], hasLength(3));
      await storageSession.revokeRemoteBackupSlot(kit.id);
      await witnessSession.revokeRemoteBackupSlot(kit.id);
      await witnessSession.revokeRemoteBackupSlot(kit.id);
      await expectLater(
        recovery.preview(kit, 'Отдельный длинный пароль'),
        throwsA(anything),
      );
    },
    skip: storageOrigin.isEmpty,
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
