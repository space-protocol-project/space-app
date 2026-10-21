import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/voice_transmission.dart';

class VoiceTouchButton extends StatefulWidget {
  const VoiceTouchButton({super.key});

  @override
  State<VoiceTouchButton> createState() => _VoiceTouchButtonState();
}

class _VoiceTouchButtonState extends State<VoiceTouchButton> {
  int? _pointer;

  void _release(PointerEvent event) {
    if (event.pointer != _pointer) return;
    _pointer = null;
    voiceTouchTransmission.value = false;
  }

  @override
  void dispose() {
    voiceTouchTransmission.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 8),
    child: Listener(
      onPointerDown: (event) {
        if (_pointer != null) return;
        _pointer = event.pointer;
        voiceTouchTransmission.value = true;
      },
      onPointerUp: _release,
      onPointerCancel: _release,
      child: FilledButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.mic),
        label: Text(context.strings.voiceHoldToTalk),
      ),
    ),
  );
}
