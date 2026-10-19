import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/mls/local_store.dart';

import 'mls_native_test.dart' show local, MemoryMlsStorage;
import 'support/temp_directory.dart';

void main() {
  test(
    'Сбой после свидетеля завершает только остановку, не активируя снимок',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'mls-migration-interrupted-',
      );
      addTearDown(
        () => deleteTestDirectory(
          directory,
          prefix: 'mls-migration-interrupted-',
        ),
      );
      final storage = MemoryMlsStorage();
      final original = await local(1, storage);
      final source = MlsLocalStore(
        storage: storage,
        engine: original.engine,
        scope: original.scope,
        deviceSeed: original.deviceSeed,
        lockDirectory: directory,
      );
      await source.read();
      late Map<String, dynamic> preserved;
      await expectLater(
        source.transferCheckpoint('interrupted', (doc) async {
          preserved = doc;
          storage.fail = true;
        }),
        throwsStateError,
      );
      storage.fail = false;
      await expectLater(source.read(), throwsA(isA<MlsRecoveryRequired>()));
      await expectLater(
        source.resumeTransfer(preserved, 'different-transfer'),
        throwsA(isA<MlsRecoveryRequired>()),
      );
      expect(await source.resumeTransfer(preserved, 'interrupted'), true);
      await expectLater(source.read(), throwsStateError);
      final stopped = jsonDecode(storage.values[source.storageKey]!) as Map;
      expect(stopped['key'], isNull);
      expect(stopped['snapshot'], isNull);
    },
  );
  test(
    'Перенос настоящего MLS сохраняет обмен и блокирует источник и откат',
    () async {
      final root = await Directory.systemTemp.createTemp('mls-migration-test-');
      addTearDown(
        () => deleteTestDirectory(root, prefix: 'mls-migration-test-'),
      );
      final original = await local(1, MemoryMlsStorage());
      final source = MlsLocalStore(
        storage: original.storage,
        engine: original.engine,
        scope: original.scope,
        deviceSeed: original.deviceSeed,
        lockDirectory: Directory('${root.path}/source'),
      );
      final bob = await local(2, MemoryMlsStorage());
      final aliceState = await source.read(), bobState = await bob.read();
      final group = base64Encode(utf8.encode('test-server/migration-channel'));
      await source.update('create_group', {'group_id': group});
      final package = await bob.update('key_package', {});
      final invitation = await source.update('invite', {
        'group_id': group,
        'peer': bobState['binding'],
        'key_package': package['key_package'],
      });
      final roster = [aliceState['binding'], bobState['binding']];
      await source.update('confirm_commit', {
        'group_id': group,
        'roster': roster,
      });
      await bob.update('join', {
        'group_id': group,
        'welcome': invitation['welcome'],
        'roster': roster,
      });
      await source.change(
        (doc) => doc['channels']['cached'] = {
          'messages': [
            {'text': 'история'},
          ],
          'files': ['file-key'],
        },
      );
      late Map<String, dynamic> checkpoint;
      await source.transferCheckpoint(
        'migration-1',
        (doc) async => checkpoint = doc,
      );
      final stopped = jsonDecode(
        (source.storage as MemoryMlsStorage).values[source.storageKey]!,
      ) as Map;
      expect(stopped.containsKey('key'), false);
      expect(stopped.containsKey('snapshot'), false);
      await expectLater(source.update('key_package', {}), throwsStateError);
      final target = MlsLocalStore(
        storage: MemoryMlsStorage(),
        engine: source.engine,
        scope: source.scope,
        deviceSeed: source.deviceSeed,
        lockDirectory: Directory('${root.path}/target'),
        requireExisting: true,
      );
      await target.restoreCheckpoint(checkpoint, 'migration-1');
      expect((await target.read())['channels'], checkpoint['channels']);
      final encrypted = await target.update('encrypt', {
        'group_id': group,
        'message': {
          'version': 1,
          'id': List.filled(16, 3),
          'text': 'После переноса',
          'files': [],
        },
      });
      final decrypted = await bob.update('decrypt', {
        'group_id': group,
        'ciphertext': encrypted['ciphertext'],
      });
      expect((decrypted['message'] as Map)['text'], 'После переноса');
      final after = await target.read();
      await target.restoreCheckpoint(checkpoint, 'migration-1');
      expect(await target.read(), after);
      await expectLater(
        target.restoreCheckpoint(checkpoint, 'another-transfer'),
        throwsStateError,
      );
      final returned = await bob.update('encrypt', {
        'group_id': group,
        'message': {
          'version': 1,
          'id': List.filled(16, 4),
          'text': 'Ответ новому устройству',
          'files': [],
        },
      });
      final reply = await target.update('decrypt', {
        'group_id': group,
        'ciphertext': returned['ciphertext'],
      });
      expect((reply['message'] as Map)['text'], 'Ответ новому устройству');
    },
  );

  test(
    'Ошибка сохранения архива не останавливает исходное состояние',
    () async {
      final source = await local(1, MemoryMlsStorage());
      final before = await source.read();
      await expectLater(
        source.transferCheckpoint(
          'failed',
          (_) async => throw StateError('disk full'),
        ),
        throwsStateError,
      );
      expect(await source.read(), before);
      await source.update('key_package', {});
    },
  );

  test('Повреждённый снимок не записывается на новом устройстве', () async {
    final source = await local(1, MemoryMlsStorage());
    final checkpoint = await source.read();
    checkpoint['snapshot'] = base64Encode(List.filled(100, 0));
    final target = await local(1, MemoryMlsStorage());
    await expectLater(
      target.restoreCheckpoint(checkpoint, 'bad'),
      throwsStateError,
    );
    expect(await target.storage.read(key: target.storageKey), isNull);
  });
}
