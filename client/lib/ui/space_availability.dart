import 'package:flutter/material.dart';

import '../l10n/strings.dart';

class SpaceAvailability extends StatelessWidget {
  const SpaceAvailability({super.key, required this.online});
  final bool? online;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = switch (online) {
      true => colors.secondary,
      false => colors.error,
      null => colors.onSurfaceVariant,
    };
    final label = switch (online) {
      true => context.strings.dashboardAvailable,
      false => context.strings.dashboardUnavailable,
      null => context.strings.serverAvailabilityUnknown,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 7, color: color),
        const SizedBox(width: 8),
        Flexible(
          child: Text(label, style: TextStyle(fontSize: 12, color: color)),
        ),
      ],
    );
  }
}
