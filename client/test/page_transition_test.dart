import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/ui/page_transition.dart';

void main() {
  for (final disabled in [false, true]) {
    testWidgets(
      'переход заменяет старое содержимое; анимации отключены: $disabled',
      (tester) async {
        Future<void> render(int id) => tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(disableAnimations: disabled),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: PageTransition(
                transitionKey: id,
                child: Text('Экран $id'),
              ),
            ),
          ),
        );
        await render(0);
        await render(1);
        expect(find.text('Экран 0', skipOffstage: false), findsNothing);
        final opacity = tester
            .widget<FadeTransition>(find.byType(FadeTransition))
            .opacity;
        expect(opacity.value, disabled ? 1 : 0);
        await tester.pump(const Duration(milliseconds: 90));
        if (!disabled) expect(opacity.value, inExclusiveRange(0, 1));
        await tester.pumpAndSettle();
        expect(opacity.value, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
