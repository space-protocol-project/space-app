import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:space_client/src/extensions_p1/command_cubit.dart';
import 'package:space_client/src/extensions_p1/command_snapshot.dart';
import 'package:space_client/src/extensions_p1/command_transport.dart';
import 'package:space_client/src/generated/space/v1/extensions_p1.pb.dart';
import 'package:space_client/src/generated/space/v1/extensions_p1.connect.client.dart';
import 'package:space_client/src/rpc_http.dart';
import 'package:space_client/src/secure_vault.dart';

final environment = Platform.environment;
final control = Directory(environment['P1_COMMAND_CONTROL']!);

Future<void> signal(String name, Map<String, Object?> value) async {
  final target = File.fromUri(control.uri.resolve('$name.json'));
  final next = File.fromUri(control.uri.resolve('$name.next'));
  await next.writeAsString(jsonEncode({'pid': pid, ...value}), flush: true);
  await next.rename(target.path);
}

class CrashCommandStorage implements SecureKeyStorage {
  const CrashCommandStorage();
  static const actual = PlatformKeyStorage();
  @override
  Future<String?> read({required String key}) => actual.read(key: key);
  @override
  Future<void> delete({required String key}) => actual.delete(key: key);
  @override
  Future<void> write({required String key, required String value}) async {
    if (environment['P1_COMMAND_STAGE'] == 'before-save') {
      await signal('checkpoint', {'stage': 'before-save'});
      await Completer<void>().future;
    }
    await actual.write(key: key, value: value);
    await signal('saved', await storageProof(key));
    if (environment['P1_COMMAND_STAGE'] == 'after-save') {
      await signal('checkpoint', {'stage': 'after-save'});
      await Completer<void>().future;
    }
  }
}

Future<Map<String, Object?>> storageProof(String key) async {
  if (environment['SECRET_BACKEND'] != 'service') {
    throw StateError('Не используется Secret Service');
  }
  final raw = await const PlatformKeyStorage().read(key: key);
  final lookup = await Process.run('secret-tool', [
    'lookup',
    'account',
    'org.spaceprotocol.space_client.secureStorage',
  ]);
  final values = lookup.exitCode == 0
      ? jsonDecode(lookup.stdout as String) as Map<String, dynamic>
      : <String, dynamic>{};
  if (values[key] != raw) throw StateError('Независимое чтение не совпало');
  if (raw == null) return {'present': false, 'independent_read': true};
  final file = File.fromUri(
    Directory(environment['XDG_DATA_HOME']!).uri
        .resolve('keyrings/login.keyring'),
  );
  final bytes = await file.readAsBytes();
  if (bytes.length < 16 ||
      ascii.decode(bytes.take(12).toList(), allowInvalid: true) !=
          'GnomeKeyring' ||
      utf8.decode(bytes, allowMalformed: true).contains(raw)) {
    throw StateError('Не подтверждено шифрование keyring');
  }
  return {
    'present': true,
    'independent_read': true,
    'encrypted_keyring': true,
    'snapshot_sha256': sha256.convert(utf8.encode(raw)).toString(),
    'snapshot_bytes': utf8.encode(raw).length,
  };
}

Future<void> runRole() async {
  final role = environment['P1_COMMAND_ROLE']!;
  final address = environment['SPACE_P1_COMMAND_URL']!;
  final binding = (
    server: address,
    space: 'crash-fixture',
    installation: 'install',
    principal: environment['SPACE_P1_COMMAND_PRINCIPAL']!,
  );
  final journal = ExtensionCommandJournal(const CrashCommandStorage(), binding);
  final http = pinnedRpcClient(Uri.parse(address), '');
  final transport = ExtensionConnectCommandTransport(
    ExtensionP1ServiceClient(
      protocol.Transport(
        baseUrl: address,
        codec: const ProtoCodec(),
        httpClient: rpcHttpClient(http),
      ),
    ),
    () => {'authorization': environment['SPACE_P1_COMMAND_AUTH']!},
  );
  final cubit = ExtensionCommandCubit(
    transport,
    journal,
    () => (
      server: binding.server,
      space: binding.space,
      installation: binding.installation,
      principal: role == 'foreign' ? 'other-principal' : binding.principal,
    ),
  );
  try {
    await signal('ready', {'role': role});
    if (role == 'start') {
      await cubit.start(
        ExecuteExtensionCommandRequest(
          instanceId: 'demo',
          command: 'acknowledge',
          // Контракт demo допускает только {}; пробелы проверяют большой журнал.
          payloadJson: utf8.encode('{${' ' * 12000}}'),
          effect: ExtensionCommandEffect.EXTENSION_COMMAND_EFFECT_MUTATION,
          idempotencyKey: 'native-crash-command-001',
        ),
      );
      throw StateError('Процесс не был остановлен в контрольной точке');
    }
    if (role != 'inspect') await cubit.reconcile();
    final proof = await storageProof(journal.key);
    await signal('done', {
      'role': role,
      'phase': cubit.state.phase,
      'unknown': cubit.state.unknown,
      'attempts': cubit.state.attempts,
      ...proof,
    });
  } finally {
    await cubit.close();
    http.close(force: true);
  }
}

Future<void> main() async {
  if (environment['GITHUB_ACTIONS'] != 'true' || !Platform.isLinux) exit(2);
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    stderr.writeln(details.exception.runtimeType);
    exit(1);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    stderr.writeln(error.runtimeType);
    exit(1);
  };
  runApp(
    const MaterialApp(home: Scaffold(body: Text('P1 command recovery CI'))),
  );
  await WidgetsBinding.instance.endOfFrame;
  try {
    await runRole();
    exit(0);
  } catch (error, stack) {
    stderr.writeln('COMMAND_CRASH_FAILED: $error\n$stack');
    exit(1);
  }
}
