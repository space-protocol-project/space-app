import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_installation.dart';

import 'home_installation_test.dart' show installed, release;
import 'support/temp_directory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory root;
  late HomeBackupPreferences preferences;
  var supported = true;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-backup-policy-');
    supported = true;
    preferences = HomeBackupPreferences(
      root,
      Directory('${root.path}/runtime'),
      tool: (_, _) async => {'scheduledBackupsVersion': supported ? 1 : 0},
    );
  });
  tearDown(() => deleteTestDirectory(root, prefix: 'space-backup-policy-'));

  test('По умолчанию расписание и удаление выключены; настройки сохраняются после открытия', () async {
    expect((await preferences.load()).policy.enabled, false);
    expect((await preferences.load()).policy.prune, false);
    const policy = HomeBackupPolicy(
      enabled: true,
      prune: true,
      intervalHours: 6,
      keepCount: 5,
      keepDays: 14,
      maxBytes: 1024 * 1024,
    );
    await preferences.save(policy);
    final reopened = HomeBackupPreferences(
      root,
      Directory('${root.path}/runtime'),
      tool: (_, _) async => {'scheduledBackupsVersion': 1},
    );
    expect((await reopened.load()).policy.toJson(), policy.toJson());
    expect(await root.list().map((e) => e.path).toList(), [
      '${root.path}${Platform.pathSeparator}backup-policy.json',
    ]);
    await reopened.save(const HomeBackupPolicy());
    expect((await reopened.load()).policy.enabled, false);
  });

  test(
    'Старый runtime не включает расписание, отключение остаётся доступным',
    () async {
      supported = false;
      await expectLater(
        preferences.save(const HomeBackupPolicy(enabled: true)),
        throwsFormatException,
      );
      expect(await File('${root.path}/backup-policy.json').exists(), false);
      await preferences.save(const HomeBackupPolicy());
      expect((await preferences.load()).policy.enabled, false);
    },
  );

  test('Неправильные лимиты не заменяют сохранённую политику', () async {
    await preferences.save(const HomeBackupPolicy());
    for (final policy in [
      const HomeBackupPolicy(keepCount: 2),
      const HomeBackupPolicy(intervalHours: 0),
      const HomeBackupPolicy(keepDays: 0),
      const HomeBackupPolicy(maxBytes: -1),
    ]) {
      await expectLater(preferences.save(policy), throwsFormatException);
    }
    expect((await preferences.load()).policy.keepCount, 7);
  });

  test(
    'Статус runtime отображается без секретных полей и некорректных дат',
    () async {
      await File('${root.path}/backup-status.json').writeAsString(
        jsonEncode({
          'format': 1,
          'code': 'space_low',
          'lastSuccessAt': 1760000000000,
          'nextAt': 1760000060000,
          'count': 3,
          'bytes': 1234,
          'protected': 2,
          'limited': true,
          'serverId': 'server',
          'policy': 'hash',
        }),
      );
      final status = (await preferences.load()).status;
      expect(status.code, 'space_low');
      expect(status.count, 3);
      expect(status.limited, true);
      expect(
        () => HomeBackupStatus.fromJson({'format': 1, 'code': 'raw secret'}),
        throwsFormatException,
      );
    },
  );

  test('Контроллер сохраняет настройки работающего сервера и блокирует другую операцию', () async {
    final installation = HomeInstallation(root);
    await installed(installation, release('v0.5.0'));
    await installation.selectInitial(release('v0.5.0'));
    final home = HomeController(
      directory: () async => root,
      release: () async => release('v0.5.0'),
      transferTool: (_, _) async => {'scheduledBackupsVersion': 1},
    );
    addTearDown(home.dispose);
    home.running = true;
    await home.saveBackupPolicy(const HomeBackupPolicy(enabled: true));
    expect(home.running, true);
    expect((await home.backupSettings())!.policy.enabled, true);
    home.busy = true;
    await expectLater(
      home.saveBackupPolicy(const HomeBackupPolicy()),
      throwsStateError,
    );
    home.busy = false;
    home.running = false;
  });
}
