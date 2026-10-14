import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/ui/shell.dart';

import 'channels_test.dart'
    show CatalogSession, ChannelVault, MemoryPositions, MemoryHistory;

class _AdminSession extends CatalogSession implements SpaceAdministration {
  _AdminSession(this.origin, this.name);
  final String origin, name;
  @override
  String get spaceTitle => name;
  @override
  bool get canManageSpace => true;
  @override
  bool get needsOwnerSetup => false;
  @override
  Future<Map<String, dynamic>> adminIdentity() async => {
    'origin': origin,
    'role': 'owner',
    'administrative': true,
    'token': '',
    'expires': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 600,
    'principalId': 'u_test',
    'serverId': 'srv_test',
  };
  @override
  Future<Map<String, dynamic>> adminRequest(
    String path, {
    Map<String, dynamic>? body,
    String? method,
  }) async {
    if (path.endsWith('/setup')) return {'initialized': true};
    if (path.endsWith('/settings')) {
      return {
        'settings': {
          'title': 'Название $name',
          'chatTitle': 'Общий чат',
          'chatEnabled': true,
          'registrationPolicy': 'closed',
          'revision': '1',
        },
      };
    }
    return {'channels': [], 'members': [], 'invites': []};
  }
}

class _Routes extends NavigatorObserver {
  int pushes = 0;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushes++;
  }
}

void main() {
  for (final width in [390.0, 1680.0]) {
    testWidgets(
      'Управление встроено в сервер, навигация остаётся доступной: $width',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        const first = 'http://127.0.0.1:8080', second = 'http://127.0.0.1:8081';
        final sessions = {
          first: _AdminSession(first, 'A'),
          second: _AdminSession(second, 'B'),
        };
        final vault = ChannelVault();
        late ServerWorkspaces workspaces;
        await tester.runAsync(() async {
          workspaces = ServerWorkspaces(
            vault: vault,
            create: (origin) => ChatController(
              vault,
              positions: MemoryPositions(),
              historyStore: MemoryHistory(),
              openSession: (_, _) async => sessions[origin]!,
            ),
            resume: (origin, controller) async {
              controller.preview = Discovery(
                Uri.parse(origin),
                'srv_test',
                List.filled(32, 1),
              );
              await controller.connect();
            },
          );
          await workspaces.synchronize([first, second]);
          await workspaces.refresh();
          await Future<void>.delayed(const Duration(milliseconds: 50));
        });
        final preferences = AppPreferences()..origins.addAll([first, second]);
        final presence = ServerPresence(probe: (_) async => true);
        final observer = _Routes();
        await tester.pumpWidget(
          MaterialApp(
            theme: preferences.theme,
            locale: const Locale('ru'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AdminLocalizations.delegate,
              ...AppLocalizations.localizationsDelegates,
            ],
            navigatorObservers: [observer],
            home: SpaceShell(
              controller: workspaces[first],
              preferences: preferences,
              workspaces: workspaces,
              presence: presence,
            ),
          ),
        );
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        final initialPushes = observer.pushes;
        if (width < 760) {
          await tester.tap(
            find.byKey(const ValueKey('navigation-menu-button')),
          );
          await tester.pumpAndSettle();
          await tester.scrollUntilVisible(
            find.byKey(const ValueKey('my-device-tab')),
            160,
            scrollable: find
                .descendant(
                  of: find.byKey(const ValueKey('mobile-navigation')),
                  matching: find.byType(Scrollable),
                )
                .first,
          );
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const ValueKey('my-device-tab')));
        } else {
          await tester.tap(find.byKey(const ValueKey('my-device-tab')));
        }
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(
          find.text('Идентичности и ключи этого устройства.'),
          findsOneWidget,
        );
        expect(find.byType(AdminPage), findsNothing);
        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
        expect(find.text('Сохранить QR'), findsOneWidget);
        expect(find.text('Восстановить из файла'), findsOneWidget);
        expect(find.text('Сканировать камерой'), findsOneWidget);
        if (width >= 760) {
          await tester.tap(find.byKey(const ValueKey('server-tab-$first')));
          await tester.runAsync(() async {
            await Future<void>.delayed(Duration.zero);
          });
          await tester.pumpAndSettle();
        }
        if (width < 760) {
          await tester.tap(find.byType(NavigationDestination).last);
        } else {
          await tester.tap(
            find.widgetWithText(ListTile, 'Управление пространством'),
          );
        }
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(observer.pushes, initialPushes);
        expect(find.byType(AdminPage), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextField && widget.controller?.text == 'Название A',
          ),
          findsOneWidget,
        );
        if (width >= 760) {
          expect(
            find.byKey(const ValueKey('server-tab-$second')),
            findsOneWidget,
          );
          await tester.tap(find.byKey(const ValueKey('server-tab-$second')));
          await tester.runAsync(() async {
            await Future<void>.delayed(Duration.zero);
          });
          await tester.pumpAndSettle();
          await tester.tap(
            find.widgetWithText(ListTile, 'Управление пространством'),
          );
          await tester.runAsync(() async {
            await Future<void>.delayed(Duration.zero);
          });
          await tester.pumpAndSettle();
          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is TextField &&
                  widget.controller?.text == 'Название B',
            ),
            findsOneWidget,
          );
          expect(observer.pushes, initialPushes);
        }
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        workspaces.dispose();
        presence.dispose();
        preferences.dispose();
      },
    );
  }
}
