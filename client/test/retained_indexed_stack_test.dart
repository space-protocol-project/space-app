import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/ui/retained_indexed_stack.dart';

void main() {
  testWidgets('Скрытая страница сохраняет состояние без лишних перестроений', (
    tester,
  ) async {
    final builds = [0, 0];
    var index = 0;
    var revision = 0;
    Widget page(int i) => Builder(
      builder: (context) {
        builds[i]++;
        return _Draft(label: '$i:$revision:${i == index}');
      },
    );
    Future<void> render() => tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RetainedIndexedStack(index: index, children: [page(0), page(1)]),
      ),
    );

    await render();
    final state = tester.state<_DraftState>(find.byType(_Draft).first);
    state.value = 'Черновик';
    revision++;
    await render();
    expect(builds, [2, 1]);
    index = 1;
    await render();
    expect(builds, [3, 2]);
    expect(
      find.text('0:1:false Черновик', skipOffstage: false),
      findsOneWidget,
    );
    revision++;
    await render();
    expect(builds, [3, 3]);
    index = 0;
    await render();
    expect(find.text('0:2:true Черновик'), findsOneWidget);
    expect(tester.state<_DraftState>(find.byType(_Draft).first), same(state));
  });
}

class _Draft extends StatefulWidget {
  const _Draft({required this.label});
  final String label;

  @override
  State<_Draft> createState() => _DraftState();
}

class _DraftState extends State<_Draft> {
  String value = '';

  @override
  Widget build(BuildContext context) => Text('${widget.label} $value');
}
