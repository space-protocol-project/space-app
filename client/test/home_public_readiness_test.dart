import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/rpc_clients.dart';

import '../tool/home_server_drill.dart' show waitForPublicHome;

void main() {
  test(
    'Ожидание публичного входа переживает временные 503 после bootstrap',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      var requests = 0;
      server.listen((request) async {
        requests++;
        await request.drain<void>();
        if (requests < 3) {
          request.response.statusCode = 503;
        } else {
          request.response.headers.contentType = ContentType(
            'application',
            'proto',
          );
          request.response.add(
            GetSetupStatusResponse(initialized: true).writeToBuffer(),
          );
        }
        await request.response.close();
      });
      try {
        await waitForPublicHome(
          Discovery(Uri.parse('http://127.0.0.1:${server.port}'), 'test', []),
        );
        expect(requests, 3);
      } finally {
        await server.close(force: true);
      }
    },
  );
}
