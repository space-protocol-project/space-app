import 'package:flutter/material.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../l10n/strings.dart';
import '../src/core.dart';
import 'components.dart';

class VoiceRoomManagement extends StatelessWidget {
  const VoiceRoomManagement({
    super.key,
    required this.session,
    required this.call,
  });
  final SpaceSession session;
  final AdminCall call;

  @override
  Widget build(BuildContext context) {
    if (session.server.voiceRoomsVersion == 3) {
      return ChannelsPanel(call: call, voiceRooms: true);
    }
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.strings.voiceTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(context.strings.voiceUpdateRuntime),
        ],
      ),
    );
  }
}
