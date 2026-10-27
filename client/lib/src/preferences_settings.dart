part of 'preferences.dart';

extension _VersionedPreferences on AppPreferences {
  void _loadVersionedSettings(SharedPreferences data) {
    final value = data.get(AppPreferences.settingsStorageKey);
    if (value != null && value is! String) {
      _settingsInvalid = true;
      throw const FormatException('Повреждены ревизии настроек');
    }
    final raw = value as String?;
    if (raw == null) {
      _loadInitialSettings(data);
      final hadSettings = data.getKeys().any(
        (key) => key.startsWith('space.ui.') && key != 'space.ui.origins',
      );
      if (hadSettings || data.containsKey('space.notifications.mode')) {
        _settingsReplica.seed(settingsValues);
      }
      return;
    }
    try {
      _settingsReplica = SettingsReplica.parse(raw);
      _installSettings(_settingsReplica.snapshot);
    } catch (_) {
      _settingsInvalid = true;
      rethrow;
    }
  }

  void _installSettings(SettingsSnapshot snapshot) {
    final data = snapshot.values;
    _settingsReplica.snapshot = snapshot;
    _setThemeMode(ThemeMode.values.byName(data['themeMode'] as String));
    effects = data['effects'] as bool;
    palette = data['palette'] as String;
    language = data['language'] as String;
    sendShortcut = data['sendShortcut'] as String;
    uiScale = data['uiScale'] as double;
    notificationMode = data['notificationMode'] as int;
  }

  Future<SettingsSnapshot> _exportSettings() async {
    await _save();
    await flush();
    return _settingsReplica.snapshot;
  }

  Future<void> _commitSettings(PreferencesSettingsCommitted event) async {
    if (_settingsInvalid) throw StateError('Повреждены ревизии настроек');
    if (!event.before.same(settingsSnapshot)) {
      throw StateError('Настройки изменились после предварительного просмотра');
    }
    await event.persist();
    await _writeMergedSettings(event.target);
  }

  Future<void> _resumeSettings(PreferencesSettingsResumed event) async {
    if (_settingsInvalid) throw StateError('Повреждены ревизии настроек');
    final next = resumeSettingsSnapshot(
      event.before,
      event.target,
      settingsSnapshot,
      settingsActor,
    );
    if (next.same(settingsSnapshot)) return;
    await _writeMergedSettings(next);
  }

  Future<void> _writeMergedSettings(SettingsSnapshot snapshot) async {
    if (_settingsInvalid) throw StateError('Повреждены ревизии настроек');
    _installSettings(snapshot);
    publishState();
    await _save();
    await flush();
  }

  void _loadInitialSettings(SharedPreferences data) {
    _loadThemeMode(data);
    final mode = data.getInt('space.notifications.mode') ?? 0;
    notificationMode = [0, 1, 2].contains(mode) ? mode : 0;
    effects = data.getBool('space.ui.effects') ?? true;
    uiScale = AppPreferences.validUiScale(data.getDouble('space.ui.scale') ?? 1);
    final savedSend = data.getString('space.ui.sendShortcut');
    if (['enter', 'shiftEnter'].contains(savedSend)) {
      sendShortcut = savedSend!;
    }
    final savedLanguage = data.getString('space.ui.language');
    if (AppPreferences.languages.contains(savedLanguage)) language = savedLanguage!;
    final saved = data.getString('space.ui.palette');
    if (['gruvbox', 'ocean', 'iris'].contains(saved)) palette = saved!;
  }
}
