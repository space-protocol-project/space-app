import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectrpc/protobuf.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/local_failure.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/src/rpc_connection.dart';

final certificateFile = File('test/fixtures/rpc-tls/server.crt');
final keyFile = File('test/fixtures/rpc-tls/server.key');

String fixtureFingerprint([File? certificate]) => crypto.sha256
    .convert(
      base64Decode(
        (certificate ?? certificateFile).readAsStringSync().replaceAll(
          RegExp(r'-----[^-]+-----|\s'),
          '',
        ),
      ),
    )
    .toString();

Future<HttpServer> secureFixture() => HttpServer.bindSecure(
  InternetAddress.loopbackIPv4,
  0,
  SecurityContext()
    ..useCertificateChain(certificateFile.path)
    ..usePrivateKey(keyFile.path),
);

Uint8List envelope(List<int> message, {int flags = 0}) {
  final bytes = Uint8List(message.length + 5);
  bytes[0] = flags;
  ByteData.sublistView(bytes).setUint32(1, message.length);
  bytes.setRange(5, bytes.length, message);
  return bytes;
}

void main() {
  test('Истёкший сертификат отклоняется даже при правильном pin', () async {
    final expired = File('test/fixtures/rpc-tls/expired.crt');
    final context = SecurityContext()
      ..useCertificateChain(expired.path)
      ..usePrivateKey(keyFile.path);
    final server = await HttpServer.bindSecure(
      InternetAddress.loopbackIPv4,
      0,
      context,
    );
    var requests = 0;
    server.listen((request) {
      requests++;
      request.response.close();
    });
    final connection = RpcConnection.connect(
      Uri.parse('https://127.0.0.1:${server.port}'),
      fixtureFingerprint(expired),
    );
    try {
      await expectLater(
        ChannelServiceClient(connection).getManifest(GetManifestRequest()),
        throwsA(isA<HandshakeException>()),
      );
      expect(requests, 0);
    } finally {
      await connection.terminate();
      await server.close(force: true);
    }
  });
  for (final json in [false, true]) {
    test(
      'Настоящий HTTPS: pin, авторизация и ${json ? 'JSON' : 'Protobuf'}',
      () async {
        final server = await secureFixture();
        final origin = Uri.parse('https://127.0.0.1:${server.port}');
        final connection = RpcConnection.connect(
          origin,
          fixtureFingerprint(),
          codec: json ? const JsonCodec() : const ProtoCodec(),
        );
        final received = Completer<void>();
        server.listen((request) async {
          expect(request.uri.path, '/space.v1.ChannelService/GetManifest');
          expect(request.headers.value('authorization'), 'Bearer test-token');
          expect(request.headers.value('accept-encoding'), isNull);
          expect(request.headers.value('connect-timeout-ms'), isNotNull);
          await request.drain<void>();
          final manifest = GetManifestResponse(serverId: 'srv_test');
          request.response.headers.contentType = ContentType.parse(
            json ? 'application/json' : 'application/proto',
          );
          request.response.add(
            json
                ? utf8.encode(jsonEncode(manifest.toProto3Json()))
                : manifest.writeToBuffer(),
          );
          await request.response.close();
          received.complete();
        });
        try {
          final response = await ChannelServiceClient(connection).getManifest(
            GetManifestRequest(),
            options: CallOptions(
              metadata: {'authorization': 'Bearer test-token'},
            ),
          );
          expect(response.serverId, 'srv_test');
          await received.future;
        } finally {
          await connection.terminate();
          await server.close(force: true);
        }
      },
    );
  }

  test('Неверный pin отклоняет даже системно доверенный сертификат до отправки RPC', () async {
    SecurityContext.defaultContext.setTrustedCertificatesBytes(
      certificateFile.readAsBytesSync(),
    );
    final server = await secureFixture();
    var requests = 0;
    server.listen((request) {
      requests++;
      request.response.close();
    });
    final connection = RpcConnection.connect(
      Uri.parse('https://127.0.0.1:${server.port}'),
      '0' * 64,
    );
    try {
      await expectLater(
        ChannelServiceClient(connection).getManifest(
          GetManifestRequest(),
          options: CallOptions(metadata: {'authorization': 'Bearer secret'}),
        ),
        throwsA(isA<HandshakeException>()),
      );
      expect(requests, 0);
    } finally {
      await connection.terminate();
      await server.close(force: true);
    }
  });

  test('Перенаправление не пересылает авторизацию', () async {
    final target = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    var forwarded = 0;
    target.listen((request) {
      forwarded++;
      request.response.close();
    });
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      await request.drain<void>();
      request.response.statusCode = 307;
      request.response.headers.set(
        'location',
        'http://127.0.0.1:${target.port}/space.v1.ChannelService/GetManifest',
      );
      await request.response.close();
    });
    final connection = RpcConnection.connect(
      Uri.parse('http://127.0.0.1:${server.port}'),
      '',
    );
    try {
      await expectLater(
        ChannelServiceClient(connection).getManifest(
          GetManifestRequest(),
          options: CallOptions(metadata: {'authorization': 'Bearer secret'}),
        ),
        throwsA(isA<GrpcError>()),
      );
      expect(forwarded, 0);
    } finally {
      await connection.terminate();
      await server.close(force: true);
      await target.close(force: true);
    }
  });

  test('Deadline и коды ошибок сохраняются при ConnectRPC', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      await request.drain<void>();
      if (request.uri.path.endsWith('GetManifest')) return;
      request.response.statusCode = 403;
      request.response.headers.contentType = ContentType.json;
      request.response.write('{"code":"permission_denied","message":"Отказ"}');
      await request.response.close();
    });
    final connection = RpcConnection.connect(
      Uri.parse('http://127.0.0.1:${server.port}'),
      '',
    );
    try {
      await expectLater(
        ChannelServiceClient(connection).getManifest(
          GetManifestRequest(),
          options: CallOptions(timeout: const Duration(milliseconds: 100)),
        ),
        throwsA(
          isA<GrpcError>().having(
            (e) => e.code,
            'deadline',
            StatusCode.deadlineExceeded,
          ),
        ),
      );
      await expectLater(
        ChannelServiceClient(connection).listChannels(ListChannelsRequest()),
        throwsA(
          isA<GrpcError>().having(
            (e) => e.code,
            'ACL',
            StatusCode.permissionDenied,
          ),
        ),
      );
    } finally {
      await connection.terminate();
      await server.close(force: true);
    }
  });

  test(
    'Отмена останавливает ожидающий поток, соединение закрывает активные RPC',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        await request.drain<void>();
        request.response.headers.contentType = ContentType.parse(
          'application/connect+proto',
        );
        request.response.bufferOutput = false;
        request.response.done.ignore();
        request.response.add(
          envelope(SubscribeResponse(heartbeat: true).writeToBuffer()),
        );
        await request.response.flush();
      });
      final connection = RpcConnection.connect(
        Uri.parse('http://127.0.0.1:${server.port}'),
        '',
      );
      final stream = SyncServiceClient(connection)
          .subscribe(SubscribeRequest(channelId: 'general'));
      final iterator = StreamIterator(stream);
      try {
        expect(await iterator.moveNext(), true);
        expect(iterator.current.heartbeat, true);
        final waiting = iterator.moveNext();
        final assertion = expectLater(
          waiting,
          throwsA(
            isA<GrpcError>().having(
              (e) => e.code,
              'cancel',
              StatusCode.cancelled,
            ),
          ),
        );
        await stream.cancel();
        await assertion.timeout(const Duration(seconds: 1));
        await connection.terminate();
        await expectLater(
          ChannelServiceClient(connection).getManifest(GetManifestRequest()),
          throwsA(isA<GrpcError>()),
        );
      } finally {
        await iterator.cancel();
        await connection.terminate();
        await server.close(force: true);
      }
    },
  );

  test('Discovery выбирает Connect только по известной поддержке, ошибки не включают fallback', () async {
    for (final endpoint in [null, '/', 'https://evil.test/']) {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode({
            'protocol_version': '0.1-experimental',
            'server_id': 'srv_${'a' * 32}',
            'signing_algorithm': 'Ed25519',
            'signing_public_key': base64Url.encode(List.filled(32, 1)),
            'manifest': '/api/v1/manifest',
            'grpc_endpoint': '127.0.0.1:9090',
            'connect_endpoint': ?endpoint,
          }),
        );
        await request.response.close();
      });
      if (endpoint == 'https://evil.test/') {
        await expectLater(
          discover('http://127.0.0.1:${server.port}'),
          throwsA(isA<LocalFailure>()),
        );
      } else {
        final discovery = await discover('http://127.0.0.1:${server.port}');
        final connection = discovery.openConnection();
        expect(connection.usesConnect, endpoint == '/');
        await connection.terminate();
      }
      await server.close(force: true);
    }
  });
}
