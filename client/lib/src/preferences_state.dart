part of 'preferences.dart';

final class PreferencesState {
  const PreferencesState({
    this.uiScale = 1,
    this.dark = true,
    this.effects = true,
    this.palette = 'gruvbox',
    this.language = 'ru',
    this.sendShortcut = 'enter',
    this.error = '',
    this.origins = const [],
    this.serverIcons = const {},
    this.theme,
  });
  factory PreferencesState.fromController(AppPreferences controller) =>
      PreferencesState(
        uiScale: controller.uiScale,
        dark: controller.dark,
        effects: controller.effects,
        palette: controller.palette,
        language: controller.language,
        sendShortcut: controller.sendShortcut,
        error: controller.error,
        origins: List.unmodifiable(controller.origins),
        serverIcons: Map.unmodifiable(
          controller.serverIcons.map(
            (key, value) =>
                MapEntry(key, Map<String, dynamic>.unmodifiable(value)),
          ),
        ),
        theme: controller.theme,
      );
  final double uiScale;
  final bool dark, effects;
  final String palette, language, sendShortcut, error;
  final List<String> origins;
  final Map<String, Map<String, dynamic>> serverIcons;
  final ThemeData? theme;
  Locale get locale => language == 'zh-Hans'
      ? const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')
      : Locale(language);
}
