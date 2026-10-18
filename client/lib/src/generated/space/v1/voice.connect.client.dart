//
//  Generated code. Do not modify.
//  source: space/v1/voice.proto
//

import "package:connectrpc/connect.dart" as connect;
import "voice.pb.dart" as spacev1voice;
import "voice.connect.spec.dart" as specs;

/// Голос передаётся WebRTC, через RPC проходит только управление и SDP.
extension type VoiceServiceClient (connect.Transport _transport) {
  Future<spacev1voice.JoinVoiceRoomResponse> joinVoiceRoom(
    spacev1voice.JoinVoiceRoomRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.VoiceService.joinVoiceRoom,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1voice.UpdateVoiceRoomResponse> updateVoiceRoom(
    spacev1voice.UpdateVoiceRoomRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.VoiceService.updateVoiceRoom,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1voice.LeaveVoiceRoomResponse> leaveVoiceRoom(
    spacev1voice.LeaveVoiceRoomRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.VoiceService.leaveVoiceRoom,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1voice.GetVoiceRoomResponse> getVoiceRoom(
    spacev1voice.GetVoiceRoomRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.VoiceService.getVoiceRoom,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
