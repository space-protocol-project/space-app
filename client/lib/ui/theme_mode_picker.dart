import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/preferences.dart';

class ThemeModePicker extends StatelessWidget {
  const ThemeModePicker({
    super.key,
    required this.preferences,
    required this.mode,
  });
  final AppPreferences preferences;
  final ThemeMode mode;
  @override
  Widget build(BuildContext context) => DropdownButtonFormField<ThemeMode>(
    key: ValueKey('theme-mode-${mode.name}'),
    initialValue: mode,
    isExpanded: true,
    decoration: InputDecoration(labelText: context.strings.appearanceTheme),
    items: [
      DropdownMenuItem(
        value: ThemeMode.system,
        child: Text(context.strings.appearanceThemeSystem),
      ),
      DropdownMenuItem(
        value: ThemeMode.light,
        child: Text(context.strings.appearanceThemeLight),
      ),
      DropdownMenuItem(
        value: ThemeMode.dark,
        child: Text(context.strings.appearanceThemeDark),
      ),
    ],
    onChanged: (value) {
      if (value != null) preferences.change(themeMode: value);
    },
  );
}
