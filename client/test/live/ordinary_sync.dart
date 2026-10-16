import 'dart:async';
import 'dart:io';

import 'package:connectrpc/connect.dart' as connect;
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/pairing.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/src/rpc_connection.dart';

import '../channels_test.dart' show MemoryHistory, MemoryPositions;
import '../chat_history_test.dart' show HistoryKeys;
import '../support/rpc_fault_proxy.dart';

const _backlogCount = 105;

class _Vault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async => record = value;
}

class _Network extends Discovery {
  _Network(Discovery source)
    : super(
        source.origin,
        source.serverId,
        source.publicKey,
        connectOrigin: source.connectOrigin,
        endpoint: source.endpoint,
        tlsFingerprint: source.tlsFingerprint,
        dialHost: source.dialHost,
        announcement: source.announcement,
      );
  bool offline = false, loseAck = false, expireOnce = false;
  final keys = <String>[];
  final cuts = <void Function()>[];

  void disconnect() {
    offline = true;
    for (final cut in cuts.toList()) {
      cut();
    }
  }

  @override
  RpcConnection openConnection({String setupCode = ''}) {
    final rpc = _NetworkRpc(super.openConnection(setupCode: setupCode), this);
    rpc.beforeRequest = (request) {
      if (request is CreateContentRequest) {
        keys.add(request.idempotencyKey);
        if (expireOnce) {
          expireOnce = false;
          throw const GrpcError.unauthenticated('Сессия истекла');
        }
      }
      if (offline) throw const GrpcError.unavailable('Сеть отключена');
    };
    rpc.mutate = (method, response) {
      if (loseAck && method == 'CreateContentRequest') {
        throw const HttpException('Ответ потерян после записи');
      }
      return response;
    };
    return rpc;
  }
}

class _NetworkRpc extends RpcFaultProxy {
  _NetworkRpc(super.target, this.network);
  final _Network network;
  @override
  RpcStream<O> server<I extends GeneratedMessage, O extends GeneratedMessage>(
    connect.Spec<I, O> spec,
    I request, {
    RpcOptions? options,
  }) {
    if (network.offline) {
      return RpcStream(
        Stream.error(const GrpcError.unavailable()),
        () async {},
      );
    }
    final source = super.server(spec, request, options: options);
    final output = StreamController<O>();
    StreamSubscription<O>? subscription;
    void cut() {
      if (output.isClosed) return;
      output.addError(const GrpcError.unavailable('Соединение оборвано'));
      unawaited(output.close());
    }

    Future<void> cancel() async {
      network.cuts.remove(cut);
      await source.cancel();
      try {
        await subscription?.cancel();
      } on GrpcError catch (error) {
        if (error.code != StatusCode.cancelled) rethrow;
      } on HttpException {
        // Прерванный тестом HTTP-ответ уже закрыт.
      }
    }

    output.onListen = () {
      network.cuts.add(cut);
      subscription = source.listen(
        (value) {
          if (!output.isClosed) output.add(value);
        },
        onError: (Object error) {
          if (!output.isClosed) output.addError(error);
        },
        onDone: () {
          if (!output.isClosed) unawaited(output.close());
        },
      );
    };
    output.onCancel = cancel;
    return RpcStream(output.stream, cancel);
  }
}

Future<void> _wait(bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 20));
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Два устройства не синхронизировались');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

class _Device {
  _Device(this.vault, this.network, this.directory);
  final IdentityVault vault;
  final _Network network;
  final Directory directory;
  final keys = HistoryKeys();
  final history = MemoryHistory();
  final positions = MemoryPositions();
  DateTime clock = DateTime.now();
  ChatController? chat;
  LocalChatOutbox get store =>
      LocalChatOutbox(storage: keys, directory: () async => directory);

  Future<void> start({bool connected = true}) async {
    chat = ChatController(
      vault,
      outboxStore: store,
      historyStore: history,
      positions: positions,
      now: () => clock,
      retryDelay: (_) => const Duration(milliseconds: 80),
    )..preview = network;
    await chat!.connect();
    expect(chat!.connected, connected, reason: chat!.error);
  }

  Future<void> stop() async {
    await chat?.close();
    chat = null;
  }
}

Future<_Vault> _pair(Discovery server, SpaceSession owner) async {
  final pairing = await PendingPairing.start(server);
  try {
    await owner.preparePairing(pairing.request.pairing);
    await pairing.poll();
    await owner.approvePairing(pairing.request.pairing);
    final approved = await pairing.poll();
    final record = await pairing.verifiedRecord(approved);
    final vault = _Vault();
    final session = await SpaceSession.connect(
      server,
      vault,
      restoredRecord: record,
      pairingId: pairing.request.pairing.id,
    );
    pairing.claimed = true;
    expect(session.principalId, owner.principalId);
    expect(session.currentGrantId, isNot(owner.currentGrantId));
    await session.close();
    return vault;
  } finally {
    await pairing.close();
  }
}

Future<void> verifyOrdinarySync(
  Discovery server,
  IdentityVault vault,
  SpaceSession owner,
) async {
  final root = await Directory.systemTemp.createTemp('space-two-devices-');
  final secondVault = await _pair(server, owner);
  final a = _Device(vault, _Network(server), Directory('${root.path}/a'));
  final b = _Device(secondVault, _Network(server), Directory('${root.path}/b'));
  final prefix = newRequestKey();
  try {
    await Future.wait([a.start(), b.start()]);
    await _concurrentMessages(a, b, prefix);
    await _restartOffline(a, b, prefix);
    // Сессия отклонена между проверкой срока и CreateContent: вход и тот же ключ.
    a.network.expireOnce = true;
    expect(await a.chat!.send('$prefix-session'), true);
    await _wait(() => a.chat!.pendingMessages.isEmpty);
    await _wait(() => b.chat!.messages.any((m) => m.text == '$prefix-session'));
    expect(
      a.network.keys.skip(a.network.keys.length - 2).toSet(),
      hasLength(1),
    );
    await _assertConverged(a, b, prefix, 15 + _backlogCount);
    await _explicitDisconnect(a, b, prefix);
  } finally {
    await Future.wait([a.stop(), b.stop()]);
    await root.delete(recursive: true);
  }
}

Future<void> _concurrentMessages(_Device a, _Device b, String prefix) async {
  for (var i = 0; i < 5; i++) {
    final text = '$prefix-same-$i';
    expect(await Future.wait([a.chat!.send(text), b.chat!.send(text)]), [
      true,
      true,
    ]);
  }
  await _assertConverged(a, b, prefix, 10);
  expect(a.network.keys.toSet().intersection(b.network.keys.toSet()), isEmpty);
}

Future<void> _restartOffline(_Device a, _Device b, String prefix) async {
  a.network.loseAck = true;
  expect(await a.chat!.send('$prefix-lost'), true);
  await _wait(() => a.chat!.sendStatus == MessageSendStatus.unconfirmed);
  a.network.disconnect();
  await _wait(() => b.chat!.messages.any((m) => m.text == '$prefix-lost'));
  final original = b.chat!.messages.singleWhere(
    (m) => m.text == '$prefix-lost',
  );
  expect(await b.chat!.updateMessage(original, '$prefix-lost-edited'), true);
  a.clock = DateTime.now().subtract(const Duration(days: 45));
  expect(await a.chat!.send('$prefix-offline-1'), true);
  expect(await a.chat!.send('$prefix-offline-2'), true);
  await _wait(() => a.chat!.pendingMessages.length == 3);
  final pending = a.chat!.pendingMessages.map((m) => m.key).toList();
  final scope = OutboxScope(
    a.network.origin.toString(),
    a.network.serverId,
    a.chat!.principalId,
    (await a.vault.load(a.network.origin.toString()))!.grantId,
  );
  await a.stop();
  expect((await a.store.read(scope)).map((m) => m.key), pending);
  await a.start(connected: false);
  expect(a.chat!.pendingMessages.map((m) => m.key), pending);
  expect(a.chat!.canQueue, true);
  expect(await b.chat!.send('$prefix-while-away'), true);
  await _wait(() => b.chat!.pendingMessages.isEmpty);
  await _buildBacklog(b, prefix);
  a.clock = DateTime.now();
  a.network
    ..offline = false
    ..loseAck = false;
  await _wait(() => a.chat!.connected);
  await _assertConverged(a, b, prefix, 14 + _backlogCount);
  for (final key in pending) {
    expect(a.network.keys, contains(key));
  }
  expect(a.chat!.messages.where((m) => m.text == '$prefix-lost'), isEmpty);
  final edited = a.chat!.messages.singleWhere(
    (m) => m.text == '$prefix-lost-edited',
  );
  expect(edited.id, original.id);
  expect(edited.revision.toInt(), 2);
}

Future<void> _assertConverged(
  _Device a,
  _Device b,
  String prefix,
  int count,
) async {
  await _wait(
    () =>
        a.chat!.pendingMessages.isEmpty &&
        b.chat!.pendingMessages.isEmpty &&
        a.chat!.messages.where((m) => m.text.startsWith(prefix)).length ==
            count &&
        b.chat!.messages.where((m) => m.text.startsWith(prefix)).length ==
            count &&
        _versions(a, prefix) == _versions(b, prefix),
  );
  final left = a.chat!.messages
      .where((m) => m.text.startsWith(prefix))
      .toList();
  final right = b.chat!.messages
      .where((m) => m.text.startsWith(prefix))
      .toList();
  expect(left.map((m) => m.id), right.map((m) => m.id));
  expect(left.map((m) => m.sequence.toInt()).toSet(), hasLength(count));
  expect(left.map((m) => m.authorId).toSet(), hasLength(1));
}

String _versions(_Device device, String prefix) => device.chat!.messages
    .where((m) => m.text.startsWith(prefix))
    .map((m) => '${m.id}/${m.revision}/${m.text}/${m.deleted}')
    .join('\n');

Future<void> _explicitDisconnect(_Device a, _Device b, String prefix) async {
  a.network.disconnect();
  expect(await a.chat!.send('$prefix-explicit-stop'), true);
  await _wait(() => a.chat!.sendStatus == MessageSendStatus.unconfirmed);
  await a.stop();
  await a.start(connected: false);
  await a.chat!.disconnect();
  final requests = a.network.keys.length;
  a.network.offline = false;
  await Future<void>.delayed(const Duration(milliseconds: 250));
  expect(a.chat!.connected, false);
  expect(a.network.keys.length, requests);
  expect(a.chat!.pendingMessages, hasLength(1));
  a.chat!.preview = a.network;
  await a.chat!.connect();
  await _assertConverged(a, b, prefix, 16 + _backlogCount);
}

Future<void> _buildBacklog(_Device device, String prefix) async {
  // Больше одной страницы истории, но без превышения размера очереди.
  for (var i = 0; i < _backlogCount; i++) {
    expect(await device.chat!.send('$prefix-backlog-$i'), true);
    if (i % 5 == 4) await _wait(() => device.chat!.pendingMessages.isEmpty);
  }
  await _wait(() => device.chat!.pendingMessages.isEmpty);
}
