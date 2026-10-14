import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/ui/message_bubble.dart';

import 'channels_test.dart' show CatalogSession, MemoryPositions, connected;

void main() {
  testWidgets('Каналы доступны в меню и не занимают место под заголовком', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = (await tester.runAsync(
      () => connected(CatalogSession(), MemoryPositions()),
    ))!;
    await tester.pumpWidget(SpaceApp(controller: controller));
    await tester.pumpAndSettle();
    final menu = find.byKey(const ValueKey('navigation-menu-button'));
    await tester.tap(menu);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(MessageBubble).first).top, lessThan(180));
    await tester.tap(menu);
    await tester.pumpAndSettle();
    final archived = find.widgetWithText(ListTile, 'Чат archive');
    await tester.ensureVisible(archived);
    await tester.tap(archived);
    await tester.runAsync(() async => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(controller.channelId, 'archive');
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
          .enabled,
      false,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(controller.close);
  });
}
