part of 'server_workspaces.dart';

final class WorkspaceState {
  const WorkspaceState({this.chats = const {}, this.loading = const {}});
  final Map<String, ChatState> chats;
  final Set<String> loading;
}
