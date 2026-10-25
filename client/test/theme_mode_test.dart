import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/window_theme.dart';
import 'package:space_client/ui/shell.dart';
import 'package:space_client/ui/space_appearance.dart';
import 'package:space_client/ui/theme_mode_picker.dart';

import 'shell_test.dart' show TestController;
import 'feed_test.dart' show app;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('прежний выбор сохраняется; автоматический режим следует системе и переживает перезапуск', () async {
    SharedPreferences.setMockInitialValues({'space.ui.dark': false});
    final prefs = AppPreferences();
    await prefs.load();
    expect(prefs.themeMode, ThemeMode.light);
    expect(prefs.dark, isFalse);
    await prefs.updateSystemBrightness(Brightness.dark);
    expect(prefs.dark, isFalse);
    await prefs.change(themeMode: ThemeMode.system);
    expect(prefs.dark, isTrue);
    await prefs.updateSystemBrightness(Brightness.light);
    expect(prefs.dark, isFalse);
    await prefs.flush();
    final reopened = AppPreferences();
    await reopened.load();
    expect(reopened.themeMode, ThemeMode.system);
    await reopened.updateSystemBrightness(Brightness.dark);
    expect(reopened.dark, isTrue);
    await reopened.change(themeMode: ThemeMode.dark);
    await reopened.updateSystemBrightness(Brightness.light);
    expect(reopened.dark, isTrue);
    await prefs.close();
    await reopened.close();
  });

  test('светлая рамка и shell совпадают; тёмные цвета сохранены', () async {
    SharedPreferences.setMockInitialValues({});
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final calls = <Map<Object?, Object?>>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(windowThemeChannel, (call) async {
          calls.add(Map<Object?, Object?>.from(call.arguments as Map));
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(windowThemeChannel, null),
    );
    final prefs = AppPreferences();
    await prefs.load();
    await prefs.change(themeMode: ThemeMode.light);
    await updateWindowTheme(prefs.theme);
    expect(calls.last['background'], 0xFFDEDACE);
    expect(
      calls.last['background'],
      prefs.theme.extension<SpaceAppearance>()!.background.toARGB32(),
    );
    expect(calls.last['dark'], isFalse);
    await prefs.change(themeMode: ThemeMode.dark);
    await updateWindowTheme(prefs.theme);
    expect(calls.last['background'], 0xFF1D2021);
    expect(calls.last['foreground'], 0xFFEBDBB2);
    await prefs.close();
  });

  testWidgets('выбор темы содержит три режима', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = AppPreferences();
    await prefs.load();
    await tester.pumpWidget(
      app(
        BlocBuilder<AppPreferences, PreferencesState>(
          bloc: prefs,
          builder: (_, state) =>
              ThemeModePicker(preferences: prefs, mode: state.themeMode),
        ),
      ),
    );
    await tester.tap(find.byType(DropdownButtonFormField<ThemeMode>));
    await tester.pumpAndSettle();
    expect(find.text('Автоматическая'), findsOneWidget);
    expect(find.text('Светлая'), findsOneWidget);
    await tester.tap(find.text('Автоматическая'));
    await tester.pumpAndSettle();
    expect(prefs.themeMode, ThemeMode.system);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(prefs.close);
  });

  testWidgets('системное изменение переключает уже открытое приложение', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'space.ui.themeMode': 'system'});
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final controller = TestController();
    await tester.pumpWidget(SpaceApp(controller: controller));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(SpaceShell))).brightness,
      Brightness.light,
    );
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(SpaceShell))).brightness,
      Brightness.dark,
    );
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(controller.close);
  });
}
