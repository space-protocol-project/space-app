part of 'server_presence.dart';

@Freezed(equal: false)
abstract class PresenceState with _$PresenceState {
  const PresenceState._();
  const factory PresenceState({
    @Default({}) Map<String, bool> online,
    ServerPresenceChange? change,
  }) = _PresenceState;
}
