import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';

void main() {
  // Без widget binding: нужен настоящий HttpClient, а не заглушка HTTP 400.
  test('Discovery отказывает при недоступном порте', () async {
    final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final port = socket.port;
    await socket.close();
    await expectLater(
      discover('https://127.0.0.1:$port', tlsFingerprint: 'a' * 64),
      throwsA(isA<SocketException>()),
    );
  });
}
