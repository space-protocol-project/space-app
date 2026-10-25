import 'dart:convert';

import 'package:space_client/src/generated/space/v1/space.pb.dart' show Channel;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/src/system_notifications.dart';
import 'package:space_client/ui/shell.dart';

import 'channels_test.dart' show ChannelVault, MemoryHistory, MemoryPositions;
import 'dashboard_workspaces_test.dart' show DashboardSession;
import 'mls_notifications_test.dart' show NotificationMlsClient;
import 'mls_view_test.dart' show entry;
import 'support/chat_outbox.dart';

class _Session implements SpaceSession {
  @override
  bool get chatMentionsSupported => false;
  @override
  List<Channel> get availableChannels => const [];
  _Session(this.client);
  final MlsClient client;
  @override
  bool get mlsSupported => true;
  @override
  bool get attachmentsEnabled => false;
  @override
  Discovery get server => Discovery(
    localOrigin('http://127.0.0.1:18080'),
    'server',
    List.filled(32, 1),
  );
  @override
  Future<MlsClient> mlsClient() async => client;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Chat extends ChatController {
  _Chat(super.vault, DashboardSession ordinary, this.mls)
    : super(
        positions: MemoryPositions(),
        historyStore: MemoryHistory(),
        outboxStore: MemoryChatOutbox(),
        openSession: (_, _) async => ordinary,
      );
  final SpaceSession mls;
  @override
  SpaceSession get mlsSession => mls;
}

class _Notifications extends SystemNotifications {
  final shown = <(String, String)>[];
  List<Object>? lastTarget;
  @override
  Future<void> focus() async {}
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {}
  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required List<Object> target,
    String actionLabel = 'Space',
  }) async {
    shown.add((title, body));
    lastTarget = target;
    expect(target.length, 6);
  }
}

void main() {
  for (final mode in [0, 1, 2]) {
    testWidgets('MLS: системная доставка соблюдает режим приватности $mode', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      const origin = 'http://127.0.0.1:18080';
      final session = DashboardSession('Личное пространство');
      session.availableChannels.last.mlsGroupId = [1];
      final client = NotificationMlsClient();
      client.local.principal = session.principalId;
      client.local.channels['team'] = <String, dynamic>{
        'joined': true,
        'cursor': 3,
        'group_id': 'AQ==',
        'messages': [entry(3)],
        'managers': <String>[],
        'roster': <dynamic>[],
      };
      final vault = ChannelVault();
      late ServerWorkspaces workspaces;
      await tester.runAsync(() async {
        workspaces = ServerWorkspaces(
          vault: vault,
          create: (_) => _Chat(vault, session, _Session(client)),
          resume: (_, controller) async {
            controller.preview = Discovery(
              localOrigin(origin),
              'server',
              List.filled(32, 1),
            );
            await controller.connect();
          },
        );
        await workspaces.synchronize([origin]);
        await workspaces.refresh();
      });
      final preferences = AppPreferences()
        ..origins.add(origin)
        ..notificationMode = mode;
      final notifications = _Notifications();
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
            controller: workspaces[origin],
            workspaces: workspaces,
            preferences: preferences,
            presence: presence,
            notifications: notifications,
            hostingEnabled: false,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 3));
      await tester.runAsync(
        () async => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
      await tester.pumpAndSettle();
      expect(notifications.shown, isEmpty);
      client.incoming = [entry(4)];
      await tester.pump(const Duration(seconds: 3));
      await tester.runAsync(
        () async => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
      await tester.pumpAndSettle();
      if (mode == 0) {
        expect(notifications.shown, isEmpty);
      }
      if (mode == 1) {
        expect(notifications.shown.single, ('Space', 'Новое сообщение'));
      }
      if (mode == 2) {
        expect(notifications.shown.single, (
          'Личное пространство · Команда · Личное пространство',
          'Сообщение 4',
        ));
      }
      if (mode == 2) {
        notifications.targets.add(jsonEncode(notifications.lastTarget));
        for (var frame = 0; frame < 8; frame++) {
          await tester.pump();
          await tester.runAsync(
            () async => Future<void>.delayed(const Duration(milliseconds: 10)),
          );
        }
        await tester.pumpAndSettle();
        expect(workspaces[origin]!.channelId, 'team');
        expect(find.text('Сообщение 4').hitTestable(), findsOneWidget);
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
