import 'package:flutter/material.dart';

abstract interface class SpacedControl {}

bool _control(Widget widget) {
  if (widget is SpacedControl ||
      widget is ButtonStyleButton ||
      widget is IconButton ||
      widget is TextField ||
      widget is DropdownButtonFormField ||
      widget is CheckboxListTile ||
      widget is SwitchListTile) {
    return true;
  }
  final children = widget is Wrap
      ? widget.children
      : widget is Row
      ? widget.children
      : const <Widget>[];
  return children.any(_control);
}

bool _separator(Widget widget) =>
    widget is SizedBox ||
    widget is Divider ||
    widget is Flexible ||
    widget is Spacer;

bool _besideControl(Widget? a, Widget? b) =>
    (a != null && _control(a)) || (b != null && _control(b));

Widget spaceControls(Widget child) {
  if (child is! Column) return child;
  final children = <Widget>[];
  for (var i = 0; i < child.children.length; i++) {
    final current = child.children[i];
    final previous = i > 0 ? child.children[i - 1] : null;
    final next = i + 1 < child.children.length ? child.children[i + 1] : null;
    children.addAll(_spacedControl(previous, current, next));
  }
  return Column(
    key: child.key,
    mainAxisAlignment: child.mainAxisAlignment,
    mainAxisSize: child.mainAxisSize,
    crossAxisAlignment: child.crossAxisAlignment,
    textDirection: child.textDirection,
    verticalDirection: child.verticalDirection,
    textBaseline: child.textBaseline,
    children: children,
  );
}

List<Widget> _spacedControl(Widget? previous, Widget current, Widget? next) {
  final result = <Widget>[];
  if (current is SizedBox &&
      current.height != null &&
      _besideControl(previous, next)) {
    result.add(
      SizedBox(
        width: current.width,
        height: current.height! < 16 ? 16 : current.height,
        child: current.child,
      ),
    );
  } else {
    if (_needsControlGap(previous, current)) {
      result.add(const SizedBox(height: 16));
    }
    result.add(current);
  }
  return result;
}

bool _needsControlGap(Widget? previous, Widget current) =>
    previous != null &&
    !_separator(current) &&
    !_separator(previous) &&
    _besideControl(previous, current);
