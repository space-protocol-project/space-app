import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

import 'window_theme_fallback_stub.dart'
    if (dart.library.io) 'window_theme_fallback.dart';

const windowThemeChannel = MethodChannel('space/window-theme');
ThemeData? _latestWindowTheme;
bool _listening = false;
final _focusListener = _WindowThemeFocus();

class _WindowThemeFocus with WindowListener {
  void _apply() {
    final theme = _latestWindowTheme;
    if (theme != null) unawaited(updateWindowTheme(theme));
  }

  @override
  void onWindowFocus() => _apply();
  @override
  void onWindowBlur() => _apply();
}

Future<void> updateWindowTheme(ThemeData theme) async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.windows) return;
  _latestWindowTheme = theme;
  if (!_listening) {
    windowManager.addListener(_focusListener);
    _listening = true;
  }
  try {
    await windowThemeChannel.invokeMethod<void>('set', {
      'dark': theme.brightness == Brightness.dark,
      'background': theme.scaffoldBackgroundColor.toARGB32(),
      'foreground': theme.brightness == Brightness.dark
          ? 0xFFEBDBB2
          : theme.colorScheme.onSurface.toARGB32(),
    });
  } on MissingPluginException {
    await applyWindowThemeFallback(
      theme.brightness == Brightness.dark,
      theme.scaffoldBackgroundColor.toARGB32(),
      theme.brightness == Brightness.dark
          ? 0xFFEBDBB2
          : theme.colorScheme.onSurface.toARGB32(),
    );
  } on PlatformException {
    // Неподдерживаемая версия DWM сохраняет системную рамку.
  }
}
