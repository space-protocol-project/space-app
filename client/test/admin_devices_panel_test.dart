import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_api/space_api.dart';

void main() {
  testWidgets('Устройства: разрешения, отмена, каскадный отзыв и self revoke', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final grants = [
      {
        'id': 'current',
        'expiresAt': '4102444800',
        'scopes': ['chat.read', 'space.manage'],
      },
      {
        'id': 'card',
        'expiresAt': '4102444800',
        'scopes': ['chat.read'],
        'recovery': true,
      },
      {
        'id': 'old',
        'expiresAt': '1',
        'scopes': ['chat.read'],
      },
    ];
    var revokes = 0, disconnected = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: DevicesPanel(
              call: (path, {body, method}) async => {'devices': grants},
              currentGrantId: 'current',
              hasRootAuthority: true,
              revoke: (grant, password) async {
                revokes++;
                grants.removeWhere((g) => g['id'] == grant['id']);
              },
              onRevoked: () => disconnected = true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Разрешения: chat.read, space.manage'), findsOneWidget);
    expect(find.text('Отозвать доступ'), findsNWidgets(2));
    await tester.tap(find.text('Отозвать доступ').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('все подключённые'), findsOneWidget);
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(revokes, 0);
    await tester.tap(find.text('Отозвать доступ').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отозвать'));
    await tester.pumpAndSettle();
    expect(revokes, 1);
    expect(find.text('card'), findsNothing);
    await tester.tap(find.text('Отозвать доступ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отозвать'));
    await tester.pumpAndSettle();
    expect(disconnected, isTrue);
    expect(find.text('current'), findsNothing);
  });

  testWidgets('Отзыв с карточкой: ошибка сохраняет список и позволяет повтор', (
    tester,
  ) async {
    var attempts = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: DevicesPanel(
              call: (path, {body, method}) async => {
                'devices': [
                  {'id': 'other', 'expiresAt': '4102444800'},
                ],
              },
              currentGrantId: 'current',
              revoke: (grant, password) async {
                attempts++;
                expect(password, 'secret');
                throw SpaceApiError(403, 'Доступ отклонён');
              },
              onRevoked: () => fail('Не должно отключать текущую сессию'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отозвать доступ'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'secret');
    await tester.tap(find.text('Отозвать'));
    await tester.pumpAndSettle();
    expect(attempts, 1);
    expect(find.text('other'), findsOneWidget);
    expect(find.text('Доступ отклонён'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
