import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart' show mapEquals;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart' show validatedServerIcon;

import 'event_controller.dart';
import '../ui/space_appearance.dart';

part 'preferences_events.dart';
part 'preferences_state.dart';

class AppPreferences
    extends EventController<PreferencesEvent<dynamic>, PreferencesState> {
  AppPreferences() : super(const PreferencesState()) {
    on<PreferencesStatePublished>(
      (event, emit) => event.runAndComplete(() => emit(event.state)),
    );
    on<PreferencesCommand<dynamic>>(
      (event, _) => handleRequest(
        event,
        () => switch (event) {
          PreferencesLoaded() => _load(),
          PreferencesChanged() => _change(
            dark: event.dark,
            effects: event.effects,
            palette: event.palette,
            language: event.language,
            sendShortcut: event.sendShortcut,
          ),
          ServerRemembered() => _remember(event.origin),
          ServerForgotten() => _forget(event.origin),
          ServerIconCached() => _cacheServerIcon(event.origin, event.value),
        },
      ),
      transformer: sequential(),
    );
  }

  Future<void> load() => sendRequest(PreferencesLoaded());
  Future<void> change({
    bool? dark,
    bool? effects,
    String? palette,
    String? language,
    String? sendShortcut,
  }) => sendRequest(
    PreferencesChanged(
      dark: dark,
      effects: effects,
      palette: palette,
      language: language,
      sendShortcut: sendShortcut,
    ),
  );
  Future<void> remember(String origin) => sendRequest(ServerRemembered(origin));
  Future<void> forget(String origin) => sendRequest(ServerForgotten(origin));
  Future<void> cacheServerIcon(String origin, Object? value) =>
      sendRequest(ServerIconCached(origin, value));

  bool dark = true, effects = true;
  String palette = 'gruvbox', error = '';
  String language = 'ru';
  String sendShortcut = 'enter';
  static const languages = ['ru', 'zh-Hans', 'en'];
  Locale get locale => language == 'zh-Hans'
      ? const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')
      : Locale(language);
  final List<String> origins = [];
  final Map<String, Map<String, dynamic>> serverIcons = {};
  Future<void> _cacheServerIcon(String origin, Object? value) {
    final icon = validatedServerIcon(value);
    if (icon == null ||
        !origins.contains(origin) ||
        mapEquals(serverIcons[origin], icon)) {
      return Future.value();
    }
    serverIcons[origin] = icon;
    publishState();
    return _save();
  }

  bool _disposed = false;
  Future<void> _writes = Future.value();

  Future<void> _load() async {
    try {
      final data = await SharedPreferences.getInstance();
      if (_disposed) return;
      dark = data.getBool('space.ui.dark') ?? true;
      effects = data.getBool('space.ui.effects') ?? true;
      final savedSend = data.getString('space.ui.sendShortcut');
      if (['enter', 'shiftEnter'].contains(savedSend)) {
        sendShortcut = savedSend!;
      }
      final savedLanguage = data.getString('space.ui.language');
      if (languages.contains(savedLanguage)) language = savedLanguage!;
      final saved = data.getString('space.ui.palette');
      if (['gruvbox', 'ocean', 'iris'].contains(saved)) palette = saved!;
      origins.addAll(data.getStringList('space.ui.origins') ?? []);
      _loadServerIcons(data.getString('space.server.icons'));
    } catch (_) {
      error = 'Не удалось загрузить настройки оформления.';
    }
    if (!_disposed) publishState();
  }

  void _loadServerIcons(String? icons) {
    if (icons != null && icons.length < 2 * 1024 * 1024) {
      try {
        final decoded = jsonDecode(icons);
        if (decoded is Map) {
          for (final origin in origins) {
            final icon = validatedServerIcon(decoded[origin]);
            if (icon != null) serverIcons[origin] = icon;
          }
        }
      } catch (_) {}
    }
  }

  Future<void> _change({
    bool? dark,
    bool? effects,
    String? palette,
    String? language,
    String? sendShortcut,
  }) {
    if (sendShortcut != null &&
        ['enter', 'shiftEnter'].contains(sendShortcut)) {
      this.sendShortcut = sendShortcut;
    }
    if (language != null && languages.contains(language)) {
      this.language = language;
    }
    if (dark != null) this.dark = dark;
    if (effects != null) this.effects = effects;
    if (palette != null && ['gruvbox', 'ocean', 'iris'].contains(palette)) {
      this.palette = palette;
    }
    publishState();
    return _save();
  }

  Future<void> _remember(String origin) {
    origins.remove(origin);
    origins.insert(0, origin);
    publishState();
    return _save();
  }

  Future<void> _forget(String origin) {
    origins.remove(origin);
    serverIcons.remove(origin);
    publishState();
    return _save();
  }

  Future<void> _save() {
    final snapshot = (
      dark: dark,
      effects: effects,
      palette: palette,
      language: language,
      sendShortcut: sendShortcut,
      origins: List<String>.of(origins),
      icons: jsonEncode(serverIcons),
    );
    _writes = _writes.then((_) async {
      try {
        final data = await SharedPreferences.getInstance();
        final results = await Future.wait([
          data.setBool('space.ui.dark', snapshot.dark),
          data.setBool('space.ui.effects', snapshot.effects),
          data.setString('space.ui.palette', snapshot.palette),
          data.setString('space.ui.language', snapshot.language),
          data.setString('space.ui.sendShortcut', snapshot.sendShortcut),
          data.setStringList('space.ui.origins', snapshot.origins),
          data.setString('space.server.icons', snapshot.icons),
        ]);
        if (results.contains(false)) throw StateError('Запись не завершена');
        error = '';
      } catch (_) {
        error = 'Настройки изменены, но сохранить их на устройстве не удалось.';
      }
      if (!_disposed) publishState();
    });
    return _writes;
  }

  void publishState() {
    if (!_disposed && !isClosed) {
      publishStateEvent(
        PreferencesStatePublished(PreferencesState.fromController(this)),
      );
    }
  }

  Color _tone(int darkColor, int lightColor) =>
      Color(dark ? darkColor : lightColor);

  ThemeData get theme {
    final brightness = dark ? Brightness.dark : Brightness.light;
    final primary = switch (palette) {
      'ocean' => _tone(0xFF83A598, 0xFF076678),
      'iris' => _tone(0xFFD3869B, 0xFF8F3F71),
      _ => _tone(0xFFFABD2F, 0xFF9D6000),
    };
    final background = _tone(0xFF1D2021, 0xFFFBF1C7);
    final surface = _tone(0xFF32302F, 0xFFF9F5D7);
    final text = _tone(0xFFEBDBB2, 0xFF3C3836);
    final sidebar = _tone(0xFF282828, 0xFFF2E5BC);
    final soft = _tone(0xFF3C3836, 0xFFEBDBB2);
    final raised = _tone(0xFF504945, 0xFFD5C4A1);
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      onPrimary: background,
      surface: surface,
      surfaceContainerLowest: sidebar,
      surfaceContainerLow: dark ? const Color(0xFF2C2C2C) : background,
      surfaceContainer: surface,
      surfaceContainerHigh: soft,
      surfaceContainerHighest: raised,
      surfaceBright: raised,
      surfaceDim: dark ? background : sidebar,
      surfaceTint: Colors.transparent,
      primaryContainer: soft,
      onPrimaryContainer: primary,
      secondaryContainer: soft,
      onSecondaryContainer: text,
      tertiaryContainer: soft,
      onTertiaryContainer: text,
      onSurface: text,
      secondary: _tone(0xFFB8BB26, 0xFF427B58),
      onSecondary: background,
      onSurfaceVariant: _tone(0xFFBDAE93, 0xFF665C54),
      outline: _tone(0xFF928374, 0xFF7C6F64),
      outlineVariant: _tone(0xFF504945, 0xFFD5C4A1),
      error: _tone(0xFFFB4934, 0xFF9D0006),
    );
    final theme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      iconTheme: IconThemeData(color: scheme.onSurface),
      primaryIconTheme: IconThemeData(color: scheme.onSurface),
      scaffoldBackgroundColor: background,
      fontFamily: 'Nunito Sans',
      visualDensity: VisualDensity.compact,
      filledButtonTheme: const FilledButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          minimumSize: WidgetStatePropertyAll(Size(64, 48)),
          tapTargetSize: MaterialTapTargetSize.padded,
          visualDensity: VisualDensity.standard,
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          minimumSize: WidgetStatePropertyAll(Size(64, 48)),
          tapTargetSize: MaterialTapTargetSize.padded,
          visualDensity: VisualDensity.standard,
        ),
      ),
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          minimumSize: WidgetStatePropertyAll(Size(64, 48)),
          tapTargetSize: MaterialTapTargetSize.padded,
          visualDensity: VisualDensity.standard,
        ),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          minimumSize: WidgetStatePropertyAll(Size(48, 44)),
          tapTargetSize: MaterialTapTargetSize.padded,
          visualDensity: VisualDensity.standard,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
    return quietSpaceTheme(
      theme.copyWith(
        textTheme: theme.textTheme.copyWith(
          displayLarge: theme.textTheme.displayLarge?.copyWith(
            fontFamily: 'Nunito',
          ),
          displayMedium: theme.textTheme.displayMedium?.copyWith(
            fontFamily: 'Nunito',
          ),
          displaySmall: theme.textTheme.displaySmall?.copyWith(
            fontFamily: 'Nunito',
          ),
          headlineLarge: theme.textTheme.headlineLarge?.copyWith(
            fontFamily: 'Nunito',
          ),
          headlineMedium: theme.textTheme.headlineMedium?.copyWith(
            fontFamily: 'Nunito',
          ),
          headlineSmall: theme.textTheme.headlineSmall?.copyWith(
            fontFamily: 'Nunito',
          ),
          titleLarge: theme.textTheme.titleLarge?.copyWith(
            fontFamily: 'Nunito',
          ),
          titleMedium: theme.textTheme.titleMedium?.copyWith(
            fontFamily: 'Nunito',
          ),
        ),
      ),
      palette: palette,
      effects: effects,
    );
  }

  @override
  Future<void> close() async {
    _disposed = true;
    await super.close();
  }
}
