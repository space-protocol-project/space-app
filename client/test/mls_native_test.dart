import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/native.dart';

class MemoryMlsStorage implements SecureKeyStorage {
  final values = <String, String>{};
  bool fail = false;
  @override
  Future<String?> read({required String key}) async => values[key];
  @override
  Future<void> write({required String key, required String value}) async {
    if (fail) throw StateError('Хранилище недоступно');
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async => values.remove(key);
}

Future<MlsLocalStore> local(int number, MemoryMlsStorage storage) async {
  final seed = List.filled(32, number);
  final key = await Ed25519().newKeyPairFromSeed(seed);
  return MlsLocalStore(
    storage: storage,
    engine: NativeMlsEngine(),
    deviceSeed: seed,
    scope: {
      'server_id': 'test-server',
      'principal_id': 'participant-$number',
      'grant_id': 'grant-$number',
      'public_key': (await key.extractPublicKey()).bytes,
    },
  );
}

void main() {
  test('После смены root отсутствие прежнего состояния не создаёт новую MLS-идентичность', () async {
    final previous = await local(1, MemoryMlsStorage());
    final required = MlsLocalStore(
      storage: MemoryMlsStorage(),
      engine: NativeMlsEngine(),
      scope: previous.scope,
      deviceSeed: List.filled(32, 2),
      requireExisting: true,
    );
    await expectLater(required.read(), throwsStateError);
  });

  test(
    'Настоящий Rust-мост: привязка проверяется подписью устройства Dart',
    () async {
      final store = await local(1, MemoryMlsStorage());
      final document = await store.read();
      final binding = document['binding'] as Map;
      final signing = utf8.encode(
        jsonEncode([
          'space/mls/binding/v1',
          store.scope,
          binding['mls_public_key'],
        ]),
      );
      expect(
        await Ed25519().verify(
          signing,
          signature: Signature(
            (binding['signature'] as List).cast<int>(),
            publicKey: SimplePublicKey(
              (store.scope['public_key'] as List).cast<int>(),
              type: KeyPairType.ed25519,
            ),
          ),
        ),
        isTrue,
      );
    },
  );

  test('Перезапуск Dart сохраняет MLS-эпоху и обмен сообщениями', () async {
    final aliceStorage = MemoryMlsStorage(), bobStorage = MemoryMlsStorage();
    var alice = await local(1, aliceStorage);
    final bob = await local(2, bobStorage);
    final a = await alice.read(), b = await bob.read();
    final group = base64Encode(utf8.encode('test-server/private-channel'));
    await alice.update('create_group', {'group_id': group});
    final package = await bob.update('key_package', {});
    final invitation = await alice.update('invite', {
      'group_id': group,
      'peer': b['binding'],
      'key_package': package['key_package'],
    });
    final before = await alice.read();
    await expectLater(
      alice.update('confirm_commit', {
        'group_id': group,
        'roster': [a['binding']],
      }),
      throwsStateError,
    );
    expect(await alice.read(), before);
    await alice.update('confirm_commit', {
      'group_id': group,
      'roster': [a['binding'], b['binding']],
    });
    await bob.update('join', {
      'group_id': group,
      'welcome': invitation['welcome'],
      'roster': [a['binding'], b['binding']],
    });
    alice = await local(1, aliceStorage);
    final encrypted = await alice.update('encrypt', {
      'group_id': group,
      'message': {
        'version': 1,
        'id': List.filled(16, 1),
        'text': 'После перезапуска',
        'files': [],
      },
    });
    final decrypted = await bob.update('decrypt', {
      'group_id': group,
      'ciphertext': encrypted['ciphertext'],
    });
    expect((decrypted['message'] as Map)['text'], 'После перезапуска');
    await expectLater(
      bob.update('decrypt', {
        'group_id': group,
        'ciphertext': encrypted['ciphertext'],
      }),
      throwsStateError,
    );
  });

  test('Неудачная запись не подтверждает изменение состояния', () async {
    final storage = MemoryMlsStorage();
    final store = await local(1, storage);
    final before = await store.read();
    storage.fail = true;
    await expectLater(store.update('key_package', {}), throwsStateError);
    storage.fail = false;
    expect((await store.read())['snapshot'], before['snapshot']);
    await store.update('key_package', {});
    expect((await store.read())['revision'], 1);
  });

  test(
    'Два объекта хранилища не теряют обновления одного устройства',
    () async {
      final storage = MemoryMlsStorage();
      final first = await local(1, storage), second = await local(1, storage);
      await first.read();
      await Future.wait([
        first.update('key_package', {}),
        second.update('key_package', {}),
      ]);
      expect((await first.read())['revision'], 2);
    },
  );
}
