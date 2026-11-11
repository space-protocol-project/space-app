import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/contributions_transport.dart';
import 'package:space_client/src/generated/space/v1/extensions_p1.pb.dart';
import 'package:space_client/src/generated/space/v1/extensions_p1.connect.client.dart';
import 'package:space_client/src/rpc_http.dart';

import 'extensions_p1_contributions_test.dart' show registryResponse;

void main() {
  test('Connect передаёт сессию, instance, выбранный query и NONE; проверяет UI API', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final http = HttpClient();
    addTearDown(() => server.close(force: true));
    addTearDown(() => http.close(force: true));
    var version = 'space.ui.p1';
    final names = <String>[];
    server.listen((request) async {
      expect(request.headers.value('authorization'), 'Bearer fixture');
      final body = await request.fold(
        <int>[],
        (List<int> a, b) => a..addAll(b),
      );
      request.response.headers.contentType = ContentType(
        'application',
        'proto',
      );
      if (request.uri.path.endsWith('ListExtensionContributions')) {
        expect(
          ListExtensionContributionsRequest.fromBuffer(body).instanceId,
          'demo',
        );
        request.response.add(registryResponse().writeToBuffer());
      } else if (request.uri.path.endsWith('QueryExtension')) {
        final query = QueryExtensionRequest.fromBuffer(body);
        expect(query.instanceId, 'demo');
        expect(utf8.decode(query.payloadJson), '{}');
        names.add(query.query);
        request.response.add(
          QueryExtensionResponse(
            uiApi: version,
            documentJson: utf8.encode(
              '{"ui_api":"space.ui.p1","strings":{"en":{"text":"Hello"}},"body":[{"id":"text","component":"text.v1","label_key":"text"}]}',
            ),
          ).writeToBuffer(),
        );
      } else {
        final command = ExecuteExtensionCommandRequest.fromBuffer(body);
        expect(command.command, 'refresh');
        expect(
          command.effect,
          ExtensionCommandEffect.EXTENSION_COMMAND_EFFECT_NONE,
        );
        request.response.add(ExecuteExtensionCommandResponse().writeToBuffer());
      }
      await request.response.close();
    });
    final transport = ConnectContributionsTransport(
      ExtensionP1ServiceClient(
        protocol.Transport(
          baseUrl: 'http://127.0.0.1:${server.port}',
          codec: const ProtoCodec(),
          httpClient: rpcHttpClient(http, budget: RpcSubscriptionBudget()),
        ),
      ),
      'demo',
      () => {'authorization': 'Bearer fixture'},
      {'refresh'},
    );
    expect((await transport.list()).entries.length, 2);
    await transport.query('details');
    expect(names, ['details']);
    await transport.command('refresh');
    await expectLater(transport.command('unknown'), throwsStateError);
    version = 'space.ui.future';
    await expectLater(transport.query('summary'), throwsFormatException);
  });

  test('Отмена настоящего HTTP-запроса завершает ожидание', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final http = HttpClient();
    final started = Completer<void>();
    final release = Completer<void>();
    addTearDown(() => http.close(force: true));
    addTearDown(() => server.close(force: true));
    server.listen((request) async {
      await request.drain<void>();
      started.complete();
      await release.future;
      await request.response.close();
    });
    final transport = ConnectContributionsTransport(
      ExtensionP1ServiceClient(
        protocol.Transport(
          baseUrl: 'http://127.0.0.1:${server.port}',
          codec: const ProtoCodec(),
          httpClient: rpcHttpClient(http, budget: RpcSubscriptionBudget()),
        ),
      ),
      'demo',
      () => {},
      {},
    );
    final pending = expectLater(transport.list(), throwsA(isA<Exception>()));
    await started.future;
    transport.cancel();
    await pending;
    release.complete();
  });
}
