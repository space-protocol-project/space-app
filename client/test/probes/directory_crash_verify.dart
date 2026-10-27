import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/directory_document.dart';

import '../fixtures/directory.dart' show directorySpace;
import 'directory_crash_support.dart';

Future<void> initializeCrashTarget(CrashContext context) async {
  final record = DeviceRecord(origin: existingOrigin, serverId: 'srv_existing',
    serverKey: url64(List.filled(32, 9)), rootSeed: List.filled(32, 7), deviceSeed: List.filled(32, 6));
  await context.vault.save(record);
  final state = await context.repository.read();
  (state['catalog'] as Map)[existingOrigin] = {
    ...directorySpace(count: 0), 'origin': existingOrigin, 'endpoint': existingOrigin,
    'server_id': record.serverId, 'server_key': record.serverKey,
    'tls_fingerprint': '', 'principal_id': (await record.identity()).principalId,
  };
  await context.repository.write(state);
  await context.preferences.change(themeMode: ThemeMode.light, palette: 'ocean', language: 'en', uiScale: 1.25);
  await context.preferences.changeNotifications(2);
  await context.preferences.remember(existingOrigin);
  await context.preferences.flush();
  await context.hooks.signal('baseline', await context.snapshot());
}

Future<void> verifyCrashUnapplied(CrashContext context) async {
  final before = await context.hooks.read('baseline');
  requireCrash(sameCrashData(await context.snapshot(), before), 'Неподтверждённый каталог изменил профиль');
  await context.service.resume();
  requireCrash(sameCrashData(await context.snapshot(), before), 'Resume применил каталог без журнала');
  await context.noImportedKeys();
}

Future<void> requirePinFailure(Future<void> Function() action) async {
  try {
    await action();
  } on FormatException {
    return;
  }
  throw StateError('Подмена закрепления не заблокирована');
}

Future<void> verifyCrashPins(CrashContext context, DirectoryDocument document) async {
  for (final space in document.spaces) {
    final origin = Uri.parse(space['origin'] as String);
    final id = space['server_id'] as String, tls = space['tls_fingerprint'] as String;
    final key = base64Url.decode(base64Url.normalize(space['server_key'] as String));
    await context.repository.checkTrust(Discovery(origin, id, key, tlsFingerprint: tls));
    await requirePinFailure(() => context.repository.checkTrust(Discovery(origin, id, List.filled(32, 8), tlsFingerprint: tls)));
  }
  final saved = await context.vault.load(existingOrigin);
  await context.repository.checkRecord(saved!);
  final other = DeviceRecord(origin: existingOrigin, serverId: saved.serverId,
    serverKey: saved.serverKey, rootSeed: List.filled(32, 8), deviceSeed: List.filled(32, 6));
  await requirePinFailure(() => context.repository.checkRecord(other));
}

Future<void> verifyCrashApplied(CrashContext context) async {
  final document = DirectoryDocument.parse(await context.hooks.read('expected'));
  final baseline = await context.hooks.read('baseline') as Map;
  final state = await context.repository.read(), catalog = state['catalog'] as Map;
  requireCrash(state['pending'] == null && catalog.length == 3, 'Журнал не завершён');
  requireCrash((state['heads'] as Map).length == 1, 'Повтор создал лишнюю голову');
  final head = (state['heads'] as Map)[document.id] as Map;
  requireCrash(head['revision'] == 1 && head['digest'] == await document.digest(), 'Изменена голова копии');
  requireCrash(sameCrashData(catalog[existingOrigin], (baseline['state'] as Map)['catalog'][existingOrigin]), 'Изменено прежнее закрепление');
  for (final space in document.spaces) {
    requireCrash(sameCrashData(catalog[space['origin']], space), 'Повреждён снимок каталога или подписок');
  }
  requireCrash(sameCrashData(context.preferences.origins, [...incomingOrigins, existingOrigin]), 'Повтор или потеря пространства');
  final settings = context.hooks.replace ? document.settings : baseline['settings'];
  requireCrash(sameCrashData(context.service.settings(), settings), 'Настройки не соответствуют явному выбору');
  requireCrash(await context.keyDigest() == baseline['key'], 'Изменена существующая личность');
  await context.noImportedKeys();
  await verifyCrashPins(context, document);
  final before = await context.snapshot();
  await context.service.resume();
  requireCrash(sameCrashData(await context.snapshot(), before), 'Повтор resume не идемпотентен');
  // Без авторизации снимок хранится, но удалённые подписки не создаются.
  final results = await context.service.restoreFollowing();
  requireCrash(results.length == 3, 'Не проверены ограничения авторизации');
  requireCrash(sameCrashData(await context.snapshot(), before), 'Неавторизованное восстановление изменило каталог');
}
