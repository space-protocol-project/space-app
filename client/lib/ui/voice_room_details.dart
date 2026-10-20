import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/generated/space/v1/space.pb.dart' show Channel;
import '../src/generated/space/v1/voice.pb.dart';
import '../src/voice_controller.dart';
import '../src/voice_signaling.dart';
import 'components.dart';
import 'voice_roster.dart';

class VoiceRoomDetails extends StatefulWidget {
  const VoiceRoomDetails({
    super.key,
    required this.room,
    required this.controller,
    required this.api,
    required this.load,
  });
  final Channel room;
  final VoiceController controller;
  final VoiceSignaling api;
  final Future<VoiceRoomState> Function() load;
  @override
  State<VoiceRoomDetails> createState() => _VoiceRoomDetailsState();
}

class _VoiceRoomDetailsState extends State<VoiceRoomDetails>
    with WidgetsBindingObserver {
  VoiceRoomState? _roster;
  String _error = '';
  Timer? _timer;
  bool _loading = false;
  bool _resumed = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _resumed = state == AppLifecycleState.resumed;
    _monitor();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _monitor();
  }

  void _monitor() {
    _timer?.cancel();
    if (!_resumed ||
        !TickerMode.valuesOf(context).enabled ||
        !widget.room.permissions.read)
      return;
    unawaited(_refresh());
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => unawaited(_refresh()),
    );
  }

  Future<void> _refresh() async {
    if (_loading) return;
    _loading = true;
    final pending = Future<VoiceRoomState>.sync(widget.load);
    unawaited(
      pending.then(
        (_) => _loading = false,
        onError: (Object _, StackTrace stack) {
          _loading = false;
        },
      ),
    );
    try {
      final roster = await pending.timeout(const Duration(seconds: 5));
      if (mounted)
        setState(() {
          _roster = roster;
          _error = '';
        });
    } catch (error) {
      if (mounted)
        setState(() {
          _roster = null;
          _error = error.toString();
        });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<VoiceController, VoiceState>(
        bloc: widget.controller,
        builder: (context, state) => _content(context, state),
      );

  Widget _content(BuildContext context, VoiceState state) {
    final active = widget.controller.matches(widget.api, widget.room.id);
    final roster = active && state.roster != null ? state.roster : _roster;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.headphones_outlined),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.room.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              FilledButton.tonal(
                key: ValueKey('voice-join-${widget.room.id}'),
                onPressed: active || !widget.room.permissions.read
                    ? null
                    : () => unawaited(
                        widget.controller.join(
                          widget.api,
                          widget.room.id,
                          widget.room.title,
                        ),
                      ),
                child: Text(
                  active
                      ? context.strings.voiceConnected
                      : context.strings.voiceJoin,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (!widget.room.permissions.read)
            Text(context.strings.noReadAccess)
          else if (roster != null)
            VoiceRoster(
              people: roster.participants,
              speaking: active ? state.speaking : const {},
            )
          else if (_error.isNotEmpty)
            Text('${context.strings.voiceFailure}: $_error')
          else
            const LinearProgressIndicator(),
          if (active &&
              roster != null &&
              roster.participants.any((p) => !p.hasAudioSlot()))
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                context.strings.voiceActivityUpdateRuntime,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
