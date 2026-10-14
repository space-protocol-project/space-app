part of 'server_presence.dart';

sealed class PresenceEvent<T> extends RequestEvent<T> {}

final class PresenceWatched extends PresenceEvent<void> {
  PresenceWatched(Iterable<String> origins)
    : origins = Set.unmodifiable(origins);
  final Set<String> origins;
}

final class PresenceChecked extends PresenceEvent<void> {}

final class PresenceStatePublished extends PresenceEvent<void> {
  PresenceStatePublished(this.state);
  final PresenceState state;
}

final class PresenceProbeCompleted extends PresenceEvent<void> {
  PresenceProbeCompleted(this.origin, this.generation, this.online);
  final String origin;
  final int generation;
  final bool? online;
}
