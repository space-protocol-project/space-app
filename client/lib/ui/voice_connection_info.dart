import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/voice_connection_info.dart';

class VoiceConnectionDetails extends StatelessWidget {
  const VoiceConnectionDetails({super.key, required this.info});
  final VoiceConnectionInfo info;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final route = switch (info.route) {
      VoiceRoute.direct => strings.voiceRouteDirect,
      VoiceRoute.relay => strings.voiceRouteRelay,
      VoiceRoute.unknown => strings.voiceRouteUnknown,
    };
    final delay = info.roundTripMs;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        delay == null ? route : '$route · ${strings.voiceRoundTrip(delay)}',
        key: const ValueKey('voice-connection-info'),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
