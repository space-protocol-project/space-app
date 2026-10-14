import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/space_appearance.dart';

import 'shell_test.dart' show TestController;

void main() {
  testWidgets(
    'Мобильное меню: жесты, Back, фокус и черновик при смене ширины',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = TestController()..connected = true;
      controller.server(
        Discovery(
          localOrigin('http://127.0.0.1:8080'),
          'test',
          List.filled(32, 1),
        ),
      );
      await tester.pumpWidget(SpaceApp(controller: controller));
      await tester.pumpAndSettle();
      final menu = find.byKey(const ValueKey('mobile-navigation'));
      final menuButton = find.byKey(const ValueKey('navigation-menu-button'));
      final draft = find.byKey(const ValueKey('chat-draft'));
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
      expect(tester.getRect(menu).width, lessThanOrEqualTo(342));
      await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
      await tester.pumpAndSettle();
      await tester.enterText(draft, 'Мобильный черновик');
      await tester.dragFrom(const Offset(5, 250), const Offset(120, 0));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<IgnorePointer>(
              find
                  .ancestor(of: menu, matching: find.byType(IgnorePointer))
                  .first,
            )
            .ignoring,
        false,
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(draft).focusNode!.hasFocus, true);
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
      await tester.dragFrom(const Offset(220, 250), const Offset(-150, 0));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<IgnorePointer>(
              find
                  .ancestor(of: menu, matching: find.byType(IgnorePointer))
                  .first,
            )
            .ignoring,
        true,
      );
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(1280, 800);
      await tester.pumpAndSettle();
      expect(menu, findsNothing);
      expect(
        tester.widget<TextField>(draft).controller!.text,
        'Мобильный черновик',
      );
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(draft).controller!.text,
        'Мобильный черновик',
      );
      expect(
        tester
            .widget<IgnorePointer>(
              find
                  .ancestor(of: menu, matching: find.byType(IgnorePointer))
                  .first,
            )
            .ignoring,
        true,
      );
      await tester.dragFrom(const Offset(5, 250), const Offset(0, -100));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<IgnorePointer>(
              find
                  .ancestor(of: menu, matching: find.byType(IgnorePointer))
                  .first,
            )
            .ignoring,
        true,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(controller.close);
    },
  );

  testWidgets('Поле растёт до трети окна, затем прокручивает текст внутри', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    final controller = TestController()..connected = true;
    controller.publishState();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatView(controller: controller, openConnection: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final field = find.byKey(const ValueKey('chat-draft'));
    final surface = find.ancestor(
      of: field,
      matching: find.byType(GlassSurface),
    );
    final original = tester.getSize(surface).height;
    await tester.enterText(field, List.filled(8, 'Строка текста').join('\n'));
    await tester.pumpAndSettle();
    expect(tester.getSize(surface).height, greaterThan(original + 60));
    await tester.enterText(field, List.filled(30, 'Строка текста').join('\n'));
    await tester.pumpAndSettle();
    expect(tester.getSize(surface).height, inInclusiveRange(260, 300));
    final scrolling = tester.state<ScrollableState>(
      find.descendant(of: field, matching: find.byType(Scrollable)).first,
    );
    expect(scrolling.position.maxScrollExtent, greaterThan(0));
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expect(tester.getRect(surface).bottom, lessThanOrEqualTo(600));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(controller.close);
  });
}
