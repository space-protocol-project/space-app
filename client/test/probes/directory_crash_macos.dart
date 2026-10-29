// Меняется только пространство имён, системные Keychain и NSUserDefaults настоящие.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/directory_repository.dart';

import 'directory_crash_support.dart';

const crashMacChannel = MethodChannel('space/directory-crash-keychain');

void initializeCrashMacOS() {
  if (!Platform.isMacOS) return;
  final namespace = Platform.environment['DIRECTORY_CRASH_NAMESPACE']!;
  requireCrash(
    RegExp(r'^space-ci-[a-f0-9]{64}$').hasMatch(namespace),
    'Некорректное пространство имён стенда',
  );
  SharedPreferences.setPrefix('flutter.$namespace.');
}

Future<void> verifyCrashMacOSStorage(CrashContext context) async {
  if (!Platform.isMacOS) return;
  final journal = await context.storage.read(key: DirectoryRepository.key);
  requireCrash(journal != null, 'Системный Keychain потерял каталог');
  final matches = await crashMacChannel.invokeMethod<bool>('verify', journal);
  requireCrash(matches == true, 'Прямое чтение Keychain не совпало с плагином');
  requireCrash(
    !await Directory('${context.hooks.profile.path}/vault').exists(),
    'Обнаружена файловая фикстура ключей',
  );
  await context.hooks.signal('storage-proof-${context.hooks.role}', {
    'backend': 'PlatformKeyStorage/macOS system login Keychain',
    'file_fixture': false,
    'independent_read': true,
    'system_keychain': true,
    'pid': pid,
  });
}

Future<void> cleanupCrashMacOS() async {
  requireCrash(Platform.isMacOS, 'Очистка доступна только на macOS');
  final cleaned = await crashMacChannel.invokeMethod<bool>('cleanup');
  requireCrash(cleaned == true, 'Не удалены собственные данные стенда');
}
