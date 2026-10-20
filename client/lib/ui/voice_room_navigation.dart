import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/generated/space/v1/space.pb.dart' show Channel;
import 'components.dart';

class VoiceRoomNavigation extends StatelessWidget {
  const VoiceRoomNavigation({
    super.key,
    required this.rooms,
    required this.onSelect,
    required this.onRefresh,
    this.selectedRoomId,
    this.onJoin,
    this.active = false,
    this.busy = false,
  });
  final List<Channel> rooms;
  final ValueChanged<String?> onSelect;
  final VoidCallback? onRefresh;
  final String? selectedRoomId;
  final ValueChanged<Channel>? onJoin;
  final bool active, busy;

  @override
  Widget build(BuildContext context) => SurfaceCard(
    key: const ValueKey('server-voice-rooms'),
    color: Theme.of(context).colorScheme.surfaceContainerHigh,
    hoverBorder: true,
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    child: Column(
      children: [
        ListTile(
          leading: const Icon(Icons.headset_mic_outlined, size: 20),
          title: Text(context.strings.rooms),
          selected: active && selectedRoomId == null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
          onTap: () => onSelect(_firstReadable),
          trailing: onRefresh == null
              ? null
              : IconButton(
                  tooltip: context.strings.voiceRefreshRooms,
                  onPressed: busy ? null : onRefresh,
                  icon: const Icon(Icons.refresh, size: 20),
                ),
        ),
        for (final room in rooms) _room(context, room),
      ],
    ),
  );

  String? get _firstReadable {
    for (final room in rooms) {
      if (room.permissions.read) return room.id;
    }
    return null;
  }

  Widget _room(BuildContext context, Channel room) => GestureDetector(
    onDoubleTap: busy || !room.permissions.read || onJoin == null
        ? null
        : () => onJoin!(room),
    child: ListTile(
      key: ValueKey('sidebar-voice-room-${room.id}'),
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      selected: active && selectedRoomId == room.id,
      leading: Icon(
        room.permissions.read ? Icons.headphones_outlined : Icons.lock_outline,
        size: 18,
      ),
      title: Text(room.title, overflow: TextOverflow.ellipsis),
      subtitle: room.permissions.read
          ? null
          : Text(context.strings.noReadAccess),
      onTap: busy ? null : () => onSelect(room.id),
    ),
  );
}
