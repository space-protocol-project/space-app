// Windows использует настоящее системное хранилище, Linux — файловую фикстуру.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_document.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/secure_vault.dart' show PlatformKeyStorage;
import 'package:space_client/src/settings_snapshot.dart';
import 'package:space_directory_noise/space_directory_noise.dart';

import '../fixtures/directory.dart' show directoryDocument, directorySpace;

const existingOrigin = 'https://existing.example';
const incomingOrigins = ['https://space.example', 'https://second.example'];

void requireCrash(bool condition, String message) {
  if (!condition) throw StateError(message);
}

Future<void> atomicCrashFile(File file, String value) async {
  await file.parent.create(recursive: true);
  final next = File('${file.path}.next');
  await next.writeAsString(value, flush: true);
  await next.rename(file.path);
}

class CrashHooks {
  CrashHooks()
    : control = Directory(Platform.environment['DIRECTORY_CRASH_CONTROL']!),
      profile = Directory(Platform.environment['DIRECTORY_CRASH_PROFILE']!),
      role = Platform.environment['DIRECTORY_CRASH_ROLE']!,
      stage = Platform.environment['DIRECTORY_CRASH_STAGE'] ?? '',
      replace = Platform.environment['DIRECTORY_CRASH_REPLACE'] == '1';
  final Directory control, profile;
  final String role, stage;
  final bool replace;
  File file(String name) => File('${control.path}/$name.json');
  Future<void> signal(String name, [Object value = const {}]) =>
      atomicCrashFile(file(name), jsonEncode(value));
  Future<dynamic> read(String name) async =>
      jsonDecode(await file(name).readAsString());
  Future<void> wait(String name) async {
    final deadline = DateTime.now().add(const Duration(seconds: 90));
    while (!await file(name).exists()) {
      requireCrash(DateTime.now().isBefore(deadline), 'Нет сигнала $name');
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> hit(String point) async {
    if (stage != point) return;
    await signal('checkpoint-$role', {'pid': pid, 'stage': point});
    stdout.writeln('DIRECTORY_CRASH_CHECKPOINT: $role/$point');
    await Completer<void>().future;
  }
}

class CrashStorage implements SecureKeyStorage {
  CrashStorage(this.hooks);
  final CrashHooks hooks;
  bool armed = false;
  File _file(String key) =>
      File('${hooks.profile.path}/vault/${url64(utf8.encode(key))}.json');
  @override
  Future<String?> read({required String key}) async {
    if (Platform.isWindows) return const PlatformKeyStorage().read(key: key);
    final file = _file(key);
    return await file.exists() ? file.readAsString() : null;
  }

  @override
  Future<void> write({required String key, required String value}) async {
    final journal = key == DirectoryRepository.key;
    final pending = journal && (jsonDecode(value) as Map)['pending'] != null;
    if (armed && pending) await hooks.hit('journal-before');
    if (Platform.isWindows) {
      if (armed && pending && hooks.stage == 'encrypted-journal') {
        await hooks.signal('checkpoint-${hooks.role}', {
          'pid': pid,
          'stage': 'encrypted-journal',
        });
      }
      await const PlatformKeyStorage().write(key: key, value: value);
    } else {
      await atomicCrashFile(_file(key), value);
    }
    if (armed && journal) {
      await hooks.hit(pending ? 'journal-written' : 'journal-cleared');
    }
  }

  @override
  Future<void> delete({required String key}) async {
    if (Platform.isWindows) {
      await const PlatformKeyStorage().delete(key: key);
      return;
    }
    final file = _file(key);
    if (await file.exists()) await file.delete();
  }
}

class CrashPreferences extends AppPreferences {
  CrashPreferences(this.hooks);
  final CrashHooks hooks;
  bool armed = false;
  @override
  Future<void> applyMergedSettings(SettingsSnapshot before, SettingsSnapshot target,
      Future<void> Function() persist) async {
    await super.applyMergedSettings(before, target, persist);
    if (armed) await hooks.hit('settings-written');
  }
  @override
  Future<void> change({
    bool? dark,
    ThemeMode? themeMode,
    bool? effects,
    String? palette,
    String? language,
    String? sendShortcut,
    double? uiScale,
  }) async {
    await super.change(
      dark: dark,
      themeMode: themeMode,
      effects: effects,
      palette: palette,
      language: language,
      sendShortcut: sendShortcut,
      uiScale: uiScale,
    );
    await flush();
    if (armed) await hooks.hit('settings-written');
  }

  @override
  Future<void> remember(String origin) async {
    await super.remember(origin);
    await flush();
    if (armed) await hooks.hit('origin-written');
  }
}

class CrashNoise implements DirectoryNoiseEngine {
  CrashNoise(this.hooks);
  final CrashHooks hooks;
  final delegate = const NativeDirectoryNoise();
  @override
  Future<Map<String, dynamic>> execute(Map<String, dynamic> input) async {
    final result = await delegate.execute(input);
    if (input['op'] == 'create') {
      // Только номер handle для отрицательной проверки после exec; ключи не экспортируются.
      await hooks.signal('handle-${hooks.role}', result['handle']);
    }
    return result;
  }
}

class CrashContext {
  CrashContext(this.hooks) {
    storage = CrashStorage(hooks);
    repository = DirectoryRepository(storage);
    vault = KeyIdentityVault(storage);
    preferences = CrashPreferences(hooks);
    service = DirectoryBackupService(repository, vault, preferences, () => {});
  }
  final CrashHooks hooks;
  late final CrashStorage storage;
  late final DirectoryRepository repository;
  late final KeyIdentityVault vault;
  late final CrashPreferences preferences;
  late final DirectoryBackupService service;
  Future<void> open() async {
    await preferences.load();
    requireCrash(
      preferences.error.isEmpty,
      'Ошибка загрузки настоящих SharedPreferences',
    );
  }

  Future<String> keyDigest() async {
    final record = await vault.load(existingOrigin);
    requireCrash(record != null, 'Исходная личность потеряна');
    return url64(
      (await Sha256().hash(utf8.encode(jsonEncode(record!.toJson())))).bytes,
    );
  }

  Future<Map<String, dynamic>> snapshot() async => {
    'state': await repository.read(),
    'settings': service.settings(),
    'settings_versions': preferences.settingsSnapshot.versions,
    'origins': List.of(preferences.origins),
    'key': await keyDigest(),
  };
  Future<void> noImportedKeys() async {
    for (final origin in incomingOrigins) {
      requireCrash(
        await vault.load(origin) == null,
        'Каталог создал рабочую личность',
      );
    }
  }

  Future<void> oldHandleRejected([String owner = 'target']) async {
    final handle = await hooks.read('handle-$owner');
    try {
      await const NativeDirectoryNoise().execute({
        'op': 'write_handshake',
        'handle': handle,
      });
    } catch (error) {
      requireCrash(
        error.toString().contains('expired'),
        'Handle отклонён по другой причине: $error',
      );
      return;
    }
    throw StateError('Прежний Noise handle пережил запуск нового процесса');
  }
}

bool sameCrashData(Object? a, Object? b) => jsonEncode(a) == jsonEncode(b);

DirectoryDocument crashDocument() => DirectoryDocument.parse({
  ...directoryDocument(count: 1500).data,
  'spaces': [
    directorySpace(count: 1500),
    {
      ...directorySpace(count: 1500),
      'origin': incomingOrigins[1],
      'endpoint': incomingOrigins[1],
      'server_id': 'srv_second',
      'server_key': url64(List.filled(32, 3)),
      'principal_id': 'u_${'c' * 64}',
    },
  ],
});
