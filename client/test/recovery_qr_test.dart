import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:space_client/src/recovery_qr.dart';

void main() {
  test('Плотные QR с разными масками читаются без эвристических сбоев', () {
    final random = Random(7);
    for (var i = 0; i < 12; i++) {
      final packet = jsonEncode({
        'v': 1,
        'kind': 'space-recovery-card',
        'ciphertext': base64Url.encode(
          List.generate(1000 + i * 13, (_) => random.nextInt(256)),
        ),
      });
      expect(cardFromArtifact(recoveryPng(packet)), packet);
    }
  });
  test(
    'QR PNG читается после поворота и уменьшения; опасные размеры отклоняются',
    () {
      final packet = jsonEncode({
        'v': 1,
        'kind': 'space-recovery-card',
        'kdf': 'PBKDF2-SHA256',
        'iterations': 600000,
        'salt': 'A' * 22,
        'nonce': 'B' * 16,
        'ciphertext': 'C' * 650,
      });
      final png = recoveryPng(packet);
      expect(cardFromArtifact(png), packet);
      final decoded = img.decodePng(png)!;
      expect(
        cardFromArtifact(img.encodePng(img.copyRotate(decoded, angle: 90))),
        packet,
      );
      expect(
        cardFromArtifact(
          img.encodePng(
            img.copyResize(
              decoded,
              width: decoded.width ~/ 2,
              height: decoded.height ~/ 2,
            ),
          ),
        ),
        packet,
      );
      final bomb = Uint8List.fromList(png);
      ByteData.sublistView(bomb).setUint32(16, 100000);
      expect(() => cardFromArtifact(bomb), throwsFormatException);
      expect(() => recoveryPng('x' * 4000), throwsFormatException);
      expect(
        () => cardFromArtifact(img.encodePng(img.Image(width: 80, height: 80))),
        throwsFormatException,
      );
    },
  );
}
