import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/reactions.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/ui/emoji_picker.dart';
import 'package:space_client/ui/message_context_menu.dart';
import 'package:space_client/ui/message_markdown.dart';

Widget app(Widget child) => MaterialApp(
  locale: const Locale('ru'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  test(
    'Эмодзи заменяет выделение и вставляется без разрыва последовательности',
    () {
      final controller = TextEditingController(text: 'Привет мир');
      addTearDown(controller.dispose);
      controller.selection = const TextSelection(
        baseOffset: 7,
        extentOffset: 10,
      );
      insertEmoji(controller, '👩🏽‍💻');
      expect(controller.text, 'Привет 👩🏽‍💻');
      expect(controller.selection.extentOffset, controller.text.length);
    },
  );

  test(
    'MLS: устройства одного участника, повтор, снятие и неизвестная цель',
    () {
      final id = List.filled(16, 1);
      Map<String, dynamic> message() => {
        'grant_id': 'author-device',
        'author_id': 'author',
        'message': {'id': id, 'text': 'Текст', 'files': []},
      };
      Map<String, dynamic> reaction(
        String grant,
        bool active, {
        String target = 'author-device',
      }) => {
        'grant_id': grant,
        'author_id': 'participant',
        'message': {
          'id': List.filled(16, 2),
          'text': '',
          'files': [],
          'reaction': {
            'message_id': id,
            'grant_id': target,
            'emoji': '👍',
            'active': active,
          },
        },
      };
      final events = [
        message(),
        reaction('phone', true),
        reaction('desktop', true),
        reaction('phone', true),
      ];
      final projected = projectMlsReactions(events);
      expect(projected, hasLength(1));
      expect(
        (projected.single['reactions'] as List<Reaction>).single.principalIds,
        ['participant'],
      );
      events.add(reaction('desktop', false));
      events.add(reaction('phone', true, target: 'other-channel-author'));
      expect(projectMlsReactions(events).single['reactions'], isEmpty);
    },
  );

  for (final touch in [false, true]) {
    testWidgets('Меню сообщения: ${touch ? "удержание" : "правый клик"}', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        app(
          MessageContextMenu(
            text: 'Текст',
            onReact: (value) => selected = value,
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: MessageMarkdown(text: 'Текст'),
            ),
          ),
        ),
      );
      final target = find.text('Текст');
      if (touch) {
        final gesture = await tester.startGesture(tester.getCenter(target));
        await tester.pump(const Duration(milliseconds: 600));
        await gesture.up();
      } else {
        await tester.tap(target, buttons: kSecondaryMouseButton);
      }
      await tester.pumpAndSettle();
      expect(find.text('Скопировать'), findsOneWidget);
      expect(find.text('👍'), findsOneWidget);
      await tester.tap(find.text('👍'));
      await tester.pumpAndSettle();
      expect(selected, '👍');
      expect(find.text('Скопировать'), findsNothing);
    });
  }

  testWidgets('Поиск эмодзи по русскому имени и недавние', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(app(EmojiButton(controller: controller)));
    await tester.tap(find.byType(EmojiButton));
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'сердце');
    await tester.pumpAndSettle();
    expect(find.text('❤️'), findsOneWidget);
    await tester.tap(find.text('❤️'));
    await tester.pumpAndSettle();
    expect(controller.text, '❤️');
    expect(
      (await SharedPreferences.getInstance()).getStringList(
        'space.emoji.recent',
      ),
      ['❤️'],
    );
  });
}
