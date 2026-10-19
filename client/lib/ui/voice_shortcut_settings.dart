import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/voice_devices.dart';
import '../src/voice_shortcut.dart';

class VoiceShortcutSettings extends StatefulWidget {
  const VoiceShortcutSettings({
    super.key,
    required this.devices,
    this.showError = true,
  });
  final VoiceDevices devices;
  final bool showError;
  @override
  State<VoiceShortcutSettings> createState() => _VoiceShortcutSettingsState();
}

class _VoiceShortcutSettingsState extends State<VoiceShortcutSettings> {
  VoiceDevices get devices => widget.devices;
  @override
  void initState() {
    super.initState();
    unawaited(devices.refresh());
  }

  Future<void> _change(BuildContext context) async {
    if (voiceShortcutRecording.value) return;
    voiceShortcutRecording.value = true;
    try {
      final shortcut = await showDialog<VoiceShortcut>(
        context: context,
        builder: (_) => const _ShortcutDialog(),
      );
      if (shortcut != null) {
        await devices.updateAudio(
          devices.state.audio.copyWith(shortcut: shortcut),
        );
      }
    } finally {
      voiceShortcutRecording.value = false;
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<VoiceDevices, VoiceDevicesState>(
        bloc: devices,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.strings.voiceShortcutTitle),
            Text(context.strings.voiceShortcutScope),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: state.busy ? null : () => _change(context),
              icon: const Icon(Icons.keyboard_outlined),
              label: Text(
                state.audio.shortcut.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.showError && state.error.isNotEmpty)
              Text(
                state.error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      );
}

class _ShortcutDialog extends StatefulWidget {
  const _ShortcutDialog();
  @override
  State<_ShortcutDialog> createState() => _ShortcutDialogState();
}

class _ShortcutDialogState extends State<_ShortcutDialog> {
  VoiceShortcut? shortcut;
  final focus = FocusNode();
  @override
  void dispose() {
    focus.dispose();
    super.dispose();
  }

  KeyEventResult _key(FocusNode node, KeyEvent event) {
    if (!node.hasPrimaryFocus) return KeyEventResult.ignored;
    if (shortcut != null && event.logicalKey == LogicalKeyboardKey.tab) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    if (event is KeyDownEvent &&
        !event.synthesized &&
        VoiceShortcut.usable(event.logicalKey)) {
      setState(() => shortcut = VoiceShortcut.fromKey(event.logicalKey));
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) => Focus(
    focusNode: focus,
    autofocus: true,
    onKeyEvent: _key,
    child: AlertDialog(
      title: Text(context.strings.voiceShortcutTitle),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.strings.voiceShortcutPress),
            const SizedBox(height: 20),
            Text(
              shortcut?.label ?? '…',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.strings.close),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, const VoiceShortcut()),
          child: const Text('F8'),
        ),
        FilledButton(
          onPressed: shortcut == null
              ? null
              : () => Navigator.pop(context, shortcut),
          child: Text(context.strings.voiceShortcutSave),
        ),
      ],
    ),
  );
}
