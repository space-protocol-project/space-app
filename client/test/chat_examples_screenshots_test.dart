import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/attachment_gallery.dart';
import 'package:space_client/ui/shell.dart';

import 'redesign_golden_test.dart' show loadFonts;
import 'support/chat_examples.dart';

Future<void> captureExample(
  WidgetTester tester,
  GlobalKey boundary,
  String path,
) async {
  expect(tester.takeException(), isNull);
  await tester.runAsync(() async {
    final image =
        await (boundary.currentContext!.findRenderObject()
                as RenderRepaintBoundary)
            .toImage(pixelRatio: 1.5);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

Future<void> waitForGallery(WidgetTester tester) async {
  for (var i = 0; i < 500; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
    if (tester
            .widgetList<RawImage>(
              find.descendant(
                of: find.byType(AttachmentGallery, skipOffstage: false),
                matching: find.byType(RawImage, skipOffstage: false),
              ),
            )
            .where((v) => v.image != null)
            .length >=
        3) {
      return;
    }
  }
  fail('Мини-галерея не загрузилась');
}

Widget exampleApp(ExampleController controller, AppPreferences preferences) {
  final theme = preferences.theme;
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme.copyWith(
      textTheme: theme.textTheme.apply(fontFamilyFallback: ['Segoe UI Emoji']),
    ),
    locale: const Locale('ru'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: [
      AdminLocalizations.delegate,
      ...AppLocalizations.localizationsDelegates,
    ],
    home: SpaceShell(preferences: preferences, controller: controller),
  );
}

Future<void> loadExampleFonts() async {
  await loadFonts();
  final bytes = await File('C:/Windows/Fonts/seguiemj.ttf').readAsBytes();
  final emoji = FontLoader('Segoe UI Emoji')
    ..addFont(Future.value(ByteData.sublistView(bytes)));
  await emoji.load();
}

void main() {
  final output = Platform.environment['SPACE_CHAT_SCREENSHOTS'];
  for (final example in [
    'reactions',
    'files',
    'gallery',
    'markdown',
    'favorites',
  ]) {
    testWidgets('Снимок настоящего чата: $example', (tester) async {
      SharedPreferences.setMockInitialValues({'space.ui.dark': true});
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.runAsync(loadExampleFonts);
      final preferences = AppPreferences();
      addTearDown(preferences.dispose);
      final files = ExampleFiles();
      if (example == 'gallery') await tester.runAsync(files.prepare);
      final controller = ExampleController(example, files)..connected = true;
      controller.server(
        Discovery(
          localOrigin('http://127.0.0.1:8080'),
          'srv_examples',
          List.filled(32, 1),
        ),
      );
      final boundary = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: exampleApp(controller, preferences),
        ),
      );
      if (example == 'gallery') {
        await waitForGallery(tester);
      } else {
        await tester.pumpAndSettle();
      }
      await tester.runAsync(
        () => precacheImage(
          const AssetImage('assets/branding/space-app-icon.png'),
          boundary.currentContext!,
        ),
      );
      await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
      if (example == 'gallery') {
        await tester.pump();
        await waitForGallery(tester);
      } else {
        await tester.pumpAndSettle();
      }
      await tester.pump(const Duration(milliseconds: 300));
      await captureExample(tester, boundary, '$output/chat-$example.png');
      if (example == 'favorites') {
        await tester.tap(find.widgetWithText(ListTile, 'Избранные сообщения'));
        await tester.pumpAndSettle();
        await captureExample(
          tester,
          boundary,
          '$output/favorites-participants.png',
        );
      }
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(controller.close);
    }, skip: output == null);
  }
}
