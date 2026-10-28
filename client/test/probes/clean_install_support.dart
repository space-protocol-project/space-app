import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/device_migration.dart';
import 'package:space_client/src/home_migration.dart';
import 'package:space_client/src/home_network.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/native.dart';
import 'package:space_client/src/secure_vault.dart';

import '../live/device_migration_home.dart';

void requireClean(bool condition, String message) {
  if (!condition) throw StateError(message);
}

String cleanHash(List<int> bytes) => crypto.sha256.convert(bytes).toString();
final cleanFileBytes = Uint8List.fromList(List.generate(300000, (i) => i % 251));

// Фикстура только второго участника; владелец использует настоящий DPAPI.
class CleanPeerStorage implements SecureKeyStorage {
  CleanPeerStorage(this.root);
  final Directory root;
  File file(String key) => File(p.join(root.path, cleanHash(utf8.encode(key))));
  @override
  Future<String?> read({required String key}) async {
    final value = file(key);
    return await value.exists() ? value.readAsString() : null;
  }
  @override
  Future<void> write({required String key, required String value}) async {
    await root.create(recursive: true);
    final next = File('${file(key).path}.next');
    await next.writeAsString(value, flush: true);
    await next.rename(file(key).path);
  }
  @override
  Future<void> delete({required String key}) async {
    final value = file(key);
    if (await value.exists()) await value.delete();
  }
}

class CleanContext {
  CleanContext()
    : work = Directory(Platform.environment['CLEAN_INSTALL_WORK']!),
      profile = Directory(Platform.environment['DIRECTORY_CRASH_PROFILE']!),
      executable = Platform.environment['SPACE_RESTORE_EXECUTABLE']!,
      runtime = Platform.environment['SPACE_HOME_RUNTIME']!;
  final Directory work, profile;
  final String executable, runtime;
  final storage = const PlatformKeyStorage();
  KeyIdentityVault get vault => KeyIdentityVault(storage);
  Directory get homeRoot => Directory(p.join(profile.path, 'home'));
  Directory get files => Directory(p.join(profile.path, 'files'));
  File get archive => File(p.join(work.path, 'device.spacedevice'));
  File get expectedFile => File(p.join(work.path, 'expected.json'));
  CleanPeerStorage get peerStorage => CleanPeerStorage(Directory(p.join(work.path, 'peer')));
  Future<Map<String, dynamic>> expected() async =>
      jsonDecode(await expectedFile.readAsString()) as Map<String, dynamic>;

  Future<NativeMigrationHome> home({bool source = false}) async {
    await homeRoot.create(recursive: true);
    final result = NativeMigrationHome(homeRoot, executable, runtime);
    if (source) {
      result.network = HomeNetwork([ServerEndpoint.parse('203.0.113.10', 8443)],
        identityOrigin: (await expected())['origin'] as String);
      result.ip = '203.0.113.10';
    }
    return result;
  }

  Future<DeviceMigration> migration(NativeMigrationHome home) async => DeviceMigration(
    home: home,
    devices: HomeMigration(vault: vault, storage: storage,
      locks: () async => Directory(p.join(profile.path, 'locks'))),
    preferences: await SharedPreferences.getInstance(),
    directory: () async => files,
    stop: () async {},
  );
}

Future<MlsClient> cleanClient(
  SpaceSession session, SecureKeyStorage storage, Directory locks,
) async {
  final record = session.record;
  final public = await (await Ed25519().newKeyPairFromSeed(record.deviceSeed)).extractPublicKey();
  final scope = record.mlsIdentity ?? {
    'server_id': record.serverId,
    'principal_id': session.principalId,
    'grant_id': record.grantId,
    'public_key': public.bytes,
  };
  record.mlsIdentity = scope;
  await session.vault.save(record);
  return MlsClient(
    connection: session.channel,
    options: () => session.mlsOptions(expectedGrant: record.grantId),
    local: MlsLocalStore(storage: storage, engine: NativeMlsEngine(),
      scope: scope, deviceSeed: record.deviceSeed, lockDirectory: locks,
      requireExisting: scope['grant_id'] != record.grantId),
  );
}
