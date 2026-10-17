part of 'shell.dart';

class _MessageSearchScope {
  _MessageSearchScope(this.target)
    : origin = target.knownOrigin,
      principal = target.principalId,
      id = target.channelId,
      mls = target.mlsSession,
      remote = target.messageSearch,
      group = List<int>.from(
        target.channels
                .where((c) => c.id == target.channelId)
                .firstOrNull
                ?.mlsGroupId ??
            [],
      );
  final ChatController target;
  final String origin, principal, id;
  final List<int> group;
  final SpaceSession? mls;
  final MessageSearchSession? remote;
  bool get local => group.isNotEmpty;
  bool get available =>
      target.canRead && (local ? mls != null : remote != null);
  bool get valid =>
      target.knownOrigin == origin &&
      target.principalId == principal &&
      target.channelId == id &&
      target.canRead &&
      identical(target.mlsSession, mls) &&
      identical(target.messageSearch, remote) &&
      target.channels.any(
        (channel) =>
            channel.id == id &&
            channel.permissions.visible &&
            channel.permissions.read &&
            base64Encode(channel.mlsGroupId) == base64Encode(group),
      );
  Future<MessageSearchPage> fetch(String query, String cursor) async {
    if (!valid) throw StateError('Канал изменился');
    final page = local
        ? await searchMlsMessages(
            await mls!.mlsClient(),
            id,
            group,
            query,
            cursor,
          )
        : await remote!.searchMessages(id, query, cursor);
    if (!valid) throw StateError('Доступ изменился');
    return page;
  }
}

extension _ShellMessageSearch on _SpaceShellState {
  Future<void> openMessageSearch() async {
    closeNavigation();
    final scope = _MessageSearchScope(controller);
    bool valid() =>
        mounted && identical(controller, scope.target) && scope.valid;
    final protectResults = scope.valid;
    Content? hit;
    VoidCallback? closePanel;
    final subscription = workspaces.stream.listen((_) {
      if (protectResults && !valid()) closePanel?.call();
    });
    String? route;
    try {
      route = await showSpacePopup<String>(
        context,
        top: headerHeight + 22,
        surfaceKey: const ValueKey('space-search-surface'),
        builder: (context) {
          closePanel = searchPanelCloser(context);
          return SpaceSearchPanel(
            sections: searchSections(context),
            messages: scope.target.messages,
            localOnly: scope.local,
            searchMessages: scope.available
                ? (query, cursor) =>
                      guardedMessageSearch(scope, valid, query, cursor)
                : null,
            onMessageSelected: (message) => hit = message,
          );
        },
      );
    } finally {
      unawaited(subscription.cancel());
    }
    if (!mounted || route == null || route.isEmpty) return;
    if (!route.startsWith('message:')) {
      select(Section.values.firstWhere((section) => section.name == route));
      return;
    }
    if (!valid()) return;
    if (hit != null && !scope.local) {
      await scope.target.revealSearchMessage(hit!);
    }
    if (valid()) openMessage(route.substring(8));
  }

  Future<MessageSearchPage> guardedMessageSearch(
    _MessageSearchScope scope,
    bool Function() valid,
    String query,
    String cursor,
  ) async {
    if (!valid()) throw StateError('Пространство изменилось');
    final page = await scope.fetch(query, cursor);
    if (!valid()) throw StateError('Пространство изменилось');
    return page;
  }

  VoidCallback searchPanelCloser(BuildContext context) => () {
    if (!context.mounted) return;
    if (ModalRoute.of(context)?.isCurrent == true) Navigator.of(context).pop();
  };

  Map<String, String> searchSections(BuildContext context) => {
    for (final section in [
      Section.overview,
      Section.chat,
      Section.identity,
      Section.settings,
    ])
      section.name: section == Section.chat
          ? chatLabel
          : section.localized(context),
  };
}
