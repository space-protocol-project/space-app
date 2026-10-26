part of 'shell.dart';

String _spaceSearchCatalog(ChatController target) {
  final channels = target.channels.toList()..sort((a,b) => a.id.compareTo(b.id));
  return jsonEncode([for (final c in channels) [c.id,c.revision.toString(),c.archived,
    c.permissions.visible,c.permissions.read,base64Encode(c.mlsGroupId),
    c.views.map((v) => v.type).toList()]]);
}

bool _spaceSearchReadable(Channel c) => !c.archived && c.mlsGroupId.isEmpty &&
  c.permissions.visible && c.permissions.read &&
  c.views.any((v) => const ['chat','forum','feed'].contains(v.type));

class _SpaceSearchScope {
  _SpaceSearchScope(this.target, this.api) : scope = api.scopeId,
    origin = target.knownOrigin, principal = target.principalId,
    catalog = _spaceSearchCatalog(target),
    channels = {for (final c in target.channels.where(_spaceSearchReadable)) c.id: c.views.first.type};
  final ChatController target;
  final SpaceSearchApi api;
  final String scope, origin, principal, catalog;
  final Map<String,String> channels;
  bool get valid => target.connected && !target.accessRemoved &&
    target.knownOrigin == origin && target.principalId == principal &&
    identical(target.spaceSearch,api) && api.scopeId == scope &&
    _spaceSearchCatalog(target) == catalog;
}

extension _ShellSpaceSearch on _SpaceShellState {
  bool _spaceSearchCurrent(_SpaceSearchScope scope) =>
    mounted && identical(controller, scope.target) && scope.valid;
  Future<void> openSpaceSearch(SpaceSearchApi api) async {
    closeNavigation();
    final scope = _SpaceSearchScope(controller,api);
    bool current() => _spaceSearchCurrent(scope);
    var chatSearch = false;
    final hit = await showSpaceSearch(context,api: api,channels: scope.channels,
      changes: workspaces.stream, available: current, chatSearch: () => chatSearch = true);
    if (!current()) return;
    if (chatSearch) { await openMessageSearch(); return; }
    if (hit != null) await _openSpaceSearchHit(scope,hit);
  }

  Future<void> _openSpaceSearchHit(_SpaceSearchScope scope, SpaceSearchResult hit) async {
    if (!_spaceSearchCurrent(scope)) return;
    if (spaceSearchView(hit.kind) == 'chat') {
      await _openSpaceSearchMessage(scope,hit);
      return;
    }
    showCommunityTarget(DashboardCommunityTarget(origin: scope.origin,
      channel: hit.channelId, destination: spaceSearchView(hit.kind) == 'forum'
        ? DashboardDestination.forum : DashboardDestination.feed,
      id: hit.parentId, replySequence: hit.sequence.toInt()));
  }

  Future<void> _openSpaceSearchMessage(_SpaceSearchScope scope, SpaceSearchResult hit) async {
    try {
      final message = await scope.target.searchContent(hit.channelId, hit.sequence.toInt());
      if (!_spaceSearchCurrent(scope) || message?.id != hit.id) return;
      await scope.target.selectChannel(hit.channelId);
      if (!_spaceSearchCurrent(scope)) return;
      await scope.target.revealSearchMessage(message!);
      if (_spaceSearchCurrent(scope)) openMessage(hit.id);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.communitySearchRevoked)));
    }
  }
}
