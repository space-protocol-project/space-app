import 'dart:convert';

import 'package:connectrpc/connect.dart' as connect;
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protobuf/protobuf.dart';
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/mls/replies.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/src/rpc_connection.dart';

import 'mls_native_test.dart' show MemoryMlsStorage, local;
import 'support/rpc_fault_proxy.dart';

import 'package:grpc/grpc.dart';

class _Server implements RpcConnection {
  late GeneratedMessage Function(GeneratedMessage request) respond;

  @override
  Future<O> unary<I extends GeneratedMessage, O extends GeneratedMessage>(
    connect.Spec<I, O> spec,
    I request, {
    RpcOptions? options,
  }) async => respond(request) as O;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'Ответ MLS переживает потерю квитанции и перезапуск без дубля',
    () async {
      final storage = MemoryMlsStorage();
      var store = await local(1, storage);
      final server = _Server();
      var loseReply = false;
      final accepted = <String, MlsEnvelope>{};
      server.respond = (request) {
        if (request is RegisterMlsDeviceRequest) {
          return RegisterMlsDeviceResponse();
        }
        if (request is CreateChannelRequest) return CreateChannelResponse();
        if (request is ListMlsDevicesRequest) {
          return ListMlsDevicesResponse(
            devices: [MlsDevice(grantId: 'grant-1')],
          );
        }
        if (request is ListMlsEnvelopesRequest) {
          return ListMlsEnvelopesResponse(
            envelopes: accepted.values.where(
              (e) => e.sequence > request.afterSequence,
            ),
            nextSequence: Int64(accepted.length),
          );
        }
        final publish = request as PublishMlsRequest;
        final key = base64Encode(publish.requestId);
        final envelope = accepted.putIfAbsent(
          key,
          () => MlsEnvelope(
            sequence: Int64(accepted.length + 1),
            epoch: publish.expectedEpoch,
            kind: publish.kind,
            requestId: publish.requestId,
            ciphertext: publish.ciphertext,
            authorGrantId: 'grant-1',
            authorId: 'participant-1',
          ),
        );
        if (loseReply) throw const GrpcError.unavailable('Обрыв после приёма');
        return PublishMlsResponse(envelope: envelope);
      };
      MlsClient client() => MlsClient(
        local: store,
        connection: server,
        options: () async => const RpcOptions(),
      );
      var sender = client();
      await sender.createChannel('private', 'Закрытый');
      await sender.send('private', 'Источник');
      var channel =
          ((await store.read())['channels'] as Map)['private']
              as Map<String, dynamic>;
      final reference = mlsReplyReference(
        MlsChannelData(channel).messages.single,
      );
      final beforeInvalid = jsonEncode(await store.read());
      await expectLater(
        sender.send(
          'private',
          'Чужая ссылка',
          reply: {'grant_id': 'другой', 'message_id': List.filled(16, 2)},
        ),
        throwsStateError,
      );
      expect(jsonEncode(await store.read()), beforeInvalid);
      loseReply = true;
      await expectLater(
        sender.send('private', 'Ответ', reply: reference),
        throwsA(isA<GrpcError>()),
      );
      channel =
          ((await store.read())['channels'] as Map)['private']
              as Map<String, dynamic>;
      final request = (channel['outbox'] as List).single as Map;
      expect((request['message'] as Map)['reply'], reference);
      final ciphertext = request['request'];
      store = await local(1, storage);
      sender = client();
      loseReply = false;
      final result = await sender.refresh(
        'private',
        base64Decode(channel['group_id'] as String),
      );
      expect(result.messages, hasLength(2));
      expect(result.messages.last['message']['reply'], reference);
      expect(result.channel['outbox'], isEmpty);
      expect(accepted, hasLength(2));
      final archive = await store.historyArchive();
      final fresh = await local(3, MemoryMlsStorage());
      fresh.scope['principal_id'] = 'participant-1';
      final restored = MlsClient(
        local: fresh,
        connection: server,
        options: () async => const RpcOptions(),
      );
      await restored.importHistory(archive);
      final recoveredChannel =
          ((await fresh.read())['channels'] as Map)['private']
              as Map<String, dynamic>;
      expect(
        MlsChannelData(recoveredChannel).messages.last['message']['reply'],
        reference,
      );
      expect(
        recoveredChannel['joined'],
        isFalse,
        reason: 'Архив не восстанавливает ratchet или членство',
      );
      expect(
        base64Encode(
          PublishMlsRequest(
            channelId: 'private',
            requestId: accepted.values.last.requestId,
            kind: 'application',
            expectedEpoch: accepted.values.last.epoch,
            ciphertext: accepted.values.last.ciphertext,
          ).writeToBuffer(),
        ),
        ciphertext,
      );
    },
  );
  test(
    'Мутации подтверждений и коды ошибок не меняют snapshot и outbox',
    () async {
      final store = await local(1, MemoryMlsStorage());
      final target = _Server();
      final proxy = RpcFaultProxy(target);
      final client = MlsClient(
        local: store,
        connection: proxy,
        options: () async => const RpcOptions(),
      );
      target.respond = (request) {
        if (request is RegisterMlsDeviceRequest) {
          return RegisterMlsDeviceResponse();
        }
        if (request is CreateChannelRequest) return CreateChannelResponse();
        if (request is ListMlsEnvelopesRequest) {
          return ListMlsEnvelopesResponse(nextSequence: request.afterSequence);
        }
        if (request is ListMlsDevicesRequest) {
          return ListMlsDevicesResponse(
            devices: [MlsDevice(grantId: 'grant-1')],
          );
        }
        final publish = request as PublishMlsRequest;
        return PublishMlsResponse(
          envelope: MlsEnvelope(
            sequence: Int64.ONE,
            epoch: publish.expectedEpoch,
            kind: publish.kind,
            requestId: publish.requestId,
            ciphertext: publish.ciphertext,
            authorGrantId: 'grant-1',
            authorId: 'participant-1',
          ),
        );
      };
      await client.createChannel('private', 'Закрытый');
      final group = base64Decode(
        ((await store.read())['channels'] as Map)['private']['group_id']
            as String,
      );
      final mutations = <void Function(MlsEnvelope)>[
        (e) => e.sequence = Int64.ZERO,
        (e) => e.epoch = Int64(10),
        (e) => e.kind = 'transfer',
        (e) => e.requestId = [1],
        (e) => e.ciphertext = [],
        (e) => e.authorId = 'другой',
        (e) => e.authorGrantId = 'другой',
        (e) => e.addedGrantId = 'другой',
        (e) => e.removedGrantId = 'другой',
        (e) => e.newManagerGrantId = 'другой',
        (e) => e.welcome = [1],
      ];
      void corrupt(void Function(MlsEnvelope) mutation) {
        proxy.mutate = (_, response) {
          if (response is! PublishMlsResponse) return response;
          final copy = response.deepCopy();
          mutation(copy.envelope);
          return copy;
        };
      }

      corrupt(mutations.first);
      await expectLater(
        client.send('private', 'Не потерять'),
        throwsStateError,
      );
      final before = jsonEncode(await store.read());
      for (final mutation in mutations) {
        corrupt(mutation);
        await expectLater(client.refresh('private', group), throwsStateError);
        expect(jsonEncode(await store.read()), before);
      }
      for (final code in [
        StatusCode.aborted,
        StatusCode.permissionDenied,
        StatusCode.failedPrecondition,
        StatusCode.notFound,
        StatusCode.unavailable,
      ]) {
        proxy.mutate = (_, response) {
          if (response is PublishMlsResponse) {
            throw GrpcError.custom(code, 'Подмена');
          }
          return response;
        };
        try {
          await client.refresh('private', group);
        } on GrpcError {
          /* Очередь должна сохраниться. */
        }
        expect(jsonEncode(await store.read()), before);
      }
    },
  );
  test('Ложное подтверждение не теряет outbox; подмена собственного echo отклоняется', () async {
    final store = await local(1, MemoryMlsStorage());
    final server = _Server();
    final client = MlsClient(
      local: store,
      connection: server,
      options: () async => const RpcOptions(),
    );
    MlsEnvelope? accepted;
    var corruptAck = true;
    var corruptEcho = false;
    server.respond = (request) {
      if (request is RegisterMlsDeviceRequest) {
        return RegisterMlsDeviceResponse();
      }
      if (request is CreateChannelRequest) return CreateChannelResponse();
      if (request is ListMlsEnvelopesRequest) {
        if (accepted == null) return ListMlsEnvelopesResponse();
        if (request.afterSequence >= Int64.ONE) {
          return ListMlsEnvelopesResponse(nextSequence: request.afterSequence);
        }
        final echo = accepted!.deepCopy();
        if (corruptEcho) echo.ciphertext = [99];
        return ListMlsEnvelopesResponse(
          envelopes: [echo],
          nextSequence: echo.sequence,
        );
      }
      if (request is ListMlsDevicesRequest) {
        return ListMlsDevicesResponse(
          devices: [MlsDevice(grantId: store.scope['grant_id'] as String)],
        );
      }
      final publish = request as PublishMlsRequest;
      accepted ??= MlsEnvelope(
        sequence: Int64.ONE,
        epoch: publish.expectedEpoch,
        kind: publish.kind,
        requestId: publish.requestId,
        ciphertext: publish.ciphertext,
        authorGrantId: store.scope['grant_id'] as String,
        authorId: store.scope['principal_id'] as String,
      );
      final reply = accepted!.deepCopy();
      if (corruptAck) reply.requestId = List.filled(16, 99);
      return PublishMlsResponse(envelope: reply);
    };
    await client.createChannel('private', 'Закрытый');
    final saved = ((await store.read())['channels'] as Map)['private'] as Map;
    final group = base64Decode(saved['group_id'] as String);
    await expectLater(client.send('private', 'Секрет'), throwsStateError);
    final before = await store.read();
    final pending = (before['channels'] as Map)['private'] as Map;
    expect((pending['outbox'] as List), hasLength(1));
    expect(pending['messages'], isEmpty);

    corruptAck = false;
    corruptEcho = true;
    await expectLater(
      client.refresh('private', group),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'Причина отказа',
          contains('неизвестный пакет'),
        ),
      ),
    );
    var channel = ((await store.read())['channels'] as Map)['private'] as Map;
    expect(channel['cursor'], 0);
    expect(channel['messages'], hasLength(1));
    expect(channel['outbox'], isEmpty);

    corruptEcho = false;
    await client.refresh('private', group);
    channel = ((await store.read())['channels'] as Map)['private'] as Map;
    expect(channel['cursor'], 1);
    expect(channel['messages'], hasLength(1));
    expect(channel['receipts'], isEmpty);
  });
}
