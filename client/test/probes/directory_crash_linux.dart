// Независимое чтение libsecret подтверждает путь хранения без файловой фикстуры.
import 'dart:convert';
import 'dart:io';

import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/secure_vault.dart';

import 'directory_crash_support.dart';

Map readCrashSecret(Object? value) {
  try {
    return jsonDecode(value as String) as Map;
  } catch (_) {
    throw StateError('Secret Service вернул некорректную запись');
  }
}

Future<void> verifyCrashLinuxStorage(CrashHooks hooks) async {
  if (!Platform.isLinux) return;
  requireCrash(
    Platform.environment['SECRET_BACKEND'] == 'service',
    'Нужен системный Secret Service',
  );
  final result = await Process.run('secret-tool', [
    'lookup',
    'account',
    'org.spaceprotocol.space_client.secureStorage',
  ]);
  // Содержимое секрета не выводится и не попадает в контрольные файлы.
  requireCrash(
    result.exitCode == 0,
    'Независимое чтение Secret Service не удалось',
  );
  final stored = readCrashSecret(result.stdout);
  final journal = await const PlatformKeyStorage().read(
    key: DirectoryRepository.key,
  );
  requireCrash(
    journal != null && stored[DirectoryRepository.key] == journal,
    'Каталог плагина отличается от записи Secret Service',
  );
  requireCrash(
    !await Directory('${hooks.profile.path}/vault').exists(),
    'Обнаружена файловая фикстура ключей',
  );
  final keyring = File('${hooks.profile.path}/data/keyrings/login.keyring');
  final bytes = await keyring.readAsBytes();
  requireCrash(
    bytes.length > 16 &&
        ascii.decode(bytes.take(12).toList(), allowInvalid: true) ==
            'GnomeKeyring' &&
        !utf8.decode(bytes, allowMalformed: true).contains(journal!),
    'Не подтверждён зашифрованный файл GNOME Keyring',
  );
  await hooks.signal('storage-proof-${hooks.role}', {
    'backend': 'PlatformKeyStorage/libsecret/GNOME Keyring',
    'file_fixture': false,
    'independent_read': true,
    'encrypted_keyring': true,
    'pid': pid,
  });
}
