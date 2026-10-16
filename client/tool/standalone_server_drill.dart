// Проверяет только одноразовое пространство, без пользовательских данных.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:space_client/src/core.dart';

import 'home_vault.dart';
import 'home_endpoints_drill.dart' show freePort;

Future<void> main(List<String> args) async {
  final runtime = Directory(args.single).absolute;
  final temporary = await Directory.systemTemp.createTemp('space-standalone-');
  final ownerVault = HomeVault(), adminVault = HomeVault();
  final port = await freePort();
  String link = '';
  String ownerId = '';
  try {
    for (var attempt = 0; attempt < 2; attempt++) {
      final process = await Process.start(
        '${runtime.path}/${Platform.isWindows ? 'space-server.exe' : 'space-server'}',
        [
          'start',
          '-data',
          temporary.path,
          '-address',
          'https://127.0.0.1:$port',
          '-listen',
          '127.0.0.1:$port',
          '-managed',
        ],
      );
      final ready = Completer<void>();
      process.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
            if (line.startsWith('https://') && line.contains('#')) {
              link = line;
              if (!ready.isCompleted) ready.complete();
            }
          });
      // Ошибки читаются, но секретная ссылка не попадает в журнал CI.
      process.stderr.transform(utf8.decoder).listen((line) {
        if (!line.contains('setup_')) stderr.write(line);
      });
      SpaceSession? owner, admin;
      try {
        if (attempt == 0) {
          await ready.future.timeout(const Duration(seconds: 50));
        }
        final input = parseConnectionInput(link);
        Discovery? server;
        for (var retry = 0; retry < 80 && server == null; retry++) {
          try {
            server = await discoverConnection(input);
          } on SocketException {
            await Future<void>.delayed(const Duration(milliseconds: 250));
          }
        }
        if (server == null) throw StateError('Сервер не запустился');
        if (attempt == 0) {
          try {
            final unexpected = await SpaceSession.connect(server, HomeVault());
            await unexpected.close();
            throw StateError('Первый посторонний вошёл без одноразовой ссылки');
          } catch (error) {
            if (error is StateError) rethrow;
          }
          owner = await SpaceSession.connect(
            server,
            ownerVault,
            setupCode: input.setupCode,
          );
          ownerId = owner.principalId;
          if (owner.role != 'owner') {
            throw StateError('Первый участник не владелец');
          }
          await verifySecondAdmin(owner, server, adminVault);
        } else {
          owner = await SpaceSession.connect(server, ownerVault);
          admin = await SpaceSession.connect(server, adminVault);
          if (owner.principalId != ownerId ||
              owner.role != 'owner' ||
              admin.role != 'admin') {
            throw StateError('Роли потеряны после перезапуска');
          }
          await admin.adminRequest('/api/v1/space/settings');
          if (ownerVault.data.toString().contains('setup_')) {
            throw StateError('Секрет настройки сохранён в vault');
          }
        }
      } finally {
        await admin?.close();
        await owner?.close();
        await process.stdin.close();
        final code = await process.exitCode.timeout(
          const Duration(seconds: 30),
        );
        if (code != 0) throw StateError('Ошибка остановки: $code');
      }
    }
    stdout.writeln(
      'Standalone: первый владелец по pinned TLS, второй администратор и перезапуск проверены.',
    );
  } finally {
    await temporary.delete(recursive: true);
  }
}

Future<void> verifySecondAdmin(
  SpaceSession owner,
  Discovery server,
  HomeVault vault,
) async {
  final invitation = await owner.adminRequest(
    '/api/v1/space/invites',
    method: 'POST',
    body: {'role': 'member', 'ttlSeconds': 3600, 'maxUses': 1},
  );
  final member = await SpaceSession.connect(
    server,
    vault,
    invitationToken: invitation['token'] as String,
  );
  try {
    final members = await owner.adminRequest('/api/v1/space/members');
    final current = (members['members'] as List).cast<Map>().firstWhere(
      (m) => m['principalId'] == member.principalId,
    );
    await owner.adminRequest(
      '/api/v1/space/members/${member.principalId}',
      method: 'PATCH',
      body: {
        'role': 'admin',
        'blocked': false,
        'expectedRevision': current['revision'],
      },
    );
    await member.refreshMembership();
    await member.authorizeAdministration();
    await member.adminRequest('/api/v1/space/settings');
    if (!owner.canManageSpace || !member.canManageSpace) {
      throw StateError('Не работают несколько администраторов');
    }
  } finally {
    await member.close();
  }
}
