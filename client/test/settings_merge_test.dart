import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_document.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/settings_snapshot.dart';

import 'fixtures/directory.dart';

final actorA = url64(List.filled(16, 40)), actorB = url64(List.filled(16, 41));
SettingsSnapshot edit(
  SettingsSnapshot base,
  String field,
  Object value,
  String actor,
) => base.observe({...base.values, field: value}, actor);

class InterruptedSettings extends AppPreferences {
  @override
  Future<void> applyMergedSettings(
    SettingsSnapshot before,
    SettingsSnapshot target,
    Future<void> Function() persist,
  ) async {
    await persist();
    throw StateError('Процесс остановлен после сохранения журнала');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final base = SettingsSnapshot.initial(settingsDefaults);

  test('Независимые параметры объединяются и повтор не создаёт ревизию', () {
    final a = edit(base, 'palette', 'ocean', actorA);
    final b = edit(base, 'language', 'en', actorB);
    final merged = SettingsMerge(a, b).resolve(actorA, {});
    expect(merged.values['palette'], 'ocean');
    expect(merged.values['language'], 'en');
    expect(SettingsMerge(merged, b).resolve(actorA, {}).same(merged), isTrue);
    expect(SettingsMerge(b, a).resolve(actorB, {}).same(merged), isTrue);
  });
  test('Конкурентные значения требуют выбора; локальный выбор учитывает обе стороны', () {
    final a = edit(base, 'palette', 'ocean', actorA);
    final b = edit(base, 'palette', 'iris', actorB);
    final merge = SettingsMerge(a, b);
    expect(merge.conflicts, ['palette']);
    expect(() => merge.resolve(actorA, {}), throwsFormatException);
    final result = merge.resolve(actorA, {'palette': SettingsChoice.local});
    expect(result.values['palette'], 'ocean');
    expect(result.versions['palette'], {actorA: 2, actorB: 1});
    expect(SettingsMerge(result, b).conflicts, isEmpty);
    expect(SettingsMerge(result, b).resolve(actorA, {}).same(result), isTrue);
  });
  test('Одинаковые значения объединяют историю без новой ревизии', () {
    final a = edit(base, 'palette', 'iris', actorA);
    final b = edit(base, 'palette', 'iris', actorB);
    final result = SettingsMerge(a, b).resolve(actorA, {});
    expect(result.versions['palette'], {actorA: 1, actorB: 1});
  });
  test(
    'Более старое значение не побеждает; одинаковые часы не скрывают подмену',
    () {
      final first = edit(base, 'palette', 'ocean', actorA);
      final next = edit(first, 'palette', 'iris', actorA);
      expect(SettingsMerge(next, first).resolve(actorA, {}).same(next), isTrue);
      final fork = edit(base, 'palette', 'iris', actorA);
      expect(SettingsMerge(first, fork).conflicts, ['palette']);
    },
  );
  test('Лимиты истории и счётчиков проверяются без усечения', () {
    final full = {for (var i = 0; i < 32; i++) url64(List.filled(16, i)): 1};
    expect(() => joinSettingsClocks(full, {actorA: 1}), throwsFormatException);
    expect(
      () => advanceSettingsClock({actorA: directoryMaxInteger}, actorA),
      throwsFormatException,
    );
    for (final value in [0, -1, 1.0, directoryMaxInteger + 1]) {
      expect(
        () => checkedSettingsClock({actorA: value}),
        throwsFormatException,
      );
    }
    expect(() => checkedSettingsClock({'../path': 1}), throwsFormatException);
    expect(
      () => SettingsSnapshot.parse({...base.data, 'extra': 1}),
      throwsFormatException,
    );
    expect(
      () =>
          SettingsSnapshot.create(base.values, {...base.versions, 'extra': {}}),
      throwsFormatException,
    );
  });
  test(
    'Файл v1 читается без изменения digest; неизвестная история требует выбора',
    () async {
      final old = directoryDocument(version: 1);
      expect(old.hasSettingsVersions, isFalse);
      expect(
        DirectoryDocument.parse(jsonDecode(jsonEncode(old.data))).encode(),
        old.encode(),
      );
      final merge = SettingsMerge(base, old.settingsSnapshot, unknown: true);
      expect(merge.conflicts, contains('palette'));
      expect(() => merge.resolve(actorA, {}), throwsFormatException);
      final modern = directoryDocument();
      expect(modern.hasSettingsVersions, isTrue);
      expect(
        () => modern.data['settings_versions']['palette'][actorA] = 2,
        throwsUnsupportedError,
      );
    },
  );
  test(
    'Возобновление сохраняет последующее локальное изменение и идемпотентно',
    () {
      final prepared = edit(base, 'palette', 'iris', actorB);
      final later = edit(base, 'palette', 'ocean', actorA);
      final resumed = resumeSettingsSnapshot(base, prepared, later, actorA);
      expect(resumed.values['palette'], 'ocean');
      expect(resumed.versions['palette'], {actorA: 2, actorB: 1});
      expect(
        resumeSettingsSnapshot(base, prepared, resumed, actorA).same(resumed),
        isTrue,
      );
    },
  );
  test('Повреждённый либо откатывающий журнал отклоняется', () {
    final later = edit(base, 'language', 'en', actorA);
    expect(
      () => checkedSettingsPending({
        'v': 2,
        'before': later.data,
        'after': base.data,
      }),
      throwsFormatException,
    );
    expect(
      () => checkedSettingsPending({
        'v': 2,
        'before': base.data,
        'after': base.data,
        'extra': true,
      }),
      throwsFormatException,
    );
  });
  test('Повторяющиеся JSON-ключи не меняют смысл или digest каталога', () {
    final raw = utf8.decode(directoryDocument().encode());
    final repeated = raw.replaceFirst('"v":2', '"v":2,"v":2');
    expect(() => decodeDirectoryDocument(utf8.encode(repeated)), throwsFormatException);
    final replica = SettingsReplica();
    final duplicate = replica.encode().replaceFirst('"v":1', '"v":1,"v":1');
    expect(() => SettingsReplica.parse(duplicate), throwsFormatException);
  });

  setUp(() => SharedPreferences.setMockInitialValues({}));
  AppPreferences preferences() {
    final prefs = AppPreferences();
    addTearDown(prefs.close);
    return prefs;
  }

  DirectoryBackupService service(
    AppPreferences prefs, [
    DirectoryStorage? storage,
  ]) => DirectoryBackupService(
    DirectoryRepository(storage ?? DirectoryStorage()),
    DirectoryVault(),
    prefs,
    () => {},
  );

  test(
    'Значения и версии переживают запуск; системная яркость не меняет историю',
    () async {
      final prefs = preferences();
      await prefs.load();
      await prefs.change(themeMode: ThemeMode.system, palette: 'ocean');
      final snapshot = prefs.settingsSnapshot;
      await prefs.updateSystemBrightness(Brightness.light);
      await prefs.updateSystemBrightness(Brightness.dark);
      expect(prefs.settingsSnapshot.same(snapshot), isTrue);
      final reopened = preferences();
      await reopened.load();
      expect(reopened.settingsActor, prefs.settingsActor);
      expect(reopened.settingsSnapshot.same(snapshot), isTrue);
    },
  );
  test(
    'Обычные изменения сериализованы с фиксацией согласованного плана',
    () async {
      final prefs = preferences();
      await prefs.load();
      final before = prefs.settingsSnapshot;
      final target = edit(before, 'language', 'zh-Hans', actorB);
      final entered = Completer<void>(), release = Completer<void>();
      final apply = prefs.applyMergedSettings(before, target, () async {
        entered.complete();
        await release.future;
      });
      await entered.future;
      final change = prefs.change(language: 'en');
      release.complete();
      await apply;
      await change;
      expect(prefs.language, 'en');
      expect(prefs.settingsSnapshot.versions['language'], {
        actorB: 1,
        prefs.settingsActor: 1,
      });
    },
  );
  test(
    'Без согласия каталог применяется, значения и версии настроек сохраняются',
    () async {
      final prefs = preferences();
      await prefs.change(palette: 'ocean');
      final before = prefs.settingsSnapshot;
      final backup = service(prefs);
      final plan = await backup.preview(directoryDocument());
      expect(plan.settingsMerge.conflicts, contains('palette'));
      await backup.apply(plan, mergeSettings: false);
      expect(prefs.settingsSnapshot.same(before), isTrue);
      expect(prefs.origins, contains('https://space.example'));
    },
  );
  test('Возврат к прежнему значению после preview всё равно делает план устаревшим', () async {
    final prefs = preferences(), storage = DirectoryStorage();
    final backup = service(prefs, storage);
    final plan = await backup.preview(directoryDocument());
    await prefs.change(palette: 'ocean');
    await prefs.change(palette: 'gruvbox');
    await expectLater(
      backup.apply(plan, mergeSettings: true),
      throwsFormatException,
    );
    expect(storage.values, isEmpty);
  });
  test('Конфликт блокирует запись до выбора; выбранный результат не конфликтует повторно', () async {
    final prefs = preferences(), storage = DirectoryStorage();
    await prefs.change(palette: 'ocean');
    final backup = service(prefs, storage);
    final document = directoryDocument();
    var plan = await backup.preview(document);
    await expectLater(
      backup.apply(plan, mergeSettings: true),
      throwsFormatException,
    );
    expect(storage.values, isEmpty);
    await backup.apply(
      plan,
      mergeSettings: true,
      settingsChoices: {'palette': SettingsChoice.local},
    );
    expect(prefs.palette, 'ocean');
    final before = prefs.settingsSnapshot;
    plan = await backup.preview(document);
    expect(plan.settingsMerge.conflicts, isEmpty);
    await backup.apply(plan, mergeSettings: true);
    expect(prefs.settingsSnapshot.same(before), isTrue);
  });
  test('После сбоя перед записью настроек повтор сохраняет более поздний локальный выбор', () async {
    final prefs = InterruptedSettings(), storage = DirectoryStorage();
    addTearDown(prefs.close);
    final backup = service(prefs, storage);
    final plan = await backup.preview(directoryDocument());
    await expectLater(
      backup.apply(plan, mergeSettings: true),
      throwsStateError,
    );
    expect((await backup.repository.read())['pending'], isNotNull);
    await prefs.change(palette: 'ocean');
    await backup.resume();
    expect(prefs.palette, 'ocean');
    expect((await backup.repository.read())['pending'], isNull);
    final reopened = preferences();
    await reopened.load();
    expect(reopened.settingsSnapshot.same(prefs.settingsSnapshot), isTrue);
    final stable = prefs.settingsSnapshot;
    await backup.resume();
    expect(prefs.settingsSnapshot.same(stable), isTrue);
  });
  test('Повреждённые ревизии не заменяются молча новыми', () async {
    SharedPreferences.setMockInitialValues({
      AppPreferences.settingsStorageKey: '{"v":999}',
    });
    final prefs = preferences();
    await prefs.load();
    expect(prefs.error, isNotEmpty);
    await expectLater(prefs.exportSettings(), throwsStateError);
    expect(
      (await SharedPreferences.getInstance()).getString(
        AppPreferences.settingsStorageKey,
      ),
      '{"v":999}',
    );
  });
}
