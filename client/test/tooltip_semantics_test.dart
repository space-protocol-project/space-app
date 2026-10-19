import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/ui/shell.dart';

import 'shell_test.dart' show TestVault;
import 'support/semantics_update_binding.dart';

class _NamedController extends ChatController {
  _NamedController() : super(TestVault());
  @override
  String get spaceTitle => 'Тестовое пространство';
}

class _Presence extends ServerPresence {
  _Presence() : super(probe: (_) async => null);
  bool? available;
  @override
  bool? online(String origin) => available;
}

void main() {
  final binding = SemanticsUpdateBinding();
  testWidgets('Смена подсказок не отправляет узлы вне дерева доступности', (
    tester,
  ) async {
    const origin = 'http://127.0.0.1:8080';
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semantics = tester.ensureSemantics();
    final controller = ChatController(TestVault());
    addTearDown(controller.dispose);
    final preferences = AppPreferences()..origins.add(origin);
    final presence = _Presence();
    final workspaces = ServerWorkspaces(
      vault: TestVault(),
      create: (_) => _NamedController(),
      resume: (_, _) async {},
    );
    addTearDown(preferences.dispose);
    addTearDown(workspaces.dispose);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AdminLocalizations.delegate,
          ...AppLocalizations.localizationsDelegates,
        ],
        home: SpaceShell(
          preferences: preferences,
          controller: controller,
          presence: presence,
          workspaces: workspaces,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    final server = find.byKey(const ValueKey('server-tab-$origin'));
    final add = find.widgetWithIcon(IconButton, Icons.add).first;
    final strings = AppLocalizations.of(tester.element(server))!;
    for (final available in [null, true, false]) {
      presence.available = available;
      presence.publishState();
      await tester.pumpAndSettle();
      var expected = 'Тестовое пространство · $origin';
      if (available != null) {
        expected +=
            '\n${available ? strings.serverNowOnline('127.0.0.1') : strings.serverNowOffline('127.0.0.1')}';
      }
      expect(tester.widget<IconButton>(server).tooltip, expected);
      expect(tester.getSemantics(server).getSemanticsData().tooltip, expected);
      for (final button in [server, add]) {
        await mouse.moveTo(tester.getCenter(button));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
      }
    }
    await mouse.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    semantics.dispose();
    expect(binding.orphanUpdates, isEmpty);
    await tester.pumpWidget(const SizedBox());
    presence.dispose();
  });
}
