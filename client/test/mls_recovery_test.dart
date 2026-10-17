import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/history_archive.dart';

import 'mls_native_test.dart' show local, MemoryMlsStorage;

import 'support/temp_directory.dart';

void main() {
  test(
    'Откат защищённой записи блокирует ratchet, но разрешает архив истории',
    () async {
      final directory = await Directory.systemTemp.createTemp('mls-rollback-');
      addTearDown(
        () => deleteTestDirectory(directory, prefix: 'mls-rollback-'),
      );
      final storage = MemoryMlsStorage();
      final original = await local(1, storage);
      final store = MlsLocalStore(
        storage: storage,
        engine: original.engine,
        scope: original.scope,
        deviceSeed: original.deviceSeed,
        lockDirectory: directory,
      );
      await store.read();
      final old = storage.values[store.storageKey]!;
      await store.update('key_package', {});
      storage.values[store.storageKey] = old;
      await expectLater(store.read(), throwsA(isA<MlsRecoveryRequired>()));
      await expectLater(
        store.update('key_package', {}),
        throwsA(isA<MlsRecoveryRequired>()),
      );
      final archive = await store.historyArchive();
      expect(archive.keys, isNot(contains('snapshot')));
      expect(archive.keys, isNot(contains('key')));
      expect(archive['previous_grant_id'], 'grant-1');
    },
  );

  test(
    'Сбой записи после свидетеля не позволяет возобновить прежнее состояние',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'mls-interrupted-',
      );
      addTearDown(
        () => deleteTestDirectory(directory, prefix: 'mls-interrupted-'),
      );
      final storage = MemoryMlsStorage();
      final original = await local(1, storage);
      final store = MlsLocalStore(
        storage: storage,
        engine: original.engine,
        scope: original.scope,
        deviceSeed: original.deviceSeed,
        lockDirectory: directory,
      );
      await store.read();
      storage.fail = true;
      await expectLater(store.update('key_package', {}), throwsStateError);
      storage.fail = false;
      await expectLater(store.read(), throwsA(isA<MlsRecoveryRequired>()));
    },
  );

  test('Архив зашифрован; неверный пароль и подмена отвергаются', () async {
    final history = {'v': 1, 'channels': <dynamic>[], 'text': 'Секрет'};
    final bytes = await MlsHistoryArchive.seal(
      history,
      'длинный пароль архива',
    );
    expect(utf8.decode(bytes), isNot(contains('Секрет')));
    expect(
      await MlsHistoryArchive.open(bytes, 'длинный пароль архива'),
      history,
    );
    await expectLater(
      MlsHistoryArchive.open(bytes, 'неверный пароль'),
      throwsA(anything),
    );
    final altered = jsonDecode(utf8.decode(bytes)) as Map;
    altered['nonce'] = base64Encode(List.filled(12, 0));
    await expectLater(
      MlsHistoryArchive.open(
        utf8.encode(jsonEncode(altered)),
        'длинный пароль архива',
      ),
      throwsA(anything),
    );
  });
}
