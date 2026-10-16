import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/chat_view.dart';

import 'channels_test.dart' show ChannelSession, MemoryPositions, connected;

void main() {
  for (final language in ['ru', 'zh', 'en']) {
    testWidgets(
      'Ожидающие сообщения и подтверждение удаления на 390px: $language',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controller = (await tester.runAsync(
          () => connected(ChannelSession()..failSend = true, MemoryPositions()),
        ))!;
        addTearDown(controller.dispose);
        await tester.runAsync(() async {
          await controller.send('Первое 不丢失 — pending');
          await controller.send('Второе сохранённое сообщение');
        });
        final strings = lookupAppLocalizations(Locale(language));
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(language),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.5)),
              child: child!,
            ),
            home: Scaffold(
              body: ChatView(controller: controller, openConnection: () {}),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
              .enabled,
          true,
        );
        await tester.tap(find.byKey(const ValueKey('open-outbox')));
        await tester.pumpAndSettle();
        expect(find.text(strings.outboxWaiting), findsNWidgets(2));
        await tester.tap(find.byTooltip(strings.outboxDiscard).first);
        await tester.pumpAndSettle();
        expect(find.text(strings.outboxDiscardDescription), findsOneWidget);
        await tester.tap(
          find.widgetWithText(TextButton, strings.cancelMessageChange),
        );
        await tester.pumpAndSettle();
        expect(controller.pendingMessages, hasLength(2));
        await tester.tap(find.byTooltip(strings.outboxDiscard).first);
        await tester.pumpAndSettle();
        await tester.tap(
          find.widgetWithText(TextButton, strings.outboxDiscard),
        );
        await tester.pumpAndSettle();
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 20));
        });
        await tester.pumpAndSettle();
        expect(controller.pendingMessages, hasLength(1));
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}
