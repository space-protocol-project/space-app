import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_api/space_api.dart';

Future<void> visible(WidgetTester tester, Finder finder) async {
  tester.testTextInput.hide();
  await tester.pump();
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

Future<void> press(WidgetTester tester, String text) async {
  await visible(tester, find.text(text));
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

Widget frame(Widget child) => MaterialApp(
  home: Scaffold(body: SingleChildScrollView(child: child)),
);
void main() {
  testWidgets(
    'Участники: поиск, пагинация, блокировка и конфликт сохраняют форму',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final id = 'u_${'1' * 64}';
      var revision = '1', blocked = false;
      var calls = 0;
      Future<Map<String, dynamic>> api(
        String path, {
        Map<String, dynamic>? body,
        String? method,
      }) async {
        if (method == 'PATCH') {
          calls++;
          if (body!['expectedRevision'] != revision) {
            throw SpaceApiError(409, 'Конфликт');
          }
          blocked = body['blocked'] == true;
          revision = '2';
          return {
            'member': {
              'principalId': id,
              'role': 'member',
              'blocked': blocked,
              'revision': revision,
            },
          };
        }
        if (path.contains('after=')) {
          return {
            'members': [
              {
                'principalId': 'u_${'2' * 64}',
                'role': 'reader',
                'revision': '1',
              },
            ],
          };
        }
        return {
          'members': [
            {
              'principalId': id,
              'role': 'member',
              'blocked': blocked,
              'revision': revision,
            },
            {'principalId': 'u_${'0' * 64}', 'role': 'owner', 'revision': '1'},
          ],
          'nextCursor': id,
        };
      }

      await tester.pumpWidget(frame(MembersPanel(call: api, owner: true)));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('member-search')),
        'Читатель',
      );
      await tester.pumpAndSettle();
      expect(find.text('Участники не найдены.'), findsOneWidget);
      await press(tester, 'Загрузить ещё участников');
      expect(find.text('Читатель'), findsNWidgets(2));
      await tester.enterText(find.byKey(const ValueKey('member-search')), '');
      await tester.pumpAndSettle();
      await visible(tester, find.byKey(ValueKey('edit-member-$id')));
      await tester.tap(find.byKey(ValueKey('edit-member-$id')));
      await tester.pumpAndSettle();
      await visible(tester, find.byKey(ValueKey('blocked-$id')));
      await tester.tap(find.byKey(ValueKey('blocked-$id')));
      await tester.pumpAndSettle();
      await press(tester, 'Сохранить права участника');
      await tester.tap(find.text('Применить права'));
      await tester.pumpAndSettle();
      expect(blocked, true);
      expect(calls, 1);
      revision = '3';
      await visible(tester, find.byKey(ValueKey('blocked-$id')));
      await tester.tap(find.byKey(ValueKey('blocked-$id')));
      await tester.pumpAndSettle();
      await press(tester, 'Сохранить права участника');
      await tester.tap(find.text('Применить права'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<SwitchListTile>(find.byKey(ValueKey('blocked-$id')))
            .value,
        false,
      );
      expect(blocked, true);
      expect(
        find.text(
          'Права уже изменились. Несохранённые значения остаются в форме. Обновите участников перед повтором.',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('Администратор видит участников без изменения ролей', (
    tester,
  ) async {
    await tester.pumpWidget(
      frame(
        MembersPanel(
          owner: false,
          call: (path, {body, method}) async => {
            'members': [
              {
                'principalId': 'u_${'1' * 64}',
                'role': 'member',
                'revision': '1',
              },
            ],
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Изменить права'), findsNothing);
    expect(find.text('Сохранить права участника'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'Приглашение: создание, копирование, отзыв и отсутствие токена после повторного открытия',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final invite = <String, dynamic>{
        'id': 'in_fixture',
        'role': 'member',
        'maxUses': 1,
        'uses': 0,
        'revoked': false,
        'expiresAt': '${DateTime.now().millisecondsSinceEpoch ~/ 1000 + 86400}',
      };
      var created = false;
      String? copied;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'Clipboard.setData') {
              copied = (call.arguments as Map)['text'] as String;
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );
      Future<Map<String, dynamic>> api(
        String path, {
        Map<String, dynamic>? body,
        String? method,
      }) async {
        if (path.endsWith('/revoke')) {
          invite['revoked'] = true;
          return {};
        }
        if (method == 'POST') {
          created = true;
          return {
            'invite': Map<String, dynamic>.from(invite),
            'token': 'iv_fixture_only',
          };
        }
        return {
          'invites': created ? [Map<String, dynamic>.from(invite)] : [],
        };
      }

      await tester.pumpWidget(
        frame(InvitesPanel(call: api, origin: 'http://127.0.0.1:8080')),
      );
      await tester.pumpAndSettle();
      await press(tester, 'Создать приглашение');
      expect(find.byKey(const ValueKey('issued-invite-token')), findsOneWidget);
      await visible(tester, find.text('Копировать код'));
      await tester.runAsync(() async {
        await tester.tap(find.text('Копировать код'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle();
      expect(copied, 'iv_fixture_only');
      await visible(tester, find.byKey(const ValueKey('revoke-in_fixture')));
      await tester.tap(find.byKey(const ValueKey('revoke-in_fixture')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(FilledButton, 'Отозвать приглашение'),
      );
      await tester.pumpAndSettle();
      expect(invite['revoked'], true);
      expect(find.byKey(const ValueKey('issued-invite-token')), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        frame(InvitesPanel(call: api, origin: 'http://127.0.0.1:8080')),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('issued-invite-token')), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
