import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/ui/search.dart';
import 'package:space_client/ui/space_appearance.dart';
import 'package:space_client/ui/space_frame.dart';

void main() {
  test('Выключенные эффекты сохраняются после перезапуска', () async {
    SharedPreferences.setMockInitialValues({});
    final first = AppPreferences();
    await first.change(effects: false, palette: 'iris', language: 'en');
    final restored = AppPreferences();
    await restored.load();
    expect(restored.effects, false);
    expect(restored.palette, 'iris');
    expect(restored.language, 'en');
    expect(restored.theme.extension<SpaceAppearance>()!.effects, false);
    await first.close();
    await restored.close();
  });

  testWidgets('Выключенные эффекты дают непрозрачную поверхность', (
    tester,
  ) async {
    final preferences = AppPreferences()..effects = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: preferences.theme,
        home: const Scaffold(body: GlassSurface(child: Text('Текст'))),
      ),
    );
    expect(find.byType(BackdropFilter), findsNothing);
    await tester.runAsync(preferences.close);
  });

  testWidgets('Поиск возвращает идентификатор выбранного сообщения', (
    tester,
  ) async {
    String? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showSearch<String>(
                  context: context,
                  delegate: SpaceSearch({}, [
                    Content(id: 'точный-id', text: 'Найди меня'),
                  ], 'Поиск'),
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
    await tester.enterText(find.byType(TextField), 'Найди');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Найди меня'));
    await tester.pumpAndSettle();
    expect(result, 'message:точный-id');
  });

  testWidgets(
    'Панель обрезается после полосы пространств и не перехватывает скрытые нажатия',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var opened = false, tapped = 0;
      late StateSetter change;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              change = setState;
              return Scaffold(
                body: SpaceFrame(
                  compact: true,
                  navigationOpen: opened,
                  rail: const ColoredBox(
                    key: ValueKey('полоса'),
                    color: Colors.red,
                  ),
                  sidebar: const ColoredBox(
                    key: ValueKey('панель'),
                    color: Colors.blue,
                  ),
                  content: GestureDetector(
                    onTap: () => tapped++,
                    child: const ColoredBox(color: Colors.green),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.tapAt(const Offset(150, 100));
      expect(tapped, 1);
      change(() => opened = true);
      await tester.pump();
      for (var frame = 0; frame < 4; frame++) {
        await tester.pump(const Duration(milliseconds: 70));
        final clips = tester.widgetList<ClipRect>(
          find.ancestor(
            of: find.byKey(const ValueKey('панель')),
            matching: find.byType(ClipRect),
          ),
        );
        expect(clips, isNotEmpty);
        final clip = find
            .ancestor(
              of: find.byKey(const ValueKey('панель')),
              matching: find.byType(ClipRect),
            )
            .first;
        expect(
          tester.getRect(clip).left,
          tester.getRect(find.byKey(const ValueKey('полоса'))).right,
        );
        expect(tester.takeException(), isNull);
      }
      change(() => opened = false);
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(150, 100));
      expect(tapped, 2);
    },
  );
}
