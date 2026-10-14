import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/panels.dart';

void main() {
  for (final width in [390.0, 1280.0]) {
    testWidgets('Назначение и сброс клавиши отправки: $width', (tester) async {
      tester.view.physicalSize = Size(width, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      final preferences = AppPreferences();
      addTearDown(preferences.dispose);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: preferences.theme,
          home: Scaffold(body: SettingsPanel(preferences: preferences)),
        ),
      );
      await tester.pumpAndSettle();
      final field = find.byKey(const ValueKey('send-shortcut-enter'));
      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Shift').last);
      await tester.pumpAndSettle();
      expect(preferences.sendShortcut, 'shiftEnter');
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Вернуть Enter по умолчанию'));
      await tester.pumpAndSettle();
      expect(preferences.sendShortcut, 'enter');
      final restored = AppPreferences();
      await restored.load();
      expect(restored.sendShortcut, 'enter');
      restored.dispose();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
