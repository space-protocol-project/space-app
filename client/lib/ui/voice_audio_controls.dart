import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/voice_audio_settings.dart';
import '../src/voice_devices.dart';
import '../src/voice_microphone_test.dart';
import 'voice_shortcut_settings.dart';

class VoiceGainSlider extends StatefulWidget {
  const VoiceGainSlider({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });
  final double value;
  final String label;
  final ValueChanged<double>? onChanged;
  @override
  State<VoiceGainSlider> createState() => _VoiceGainSliderState();
}

class _VoiceGainSliderState extends State<VoiceGainSlider> {
  double? _drag;
  @override
  void didUpdateWidget(VoiceGainSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || widget.onChanged == null) {
      _drag = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = _drag ?? widget.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text(
          '${widget.label} · ${(value * 100).round()}%',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        // Локальный Overlay удерживает узлы индикатора Slider внутри диалога.
        Overlay.wrap(
          alwaysSizeToContent: true,
          clipBehavior: Clip.none,
          child: Slider(
            value: value,
            min: 0,
            max: 2,
            divisions: 100,
            label: '${(value * 100).round()}%',
            onChanged: widget.onChanged == null
                ? null
                : (value) => setState(() => _drag = value),
            onChangeEnd: widget.onChanged == null
                ? null
                : (value) {
                    setState(() => _drag = null);
                    widget.onChanged!(value);
                  },
          ),
        ),
      ],
    );
  }
}

class VoiceProcessingControls extends StatelessWidget {
  const VoiceProcessingControls({
    super.key,
    required this.devices,
    required this.state,
  });
  final VoiceDevices devices;
  final VoiceDevicesState state;

  void _update(VoiceAudioSettings audio) =>
      unawaited(devices.updateAudio(audio));

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Divider(height: 40),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(context.strings.voicePushToTalk),
        subtitle: Text(context.strings.voicePushToTalkHint),
        value: state.audio.pushToTalk,
        onChanged: state.busy
            ? null
            : (value) => _update(state.audio.copyWith(pushToTalk: value)),
      ),
      if (!state.audio.pushToTalk) ...[
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(context.strings.voiceAutomaticSensitivity),
          value: state.audio.automaticSensitivity,
          onChanged: state.busy
              ? null
              : (value) =>
                    _update(state.audio.copyWith(automaticSensitivity: value)),
        ),
        if (!state.audio.automaticSensitivity) _sensitivity(context),
      ],
      VoiceShortcutSettings(devices: devices, showError: false),
      const Divider(height: 32),
      Text(
        context.strings.voiceProcessingTitle,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<VoiceInputProfile>(
        isExpanded: true,
        key: ValueKey(state.audio.profile),
        initialValue: state.audio.profile,
        decoration: InputDecoration(
          labelText: context.strings.voiceInputProfile,
          border: const OutlineInputBorder(),
        ),
        items: [
          DropdownMenuItem(
            value: VoiceInputProfile.speech,
            child: Text(context.strings.voiceProfileSpeech),
          ),
          DropdownMenuItem(
            value: VoiceInputProfile.studio,
            child: Text(context.strings.voiceProfileStudio),
          ),
          DropdownMenuItem(
            value: VoiceInputProfile.custom,
            enabled: false,
            child: Text(context.strings.voiceProfileCustom),
          ),
        ],
        onChanged: state.busy
            ? null
            : (profile) {
                if (profile != null) _update(state.audio.withProfile(profile));
              },
      ),
      const SizedBox(height: 12),
      _switch(
        context.strings.voiceNoiseSuppression,
        state.audio.noiseSuppression,
        (value) => _update(state.audio.copyWith(noiseSuppression: value)),
      ),
      _switch(
        context.strings.voiceEchoCancellation,
        state.audio.echoCancellation,
        (value) => _update(state.audio.copyWith(echoCancellation: value)),
      ),
      _switch(
        context.strings.voiceAutoGain,
        state.audio.autoGainControl,
        (value) => _update(state.audio.copyWith(autoGainControl: value)),
      ),
      const SizedBox(height: 8),
      Text(
        context.strings.voiceProcessingHint,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) =>
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label),
        value: value,
        onChanged: state.busy ? null : onChanged,
      );

  Widget _sensitivity(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        '${context.strings.voiceSensitivity}: ${state.audio.thresholdDb.round()} dBFS',
      ),
      Overlay.wrap(
        alwaysSizeToContent: true,
        clipBehavior: Clip.none,
        child: Slider(
          value: state.audio.thresholdDb,
          min: -60,
          max: -10,
          divisions: 50,
          label: '${state.audio.thresholdDb.round()} dBFS',
          onChanged: state.busy
              ? null
              : (value) => _update(state.audio.copyWith(thresholdDb: value)),
        ),
      ),
    ],
  );
}

class VoiceMicrophoneTestControls extends StatelessWidget {
  const VoiceMicrophoneTestControls({
    super.key,
    required this.test,
    required this.devices,
  });
  final VoiceMicrophoneTest test;
  final VoiceDevices devices;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<VoiceMicrophoneTest, VoiceMicrophoneTestState>(
        bloc: test,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonalIcon(
                key: const ValueKey('voice-microphone-test'),
                onPressed: _action(state),
                icon: Icon(
                  state.active || state.busy ? Icons.stop : Icons.mic_none,
                ),
                label: Text(
                  state.active || state.busy
                      ? context.strings.voiceStopMicrophoneTest
                      : context.strings.voiceTestMicrophone,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _meter(context, state),
            const SizedBox(height: 12),
            Text(
              context.strings.voiceMicrophoneTestHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (state.error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  state.error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      );

  VoidCallback? _action(VoiceMicrophoneTestState state) {
    if (state.active || state.busy) return () => unawaited(test.stop());
    if (devices.state.busy ||
        !devices.state.ready ||
        devices.state.inputUnavailable) {
      return null;
    }
    return () =>
        unawaited(test.start(devices.state.input, devices.state.audio));
  }

  Widget _meter(BuildContext context, VoiceMicrophoneTestState state) {
    final db = state.level > 0
        ? (20 * math.log(state.level) / math.ln10).clamp(-60.0, 0.0)
        : -60.0;
    final level = state.active ? (db + 60) / 60 : 0.0;
    return Semantics(
      label: context.strings.voiceMicrophoneLevel,
      value: '${db.round()} dBFS',
      child: Row(
        children: List.generate(
          32,
          (index) => Expanded(
            child: Container(
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: index / 32 < level
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
