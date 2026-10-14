import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/app_updates.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/shell.dart';

import 'redesign_device_test.dart' show DeviceController;

Future<void> waitForUser(WidgetTester tester, bool Function() ready) async {
  final deadline = DateTime.now().add(const Duration(minutes: 5));
  while (!ready() && DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 200));
  }
  expect(ready(), true, reason: 'Ожидаемое действие на телефоне не завершено');
  await tester.pumpAndSettle();
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.shouldPropagateDevicePointerEvents = true;
  testWidgets('Настоящая клавиатура, ориентация и системный Back', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences();
    final controller = DeviceController()..connected = true;
    controller.publishState();
    final updates = AppUpdates(
      readVersion: () async => '0.2.5',
      client: MockClient((_) async => http.Response('[]', 200)),
    );
    final instruction = ValueNotifier('Подготовка проверки');
    instruction.addListener(
      () => debugPrint('MANUAL_STEP ${instruction.value}'),
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox());
      await controller.close();
      preferences.dispose();
      instruction.dispose();
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: preferences.theme,
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AdminLocalizations.delegate,
          ...AppLocalizations.localizationsDelegates,
        ],
        home: Material(
          child: Column(
            children: [
              SafeArea(
                bottom: false,
                child: ValueListenableBuilder<String>(
                  valueListenable: instruction,
                  builder: (context, text, child) => Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(text, textAlign: TextAlign.center),
                  ),
                ),
              ),
              Expanded(
                child: SpaceShell(
                  preferences: preferences,
                  controller: controller,
                  updates: updates,
                  hostingEnabled: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('navigation-menu-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
    await tester.pumpAndSettle();
    final draft = find.byKey(const ValueKey('chat-draft'));
    String text() => tester.widget<TextField>(draft).controller!.text;
    instruction.value = 'Напечатай в поле: Проверка ввода';
    await tester.tap(draft);
    await waitForUser(tester, () => text().contains('Проверка ввода'));
    expect(tester.view.viewInsets.bottom, greaterThan(0));
    final visibleBottom =
        (tester.view.physicalSize.height - tester.view.viewInsets.bottom) /
        tester.view.devicePixelRatio;
    expect(tester.getRect(draft).bottom, lessThanOrEqualTo(visibleBottom));
    instruction.value =
        'Нажми системную кнопку или жест «Назад», чтобы закрыть клавиатуру';
    await waitForUser(tester, () => tester.view.viewInsets.bottom == 0);
    final savedDraft = text();
    instruction.value = 'Поверни телефон горизонтально';
    await waitForUser(
      tester,
      () => tester.view.physicalSize.width > tester.view.physicalSize.height,
    );
    expect(text(), savedDraft);
    instruction.value = 'Верни телефон вертикально';
    await waitForUser(
      tester,
      () => tester.view.physicalSize.width < tester.view.physicalSize.height,
    );
    expect(text(), savedDraft);
    final overview = find.widgetWithText(ListTile, 'Обзор').hitTestable();
    instruction.value = 'Открой меню свайпом от левого края';
    await waitForUser(tester, () => overview.evaluate().isNotEmpty);
    instruction.value = 'Закрой меню системной кнопкой или жестом «Назад»';
    await waitForUser(tester, () => overview.evaluate().isEmpty);
    expect(text(), savedDraft);
    expect(tester.takeException(), isNull);
    binding.reportData = {
      'platform': 'android-manual',
      'native_keyboard': true,
      'orientation_round_trip': true,
      'physical_edge_swipe': true,
      'system_back': true,
      'draft_preserved': true,
    };
    instruction.value =
        'Проверка прошла. Через несколько секунд тест закроет приложение.';
    await tester.pump(const Duration(seconds: 5));
  }, skip: !Platform.isAndroid);
}
