import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:space_api/space_api.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

class SettingsOnlyGateway extends SpaceGateway {
  SettingsOnlyGateway(super.origin, {super.client});
  @override
  Future<Map<String, dynamic>> call(
    String path, {
    String token = '',
    Map<String, dynamic>? body,
    String? method,
  }) async {
    if (path.endsWith('/settings') || path.endsWith('/setup')) {
      return super.call(path, token: token, body: body, method: method);
    }
    return {'channels': [], 'members': [], 'invites': []};
  }
}

void main() {
  testWidgets('Вход, настройки, узкий экран и защита от конфликтующей записи', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var writes = 0;
    final api = SettingsOnlyGateway(
      Uri.parse('http://127.0.0.1:8080'),
      client: MockClient((r) async {
        if (r.url.path.endsWith('/setup')) {
          return http.Response('{"initialized":true}', 200);
        }
        if (r.method == 'PATCH') {
          writes++;
          return http.Response(
            '{"message":"Конфликт"}',
            409,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return http.Response(
          jsonEncode({
            'settings': {
              'title': 'Мастерская',
              'chatTitle': 'Чат',
              'chatEnabled': true,
              'registrationPolicy': 'open',
              'revision': '3',
            },
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );
    await tester.pumpWidget(
      AdminTestApp(
        gateway: (_) => api,
        login: ({bool create = false}) async => {
          'origin': 'http://127.0.0.1:8080',
          'serverId': 'srv_test',
          'principalId': 'u_test',
          'token': 'test-only',
          'expires': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 600,
          'role': 'owner',
        },
      ),
    );
    await tester.runAsync(() async {
      await tester.tap(find.text('Подключить управление текущим сервером'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpAndSettle();
    expect(find.text('Настройки пространства · версия 3'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField).first,
      'Несохранённое название',
    );
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Сохранить настройки'));
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await tester.tap(find.text('Сохранить настройки'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();
    expect(writes, 1);
    expect(
      find.text(
        'Настройки уже изменены. Загрузите их заново и повторите изменения.',
      ),
      findsOneWidget,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'Несохранённое название',
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}

class AdminTestApp extends StatelessWidget {
  const AdminTestApp({
    super.key,
    this.gateway = SpaceGateway.new,
    this.login = emptyLogin,
  });
  final IdentityLogin login;
  final SpaceGateway Function(Uri) gateway;
  static Future<Map<String, dynamic>> emptyLogin({bool create = false}) async =>
      {};
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: AdminPage(login: login, gateway: gateway),
  );
}
