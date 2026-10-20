import 'package:space_client/src/chat_notifications.dart';
import 'package:space_client/src/mls/notifications.dart';

import 'dart:convert';

import 'package:space_client/src/message_search.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/rpc_clients.dart'
    show
        AuthServiceClient,
        AdminServiceClient,
        ListMembersRequest,
        ListDevicesRequest,
        DeviceGrant,
        PublishMlsRequest,
        PublishMlsResponse,
        ListMlsEnvelopesRequest,
        ListMlsDevicesResponse,
        UpdateMemberRequest;
import 'package:space_client/src/root_rotation.dart' as rotation;
import 'package:space_client/src/pairing.dart';
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/mls/replies.dart';
import 'package:space_client/src/mls/files.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/native.dart';
import 'package:space_client/src/mls/history_archive.dart';

import '../mls_native_test.dart' show MemoryMlsStorage;
import '../../tool/attachment_policy_fixture.dart';
import '../support/rpc_fault_proxy.dart';

class _Identity implements RotationJournalVault {
  Map<String, dynamic>? pending;
  @override
  Future<Map<String, dynamic>?> loadRotation(String origin) async => pending;
  @override
  Future<void> saveRotation(String origin, Map<String, dynamic> value) async {
    pending = value;
  }

  @override
  Future<void> clearRotation(String origin) async {
    pending = null;
  }

  DeviceRecord? record;
  bool failSave = false;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async {
    if (failSave) throw StateError('Сбой активации после commit');
    record = value;
  }
}

Future<MlsClient> client(SpaceSession session, MemoryMlsStorage storage) async {
  final public = await (await Ed25519().newKeyPairFromSeed(
    session.record.deviceSeed,
  )).extractPublicKey();
  final grant = session.record.grantId;
  final scope =
      session.record.mlsIdentity ??
      {
        'server_id': session.server.serverId,
        'principal_id': session.principalId,
        'grant_id': grant,
        'public_key': public.bytes,
      };
  session.record.mlsIdentity = scope;
  await session.vault.save(session.record);

  return MlsClient(
    connection: session.channel,
    options: () => session.mlsOptions(expectedGrant: grant),
    local: MlsLocalStore(
      storage: storage,
      engine: NativeMlsEngine(),
      deviceSeed: session.record.deviceSeed,
      scope: scope,
      requireExisting: scope['grant_id'] != grant,
    ),
  );
}

void main() {
  final origin = Platform.environment['SPACE_MLS_TEST_ORIGIN'];
  final sharedOwnerVault = _Identity();
  final sharedOwnerStorage = MemoryMlsStorage();
  test(
    'MLS: три настоящих Dart-клиента, сервер, файлы, перезапуск и исключение',
    () async {
      final address = Uri.parse(origin!);
      expect(InternetAddress.tryParse(address.host)?.isLoopback, isTrue);
      final server = await discover(origin);
      final owner = await SpaceSession.connect(server, sharedOwnerVault);
      addTearDown(owner.close);
      await enableFixtureAttachments(owner);
      final memberVault = _Identity();
      var member = await SpaceSession.connect(server, memberVault);
      addTearDown(member.close);
      final third = await SpaceSession.connect(server, _Identity());
      addTearDown(third.close);
      expect(owner.role, 'owner');
      final storageA = sharedOwnerStorage,
          storageB = MemoryMlsStorage(),
          storageC = MemoryMlsStorage();
      final a = await client(owner, storageA);
      var b = await client(member, storageB);
      final c = await client(third, storageC);
      await a.initialize();
      await b.initialize();
      await c.initialize();
      await a.createChannel('private', 'Закрытая переписка');
      await owner.refreshChannels();
      final group = owner.availableChannels
          .firstWhere((channel) => channel.id == 'private')
          .mlsGroupId;
      final devices = await a.devices('private');
      final deviceA = devices.firstWhere(
        (d) => d.grantId == owner.record.grantId,
      );
      final deviceB = devices.firstWhere(
        (d) => d.grantId == member.record.grantId,
      );
      final deviceC = devices.firstWhere(
        (d) => d.grantId == third.record.grantId,
      );
      expect(
        mlsFingerprint(mlsBinding(deviceB)),
        mlsFingerprint(await b.ownBinding()),
      );
      await a.trust(deviceB);
      await a.invite('private', deviceB);
      var view = await b.refresh('private', group);
      expect(view.joined, isFalse);
      expect(view.untrusted.single.grantId, deviceA.grantId);
      await b.trust(deviceA);
      view = await b.refresh('private', group);
      expect(view.joined, isTrue);
      final watcher = MlsNotificationWatcher();
      addTearDown(watcher.dispose);
      final notices = <ChatNotice>[];
      final source = MlsNotificationSource(
        origin: origin,
        principal: member.principalId,
        channel: owner.availableChannels.firstWhere((c) => c.id == 'private'),
        open: () async => b,
        valid: () => true,
      );
      await watcher.poll([source], notices.add);
      expect(notices, isEmpty);
      await a.send('private', 'Секретный текст');
      await watcher.poll([source], notices.add);
      expect(notices.single.message!.text, 'Секретный текст');
      expect(
        (await watcher.message(source, notices.single.message!.id))!.text,
        'Секретный текст',
      );
      await watcher.poll([source], notices.add);
      expect(notices, hasLength(1));
      view = await b.refresh('private', group);
      expect(
        (view.messages.single['message'] as Map)['text'],
        'Секретный текст',
      );
      final localSearch = await searchMlsMessages(
        b,
        'private',
        group,
        'СЕКРЕТНЫЙ',
        '',
      );
      expect(localSearch.messages.single.text, 'Секретный текст');
      expect(localSearch.next, isEmpty);
      final originalReply = mlsReplyReference(view.messages.single);
      await a.trust(deviceC);
      await a.invite('private', deviceC);
      view = await b.refresh('private', group);
      expect(view.untrusted.single.grantId, deviceC.grantId);
      await b.trust(deviceC);
      await b.refresh('private', group);
      await c.trust(deviceA);
      await c.trust(deviceB);
      view = await c.refresh('private', group);
      expect(view.joined, isTrue);
      await b.selfUpdate('private');
      await a.refresh('private', group);
      await c.refresh('private', group);
      final codeA = await a.groupCode('private');
      expect(await b.groupCode('private'), codeA);
      expect(await c.groupCode('private'), codeA);
      expect(
        view.messages,
        isEmpty,
        reason: 'Новому устройству не выдаётся старая история',
      );
      final bytes = Uint8List.fromList(
        List.generate(256 * 1024 + 31, (i) => i % 251),
      );
      await MlsFiles(a).send('private', group, 'Файл для группы', [
        XFile.fromData(bytes, path: 'секретный-файл.bin'),
      ], reply: originalReply);
      view = await c.refresh('private', group);
      final item = view.messages.single;
      final message = item['message'] as Map;
      expect(message['reply'], originalReply);
      expect(
        findMlsReply(view.messages, message['reply'] as Map),
        isNull,
        reason: 'Новому leaf недоступна история до приглашения',
      );
      final descriptor =
          (message['files'] as List).single as Map<String, dynamic>;
      expect(descriptor['name'], 'секретный-файл.bin');
      expect(
        await MlsFiles(c)
            .download(group, (message['id'] as List).cast<int>(), descriptor),
        bytes,
      );
      await c.setReaction('private', item, '👍', true);
      await a.refresh('private', group);
      b = await client(member, storageB);
      view = await b.refresh('private', group);
      expect((view.messages.last['reactions'] as List).single.emoji, '👍');
      expect((view.messages.last['reactions'] as List).single.principalIds, [
        third.principalId,
      ]);
      final cForReactionRestart = await client(third, storageC);
      final restoredReactions = await cForReactionRestart.refresh(
        'private',
        group,
      );
      expect(
        (restoredReactions.messages.last['reactions'] as List).single.emoji,
        '👍',
      );
      final reactionProxy = RpcFaultProxy(cForReactionRestart.connection);
      reactionProxy.mutate = (_, response) {
        if (response is PublishMlsResponse) {
          throw const GrpcError.unavailable('Потеря подтверждения реакции');
        }
        return response;
      };
      final interruptedReaction = MlsClient(
        local: cForReactionRestart.local,
        connection: reactionProxy,
        options: cForReactionRestart.options,
      );
      await expectLater(
        interruptedReaction.setReaction(
          'private',
          restoredReactions.messages.last,
          '👍',
          false,
        ),
        throwsA(isA<GrpcError>()),
      );
      expect(
        ((await interruptedReaction.local.read())['channels']
            as Map)['private']['outbox'],
        hasLength(1),
      );
      final resumedReaction = await client(third, storageC);
      await resumedReaction.refresh('private', group);
      expect(
        ((await resumedReaction.local.read())['channels']
            as Map)['private']['outbox'],
        isEmpty,
      );
      view = await b.refresh('private', group);
      expect(view.messages.last['reactions'], isEmpty);
      expect(view.messages, hasLength(2));
      await b.send('private', 'После перезапуска');
      view = await a.refresh('private', group);
      expect(
        view.messages.any(
          (m) => (m['message'] as Map)['text'] == 'После перезапуска',
        ),
        isTrue,
      );
      await MlsFiles(b).send('private', group, 'Мой файл до смены root', [
        XFile.fromData(bytes, path: 'мой-файл.bin'),
      ]);
      view = await a.refresh('private', group);
      final ownFileMessage = view.messages.last['message'] as Map;
      final ownDescriptor =
          (ownFileMessage['files'] as List).single as Map<String, dynamic>;
      await c.refresh('private', group);
      final admin = AdminServiceClient(owner.channel);
      final adminOptions = await owner.mlsOptions(
        expectedGrant: owner.record.grantId,
      );
      final members = await admin.listMembers(
        ListMembersRequest(),
        options: adminOptions,
      );
      final target = members.members.firstWhere(
        (m) => m.principalId == third.principalId,
      );
      final reader = await admin.updateMember(
        UpdateMemberRequest(
          principalId: target.principalId,
          role: 'reader',
          expectedRevision: target.revision,
        ),
        options: adminOptions,
      );
      await expectLater(
        a.transfer('private', deviceC),
        throwsA(isA<GrpcError>()),
      );
      await a.cancelTransfer('private');
      await a.send('private', 'Отказ передачи не блокирует переписку');
      await admin.updateMember(
        UpdateMemberRequest(
          principalId: target.principalId,
          role: 'member',
          expectedRevision: reader.member.revision,
        ),
        options: adminOptions,
      );
      await b.refresh('private', group);
      await c.refresh('private', group);
      await a.transfer('private', deviceB);
      view = await b.refresh('private', group);
      expect(view.channel['managers'], [deviceB.grantId]);
      await c.refresh('private', group);
      await expectLater(a.remove('private', deviceC), throwsStateError);
      final oldGrant = member.record.grantId;
      for (var round = 0; round < 2; round++) {
        await member.prepareRotation();
        if (round == 0) {
          memberVault.failSave = true;
          await expectLater(
            rotation.finishRootRotation(
              server,
              memberVault,
              AuthServiceClient(member.channel),
            ),
            throwsStateError,
          );
          memberVault.failSave = false;
          await expectLater(
            b.refresh('private', group),
            throwsA(isA<GrpcError>()),
          );
        }
        await rotation.finishRootRotation(
          server,
          memberVault,
          AuthServiceClient(member.channel),
        );
        await member.close();
        member = await SpaceSession.connect(server, memberVault);
        addTearDown(member.close);
        expect(member.record.grantId, isNot(oldGrant));
        b = await client(member, storageB);
        view = await b.refresh('private', group);
        expect(view.channel['managers'], [deviceB.grantId]);
        expect(
          mlsFingerprint(await b.ownBinding()),
          mlsFingerprint(mlsBinding(deviceB)),
        );
        expect(
          await MlsFiles(b).download(
            group,
            (ownFileMessage['id'] as List).cast<int>(),
            ownDescriptor,
          ),
          bytes,
        );
        expect(
          view.messages.any(
            (m) => (m['message'] as Map)['text'] == 'Секретный текст',
          ),
          isTrue,
        );
        expect(
          await MlsFiles(b)
              .download(group, (message['id'] as List).cast<int>(), descriptor),
          bytes,
        );
        await b.send('private', 'После смены root $round');
        await a.refresh('private', group);
        view = await c.refresh('private', group);
        expect(
          (view.messages.last['message'] as Map)['text'],
          'После смены root $round',
        );
      }
      await b.transfer('private', deviceA);
      await a.refresh('private', group);
      await c.refresh('private', group);
      final failing = RpcFaultProxy(a.connection)
        ..beforeRequest = (request) {
          if (request is PublishMlsRequest) {
            throw const GrpcError.unavailable('Обрыв до доставки');
          }
        };
      final interrupted = MlsClient(
        local: a.local,
        connection: failing,
        options: a.options,
      );
      await a.local.change((document) {
        ((document['channels'] as Map)['private'] as Map)['last_self_update'] =
            0;
      });
      await expectLater(
        interrupted.send(
          'private',
          'Очередь пережила отзыв',
          reply: mlsReplyReference(item),
        ),
        throwsA(isA<GrpcError>()),
      );
      await member.revoke();
      await expectLater(c.maintainChannels(force: true), throwsStateError);
      final lyingDirectory = RpcFaultProxy(c.connection)
        ..mutate = (_, response) {
          if (response is ListMlsDevicesResponse) {
            return ListMlsDevicesResponse(
              devices: [...response.devices, deviceB],
              nextCursor: response.nextCursor,
            );
          }
          return response;
        };
      final deceived = MlsClient(
        local: c.local,
        connection: lyingDirectory,
        options: c.options,
      );
      await expectLater(
        deceived.maintainChannels(force: true),
        throwsStateError,
      );
      final stopped = await c.local.read();
      await expectLater(
        c.send('private', 'Не шифровать до Remove'),
        throwsStateError,
      );
      expect(await c.local.read(), stopped);
      await a.maintainChannels(force: true);
      expect(
        (((await a.local.read())['channels'] as Map)['private']
            as Map)['outbox'],
        isEmpty,
      );
      expect(
        (await a.refresh('private', group)).messages.where(
          (entry) =>
              (entry['message'] as Map)['text'] == 'Очередь пережила отзыв',
        ),
        hasLength(1),
      );
      expect(
        (((await a.local.read())['channels'] as Map)['private']
                as Map)['roster']
            as List,
        isNot(
          contains(
            predicate(
              (dynamic item) =>
                  (item['device'] as Map)['grant_id'] == deviceB.grantId,
            ),
          ),
        ),
      );
      await c.refresh('private', group);
      final replyView = await c.refresh('private', group);
      final rebasedReply = replyView.messages.singleWhere(
        (entry) => entry['message']['text'] == 'Очередь пережила отзыв',
      );
      expect(rebasedReply['message']['reply'], mlsReplyReference(item));
      await expectLater(
        b.refresh('private', group),
        throwsA(
          isA<GrpcError>().having(
            (e) => e.code,
            'code',
            anyOf(StatusCode.permissionDenied, StatusCode.unauthenticated),
          ),
        ),
      );
      await a.send('private', 'После исключения');
      view = await c.refresh('private', group);
      expect(
        (view.messages.last['message'] as Map)['text'],
        'После исключения',
      );
      expect(
        utf8
            .decode(
              base64Decode((await a.local.read())['snapshot'] as String),
              allowMalformed: true,
            )
            .contains('Секретный текст'),
        isFalse,
      );
    },
    skip: origin == null,
    timeout: const Timeout(Duration(minutes: 3)),
  );
  test(
    'Три устройства одной личности сохраняют MLS и файлы после двух смен root',
    () async {
      final server = await discover(origin!);
      final va = sharedOwnerVault, vb = _Identity(), vc = _Identity();
      var owner = await SpaceSession.connect(server, va);
      addTearDown(() => owner.close());
      final pairing = await PendingPairing.start(server);
      await owner.preparePairing(pairing.request.pairing);
      await pairing.poll();
      await owner.approvePairing(pairing.request.pairing);
      final approved = await pairing.poll();
      final recordB = await pairing.verifiedRecord(approved);
      final second = await SpaceSession.connect(
        server,
        vb,
        restoredRecord: recordB,
        pairingId: pairing.request.pairing.id,
      );
      pairing.claimed = true;
      await pairing.close();
      addTearDown(second.close);
      final newDevice = await Ed25519().newKeyPair();
      final recordC = DeviceRecord.fromJson({
        ...owner.record.toJson(),
        'grantId': '',
        'deviceSeed': url64(await newDevice.extractPrivateKeyBytes()),
        'mlsIdentity': null,
        'mlsChannels': <String, String>{},
      });
      var third = await SpaceSession.connect(
        server,
        vc,
        restoredRecord: recordC,
      );
      addTearDown(() => third.close());
      expect(second.principalId, owner.principalId);
      expect(third.principalId, owner.principalId);
      final sa = sharedOwnerStorage,
          sb = MemoryMlsStorage(),
          sc = MemoryMlsStorage();
      var a = await client(owner, sa);
      final b = await client(second, sb);
      var c = await client(third, sc);
      await b.initialize();
      await c.initialize();
      await a.initialize();
      await a.createChannel('retention', 'Сохранение устройств');
      await owner.refreshChannels();
      final group = owner.availableChannels
          .firstWhere((c) => c.id == 'retention')
          .mlsGroupId;
      final devices = await a.devices('retention');
      final da = devices.firstWhere((d) => d.grantId == owner.record.grantId);
      final db = devices.firstWhere((d) => d.grantId == second.record.grantId);
      final dc = devices.firstWhere((d) => d.grantId == third.record.grantId);
      await a.trust(db);
      await a.invite('retention', db);
      await b.trust(da);
      await b.refresh('retention', group);
      await a.trust(dc);
      await a.invite('retention', dc);
      await b.trust(dc);
      await b.refresh('retention', group);
      await c.trust(da);
      await c.trust(db);
      await c.refresh('retention', group);
      final bytes = Uint8List.fromList(List.generate(1024, (i) => i % 251));
      await MlsFiles(b).send('retention', group, 'До смены root', [
        XFile.fromData(bytes, path: 'history.bin'),
      ]);
      final oldMessage =
          (await a.refresh('retention', group)).messages.last['message'] as Map;
      await c.refresh('retention', group);
      final beforeFingerprint = mlsFingerprint(await b.ownBinding());
      final beforeGrant = second.record.grantId;
      final beforeC = third.record.grantId;
      await third.close();
      final before = (await AuthServiceClient(owner.channel).listDevices(
        ListDevicesRequest(),
        options: await owner.mlsOptions(expectedGrant: owner.record.grantId),
      )).devices.firstWhere((d) => d.id == beforeGrant);
      for (var round = 0; round < 2; round++) {
        final reviewed = await owner.previewRotationDevices();
        if (round == 0) {
          final changed = reviewed
              .map((d) => DeviceGrant.fromBuffer(d.writeToBuffer()))
              .toList();
          changed.first.publicKey[0] ^= 1;
          await expectLater(
            owner.prepareRotation(retainedDevices: changed),
            throwsException,
          );
          expect(va.pending, isNull);
        }
        await owner.prepareRotation(retainedDevices: reviewed);
        final next = await rotation.finishRootRotation(
          server,
          va,
          AuthServiceClient(owner.channel),
        );
        expect(next, isNotNull);
        await owner.close();
        owner = await SpaceSession.connect(server, va);
        a = await client(owner, sa);
        await a.refresh('retention', group);
        await a.send('retention', 'После смены root $round');
        String? pending;
        if (round == 0) {
          await expectLater(
            b.send('retention', 'Сохранённая очередь'),
            throwsA(isA<GrpcError>()),
          );
          pending =
              ((((await b.local.read())['channels'] as Map)['retention']
                              as Map)['outbox']
                          as List)
                      .single['request']
                  as String;
        } else {
          await expectLater(
            b.refresh('retention', group),
            throwsA(isA<GrpcError>()),
          );
        }
        if (round == 0) {
          vb.failSave = true;
          await expectLater(b.refresh('retention', group), throwsStateError);
          expect(second.record.rootHistory, isEmpty);
          expect(
            ((((await b.local.read())['channels'] as Map)['retention']
                        as Map)['outbox']
                    as List)
                .single['request'],
            pending,
          );
          vb.failSave = false;
        }
        final view = await b.refresh('retention', group);
        expect(
          view.messages.any(
            (m) => (m['message'] as Map)['text'] == 'После смены root $round',
          ),
          isTrue,
        );
        if (pending != null) {
          final request = PublishMlsRequest.fromBuffer(base64Decode(pending));
          final envelopes = await b.rpc.listMlsEnvelopes(
            ListMlsEnvelopesRequest(channelId: 'retention'),
            options: await b.options(),
          );
          final received = envelopes.envelopes.singleWhere(
            (e) => base64Encode(e.requestId) == base64Encode(request.requestId),
          );
          expect(received.ciphertext, request.ciphertext);
        }
        expect(second.record.grantId, beforeGrant);
        expect(second.record.rootSeed, isEmpty);
        expect(second.record.recoverySeed, isEmpty);
        expect(mlsFingerprint(await b.ownBinding()), beforeFingerprint);
        final current = (await AuthServiceClient(owner.channel).listDevices(
          ListDevicesRequest(),
          options: await owner.mlsOptions(expectedGrant: owner.record.grantId),
        )).devices.firstWhere((d) => d.id == beforeGrant);
        expect(current.expiresAt, before.expiresAt);
        expect(current.scopes, before.scopes);
        expect(current.publicKey, before.publicKey);
      }
      third = await SpaceSession.connect(server, vc);
      expect(third.record.grantId, beforeC);
      expect(third.record.rootSeed, isEmpty);
      c = await client(third, sc);
      final view = await c.refresh('retention', group);
      expect(view.messages, hasLength(4));
      final descriptor =
          (oldMessage['files'] as List).single as Map<String, dynamic>;
      expect(
        await MlsFiles(
          c,
        ).download(group, (oldMessage['id'] as List).cast<int>(), descriptor),
        bytes,
      );
      expect(
        await MlsFiles(
          b,
        ).download(group, (oldMessage['id'] as List).cast<int>(), descriptor),
        bytes,
      );
      await b.send('retention', 'Устройства сохранили доступ');
      expect(
        ((await a.refresh('retention', group)).messages.last['message']
            as Map)['text'],
        'Устройства сохранили доступ',
      );
      final archive = await MlsHistoryArchive.seal(
        await a.local.historyArchive(),
        'надёжный пароль архива',
      );
      final restoredKey = await Ed25519().newKeyPair();
      final restoredRecord = DeviceRecord.fromJson({
        ...owner.record.toJson(),
        'grantId': '',
        'deviceSeed': url64(await restoredKey.extractPrivateKeyBytes()),
        'mlsIdentity': null,
        'mlsChannels': <String, String>{},
      });
      final restored = await SpaceSession.connect(
        server,
        _Identity(),
        restoredRecord: restoredRecord,
      );
      addTearDown(restored.close);
      final d = await client(restored, MemoryMlsStorage());
      await d.initialize();
      final freshBefore = await d.local.read();
      await d.importHistory(
        await MlsHistoryArchive.open(archive, 'надёжный пароль архива'),
      );
      final freshAfter = await d.local.read();
      expect(freshAfter['snapshot'], freshBefore['snapshot']);
      expect(freshAfter['revision'], freshBefore['revision']);
      expect(
        mlsFingerprint(await d.ownBinding()),
        isNot(mlsFingerprint(await a.ownBinding())),
      );
      final available = await a.devices('retention');
      for (final device in available) {
        await d.trust(device);
      }
      final deviceD = available.firstWhere(
        (device) => device.grantId == restored.record.grantId,
      );
      await a.trust(deviceD);
      await a.invite('retention', deviceD);
      final restoredView = await d.refresh('retention', group);
      expect(restoredView.joined, isTrue);
      expect(
        restoredView.messages.any(
          (entry) =>
              (entry['message'] as Map)['text'] ==
              'Устройства сохранили доступ',
        ),
        isTrue,
      );
      expect(
        await MlsFiles(
          d,
        ).download(group, (oldMessage['id'] as List).cast<int>(), descriptor),
        bytes,
      );
      await d.send('retention', 'Свежий leaf после восстановления');
      expect(
        ((await a.refresh('retention', group)).messages.last['message']
            as Map)['text'],
        'Свежий leaf после восстановления',
      );
    },
    skip: origin == null,
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
