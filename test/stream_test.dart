import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';

class Vault implements IdentityVault {
  @override
  Future<DeviceRecord?> load(String origin) async => null;
  @override
  Future<void> save(DeviceRecord record) async {}
}

class Session implements LiveSession {
  final streams = <StreamController<SubscribeResponse>>[];
  final cursors = <String>[];
  bool revoked = false, closed = false;
  int logins = 0;
  @override
  String get principalId => 'u_test';
  @override
  Future<List<Content>> messages() async => [];
  @override
  Future<Content> send(String text, String key) async =>
      Content(id: key, text: text);
  @override
  Future<void> login() async {
    logins++;
    if (revoked) throw const GrpcError.unauthenticated();
  }

  @override
  Stream<SubscribeResponse> subscribe(String after) {
    cursors.add(after);
    final stream = StreamController<SubscribeResponse>();
    streams.add(stream);
    return stream.stream;
  }

  @override
  Future<void> revoke() async {
    revoked = true;
  }

  @override
  Future<void> close() async {
    closed = true;
    for (final stream in streams) {
      unawaited(stream.close());
    }
  }
}

Future<void> settle() async {
  await Future<void>.delayed(const Duration(milliseconds: 20));
}

SubscribeResponse event(String cursor, String id) => SubscribeResponse(
  cursor: cursor,
  event: Event(
    cursor: cursor,
    type: 'content.created',
    content: Content(id: id, channelId: 'general', text: id),
  ),
);
Future<ChatController> connect(Session session) async {
  final controller = ChatController(
    Vault(),
    openSession: (_, _) async => session,
    retryDelay: (_) => const Duration(milliseconds: 5),
  );
  controller.preview = Discovery(
    localOrigin('http://127.0.0.1:8080'),
    'srv_test',
    List.filled(32, 1),
    9090,
  );
  await controller.connect();
  await settle();
  return controller;
}

void main() {
  test(
    'Подписка возобновляется с применённого курсора и не дублирует сообщения',
    () async {
      final session = Session();
      final controller = await connect(session);
      session.streams[0].add(event('event-1', 'message-1'));
      await settle();
      session.streams[0].addError(const GrpcError.unavailable());
      await settle();
      expect(session.cursors, ['', 'event-1']);
      session.streams[1].add(event('event-1', 'message-1'));
      session.streams[1].add(event('event-2', 'message-2'));
      await settle();
      expect(controller.messages.length, 2);
      expect(controller.cursor, 'event-2');
      expect(controller.reconnecting, false);
      await controller.disconnect();
      await settle();
      expect(session.closed, true);
      final count = session.cursors.length;
      await settle();
      expect(session.cursors.length, count);
      controller.dispose();
    },
  );
  test(
    'Отозванное устройство останавливается без регистрации нового grant',
    () async {
      final session = Session();
      final controller = await connect(session);
      session.revoked = true;
      session.streams[0].addError(const GrpcError.unauthenticated());
      await settle();
      expect(session.logins, 1);
      expect(controller.connected, false);
      expect(session.cursors.length, 1);
      controller.dispose();
    },
  );
  test('Некорректный курсор heartbeat не применяется', () async {
    final session = Session();
    final controller = await connect(session);
    session.streams[0].add(
      SubscribeResponse(heartbeat: true, cursor: 'untrusted'),
    );
    await settle();
    expect(controller.connected, false);
    expect(controller.cursor, '');
    controller.dispose();
  });
}
