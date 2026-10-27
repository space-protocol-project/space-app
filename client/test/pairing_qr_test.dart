import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/pairing_qr.dart';
import 'package:space_client/src/space_link_qr.dart';

Discovery testServer() =>
    Discovery(Uri.parse('https://example.org'), 'srv_test', List.filled(32, 1));
CreatePairingResponse testRequest() => CreatePairingResponse(
  code: 'pc_${'b' * 43}',
  pollToken: 'pt_${'c' * 43}',
  pairing: Pairing(
    id: 'pr_${'d' * 43}',
    state: 'pending',
    publicKey: List.filled(32, 2),
    expiresAt: Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000 + 300),
  ),
);

void main() {
  test('Публичный QR проходит PNG и не содержит секрет получения', () {
    final request = testRequest(), server = testServer();
    final text = PairingQr.request(server, request).encode();
    final decoded = utf8.decode(
      base64Url.decode(text.substring(pairingQrPrefix.length)),
    );
    expect(decoded, isNot(contains(request.pollToken)));
    expect(decoded, isNot(contains('seed')));
    final png = pairingPng(text);
    expect(pairingQrFromImage(png), text);
    expect(spaceLinkFromImage(png), isNull);
    PairingQr.parse(text)
      ..checkServer(server)
      ..checkPair(request.pairing);
  });

  test(
    'Подмена пространства, ключа сервера и параметров запроса отвергается',
    () {
      final server = testServer(), request = testRequest();
      final qr = PairingQr.request(server, request);
      expect(
        () =>
            qr.checkServer(Discovery(server.origin, 'other', server.publicKey)),
        throwsFormatException,
      );
      expect(
        () => qr.checkServer(
          Discovery(server.origin, server.serverId, List.filled(32, 9)),
        ),
        throwsFormatException,
      );
      expect(
        () => qr.checkServer(
          Discovery(
            Uri.parse('https://other.org'),
            server.serverId,
            server.publicKey,
          ),
        ),
        throwsFormatException,
      );
      for (final pair in [
        request.pairing.deepCopy()..id = 'other',
        request.pairing.deepCopy()..publicKey = List.filled(32, 8),
        request.pairing.deepCopy()..administrative = true,
        request.pairing.deepCopy()..expiresAt = Int64(1),
      ]) {
        expect(() => qr.checkPair(pair), throwsFormatException);
      }
    },
  );

  test('Неверный формат, срок и чрезмерный размер отвергаются', () {
    final server = testServer();
    for (final text in [
      '',
      'pc_${'a' * 43}',
      'space-recovery:v1:aaa',
      '$pairingQrPrefix@@',
      '$pairingQrPrefix${'a' * 2049}',
      '$pairingQrPrefix${base64Url.encode(utf8.encode('{"code":3}'))}',
    ]) {
      expect(() => PairingQr.parse(text), throwsA(anything));
    }
    for (final offset in [-1, 306]) {
      final request = testRequest()
        ..pairing.expiresAt = Int64(
          DateTime.now().millisecondsSinceEpoch ~/ 1000 + offset,
        );
      expect(
        () => PairingQr.parse(PairingQr.request(server, request).encode()),
        throwsFormatException,
      );
    }
  });
  test('QR читается из JPEG с полями и поворотом', () {
    final text = PairingQr.request(testServer(), testRequest()).encode();
    final qr = img.decodePng(pairingPng(text))!;
    final frame = img.Image(width: qr.width + 160, height: qr.height + 160, numChannels: 3);
    img.fill(frame, color: img.ColorRgb8(220, 220, 220));
    img.compositeImage(frame, qr, dstX: 80, dstY: 80);
    expect(pairingQrFromImage(img.encodeJpg(frame, quality: 95)), text);
    expect(pairingQrFromImage(img.encodePng(img.copyRotate(frame, angle: 90))), text);
  });

}
