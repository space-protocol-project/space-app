import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/home_network.dart';

import 'support/temp_directory.dart';

void main() {
  final identity = Uri.parse('https://203.0.113.10:8443');
  final pin = 'a' * 64;
  final serverId = 'srv_${'1' * 32}';

  test('Домен, IPv6, нестандартный порт и полный QR сохраняют все адреса', () {
    final endpoints = [
      ServerEndpoint.parse('space.example.org', 443),
      ServerEndpoint.parse('2001:db8::1', 19443, priority: 1),
    ];
    final token = 'iv_${'b' * 43}';
    final link = spaceEndpointLink(
      endpoints.first.origin,
      pin,
      serverId,
      endpoints,
      invitationToken: token,
    );
    final input = parseConnectionInput(link);
    expect(input.origin.toString(), 'https://space.example.org');
    expect(
      input.endpoints.last.origin.toString(),
      'https://[2001:db8::1]:19443',
    );
    expect(input.invitationToken, token);
    expect(input.serverId, serverId);
    expect(input.tlsFingerprint, pin);
    for (final host in [
      'user@host',
      'host/path',
      '*.example.org',
      'fe80::1%eth0',
      'a..b',
      '[::1]',
    ]) {
      expect(() => ServerEndpoint.parse(host, 8443), throwsFormatException);
    }
    expect(
      () => ServerEndpoint.parse('example.org', 65536),
      throwsFormatException,
    );
    expect(
      () =>
          parseEndpoints([endpoints.first.toJson(), endpoints.first.toJson()]),
      throwsFormatException,
    );
    expect(() => parseConnectionInput('$link&tls=$pin'), throwsFormatException);
  });

  test('Подпись списка, постоянная идентичность и защита от отката', () async {
    final algorithm = Ed25519();
    final key = await algorithm.newKeyPairFromSeed(List.filled(32, 7));
    final public = (await key.extractPublicKey()).bytes;
    final endpoint = ServerEndpoint.parse('space.example.org', 9443);
    Future<Map<String, dynamic>> announcement(int revision) async {
      final data = <String, dynamic>{
        'server_id': serverId,
        'identity_origin': identity.toString(),
        'tls_fingerprint': pin,
        'endpoint_revision': revision,
        'endpoints': [endpoint.toJson()],
      };
      final payload = utf8.encode(
        'space/endpoints/v1\u0000${jsonEncode([
          serverId,
          identity.toString(),
          revision,
          pin,
          [endpoint.row],
        ])}',
      );
      data['endpoint_signature'] = url64(
        (await algorithm.sign(payload, keyPair: key)).bytes,
      );
      return data;
    }

    final data = await announcement(3);
    final accepted = await EndpointAnnouncement.verify(
      data,
      endpoint.origin,
      pin,
      public,
    );
    final record = DeviceRecord(
      origin: identity.toString(),
      serverId: serverId,
      serverKey: url64(public),
      rootSeed: List.filled(32, 1),
      deviceSeed: List.filled(32, 2),
      tlsFingerprint: pin,
    );
    Discovery discovery(
      EndpointAnnouncement? list, {
      String? tls,
      String? id,
    }) => Discovery(
      identity,
      id ?? serverId,
      public,
      endpoint: endpoint.origin,
      tlsFingerprint: tls ?? pin,
      announcement: list,
    );
    rememberServerRoute(record, discovery(accepted));
    final before = jsonEncode(record.toJson());
    final stale = await EndpointAnnouncement.verify(
      await announcement(2),
      endpoint.origin,
      pin,
      public,
    );
    for (final invalid in [
      discovery(stale),
      discovery(null),
      discovery(EndpointAnnouncement(accepted.endpoints, 3, 'подмена')),
      discovery(accepted, tls: 'b' * 64),
      discovery(accepted, id: 'srv_${'2' * 32}'),
    ]) {
      expect(
        () => rememberServerRoute(record, invalid),
        throwsA(isA<Exception>()),
      );
      expect(jsonEncode(record.toJson()), before);
    }
    for (final field in [
      'server_id',
      'identity_origin',
      'tls_fingerprint',
      'endpoint_signature',
      'endpoint_revision',
    ]) {
      await expectLater(
        EndpointAnnouncement.verify(
          {...data, field: field == 'endpoint_revision' ? 4 : 'подмена'},
          endpoint.origin,
          pin,
          public,
        ),
        throwsA(isA<Exception>()),
      );
    }
    final restored = DeviceRecord.fromJson(record.toJson());
    expect(restored.endpointRevision, 3);
    expect(restored.endpointDigest, accepted.digest);
    expect(restored.origin, identity.toString());
  });

  test(
    'Отказ основного адреса, максимум две попытки и отмена проигравшей',
    () async {
      final addresses = [
        Uri.parse('https://first.example:8443'),
        Uri.parse('https://second.example:9443'),
      ];
      final started = <Uri>[];
      final loserCancelled = Completer<void>();
      final server = await selectEndpoint(addresses, (
        endpoint,
        cancelled,
        explicit,
      ) async {
        started.add(endpoint);
        if (endpoint == addresses.first) {
          await cancelled;
          loserCancelled.complete();
          throw const SocketException('Адрес отключён');
        }
        expect(explicit, false);
        return Discovery(identity, serverId, const [], endpoint: endpoint);
      }, stagger: const Duration(milliseconds: 5));
      await loserCancelled.future;
      expect(started, addresses);
      expect(server.endpoint, addresses.last);
    },
  );

  test('После общего таймаута новые адреса не пробуются', () async {
    var attempts = 0;
    await expectLater(
      selectEndpoint(
        List.generate(8, (i) => Uri.parse('https://host$i.example')),
        (uri, cancelled, explicit) async {
          attempts++;
          await cancelled;
          throw const SocketException('Отменено');
        },
        stagger: const Duration(milliseconds: 1),
        timeout: const Duration(milliseconds: 20),
      ),
      throwsA(isA<TimeoutException>()),
    );
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(attempts, 2);
  });

  test(
    'Автоматические адреса не ведут в локальные сети и IPv4-mapped IPv6',
    () {
      for (final ip in [
        '127.0.0.1',
        '10.0.0.1',
        '192.168.1.1',
        '100.64.0.1',
        '::1',
        'fc00::1',
        'fe80::1',
        '::ffff:127.0.0.1',
      ]) {
        expect(publicEndpointAddress(InternetAddress(ip)), false, reason: ip);
      }
      expect(publicEndpointAddress(InternetAddress('8.8.8.8')), true);
      expect(
        publicEndpointAddress(InternetAddress('2606:4700:4700::1111')),
        true,
      );
    },
  );

  test('Смена адресов и локального порта сохраняет постоянный origin после перезапуска', () async {
    final root = await Directory.systemTemp.createTemp('space-endpoints-');
    addTearDown(() => deleteTestDirectory(root, prefix: 'space-endpoints-'));
    final original = HomeNetwork.fromJson({'ip': '203.0.113.10', 'port': 8443});
    final next = original.changed(
      [
        ServerEndpoint.parse('space.example.org', 443),
        ServerEndpoint.parse('2001:db8::2', 9443),
      ],
      '::',
      18443,
    );
    await next.write(root);
    final restored = (await HomeNetwork.read(root))!;
    expect(restored.identityOrigin, identity.toString());
    expect(restored.listenPort, 18443);
    expect(restored.endpoints.first.port, 443);
    expect(restored.revision, 2);
    expect(restored.changed(restored.endpoints, '0.0.0.0', 18444).revision, 2);
    expect(
      () => HomeNetwork(next.endpoints, revision: maxEndpointRevision + 1),
      throwsFormatException,
    );
  });
}
