import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/device_migration.dart';
import 'package:space_client/src/files.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/mls/files.dart';

import '../../tool/attachment_policy_fixture.dart';
import '../../tool/home_transfer_drill.dart' as transfer;
import 'clean_install_support.dart';
import 'clean_install_data.dart';
import 'directory_crash_windows.dart';

Future<void> seedCleanPeer(
  CleanContext c,
  transfer.RunningSpace running,
  SpaceSession owner,
  MlsClient mls,
  List<int> group,
) async {
  await enableFixtureAttachments(owner);
  final invite = await owner.adminRequest(
    '/api/v1/space/invites',
    method: 'POST',
    body: {'role': 'member', 'ttlSeconds': 3600, 'maxUses': 1},
  );
  final peerStorage = c.peerStorage;
  final peer = await SpaceSession.connect(
    running.discovery,
    KeyIdentityVault(peerStorage),
    invitationToken: invite['token'] as String,
  );
  try {
    final client = await cleanClient(
      peer,
      peerStorage,
      Directory(p.join(c.work.path, 'peer-locks')),
    );
    await client.initialize();
    final roster = await mls.devices('private');
    for (final device in roster) {
      await mls.trust(device);
      await client.trust(device);
    }
    await mls.invite(
      'private',
      roster.firstWhere((d) => d.grantId == peer.record.grantId),
    );
    await client.refresh('private', group);
    await MlsFiles(client).send('private', group, 'Файл до переноса', [
      SpaceFile.fromData(
        cleanFileBytes,
        name: 'restore.bin',
        path: 'restore.bin',
      ),
    ]);
    await mls.refresh('private', group);
  } finally {
    await peer.close();
  }
}

Future<void> seedCleanInstall(CleanContext c) async {
  await c.homeRoot.create(recursive: true);
  await File(p.join(c.homeRoot.path, 'config.json'))
      .writeAsString('{"ip":"203.0.113.10"}');
  final running = await transfer.startSpace(
    c.executable,
    c.runtime,
    c.homeRoot,
    '203.0.113.10',
    bindHost: '127.0.0.3',
  );
  try {
    final owner = await SpaceSession.connect(
      running.discovery,
      c.vault,
      setupCode: running.setupCode,
    );
    try {
      final mls = await cleanClient(
        owner,
        c.storage,
        Directory(p.join(c.profile.path, 'locks')),
      );
      await mls.createChannel('private', 'Чистая установка');
      await owner.refreshChannels();
      final group = owner.availableChannels
          .firstWhere((ch) => ch.id == 'private')
          .mlsGroupId;
      await mls.send('private', 'До переноса');
      await seedCleanPeer(c, running, owner, mls, group);
      await c.expectedFile.writeAsString(
        jsonEncode({
          'origin': owner.record.origin,
          'server_id': owner.record.serverId,
          'server_key': owner.record.serverKey,
          'tls': owner.record.tlsFingerprint,
          'principal': owner.principalId,
          'grant': owner.record.grantId,
          'seed_hash': cleanHash(owner.record.deviceSeed),
          'group': group,
        }),
        flush: true,
      );
      final preferences = await SharedPreferences.getInstance();
      requireClean(
        await preferences.setStringList('space.ui.origins', [
          owner.record.origin,
        ]),
        'Не сохранены пространства',
      );
      requireClean(
        await preferences.setString('space.ui.palette', 'iris'),
        'Не сохранена палитра',
      );
      await seedCleanData(c, owner);
    } finally {
      await owner.close();
    }
  } finally {
    await running.stop();
  }
  final home = await c.home(source: true);
  try {
    await (await c.migration(home)).export(c.archive.path, '');
  } finally {
    await home.close();
  }
  await verifyCleanRetirement(c);
}

Future<void> verifyCleanRetirement(CleanContext c) async {
  requireClean(
    await c.storage.read(key: DeviceMigration.exportKey) != null,
    'Нет отметки экспорта',
  );
  var rejected = false;
  try {
    await c.vault.load((await c.expected())['origin'] as String);
  } on StateError {
    rejected = true;
  }
  requireClean(rejected, 'Прежние ключи всё ещё активны');
}

Future<void> restoreCleanInstall(CleanContext c) async {
  final preferences = await SharedPreferences.getInstance();
  requireClean(
    preferences.getKeys().isEmpty,
    'Получатель не является чистой установкой',
  );
  requireClean(
    await c.storage.read(key: DeviceMigration.importKey) == null,
    'Найдена прежняя квитанция',
  );
  requireClean(
    await c.vault.load((await c.expected())['origin'] as String) == null,
    'У получателя уже есть ключи',
  );
  final home = await c.home();
  try {
    final migration = await c.migration(home);
    var wrongPasswordRejected = false;
    try {
      await migration.restore(
        c.archive.path,
        'Неверный пароль',
        publicIP: '203.0.113.10',
      );
    } catch (_) {
      wrongPasswordRejected = true;
    }
    requireClean(
      wrongPasswordRejected &&
          await c.storage.read(key: DeviceMigration.importKey) == null,
      'Неверный пароль изменил получателя',
    );
    await migration.restore(c.archive.path, '', publicIP: '203.0.113.10');
  } finally {
    await home.close();
  }
  await verifyCleanSettings(c, palette: 'iris');
}

Future<void> verifyCleanSettings(
  CleanContext c, {
  required String palette,
}) async {
  final preferences = await SharedPreferences.getInstance();
  requireClean(
    preferences.getString('space.ui.palette') == palette,
    'Не сохранена палитра',
  );
  await verifyCleanData(c);
  final marker = await c.storage.read(key: DeviceMigration.importKey);
  requireClean(
    marker != null && marker.endsWith(':complete'),
    'Импорт не завершён',
  );
  final files = await Directory(p.join(c.profile.path, 'system-storage'))
      .list()
      .toList();
  final vaultFiles = files.whereType<File>().where(
    (f) => f.path.endsWith('.dat'),
  );
  requireClean(vaultFiles.isNotEmpty, 'Нет файлов системного vault');
  final bytes = await vaultFiles.first.readAsBytes();
  requireClean(
    bytes.length > 20 &&
        bytes[0] == 1 &&
        bytes[1] == 0 &&
        bytes[2] == 0 &&
        bytes[3] == 0,
    'Не подтверждён DPAPI',
  );
}

void verifyCleanIdentity(SpaceSession owner, Map<String, dynamic> expected) {
  requireClean(
    owner.record.serverId == expected['server_id'] &&
        owner.record.serverKey == expected['server_key'] &&
        owner.record.tlsFingerprint == expected['tls'],
    'Изменилась идентичность сервера',
  );
  requireClean(
    owner.principalId == expected['principal'] &&
        owner.record.grantId == expected['grant'] &&
        cleanHash(owner.record.deviceSeed) == expected['seed_hash'],
    'Изменились ключи владельца',
  );
}

Future<void> verifyCleanHistory(
  MlsClient mls,
  List<int> group, {
  required bool again,
}) async {
  final view = await mls.refresh('private', group);
  final messages = view.messages.map((m) => m['message'] as Map).toList();
  requireClean(
    messages.where((m) => m['text'] == 'До переноса').length == 1,
    'Потеряна история',
  );
  if (again) {
    requireClean(
      messages.where((m) => m['text'] == 'После переноса').length == 1,
      'Откат исходящего сообщения',
    );
    requireClean(
      messages.where((m) => m['text'] == 'Ответ после переноса').length == 1,
      'Откат ответа',
    );
  }
  final message = messages.singleWhere((m) => m['text'] == 'Файл до переноса');
  final descriptor = Map<String, dynamic>.from(
    (message['files'] as List).single as Map,
  );
  final bytes = await MlsFiles(mls)
      .download(group, (message['id'] as List).cast<int>(), descriptor);
  requireClean(
    cleanHash(bytes) == cleanHash(cleanFileBytes),
    'Повреждён зашифрованный файл',
  );
}

Future<void> exchangeCleanMessages(
  CleanContext c,
  transfer.RunningSpace running,
  MlsClient owner,
  List<int> group, {
  required bool again,
}) async {
  final storage = c.peerStorage;
  final peer = await SpaceSession.connect(
    running.discovery,
    KeyIdentityVault(storage),
  );
  try {
    final mls = await cleanClient(
      peer,
      storage,
      Directory(p.join(c.work.path, 'peer-locks')),
    );
    final text = again ? 'После второго запуска' : 'После переноса';
    final reply = again
        ? 'Ответ после второго запуска'
        : 'Ответ после переноса';
    await owner.send('private', text);
    final received = await mls.refresh('private', group);
    requireClean(
      received.messages
              .where((m) => (m['message'] as Map)['text'] == text)
              .length ==
          1,
      'Второй участник не прочитал сообщение',
    );
    await mls.send('private', reply);
    final result = await owner.refresh('private', group);
    requireClean(
      result.messages
              .where((m) => (m['message'] as Map)['text'] == reply)
              .length ==
          1,
      'Владелец не прочитал ответ',
    );
  } finally {
    await peer.close();
  }
}

Future<void> verifyCleanInstall(CleanContext c, {required bool again}) async {
  await verifyCleanSettings(c, palette: again ? 'ocean' : 'iris');
  final running = await transfer.startSpace(
    c.executable,
    c.runtime,
    Directory(p.join(c.homeRoot.path, 'transferred')),
    '203.0.113.10',
    bindHost: '127.0.0.3',
  );
  try {
    final owner = await SpaceSession.connect(running.discovery, c.vault);
    try {
      final expected = await c.expected();
      verifyCleanIdentity(owner, expected);
      final group = (expected['group'] as List).cast<int>();
      final mls = await cleanClient(
        owner,
        c.storage,
        Directory(p.join(c.profile.path, 'locks')),
      );
      await verifyCleanHistory(mls, group, again: again);
      await exchangeCleanMessages(c, running, mls, group, again: again);
      if (!again) {
        final before = jsonEncode(await mls.local.read());
        final preferences = await SharedPreferences.getInstance();
        requireClean(
          await preferences.setString('space.ui.palette', 'ocean'),
          'Не сохранено новое значение',
        );
        final home = await c.home();
        try {
          await (await c.migration(home)).restore(c.archive.path, '');
        } finally {
          await home.close();
        }
        requireClean(
          jsonEncode(await mls.local.read()) == before,
          'Повтор импорта откатил MLS',
        );
        await verifyCleanSettings(c, palette: 'ocean');
      }
    } finally {
      await owner.close();
    }
  } finally {
    await running.stop();
  }
}

Future<void> main() async {
  if (Platform.environment['GITHUB_ACTIONS'] != 'true' || !Platform.isWindows) {
    exit(2);
  }
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    stderr.writeln(details.exceptionAsString());
    exit(1);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    stderr.writeln('$error\n$stack');
    exit(1);
  };
  runApp(
    const MaterialApp(home: Scaffold(body: Text('Clean installation CI'))),
  );
  await WidgetsBinding.instance.endOfFrame;
  try {
    await initializeCrashWindows();
    final c = CleanContext();
    final phase = Platform.environment['CLEAN_INSTALL_PHASE'];
    switch (phase) {
      case 'source':
        await seedCleanInstall(c);
      case 'source-check':
        await verifyCleanRetirement(c);
      case 'restore':
        await restoreCleanInstall(c);
      case 'verify':
        await verifyCleanInstall(c, again: false);
      case 'verify-again':
        await verifyCleanInstall(c, again: true);
      default:
        throw StateError('Неизвестная фаза');
    }
    await File(p.join(c.work.path, 'done-$phase.json')).writeAsString(
      jsonEncode({'phase': phase, 'success': true, 'pid': pid}),
      flush: true,
    );
    exit(0);
  } catch (error, stack) {
    stderr.writeln('$error\n$stack');
    exit(1);
  }
}
