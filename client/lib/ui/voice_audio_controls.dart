import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/voice_audio_settings.dart';
import '../src/voice_platform.dart';
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
          key: ValueKey(widget.label),
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
      _profiles(context),
      const Divider(height: 32),
      _inputMode(context),
      if (!state.audio.pushToTalk) _activation(context),
      if (state.audio.pushToTalk && !Platform.isAndroid)
        VoiceShortcutSettings(devices: devices, showError: false),
      const Divider(height: 32),
      _noiseSuppression(context),
      _switch(
        context.strings.voiceEchoCancellation,
        state.audio.echoCancellation,
        (value) => _update(state.audio.copyWith(echoCancellation: value)),
      ),
      _advanced(context),
      const SizedBox(height: 8),
      Text(
        context.strings.voiceProcessingHint,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );

  Widget _profiles(BuildContext context) => RadioGroup<VoiceInputProfile>(
    groupValue: state.audio.profile,
    onChanged: (profile) {
      if (!state.busy && profile != null) {
        final audio = state.audio.withProfile(profile);
        _update(
          profile == VoiceInputProfile.speech
              ? audio.copyWith(
                  noiseMode: voiceDefaultAudio.noiseMode,
                  customProfile: false,
                )
              : audio,
        );
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.strings.voiceInputProfile,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        _profile(
          VoiceInputProfile.speech,
          context.strings.voiceProfileSpeech,
          context.strings.voiceProfileSpeechHelp,
        ),
        _profile(
          VoiceInputProfile.studio,
          context.strings.voiceProfileStudio,
          context.strings.voiceProfileStudioHelp,
        ),
        _profile(
          VoiceInputProfile.custom,
          context.strings.voiceProfileCustom,
          context.strings.voiceProfileCustomHelp,
        ),
      ],
    ),
  );

  Widget _profile(VoiceInputProfile profile, String title, String help) =>
      RadioListTile<VoiceInputProfile>(
        key: ValueKey('voice-profile-${profile.name}'),
        contentPadding: EdgeInsets.zero,
        value: profile,
        enabled: !state.busy,
        title: Text(title),
        subtitle: Text(help),
      );

  Widget _inputMode(BuildContext context) => RadioGroup<bool>(
    groupValue: state.audio.pushToTalk,
    onChanged: (value) {
      if (!state.busy && value != null) {
        _update(state.audio.copyWith(pushToTalk: value));
      }
    },
    child: Column(
      children: [
        RadioListTile<bool>(
          contentPadding: EdgeInsets.zero,
          value: false,
          enabled: !state.busy,
          title: Text(context.strings.voiceActivity),
          subtitle: Text(context.strings.voiceActivityHelp),
        ),
        RadioListTile<bool>(
          contentPadding: EdgeInsets.zero,
          value: true,
          enabled: !state.busy,
          title: Text(context.strings.voicePushToTalk),
          subtitle: Text(
            Platform.isAndroid
                ? context.strings.voiceTouchToTalkHint
                : context.strings.voicePushToTalkHint,
          ),
        ),
      ],
    ),
  );

  Widget _activation(BuildContext context) => Column(
    children: [
      _switch(
        context.strings.voiceAutomaticSensitivity,
        state.audio.automaticSensitivity,
        (value) => _update(state.audio.copyWith(automaticSensitivity: value)),
      ),
      if (!state.audio.automaticSensitivity) _sensitivity(context),
    ],
  );

  Widget _noiseSuppression(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: DropdownButtonFormField<VoiceNoiseSuppression>(
      key: ValueKey('noise-${state.audio.noiseMode.name}'),
      initialValue: state.audio.noiseMode,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: context.strings.voiceNoiseSuppression,
        helperText: Platform.isAndroid
            ? context.strings.voiceAndroidNoiseHelp
            : context.strings.voiceNoiseSuppressionHelp,
        helperMaxLines: 4,
        border: const OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem(
          value: VoiceNoiseSuppression.deepFilter,
          child: const Text('DeepFilterNet3'),
        ),
        DropdownMenuItem(
          value: VoiceNoiseSuppression.webrtc,
          child: Text(context.strings.voiceNoiseWebRtc),
        ),
        DropdownMenuItem(
          value: VoiceNoiseSuppression.disabled,
          child: Text(context.strings.voiceNoiseOff),
        ),
      ],
      onChanged: state.busy
          ? null
          : (value) {
              if (value != null) {
                _update(state.audio.copyWith(noiseMode: value));
              }
            },
    ),
  );

  Widget _advanced(BuildContext context) => ExpansionTile(
    key: const PageStorageKey('voice-advanced-settings'),
    tilePadding: EdgeInsets.zero,
    title: Text(context.strings.voiceAdvancedSettings),
    children: [
      _switch(
        context.strings.voiceAutoGain,
        state.audio.autoGainControl,
        (value) => _update(state.audio.copyWith(autoGainControl: value)),
      ),
      _switch(
        context.strings.voiceHighPass,
        state.audio.highPassFilter,
        (value) => _update(state.audio.copyWith(highPassFilter: value)),
      ),
      if (!state.audio.pushToTalk) ...[
        _switch(
          context.strings.voiceAdvancedActivation,
          state.audio.advancedActivation,
          (value) => _update(state.audio.copyWith(advancedActivation: value)),
        ),
        Text(
          context.strings.voiceAdvancedActivationHelp,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        _releaseDelay(context),
      ],
    ],
  );

  Widget _releaseDelay(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 16),
      Text(context.strings.voiceReleaseDelay(state.audio.releaseDelayMs)),
      Overlay.wrap(
        alwaysSizeToContent: true,
        clipBehavior: Clip.none,
        child: Slider(
          key: const ValueKey('voice-release-delay'),
          value: state.audio.releaseDelayMs.toDouble(),
          min: 50,
          max: 1000,
          divisions: 19,
          label: '${state.audio.releaseDelayMs} ms',
          onChanged: state.busy
              ? null
              : (value) => _update(
                  state.audio.copyWith(releaseDelayMs: value.round()),
                ),
        ),
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
