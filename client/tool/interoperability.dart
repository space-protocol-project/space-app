import 'dart:io';
import 'dart:async';

import 'package:grpc/grpc.dart';

import 'package:space_client/src/core.dart';

// Только CI: пользовательские ключи живут в памяти процесса теста.
class TestVault implements IdentityVault {
  Map<String, dynamic>? value;
  @override
  Future<DeviceRecord?> load(String origin) async =>
      value == null ? null : DeviceRecord.fromJson(value!);
  @override
  Future<void> save(DeviceRecord record) async {
    value = record.toJson();
  }
}

Future<void> main(List<String> arguments) async {
  final server = await discover(
    arguments.isEmpty ? 'http://127.0.0.1:18080' : arguments.single,
  );
  final vault = TestVault();
  var session = await SpaceSession.connect(server, vault);
  final principal = session.principalId;
  final key = newRequestKey();
  final original = await session.send('Сообщение из Dart gRPC клиента', key);
  final repeated = await session.send('Сообщение из Dart gRPC клиента', key);
  if (original.id != repeated.id || original.authorId != principal) {
    throw StateError('Idempotency или автор не совпали');
  }
  await session.close();
  session = await SpaceSession.connect(server, vault);
  try {
    if (session.principalId != principal ||
        !(await session.messages()).any((c) => c.id == original.id)) {
      throw StateError('Identity или сообщение потерялись');
    }
    final events = await session.events('');
    if (!events.events.any((e) => e.content.id == original.id)) {
      throw StateError('Событие не найдено');
    }
    var iterator = StreamIterator(session.subscribe(events.nextCursor));
    if (!await iterator.moveNext() || !iterator.current.heartbeat) {
      throw StateError('Нет первого heartbeat');
    }
    final streamed = await session.send(
      'Сообщение для живой подписки',
      newRequestKey(),
    );
    if (!await iterator.moveNext() ||
        iterator.current.event.content.id != streamed.id) {
      throw StateError('Live stream не получил сообщение');
    }
    final cursor = iterator.current.cursor;
    await iterator.cancel();
    final missed = await session.send(
      'Сообщение во время отключения',
      newRequestKey(),
    );
    iterator = StreamIterator(session.subscribe(cursor));
    if (!await iterator.moveNext() || !iterator.current.heartbeat) {
      throw StateError('Нет resume heartbeat');
    }
    if (!await iterator.moveNext() ||
        iterator.current.event.content.id != missed.id) {
      throw StateError('Replay не получил пропущенное сообщение');
    }
    await session.revoke();
    var streamRefused = false;
    try {
      await iterator.moveNext();
    } on GrpcError catch (error) {
      if (error.code != StatusCode.unauthenticated) rethrow;
      streamRefused = true;
    } finally {
      await iterator.cancel();
    }
    if (!streamRefused) {
      throw StateError('Активная подписка не закрылась после revoke');
    }
    var refused = false;
    try {
      await session.login();
    } on GrpcError catch (error) {
      if (error.code != StatusCode.unauthenticated) {
        rethrow;
      }
      refused = true;
    }
    if (!refused) throw StateError('Отзыв не сработал');
    stdout.writeln(
      'Dart/Go: register, login, message, retry, stream, replay, revoke — успешно.',
    );
  } finally {
    await session.close();
  }
}
