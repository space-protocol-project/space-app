import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/ui/message_bubble.dart';
import 'package:space_client/ui/message_reactions.dart';
import 'package:space_client/ui/reaction_people.dart';

void main() {
  for (final width in [390.0, 1100.0]) {
    for (final scale in [1.0, 1.5]) {
      testWidgets(
        'Реакции слева, время справа, без кнопки избранного: $width / $scale',
        (tester) async {
          tester.view.physicalSize = Size(width, 800);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await tester.pumpWidget(
            MaterialApp(
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: Scaffold(
                body: MessageBubble(
                  text: 'Готово',
                  author: 'Мария',
                  mine: false,
                  sentAt: DateTime(2026, 10, 17, 13, 23),
                  onToggleFavorite: () {},
                  reactions: MessageReactionBar(
                    reactions: [
                      Reaction(emoji: '👍', principalIds: ['maria', 'ilya']),
                    ],
                    principalId: 'maria',
                    authorName: (id) => id == 'maria' ? 'Мария' : 'Илья',
                    onSet: (_, _) {},
                  ),
                ),
              ),
            ),
          );
          final time = tester.getRect(find.text('13:23'));
          final people = tester.getRect(find.byType(ReactionPeople));
          expect(time.left, greaterThan(people.right));
          expect(time.top, lessThan(people.bottom + 8));
          expect(time.bottom, greaterThan(people.top));
          expect(
            people.top - tester.getRect(find.text('Готово')).bottom,
            greaterThanOrEqualTo(10),
          );
          expect(find.byIcon(Icons.bookmark_border), findsNothing);
          expect(find.byTooltip('Мария\nmaria'), findsOneWidget);
          expect(find.byTooltip('Илья\nilya'), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
