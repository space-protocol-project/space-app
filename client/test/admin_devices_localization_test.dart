import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import 'admin_people_invites_test.dart' show visible;

void main() {
  testWidgets(
    'Смена языка сохраняет цель отзыва и пароль, без автоматического согласия',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final locale = ValueNotifier(const Locale('ru'));
      addTearDown(locale.dispose);
      final grant = <String, dynamic>{
        'id': 'other',
        'expiresAt': '4102444800',
        'parentGrantId': 'card',
        'scopes': ['chat.read', 'space.manage'],
      };
      var revocations = 0, revoked = false;
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, language, _) => MaterialApp(
            locale: language,
            supportedLocales: AdminLocalizations.supportedLocales,
            localizationsDelegates: AdminLocalizations.localizationsDelegates,
            home: Scaffold(
              body: SingleChildScrollView(
                child: DevicesPanel(
                  currentGrantId: 'current',
                  call: (path, {body, method}) async => {
                    'devices': revoked ? [] : [grant],
                  },
                  revoke: (selected, password) async {
                    expect(selected, grant);
                    expect(selected['scopes'], ['chat.read', 'space.manage']);
                    expect(password, '未翻译-secret');
                    revocations++;
                    revoked = true;
                  },
                  onRevoked: () =>
                      fail('Отзыв другого устройства не отключает текущее'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final language in ['zh', 'en', 'ru']) {
        locale.value = Locale(language);
        await tester.pumpAndSettle();
        final strings = lookupAdminLocalizations(Locale(language));
        expect(
          find.text(strings.deviceScopes('chat.read, space.manage')),
          findsOneWidget,
        );
        expect(find.text(strings.deviceParent('card')), findsOneWidget);
        await visible(
          tester,
          find.byKey(const ValueKey('revoke-device-other')),
        );
        await tester.tap(find.byKey(const ValueKey('revoke-device-other')));
        await tester.pumpAndSettle();
        expect(find.text(strings.deviceOtherWarning), findsOneWidget);
        await tester.tap(find.text(strings.cancel));
        await tester.pumpAndSettle();
        expect(revocations, 0);
        expect(tester.takeException(), isNull);
      }
      await visible(tester, find.byKey(const ValueKey('revoke-device-other')));
      await tester.tap(find.byKey(const ValueKey('revoke-device-other')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '未翻译-secret');
      for (final language in ['zh', 'en']) {
        locale.value = Locale(language);
        await tester.pumpAndSettle();
        final strings = lookupAdminLocalizations(Locale(language));
        expect(find.text(strings.deviceRevokeConfirm), findsOneWidget);
        expect(find.text(strings.deviceCardPassword), findsOneWidget);
        expect(
          tester
              .widget<EditableText>(
                find.descendant(
                  of: find.byType(TextField),
                  matching: find.byType(EditableText),
                ),
              )
              .controller
              .text,
          '未翻译-secret',
        );
        expect(revocations, 0);
      }
      await tester.tap(find.text('Revoke'));
      await tester.pumpAndSettle();
      expect(revocations, 1);
      expect(find.text('other'), findsNothing);
      locale.value = const Locale('zh');
      await tester.pumpAndSettle();
      expect(
        find.text(
          lookupAdminLocalizations(const Locale('zh')).deviceRevokedStatus,
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
