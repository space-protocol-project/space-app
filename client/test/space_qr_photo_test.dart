import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/space_link_qr.dart';

import '../integration_test/fixtures/space_link.dart';

void main() {
  const photoPath = String.fromEnvironment('SPACE_QR_PHOTO');

  test('Фото экрана сохраняет ссылку, приглашение и TLS', () async {
    final bytes = await File(photoPath).readAsBytes();
    expect(await compute(spaceLinkFromImage, bytes), deviceQrLink);
  }, skip: photoPath.isEmpty);
}
