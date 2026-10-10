// Сквозная проверка выполняется только на одноразовых runner с отдельной базой.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:grpc/grpc.dart';
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

Future<void> expectAccessDenied(
  Future<void> Function() action,
  String scenario,
) async {
  try {
    await action();
  } on GrpcError catch (error) {
    if ([
      StatusCode.permissionDenied,
      StatusCode.failedPrecondition,
      StatusCode.notFound,
      StatusCode.unauthenticated,
    ].contains(error.code)) {
      return;
    }
    rethrow;
  }
  throw StateError('Не запрещён доступ: $scenario');
}

Future<void> checkInvitationRefused(Discovery server, String token) =>
    expectAccessDenied(() async {
      final session = await SpaceSession.connect(
        server,
        HomeVault(),
        invitationToken: token,
      );
      await session.close();
    }, 'новый участник по недействующему приглашению');

Future<void> checkMemberBlocking(
  SpaceSession owner,
  SpaceSession friend,
) async {
  Future<void> setBlocked(bool blocked) async {
    final response = await owner.adminRequest('/api/v1/space/members');
    final member = (response['members'] as List).cast<Map>().firstWhere(
      (member) => member['principalId'] == friend.principalId,
    );
    await owner.adminRequest(
      '/api/v1/space/members/${friend.principalId}',
      method: 'PATCH',
      body: {
        'role': member['role'],
        'blocked': blocked,
        'expectedRevision': member['revision'],
      },
    );
  }

  await setBlocked(true);
  try {
    await expectAccessDenied(() async {
      await friend.messages();
    }, 'чтение заблокированным участником');
    await expectAccessDenied(() async {
      await friend.send('Запрещённая запись', 'blocked-home-drill');
    }, 'запись заблокированным участником');
  } finally {
    await setBlocked(false);
  }
  await friend.messages();
}

Future<void> main(List<String> args) async {
  final root = Directory(args.single).absolute;
  final directory = await Directory.systemTemp.createTemp('space-home-drill-');
  final ownerVault = HomeVault(), friendVault = HomeVault();
  String? originalID, originalCertificate, messageID;
  try {
    for (var attempt = 0; attempt < 3; attempt++) {
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
          await Future<void>.delayed(const Duration(seconds: 1));
          // Проверяем настоящий TLS handshake, а не только сравнение модели.
          try {
            await discover('https://127.0.0.1:18843', tlsFingerprint: '0' * 64);
            throw StateError('Discovery принял неверный TLS-отпечаток');
          } on HandshakeException {
            // Ожидаемый отказ до получения discovery и отправки приглашения.
          }
          final wrongCertificate = Discovery(
            remote.origin,
            remote.serverId,
            remote.publicKey,
            remote.grpcPort,
            grpcHost: remote.grpcHost,
            tlsFingerprint: '0' * 64,
          );
          try {
            await SpaceSession.previewInvitation(
              wrongCertificate,
              'iv_${'a' * 43}',
            );
            throw StateError('gRPC принял неверный TLS-отпечаток');
          } on GrpcError catch (error) {
            if (error.code != StatusCode.unavailable) rethrow;
          }
          final settings =
              (await owner.adminRequest('/api/v1/space/settings'))['settings']
                  as Map;
          if (settings['registrationPolicy'] != 'closed') {
            throw StateError('Домашний сервер не закрыт по умолчанию');
          }
          try {
            final stranger = await SpaceSession.connect(remote, HomeVault());
            await stranger.close();
            throw StateError('Участник без приглашения получил доступ');
          } on GrpcError catch (e) {
            if (e.code != StatusCode.permissionDenied &&
                e.code != StatusCode.failedPrecondition) {
              rethrow;
            }
          }
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
          await checkInvitationRefused(remote, invite['token'] as String);
          final revoked = await owner.adminRequest(
            '/api/v1/space/invites',
            method: 'POST',
            body: {'role': 'member', 'ttlSeconds': 3600, 'maxUses': 1},
          );
          final revokedInvite = revoked['invite'] as Map;
          await owner.adminRequest(
            '/api/v1/space/invites/${revokedInvite['id']}/revoke',
            method: 'POST',
            body: {},
          );
          await checkInvitationRefused(remote, revoked['token'] as String);
          await checkMemberBlocking(owner, friend);
        } else {
          friend = await SpaceSession.connect(remote, friendVault);
          if (!(await friend.messages()).any(
            (message) => message.id == messageID,
          )) {
            throw StateError('Сообщение потеряно после перезапуска');
          }
          final settings =
              (await owner.adminRequest('/api/v1/space/settings'))['settings']
                  as Map;
          if (settings['registrationPolicy'] !=
              (attempt == 1 ? 'closed' : 'open')) {
            throw StateError('Выбор владельца изменился при перезапуске');
          }
          if (attempt == 1) {
            await owner.adminRequest(
              '/api/v1/space/settings',
              method: 'PATCH',
              body: {
                'title': settings['title'],
                'chatTitle': settings['chatTitle'],
                'chatEnabled': settings['chatEnabled'],
                'registrationPolicy': 'open',
                'expectedRevision': settings['revision'],
              },
            );
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
        await expectAccessDeniedAfterStop();
      }
    }
    stdout.writeln(
      'Home: PostgreSQL, локальный владелец, публичный TLS/gRPC, приглашение, сообщение и повторный запуск проверены.',
    );
  } finally {
    await directory.delete(recursive: true);
  }
}

Future<void> expectAccessDeniedAfterStop() async {
  try {
    await discover('https://127.0.0.1:18843');
  } on SocketException {
    return;
  }
  throw StateError('HTTPS остался доступен после остановки сервера');
}
