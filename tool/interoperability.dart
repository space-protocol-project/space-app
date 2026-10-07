import 'dart:io';

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
    await session.revoke();
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
      'Dart/Go: register, login, message, retry, reconnect, events, revoke — успешно.',
    );
  } finally {
    await session.close();
  }
}
