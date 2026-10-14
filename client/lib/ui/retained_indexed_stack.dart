import 'package:flutter/widgets.dart';

/// Сохраняет страницы и не передаёт скрытым страницам обновления родителя.
class RetainedIndexedStack extends StatelessWidget {
  const RetainedIndexedStack({
    super.key,
    required this.index,
    required this.children,
  });

  final int index;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => IndexedStack(
    index: index,
    children: [
      for (var i = 0; i < children.length; i++)
        _RetainedPage(active: i == index, child: children[i]),
    ],
  );
}

class _RetainedPage extends StatefulWidget {
  const _RetainedPage({required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  State<_RetainedPage> createState() => _RetainedPageState();
}

class _RetainedPageState extends State<_RetainedPage> {
  late Widget _child = widget.child;

  @override
  void didUpdateWidget(_RetainedPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Перед скрытием передаём странице последнее обновление, включая active.
    if (widget.active || oldWidget.active) _child = widget.child;
  }

  @override
  Widget build(BuildContext context) => _child;
}
