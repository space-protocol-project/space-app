part of 'server_workspaces.dart';

@Freezed(equal: false)
abstract class WorkspaceState with _$WorkspaceState {
  const WorkspaceState._();
  const factory WorkspaceState({
    @Default({}) Map<String, ChatState> chats,
    @Default({}) Set<String> loading,
  }) = _WorkspaceState;
}
