import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/core.dart';
import '../src/voice_controller.dart';
import '../src/voice_signaling.dart';
import '../src/generated/space/v1/voice.pb.dart';
import 'components.dart';

class VoiceRoomsView extends StatelessWidget {
  const VoiceRoomsView({
    super.key,
    required this.session,
    required this.controller,
  });
  final SpaceSession? session;
  final VoiceController controller;

  @override
  Widget build(BuildContext context) {
    final connected = session;
    return PageBody(
      title: context.strings.voiceTitle,
      description: context.strings.voiceDescription,
      children: connected == null
          ? [Text(context.strings.voiceConnectFirst)]
          : _rooms(context, connected),
    );
  }

  List<Widget> _rooms(BuildContext context, SpaceSession connected) {
    if (Platform.isAndroid || Platform.isIOS) {
      return [Text(context.strings.voiceDesktopOnly)];
    }
    if (connected.server.voiceRoomsVersion != 1) {
      return [Text(context.strings.voiceUpdateRuntime)];
    }
    return [
      Text(context.strings.voiceLimit),
      const SizedBox(height: 16),
      _createButton(context, connected),
      if (connected.voiceRooms.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(context.strings.voiceEmpty),
        ),
      for (final room in connected.voiceRooms)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SurfaceCard(
            child: Row(
              children: [
                const Icon(Icons.headphones_outlined),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    room.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                FilledButton.tonal(
                  key: ValueKey('voice-join-${room.id}'),
                  onPressed: () => unawaited(
                    controller.join(
                      SessionVoiceSignaling(connected),
                      room.id,
                      room.title,
                    ),
                  ),
                  child: Text(context.strings.voiceJoin),
                ),
              ],
            ),
          ),
        ),
      const SizedBox(height: 20),
      VoiceParticipants(controller: controller),
      const SizedBox(height: 20),
      Text(
        context.strings.voicePrivacy,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ];
  }

  Widget _createButton(BuildContext context, SpaceSession connected) {
    if (!['owner', 'admin'].contains(connected.role)) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: () => unawaited(_create(context, connected)),
        icon: const Icon(Icons.add),
        label: Text(context.strings.voiceCreate),
      ),
    );
  }

  Future<void> _create(BuildContext context, SpaceSession connected) async {
    var enteredName = '';
    final name = await showDialog<String>(
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
    if (name == null) {
      return;
    }
    try {
      await connected.createVoiceRoom(name);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}

class VoiceParticipants extends StatelessWidget {
  const VoiceParticipants({super.key, required this.controller});
  final VoiceController controller;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<VoiceController, VoiceState>(
        bloc: controller,
        builder: (context, state) {
          if (!state.active) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.strings.voiceParticipants} · ${state.title}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              for (final person in state.roster?.participants ?? [])
                _person(context, person),
            ],
          );
        },
      );
  Widget _person(BuildContext context, VoiceParticipant person) => ListTile(
    leading: Icon(person.muted ? Icons.mic_off_outlined : Icons.mic_none),
    title: Text(person.nickname.isEmpty ? person.principalId : person.nickname),
    subtitle: Text(_status(context, person)),
  );

  String _status(BuildContext context, VoiceParticipant person) {
    if (person.deafened) {
      return context.strings.voiceDeafened;
    }
    return person.muted
        ? context.strings.voiceMuted
        : context.strings.voiceSpeaking;
  }
}

class VoiceCallBar extends StatelessWidget {
  const VoiceCallBar({super.key, required this.controller});
  final VoiceController controller;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<VoiceController, VoiceState>(
        bloc: controller,
        builder: (context, state) {
          if (!state.active && state.error.isEmpty) {
            return const SizedBox.shrink();
          }
          return Material(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.error.isNotEmpty)
                      Text(
                        '${context.strings.voiceFailure}: ${state.error}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    _controls(context, state),
                  ],
                ),
              ),
            ),
          );
        },
      );

  Widget _controls(BuildContext context, VoiceState state) => Row(
    children: [
      Expanded(
        child: Text(
          state.phase == VoicePhase.connected
              ? '${context.strings.voiceConnected} · ${state.title}'
              : state.active
              ? context.strings.voiceJoining
              : '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      IconButton(
        key: const ValueKey('voice-microphone'),
        tooltip: state.muted
            ? context.strings.voiceMicrophoneOn
            : context.strings.voiceMicrophoneOff,
        onPressed:
            state.busy ||
                state.phase != VoicePhase.connected ||
                state.deafened ||
                !state.canPublish
            ? null
            : () => unawaited(controller.toggleMicrophone()),
        icon: Icon(state.muted ? Icons.mic_off_outlined : Icons.mic_none),
      ),
      IconButton(
        key: const ValueKey('voice-deafen'),
        tooltip: state.deafened
            ? context.strings.voiceSoundOn
            : context.strings.voiceSoundOff,
        onPressed: state.busy || state.phase != VoicePhase.connected
            ? null
            : () => unawaited(controller.toggleDeafened()),
        icon: Icon(
          state.deafened ? Icons.headset_off_outlined : Icons.headset_outlined,
        ),
      ),
      IconButton(
        key: const ValueKey('voice-leave'),
        tooltip: context.strings.voiceLeave,
        onPressed: () => unawaited(controller.leave()),
        icon: Icon(Icons.call_end, color: Theme.of(context).colorScheme.error),
      ),
    ],
  );
}
