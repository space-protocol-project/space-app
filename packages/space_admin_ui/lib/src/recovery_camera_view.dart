import 'package:flutter/material.dart';

import '../l10n/admin_localizations.dart';

class RecoveryCameraView extends StatelessWidget {
  const RecoveryCameraView({
    super.key,
    this.help,
    this.onCapture,
    this.capturing = false,
    required this.cameras,
    required this.selected,
    required this.starting,
    required this.error,
    required this.preview,
    required this.onSelect,
    required this.onRestart,
    required this.onCancel,
  });
  final String? help;
  final VoidCallback? onCapture;
  final bool capturing;
  final List<String> cameras;
  final String? selected, error;
  final bool starting;
  final Widget? preview;
  final ValueChanged<String?> onSelect;
  final VoidCallback onRestart, onCancel;
  @override
  Widget build(BuildContext context) {
    final strings =
        AdminLocalizations.of(context) ??
        lookupAdminLocalizations(const Locale('ru'));
    return AlertDialog(
      title: Text(strings.cameraTitle),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(help ?? strings.cameraHelp),
              const SizedBox(height: 12),
              if (cameras.length > 1)
                DropdownButton<String>(
                  value: selected,
                  isExpanded: true,
                  items: [
                    for (var i = 0; i < cameras.length; i++)
                      DropdownMenuItem(
                        value: cameras[i],
                        child: Text(
                          strings.cameraLabel(i + 1, cameras[i]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: starting ? null : onSelect,
                ),
              if (error != null) Text(error!),
              if (preview != null)
                preview!
              else if (starting)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        SizedBox(
          width: 560,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: FilledButton(
                    key: const ValueKey('camera-capture'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                    ),
                    onPressed: starting || capturing ? null : onCapture,
                    child: Text(
                      strings.cameraCapture,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                    ),
                    onPressed: starting ? null : onRestart,
                    child: Text(
                      strings.cameraRestart,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                    ),
                    onPressed: onCancel,
                    child: Text(strings.cancel, textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
