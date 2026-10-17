import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_network.dart';
import 'package:space_client/src/server_endpoints.dart';

import 'support/temp_directory.dart';

void main() {
  test(
    'Автонастройки и прежний маршрут сохраняются после перезапуска',
    () async {
      final root = await Directory.systemTemp.createTemp('space-auto-network-');
      addTearDown(
        () => deleteTestDirectory(root, prefix: 'space-auto-network-'),
      );
      final original = HomeNetwork(
        [ServerEndpoint.parse('8.8.8.8', 9443)],
        identityOrigin: 'https://8.8.4.4:8443',
        revision: 4,
        autoPortMapping: true,
        autoPublicIP: true,
        previousAutomatic: ServerEndpoint.parse('8.8.4.4', 8443),
      );
      await original.write(root);
      final restored = (await HomeNetwork.read(root))!;
      expect(restored.autoPortMapping, isTrue);
      expect(restored.autoPublicIP, isTrue);
      expect(restored.advertisedEndpoints.map((e) => e.origin.toString()), [
        'https://8.8.8.8:9443',
        'https://8.8.4.4:8443',
      ]);
      final changed = restored.changed(
        restored.endpoints,
        '::',
        18443,
        autoPortMapping: false,
        autoPublicIP: false,
      );
      expect(changed.revision, 4);
      expect(changed.identityOrigin, original.identityOrigin);
      expect(changed.previousAutomatic!.host, '8.8.4.4');
      expect(changed.autoPortMapping, isFalse);
    },
  );

  test(
    'Домен не заменяется автоматически и оставлено место для старого адреса',
    () {
      expect(
        () => HomeNetwork([
          ServerEndpoint.parse('space.example.org', 443),
        ], autoPublicIP: true),
        throwsFormatException,
      );
      final endpoints = List.generate(
        8,
        (i) => ServerEndpoint.parse('8.8.8.${i + 1}', 8443),
      );
      expect(
        () => HomeNetwork(endpoints, autoPortMapping: true),
        throwsFormatException,
      );
      expect(HomeNetwork(endpoints).endpoints.length, 8);
      final duplicate = HomeNetwork([
        ServerEndpoint.parse('8.8.8.8', 8443),
      ], previousAutomatic: ServerEndpoint.parse('8.8.8.8', 8443));
      expect(duplicate.advertisedEndpoints.length, 1);
    },
  );
}
