import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/app_updates.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/ui/shell.dart';
import 'package:space_client/ui/panels.dart';
import 'package:window_manager/window_manager.dart';

import '../test/channels_test.dart'
    show ChannelVault, MemoryHistory, MemoryPositions;
import 'fixtures/gallery_session.dart';

const origin = 'https://friends.example';
final captureKey = GlobalKey();

Future<void> capture(WidgetTester tester, Directory output, String name) async {
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  final boundary =
      captureKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 1);
  try {
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await File('${output.path}/$name.png')
        .writeAsBytes(bytes!.buffer.asUint8List());
  } finally {
    image.dispose();
  }
}

Future<void> openMenu(WidgetTester tester) async {
  final menu = find.byKey(const ValueKey('navigation-menu-button'));
  if (menu.evaluate().isEmpty) return;
  await tester.tap(menu);
  await tester.pumpAndSettle();
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.allTestsPassed.future.then((passed) => exit(passed ? 0 : 1));
  testWidgets('Release: основные экраны и сохранность черновика', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    if (Platform.isWindows) {
      await windowManager.ensureInitialized();
      await windowManager.setSize(const Size(1440, 900));
    }
    final configured = const String.fromEnvironment('SPACE_GALLERY_OUTPUT');
    final outputRoot = Directory(
      configured.isNotEmpty
          ? configured
          : '${(await getExternalStorageDirectory())!.path}/redesign-gallery',
    );
    final output = outputRoot;
    await output.create(recursive: true);
    final preferences = AppPreferences()..origins.add(origin);
    final session = GallerySession();
    final controller =
        ChatController(
            ChannelVault(),
            positions: MemoryPositions(),
            historyStore: MemoryHistory(),
            openSession: (_, _) async => session,
          )
          ..preview = Discovery(
            Uri.parse(origin),
            'srv_gallery',
            List.filled(32, 1),
          );
    await controller.connect();
    final workspaces = ServerWorkspaces(vault: controller.vault);
    await workspaces.adopt(origin, controller, owned: false);
    final presence = ServerPresence(probe: (_) async => true);
    await presence.watch([origin]);
    final updates = AppUpdates(
      readVersion: () async => '0.2.6',
      client: MockClient((_) async => http.Response('[]', 200)),
    );
    await tester.pumpWidget(
      RepaintBoundary(
        key: captureKey,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
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
            workspaces: workspaces,
            presence: presence,
            updates: updates,
            hostingEnabled: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await precacheImage(
      const AssetImage('assets/branding/space-app-icon.png'),
      captureKey.currentContext!,
    );
    await capture(tester, output, 'overview');
    await openMenu(tester);
    await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
    await capture(tester, output, 'chat');
    final draft = find.byKey(const ValueKey('chat-draft'));
    tester.testTextInput.register();
    await tester.enterText(draft, 'До встречи!');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Поиск'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    Navigator.of(tester.element(find.byType(Dialog))).pop();
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(draft).controller!.text, 'До встречи!');
    tester.testTextInput.unregister();
    await openMenu(tester);
    await tester.tap(find.widgetWithText(ListTile, 'Управление пространством'));
    await capture(tester, output, 'administration');
    await openMenu(tester);
    await tester.ensureVisible(find.byKey(const ValueKey('app-settings-tab')));
    await tester.tap(find.byKey(const ValueKey('app-settings-tab')));
    await capture(tester, output, 'settings');
    final settingsScroll = find
        .descendant(
          of: find.byType(SettingsPanel),
          matching: find.byType(Scrollable),
        )
        .first;
    final position = tester.state<ScrollableState>(settingsScroll).position;
    final beforeScroll = position.pixels;
    await tester.drag(settingsScroll, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(position.pixels, greaterThan(beforeScroll));
    await openMenu(tester);
    final addSpace = find.widgetWithText(ListTile, 'Добавить пространство');
    if (addSpace.evaluate().isNotEmpty) {
      await tester.ensureVisible(addSpace);
      await tester.tap(addSpace);
    } else {
      await tester.tap(find.byTooltip('Добавить пространство').first);
    }
    await capture(tester, output, 'connection');
    final report = {
      'release': kReleaseMode,
      'platform': Platform.operatingSystem,
      'device_pixel_ratio': tester.view.devicePixelRatio,
      'physical_width': tester.view.physicalSize.width,
      'physical_height': tester.view.physicalSize.height,
      'navigation': true,
      'scrolling': true,
      'draft_preserved_after_search': true,
      'demonstration_data': true,
    };
    binding.reportData = report;
    await File('${output.path}/report.json')
        .writeAsString(const JsonEncoder.withIndent('  ').convert(report));
    await tester.pumpWidget(const SizedBox());
    await workspaces.close();
    await presence.close();
    await controller.close();
    preferences.dispose();
  });
}
