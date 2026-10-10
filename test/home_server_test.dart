import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_runtime.dart';
import 'package:space_client/ui/home_panel.dart';

void main() {
  test(
    'Публичный HTTPS и TLS-отпечаток приглашения; внешний HTTP запрещён',
    () {
      final pin = 'a' * 64;
      final input = parseConnectionInput(
        'https://203.0.113.10:8443/#invite=iv_${'b' * 43}&tls=$pin',
      );
      expect(input.origin.toString(), 'https://203.0.113.10:8443');
      expect(input.tlsFingerprint, pin);
      expect(
        () => localOrigin('http://203.0.113.10:8443'),
        throwsFormatException,
      );
      expect(
        () => parseConnectionInput('https://203.0.113.10:8443#tls=bad'),
        throwsFormatException,
      );
      expect(isPublicHomeIPv4('192.168.1.2'), false);
      expect(isPublicHomeIPv4('100.64.1.2'), false);
      expect(isPublicHomeIPv4('203.0.113.10'), true);
    },
  );

  test('Замена сертификата блокируется даже при прежнем server ID и ключе', () {
    final record = DeviceRecord(
      origin: 'https://203.0.113.10:8443',
      serverId: 'srv_same',
      serverKey: url64(List.filled(32, 1)),
      rootSeed: List.filled(32, 2),
      deviceSeed: List.filled(32, 3),
      tlsFingerprint: 'a' * 64,
    );
    final restored = DeviceRecord.fromJson(record.toJson());
    expect(restored.tlsFingerprint, 'a' * 64);
    final changed = Discovery(
      Uri.parse(record.origin),
      record.serverId,
      List.filled(32, 1),
      8443,
      tlsFingerprint: 'b' * 64,
    );
    expect(() => checkTrust(changed, restored), throwsFormatException);
  });

  test(
    'Проверка SHA-256 и запрет выхода файлов из каталога установки',
    () async {
      final root = await Directory.systemTemp.createTemp('space-home-test-');
      addTearDown(() => root.delete(recursive: true));
      for (final name in [
        'space-server.exe',
        '../outside.txt',
        'C:/outside.txt',
      ]) {
        final archive = Archive()..addFile(ArchiveFile(name, 3, [1, 2, 3]));
        final bytes = ZipEncoder().encode(archive);
        final input = await File('${root.path}/archive.zip')
            .writeAsBytes(bytes);
        final output = await Directory(
          '${root.path}/output-${name.hashCode.abs()}',
        ).create();
        if (name == 'space-server.exe') {
          await expectLater(
            extractHomeRelease(input, output, '0' * 64),
            throwsFormatException,
          );
          expect(output.listSync(), isEmpty);
          await extractHomeRelease(
            input,
            output,
            crypto.sha256.convert(bytes).toString(),
          );
          expect(await File('${output.path}/space-server.exe').readAsBytes(), [
            1,
            2,
            3,
          ]);
        } else {
          await expectLater(
            extractHomeRelease(
              input,
              output,
              crypto.sha256.convert(bytes).toString(),
            ),
            throwsFormatException,
          );
          expect(output.listSync(), isEmpty);
        }
      }
      expect(await File('${root.path}/outside.txt').exists(), false);
    },
  );

  testWidgets(
    'Выйти в эфир → Отключиться → Выйти в эфир; ссылка остаётся прежней',
    (tester) async {
      final home = HomeController();
      home.ip = '203.0.113.10';
      addTearDown(home.dispose);
      var launches = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomePanel(
              home: home,
              onStart: (ip) async {
                launches++;
                expect(ip, home.ip);
                home.running = true;
                home.state = HomeServerState(
                  'http://127.0.0.1:18080',
                  'https://203.0.113.10:8443',
                  '',
                  'a' * 64,
                );
                home.notifyListeners();
              },
              onStop: () async {
                home.running = false;
                home.state = null;
                home.notifyListeners();
              },
              openAdministration: () {},
            ),
          ),
        ),
      );
      await tester.tap(find.text('Выйти в эфир'));
      await tester.pumpAndSettle();
      expect(find.text('Отключиться'), findsOneWidget);
      final link = home.state!.link;
      await tester.ensureVisible(find.text('Отключиться'));
      await tester.tap(find.text('Отключиться'));
      await tester.pumpAndSettle();
      expect(find.text('Выйти в эфир'), findsOneWidget);
      await tester.tap(find.text('Выйти в эфир'));
      await tester.pumpAndSettle();
      expect(home.state!.link, link);
      expect(launches, 2);
      expect(tester.takeException(), isNull);
    },
  );
}
