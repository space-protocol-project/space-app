import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/core.dart';

import 'chat_design_test.dart' show DesignController;
import 'redesign_golden_test.dart' show loadFonts;

void main() {
  for (final scenario in [
    (width: 390.0, expanded: true),
    (width: 1280.0, expanded: true),
    (width: 1280.0, expanded: false),
  ]) {
    final width = scenario.width;
    testWidgets('Меню: ширина $width, раскрыто ${scenario.expanded}', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'space.ui.dark': true});
      tester.view.physicalSize = Size(width, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.runAsync(loadFonts);
      final controller = DesignController()..connected = true;
      controller.server(
        Discovery(
          localOrigin('http://127.0.0.1:8080'),
          'srv_preview',
          List.filled(32, 1),
        ),
      );
      const boundary = ValueKey('navigation-golden');
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: SpaceApp(controller: controller),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(
        () => precacheImage(
          const AssetImage('assets/branding/space-app-icon.png'),
          tester.element(find.byType(MaterialApp)),
        ),
      );
      await tester.pumpAndSettle();
      final menu = find.byKey(const ValueKey('navigation-menu-button'));
      if (width < 760) {
        await tester.tap(menu);
        await tester.pumpAndSettle();
      }
      await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
      await tester.pumpAndSettle();
      if (width < 760) {
        await tester.tap(menu);
        await tester.pumpAndSettle();
      }
      if (width >= 760 && !scenario.expanded) {
        await tester.tap(menu);
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      if (Platform.isWindows) {
        await expectLater(
          find.byKey(boundary),
          matchesGoldenFile(
            'goldens/navigation-${scenario.expanded ? 'reveal' : 'collapsed'}-${width.toInt()}.png',
          ),
        );
      }
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(controller.close);
    });
  }
}
