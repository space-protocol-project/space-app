import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/preferences.dart';
import 'components.dart';

class ShortcutSettings extends StatelessWidget {
  const ShortcutSettings({
    super.key,
    required this.preferences,
    required this.value,
  });
  final AppPreferences preferences;
  final String value;

  @override
  Widget build(BuildContext context) => SurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.strings.hotkeysTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(context.strings.sendShortcutHelp),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final label = Text(context.strings.sendShortcutTitle);
            final control = Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    key: ValueKey('send-shortcut-$value'),
                    isExpanded: true,
                    initialValue: value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'enter',
                        child: KeyCombination(keys: ['Enter']),
                      ),
                      DropdownMenuItem(
                        value: 'shiftEnter',
                        child: KeyCombination(keys: ['Shift', 'Enter']),
                      ),
                    ],
                    onChanged: (next) => preferences.change(sendShortcut: next),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: context.strings.resetShortcut,
                  onPressed: value == 'enter'
                      ? null
                      : () => preferences.change(sendShortcut: 'enter'),
                  icon: const Icon(Icons.backspace_outlined),
                ),
              ],
            );
            if (constraints.maxWidth < 500) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [label, const SizedBox(height: 12), control],
              );
            }
            return Row(
              children: [
                SizedBox(width: 160, child: label),
                const SizedBox(width: 16),
                Expanded(child: control),
              ],
            );
          },
        ),
      ],
    ),
  );
}

class KeyCombination extends StatelessWidget {
  const KeyCombination({super.key, required this.keys});
  final List<String> keys;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 5,
    runSpacing: 4,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      for (var index = 0; index < keys.length; index++) ...[
        if (index > 0) const Text('+'),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text(
              keys[index],
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ],
    ],
  );
}
