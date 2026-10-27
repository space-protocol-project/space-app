part of 'preferences.dart';

sealed class PreferencesEvent<T> extends RequestEvent<T> {}

sealed class PreferencesCommand<T> extends PreferencesEvent<T> {}

sealed class PreferencesVoidCommand extends PreferencesCommand<void> {}

final class PreferencesLoaded extends PreferencesVoidCommand {}

final class PreferencesSettingsExported
    extends PreferencesCommand<SettingsSnapshot> {}

final class PreferencesSettingsCommitted extends PreferencesVoidCommand {
  PreferencesSettingsCommitted(this.before, this.target, this.persist);
  final SettingsSnapshot before, target;
  final Future<void> Function() persist;
}

final class PreferencesSettingsResumed extends PreferencesVoidCommand {
  PreferencesSettingsResumed(this.before, this.target);
  final SettingsSnapshot before, target;
}

final class NotificationsChanged extends PreferencesVoidCommand {
  NotificationsChanged(this.mode);
  final int mode;
}

final class PreferencesChanged extends PreferencesVoidCommand {
  PreferencesChanged({
    this.dark,
    this.themeMode,
    this.effects,
    this.palette,
    this.language,
    this.sendShortcut,
    this.uiScale,
  });
  final double? uiScale;
  final ThemeMode? themeMode;
  final bool? dark, effects;
  final String? palette, language, sendShortcut;
}

final class ServerRemembered extends PreferencesVoidCommand {
  ServerRemembered(this.origin);
  final String origin;
}

final class ServerForgotten extends PreferencesVoidCommand {
  ServerForgotten(this.origin);
  final String origin;
}

final class ServerIconCached extends PreferencesVoidCommand {
  ServerIconCached(this.origin, Object? value)
    : value = validatedServerIcon(value);
  final String origin;
  final Map<String, dynamic>? value;
}

final class PreferencesStatePublished extends PreferencesEvent<void> {
  PreferencesStatePublished(this.state);
  final PreferencesState state;
}

final class SystemBrightnessChanged extends PreferencesVoidCommand {
  SystemBrightnessChanged(this.brightness);
  final Brightness brightness;
}
