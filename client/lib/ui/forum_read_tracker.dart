import 'dart:math' as math;

import 'package:flutter/material.dart';

// Подтверждаем только сообщения, до конца которых пользователь дошёл в видимой области.
class ForumReadTracker {
  final viewport = GlobalKey();
  final keys = <int, GlobalKey>{};
  String topic = '';
  bool scheduled = false;

  void select(String id) {
    if (topic == id) return;
    topic = id;
    keys.clear();
  }

  Widget track(int sequence, Widget child) => KeyedSubtree(
    key: keys.putIfAbsent(sequence, GlobalKey.new),
    child: child,
  );

  void schedule(
    BuildContext context,
    bool Function() active,
    ValueChanged<int> read,
  ) {
    if (scheduled) return;
    scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scheduled = false;
      if (!context.mounted ||
          !active() ||
          ModalRoute.of(context)?.isCurrent == false) {
        return;
      }
      final sequence = visibleThrough(context);
      if (sequence != null) read(sequence);
    });
  }

  int? visibleThrough(BuildContext context) {
    final box = viewport.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    final media = MediaQuery.of(context);
    final top = math.max(0.0, box.localToGlobal(Offset.zero).dy);
    final bottom = math.min(
      box.localToGlobal(Offset(0, box.size.height)).dy,
      media.size.height - media.viewInsets.bottom,
    );
    int? through;
    for (final entry in keys.entries) {
      final message = entry.value.currentContext?.findRenderObject();
      if (message is! RenderBox || !message.hasSize) continue;
      final end = message.localToGlobal(Offset(0, message.size.height)).dy;
      if (end > top && end <= bottom) {
        through = math.max(through ?? 0, entry.key);
      }
    }
    return through;
  }
}
