import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import 'admin_people_invites_test.dart' show press, visible;

void main() {
  testWidgets('Язык участников сохраняет поиск, роль, блокировку и согласие', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final locale = ValueNotifier(const Locale('ru'));
    addTearDown(locale.dispose);
    final id = 'u_${'1' * 64}';
    Map<String, dynamic>? saved;
    await tester.pumpWidget(
      ValueListenableBuilder<Locale>(
        valueListenable: locale,
        builder: (_, language, _) => MaterialApp(
          locale: language,
          supportedLocales: AdminLocalizations.supportedLocales,
          localizationsDelegates: AdminLocalizations.localizationsDelegates,
          home: Scaffold(
            body: SingleChildScrollView(
              child: MembersPanel(
                owner: true,
                call: (path, {body, method}) async {
                  if (method == 'PATCH') {
                    expect(path, '/api/v1/space/members/$id');
                    saved = Map.from(body!);
                    return {
                      'member': {'principalId': id, ...body, 'revision': '2'},
                    };
                  }
                  return {
                    'members': [
                      {
                        'principalId': id,
                        'role': 'member',
                        'blocked': false,
                        'revision': '1',
                      },
                    ],
                  };
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final card = find.byKey(ValueKey('member-card-$id'));
    final size = tester.getSize(card);
    expect(size.height, closeTo(size.width, 1));
    expect(tester.takeException(), isNull);
    final search = find.byKey(const ValueKey('member-search'));
    await tester.enterText(search, id);
    await tester.pumpAndSettle();
    await visible(tester, find.byKey(ValueKey('edit-member-$id')));
    await tester.tap(find.byKey(ValueKey('edit-member-$id')));
    await tester.pumpAndSettle();
    await visible(tester, find.byKey(ValueKey('role-$id-1')));
    await tester.tap(find.byKey(ValueKey('role-$id-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Администратор').last);
    await tester.pumpAndSettle();
    await visible(tester, find.byKey(ValueKey('blocked-$id')));
    await tester.tap(find.byKey(ValueKey('blocked-$id')));
    await tester.pumpAndSettle();
    for (final language in ['zh', 'en', 'ru']) {
      locale.value = Locale(language);
      await tester.pumpAndSettle();
      final strings = lookupAdminLocalizations(Locale(language));
      expect(tester.widget<TextField>(search).controller!.text, id);
      expect(find.text(strings.roleAdmin), findsOneWidget);
      expect(
        tester
            .widget<SwitchListTile>(find.byKey(ValueKey('blocked-$id')))
            .value,
        true,
      );
      await press(tester, strings.memberSave);
      expect(find.text(strings.memberConfirm), findsOneWidget);
      expect(
        find.text(
          strings.memberProposal(id, strings.roleAdmin, strings.memberBlocked),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text(strings.cancel));
      await tester.pumpAndSettle();
      expect(saved, isNull);
      expect(tester.takeException(), isNull);
    }
    await press(tester, 'Сохранить права участника');
    locale.value = const Locale('en');
    await tester.pumpAndSettle();
    expect(find.text('Change member permissions?'), findsOneWidget);
    await tester.tap(find.text('Apply permissions'));
    await tester.pumpAndSettle();
    expect(saved, {'role': 'admin', 'blocked': true, 'expectedRevision': '1'});
    locale.value = const Locale('zh');
    await tester.pumpAndSettle();
    expect(
      find.text(lookupAdminLocalizations(const Locale('zh')).memberSaved),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
