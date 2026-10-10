import 'package:flutter/material.dart';

import '../l10n/admin_localizations.dart';

class RecoveryCameraView extends StatelessWidget {
  const RecoveryCameraView({
    super.key,
    required this.cameras,
    required this.selected,
    required this.starting,
    required this.error,
    required this.preview,
    required this.onSelect,
    required this.onRestart,
    required this.onCancel,
  });
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(strings.cameraHelp),
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
              if (error != null)
                Text(error!)
              else if (preview != null)
                preview!
              else
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: starting ? null : onRestart,
          child: Text(strings.cameraRestart),
        ),
        TextButton(onPressed: onCancel, child: Text(strings.cancel)),
      ],
    );
  }
}
