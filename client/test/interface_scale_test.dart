import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/interface_scale.dart';

void main() {
  test('Масштаб сохраняется; неподдерживаемое значение сбрасывается', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences();
    final restored = AppPreferences();
    addTearDown(preferences.dispose);
    addTearDown(restored.dispose);
    await preferences.change(uiScale: 1.5);
    await restored.load();
    expect(restored.state.uiScale, 1.5);
    await restored.change(uiScale: double.nan);
    expect(restored.state.uiScale, 1);
  });

  for (final scale in [0.75, 1.0, 1.5]) {
    testWidgets('Геометрия, клавиатура и нажатия при масштабе $scale', (
      tester,
    ) async {
      var taps = 0;
      late MediaQueryData actual;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(viewInsets: const EdgeInsets.only(bottom: 180)),
            child: InterfaceScale(scale: scale, child: child!),
          ),
          home: Builder(
            builder: (context) {
              actual = MediaQuery.of(context);
              return Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: FilledButton(
                      onPressed: () => taps++,
                      child: const Text('OK'),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(actual.size.width, closeTo(800 / scale, 0.01));
      expect(actual.viewInsets.bottom, closeTo(180 / scale, 0.01));
      final button = find.byType(FilledButton);
      final topLeft = tester.getTopLeft(button);
      final bottomRight = tester.getBottomRight(button);
      expect(bottomRight.dx - topLeft.dx, closeTo(100 * scale, 0.01));
      await tester.tap(button);
      expect(taps, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
