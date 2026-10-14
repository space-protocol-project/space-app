part of 'preferences.dart';

sealed class PreferencesEvent<T> extends RequestEvent<T> {}

sealed class PreferencesCommand<T> extends PreferencesEvent<T> {}

final class PreferencesLoaded extends PreferencesCommand<void> {}

final class PreferencesChanged extends PreferencesCommand<void> {
  PreferencesChanged({
    this.dark,
    this.effects,
    this.palette,
    this.language,
    this.sendShortcut,
    this.uiScale,
  });
  final double? uiScale;
  final bool? dark, effects;
  final String? palette, language, sendShortcut;
}

final class ServerRemembered extends PreferencesCommand<void> {
  ServerRemembered(this.origin);
  final String origin;
}

final class ServerForgotten extends PreferencesCommand<void> {
  ServerForgotten(this.origin);
  final String origin;
}

final class ServerIconCached extends PreferencesCommand<void> {
  ServerIconCached(this.origin, Object? value)
    : value = validatedServerIcon(value);
  final String origin;
  final Map<String, dynamic>? value;
}

final class PreferencesStatePublished extends PreferencesEvent<void> {
  PreferencesStatePublished(this.state);
  final PreferencesState state;
}
