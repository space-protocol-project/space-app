import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';

@immutable
class SpaceAppearance extends ThemeExtension<SpaceAppearance> {
  const SpaceAppearance({
    required this.background,
    required this.sidebar,
    required this.main,
    required this.surface,
    required this.glass,
    required this.line,
    required this.mine,
    this.effects = true,
  });
  final Color background, sidebar, main, surface, glass, line, mine;
  final bool effects;
  static const railWidth = 72.0;
  static const sidebarWidth = 258.0;
  static const headerHeight = 76.0;
  static const radius = 18.0;
  static const conversationWidth = 740.0;

  static SpaceAppearance of(BuildContext context) =>
      Theme.of(context).extension<SpaceAppearance>() ??
      fromScheme(Theme.of(context).colorScheme);
  static SpaceAppearance fromScheme(ColorScheme colors) => SpaceAppearance(
    background: colors.surfaceContainerLowest,
    sidebar: colors.surfaceContainerLow,
    main: colors.surface,
    surface: colors.surfaceContainerHigh,
    glass: colors.surfaceContainerHigh.withValues(alpha: .9),
    line: colors.outlineVariant,
    mine: Color.alphaBlend(
      colors.primary.withValues(alpha: .14),
      colors.surface,
    ),
  );

  @override
  SpaceAppearance copyWith({
    Color? background,
    Color? sidebar,
    Color? main,
    Color? surface,
    Color? glass,
    Color? line,
    Color? mine,
  }) => SpaceAppearance(
    background: background ?? this.background,
    sidebar: sidebar ?? this.sidebar,
    main: main ?? this.main,
    surface: surface ?? this.surface,
    glass: glass ?? this.glass,
    line: line ?? this.line,
    mine: mine ?? this.mine,
    effects: effects,
  );
  @override
  SpaceAppearance lerp(covariant SpaceAppearance? other, double t) {
    if (other == null) return this;
    return SpaceAppearance(
      background: Color.lerp(background, other.background, t)!,
      sidebar: Color.lerp(sidebar, other.sidebar, t)!,
      main: Color.lerp(main, other.main, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      line: Color.lerp(line, other.line, t)!,
      mine: Color.lerp(mine, other.mine, t)!,
      effects: other.effects,
    );
  }
}

ThemeData quietSpaceTheme(
  ThemeData base, {
  required String palette,
  bool effects = true,
}) {
  final dark = base.brightness == Brightness.dark;
  Color tone(int night, int day) => Color(dark ? night : day);
  final accent = palette == 'gruvbox'
      ? tone(0xFFE9BB59, 0xFFA97620)
      : base.colorScheme.primary;
  final appearance = SpaceAppearance(
    effects: effects,
    background: tone(0xFF1D2021, 0xFFDEDACE),
    sidebar: tone(0xFF252625, 0xFFEEECE3),
    main: tone(0xFF2B2B29, 0xFFF7F5ED),
    surface: tone(0xFF343430, 0xFFE9E5D9),
    glass: tone(0xC9383833, 0xDBF6F3E4),
    line: tone(0x18FFFFFF, 0x21403922),
    mine: palette == 'gruvbox'
        ? tone(0xFF454032, 0xFFE9DFC4)
        : Color.alphaBlend(
            accent.withValues(alpha: .14),
            tone(0xFF2B2B29, 0xFFF7F5ED),
          ),
  );
  final primaryContainer = Color.alphaBlend(
    accent.withValues(alpha: .12),
    appearance.sidebar,
  );
  final textColor = tone(0xFFEEE5CF, 0xFF3D3B33);
  final secondary = palette == 'gruvbox'
      ? tone(0xFFA6B887, 0xFF63754A)
      : base.colorScheme.secondary;
  final colors = base.colorScheme.copyWith(
    primary: accent,
    secondary: secondary,
    onSecondary: _readableForeground(secondary, base.colorScheme.onSecondary),
    onPrimary: _readableForeground(accent, appearance.background),
    surface: appearance.main,
    surfaceContainerLowest: appearance.sidebar,
    surfaceContainerLow: appearance.main,
    surfaceContainer: appearance.surface,
    surfaceContainerHigh: appearance.surface,
    surfaceContainerHighest: appearance.surface,
    primaryContainer: primaryContainer,
    onPrimaryContainer: _readableForeground(
      primaryContainer,
      accent,
      fallback: textColor,
    ),
    onSurface: textColor,
    onSurfaceVariant: tone(0xFFAAA694, 0xFF696659),
    outlineVariant: appearance.line,
  );
  return base.copyWith(
    colorScheme: colors,
    scaffoldBackgroundColor: appearance.background,
    extensions: [...base.extensions.values, appearance],
    dividerTheme: DividerThemeData(color: appearance.line, thickness: 1),
    cardTheme: CardThemeData(
      color: appearance.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: appearance.line),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: appearance.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: appearance.line),
      ),
      titleTextStyle: base.textTheme.titleLarge,
      contentTextStyle: base.textTheme.bodyMedium,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: appearance.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: .12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: appearance.line),
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thickness: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.dragged) ? 8 : 6,
      ),
      radius: const Radius.circular(8),
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => colors.onSurfaceVariant.withValues(
          alpha:
              states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.dragged)
              ? .65
              : .3,
        ),
      ),
      trackColor: WidgetStatePropertyAll(appearance.background),
      trackBorderColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colors.onSurfaceVariant,
      textColor: colors.onSurface,
      selectedColor: colors.onPrimaryContainer,
      selectedTileColor: colors.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      fillColor: appearance.surface,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: appearance.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: accent, width: 2),
      ),
    ),
  );
}

Color _readableForeground(
  Color background,
  Color preferred, {
  Color? fallback,
}) {
  bool readable(Color text) {
    final back = background.computeLuminance(), front = text.computeLuminance();
    return (math.max(back, front) + .05) / (math.min(back, front) + .05) >= 4.5;
  }

  if (readable(preferred)) return preferred;
  if (fallback != null && readable(fallback)) return fallback;
  return background.computeLuminance() > .179 ? Colors.black : Colors.white;
}

class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.radius = 24,
    this.effects = true,
    this.blur = 12,
    this.showBorder = true,
    this.color,
  });
  final Widget child;
  final double radius;
  final bool effects;
  final double blur;
  final bool showBorder;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final appearance = SpaceAppearance.of(context);
    final enabled =
        effects &&
        appearance.effects &&
        !MediaQuery.disableAnimationsOf(context);
    final surface = DecoratedBox(
      decoration: BoxDecoration(
        color: enabled
            ? color ?? appearance.glass
            : color?.withValues(alpha: 1) ?? appearance.surface,
        gradient: enabled
            ? LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: .025),
                  Colors.transparent,
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder
            ? Border.all(
                color: Theme.of(context).colorScheme.onSurface
                    .withValues(alpha: .14),
              )
            : null,
      ),
      child: const SizedBox.expand(),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: enabled
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                      child: surface,
                    )
                  : surface,
            ),
          ),
          RepaintBoundary(child: child),
        ],
      ),
    );
  }
}
