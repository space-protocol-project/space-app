part of 'shell.dart';

class _MessageSearchScope {
  _MessageSearchScope(this.target)
    : channels = [
        for (final channel in target.channels)
          Channel.fromBuffer(channel.writeToBuffer()),
      ],
      origin = target.knownOrigin,
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
  final List<Channel> channels;
  final String origin, principal, id;
  final List<int> group;
  final SpaceSession? mls;
  final MessageSearchSession? remote;
  Map<String, String> get channelNames => {
    for (final channel in channels) channel.id: channel.title,
  };
  bool get offline => !target.connected;
  Future<MessageSearchPage> Function(String, String)? get allSearch {
    if (offline) return target.canSearchSavedMls ? fetchSavedAll : null;
    return available && remote != null ? fetchAll : null;
  }

  bool get local => group.isNotEmpty;
  bool get available =>
      target.canRead &&
      (offline
          ? local && target.canSearchSavedMls
          : (local ? mls != null : remote != null));
  bool get sameSession =>
      target.knownOrigin == origin &&
      target.principalId == principal &&
      identical(target.mlsSession, mls) &&
      identical(target.messageSearch, remote);
  bool get valid =>
      target.knownOrigin == origin &&
      target.principalId == principal &&
      target.channelId == id &&
      target.canRead &&
      identical(target.mlsSession, mls) &&
      identical(target.messageSearch, remote) &&
      catalogCurrent &&
      target.channels.any(
        (channel) =>
            channel.id == id &&
            channel.permissions.visible &&
            channel.permissions.read &&
            base64Encode(channel.mlsGroupId) == base64Encode(group),
      );
  bool get catalogCurrent =>
      channels.length == target.channels.length &&
      channels.every(
        (saved) => target.channels.any(
          (current) =>
              current.id == saved.id &&
              current.archived == saved.archived &&
              current.permissions == saved.permissions &&
              base64Encode(current.mlsGroupId) ==
                  base64Encode(saved.mlsGroupId),
        ),
      );

  bool readable(Channel channel) =>
      channel.views.any((view) => view.type == 'chat') &&
      !channel.archived &&
      channel.permissions.visible &&
      channel.permissions.read;

  Future<MessageSearchPage> fetchAll(String query, String cursor) async {
    if (!valid) throw StateError('Доступ изменился');
    final candidates = channels.where(readable).toList();
    final joined = await joinedGroups(candidates);
    final ids = candidates
        .where(
          (channel) =>
              channel.mlsGroupId.isEmpty || joined.contains(channel.id),
        )
        .map((channel) => channel.id)
        .toList();
    final page = await searchChannelPages(
      channels: ids,
      query: query,
      cursor: cursor,
      fetch: (id, term, after) => fetchChannel(
        channels.firstWhere((channel) => channel.id == id),
        term,
        after,
      ),
    );
    if (!valid) throw StateError('Доступ изменился');
    return page;
  }

  Future<Set<String>> joinedGroups(List<Channel> candidates) async {
    if (mls == null || !candidates.any((c) => c.mlsGroupId.isNotEmpty)) {
      return {};
    }
    final document = await (await mls!.mlsClient()).local.read();
    final saved = document['channels'] as Map;
    return {
      for (final channel in candidates)
        if (joinedGroup(saved[channel.id], channel)) channel.id,
    };
  }

  bool joinedGroup(dynamic saved, Channel channel) =>
      channel.mlsGroupId.isNotEmpty &&
      saved is Map &&
      saved['joined'] == true &&
      saved['revocation_pending'] != true &&
      saved['group_id'] == base64Encode(channel.mlsGroupId);

  Future<MessageSearchPage> fetchChannel(
    Channel channel,
    String query,
    String cursor,
  ) async {
    if (!valid) throw StateError('Доступ изменился');
    final page = channel.mlsGroupId.isNotEmpty
        ? await searchMlsMessages(
            await mls!.mlsClient(),
            channel.id,
            channel.mlsGroupId,
            query,
            cursor,
          )
        : await remote!.searchMessages(channel.id, query, cursor);
    if (!valid) throw StateError('Доступ изменился');
    return page;
  }

  Future<MessageSearchPage> fetchSavedAll(String query, String cursor) async {
    final document = await savedDocument();
    final saved = document['channels'] as Map;
    final ids = channels
        .where(
          (channel) =>
              readable(channel) && joinedGroup(saved[channel.id], channel),
        )
        .map((channel) => channel.id)
        .toList();
    final page = await searchChannelPages(
      channels: ids,
      query: query,
      cursor: cursor,
      fetch: (id, term, after) => searchMlsDocument(
        document,
        id,
        channels.firstWhere((channel) => channel.id == id).mlsGroupId,
        term,
        after,
      ),
    );
    if (!valid) throw StateError('Доступ изменился');
    return page;
  }

  Future<Map<String, dynamic>> savedDocument() async {
    if (!valid || !offline) throw StateError('Пространство изменилось');
    final document = await (await target.savedMlsArchive()).read();
    if (!valid || !offline) throw StateError('Пространство изменилось');
    return document;
  }

  Future<MessageSearchPage> fetch(String query, String cursor) async {
    if (!valid) throw StateError('Чат изменился');
    if (offline) {
      final page = await searchMlsDocument(
        await savedDocument(),
        id,
        group,
        query,
        cursor,
      );
      if (!valid) throw StateError('Доступ изменился');
      return page;
    }
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
            channelNames: scope.channelNames,
            searchAllChannels: scope.allSearch,
            allChannelsLabel: scope.offline
                ? context.strings.savedMlsSearchChannels
                : null,
            allChannelsLocalOnly: scope.offline,
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
    await _openMessageSearchResult(scope, route, hit, valid);
  }

  Future<void> _openMessageSearchResult(
    _MessageSearchScope scope,
    String? route,
    Content? hit,
    bool Function() valid,
  ) async {
    if (!mounted || route == null || route.isEmpty) return;
    if (!route.startsWith('message:')) {
      select(Section.values.firstWhere((section) => section.name == route));
      return;
    }
    if (!valid()) return;
    if (hit == null) return;
    if (scope.offline) {
      await openSavedSearchHit(scope, hit);
      return;
    }
    await openSearchHit(scope, hit);
  }

  Future<void> openSavedSearchHit(
    _MessageSearchScope scope,
    Content message,
  ) async {
    if (!scope.valid) return;
    VoidCallback? close;
    final subscription = workspaces.stream.listen((_) {
      if (!mounted || !identical(controller, scope.target) || !scope.valid) {
        close?.call();
      }
    });
    try {
      await showSpacePopup<void>(
        context,
        top: headerHeight + 22,
        builder: (context) {
          close = searchPanelCloser(context);
          return SizedBox(
            height: 420,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    scope.channelNames[message.channelId] ?? message.channelId,
                  ),
                  subtitle: Text(context.strings.savedMlsMessagePreview),
                  trailing: IconButton(
                    onPressed: close,
                    icon: const Icon(Icons.close),
                    tooltip: context.strings.close,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: SelectableText(message.text),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } finally {
      unawaited(subscription.cancel());
    }
  }

  Future<void> openSearchHit(_MessageSearchScope scope, Content message) async {
    if (scope.target.channelId != message.channelId) {
      await scope.target.selectChannel(message.channelId);
    }
    if (!mounted ||
        !identical(controller, scope.target) ||
        !scope.sameSession ||
        !scope.catalogCurrent ||
        !scope.target.canRead ||
        scope.target.channelId != message.channelId) {
      return;
    }
    final channel = scope.target.channels
        .where((c) => c.id == message.channelId)
        .firstOrNull;
    if (channel == null || !scope.readable(channel)) return;
    if (channel.mlsGroupId.isEmpty) {
      await scope.target.revealSearchMessage(message);
    }
    if (mounted &&
        identical(controller, scope.target) &&
        scope.sameSession &&
        scope.catalogCurrent &&
        scope.target.channelId == message.channelId &&
        scope.target.canRead) {
      openMessage(message.id);
    }
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
