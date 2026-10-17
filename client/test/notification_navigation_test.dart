import 'dart:async';
import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' show Content;
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/src/system_notifications.dart';
import 'package:space_client/ui/shell.dart';

import 'channels_test.dart' show ChannelVault, MemoryHistory, MemoryPositions;
import 'dashboard_workspaces_test.dart' show DashboardSession;
import 'support/chat_outbox.dart';

class _Session extends DashboardSession {
  _Session(super.name);
  @override
  Future<List<Content>> messages() async => [
    Content(
      id: 'notification-message',
      channelId: selectedChannelId,
      authorId: 'other',
      text: 'Цель уведомления · $name · $selectedChannelId',
      sequence: Int64(7),
      revision: Int64.ONE,
    ),
  ];
}

class _Notifications extends SystemNotifications {
  Completer<void>? focusGate;
  int focuses = 0;
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {}
  @override
  Future<void> focus() async {
    focuses++;
    await focusGate?.future;
  }
}

void main() {
  for (final scenario in [
    'valid',
    'revoked',
    'wrong-principal',
    'unknown-origin',
    'revoked-during-focus',
  ]) {
    testWidgets('Нажатие системного уведомления: $scenario', (tester) async {
      SharedPreferences.setMockInitialValues({});
      const first = 'http://127.0.0.1:18080', second = 'http://127.0.0.1:18081';
      final sessions = {first: _Session('Первый'), second: _Session('Второй')};
      final vault = ChannelVault();
      late ServerWorkspaces workspaces;
      await tester.runAsync(() async {
        workspaces = ServerWorkspaces(
          vault: vault,
          create: (origin) => ChatController(
            vault,
            positions: MemoryPositions(),
            historyStore: MemoryHistory(),
            outboxStore: MemoryChatOutbox(),
            openSession: (_, _) async => sessions[origin]!,
          ),
          resume: (origin, controller) async {
            controller.preview = Discovery(
              localOrigin(origin),
              'srv-$origin',
              List.filled(32, 1),
            );
            await controller.connect();
          },
        );
        await workspaces.synchronize([first, second]);
        await workspaces.refresh();
      });
      final notifications = _Notifications();
      final preferences = AppPreferences()..origins.addAll([first, second]);
      final presence = ServerPresence(probe: (_) async => true);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AdminLocalizations.delegate,
            ...AppLocalizations.localizationsDelegates,
          ],
          home: SpaceShell(
            controller: workspaces[first],
            workspaces: workspaces,
            preferences: preferences,
            presence: presence,
            notifications: notifications,
            hostingEnabled: false,
          ),
        ),
      );
      await tester.runAsync(
        () async => Future<void>.delayed(const Duration(milliseconds: 40)),
      );
      await tester.pumpAndSettle();
      final target = workspaces[second]!;
      if (scenario == 'revoked') {
        sessions[second]!.availableChannels.last.permissions.read = false;
        await tester.runAsync(() async => target.refreshChannels());
      }
      if (scenario == 'revoked-during-focus') {
        notifications.focusGate = Completer<void>();
      }
      notifications.targets.add(
        jsonEncode([
          scenario == 'unknown-origin' ? 'http://unknown.invalid' : second,
          scenario == 'wrong-principal' ? 'someone-else' : target.principalId,
          'team',
          7,
        ]),
      );
      for (var frame = 0; frame < 8; frame++) {
        await tester.pump();
        await tester.runAsync(
          () async => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
      }
      await tester.pumpAndSettle();
      if (scenario == 'revoked-during-focus') {
        expect(notifications.focuses, 1);
        sessions[second]!.availableChannels.last.permissions.read = false;
        await tester.runAsync(() async => target.refreshChannels());
        notifications.focusGate!.complete();
        await tester.runAsync(() async => Future<void>.delayed(Duration.zero));
        await tester.pumpAndSettle();
        expect(target.canRead, isFalse);
      } else if (scenario == 'valid') {
        expect(target.channelId, 'team');
        expect(notifications.focuses, 1);
        expect(find.text('Цель уведомления · Второй · team'), findsOneWidget);
      } else {
        expect(target.channelId, 'general');
        expect(notifications.focuses, 0);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await notifications.dispose();
      workspaces.dispose();
      preferences.dispose();
      presence.dispose();
    });
  }
}
