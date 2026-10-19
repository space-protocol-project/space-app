import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/voice_devices.dart';
import '../src/voice_microphone_test.dart';
import 'voice_audio_controls.dart';

Future<void> showVoiceDevices(
  BuildContext context,
  VoiceDevices devices,
  VoiceMicrophoneTest test,
) => showDialog<void>(
  context: context,
  builder: (_) => VoiceDevicesDialog(devices: devices, microphoneTest: test),
);

class VoiceDevicesDialog extends StatefulWidget {
  const VoiceDevicesDialog({
    super.key,
    required this.devices,
    this.microphoneTest,
  });
  final VoiceDevices devices;
  final VoiceMicrophoneTest? microphoneTest;

  @override
  State<VoiceDevicesDialog> createState() => _VoiceDevicesDialogState();
}

class _VoiceDevicesDialogState extends State<VoiceDevicesDialog>
    with WidgetsBindingObserver {
  VoiceDevices get devices => widget.devices;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(devices.refresh());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      unawaited(widget.microphoneTest?.stop());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(widget.microphoneTest?.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.strings.voiceSettingsTitle),
    content: SizedBox(
      width: 720,
      child: BlocBuilder<VoiceDevices, VoiceDevicesState>(
        bloc: devices,
        builder: (context, state) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.strings.voiceDevicesDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 4,
                child: state.busy ? const LinearProgressIndicator() : null,
              ),
              const SizedBox(height: 12),
              _deviceGroups(state),
              if (widget.microphoneTest != null)
                VoiceMicrophoneTestControls(
                  test: widget.microphoneTest!,
                  devices: devices,
                ),
              VoiceProcessingControls(devices: devices, state: state),
              const SizedBox(height: 24),
              if (state.error.isNotEmpty) _notice(state.error, error: true),
              if (state.inputUnavailable || state.outputUnavailable)
                _notice(context.strings.voiceDeviceUnavailable, error: true),
              _notice(context.strings.voiceDevicesRemembered),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton.icon(
        onPressed: () => unawaited(devices.refresh()),
        icon: const Icon(Icons.refresh),
        label: Text(context.strings.voiceRefreshDevices),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.strings.voiceCloseDevices),
      ),
    ],
  );

  Widget _deviceGroups(VoiceDevicesState state) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 560) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _deviceGroup(state, true),
            const SizedBox(height: 24),
            _deviceGroup(state, false),
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _deviceGroup(state, true)),
          const SizedBox(width: 24),
          Expanded(child: _deviceGroup(state, false)),
        ],
      );
    },
  );

  Widget _deviceGroup(VoiceDevicesState state, bool input) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        input
            ? context.strings.voiceInputDevice
            : context.strings.voiceOutputDevice,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      const SizedBox(height: 10),
      _group(state, input),
      VoiceGainSlider(
        value: input ? state.audio.inputGain : state.audio.outputGain,
        label: input
            ? context.strings.voiceInputVolume
            : context.strings.voiceOutputVolume,
        onChanged: state.busy
            ? null
            : (value) => unawaited(
                devices.updateAudio(
                  input
                      ? state.audio.copyWith(inputGain: value)
                      : state.audio.copyWith(outputGain: value),
                ),
              ),
      ),
    ],
  );

  Widget _notice(String text, {bool error = false}) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: error ? colors.errorContainer : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              error ? Icons.warning_amber_rounded : Icons.info_outline,
              size: 20,
              color: error ? colors.onErrorContainer : colors.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: error
                      ? colors.onErrorContainer
                      : colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _group(VoiceDevicesState state, bool input) {
    final options = state.devices
        .where((device) => device.input == input)
        .toList();
    final selected = input ? state.input : state.output;
    final missing = input ? state.inputUnavailable : state.outputUnavailable;
    final value = selected;
    return InputDecorator(
      isEmpty: value == null,
      decoration: InputDecoration(
        prefixIcon: Icon(input ? Icons.mic_none : Icons.headphones_outlined),
        border: const OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          key: ValueKey(input ? 'voice-input' : 'voice-output'),
          value: value,
          isExpanded: true,
          hint: Text(context.strings.voiceCurrentDevice),
          items: [
            if (missing)
              DropdownMenuItem(
                value: selected,
                enabled: false,
                child: Text(
                  context.strings.voiceDeviceDisconnected,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            for (final device in options)
              DropdownMenuItem(
                value: device.id,
                child: Text(
                  device.label.isEmpty ? device.id : device.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: state.busy
              ? null
              : (id) {
                  if (id == null) return;
                  unawaited(
                    devices.select(
                      options.firstWhere((device) => device.id == id),
                    ),
                  );
                },
        ),
      ),
    );
  }
}
