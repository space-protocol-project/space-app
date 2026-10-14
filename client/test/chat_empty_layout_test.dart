import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/measure_size.dart';

import 'shell_test.dart' show TestController;

void main() {
  testWidgets('Пустой чат прокручивается между заголовком и полем ввода', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 420);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = TestController()..connected = true;
    controller.publishState();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatView(
            controller: controller,
            openConnection: () {},
            showHeader: false,
            topInset: 100,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final emptyScroll = find.byType(SingleChildScrollView);
    final composer = find.byType(MeasureSize);
    expect(tester.getRect(emptyScroll).top, greaterThanOrEqualTo(100));
    expect(
      tester.getRect(emptyScroll).bottom,
      lessThan(tester.getRect(composer).top),
    );
    await tester.drag(emptyScroll, const Offset(0, -180));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(controller.close);
  });
}
