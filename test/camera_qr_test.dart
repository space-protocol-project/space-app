import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:space_client/src/camera_qr.dart';
import 'package:space_client/src/recovery_qr.dart';

void main() {
  test('Кадр камеры: JPEG, поля вокруг QR, поворот и посторонний код', () {
    final packet = jsonEncode({
      'v': 1,
      'kind': 'space-recovery-card',
      'ciphertext': 'A' * 300,
    });
    final qr = img.decodePng(recoveryPng(packet))!;
    final frame = img.Image(
      width: qr.width + 160,
      height: qr.height + 160,
      numChannels: 3,
    );
    img.fill(frame, color: img.ColorRgb8(220, 220, 220));
    img.compositeImage(frame, qr, dstX: 80, dstY: 80);
    expect(cameraCardInWorker(img.encodeJpg(frame, quality: 95)), packet);
    expect(
      cameraCardInWorker(img.encodePng(img.copyRotate(frame, angle: 90))),
      packet,
    );
    expect(cameraCardInWorker(Uint8List.fromList([1, 2, 3])), isNull);
    expect(
      cameraCardInWorker(img.encodePng(img.Image(width: 200, height: 200))),
      isNull,
    );
  });
}
