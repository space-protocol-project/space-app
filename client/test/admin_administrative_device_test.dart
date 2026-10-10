import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_api/space_api.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

void main() {
  for (final language in ['ru', 'zh', 'en']) {
    final strings = lookupAdminLocalizations(Locale(language));
    testWidgets('Разрешение устройству требует согласия: $language', (
      tester,
    ) async {
      var authorized = false, signatures = 0;
      final api = ConsentGateway(() => authorized);
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(language),
          supportedLocales: AdminLocalizations.supportedLocales,
          localizationsDelegates: AdminLocalizations.localizationsDelegates,
          home: AdminPage(
            autoConnect: true,
            login: ({bool create = false}) async => {
              'origin': 'http://127.0.0.1:8080',
              'serverId': 'server',
              'principalId': 'owner',
              'role': 'owner',
              'token': 'session',
              'expires': 4102444800,
              'hasRootAuthority': true,
              'administrative': authorized,
            },
            gateway: (_) => api,
            authorizeDevice: (password) async {
              signatures++;
              authorized = true;
            },
          ),
        ),
      );
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
      expect(signatures, 0);
      final button = find.text(strings.authorizeDevice);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      await tester.tap(find.text(strings.cancel));
      await tester.pumpAndSettle();
      expect(signatures, 0);
      await tester.tap(button);
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await tester.tap(find.text(strings.allow));
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
      expect(signatures, 1);
      expect(find.text(strings.authorizeDevice), findsNothing);
      expect(find.text(strings.settingsRevision('1')), findsOneWidget);
    });
  }
}

class ConsentGateway extends SpaceGateway {
  ConsentGateway(this.authorized) : super(Uri.parse('http://127.0.0.1:8080'));
  final bool Function() authorized;
  @override
  Future<Map<String, dynamic>> call(
    String path, {
    String token = '',
    Map<String, dynamic>? body,
    String? method,
  }) async {
    if (path.endsWith('/setup')) return {'initialized': true};
    if (path.endsWith('/settings')) {
      if (!authorized()) throw SpaceApiError(403, 'Нужно space.manage');
      return {
        'settings': {
          'title': 'Space',
          'chatTitle': 'Общий',
          'chatEnabled': true,
          'registrationPolicy': 'open',
          'revision': '1',
        },
      };
    }
    return {};
  }
}
