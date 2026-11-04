import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_client/src/secure_vault.dart';
import 'package:space_client/src/extensions_p1/local_profile_record.dart';
import 'package:space_client/src/extensions_p1/local_profile_verifier.dart';
import 'package:space_client/src/extensions_p1/local_session_cubit.dart';

import 'directory_crash_windows.dart';

const secret = 'synthetic local profile CI password';
final environment = Platform.environment;
final namespace = environment['DIRECTORY_CRASH_NAMESPACE']!;
final root = environment['DIRECTORY_CRASH_CONTROL']!;
final role = environment['DIRECTORY_CRASH_ROLE']!;

void require(bool condition) {
  if (!condition) throw StateError('profile_native_assertion');
}

class NativeProfileStorage implements SecureKeyStorage {
  String scoped(String key) => '$namespace.$key';
  @override
  Future<String?> read({required String key}) =>
      const PlatformKeyStorage().read(key: scoped(key));
  @override
  Future<void> write({required String key, required String value}) =>
      const PlatformKeyStorage().write(key: scoped(key), value: value);
  @override
  Future<void> delete({required String key}) =>
      const PlatformKeyStorage().delete(key: scoped(key));
}

Future<void> verifyNativeStorage(String raw) async {
  final key = '$namespace.${LocalProfileVerifier.storageKey}';
  if (Platform.isLinux) {
    final result = await Process.run('secret-tool', [
      'lookup',
      'account',
      'org.spaceprotocol.space_client.secureStorage',
    ]);
    require(
      result.exitCode == 0 &&
          (jsonDecode(result.stdout as String) as Map)[key] == raw,
    );
  }
  if (Platform.isMacOS) {
    require(
      await const MethodChannel('space/directory-crash-keychain')
              .invokeMethod<bool>('verify', raw) ==
          true,
    );
  }
  if (Platform.isWindows) {
    final data = await File(
      '${environment['DIRECTORY_CRASH_PROFILE']}/system-storage/space_$key.dat',
    ).readAsBytes();
    require(
      data.length > 20 &&
          data[0] == 1 &&
          data[1] == 0 &&
          data[2] == 0 &&
          data[3] == 0,
    );
    require(!utf8.decode(data, allowMalformed: true).contains(raw));
  }
}

Future<void> execute() async {
  final storage = NativeProfileStorage();
  final service = LocalProfileVerifier(
    storage,
    lockPath: () async => '$root/profile.lock',
  );
  final access = LocalSessionCubit(
    authenticate: () => service.verify(
      role == 'wrong' ? 'incorrect profile password' : secret,
      create: role == 'create',
      active: () => true,
    ),
  )..setForeground(true);
  require(access.state == LocalSessionStatus.locked);
  if (role == 'cleanup') {
    await storage.delete(key: LocalProfileVerifier.storageKey);
    require(!await service.hasProfile());
  } else if (role == 'corrupt') {
    await storage.write(
      key: LocalProfileVerifier.storageKey,
      value: '{corrupt',
    );
    require(!await access.unlock());
    require(
      await storage.read(key: LocalProfileVerifier.storageKey) == '{corrupt',
    );
  } else {
    require(await service.hasProfile() == (role != 'create'));
    final unlocked = await access.unlock();
    require(unlocked == (role == 'create' || role == 'login'));
    final raw = (await storage.read(key: LocalProfileVerifier.storageKey))!;
    require(!raw.contains(secret));
    final record = LocalProfileRecord.decode(raw);
    await verifyNativeStorage(raw);
    if (unlocked) {
      require(access.session.profile == record.identity.profile);
      access.lock();
      require(access.state == LocalSessionStatus.locked);
    }
    final digest = sha256
        .convert(
          utf8.encode('${record.identity.device}/${record.identity.profile}'),
        )
        .toString();
    await File('$root/result-$role.json').writeAsString(
      jsonEncode({
        'pid': pid,
        'role': role,
        'identity_digest': digest,
        'failures': record.failures,
        'unlocked': unlocked,
        'native_storage': true,
      }),
      flush: true,
    );
  }
  await access.close();
}

Future<void> main() async {
  if (environment['GITHUB_ACTIONS'] != 'true' ||
      !RegExp(r'^space-ci-[a-f0-9]{64}$').hasMatch(namespace)) {
    exit(2);
  }
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: Scaffold(body: Text('Profile native CI'))));
  await WidgetsBinding.instance.endOfFrame;
  try {
    await initializeCrashWindows();
    await execute();
    await File('$root/done-$role').writeAsString('$pid', flush: true);
    if (role == 'create' || role == 'wrong') {
      await Future<void>.delayed(const Duration(minutes: 5));
    }
    exit(0);
  } catch (_) {
    stderr.writeln('PROFILE_NATIVE_FAILED: $role');
    exit(1);
  }
}
