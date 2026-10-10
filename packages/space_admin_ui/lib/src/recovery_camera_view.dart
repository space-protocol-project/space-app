import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Сканировать карточку'),
    content: SizedBox(
      width: 560,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Наведите камеру на QR-карточку Space. Кадры обрабатываются на этом устройстве. Микрофон выключен.',
            ),
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
                        'Камера ${i + 1} — ${cameras[i]}',
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
        child: const Text('Включить снова'),
      ),
      TextButton(onPressed: onCancel, child: const Text('Отмена')),
    ],
  );
}
