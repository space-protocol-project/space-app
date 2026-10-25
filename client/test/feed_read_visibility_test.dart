import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/ui/forum_read_tracker.dart';

Widget page(ForumReadTracker tracker, ValueChanged<BuildContext> capture) =>
    MaterialApp(
      home: Builder(
        builder: (context) {
          capture(context);
          return Scaffold(
            body: SizedBox.expand(
              child: SingleChildScrollView(
                key: tracker.viewport,
                child: Column(
                  children: [
                    tracker.track(0, const SizedBox(height: 40)),
                    tracker.track(1, const SizedBox(height: 1000)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

void main() {
  testWidgets('конец записи под заголовком не подтверждает чтение', (
    tester,
  ) async {
    final tracker = ForumReadTracker();
    late BuildContext context;
    final reads = <int>[];
    await tester.pumpWidget(page(tracker, (value) => context = value));
    tracker.schedule(context, () => true, reads.add, topPadding: 80);
    tester.binding.scheduleFrame();
    await tester.pump();
    expect(reads, isEmpty);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -1500),
    );
    await tester.pumpAndSettle();
    tracker.schedule(context, () => true, reads.add, topPadding: 80);
    tester.binding.scheduleFrame();
    await tester.pump();
    expect(reads, [1]);
  });

  testWidgets('перекрывающий диалог не подтверждает чтение', (tester) async {
    final tracker = ForumReadTracker();
    late BuildContext context;
    final reads = <int>[];
    await tester.pumpWidget(page(tracker, (value) => context = value));
    final dialog = showDialog<void>(
      context: context,
      builder: (_) => const AlertDialog(content: Text('Диалог')),
    );
    tracker.schedule(context, () => true, reads.add);
    await tester.pumpAndSettle();
    expect(reads, isEmpty);
    Navigator.of(context).pop();
    await dialog;
    await tester.pumpAndSettle();
    tracker.schedule(context, () => true, reads.add);
    tester.binding.scheduleFrame();
    await tester.pump();
    expect(reads, [0]);
  });
}
