import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/ui/space_frame.dart';

import 'shell_test.dart' show TestController;

Iterable<String> navigationLabels(WidgetTester tester) => tester.semantics
    .simulatedAccessibilityTraversal()
    .map((node) => node.label);

void main() {
  for (final width in [320.0, 390.0, 760.0, 1280.0, 1800.0]) {
    testWidgets('Меню под содержимым: ширина $width', (tester) async {
      tester.view.physicalSize = Size(width, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final compact = width < 760;
      var opened = false, contentTaps = 0, navigationTaps = 0;
      late StateSetter change;
      final navigationFocus = FocusNode();
      addTearDown(navigationFocus.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              change = setState;
              return Scaffold(
                body: SpaceFrame(
                  compact: compact,
                  navigationOpen: opened,
                  openNavigation: () => change(() => opened = true),
                  closeNavigation: () => change(() => opened = false),
                  rail: const ColoredBox(
                    key: ValueKey('rail'),
                    color: Colors.red,
                  ),
                  sidebar: ColoredBox(
                    key: const ValueKey('navigation'),
                    color: Colors.blue,
                    child: TextButton(
                      focusNode: navigationFocus,
                      onPressed: () => navigationTaps++,
                      child: const Text('Выбрать канал'),
                    ),
                  ),
                  content: GestureDetector(
                    onTap: () => contentTaps++,
                    child: const ColoredBox(
                      color: Colors.green,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: TextField(key: ValueKey('draft')),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      final foreground = find.byKey(const ValueKey('space-content'));
      final navigation = find.byKey(const ValueKey('navigation'));
      final field = find.byKey(const ValueKey('draft'));
      final originalElement = tester.element(field);
      await tester.enterText(field, 'Сохранённый черновик');
      expect(navigationFocus.canRequestFocus, false);
      expect(navigationLabels(tester), isNot(contains('Выбрать канал')));
      await tester.tapAt(const Offset(150, 400));
      expect(contentTaps, 1);
      expect(navigationTaps, 0);
      expect(
        find.byKey(const ValueKey('rail')).hitTestable(),
        compact ? findsNothing : findsOneWidget,
      );
      final closed = tester.getRect(foreground);
      final navigationBefore = tester.getRect(navigation);

      change(() => opened = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final moving = tester.getRect(foreground);
      expect(moving.left, greaterThan(closed.left));
      await tester.pumpAndSettle();
      final revealed = tester.getRect(foreground);
      expect(revealed.left, greaterThan(moving.left));
      expect(tester.getRect(navigation), navigationBefore);
      expect(navigationFocus.canRequestFocus, true);
      expect(navigationLabels(tester), contains('Выбрать канал'));
      if (compact) {
        expect(revealed.width, closed.width);
        expect(width - revealed.left, greaterThanOrEqualTo(56));
      } else {
        expect(revealed.width, lessThan(closed.width));
        expect(revealed.right, closed.right);
      }
      await tester.tap(find.text('Выбрать канал'));
      expect(navigationTaps, 1);
      await tester.tapAt(Offset(revealed.left + 20, 400));
      await tester.pumpAndSettle();
      expect(contentTaps, compact ? 1 : 2);
      if (!compact) change(() => opened = false);
      await tester.pumpAndSettle();
      expect(tester.getRect(foreground), closed);
      expect(navigationFocus.canRequestFocus, false);
      expect(navigationLabels(tester), isNot(contains('Выбрать канал')));
      expect(tester.element(field), same(originalElement));
      expect(
        tester.widget<TextField>(field).controller?.text ??
            tester
                .widget<EditableText>(find.byType(EditableText))
                .controller
                .text,
        'Сохранённый черновик',
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Сворачивание панели сохраняет полосу иконок, чат и выбор', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = TestController()..connected = true;
    controller.server(
      Discovery(
        localOrigin('http://127.0.0.1:8080'),
        'srv_navigation',
        List.filled(32, 1),
      ),
    );
    await tester.pumpWidget(SpaceApp(controller: controller));
    await tester.pumpAndSettle();
    final menu = find.byKey(const ValueKey('navigation-menu-button'));
    final foreground = find.byKey(const ValueKey('space-content'));
    final channels = find.widgetWithText(ListTile, 'Чаты');
    final railSettings = find.byKey(const ValueKey('app-settings-tab'));
    await tester.tap(channels);
    await tester.pumpAndSettle();
    final draft = find.byKey(const ValueKey('chat-draft'));
    await tester.enterText(draft, 'Черновик в широком окне');
    final draftElement = tester.element(draft);
    final initialWidth = tester.getSize(foreground).width;
    await tester.tap(menu);
    await tester.pumpAndSettle();
    expect(tester.getSize(foreground).width, greaterThan(initialWidth));
    expect(channels.hitTestable(), findsNothing);
    expect(railSettings.hitTestable(), findsOneWidget);
    expect(find.byTooltip('Открыть навигацию'), findsOneWidget);
    await tester.tap(menu);
    await tester.pumpAndSettle();
    expect(channels.hitTestable(), findsOneWidget);
    expect(railSettings.hitTestable(), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(channels.hitTestable(), findsNothing);
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    await tester.tap(menu);
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(1280, 844);
    await tester.pumpAndSettle();
    expect(tester.getSize(foreground).width, greaterThan(initialWidth));
    expect(tester.element(draft), same(draftElement));
    expect(
      tester.widget<TextField>(draft).controller!.text,
      'Черновик в широком окне',
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(controller.close);
  });

  testWidgets('Отключённые анимации сразу открывают и закрывают меню', (
    tester,
  ) async {
    var opened = false;
    late StateSetter change;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: StatefulBuilder(
            builder: (context, setState) {
              change = setState;
              return SpaceFrame(
                compact: true,
                navigationOpen: opened,
                rail: const SizedBox(),
                sidebar: const SizedBox(),
                content: const SizedBox(),
              );
            },
          ),
        ),
      ),
    );
    final foreground = find.byKey(const ValueKey('space-content'));
    expect(tester.getTopLeft(foreground).dx, 0);
    change(() => opened = true);
    await tester.pump();
    expect(tester.getTopLeft(foreground).dx, 320);
    change(() => opened = false);
    await tester.pump();
    expect(tester.getTopLeft(foreground).dx, 0);
    expect(tester.takeException(), isNull);
  });
}
