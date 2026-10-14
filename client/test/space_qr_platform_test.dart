import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:qr/qr.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/space_link_qr.dart';
import 'package:space_client/src/platform_capabilities.dart';

Uint8List linkImage(String text, {bool jpeg = false}) {
  final matrix = QrImage(
    QrCode(
      payload: QrPayload.fromTypedData(Uint8List.fromList(utf8.encode(text))),
      errorCorrectLevel: QrErrorCorrectLevel.medium,
    ),
  );
  const cell = 6;
  final size = (matrix.moduleCount + 8) * cell;
  final image = img.Image(width: size, height: size);
  img.fill(image, color: img.ColorRgb8(255, 255, 255));
  for (var y = 0; y < matrix.moduleCount; y++) {
    for (var x = 0; x < matrix.moduleCount; x++) {
      if (!matrix.isDark(y, x)) continue;
      img.fillRect(
        image,
        x1: (x + 4) * cell,
        y1: (y + 4) * cell,
        x2: (x + 5) * cell - 1,
        y2: (y + 5) * cell - 1,
        color: img.ColorRgb8(0, 0, 0),
      );
    }
  }
  return jpeg ? img.encodeJpg(image, quality: 95) : img.encodePng(image);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('QR находится на крупном фото среди других элементов', () {
    final link = 'https://203.0.113.10:8443#tls=${'b' * 64}';
    final full = img.decodePng(linkImage(link))!;
    final qr = img.copyResize(full, width: full.width ~/ 2);
    final photo = img.Image(width: 900, height: 4000);
    img.fill(photo, color: img.ColorRgb8(255, 255, 255));
    img.fillRect(
      photo,
      x1: 0,
      y1: 10,
      x2: 899,
      y2: 40,
      color: img.ColorRgb8(30, 30, 30),
    );
    img.compositeImage(photo, qr, dstX: 330, dstY: 1200);
    expect(spaceLinkFromImage(img.encodeJpg(photo, quality: 92)), link);
  });
  test('QR PNG и JPEG сохраняет приглашение и отпечаток TLS', () {
    final link =
        'https://203.0.113.10:8443#invite=iv_${'a' * 43}&tls=${'b' * 64}';
    for (final jpeg in [false, true]) {
      final decoded = spaceLinkFromImage(linkImage(link, jpeg: jpeg));
      expect(decoded, link);
      final input = parseConnectionInput(decoded!);
      expect(input.invitationToken, 'iv_${'a' * 43}');
      expect(input.tlsFingerprint, 'b' * 64);
    }
  });
  test('QR отвергает чужой текст, секрет карточки и неверный TLS', () {
    for (final text in [
      'not a space',
      'space-recovery:v1:secret',
      'https://server.example#tls=wrong',
      'https://user:password@server.example',
    ]) {
      expect(spaceLinkFromImage(linkImage(text)), isNull);
    }
    expect(spaceLinkFromImage(Uint8List(8)), isNull);
  });
  test('Android и iOS не создают и не читают домашний сервер', () async {
    for (final platform in ['android', 'ios']) {
      expect(supportsHomePlatform(platform), isFalse);
      final home = HomeController(
        hostingEnabled: false,
        directory: () async => throw StateError('Доступ к файлам запрещён'),
      );
      await home.load();
      expect(await home.start('203.0.113.10'), isNull);
      expect(home.running, isFalse);
      await home.close();
    }
    expect(supportsHomePlatform('windows'), isTrue);
    expect(supportsHomePlatform('linux'), isTrue);
    expect(supportsHomePlatform('macos'), isTrue);
  });
}
