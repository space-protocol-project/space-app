// Только одноразовая база и локальные TCP-прокси; пользовательский сервер не меняется.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cross_file/cross_file.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/home_network.dart';
import 'package:space_client/src/home_diagnostics.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/mls/files.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/native.dart';

import 'home_vault.dart';
import 'attachment_policy_fixture.dart';

class _MlsMemory implements SecureKeyStorage {
  final data = <String, String>{};
  @override
  Future<String?> read({required String key}) async => data[key];
  @override
  Future<void> write({required String key, required String value}) async {
    data[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    data.remove(key);
  }
}

Future<MlsClient> openMls(SpaceSession session) async {
  final device = await Ed25519().newKeyPairFromSeed(session.record.deviceSeed);
  final grant = session.record.grantId;
  return MlsClient(
    connection: session.channel,
    options: () => session.mlsOptions(expectedGrant: grant),
    local: MlsLocalStore(
      storage: _MlsMemory(),
      engine: NativeMlsEngine(),
      deviceSeed: session.record.deviceSeed,
      scope: {
        'server_id': session.server.serverId,
        'principal_id': session.principalId,
        'grant_id': session.record.grantId,
        'public_key': (await device.extractPublicKey()).bytes,
      },
    ),
  );
}

Future<void> verifyMlsAfterSwitch(MlsClient mls, List<int> group) async {
  final view = await mls.refresh('route-private', group);
  if (view.messages
          .where((m) => (m['message'] as Map)['text'] == 'Сообщение из очереди')
          .length !=
      1) {
    throw StateError('Потеря или дубль зашифрованного сообщения');
  }
  final message = view.messages.first['message'] as Map;
  final descriptor = Map<String, dynamic>.from(
    (message['files'] as List).single as Map,
  );
  final plaintext = await MlsFiles(mls)
      .download(group, (message['id'] as List).cast<int>(), descriptor);
  if (utf8.decode(plaintext) != 'Файл до смены маршрута') {
    throw StateError('Потерян доступ к зашифрованному файлу');
  }
}

Future<int> freePort() async {
  final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  final port = socket.port;
  await socket.close();
  return port;
}

class Forwarder {
  Forwarder(this.listener, this.target) {
    listener.listen((socket) => unawaited(forward(socket)));
  }
  final ServerSocket listener;
  final int target;
  final sockets = <Socket>{};
  Future<void> forward(Socket incoming) async {
    sockets.add(incoming);
    try {
      final outgoing = await Socket.connect(
        InternetAddress.loopbackIPv4,
        target,
      );
      sockets.add(outgoing);
      unawaited(
        incoming
            .cast<List<int>>()
            .pipe(outgoing)
            .then<void>((_) {}, onError: (_) {})
            .whenComplete(() => sockets.remove(incoming)),
      );
      unawaited(
        outgoing
            .cast<List<int>>()
            .pipe(incoming)
            .then<void>((_) {}, onError: (_) {})
            .whenComplete(() => sockets.remove(outgoing)),
      );
    } catch (_) {
      incoming.destroy();
    }
  }

  Future<void> close() async {
    await listener.close();
    for (final socket in sockets.toList()) {
      socket.destroy();
    }
  }
}

Future<void> main(List<String> arguments) async {
  final runtime = Directory(arguments.single).absolute;
  final root = await Directory.systemTemp.createTemp('space-endpoints-drill-');
  final first = Forwarder(
    await ServerSocket.bind(InternetAddress.loopbackIPv4, 0),
    await freePort(),
  );
  final second = Forwarder(
    await ServerSocket.bind(InternetAddress.loopbackIPv4, 0),
    first.target,
  );
  final endpoints = [
    ServerEndpoint.parse('localhost', first.listener.port),
    ServerEndpoint.parse('localhost', second.listener.port, priority: 1),
    ServerEndpoint.parse('::1', first.target, priority: 2),
  ];
  final config = HomeNetwork(
    endpoints,
    listenHost: '::',
    listenPort: first.target,
    identityOrigin: 'https://203.0.113.10:8443',
  );
  await config.write(root);
  Process? process;
  SpaceSession? local, remote;
  final vault = HomeVault();
  var firstClosed = false;
  try {
    process = await Process.start(
      '${runtime.path}/${Platform.isWindows ? 'space-server.exe' : 'space-server'}',
      [
        '-home-runtime',
        runtime.path,
        '-home-data',
        '${root.path}/data',
        '-http',
        '127.0.0.1:${await freePort()}',
        '-grpc',
        '127.0.0.1:${await freePort()}',
        '-managed',
      ],
    );
    // Журнал намеренно не содержит ключи, токены и код настройки в выводе теста.
    final errors = StringBuffer();
    process.stdout.drain<void>();
    process.stderr.transform(utf8.decoder).listen(errors.write);
    final ready = File('${root.path}/data/state.json');
    final deadline = DateTime.now().add(const Duration(seconds: 60));
    while (!await ready.exists()) {
      if (DateTime.now().isAfter(deadline)) {
        throw StateError('Сервер не запущен: $errors');
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    final state = jsonDecode(await ready.readAsString()) as Map;
    final certificate = await File('${root.path}/data/server.crt')
        .readAsString();
    final fingerprint = sha256
        .convert(
          base64Decode(
            certificate.replaceAll(RegExp(r'-----[^-]+-----|\s'), ''),
          ),
        )
        .toString();
    final managed = await discover(
      state['local_origin'] as String,
      homeOrigin: state['public_origin'] as String,
      tlsFingerprint: fingerprint,
    );
    local = await SpaceSession.connect(
      managed,
      vault,
      setupCode: state['setup_code'] as String,
    );
    await enableFixtureAttachments(local);
    await Future<void>.delayed(const Duration(seconds: 1));
    await verifyDoctor(runtime, root, managed.serverId, fingerprint);
    final link = spaceEndpointLink(
      endpoints.first.origin,
      fingerprint,
      managed.serverId,
      endpoints,
    );
    final public = await discoverConnection(
      parseConnectionInput(link),
      record: vault.data == null ? null : DeviceRecord.fromJson(vault.data!),
    );
    if (public.endpoint != endpoints.first.origin) {
      throw StateError('Основной адрес не выбран');
    }
    remote = await SpaceSession.connect(public, vault);
    await remote.send('До отключения маршрута', 'endpoints-before');
    final mls = await openMls(remote);
    await mls.createChannel('route-private', 'Закрытый канал');
    final group = base64Decode(
      (((await mls.local.read())['channels'] as Map)['route-private']
              as Map)['group_id']
          as String,
    );
    await MlsFiles(mls)
        .send('route-private', group, 'Старый зашифрованный файл', [
          XFile.fromData(
            Uint8List.fromList(utf8.encode('Файл до смены маршрута')),
            path: 'route-secret.txt',
          ),
        ]);
    final binding = jsonEncode(await mls.ownBinding());
    final grant = remote.record.grantId;
    final deviceKey = url64(remote.record.deviceSeed);
    await first.close();
    firstClosed = true;
    try {
      await mls.send('route-private', 'Сообщение из очереди');
    } catch (_) {
      /* Первый отказ сохраняет ciphertext в outbox. */
    }
    final pending =
        (((await mls.local.read())['channels'] as Map)['route-private']
                as Map)['outbox']
            as List;
    if (pending.length != 1) {
      throw StateError('Отказ маршрута потерял исходящее сообщение');
    }
    await remote.login();
    if (remote.record.connectionAddress != endpoints[1].origin.toString()) {
      throw StateError('Нет перехода на запасной адрес');
    }
    if (remote.record.grantId != grant ||
        url64(remote.record.deviceSeed) != deviceKey ||
        remote.record.origin != config.identityOrigin) {
      throw StateError('Смена маршрута изменила идентичность');
    }
    await verifyMlsAfterSwitch(mls, group);
    if (jsonEncode(await mls.ownBinding()) != binding) {
      throw StateError('Смена маршрута заменила MLS leaf');
    }
    await remote.send('После отключения маршрута', 'endpoints-after');
    final history = await remote.messages();
    if (history.where((m) => m.text == 'После отключения маршрута').length !=
        1) {
      throw StateError('Потеря или дубль сообщения');
    }
    final ipv6 = await discoverConnection(
      parseConnectionInput(
        spaceEndpointLink(
          endpoints[2].origin,
          fingerprint,
          managed.serverId,
          endpoints,
        ),
      ),
      record: remote.record,
    );
    if (ipv6.endpoint != endpoints[2].origin) {
      throw StateError('IPv6 не выбран');
    }
    checkTrust(ipv6, remote.record);
    final restored = DeviceRecord.fromJson(vault.data!);
    final reconnected = await discoverConnection(
      parseConnectionInput(restored.connectionAddress),
      record: restored,
    );
    checkTrust(reconnected, restored);
    stdout.writeln(
      'OK: домен и IPv6, разные внешние/локальный порты, TLS pin, отказ маршрута, прежнее устройство, сохранённый запасной адрес, MLS leaf, очередь и зашифрованный файл',
    );
  } finally {
    await remote?.close();
    await local?.close();
    if (!firstClosed) await first.close();
    await second.close();
    if (process != null) {
      await process.stdin.close();
      await process.exitCode.timeout(const Duration(seconds: 30));
    }
    await root.delete(recursive: true);
  }
}

Future<void> verifyDoctor(
  Directory runtime,
  Directory root,
  String serverId,
  String fingerprint,
) async {
  final report = HomeDiagnosis.fromJson(
    await runHomeDoctor(runtime, [
      'doctor',
      '-home-data',
      '${root.path}/data',
      '-wan-ip',
      '100.64.1.2',
      '-json',
    ]),
  );
  if (report.serverId != serverId ||
      report.fingerprint != fingerprint ||
      report.checks.any((check) => check.status == 'failed') ||
      !report.checks.any((check) => check.code == 'local_ok') ||
      !report.checks.any((check) => check.code == 'wan_shared') ||
      !report.checks.any((check) => check.code == 'external_unverified') ||
      report.outsideCommand.isEmpty) {
    throw StateError(
      'Диагностика локального сервера неверна: ${report.checks.map((check) => '${check.code}:${check.status}').join(', ')}',
    );
  }
  final remote = HomeDiagnosis.fromJson(
    await runHomeDoctor(runtime, [
      'doctor',
      '-endpoint',
      report.endpoints.first.origin.toString(),
      '-fingerprint',
      fingerprint,
      '-server-id',
      serverId,
      '-json',
    ]),
  );
  if (!remote.checks.any((check) => check.code == 'route_ok')) {
    throw StateError('Проверка адреса doctor не выполнена');
  }
  stdout.writeln(
    'Doctor: локальный TLS, подпись, CGNAT-признак и проверка заданного адреса подтверждены; интернет-доступность не приписывается.',
  );
}
