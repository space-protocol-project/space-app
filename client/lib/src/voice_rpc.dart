part of 'core.dart';

extension VoiceSession on SpaceSession {
  List<Channel> get voiceRooms => availableChannels
      .where((c) => !c.archived && c.views.any((v) => v.type == 'voice_room'))
      .toList(growable: false);

  Future<Channel> createVoiceRoom(String title) async {
    await _ensureSession();
    final id =
        'voice_${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';
    final reply = await ChannelServiceClient(channel).createChannel(
      CreateChannelRequest(
        channelId: id,
        title: title.trim(),
        viewType: 'voice_room',
        position: 100,
      ),
      options: _options,
    );
    return reply.channel;
  }

  Future<voice.JoinVoiceRoomResponse> joinVoiceRoom(
    String room,
    String offer,
  ) async {
    await _ensureSession();
    return channel.unary(
      voice_specs.VoiceService.joinVoiceRoom,
      voice.JoinVoiceRoomRequest(channelId: room, offerSdp: offer),
      options: _options,
    );
  }

  Future<voice.VoiceRoomState> updateVoiceRoom(
    String room,
    String id, {
    required bool muted,
    required bool deafened,
  }) async {
    await _ensureSession();
    final reply = await channel.unary(
      voice_specs.VoiceService.updateVoiceRoom,
      voice.UpdateVoiceRoomRequest(
        channelId: room,
        sessionId: id,
        muted: muted,
        deafened: deafened,
      ),
      options: _options,
    );
    return reply.state;
  }

  Future<voice.VoiceRoomState> getVoiceRoom(String room) async {
    await _ensureSession();
    final reply = await channel.unary(
      voice_specs.VoiceService.getVoiceRoom,
      voice.GetVoiceRoomRequest(channelId: room),
      options: _options,
    );
    return reply.state;
  }

  Future<void> leaveVoiceRoom(String room, String id) async {
    await _ensureSession();
    await channel.unary(
      voice_specs.VoiceService.leaveVoiceRoom,
      voice.LeaveVoiceRoomRequest(channelId: room, sessionId: id),
      options: _options,
    );
  }
}
