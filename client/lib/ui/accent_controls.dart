import 'package:flutter/material.dart';

({Color background, Color foreground}) readableAccent(BuildContext context) {
  final theme = Theme.of(context);
  final background = theme.brightness == Brightness.light
      ? Color.alphaBlend(
          Colors.black.withValues(alpha: .24),
          theme.colorScheme.primary,
        )
      : theme.colorScheme.primary;
  return (
    background: background,
    foreground: background.computeLuminance() > .179
        ? Colors.black
        : Colors.white,
  );
}

ButtonStyle sendButtonStyle(BuildContext context) {
  final colors = readableAccent(context);
  return IconButton.styleFrom(
    backgroundColor: colors.background,
    foregroundColor: colors.foreground,
  );
}
