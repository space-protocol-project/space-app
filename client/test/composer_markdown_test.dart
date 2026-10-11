import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/message_bubble.dart';

import 'stream_test.dart' show Session, connect;

class NetworkCounter extends HttpOverrides {
  int requests = 0;
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    requests++;
    return super.createHttpClient(context);
  }
}

void main() {
  for (final shift in [false, true]) {
    testWidgets('Отправка Enter/Shift+Enter: $shift', (tester) async {
      final session = Session();
      final c = (await tester.runAsync(() => connect(session)))!;
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ChatView(
              controller: c,
              openConnection: () {},
              sendWithShift: shift,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final field = find.byKey(const ValueKey('chat-draft'));
      await tester.enterText(field, 'Сообщение');
      if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pumpAndSettle();
      expect(c.messages.single.text, 'Сообщение');
      expect(tester.widget<TextField>(field).controller!.text, isEmpty);
      await tester.enterText(field, 'Не отправлять');
      if (!shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      if (!shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pumpAndSettle();
      expect(c.messages.length, 1);
      expect(tester.widget<TextField>(field).controller!.text, contains('\n'));
    });
  }
  test('Клавиша отправки сохраняется', () async {
    SharedPreferences.setMockInitialValues({});
    final p = AppPreferences();
    await p.load();
    expect(p.sendShortcut, 'enter');
    await p.change(sendShortcut: 'shiftEnter');
    final restored = AppPreferences();
    await restored.load();
    expect(restored.sendShortcut, 'shiftEnter');
    p.dispose();
    restored.dispose();
  });
  testWidgets('Markdown форматирует текст и не загружает внешнее изображение', (
    tester,
  ) async {
    final network = NetworkCounter();
    HttpOverrides.global = network;
    addTearDown(() => HttpOverrides.global = null);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MessageBubble(
            text: '**Жирный**\n\n- Пункт\n\n`код`\n\n![изображение](https://example.org/image.png)',
            author: 'A',
            mine: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('**Жирный**'), findsNothing);
    expect(find.textContaining('Жирный', findRichText: true), findsWidgets);
    expect(network.requests, 0);
    expect(tester.takeException(), isNull);
  });
}
