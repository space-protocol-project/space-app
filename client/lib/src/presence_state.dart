part of 'server_presence.dart';

final class PresenceState {
  const PresenceState({this.online = const {}, this.change});
  final Map<String, bool> online;
  final ServerPresenceChange? change;
}
