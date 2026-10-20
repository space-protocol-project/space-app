// Проверка переноса использует отдельную базу и сохранённые ключи участников.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:space_client/src/home_archive_inspection.dart';

import 'home_transfer_assets.dart';
import 'attachment_policy_fixture.dart';

import 'package:space_client/src/core.dart';
import 'package:space_client/src/root_rotation.dart';
import 'package:space_client/src/rpc_clients.dart';

import 'home_server_drill.dart' show HomeVault;

class TransferVault extends HomeVault implements RotationJournalVault {
  Map<String, dynamic>? pending;
  @override
  Future<Map<String, dynamic>?> loadRotation(String origin) async => pending;
  @override
  Future<void> saveRotation(String origin, Map<String, dynamic> value) async {
    pending = jsonDecode(jsonEncode(value)) as Map<String, dynamic>;
  }

  @override
  Future<void> clearRotation(String origin) async {
    pending = null;
  }
}

class RunningSpace {
  RunningSpace(this.process, this.discovery, this.setupCode);
  final Process process;
  final Discovery discovery;
  final String setupCode;
  Future<void> stop() async {
    await process.stdin.close();
    if (await process.exitCode.timeout(const Duration(seconds: 30)) != 0) {
      throw StateError('Сервер не подтвердил остановку');
    }
  }
}

Future<RunningSpace> startSpace(
  String executable,
  String runtime,
  Directory root,
  String ip, {
  String bindHost = '127.0.0.1',
}) async {
  final data = Directory('${root.path}/data');
  final process = await Process.start(executable, [
    '-home-runtime',
    runtime,
    '-home-data',
    data.path,
    '-public-ip',
    ip,
    '-http',
    '$bindHost:18080',
    '-grpc',
    '$bindHost:19090',
    '-https',
    '$bindHost:8443',
    '-managed',
  ]);
  process.stdout.listen(stdout.add);
  process.stderr.listen(stderr.add);
  int? exited;
  unawaited(process.exitCode.then((code) => exited = code));
  try {
    final ready = File('${data.path}/state.json');
    final deadline = DateTime.now().add(const Duration(seconds: 60));
    while (!await ready.exists()) {
      if (exited != null) {
        throw StateError('Сервер завершился до готовности, код $exited');
      }
      if (DateTime.now().isAfter(deadline)) {
        throw StateError('Нет готовности сервера');
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    final state = jsonDecode(await ready.readAsString()) as Map;
    final pem = await File('${data.path}/server.crt').readAsString();
    final fingerprint = sha256
        .convert(
          base64Decode(pem.replaceAll(RegExp(r'-----[^-]+-----|\s'), '')),
        )
        .toString();
    final discovery = await discover(
      state['local_origin'] as String,
      homeOrigin: state['public_origin'] as String,
      tlsFingerprint: fingerprint,
    );
    return RunningSpace(process, discovery, state['setup_code'] as String);
  } catch (_) {
    await process.stdin.close();
    await process.exitCode.timeout(const Duration(seconds: 30));
    rethrow;
  }
}

Future<void> maintenance(
  String executable,
  String runtime,
  List<String> arguments,
) async {
  final result = await Process.run(executable, [
    '-home-runtime',
    runtime,
    ...arguments,
  ]);
  if (result.exitCode != 0) {
    throw StateError('Перенос не выполнен: ${result.stderr}');
  }
}

Future<Map<String, dynamic>> seedSpace(
  RunningSpace space,
  TransferVault ownerVault,
  HomeVault memberVault,
) async {
  var owner = await SpaceSession.connect(
    space.discovery,
    ownerVault,
    setupCode: space.setupCode,
  );
  SpaceSession? member;
  try {
    await enableFixtureAttachments(owner);
    final invitation = await owner.adminRequest(
      '/api/v1/space/invites',
      method: 'POST',
      body: {'role': 'member', 'ttlSeconds': 3600, 'maxUses': 1},
    );
    member = await SpaceSession.connect(
      space.discovery,
      memberVault,
      invitationToken: invitation['token'] as String,
    );
    final message = await member.send(
      'Сообщение до переноса',
      'transfer-drill-before',
    );
    await owner.prepareRotation();
    final channel = space.discovery.openConnection();
    try {
      await finishRootRotation(
        space.discovery,
        ownerVault,
        AuthServiceClient(channel),
      );
    } finally {
      await channel.shutdown();
    }
    await owner.close();
    owner = await SpaceSession.connect(space.discovery, ownerVault);
    final attachment = await seedTransferAttachment(member);
    final recovery = await owner.recoveryPayload();
    await owner.prepareRotation();
    return {
      'message': message.id,
      'attachment': attachment,
      'owner': owner.principalId,
      'member': member.principalId,
      'recovery': recovery,
    };
  } finally {
    await member?.close();
    await owner.close();
  }
}

Future<void> verifySpace(
  RunningSpace space,
  Map<String, dynamic> saved,
  TransferVault ownerVault,
  HomeVault memberVault,
) async {
  final local = space.discovery;
  final remote = Discovery(
    local.origin,
    local.serverId,
    local.publicKey,
    announcement: local.announcement,
    tlsFingerprint: local.tlsFingerprint,
    dialHost: '127.0.0.1',
    connectOrigin: local.endpoint,
    endpoint: local.endpoint,
  );
  final owner = await SpaceSession.connect(remote, ownerVault);
  final member = await SpaceSession.connect(remote, memberVault);
  SpaceSession? restored;
  try {
    if (owner.principalId != saved['owner'] ||
        owner.role != 'owner' ||
        member.principalId != saved['member']) {
      throw StateError('Права или участники изменились');
    }
    if (!(await member.messages()).any(
      (message) => message.id == saved['message'],
    )) {
      throw StateError('Сообщение потеряно');
    }
    await verifyTransferAttachment(member, saved['attachment'] as String);
    await member.send('Сообщение после переноса', 'transfer-drill-after');
    final card = await recordFromRecovery(
      saved['recovery'] as Map<String, dynamic>,
    );
    restored = await SpaceSession.connect(
      remote,
      TransferVault(),
      restoredRecord: card,
    );
    if (restored.principalId != saved['owner'] || !restored.canManageSpace) {
      throw StateError('Старая карточка владельца потеряла права');
    }
    if ((await ownerVault.load(space.discovery.origin.toString()))!
            .connectionAddress !=
        'https://203.0.113.11:8443') {
      throw StateError('Новый адрес не сохранён');
    }
    final channel = remote.openConnection();
    try {
      final next = await finishRootRotation(
        remote,
        ownerVault,
        AuthServiceClient(channel),
      );
      if (next == null ||
          (await next.identity()).epoch != 3 ||
          next.connectionAddress != remote.endpoint.toString()) {
        throw StateError(
          'Подготовленная ротация не продолжилась после переноса',
        );
      }
    } finally {
      await channel.shutdown();
    }
  } finally {
    await restored?.close();
    await member.close();
    await owner.close();
  }
}

Future<void> main(List<String> arguments) async {
  final runtime = Directory(arguments.first).absolute.path;
  final executable = arguments.length > 1
      ? arguments[1]
      : '$runtime/${Platform.isWindows ? 'space-server.exe' : 'space-server'}';
  final temporary = await Directory.systemTemp.createTemp(
    'space-transfer-drill-',
  );
  RunningSpace? running;
  try {
    final original = await Directory('${temporary.path}/original').create();
    await File('${original.path}/config.json')
        .writeAsString('{"ip":"203.0.113.10"}');
    final owner = TransferVault(), member = HomeVault();
    running = await startSpace(executable, runtime, original, '203.0.113.10');
    final identity = running.discovery;
    final saved = await seedSpace(running, owner, member);
    await running.stop();
    running = null;
    final archive = '${temporary.path}/space.zip',
        imported = Directory('${temporary.path}/imported');
    await maintenance(executable, runtime, [
      '-home-export',
      archive,
      '-home-data',
      '${original.path}/data',
    ]);
    final report = await inspectTransferArchive(executable, archive);
    if (report.serverId != identity.serverId || await imported.exists()) {
      throw StateError('Проверка изменила пространство или его идентичность');
    }
    await report.requireCurrentSource(archive);
    await maintenance(executable, runtime, [
      '-home-import',
      archive,
      '-home-import-to',
      imported.path,
      '-public-ip',
      '203.0.113.11',
    ]);
    running = await startSpace(executable, runtime, imported, '203.0.113.11');
    if (running.discovery.origin != identity.origin ||
        running.discovery.tlsFingerprint != identity.tlsFingerprint ||
        running.discovery.serverId != identity.serverId) {
      throw StateError('Доверенная идентичность изменилась');
    }
    await verifySpace(running, saved, owner, member);
    await running.stop();
    running = null;
    running = await startSpace(executable, runtime, imported, '203.0.113.11');
    await verifyTransferRestart(running, saved, owner, member);
    stdout.writeln(
      'Перенос: новый IP, прежний TLS, история root, владелец, участник, сообщения, файл, реакция, старая карточка восстановления и повторный запуск проверены.',
    );
  } finally {
    await running?.stop();
    await temporary.delete(recursive: true);
  }
}

Future<HomeArchiveInspection> inspectTransferArchive(
  String executable,
  String archive,
) async {
  final digest = await homeArchiveDigest(archive);
  final result = await Process.run(executable, [
    '-home-verify-export',
    archive,
  ]);
  if (result.exitCode != 0) {
    throw StateError('Проверка архива: ${result.stderr}');
  }
  final report = HomeArchiveInspection.fromJson(
    jsonDecode(result.stdout as String) as Map<String, dynamic>,
    archive,
    digest,
  );
  await report.requireCurrentSource(archive);
  return report;
}

Future<void> verifyTransferRestart(
  RunningSpace space,
  Map<String, dynamic> saved,
  TransferVault ownerVault,
  HomeVault memberVault,
) async {
  final owner = await SpaceSession.connect(space.discovery, ownerVault);
  try {
    final member = await SpaceSession.connect(space.discovery, memberVault);
    try {
      if (owner.principalId != saved['owner'] ||
          owner.role != 'owner' ||
          member.principalId != saved['member']) {
        throw StateError('Перезапуск изменил участников или права');
      }
      final messages = await member.messages();
      if (messages.where((m) => m.text == 'Сообщение после переноса').length !=
              1 ||
          !messages.any((m) => m.id == saved['message'])) {
        throw StateError('Перезапуск потерял или продублировал сообщения');
      }
      await verifyTransferAttachment(member, saved['attachment'] as String);
    } finally {
      await member.close();
    }
  } finally {
    await owner.close();
  }
}
