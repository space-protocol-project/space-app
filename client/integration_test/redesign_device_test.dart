import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/app_updates.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' show Content;
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/favorite_messages.dart';
import 'package:space_client/ui/shell.dart';

import '../test/shell_test.dart' show TestController;

class DeviceController extends TestController {
  @override
  String get principalId => 'Алексей';
  @override
  bool isFavorite(Content message) =>
      ['device-0', 'device-1'].contains(message.id);
  final records = List<Content>.generate(
    300,
    (index) => Content(
      id: 'device-$index',
      authorId: index.isEven ? 'Мария' : 'Алексей',
      text: 'Сообщение $index. Проверка прокрутки настоящего интерфейса.',
    ),
  );
  @override
  List<Content> get messages => records;
}

Future<void> checkBookmarks(WidgetTester tester) async {
  if (!Platform.isWindows) return;
  final semantics = tester.ensureSemantics();
  final mouse = await tester.createGesture(kind: ui.PointerDeviceKind.mouse);
  await mouse.addPointer(location: const Offset(700, 100));
  final markers = find.descendant(
    of: find.byType(FavoriteMessages),
    matching: find.byType(InkWell),
  );
  for (var count = 0; count < 10; count++) {
    await mouse.moveTo(tester.getCenter(markers.at(count % 2)));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Сообщение ${count % 2}. Проверка прокрутки настоящего интерфейса.',
      ),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  }
  await mouse.moveTo(const Offset(700, 100));
  await tester.pumpAndSettle();
  await mouse.removePointer();
  semantics.dispose();
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Навигация и черновик на настоящем Flutter target', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences()
      ..effects = const bool.fromEnvironment(
        'SPACE_EFFECTS',
        defaultValue: true,
      );
    final controller = DeviceController()..connected = true;
    controller.publishState();
    final updates = AppUpdates(
      readVersion: () async => '0.2.5',
      client: MockClient((_) async => http.Response('[]', 200)),
    );
    final screenshotKey = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: screenshotKey,
        child: MaterialApp(
          theme: preferences.theme,
          locale: const Locale('ru'),
          localizationsDelegates: const [
            AdminLocalizations.delegate,
            ...AppLocalizations.localizationsDelegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: SpaceShell(
            preferences: preferences,
            controller: controller,
            updates: updates,
            hostingEnabled: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final draft = find.byKey(const ValueKey('chat-draft'));
    final menu = find.byKey(const ValueKey('navigation-menu-button'));
    if (menu.evaluate().isNotEmpty) {
      await tester.tap(menu);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
    await tester.pumpAndSettle();
    await tester.tap(draft);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    binding.reportData ??= {};
    binding.reportData!['platform'] = Platform.operatingSystem;
    binding.reportData!['effects'] = preferences.effects;
    binding.reportData!['device_pixel_ratio'] = tester.view.devicePixelRatio;
    binding.reportData!['physical_width'] = tester.view.physicalSize.width;
    binding.reportData!['physical_height'] = tester.view.physicalSize.height;
    binding.reportData!['keyboard_inset'] = tester.view.viewInsets.bottom;
    if (Platform.isAndroid) {
      expect(tester.view.viewInsets.bottom, greaterThan(0));
      final visibleBottom =
          (tester.view.physicalSize.height - tester.view.viewInsets.bottom) /
          tester.view.devicePixelRatio;
      expect(tester.getRect(draft).bottom, lessThanOrEqualTo(visibleBottom));
    }
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    tester.testTextInput.register();
    addTearDown(tester.testTextInput.unregister);
    await tester.enterText(draft, 'Черновик на устройстве\nВторая строка');
    await tester.pumpAndSettle();
    if (menu.evaluate().isNotEmpty) {
      await tester.dragFrom(const Offset(5, 250), const Offset(120, 0));
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(ListTile, 'Обзор').hitTestable(),
        findsOneWidget,
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
    }
    expect(
      tester.widget<TextField>(draft).controller!.text,
      'Черновик на устройстве\nВторая строка',
    );
    await binding.watchPerformance(() async {
      final history = find.descendant(
        of: find.byType(ChatView),
        matching: find.byType(ListView),
      );
      for (var count = 0; count < 6; count++) {
        await tester.timedDrag(
          history,
          const Offset(0, -400),
          const Duration(milliseconds: 400),
        );
        await tester.pumpAndSettle();
      }
    }, reportKey: 'history_scroll');
    final history = find.descendant(
      of: find.byType(ChatView),
      matching: find.byType(ListView),
    );
    expect(
      tester.widget<ListView>(history).controller!.offset,
      greaterThan(500),
    );
    await checkBookmarks(tester);
    await tester.tap(find.byTooltip('Поиск'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    final boundary =
        screenshotKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final picture = await boundary.toImage();
    final bytes = await picture.toByteData(format: ui.ImageByteFormat.png);
    binding.reportData!['search_screenshot'] = base64Encode(
      bytes!.buffer.asUint8List(),
    );
    picture.dispose();
    Navigator.of(tester.element(find.byType(Dialog))).pop();
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(draft).controller!.text,
      'Черновик на устройстве\nВторая строка',
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await controller.close();
    preferences.dispose();
  });

  testWidgets('Физическая камера возвращает кадр для QR', (tester) async {
    final cameras = await availableCameras();
    expect(cameras, isNotEmpty);
    final camera = CameraController(
      cameras.first,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    try {
      await camera.initialize().timeout(const Duration(seconds: 45));
      expect(camera.value.isInitialized, true);
      expect(camera.value.previewSize, isNotNull);
      final frame = Completer<Size>();
      await camera.startImageStream((image) {
        if (!frame.isCompleted) {
          frame.complete(Size(image.width.toDouble(), image.height.toDouble()));
        }
      });
      final size = await frame.future.timeout(const Duration(seconds: 15));
      await camera.stopImageStream();
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      binding.reportData ??= {};
      binding.reportData!['camera_count'] = cameras.length;
      binding.reportData!['camera_preview_width'] =
          camera.value.previewSize!.width;
    } finally {
      await camera.dispose().timeout(
        const Duration(seconds: 5),
        onTimeout: () {},
      );
    }
  }, skip: !Platform.isAndroid);
}
