import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/directory_backup.dart';
import '../src/settings_snapshot.dart';

class DirectorySettingsMergePanel extends StatelessWidget {
  const DirectorySettingsMergePanel({
    super.key,
    required this.plan,
    required this.enabled,
    required this.busy,
    required this.choices,
    required this.onEnabled,
    required this.onChoice,
  });
  final DirectoryRestorePlan plan;
  final bool enabled, busy;
  final Map<String, SettingsChoice> choices;
  final ValueChanged<bool> onEnabled;
  final void Function(String, SettingsChoice) onChoice;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: enabled,
        onChanged: busy ? null : (value) => onEnabled(value ?? false),
        title: Text(context.strings.directoryBackupSettings),
      ),
      if (enabled) ...[
        Text(context.strings.directorySettingsHelp),
        const SizedBox(height: 12),
        ...plan.settingConflicts.map((key) => _conflict(context, key)),
      ],
    ],
  );

  Widget _conflict(BuildContext context, String key) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label(context, key),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        RadioGroup<SettingsChoice>(
          groupValue: choices[key],
          onChanged: (value) {
            if (!busy && value != null) onChoice(key, value);
          },
          child: Column(
            children: [
              RadioListTile<SettingsChoice>(
                value: SettingsChoice.local,
                enabled: !busy,
                title: Text(context.strings.directorySettingsLocal),
                subtitle: Text(
                  _value(
                    context,
                    key,
                    key == 'voiceProfile'
                        ? plan.voiceMerge!.local.profile.data
                        : plan.settingsMerge.local.values[key],
                  ),
                ),
              ),
              RadioListTile<SettingsChoice>(
                value: SettingsChoice.incoming,
                enabled: !busy,
                title: Text(context.strings.directorySettingsIncoming),
                subtitle: Text(
                  _value(
                    context,
                    key,
                    key == 'voiceProfile'
                        ? plan.voiceMerge!.incoming!.profile.data
                        : plan.settingsMerge.incoming.values[key],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  String _label(BuildContext context, String key) => switch (key) {
    'themeMode' => context.strings.appearanceTheme,
    'language' => context.strings.language,
    'sendShortcut' => context.strings.sendShortcutTitle,
    'effects' => context.strings.directorySettingsEffects,
    'palette' => context.strings.directorySettingsPalette,
    'uiScale' => context.strings.directorySettingsScale,
    'notificationMode' => context.strings.directorySettingsNotifications,
    'voiceProfile' => context.strings.voiceSettingsTitle,
    _ => throw StateError('Неизвестный параметр'),
  };

  String _value(BuildContext context, String key, Object? value) =>
      switch ((key, value)) {
        ('voiceProfile', Map profile) => _voiceValue(context, profile),
        ('notificationMode', 0) => context.strings.notificationsOff,
        ('notificationMode', 1) => context.strings.notificationsPrivate,
        ('notificationMode', 2) => context.strings.notificationsPreview,
        ('uiScale', num scale) => '${(scale * 100).round()} %',
        ('language', 'ru') => 'Русский',
        ('language', 'en') => 'English',
        ('language', 'zh-Hans') => '简体中文',
        ('sendShortcut', 'shiftEnter') => 'Shift+Enter',
        _ => _style(context, value),
      };
  String _voiceValue(BuildContext context, Map profile) {
    final strings = context.strings;
    final mode = switch (profile['noiseMode']) {
      'deepFilter' => 'DeepFilterNet3',
      'webrtc' => strings.voiceNoiseWebRtc,
      _ => strings.voiceNoiseOff,
    };
    String setting(Object? enabled) => enabled == true
        ? strings.directorySettingsOn
        : strings.directorySettingsOff;
    return '${strings.voiceNoiseSuppression}: $mode\n'
        '${strings.voiceEchoCancellation}: ${setting(profile['echoCancellation'])}\n'
        '${strings.voiceAutoGain}: ${setting(profile['autoGainControl'])}\n'
        '${strings.voiceHighPass}: ${setting(profile['highPassFilter'])}\n'
        '${strings.voiceProfileCustom}: ${setting(profile['customProfile'])}';
  }

  String _style(BuildContext context, Object? value) => switch (value) {
    'ocean' => context.strings.ocean,
    'iris' => context.strings.iris,
    'gruvbox' => 'Gruvbox',
    'system' => context.strings.appearanceThemeSystem,
    'light' => context.strings.appearanceThemeLight,
    'dark' => context.strings.appearanceThemeDark,
    true => context.strings.directorySettingsOn,
    false => context.strings.directorySettingsOff,
    _ => value.toString(),
  };
}
