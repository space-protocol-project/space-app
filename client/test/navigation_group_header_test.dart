import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/ui/navigation_group_header.dart';

void main() {
  testWidgets(
    'заголовки выровнены, значки сохраняют отступ, обновление справа',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 214,
              child: Column(
                children: [
                  for (final title in ['Чаты', 'Комнаты', 'Обсуждения'])
                    NavigationGroupHeader(
                      icon: Icons.forum_outlined,
                      title: title,
                      leadingInset: title == 'Обсуждения' ? 12 : 16,
                      refreshTooltip: 'Обновить',
                      onTap: () {},
                      onRefresh: () {},
                    ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final labels = find.byType(AutoSizeText);
      final buttons = find.byType(IconButton);
      for (var index = 0; index < 3; index++) {
      expect(tester.getTopLeft(labels.at(index)).dx, 48);
        expect(tester.getTopRight(buttons.at(index)).dx, 214);
        expect(tester.widget<AutoSizeText>(labels.at(index)).maxLines, 1);
      }
      final icons = find.byIcon(Icons.forum_outlined);
      expect(tester.getTopLeft(icons.at(0)).dx, 16);
      expect(tester.getTopLeft(icons.at(1)).dx, 16);
      expect(tester.getTopLeft(icons.at(2)).dx, 12);
      expect(tester.takeException(), isNull);
    },
  );
}
