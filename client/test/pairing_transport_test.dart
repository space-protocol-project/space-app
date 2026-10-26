import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/pairing.dart';

class PairingServer {
  PairingServer(this.http) {
    http.listen((request) { unawaited(handle(request)); });
  }
  final HttpServer http;
  int cancellations = 0;
  String cancelledToken = '';
  final pollStarted = Completer<void>(), pollResponse = Completer<void>();
  Discovery get discovery => Discovery(
    Uri.parse('http://127.0.0.1:${http.port}'), 'srv_${'a' * 32}', List.filled(32, 1));
  Future<void> handle(HttpRequest request) async {
    final bytes = await request.fold<List<int>>([], (all, part) => all..addAll(part));
    request.response.headers.contentType = ContentType('application', 'proto');
    try {
      if (request.uri.path.endsWith('/CreatePairing')) {
        final input = CreatePairingRequest.fromBuffer(bytes);
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        request.response.add(CreatePairingResponse(
          code: 'pc_${'b' * 43}', pollToken: 'pt_${'c' * 43}',
          pairing: Pairing(id: 'pr_${'d' * 43}', state: 'pending',
            publicKey: input.publicKey, administrative: input.administrative,
            createdAt: Int64(now), expiresAt: Int64(now + 300))).writeToBuffer());
      } else if (request.uri.path.endsWith('/CancelPairing')) {
        cancellations++;
        cancelledToken = CancelPairingRequest.fromBuffer(bytes).pollToken;
        request.response.add(CancelPairingResponse().writeToBuffer());
      } else {
        pollStarted.complete();
        await pollResponse.future;
        request.response.add(PollPairingResponse(rootPublicKey: List.filled(32, 9)).writeToBuffer());
      }
      await request.response.close();
    } on HttpException {
      // Закрытие клиента во время ответа ожидаемо в проверке отмены.
    } on SocketException {
      // Прерванный запрос больше не принадлежит действующему сопряжению.
    }
  }
  Future<void> close() async {
    if (!pollResponse.isCompleted) pollResponse.complete();
    await http.close(force: true);
  }
}

void main() {
  late PairingServer server;
  setUp(() async { server = PairingServer(await HttpServer.bind(InternetAddress.loopbackIPv4, 0)); });
  tearDown(() => server.close());
  test('Повторное закрытие отправляет только одну отмену и забывает poll token', () async {
    final pending = await PendingPairing.start(server.discovery);
    final token = pending.request.pollToken;
    await Future.wait([pending.close(), pending.close()]);
    expect(server.cancellations, 1);
    expect(server.cancelledToken, token);
    expect(pending.request.pollToken, isEmpty);
    await expectLater(pending.poll(), throwsStateError);
  });
  test('Закрытие после claim не отменяет рабочий grant', () async {
    final pending = await PendingPairing.start(server.discovery);
    pending.claimed = true;
    await pending.close();
    expect(server.cancellations, 0);
    expect(pending.request.pollToken, isEmpty);
  });
  test('Ответ poll после закрытия не меняет предложенный root', () async {
    final pending = await PendingPairing.start(server.discovery);
    final rejected = expectLater(pending.poll(), throwsA(anything));
    await server.pollStarted.future;
    await pending.close();
    server.pollResponse.complete();
    await rejected;
    expect(pending.proposedRoot, isNull);
  });
}
