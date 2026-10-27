import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/pairing.dart';
import 'package:space_client/src/pairing_cubit.dart';

import 'pairing_transport_test.dart' show PairingServer;

class PairingVault implements IdentityVault {
  @override
  Future<DeviceRecord?> load(String origin) async => null;
  @override
  Future<void> save(DeviceRecord record) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PairingServer server;
  late ChatController controller;
  setUp(() async {
    server = PairingServer(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
    );
    controller = ChatController(PairingVault())..preview = server.discovery;
  });
  tearDown(() async {
    await controller.close();
    await server.close();
  });

  test('Запрос публикует QR и отменяется один раз', () async {
    final cubit = PairingCubit(controller);
    await cubit.start();
    expect(cubit.state.code, startsWith('pc_'));
    expect(cubit.state.qr, isNotEmpty);
    await cubit.cancel();
    await cubit.close();
    expect(server.cancellations, 1);
    expect(cubit.state.code, isEmpty);
    expect(cubit.state.qr, isNull);
  });

  test('Поздний start после отмены не возвращает запрос на экран', () async {
    final result = Completer<PendingPairing>();
    final cubit = PairingCubit(controller, create: (_) => result.future);
    final starting = cubit.start();
    await cubit.cancel();
    result.complete(await PendingPairing.start(server.discovery));
    await starting;
    expect(cubit.state.code, isEmpty);
    expect(server.cancellations, 1);
    await cubit.close();
  });

  test('Закрытый экран освобождает поздно созданный ресурс', () async {
    final result = Completer<PendingPairing>();
    final cubit = PairingCubit(controller, create: (_) => result.future);
    final starting = cubit.start();
    await cubit.close();
    result.complete(await PendingPairing.start(server.discovery));
    await starting;
    expect(server.cancellations, 1);
  });

  test(
    'Истёкший запрос скрывает QR и не принимает старое подтверждение',
    () async {
      late PendingPairing pending;
      final cubit = PairingCubit(
        controller,
        create: (server) async => pending = await PendingPairing.start(server),
      );
      await cubit.start();
      final revision = cubit.revision;
      pending.request.pairing.expiresAt = Int64(1);
      await cubit.poll();
      expect(cubit.state.issue, PairingIssue.expired);
      expect(cubit.state.qr, isNull);
      expect(await cubit.accept(revision), isFalse);
      await cubit.close();
    },
  );

  test('Ошибка создания допускает повторный запуск', () async {
    var calls = 0;
    final cubit = PairingCubit(
      controller,
      create: (server) {
        if (calls++ == 0) throw StateError('offline');
        return PendingPairing.start(server);
      },
    );
    await cubit.start();
    expect(cubit.state.issue, PairingIssue.start);
    await cubit.start();
    expect(cubit.state.code, isNotEmpty);
    await cubit.close();
  });
}
