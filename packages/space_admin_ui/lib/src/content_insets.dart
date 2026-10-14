import 'package:flutter/widgets.dart';

// Перекрытие верхней панелью передаёт приложение; самостоятельные формы используют 0.
class SpaceContentInsets extends InheritedWidget {
  const SpaceContentInsets({
    super.key,
    required this.top,
    required super.child,
  });
  final double top;
  static double topOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SpaceContentInsets>()?.top ??
      0;
  static EdgeInsets scrollPaddingOf(BuildContext context) =>
      EdgeInsets.fromLTRB(20, topOf(context) + 20, 20, 20);
  @override
  bool updateShouldNotify(SpaceContentInsets oldWidget) => top != oldWidget.top;
}
