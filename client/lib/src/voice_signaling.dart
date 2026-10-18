import 'core.dart';
import 'generated/space/v1/voice.pb.dart';

abstract interface class VoiceSignaling {
  Stream<void> get disconnected;
  Future<JoinVoiceRoomResponse> join(String room, String offer);
  Future<VoiceRoomState> update(
    String room,
    String id,
    bool muted,
    bool deafened,
  );
  Future<void> leave(String room, String id);
}

class SessionVoiceSignaling implements VoiceSignaling {
  const SessionVoiceSignaling(this.session);
  final SpaceSession session;
  @override
  Stream<void> get disconnected => session.closing;
  @override
  Future<JoinVoiceRoomResponse> join(String room, String offer) =>
      session.joinVoiceRoom(room, offer);
  @override
  Future<VoiceRoomState> update(
    String room,
    String id,
    bool muted,
    bool deafened,
  ) => session.updateVoiceRoom(room, id, muted: muted, deafened: deafened);
  @override
  Future<void> leave(String room, String id) =>
      session.leaveVoiceRoom(room, id);
}
