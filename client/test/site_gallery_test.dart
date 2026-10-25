import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/src/voice_devices.dart';
import 'package:space_client/ui/shell.dart';
import 'package:space_client/ui/space_frame.dart';

import 'channels_test.dart' show ChannelVault, MemoryHistory, MemoryPositions;
import 'chat_examples_screenshots_test.dart' show captureExample;
import 'redesign_golden_test.dart' show loadFonts;
import 'support/chat_outbox.dart' show MemoryChatOutbox;
import 'support/site_gallery_session.dart';
import 'voice_devices_test.dart' show DevicesBackend;

Future<void> openNavigation(WidgetTester tester, bool mobile) async {
  if (!mobile) return;
  await tester.tap(find.byKey(const ValueKey('navigation-menu-button')));
  await tester.pumpAndSettle();
}

Future<void> selectScreen(
  WidgetTester tester,
  String screen,
  bool mobile,
) async {
  await openNavigation(tester, mobile);
  final target = switch (screen) {
    'chat' => find.widgetWithText(ListTile, 'Чаты'),
    'overview' => find.byKey(
      const ValueKey('server-tab-https://friends.example'),
    ),
    'dashboard' => find.byKey(const ValueKey('dashboard-tab')),
    'settings' => find.byKey(const ValueKey('app-settings-tab')),
    'connection' => find.widgetWithText(ListTile, 'Добавить пространство'),
    _ => throw ArgumentError.value(screen),
  };
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
  if (screen == 'overview' && mobile) {
    for (var attempt = 0; attempt < 100; attempt++) {
      if (!tester.widget<SpaceFrame>(find.byType(SpaceFrame)).navigationOpen) {
        break;
      }
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pumpAndSettle();
    }
    expect(
      tester.widget<SpaceFrame>(find.byType(SpaceFrame)).navigationOpen,
      isFalse,
    );
  }
  if (screen == 'dashboard' && mobile) {
    await tester.scrollUntilVisible(
      find.text('Требует внимания'),
      250,
      scrollable: find
          .descendant(
            of: find.byType(SpaceShell),
            matching: find.byType(Scrollable),
          )
          .last,
    );
    await Scrollable.ensureVisible(
      tester.element(find.text('Требует внимания')),
      alignment: 0.12,
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('Требует внимания')).dy,
      greaterThan(70),
    );
  }
}

void main() {
  final output = Platform.environment['SPACE_SITE_GALLERY_OUTPUT'];
  for (final mobile in [false, true]) {
    for (final dark in [true, false]) {
      for (final screen in [
        'chat',
        'overview',
        'dashboard',
        mobile ? 'connection' : 'settings',
      ]) {
        final platform = mobile ? 'mobile' : 'desktop';
        final theme = dark ? 'dark' : 'light';
        final name = '$platform-$theme-$screen';
        testWidgets('Промогалерея: $name', (tester) async {
          SharedPreferences.setMockInitialValues({'space.ui.dark': dark});
          tester.view.physicalSize = mobile
              ? const Size(390, 844)
              : const Size(1440, 960);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await tester.runAsync(loadFonts);
          late AppPreferences preferences;
          late ChatController controller;
          late ServerWorkspaces workspaces;
          await tester.runAsync(() async {
            preferences = AppPreferences();
            await preferences.load();
            const origin = 'https://friends.example';
            preferences.origins.add(origin);
            controller =
                ChatController(
                    ChannelVault(),
                    positions: MemoryPositions(),
                    historyStore: MemoryHistory(),
                    outboxStore: MemoryChatOutbox(),
                    openSession: (_, _) async => SiteGallerySession(),
                  )
                  ..preview = Discovery(
                    Uri.parse(origin),
                    'srv_gallery',
                    List.filled(32, 1),
                  );
            await controller.connect();
            workspaces = ServerWorkspaces(vault: controller.vault);
            await workspaces.adopt(origin, controller, owned: false);
          });
          final presence = ServerPresence(probe: (_) async => true);
          final voice = VoiceController(
            audioDevices: VoiceDevices(backend: DevicesBackend()),
          );
          final boundary = GlobalKey();
          await tester.pumpWidget(
            RepaintBoundary(
              key: boundary,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: preferences.theme,
                locale: const Locale('ru'),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: [
                  AdminLocalizations.delegate,
                  ...AppLocalizations.localizationsDelegates,
                ],
                home: SpaceShell(
                  preferences: preferences,
                  controller: controller,
                  workspaces: workspaces,
                  presence: presence,
                  voiceController: voice,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await tester.runAsync(
            () => precacheImage(
              const AssetImage('assets/branding/space-app-icon.png'),
              boundary.currentContext!,
            ),
          );
          await selectScreen(tester, screen, mobile);
          expect(find.textContaining('TimeoutException'), findsNothing);
          await captureExample(tester, boundary, '$output/$name.png');
          await tester.pumpWidget(const SizedBox());
          await tester.runAsync(workspaces.close);
          await tester.runAsync(presence.close);
          await tester.runAsync(controller.close);
          await tester.runAsync(voice.close);
          preferences.dispose();
        }, skip: output == null);
      }
    }
  }
}
