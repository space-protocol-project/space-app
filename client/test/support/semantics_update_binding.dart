import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

class SemanticsUpdateBinding extends AutomatedTestWidgetsFlutterBinding {
  final nodes = <int, List<int>>{};
  final orphanUpdates = <int>[];

  @override
  ui.SemanticsUpdateBuilder createSemanticsUpdateBuilder() =>
      _UpdateBuilder(this);

  void apply(Map<int, List<int>> updates) {
    // AXTree получает приращения: каждый обновлённый узел должен оставаться
    // достижимым от корня после применения очередного пакета.
    nodes.addAll(updates);
    final reachable = <int>{};
    void visit(int id) {
      if (!reachable.add(id)) return;
      for (final child in nodes[id] ?? <int>[]) {
        visit(child);
      }
    }

    visit(0);
    orphanUpdates.addAll(updates.keys.where((id) => !reachable.contains(id)));
    nodes.removeWhere((id, _) => !reachable.contains(id));
  }
}

class _UpdateBuilder extends Fake implements ui.SemanticsUpdateBuilder {
  _UpdateBuilder(this.binding);
  final SemanticsUpdateBinding binding;
  final updates = <int, List<int>>{};

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #updateNode) {
      final args = invocation.namedArguments;
      updates[args[#id] as int] = List<int>.from(
        args[#childrenInTraversalOrder] as Iterable<int>,
      );
      return null;
    }
    if (invocation.memberName == #updateCustomAction) return null;
    return super.noSuchMethod(invocation);
  }

  @override
  ui.SemanticsUpdate build() {
    binding.apply(updates);
    return ui.SemanticsUpdateBuilder().build();
  }
}
