import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' show Content;
import 'package:space_client/ui/message_bubble.dart';

import 'shell_test.dart' show TestController;

class DesignController extends TestController {
  @override
  String get principalId => 'Алексей';
  @override
  List<Content> get messages => [
    Content(
      id: '1',
      authorId: 'Мария',
      text: 'Всем привет! Собрала первые идеи для нашего пространства.',
    ),
    Content(
      id: '2',
      authorId: 'Мария',
      text: 'Хочется, чтобы здесь было уютное место для общения.',
    ),
    Content(
      id: '3',
      authorId: 'Алексей',
      text: 'Отлично. Начнём с каналов и приглашений.',
    ),
    Content(
      id: '4',
      authorId: 'Илья',
      text: 'Мне нравится, что всё работает на нашем сервере.',
    ),
  ];
}

void main() {
  for (final width in [390.0, 1100.0, 1680.0]) {
    testWidgets('Пузырьки и навигация на ширине $width', (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = DesignController()..connected = true;
      controller.server(
        Discovery(
          localOrigin('http://127.0.0.1:8080'),
          'srv_preview',
          List.filled(32, 1),
        ),
      );
      if (Platform.environment['SPACE_DESIGN_PREVIEW'] == '1') {
        final icons = FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
        await icons.load();
        for (final font in {
          'Nunito': 'Nunito-Variable.ttf',
          'Nunito Sans': 'NunitoSans-Variable.ttf',
          'JetBrains Mono': 'JetBrainsMono-Variable.ttf',
        }.entries) {
          final loader = FontLoader(font.key)
            ..addFont(rootBundle.load('assets/fonts/${font.value}'));
          await loader.load();
        }
      }
      final boundary = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: SpaceApp(controller: controller),
        ),
      );
      await tester.pumpAndSettle();
      if (Platform.environment['SPACE_DESIGN_PREVIEW'] == '1') {
        await tester.runAsync(
          () => precacheImage(
            const AssetImage('assets/branding/space-app-icon.png'),
            boundary.currentContext!,
          ),
        );
        await tester.pumpAndSettle();
      }
      if (width < 760) {
        await tester.tap(find.byType(NavigationDestination).at(1));
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const ValueKey('server-inbox-http://127.0.0.1:8080')),
        );
      } else {
        await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
      }
      await tester.pumpAndSettle();
      expect(find.byType(MessageBubble), findsNWidgets(4));
      final bubbles = tester
          .widgetList<MessageBubble>(find.byType(MessageBubble))
          .toList();
      expect(bubbles[1].grouped, true);
      expect(bubbles[2].mine, true);
      expect(
        tester.getTopLeft(find.text(bubbles[2].text)).dx,
        greaterThan(tester.getTopLeft(find.text(bubbles[3].text)).dx),
      );
      expect(tester.takeException(), isNull);
      if (Platform.environment['SPACE_DESIGN_PREVIEW'] == '1' &&
          width == 1680) {
        await tester.runAsync(() async {
          final image =
              await (boundary.currentContext!.findRenderObject()
                      as RenderRepaintBoundary)
                  .toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final file = File('../docs/assets/guides/space-bubble-design.png');
          await file.parent.create(recursive: true);
          await file.writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    });
  }
}
