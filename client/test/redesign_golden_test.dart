import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/core.dart';

import 'chat_design_test.dart' show DesignController;

Future<void> loadFonts() async {
  for (final entry in {
    'Nunito': 'assets/fonts/Nunito-Variable.ttf',
    'Nunito Sans': 'assets/fonts/NunitoSans-Variable.ttf',
    'JetBrains Mono': 'assets/fonts/JetBrainsMono-Variable.ttf',
    'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
  }.entries) {
    await (FontLoader(entry.key)..addFont(rootBundle.load(entry.value))).load();
  }
}

void main() {
  for (final dark in [true, false]) {
    for (final size in [
      const Size(390, 844),
      const Size(768, 1024),
      const Size(1280, 800),
      const Size(1667, 1267),
    ]) {
      testWidgets('Переписка ${dark ? 'тёмная' : 'светлая'} ${size.width}', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({'space.ui.dark': dark});
        tester.view.physicalSize = size;
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
        const key = ValueKey('redesign-golden');
        await tester.pumpWidget(
          RepaintBoundary(
            key: key,
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
        if (size.width < 760) {
          await tester.tap(find.byType(NavigationDestination).at(1));
          await tester.pumpAndSettle();
          await tester.tap(
            find.byKey(const ValueKey('server-inbox-http://127.0.0.1:8080')),
          );
          await tester.pumpAndSettle();
          await tester.tap(
            find.byKey(const ValueKey('navigation-menu-button')),
          );
          await tester.pumpAndSettle();
          await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
        } else {
          await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        // Эталоны сняты на Windows: другие ОС проверяют компоновку ниже.
        // Пиксельное сравнение обязательно выполняется Windows-задачей CI.
        if (Platform.isWindows && (size.width == 390 || size.width == 1280)) {
          await expectLater(
            find.byKey(key),
            matchesGoldenFile(
              'goldens/quiet-space-${dark ? 'dark' : 'light'}-${size.width.toInt()}.png',
            ),
          );
        }
        if (size.width == 1280) {
          await tester.tap(find.byKey(const ValueKey('space-details')));
          await tester.pump();
          expect(find.byType(Dialog), findsOneWidget);
          expect(tester.takeException(), isNull);
          if (Platform.isWindows) {
            await expectLater(
              find.byKey(key),
              matchesGoldenFile(
                'goldens/quiet-space-details-${dark ? 'dark' : 'light'}.png',
              ),
            );
          }
        }
        await tester.pumpWidget(const SizedBox());
        await tester.runAsync(controller.close);
      });
    }
  }
}
