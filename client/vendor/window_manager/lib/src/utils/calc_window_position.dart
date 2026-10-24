import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';

Future<Offset> calcWindowPosition(Size windowSize, Alignment alignment) async {
  final manager = DisplayManager.instance;
  final displays = manager.getAll();
  final primary = manager.getPrimary();
  if (primary == null) throw StateError('No primary display');
  final cursor = manager.getCursorPosition().toOffset();
  final current = displays.firstWhere(
    (display) => display.workArea.toRect().contains(cursor),
    orElse: () => primary,
  );
  final area = current.workArea.toRect();
  return area.topLeft + alignment.alongOffset(Offset(
    area.width - windowSize.width,
    area.height - windowSize.height,
  ));
}
