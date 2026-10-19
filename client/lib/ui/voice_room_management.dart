import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/core.dart';
import 'components.dart';

class VoiceRoomManagement extends StatelessWidget {
  const VoiceRoomManagement({super.key, required this.session});
  final SpaceSession session;

  @override
  Widget build(BuildContext context) => SurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.strings.voiceTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        if (session.server.voiceRoomsVersion != 3)
          Text(context.strings.voiceUpdateRuntime)
        else
          CreateVoiceRoomButton(onCreate: session.createVoiceRoom),
      ],
    ),
  );
}

class CreateVoiceRoomButton extends StatefulWidget {
  const CreateVoiceRoomButton({super.key, required this.onCreate});
  final Future<void> Function(String) onCreate;

  @override
  State<CreateVoiceRoomButton> createState() => _CreateVoiceRoomButtonState();
}

class _CreateVoiceRoomButtonState extends State<CreateVoiceRoomButton> {
  bool busy = false;

  Future<void> _create() async {
    if (busy) return;
    setState(() => busy = true);
    try {
      final name = await _askName();
      if (name != null) await widget.onCreate(name);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<String?> _askName() {
    var enteredName = '';
    return showDialog<String>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(context.strings.voiceCreate),
        content: TextField(
          onChanged: (value) => enteredName = value,
          maxLength: 80,
          autofocus: true,
          decoration: InputDecoration(labelText: context.strings.voiceName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: Text(context.strings.voiceCancel),
          ),
          FilledButton(
            onPressed: () {
              if (enteredName.trim().isNotEmpty) {
                Navigator.pop(dialog, enteredName.trim());
              }
            },
            child: Text(context.strings.voiceSave),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: busy ? null : () => unawaited(_create()),
    icon: const Icon(Icons.add),
    label: Text(context.strings.voiceCreate),
  );
}
