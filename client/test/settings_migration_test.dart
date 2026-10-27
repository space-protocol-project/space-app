import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/device_migration_settings.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/settings_snapshot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  AppPreferences create() {
    final prefs = AppPreferences();
    addTearDown(prefs.close);
    return prefs;
  }
  test('Старый полный архив не перекрывается новой записью по умолчанию', () async {
    await create().load();
    final storage = await SharedPreferences.getInstance();
    expect(storage.containsKey(versionedSettingsStorageKey), isTrue);
    await writeDeviceSettings(storage, {'space.ui.palette':'iris','space.ui.dark':false});
    final restored = create();
    await restored.load();
    expect(restored.palette, 'iris');
    expect(restored.themeMode, ThemeMode.light);
    final reopened = create();
    await reopened.load();
    expect(reopened.settingsActor, restored.settingsActor);
    expect(reopened.settingsSnapshot.same(restored.settingsSnapshot), isTrue);
  });
  test('Снимок настроек полного переноса сохраняет историю установки', () async {
    final source = create();
    await source.change(palette:'ocean');
    final storage = await SharedPreferences.getInstance();
    final raw = storage.getString(versionedSettingsStorageKey)!;
    await writeDeviceSettings(storage, {versionedSettingsStorageKey:raw});
    final restored = create();
    await restored.load();
    expect(restored.settingsSnapshot.same(source.settingsSnapshot), isTrue);
    expect(restored.settingsActor, source.settingsActor);
  });
  test('Повреждённая история отвергается до изменения существующих параметров', () async {
    final prefs = create();
    await prefs.change(palette:'ocean');
    final storage = await SharedPreferences.getInstance();
    final before = storage.getString(versionedSettingsStorageKey);
    await expectLater(writeDeviceSettings(storage, {
      'space.ui.language':'en',versionedSettingsStorageKey:'{"v":999}',
    }), throwsFormatException);
    expect(storage.getString(versionedSettingsStorageKey), before);
    expect(storage.getString('space.ui.language'), isNull);
  });
}
