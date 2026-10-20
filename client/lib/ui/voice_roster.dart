import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/generated/space/v1/voice.pb.dart';

class VoiceRoster extends StatelessWidget {
  const VoiceRoster({
    super.key,
    required this.people,
    this.speaking = const {},
  });
  final List<VoiceParticipant> people;
  final Set<String> speaking;

  @override
  Widget build(BuildContext context) {
    if (people.isEmpty) return Text(context.strings.voiceRoomEmpty);
    return Wrap(
      spacing: 16,
      runSpacing: 20,
      children: [for (final person in people) _person(context, person)],
    );
  }

  Widget _person(BuildContext context, VoiceParticipant person) {
    final active =
        !person.muted &&
        !person.deafened &&
        speaking.contains(person.sessionId);
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      key: ValueKey('voice-person-${person.sessionId}'),
      width: 132,
      child: Column(
        children: [
          AnimatedContainer(
            key: ValueKey('voice-avatar-${person.sessionId}-$active'),
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: active ? colors.primary : Colors.transparent,
              ),
            ),
            child: CircleAvatar(
              radius: 27,
              backgroundColor: colors.surfaceContainerHighest,
              child: const Icon(Icons.person_outline, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            person.nickname.isEmpty ? person.principalId : person.nickname,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            _status(context, person, active),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _status(BuildContext context, VoiceParticipant person, bool active) {
    if (person.deafened) return context.strings.voiceDeafened;
    if (person.muted) return context.strings.voiceMuted;
    return active
        ? context.strings.voiceSpeaking
        : context.strings.voiceMicrophoneEnabled;
  }
}
