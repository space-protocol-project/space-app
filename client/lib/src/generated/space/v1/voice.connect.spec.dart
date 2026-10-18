//
//  Generated code. Do not modify.
//  source: space/v1/voice.proto
//

import "package:connectrpc/connect.dart" as connect;
import "voice.pb.dart" as spacev1voice;

/// Голос передаётся WebRTC, через RPC проходит только управление и SDP.
abstract final class VoiceService {
  /// Fully-qualified name of the VoiceService service.
  static const name = 'space.v1.VoiceService';

  static const getVoiceConfiguration = connect.Spec(
    '/$name/GetVoiceConfiguration',
    connect.StreamType.unary,
    spacev1voice.GetVoiceConfigurationRequest.new,
    spacev1voice.GetVoiceConfigurationResponse.new,
  );

  static const joinVoiceRoom = connect.Spec(
    '/$name/JoinVoiceRoom',
    connect.StreamType.unary,
    spacev1voice.JoinVoiceRoomRequest.new,
    spacev1voice.JoinVoiceRoomResponse.new,
  );

  static const updateVoiceRoom = connect.Spec(
    '/$name/UpdateVoiceRoom',
    connect.StreamType.unary,
    spacev1voice.UpdateVoiceRoomRequest.new,
    spacev1voice.UpdateVoiceRoomResponse.new,
  );

  static const leaveVoiceRoom = connect.Spec(
    '/$name/LeaveVoiceRoom',
    connect.StreamType.unary,
    spacev1voice.LeaveVoiceRoomRequest.new,
    spacev1voice.LeaveVoiceRoomResponse.new,
  );

  static const getVoiceRoom = connect.Spec(
    '/$name/GetVoiceRoom',
    connect.StreamType.unary,
    spacev1voice.GetVoiceRoomRequest.new,
    spacev1voice.GetVoiceRoomResponse.new,
  );
}
