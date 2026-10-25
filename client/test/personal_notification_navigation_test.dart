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
import 'support/chat_outbox.dart';
import 'support/personal_notifications.dart';
import 'channels_test.dart' show chat;

class _Session extends PersonalTestSession {
  _Session(this._name) {
    availableChannels.add(chat('team'));
    notifications.add(
      personalNotice(7, channel: 'team')..contentId = 'notification-message',
    );
  }
  final String _name;
  @override
  String get spaceTitle => _name;
  @override
  Future<List<Content>> messages() async => [
    Content(
      id: 'notification-message',
      channelId: selectedChannelId,
      authorId: 'other',
      text: 'Цель уведомления · $_name · $selectedChannelId',
      sequence: Int64(7),
      revision: Int64.ONE,
    ),
  ];
}

class _Notifications extends SystemNotifications {
  final shown = <(String, String, List<Object>)>[];
  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required List<Object> target,
    String actionLabel = 'Space',
    bool Function()? permitted,
  }) async {
    if (permitted?.call() ?? true) shown.add((title, body, target));
  }

  String? startupPayload;
  int activationStarts = 0;
  int clears = 0;
  @override
  Future<void> listenForActivation({required bool enabled}) async {
    activationStarts++;
    if (startupPayload != null) targets.add(startupPayload!);
  }

  Completer<void>? focusGate;
  int focuses = 0;
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {
    clears++;
  }

  @override
  Future<void> focus() async {
    focuses++;
    await focusGate?.future;
  }
}

void main() {
  for (final mode in [0, 1, 2]) {
    testWidgets('Новая личная карточка: режим $mode', (tester) async {
      SharedPreferences.setMockInitialValues({});
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            SystemNotifications.activationChannel,
            (_) async => null,
          );
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              SystemNotifications.activationChannel,
              null,
            ),
      );
      final fixture = PersonalTestWorkspace();
      fixture.session.availableChannels.add(chat('team'));
      await tester.runAsync(fixture.start);
      final notifications = _Notifications();
      final preferences = AppPreferences()
        ..origins.add(PersonalTestWorkspace.origin)
        ..notificationMode = mode;
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
            controller: fixture.chatController,
            workspaces: fixture.workspaces,
            preferences: preferences,
            presence: presence,
            notifications: notifications,
            hostingEnabled: false,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 40)),
      );
      await tester.pumpAndSettle();
      if (mode != 0) {
        expect(fixture.api.requests.where((r) => r.baselineOnly), hasLength(2));
      }
      fixture.api.add(personalNotice(1, channel: 'team'));
      await tester.pump(const Duration(seconds: 16));
      await tester.pumpAndSettle();
      if (mode == 0) {
        expect(notifications.shown, isEmpty);
      } else {
        expect(notifications.shown, hasLength(1));
        final card = notifications.shown.single;
        expect(card.$3, [
          'personal',
          PersonalTestWorkspace.origin,
          'u_test',
          'team',
          1,
          'pn_1',
        ]);
        if (mode == 1) {
          expect(card.$1, 'Space');
          expect(card.$2, 'Новое сообщение');
        } else {
          expect(card.$1, contains('Пространство'));
          expect(card.$2, contains('Запись 1'));
        }
        await tester.pump(const Duration(seconds: 16));
        await tester.pumpAndSettle();
        expect(notifications.shown, hasLength(1));
      }
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(() async {
        fixture.dispose();
        await notifications.dispose();
      });
      preferences.dispose();
      presence.dispose();
    });
  }
  for (final scenario in [
    'valid',
    'revoked',
    'wrong-principal',
    'unknown-origin',
    'revoked-during-focus',
    'cold-start',
    'cold-load-preferences',
    'notifications-off',
  ]) {
    testWidgets('Нажатие личного уведомления: $scenario', (tester) async {
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
      final startupReady = Completer<void>();
      final cold = scenario.startsWith('cold-');
      if (cold) {
        notifications.startupPayload = jsonEncode([
          'personal',
          second,
          'u_test',
          'team',
          7,
          'pn_7',
        ]);
      } else {
        startupReady.complete();
      }
      final preferences = AppPreferences()
        ..origins.addAll([first, second])
        ..notificationMode = scenario == 'notifications-off' ? 0 : 1;
      if (scenario == 'cold-load-preferences') {
        preferences.origins.clear();
        preferences.notificationMode = 0;
        SharedPreferences.setMockInitialValues({
          'space.ui.origins': [first, second],
          'space.notifications.mode': 1,
        });
      }
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
            startupReady: startupReady.future,
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
      if (cold) {
        expect(notifications.activationStarts, 0);
        expect(target.channelId, 'general');
        if (scenario == 'cold-load-preferences') {
          final loading = preferences.load();
          await tester.pumpAndSettle();
          await loading;
          expect(notifications.clears, 0);
        }
        startupReady.complete();
      } else {
        notifications.targets.add(
          jsonEncode([
            'personal',
            scenario == 'unknown-origin' ? 'http://unknown.invalid' : second,
            scenario == 'wrong-principal' ? 'someone-else' : target.principalId,
            'team',
            7,
            'pn_7',
          ]),
        );
      }
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
        expect(target.channelId, 'general');
      } else if (scenario == 'valid' || cold) {
        expect(notifications.activationStarts, 1);
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
