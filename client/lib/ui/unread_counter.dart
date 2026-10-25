import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import 'accent_controls.dart';

class UnreadCounter extends StatelessWidget {
  const UnreadCounter({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = readableAccent(context);
    return Tooltip(
      message: context.strings.unreadCount(count),
      child: Badge(
        backgroundColor: colors.background,
        textColor: colors.foreground,
        padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
        textStyle: Theme.of(context).textTheme.labelSmall
            ?.copyWith(fontWeight: FontWeight.w700, height: 1),
        label: Text(count > 99 ? '99+' : '$count'),
      ),
    );
  }
}
