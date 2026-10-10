// Сквозная проверка выполняется только на одноразовых runner с отдельной базой.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:space_client/src/core.dart';

class HomeVault implements IdentityVault {
  Map<String, dynamic>? data;
  @override
  Future<DeviceRecord?> load(String origin) async =>
      data == null ? null : DeviceRecord.fromJson(data!);
  @override
  Future<void> save(DeviceRecord record) async {
    data = record.toJson();
  }
}

Future<void> main(List<String> args) async {
  final root = Directory(args.single).absolute;
  final directory = await Directory.systemTemp.createTemp('space-home-drill-');
  final ownerVault = HomeVault(), friendVault = HomeVault();
  String? originalID, originalCertificate, messageID;
  try {
    for (var attempt = 0; attempt < 2; attempt++) {
      final executable =
          '${root.path}/${Platform.isWindows ? 'space-server.exe' : 'space-server'}';
      final process = await Process.start(executable, [
        '-home-runtime',
        root.path,
        '-home-data',
        directory.path,
        '-public-ip',
        '203.0.113.10',
        '-http',
        '127.0.0.1:18080',
        '-grpc',
        '127.0.0.1:19090',
        '-https',
        '127.0.0.1:18843',
        '-managed',
      ]);
      process.stdout.listen((bytes) => stdout.add(bytes));
      process.stderr.listen((bytes) => stderr.add(bytes));
      SpaceSession? owner, friend;
      final ready = File('${directory.path}/state.json');
      try {
        final deadline = DateTime.now().add(const Duration(seconds: 60));
        while (!await ready.exists()) {
          if (DateTime.now().isAfter(deadline)) {
            throw StateError('Нет готовности сервера');
          }
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
        final state =
            jsonDecode(await ready.readAsString()) as Map<String, dynamic>;
        final pem = await File('${directory.path}/server.crt').readAsString();
        final fingerprint = crypto.sha256
            .convert(
              base64Decode(pem.replaceAll(RegExp(r'-----[^-]+-----|\s'), '')),
            )
            .toString();
        final discovery = await discover(
          state['local_origin'] as String,
          homeOrigin: state['public_origin'] as String,
          tlsFingerprint: fingerprint,
        );
        if (attempt == 0) {
          originalID = discovery.serverId;
          originalCertificate = fingerprint;
          final client = HttpClient()
            ..badCertificateCallback = (_, _, _) => true;
          try {
            final request = await client.getUrl(
              Uri.parse('https://127.0.0.1:18843/healthz'),
            );
            request.headers.set(HttpHeaders.hostHeader, '203.0.113.10:18843');
            final response = await request.close();
            if (response.statusCode != 503) {
              throw StateError('Внешний вход открыт до владельца');
            }
            await response.drain<void>();
          } finally {
            client.close(force: true);
          }
        } else if (discovery.serverId != originalID ||
            fingerprint != originalCertificate ||
            state['setup_code'] != '') {
          throw StateError(
            'Повторный запуск изменил identity, сертификат или bootstrap',
          );
        }
        owner = await SpaceSession.connect(
          discovery,
          ownerVault,
          setupCode: state['setup_code'] as String,
        );
        if (owner.role != 'owner' || !owner.canManageSpace) {
          throw StateError('Не назначен владелец');
        }
        final remote = Discovery(
          discovery.origin,
          discovery.serverId,
          discovery.publicKey,
          18843,
          grpcHost: '127.0.0.1',
          tlsCertificate: pem,
          tlsFingerprint: fingerprint,
        );
        if (attempt == 0) {
          final invite = await owner.adminRequest(
            '/api/v1/space/invites',
            method: 'POST',
            body: {'role': 'member', 'ttlSeconds': 3600, 'maxUses': 1},
          );
          await Future<void>.delayed(const Duration(seconds: 1));
          final preview = await SpaceSession.previewInvitation(
            remote,
            invite['token'] as String,
          );
          if (preview.serverId != originalID) {
            throw StateError('Неверный сервер приглашения');
          }
          friend = await SpaceSession.connect(
            remote,
            friendVault,
            invitationToken: invite['token'] as String,
          );
          messageID = (await friend.send(
            'Сохранённое сообщение домашнего сервера',
            'home-drill-message',
          )).id;
        } else {
          friend = await SpaceSession.connect(remote, friendVault);
          if (!(await friend.messages()).any(
            (message) => message.id == messageID,
          )) {
            throw StateError('Сообщение потеряно после перезапуска');
          }
        }
      } finally {
        await friend?.close();
        await owner?.close();
        await process.stdin.close();
        final code = await process.exitCode.timeout(
          const Duration(seconds: 30),
        );
        if (code != 0) throw StateError('Сервер завершился с кодом $code');
      }
    }
    stdout.writeln(
      'Home: PostgreSQL, локальный владелец, публичный TLS/gRPC, приглашение, сообщение и повторный запуск проверены.',
    );
  } finally {
    await directory.delete(recursive: true);
  }
}
