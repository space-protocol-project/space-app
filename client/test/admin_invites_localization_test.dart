import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import 'admin_people_invites_test.dart' show press, visible;

void main() {
  for (final language in ['ru', 'zh', 'en']) {
    testWidgets('Состояния приглашений и запрет отзыва неактивных: $language', (
      tester,
    ) async {
      final strings = lookupAdminLocalizations(Locale(language));
      final future = '${DateTime.now().millisecondsSinceEpoch ~/ 1000 + 86400}';
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(language),
          supportedLocales: AdminLocalizations.supportedLocales,
          localizationsDelegates: AdminLocalizations.localizationsDelegates,
          home: Scaffold(
            body: SingleChildScrollView(
              child: InvitesPanel(
                origin: 'https://203.0.113.10:8443',
                call: (path, {body, method}) async => {
                  'invites': [
                    for (final state in [
                      'active',
                      'revoked',
                      'expired',
                      'used',
                    ])
                      {
                        'id': 'in_$state',
                        'role': 'reader',
                        'maxUses': 1,
                        'uses': state == 'used' ? 1 : 0,
                        'revoked': state == 'revoked',
                        'expiresAt': state == 'expired' ? '1' : future,
                      },
                  ],
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final state in [
        strings.inviteActiveState,
        strings.inviteRevokedState,
        strings.inviteExpiredState,
        strings.inviteUsedState,
      ]) {
        expect(find.text('${strings.roleReader} · $state'), findsOneWidget);
      }
      expect(find.byKey(const ValueKey('revoke-in_active')), findsOneWidget);
      for (final state in ['revoked', 'expired', 'used']) {
        expect(find.byKey(ValueKey('revoke-in_$state')), findsNothing);
      }
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'Язык приглашений сохраняет параметры, ссылку и подтверждение отзыва',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final locale = ValueNotifier(const Locale('ru'));
      addTearDown(locale.dispose);
      final token = 'iv_${'b' * 43}', pin = 'a' * 64;
      final link = 'https://203.0.113.10:8443#invite=$token&tls=$pin';
      final invite = <String, dynamic>{
        'id': 'in_fixture',
        'role': 'reader',
        'maxUses': 3,
        'uses': 0,
        'revoked': false,
        'expiresAt': '${DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600}',
      };
      Map<String, dynamic>? issued;
      var revocations = 0;
      String? copied;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'Clipboard.setData') {
              copied = (call.arguments as Map)['text'];
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );
      Widget page() => ValueListenableBuilder<Locale>(
        valueListenable: locale,
        builder: (_, language, _) => MaterialApp(
          locale: language,
          supportedLocales: AdminLocalizations.supportedLocales,
          localizationsDelegates: AdminLocalizations.localizationsDelegates,
          home: Scaffold(
            body: SingleChildScrollView(
              child: InvitesPanel(
                origin: 'https://203.0.113.10:8443',
                tlsFingerprint: pin,
                call: (path, {body, method}) async {
                  if (path.endsWith('/revoke')) {
                    expect(path, '/api/v1/space/invites/in_fixture/revoke');
                    revocations++;
                    invite['revoked'] = true;
                    return {};
                  }
                  if (method == 'POST') {
                    issued = Map.from(body!);
                    return {'invite': Map.from(invite), 'token': token};
                  }
                  return {
                    'invites': issued == null ? [] : [Map.from(invite)],
                  };
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(page());
      await tester.pumpAndSettle();
      await visible(tester, find.byKey(const ValueKey('invite-role')));
      await tester.tap(find.byKey(const ValueKey('invite-role')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Читатель — только чтение').last);
      await tester.pumpAndSettle();
      await visible(tester, find.byKey(const ValueKey('invite-ttl')));
      await tester.tap(find.byKey(const ValueKey('invite-ttl')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('1 час').last);
      await tester.pumpAndSettle();
      final uses = find.byKey(const ValueKey('invite-max-uses'));
      await tester.enterText(uses, '3');
      for (final language in ['zh', 'en', 'ru']) {
        locale.value = Locale(language);
        await tester.pumpAndSettle();
        final strings = lookupAdminLocalizations(Locale(language));
        expect(find.text(strings.inviteReader), findsOneWidget);
        expect(find.text(strings.inviteHour), findsOneWidget);
        expect(tester.widget<TextField>(uses).controller!.text, '3');
        expect(tester.takeException(), isNull);
      }
      await press(tester, 'Создать приглашение');
      expect(issued, {'role': 'reader', 'ttlSeconds': 3600, 'maxUses': 3});
      for (final language in ['zh', 'en', 'ru']) {
        locale.value = Locale(language);
        await tester.pumpAndSettle();
        final strings = lookupAdminLocalizations(Locale(language));
        expect(
          tester
              .widget<SelectableText>(
                find.byKey(const ValueKey('issued-invite-link')),
              )
              .data,
          link,
        );
        expect(
          tester
              .widget<SelectableText>(
                find.byKey(const ValueKey('issued-invite-token')),
              )
              .data,
          token,
        );
        await visible(tester, find.text(strings.inviteCopyLink));
        await tester.runAsync(() async {
          await tester.tap(find.text(strings.inviteCopyLink));
          await Future<void>.delayed(const Duration(milliseconds: 50));
        });
        await tester.pumpAndSettle();
        expect(copied, link);
        await visible(tester, find.byKey(const ValueKey('revoke-in_fixture')));
        await tester.tap(find.byKey(const ValueKey('revoke-in_fixture')));
        await tester.pumpAndSettle();
        expect(find.text(strings.inviteRevokeConfirm), findsOneWidget);
        await tester.tap(find.text(strings.cancel));
        await tester.pumpAndSettle();
        expect(revocations, 0);
        expect(tester.takeException(), isNull);
      }
      await visible(tester, find.byKey(const ValueKey('revoke-in_fixture')));
      await tester.tap(find.byKey(const ValueKey('revoke-in_fixture')));
      await tester.pumpAndSettle();
      locale.value = const Locale('en');
      await tester.pumpAndSettle();
      expect(find.text('Revoke invitation?'), findsOneWidget);
      expect(revocations, 0);
      await tester.tap(find.widgetWithText(FilledButton, 'Revoke invitation'));
      await tester.pumpAndSettle();
      expect(revocations, 1);
      expect(find.byKey(const ValueKey('issued-invite-token')), findsNothing);
      locale.value = const Locale('zh');
      await tester.pumpAndSettle();
      expect(
        find.text(lookupAdminLocalizations(const Locale('zh')).inviteRevoked),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
