import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_selector/file_selector.dart';

import '../l10n/admin_localizations.dart';
import 'server_icon.dart';

class ServerIconPicker extends StatefulWidget {
  const ServerIconPicker({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onPending,
    required this.disabled,
  });
  final Map<String, dynamic>? value;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final ValueChanged<bool> onPending;
  final bool disabled;
  @override
  State<ServerIconPicker> createState() => _ServerIconPickerState();
}

class _ServerIconPickerState extends State<ServerIconPicker> {
  bool loading = false, invalid = false;
  Future<void> upload() async {
    setState(() => loading = true);
    widget.onPending(true);
    try {
      final file = await openFile(
        acceptedTypeGroups: [
          const XTypeGroup(label: 'PNG / SVG', extensions: ['png', 'svg']),
        ],
      );
      if (file == null) return;
      final size = await file.length();
      if (size == null || size > 8 * 1024 * 1024)
        throw const FormatException('Файл слишком большой');
      final icon = await compute(prepareServerIcon, [
        await file.readAsBytes(),
        (await file.name() ?? '').toLowerCase().endsWith('.svg'),
      ]);
      if (mounted) {
        widget.onChanged(icon);
        setState(() => invalid = false);
      }
    } catch (_) {
      if (mounted) setState(() => invalid = true);
    } finally {
      if (mounted) {
        setState(() => loading = false);
        widget.onPending(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s =
        AdminLocalizations.of(context) ??
        lookupAdminLocalizations(const Locale('ru'));
    final labels = {
      'orbit': s.iconOrbit,
      'planet': s.iconPlanet,
      'leaf': s.iconLeaf,
      'star': s.iconStar,
      'bolt': s.iconBolt,
      'rocket': s.iconRocket,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ServerIconView(value: widget.value, size: 40),
            const SizedBox(width: 12),
            Expanded(child: Text(
              s.serverIconTitle,
              style: Theme.of(context).textTheme.titleMedium,
            )),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final preset in serverIconPresets.entries)
              ChoiceChip(
                label: Text(labels[preset.key]!),
                avatar: Icon(preset.value, size: 18),
                selected: widget.value?['preset'] == preset.key,
                onSelected: widget.disabled || loading
                    ? null
                    : (_) {
                        widget.onChanged({'preset': preset.key});
                        setState(() => invalid = false);
                      },
              ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: widget.disabled || loading ? null : upload,
          icon: const Icon(Icons.upload_file),
          label: Text(s.serverIconUpload),
        ),
        if (loading) const LinearProgressIndicator(),
        const SizedBox(height: 16),
        Text(s.serverIconHelp, style: Theme.of(context).textTheme.bodySmall),
        if (invalid)
          Text(
            s.serverIconInvalid,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    );
  }
}
