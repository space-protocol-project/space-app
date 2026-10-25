import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/personal_inbox_controller.dart';
import 'package:space_client/src/personal_notification_target.dart';
import 'package:space_client/src/personal_notifications_controller.dart';
import 'package:space_client/ui/personal_inbox.dart';

import 'support/personal_notifications.dart';

void main() {
  for (final width in [360.0, 1200.0]) {
    testWidgets('Список, просмотр и переход: ширина $width', (tester) async {
      tester.view.physicalSize = Size(width, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final fixture = PersonalTestWorkspace();
      await tester.runAsync(fixture.start);
      final notifications = PersonalNotificationsController(
        fixture.workspaces,
        interval: null,
        deliver: (_, _) async => true,
      );
      fixture.api.add(personalNotice(1));
      fixture.api.add(personalNotice(2));
      final inbox = PersonalInboxController(notifications, interval: null);
      PersonalNotificationTarget? opened;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  opened = await showDialog<PersonalNotificationTarget>(
                    context: context,
                    builder: (_) => PersonalInbox(controller: inbox),
                  );
                },
                child: const Text('Открыть'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Открыть'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('personal-notice-pn_1')),
        findsOneWidget,
      );
      expect(fixture.api.readIds, isEmpty);
      await tester.tap(find.byKey(const ValueKey('personal-read-pn_1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('personal-notice-pn_1')), findsNothing);
      expect(fixture.api.readIds.single, ['pn_1']);
      await tester.tap(find.byKey(const ValueKey('personal-notice-pn_2')));
      await tester.pumpAndSettle();
      expect(opened?.id, 'pn_2');
      expect(fixture.api.readIds, hasLength(1));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(() async {
        await inbox.close();
        await notifications.close();
        fixture.dispose();
      });
      await tester.pumpAndSettle();
    });
  }
}
