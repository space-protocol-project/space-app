import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/space_appearance.dart';

double contrast(Color a, Color b) {
  final first = a.computeLuminance(), second = b.computeLuminance();
  return (math.max(first, second) + .05) / (math.min(first, second) + .05);
}

void main() {
  for (final dark in [true, false]) {
    for (final palette in ['gruvbox', 'ocean', 'iris']) {
      test(
        'Текст кнопок, выбранных строк и карточек читаем: $palette, dark=$dark',
        () async {
          final preferences = AppPreferences()
            ..dark = dark
            ..palette = palette;
          final theme = preferences.theme;
          final colors = theme.colorScheme;
          final surfaces = theme.extension<SpaceAppearance>()!;
          for (final pair in [
            (colors.onPrimary, colors.primary),
            (colors.onSecondary, colors.secondary),
            (colors.onPrimaryContainer, colors.primaryContainer),
            (theme.listTileTheme.selectedColor!, colors.primaryContainer),
            (colors.onSurface, surfaces.main),
            (colors.onSurfaceVariant, surfaces.surface),
          ]) {
            expect(contrast(pair.$1, pair.$2), greaterThanOrEqualTo(4.5));
          }
          await preferences.close();
        },
      );
    }
  }
}
