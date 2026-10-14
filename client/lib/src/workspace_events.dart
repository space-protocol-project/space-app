part of 'server_workspaces.dart';

sealed class WorkspaceEvent<T> extends RequestEvent<T> {}

final class WorkspacesSynchronized extends WorkspaceEvent<void> {
  WorkspacesSynchronized(Iterable<String> origins)
    : origins = List.unmodifiable(origins);
  final List<String> origins;
}

final class WorkspaceAdopted extends WorkspaceEvent<void> {
  WorkspaceAdopted(this.origin, this.controller, {this.owned = true});
  final String origin;
  final ChatController controller;
  final bool owned;
}

final class WorkspacesRefreshed extends WorkspaceEvent<void> {}

final class WorkspaceReconnected extends WorkspaceEvent<void> {
  WorkspaceReconnected(this.origin);
  final String origin;
}

final class WorkspaceRemoved extends WorkspaceEvent<void> {
  WorkspaceRemoved(this.origin);
  final String origin;
}

final class WorkspaceStatePublished extends WorkspaceEvent<void> {
  WorkspaceStatePublished(this.state);
  final WorkspaceState state;
}
