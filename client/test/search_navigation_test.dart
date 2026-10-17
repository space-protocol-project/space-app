import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/message_search.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/rpc_clients.dart' show Content;
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/ui/shell.dart';
import 'package:space_client/ui/search.dart';

import 'channels_test.dart'
    show ChannelVault, MemoryHistory, MemoryPositions, chat;
import 'dashboard_workspaces_test.dart' show DashboardSession;
import 'support/chat_outbox.dart';
import 'mls_notifications_test.dart' show NotificationMlsClient;
import 'mls_view_test.dart' show entry;

import 'package:space_client/src/mls/client.dart';

class _Session extends DashboardSession implements MessageSearchSession {
  _Session() : super('Поиск');
  final pending = Completer<MessageSearchPage>();
  bool across = false;
  final requests = <String>[];
  @override
  Future<MessageSearchPage> searchMessages(
    String channel,
    String query,
    String cursor,
  ) {
    requests.add(channel);
    if (across && channel == 'general') {
      return Future.value(const MessageSearchPage([]));
    }
    return pending.future;
  }
}

class _LocalSession implements SpaceSession {
  _LocalSession(this.client);
  final MlsClient client;
  @override
  bool get mlsSupported => true;
  @override
  Future<MlsClient> mlsClient() async => client;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SearchChat extends ChatController {
  _SearchChat(super.vault, _Session session, this.local)
    : super(
        positions: MemoryPositions(),
        historyStore: MemoryHistory(),
        outboxStore: MemoryChatOutbox(),
        openSession: (_, _) async => session,
      );
  final SpaceSession? local;
  @override
  SpaceSession? get mlsSession => local ?? super.mlsSession;
}

void main() {
  for (final scenario in [
    'open',
    'revoke',
    'switch',
    'all',
    'all-revoke',
    'all-switch',
    'all-mls',
  ]) {
    testWidgets('Поиск в оболочке: $scenario', (tester) async {
      SharedPreferences.setMockInitialValues({});
      const origin = 'http://127.0.0.1:18080';
      final session = _Session()..across = scenario.startsWith('all');
      if (session.across) {
        session.availableChannels.addAll([
          chat('hidden')..permissions.read = false,
          chat('archived')..archived = true,
        ]);
      }
      final local = NotificationMlsClient();
      if (scenario == 'all-mls') {
        session.availableChannels[1].mlsGroupId = [1];
        session.availableChannels.add(chat('unjoined')..mlsGroupId = [2]);
        final message = entry(1);
        (message['message'] as Map)['text'] = 'Найти давнее сообщение';
        local.local.channels['team'] = <String, dynamic>{
          'joined': true,
          'group_id': 'AQ==',
          'messages': [message],
        };
      }
      final vault = ChannelVault();
      late ServerWorkspaces workspaces;
      await tester.runAsync(() async {
        workspaces = ServerWorkspaces(
          vault: vault,
          create: (_) => _SearchChat(
            vault,
            session,
            scenario == 'all-mls' ? _LocalSession(local) : null,
          ),
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
      final preferences = AppPreferences()..origins.add(origin);
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
            hostingEnabled: false,
          ),
        ),
      );
      await tester.runAsync(
        () async => Future<void>.delayed(const Duration(milliseconds: 40)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Поиск'));
      await tester.pumpAndSettle();
      if (session.across) {
        await tester.tap(find.byKey(const ValueKey('search-all-channels')));
        await tester.pumpAndSettle();
      }
      await tester.enterText(
        find.byKey(const ValueKey('space-search-input')),
        'Найти',
      );
      await tester.pump(const Duration(milliseconds: 310));
      await tester.pump();
      if (scenario.endsWith('revoke')) {
        session.availableChannels[session.across ? 1 : 0].permissions.read =
            false;
        await tester.runAsync(
          () async => workspaces[origin]!.refreshChannels(),
        );
        await tester.pumpAndSettle();
      }
      if (scenario.endsWith('switch')) {
        await tester.runAsync(
          () async => workspaces[origin]!.selectChannel('team'),
        );
        await tester.pumpAndSettle();
      }
      session.pending.complete(
        MessageSearchPage([
          Content(
            id: 'search-hit',
            channelId: session.across ? 'team' : 'general',
            text: 'Найти давнее сообщение',
            authorId: 'other',
            sequence: Int64(5),
          ),
        ]),
      );
      await tester.pumpAndSettle();
      if (scenario == 'open' || scenario == 'all') {
        await tester.tap(find.text('Найти давнее сообщение'));
        for (var i = 0; i < 8; i++) {
          await tester.pump();
          await tester.runAsync(
            () async => Future<void>.delayed(const Duration(milliseconds: 10)),
          );
        }
        await tester.pumpAndSettle();
        expect(
          find.text('Найти давнее сообщение').hitTestable(),
          findsOneWidget,
        );
      } else if (scenario == 'all-mls') {
        expect(find.text('Найти давнее сообщение'), findsOneWidget);
        expect(session.requests, ['general']);
        expect(local.calls, 0);
      } else {
        expect(find.byType(SpaceSearchPanel), findsNothing);
        expect(find.text('Найти давнее сообщение'), findsNothing);
      }
      if (scenario == 'all') {
        expect(workspaces[origin]!.channelId, 'team');
        expect(session.requests, ['general', 'team']);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      workspaces.dispose();
      preferences.dispose();
      presence.dispose();
    });
  }
}
