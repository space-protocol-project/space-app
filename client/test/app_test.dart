import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets(
    'Подключение обязательно; интерфейс помещается в широкое и узкое окно',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1440, 900);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final font = File('C:/Windows/Fonts/segoeui.ttf');
      if (font.existsSync()) {
        final loader = FontLoader('Segoe UI')
          ..addFont(Future.value(ByteData.sublistView(font.readAsBytesSync())));
        await loader.load();
      }
      final icons = File(
        '${Platform.environment['FLUTTER_ROOT'] ?? 'C:/Users/vostr/code/flutter'}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      );
      if (icons.existsSync()) {
        final loader = FontLoader(
          'MaterialIcons',
        )..addFont(Future.value(ByteData.sublistView(icons.readAsBytesSync())));
        await loader.load();
      }
      final boundary = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(key: boundary, child: const SpaceApp()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Все ваши пространства — рядом.'), findsOneWidget);
      expect(find.text('О пространстве'), findsNothing);
      await tester.tap(find.byTooltip('Добавить пространство').first);
      await tester.pumpAndSettle();
      expect(find.text('Проверить сервер'), findsOneWidget);
      await tester.tap(find.byTooltip('Закрыть подключение'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final output = Platform.environment['SPACE_PREVIEW_DIR'];
      if (output != null) {
        final render =
            boundary.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await render.toImage();
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          Directory(output).createSync(recursive: true);
          File('$output/space-client.png')
              .writeAsBytesSync(data!.buffer.asUint8List());
          image.dispose();
        });
        for (final screen in {
          'Мой доступ и устройства': 'client-identity',
          'Настройки': 'client-settings',
        }.entries) {
          await tester.tap(find.widgetWithText(ListTile, screen.key));
          await tester.pumpAndSettle();
          await tester.runAsync(() async {
            final image = await render.toImage();
            final data = await image.toByteData(format: ui.ImageByteFormat.png);
            File('$output/${screen.value}.png')
                .writeAsBytesSync(data!.buffer.asUint8List());
            image.dispose();
          });
        }
      }
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('chat-draft')), findsNothing);
      expect(find.byTooltip('Отправить'), findsNothing);
      await tester.tap(find.byTooltip('Добавить пространство'));
      await tester.pumpAndSettle();
      expect(find.text('Проверить сервер'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
