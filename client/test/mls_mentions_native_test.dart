import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/native.dart';
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/mls/history_archive.dart';
import 'package:space_client/src/rpc_connection.dart';
import 'package:space_client/src/rpc_clients.dart' show PublishMlsRequest;

import 'mls_native_test.dart' show local, MemoryMlsStorage;
import 'mls_mentions_test.dart' show annotated;

final group = utf8.encode('test-server/structured-mentions');
final groupArgs = {'group_id': base64Encode(group)};

Future<(MlsLocalStore, MlsLocalStore, List<Object?>)> pair({
  String? legacy,
}) async {
  final alice = await local(1, MemoryMlsStorage());
  var bob = await local(2, MemoryMlsStorage());
  if (legacy != null) {
    bob = MlsLocalStore(
      storage: bob.storage,
      engine: NativeMlsEngine(libraryPath: legacy),
      scope: bob.scope,
      deviceSeed: bob.deviceSeed,
    );
  }
  final a = await alice.read(), b = await bob.read();
  final roster = [a['binding'], b['binding']];
  await alice.update('create_group', groupArgs);
  final package = await bob.update('key_package', {});
  final invitation = await alice.update('invite', {
    ...groupArgs,
    'peer': b['binding'],
    'key_package': package['key_package'],
  });
  await alice.update('confirm_commit', {...groupArgs, 'roster': roster});
  await bob.update('join', {
    ...groupArgs,
    'roster': roster,
    'welcome': invitation['welcome'],
  });
  return (alice, bob, roster);
}

Map<String, dynamic> message() {
  final value = annotated();
  ((value['mentions'] as List).single as Map)['principal_id'] = 'participant-2';
  return value;
}

Future<Map> exchange(
  MlsLocalStore sender,
  MlsLocalStore receiver,
  Map body,
) async {
  final encrypted = await sender.update('encrypt', {
    ...groupArgs,
    'message': body,
  });
  final wire = base64Decode(encrypted['ciphertext'] as String);
  expect(
    utf8.decode(wire, allowMalformed: true),
    isNot(contains('participant-2')),
  );
  final received = await receiver.update('decrypt', {
    ...groupArgs,
    'ciphertext': encrypted['ciphertext'],
  });
  return received['message'] as Map;
}

void main() {
  test(
    'Архив сохраняет v2 и ID; повреждённый импорт не меняет хранилище',
    () async {
      final store = await local(1, MemoryMlsStorage());
      final rpc = RpcConnection.connect(Uri.parse('http://127.0.0.1:1'), '');
      addTearDown(rpc.shutdown);
      final client = MlsClient(
        local: store,
        connection: rpc,
        options: () async => const RpcOptions(),
      );
      final archive = <String, dynamic>{
        'v': 1,
        'server_id': 'test-server',
        'principal_id': 'participant-1',
        'previous_grant_id': 'old-grant',
        'channels': [
          {
            'id': 'private',
            'group_id': base64Encode(
              utf8.encode(
                jsonEncode([
                  'space/mls/group/v1',
                  'test-server',
                  'private',
                  'nonce',
                ]),
              ),
            ),
            'messages': [
              {
                'author_id': 'participant-2',
                'grant_id': 'old-grant',
                'sequence': 1,
                'time': 1,
                'message': message(),
              },
            ],
          },
        ],
      };
      final encrypted = await MlsHistoryArchive.seal(
        archive,
        'длинный пароль архива',
      );
      expect(utf8.decode(encrypted), isNot(contains('participant-2')));
      await client.importHistory(
        await MlsHistoryArchive.open(encrypted, 'длинный пароль архива'),
      );
      final before = await store.read();
      final saved =
          ((before['channels'] as Map)['private'] as Map)['archived_messages']
              as List;
      expect((saved.single as Map)['message'], message());
      final broken = jsonDecode(jsonEncode(archive)) as Map<String, dynamic>;
      broken['channels'][0]['messages'][0]['message']['mentions'][0]['start'] =
          1;
      await expectLater(client.importHistory(broken), throwsFormatException);
      expect(await store.read(), before);
      final pending = base64Encode(
        PublishMlsRequest(
          channelId: 'private',
          kind: 'application',
          ciphertext: [1, 2, 3],
        ).writeToBuffer(),
      );
      await store.change((document) {
        final channel = document['channels']['private'] as Map;
        channel['retry_messages'] = [
          {'message': message()},
        ];
        channel['outbox'] = [
          {'request': pending, 'message': message()},
        ];
      });
      await client.cancelRebasedMessages('private');
      final cancelled = (await store.read())['channels']['private'] as Map;
      expect(cancelled['retry_messages'], isEmpty);
      expect((cancelled['outbox'] as List).single['request'], pending);
    },
  );

  test(
    'Настоящий мост: чтение возможностей не меняет revision и snapshot',
    () async {
      final (alice, bob, _) = await pair();
      final before = await alice.read();
      final features = await alice.messageFeatures(group);
      expect(features.allMentions, isTrue);
      expect(await alice.read(), before);
      final received = await exchange(alice, bob, message());
      expect(received, message());
      final bad = message();
      ((bad['mentions'] as List).single as Map)['start'] = 1;
      final saved = await alice.read();
      await expectLater(
        alice.update('encrypt', {...groupArgs, 'message': bad}),
        throwsStateError,
      );
      expect(await alice.read(), saved);
      expect(
        (await exchange(alice, bob, message()))['mentions'],
        message()['mentions'],
      );
    },
  );

  final legacy = Platform.environment['SPACE_MLS_LEGACY_LIBRARY'];
  test(
    'Настоящий старый DLL: v1 читается, v2 включается после обновления листа',
    () async {
      final (alice, oldBob, roster) = await pair(legacy: legacy);
      expect((await alice.messageFeatures(group)).allMentions, isFalse);
      await expectLater(
        alice.update('encrypt', {...groupArgs, 'message': message()}),
        throwsStateError,
      );
      final plain = {...message(), 'version': 1}..remove('mentions');
      expect((await exchange(alice, oldBob, plain))['text'], plain['text']);
      final bob = MlsLocalStore(
        storage: oldBob.storage,
        engine: NativeMlsEngine(),
        scope: oldBob.scope,
        deviceSeed: oldBob.deviceSeed,
      );
      expect((await bob.messageFeatures(group)).ownMentions, isFalse);
      final update = await bob.update('self_update', groupArgs);
      await bob.update('confirm_commit', {...groupArgs, 'roster': roster});
      await alice.update('apply_commit', {
        ...groupArgs,
        'roster': roster,
        'committer': roster[1],
        'commit': update['commit'],
      });
      expect((await alice.messageFeatures(group)).allMentions, isTrue);
      expect(
        (await exchange(alice, bob, message()))['mentions'],
        message()['mentions'],
      );
    },
    skip: legacy == null
        ? 'Для проверки старого движка задайте SPACE_MLS_LEGACY_LIBRARY'
        : false,
  );
}
