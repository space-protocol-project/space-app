import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/preferences.dart';

class TestVault implements IdentityVault {
  @override
  Future<DeviceRecord?> load(String origin) async => null;
  @override
  Future<void> save(DeviceRecord record) async {}
}

class TestController extends ChatController {
  TestController() : super(TestVault());
  bool readOnly = false;
  @override
  bool get canWrite => connected && !readOnly;
  void server(Discovery value) {
    preview = value;
    notifyListeners();
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('Читатель видит чат без возможности отправки', (tester) async {
    tester.view.physicalSize = const Size(1100, 850);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = TestController()
      ..connected = true
      ..readOnly = true;
    controller.server(
      Discovery(
        localOrigin('http://127.0.0.1:8080'),
        'srv_test',
        List.filled(32, 1),
        9090,
      ),
    );
    await tester.pumpWidget(SpaceApp(controller: controller));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Общий чат'));
    await tester.pumpAndSettle();
    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('chat-draft')),
    );
    expect(field.enabled, false);
    expect(field.decoration?.hintText, 'Ваша роль разрешает только чтение');
    final send = tester.widget<IconButton>(
      find.byWidgetPredicate(
        (widget) => widget is IconButton && widget.tooltip == 'Отправить',
      ),
    );
    expect(send.onPressed, isNull);
    controller.dispose();
  });
  test('Личные настройки сохраняются отдельно от ключей', () async {
    final settings = AppPreferences();
    await settings.load();
    await settings.change(dark: false, compact: true, palette: 'iris');
    await settings.remember('http://127.0.0.1:8080');
    final reopened = AppPreferences();
    await reopened.load();
    expect(reopened.dark, false);
    expect(reopened.compact, true);
    expect(reopened.palette, 'iris');
    expect(reopened.origins, ['http://127.0.0.1:8080']);
    settings.dispose();
    reopened.dispose();
  });
  testWidgets('Навигация и смена темы сохраняют черновик', (tester) async {
    tester.view.physicalSize = const Size(1100, 850);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = TestController()..connected = true;
    final original = Discovery(
      localOrigin('http://127.0.0.1:8080'),
      'srv_test',
      List.filled(32, 1),
      9090,
    );
    controller.server(original);
    await tester.pumpWidget(SpaceApp(controller: controller));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Общий чат'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('chat-draft')),
      'Мысль, к которой хочется вернуться',
    );
    await tester.tap(find.byTooltip('Настройки оформления'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Мягкий ирис'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Общий чат'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
          .controller!
          .text,
      'Мысль, к которой хочется вернуться',
    );
    controller.server(
      Discovery(
        localOrigin('http://127.0.0.1:8081'),
        'srv_other',
        List.filled(32, 2),
        9091,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
          .controller!
          .text,
      isEmpty,
    );
    controller.server(original);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
          .controller!
          .text,
      'Мысль, к которой хочется вернуться',
    );
    await tester.tap(find.byTooltip('Поиск'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Встречи');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Встречи'));
    await tester.pumpAndSettle();
    expect(find.text('Быть рядом — по-разному.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });
  testWidgets(
    'Узкое окно, большие буквы и недоступные разделы не ломают компоновку',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const SpaceApp());
      await tester.pumpAndSettle();
      final destinations = find.byType(NavigationDestination);
      await tester.tap(destinations.at(2));
      await tester.pumpAndSettle();
      expect(find.text('Пока недоступно'), findsOneWidget);
      await tester.tap(find.byTooltip('Настройки оформления'));
      await tester.pumpAndSettle();
      expect(find.text('Оформление пространства'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
