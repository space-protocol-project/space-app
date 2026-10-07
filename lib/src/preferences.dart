import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends ChangeNotifier {
  bool dark = true, compact = false;
  String palette = 'gruvbox', error = '';
  final List<String> origins = [];
  bool _disposed = false;
  Future<void> _writes = Future.value();

  Future<void> load() async {
    try {
      final data = await SharedPreferences.getInstance();
      if (_disposed) return;
      dark = data.getBool('space.ui.dark') ?? true;
      compact = data.getBool('space.ui.compact') ?? false;
      final saved = data.getString('space.ui.palette');
      if (['gruvbox', 'ocean', 'iris'].contains(saved)) palette = saved!;
      origins.addAll((data.getStringList('space.ui.origins') ?? []).take(12));
    } catch (_) {
      error = 'Не удалось загрузить настройки оформления.';
    }
    if (!_disposed) notifyListeners();
  }

  Future<void> change({bool? dark, bool? compact, String? palette}) {
    if (dark != null) this.dark = dark;
    if (compact != null) this.compact = compact;
    if (palette != null && ['gruvbox', 'ocean', 'iris'].contains(palette)) {
      this.palette = palette;
    }
    notifyListeners();
    return _save();
  }

  Future<void> remember(String origin) {
    origins.remove(origin);
    origins.insert(0, origin);
    if (origins.length > 12) origins.removeLast();
    notifyListeners();
    return _save();
  }

  Future<void> _save() {
    final snapshot = (
      dark: dark,
      compact: compact,
      palette: palette,
      origins: List<String>.of(origins),
    );
    _writes = _writes.then((_) async {
      try {
        final data = await SharedPreferences.getInstance();
        final results = await Future.wait([
          data.setBool('space.ui.dark', snapshot.dark),
          data.setBool('space.ui.compact', snapshot.compact),
          data.setString('space.ui.palette', snapshot.palette),
          data.setStringList('space.ui.origins', snapshot.origins),
        ]);
        if (results.contains(false)) throw StateError('Запись не завершена');
        error = '';
      } catch (_) {
        error = 'Настройки изменены, но сохранить их на устройстве не удалось.';
      }
      if (!_disposed) notifyListeners();
    });
    return _writes;
  }

  ThemeData get theme {
    final brightness = dark ? Brightness.dark : Brightness.light;
    final primary = switch (palette) {
      'ocean' => dark ? const Color(0xFF83A598) : const Color(0xFF076678),
      'iris' => dark ? const Color(0xFFD3869B) : const Color(0xFF8F3F71),
      _ => dark ? const Color(0xFFFABD2F) : const Color(0xFF076678),
    };
    final background = dark ? const Color(0xFF282828) : const Color(0xFFFBF1C7);
    final surface = dark ? const Color(0xFF32302F) : const Color(0xFFF9F5D7);
    final text = dark ? const Color(0xFFEBDBB2) : const Color(0xFF3C3836);
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      onPrimary: background,
      surface: surface,
      onSurface: text,
      secondary: dark ? const Color(0xFFB8BB26) : const Color(0xFF427B58),
      onSecondary: background,
      onSurfaceVariant: dark
          ? const Color(0xFFBDAE93)
          : const Color(0xFF665C54),
      outline: dark ? const Color(0xFF928374) : const Color(0xFF7C6F64),
      error: dark ? const Color(0xFFFB4934) : const Color(0xFF9D0006),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Segoe UI',
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
