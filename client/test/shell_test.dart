import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/space_appearance.dart';
import 'package:space_client/ui/search.dart';

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
  bool get canQueue => canWrite;
  @override
  bool get canWrite => connected && !readOnly;
  void server(Discovery value) {
    preview = value;
    publishState();
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
  });
  testWidgets('Текст сообщения выше отдельного ряда кнопок', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = TestController()..connected = true;
    controller.server(
      Discovery(
        localOrigin('http://127.0.0.1:8080'),
        'srv_test',
        List.filled(32, 1),
      ),
    );
    await tester.pumpWidget(SpaceApp(controller: controller));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Комнаты'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
    await tester.pumpAndSettle();
    final field = find.byKey(const ValueKey('chat-draft'));
    await tester.enterText(
      field,
      'Первая строка\nВторая строка\nТретья строка',
    );
    await tester.pumpAndSettle();
    final send = find.byTooltip('Отправить');
    expect(
      tester.getRect(field).bottom,
      lessThanOrEqualTo(tester.getRect(send).top),
    );
    expect(
      tester.widget<TextField>(field).decoration!.border,
      InputBorder.none,
    );
    final composer = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.ancestor(of: field, matching: find.byType(GlassSurface)),
            matching: find.byType(DecoratedBox),
          ),
        )
        .firstWhere(
          (box) =>
              box.decoration is BoxDecoration &&
              (box.decoration as BoxDecoration).borderRadius ==
                  BorderRadius.circular(24),
        );
    expect((composer.decoration as BoxDecoration).color, isNotNull);
    final surface = find.ancestor(
      of: field,
      matching: find.byType(GlassSurface),
    );
    expect(tester.getSize(surface).height, greaterThanOrEqualTo(130));
    await tester.enterText(field, List.filled(30, 'Строка').join('\n'));
    await tester.pumpAndSettle();
    expect(tester.getSize(surface).height, lessThanOrEqualTo(900 / 3 + .5));
    final scrolling = tester.state<ScrollableState>(
      find.descendant(of: field, matching: find.byType(Scrollable)).first,
    );
    expect(scrolling.position.maxScrollExtent, greaterThan(0));

    expect(find.text('Space'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });
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
      ),
    );
    await tester.pumpWidget(SpaceApp(controller: controller));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
    await tester.pumpAndSettle();
    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('chat-draft')),
    );
    expect(field.enabled, false);
    expect(
      field.decoration?.hintText,
      'В этом чате нельзя отправлять сообщения',
    );
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
    await settings.change(dark: false, palette: 'iris');
    await settings.remember('http://127.0.0.1:8080');
    final reopened = AppPreferences();
    await reopened.load();
    expect(reopened.dark, false);
    expect(reopened.theme.visualDensity, VisualDensity.compact);
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
    );
    controller.server(original);
    await tester.pumpWidget(SpaceApp(controller: controller));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('chat-draft')),
      'Мысль, к которой хочется вернуться',
    );
    await tester.tap(find.byTooltip('Настройки приложения'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Мягкий ирис'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
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
    await tester.enterText(
      find.byKey(const ValueKey('space-search-input')),
      'Обзор',
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(SpaceSearchPanel),
        matching: find.widgetWithText(ListTile, 'Обзор'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Чаты и ресурсы сервера.'), findsOneWidget);
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
      expect(
        find.text('Идентичности и ключи этого устройства.'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('app-settings-tab')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        3,
      );
      expect(find.text('Настройки приложения'), findsWidgets);
      expect(find.text('Оформление пространства'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
