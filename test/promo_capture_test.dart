import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';

// Запуск: SPACE_PROMO_CAPTURE_DIR=<каталог> flutter test test/promo_capture_test.dart
void main() {
  final output = Platform.environment['SPACE_PROMO_CAPTURE_DIR'];
  testWidgets('Снимки основного Flutter-интерфейса для промостраницы', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(() async {
      for (final entry in {
        'Nunito': 'Nunito',
        'Nunito Sans': 'NunitoSans',
        'JetBrains Mono': 'JetBrainsMono',
      }.entries) {
        final loader = FontLoader(
          entry.key,
        )..addFont(rootBundle.load('assets/fonts/${entry.value}-Variable.ttf'));
        await loader.load();
      }
      final icons = FontLoader('MaterialIcons')
        ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
      await icons.load();
    });
    const key = ValueKey('promo-boundary');
    await tester.pumpWidget(const RepaintBoundary(key: key, child: SpaceApp()));
    await tester.pumpAndSettle();
    await tester.runAsync(
      () => precacheImage(
        const AssetImage('assets/branding/space-app-icon.png'),
        tester.element(find.byType(MaterialApp)),
      ),
    );
    await tester.pumpAndSettle();
    for (final entry in {
      'chat': 'Общий чат',
      'settings': 'Настройки',
      'identity': 'Идентичность',
    }.entries) {
      await tester.tap(find.widgetWithText(ListTile, entry.value));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(key),
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 1);
        try {
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          await File('$output/${entry.key}.png')
              .writeAsBytes(data!.buffer.asUint8List());
        } finally {
          image.dispose();
        }
      });
    }
    await tester.pumpWidget(const SizedBox());
  }, skip: output == null);
}
