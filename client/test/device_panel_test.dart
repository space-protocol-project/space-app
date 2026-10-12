import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/ui/device_panel.dart';
import 'package:space_client/ui/recovery_panel.dart';

import 'channels_test.dart' show ChannelVault;

class _RootVault extends ChannelVault {
  @override
  Future<DeviceRecord?> load(String origin) async => DeviceRecord(
    origin: origin,
    serverId: 'srv_${'a' * 32}',
    serverKey: url64(List.filled(32, 3)),
    rootSeed: List.filled(32, 1),
    deviceSeed: List.filled(32, 2),
  );
}

void main() {
  testWidgets('Локальный root создаёт QR без подключения к серверу', (
    tester,
  ) async {
    final controller = ChatController(_RootVault());
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: [
          AdminLocalizations.delegate,
          ...AppLocalizations.localizationsDelegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: RecoveryPanel(
              controller: controller,
              identityOrigin: 'https://203.0.113.1:8443',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(controller.connected, false);
    final button = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Создать QR'),
    );
    expect(button.onPressed, isNotNull);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  });
  testWidgets('Импорт и камера доступны без сервера и идентичности', (
    tester,
  ) async {
    final vault = ChannelVault();
    final controller = ChatController(vault);
    final workspaces = ServerWorkspaces(vault: vault);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: [
          AdminLocalizations.delegate,
          ...AppLocalizations.localizationsDelegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: DevicePanel(
            workspaces: workspaces,
            fallback: controller,
            restoreController: (_) => controller,
            onRestored: (_, _) async {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (final label in ['Восстановить из файла', 'Сканировать камерой']) {
      final button = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, label),
      );
      expect(button.onPressed, isNotNull);
    }
    expect(controller.preview, isNull);
    expect(workspaces.controllers, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
    workspaces.dispose();
  });
}
