import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/core.dart';

void main() {
  test(
    'Проверяются все сохранённые серверы, не больше четырёх одновременно',
    () async {
      final visited = <String>{};
      var active = 0, maximum = 0;
      final finished = Completer<void>();
      final monitor = ServerPresence(
        probe: (origin) async {
          active++;
          if (active > maximum) maximum = active;
          await Future<void>.delayed(Duration.zero);
          active--;
          visited.add(origin);
          if (visited.length == 18) finished.complete();
          return true;
        },
      );
      addTearDown(monitor.dispose);
      final origins = List.generate(
        18,
        (index) => 'https://server$index.example',
      );
      monitor.watch(origins);
      await finished.future;
      await Future<void>.delayed(Duration.zero);
      expect(visited, origins.toSet());
      expect(maximum, lessThanOrEqualTo(4));
      expect(monitor.online(origins.last), true);
    },
  );
  test(
    'Проверка доступности сверяет сохранённый ключ и не выполняет вход',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final origin = 'http://127.0.0.1:${server.port}';
      final key = List.filled(32, 1);
      var advertisedKey = key;
      final requests = <String>[];
      server.listen((request) async {
        requests.add(request.uri.path);
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode({
            'server_id': 'srv_${'a' * 32}',
            'signing_public_key': url64(advertisedKey),
            'protocol_version': '0.1-experimental',
            'signing_algorithm': 'Ed25519',
            'manifest': '/api/v1/manifest',
            'connect_endpoint': '/',
          }),
        );
        await request.response.close();
      });
      final vault = PresenceVault(
        DeviceRecord(
          origin: origin,
          serverId: 'srv_${'a' * 32}',
          serverKey: url64(key),
          rootSeed: List.filled(32, 2),
          deviceSeed: List.filled(32, 3),
        ),
      );
      expect(await probeSavedServer(origin, vault), true);
      advertisedKey = List.filled(32, 4);
      expect(await probeSavedServer(origin, vault), isNull);
      vault.failReads = true;
      expect(await probeSavedServer(origin, vault), isNull);
      vault.failReads = false;
      expect(requests, [
        '/.well-known/space-protocol',
        '/.well-known/space-protocol',
      ]);
      expect(vault.saves, 0);
      await server.close(force: true);
      expect(await probeSavedServer(origin, vault), false);
    },
  );
  test(
    'Переходы доступности, два отказа и отсутствие повторных уведомлений',
    () async {
      bool? available = true;
      final monitor = ServerPresence(probe: (_) async => available);
      addTearDown(monitor.dispose);
      final changes = <ServerPresenceChange>[];
      final subscription = monitor.changes.listen(changes.add);
      addTearDown(subscription.cancel);
      monitor.watch(['https://server.example']);
      await Future<void>.delayed(Duration.zero);
      expect(monitor.online('https://server.example'), true);
      expect(changes, isEmpty);
      available = false;
      await monitor.check();
      expect(monitor.online('https://server.example'), true);
      available = true;
      await monitor.check();
      available = false;
      await monitor.check();
      await monitor.check();
      await Future<void>.delayed(Duration.zero);
      expect(changes.map((event) => event.online), [false]);
      await monitor.check();
      available = true;
      await monitor.check();
      await monitor.check();
      await Future<void>.delayed(Duration.zero);
      expect(changes.map((event) => event.online), [false, true]);
      available = null;
      await monitor.check();
      expect(monitor.online('https://server.example'), isNull);
      monitor.watch([]);
      expect(monitor.online('https://server.example'), isNull);
    },
  );

  test(
    'Удаление сервера отменяет поздний результат, проверки не пересекаются',
    () async {
      final pending = Completer<bool?>();
      var probes = 0;
      final monitor = ServerPresence(
        probe: (_) {
          probes++;
          return pending.future;
        },
      );
      addTearDown(monitor.dispose);
      monitor.watch(['https://server.example']);
      await monitor.check();
      expect(probes, 1);
      monitor.watch([]);
      pending.complete(true);
      await Future<void>.delayed(Duration.zero);
      expect(monitor.online('https://server.example'), isNull);
    },
  );
}

class PresenceVault implements IdentityVault {
  PresenceVault(this.record);
  final DeviceRecord record;
  int saves = 0;
  bool failReads = false;
  @override
  Future<DeviceRecord?> load(String origin) async {
    if (failReads) throw TimeoutException('storage');
    return record;
  }

  @override
  Future<void> save(DeviceRecord record) async {
    saves++;
  }
}
