import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/components.dart';

void main() {
  for (final compact in [false, true]) {
    testWidgets('Многострочные кнопки сохраняют отступы, compact=$compact', (
      tester,
    ) async {
      final preferences = AppPreferences()..compact = compact;
      await tester.pumpWidget(
        MaterialApp(
          theme: preferences.theme,
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: Column(
                children: [
                  SizedBox(
                    width: 180,
                    child: SpaceActionButton(
                      label: 'Проверить\nдоступ',
                      icon: Icons.link,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Добавить\nпространство',
                        key: ValueKey('add-label'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'Проверить\nподключение',
                        key: ValueKey('check-label'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final label in [
        find.byKey(const ValueKey('add-label')),
        find.byKey(const ValueKey('check-label')),
        find.text('Проверить\nдоступ'),
      ]) {
        final surface = find
            .ancestor(of: label, matching: find.byType(Material))
            .first;
        final outer = tester.getRect(surface), inner = tester.getRect(label);
        expect(inner.top - outer.top, greaterThanOrEqualTo(8));
        expect(outer.bottom - inner.bottom, greaterThanOrEqualTo(8));
        expect(inner.left - outer.left, greaterThanOrEqualTo(12));
        expect(outer.right - inner.right, greaterThanOrEqualTo(12));
      }
      expect(tester.takeException(), isNull);
      preferences.dispose();
    });
  }
}
