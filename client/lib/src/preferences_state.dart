part of 'preferences.dart';

@Freezed(equal: false)
abstract class PreferencesState with _$PreferencesState {
  const PreferencesState._();
  const factory PreferencesState({
    @Default(0) int notificationMode,
    @Default(1) double uiScale,
    @Default(true) bool dark,
    @Default(true) bool effects,
    @Default('gruvbox') String palette,
    @Default('ru') String language,
    @Default('enter') String sendShortcut,
    @Default('') String error,
    @Default([]) List<String> origins,
    @Default({}) Map<String, Map<String, dynamic>> serverIcons,
    ThemeData? theme,
  }) = _PreferencesState;
  factory PreferencesState.fromController(AppPreferences controller) =>
      PreferencesState(
        notificationMode: controller.notificationMode,
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
  Locale get locale => language == 'zh-Hans'
      ? const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')
      : Locale(language);
}
