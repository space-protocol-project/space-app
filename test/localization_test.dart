import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/preferences.dart';

void main() {
  for (final entry in {
    'ru': ['Хорошо, что вы здесь.', 'Настройки', 'Язык приложения'],
    'zh-Hans': ['欢迎你来到这里。', '设置', '应用语言'],
    'en': ['Good to have you here.', 'Settings', 'App language'],
  }.entries) {
    testWidgets('Оболочка и настройки: ${entry.key}, широкое и узкое окно', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'space.ui.language': entry.key});
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1440, 900);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const SpaceApp());
      await tester.pumpAndSettle();
      expect(find.text(entry.value[0]), findsOneWidget);
      await tester.tap(find.widgetWithText(ListTile, entry.value[1]));
      await tester.pumpAndSettle();
      expect(find.text(entry.value[2]), findsOneWidget);
      expect(tester.takeException(), isNull);
      tester.view.physicalSize = const Size(430, 900);
      await tester.pumpAndSettle();
      expect(find.text(entry.value[2]), findsOneWidget);
      expect(tester.takeException(), isNull);
      if (entry.key == 'ru') {
        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('English').last);
        await tester.pumpAndSettle();
        expect(find.text('App language'), findsOneWidget);
        final saved = await SharedPreferences.getInstance();
        expect(saved.getString('space.ui.language'), 'en');
        expect(tester.takeException(), isNull);
      }
    });
  }

  test(
    'Выбор языка сохраняется; неизвестный язык не заменяет выбранный',
    () async {
      SharedPreferences.setMockInitialValues({'space.ui.language': 'unknown'});
      final preferences = AppPreferences();
      await preferences.load();
      expect(preferences.language, 'ru');
      await preferences.change(language: 'zh-Hans');
      expect(preferences.locale.scriptCode, 'Hans');
      await preferences.change(language: 'unknown');
      final restored = AppPreferences();
      await restored.load();
      expect(restored.language, 'zh-Hans');
      preferences.dispose();
      restored.dispose();
    },
  );
}
