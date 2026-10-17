import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_update_journal.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/local_failure.dart';

import 'home_installation_test.dart' show release;

import 'support/temp_directory.dart';

void main() {
  late Directory root;
  late HomeUpdateJournal journal;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('space-update-journal-');
    journal = HomeUpdateJournal(root);
  });
  tearDown(() => deleteTestDirectory(root, prefix: 'space-update-journal-'));

  test('HomeController не запускает и не загружает сервер при незавершённой операции', () async {
    await journal.begin(release('v0.1.0'), release('v0.2.0'));
    final home = HomeController(
      directory: () async => root,
      release: () async {
        fail('Выбор нового выпуска при незавершённой операции');
      },
    );
    addTearDown(home.dispose);
    expect(await home.start('203.0.113.10'), isNull);
    expect(home.failureCode, LocalFailureCode.homeUpdatePending);
    expect(await Directory('${root.path}/data').exists(), false);
    expect(await File('${root.path}/config.json').exists(), false);
  });

  test(
    'Каждый незавершённый шаг переживает перезапуск и блокирует обычный запуск',
    () async {
      final record = await journal.begin(release('v0.1.0'), release('v0.2.0'));
      for (final step in [
        HomeUpdateStep.preparing,
        HomeUpdateStep.staged,
        HomeUpdateStep.stopped,
        HomeUpdateStep.backedUp,
        HomeUpdateStep.migrating,
        HomeUpdateStep.verified,
        HomeUpdateStep.activating,
      ]) {
        if (step != HomeUpdateStep.preparing) {
          await journal.advance(record.id, step);
        }
        final reopened = HomeUpdateJournal(root);
        expect((await reopened.read())!.step, step);
        expect((await reopened.read())!.source.version, 'v0.1.0');
        await expectLater(reopened.requireSettled(), throwsFormatException);
      }
      await journal.advance(record.id, HomeUpdateStep.completeUpdated);
      await HomeUpdateJournal(root).requireSettled();
    },
  );
  test('После начала миграций отмена запрещена; требуется подтверждённое восстановление', () async {
    final record = await journal.begin(release('v0.1.0'), release('v0.2.0'));
    for (final step in [
      HomeUpdateStep.staged,
      HomeUpdateStep.stopped,
      HomeUpdateStep.backedUp,
      HomeUpdateStep.migrating,
    ]) {
      await journal.advance(record.id, step);
    }
    expect((await journal.read())!.recovery, HomeRecoveryAction.restoreBackup);
    await expectLater(
      journal.advance(record.id, HomeUpdateStep.cancelled),
      throwsFormatException,
    );
    await journal.advance(record.id, HomeUpdateStep.restoring);
    await journal.advance(record.id, HomeUpdateStep.restored);
    await expectLater(journal.requireSettled(), throwsFormatException);
    await journal.advance(record.id, HomeUpdateStep.completeRestored);
    await journal.requireSettled();
  });
  test(
    'Старая операция и пропуск резервной копии не могут изменить журнал',
    () async {
      final record = await journal.begin(release('v0.1.0'), release('v0.2.0'));
      await expectLater(
        journal.advance('update-${'0' * 32}', HomeUpdateStep.staged),
        throwsFormatException,
      );
      await expectLater(
        journal.advance(record.id, HomeUpdateStep.migrating),
        throwsFormatException,
      );
      await expectLater(
        journal.begin(release('v0.1.0'), release('v0.3.0')),
        throwsFormatException,
      );
      expect((await journal.read())!.step, HomeUpdateStep.preparing);
      await journal.advance(record.id, HomeUpdateStep.staged);
      expect(
        (await journal.advance(record.id, HomeUpdateStep.staged)).step,
        HomeUpdateStep.staged,
      );
    },
  );
  test('Повреждённый журнал и один временный файл блокируют запуск', () async {
    await File('${journal.file.path}.tmp').writeAsString('{');
    await expectLater(journal.requireSettled(), throwsFormatException);
    await journal.file.writeAsString('{');
    await expectLater(journal.requireSettled(), throwsFormatException);
  });
  test(
    'Повреждённый журнал диагностируется даже при повреждённой конфигурации',
    () async {
      await journal.file.writeAsString('{');
      await File('${root.path}/config.json').writeAsString('{');
      final home = HomeController(
        directory: () async => root,
        release: () async => release('v0.2.0'),
      );
      addTearDown(home.dispose);
      await home.load();
      expect(home.pendingUpdate, true);
      expect(home.recoveryBlocked, true);
      expect(home.failureCode, LocalFailureCode.homeJournalInvalid);
      expect(home.recoverySummary, contains(root.path));
    },
  );
  test(
    'Неподтверждённый временный журнал не считается завершённой операцией',
    () async {
      await File('${journal.file.path}.tmp').writeAsString('{');
      await expectLater(
        journal.read(),
        throwsA(
          isA<LocalFailure>().having(
            (e) => e.code,
            'code',
            LocalFailureCode.homeJournalInvalid,
          ),
        ),
      );
    },
  );
  test('Версии, платформа и пути операции проверяются при чтении', () async {
    final record = await journal.begin(release('v0.1.0'), release('v0.2.0'));
    await journal.file.writeAsString(
      jsonEncode({...record.toJson(), 'id': '../data'}),
    );
    await expectLater(journal.read(), throwsFormatException);
  });
  test('Отмена подготовки допускает новую операцию без миграций', () async {
    final record = await journal.begin(release('v0.1.0'), release('v0.2.0'));
    await journal.advance(record.id, HomeUpdateStep.cancelled);
    await journal.requireSettled();
    final next = await journal.begin(release('v0.1.0'), release('v0.3.0'));
    expect(next.id, isNot(record.id));
    expect(next.backupPath, startsWith('backups/update-'));
  });
}
