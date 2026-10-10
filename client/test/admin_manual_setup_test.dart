import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_api/space_api.dart';

class SetupGateway extends SpaceGateway {
  SetupGateway() : super(Uri.parse('http://127.0.0.1:8080'));
  bool initialized = false;
  int claims = 0;
  @override
  Future<Map<String, dynamic>> call(
    String path, {
    String token = '',
    Map<String, dynamic>? body,
    String? method,
  }) async {
    if (path.endsWith('/setup')) return {'initialized': initialized};
    if (path.endsWith('/setup/claim')) {
      expect(body!['setupCode'], 'test-code');
      claims++;
      initialized = true;
      return {};
    }
    if (path.endsWith('/settings')) {
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

void main() {
  testWidgets('Ручной bootstrap требует разрешения устройства до setup-кода', (
    tester,
  ) async {
    final api = SetupGateway();
    var authorized = false;
    await tester.pumpWidget(
      MaterialApp(
        home: AdminPage(
          autoConnect: true,
          gateway: (_) => api,
          login: ({bool create = false}) async => {
            'origin': 'http://127.0.0.1:8080',
            'serverId': 'server',
            'principalId': 'member',
            'role': api.initialized ? 'owner' : 'member',
            'token': 'session',
            'expires': 4102444800,
            'hasRootAuthority': true,
            'administrative': authorized,
          },
          authorizeDevice: (_) async => authorized = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'test-code');
    await tester.ensureVisible(find.text('Подтвердить владение'));
    await tester.tap(find.text('Подтвердить владение'));
    await tester.pumpAndSettle();
    expect(api.claims, 0);
    await tester.ensureVisible(find.text('Выдать разрешение этому устройству'));
    await tester.tap(find.text('Выдать разрешение этому устройству'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Разрешить'));
    await tester.pumpAndSettle();
    expect(authorized, isTrue);
    await tester.ensureVisible(find.text('Подтвердить владение'));
    await tester.tap(find.text('Подтвердить владение'));
    await tester.pumpAndSettle();
    expect(api.claims, 1);
    expect(find.text('Назначить первого владельца'), findsNothing);
    expect(find.text('Настройки пространства · версия 1'), findsOneWidget);
  });
}
