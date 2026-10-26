import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/community_favorite_list.dart';
import '../src/community_favorites_api.dart';
import 'community_favorites.dart';

Future<CommunitySearchResult?> showCommunityFavorites(
  BuildContext context, {
  required CommunityFavoriteApi api,
  required String channel,
  required Stream<Object?> changes,
  required bool Function() available,
}) => showDialog<CommunitySearchResult>(
  context: context,
  builder: (_) => _FavoriteDialog(
    api: api,
    channel: channel,
    changes: changes,
    available: available,
  ),
);

class _FavoriteDialog extends StatefulWidget {
  const _FavoriteDialog({
    required this.api,
    required this.channel,
    required this.changes,
    required this.available,
  });
  final CommunityFavoriteApi api;
  final String channel;
  final Stream<Object?> changes;
  final bool Function() available;
  @override
  State<_FavoriteDialog> createState() => _FavoriteDialogState();
}

class _FavoriteDialogState extends State<_FavoriteDialog> {
  late final controller = CommunityFavoriteListController(
    widget.api,
    widget.channel,
    available: widget.available,
  );
  StreamSubscription<Object?>? subscription;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    subscription = widget.changes.listen((_) => _check());
    _refresh();
    timer = Timer.periodic(const Duration(seconds: 10), (_) => _refresh());
  }

  void _check() {
    if (!widget.available()) controller.invalidate();
  }

  void _refresh() {
    _check();
    unawaited(controller.refresh());
  }

  @override
  void dispose() {
    timer?.cancel();
    unawaited(subscription?.cancel());
    unawaited(controller.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.all(16),
    child: SizedBox(
      width: 720,
      height: MediaQuery.sizeOf(context).height * .8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            BlocBuilder<
              CommunityFavoriteListController,
              CommunityFavoriteListState
            >(bloc: controller, builder: (context, state) => _body(state)),
      ),
    ),
  );
  Widget _body(CommunityFavoriteListState state) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(child: Text(context.strings.communityFavorites)),
          IconButton(
            tooltip: context.strings.forumRefresh,
            onPressed: state.loading ? null : _refresh,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: context.strings.forumBack,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      const SizedBox(height: 12),
      if (state.loading) const LinearProgressIndicator(),
      ..._status(state),
      Expanded(
        child: CommunityFavoriteScope(
          api: widget.api,
          channel: widget.channel,
          contents: state.entries.map(
            (item) => CommunityContentReference(
              kind: item.result.kind,
              id: item.result.id,
            ),
          ),
          active: !state.revoked && state.error == null,
          child: ListView.builder(
            itemCount: state.entries.length,
            itemBuilder: (_, index) => _entry(state.entries[index]),
          ),
        ),
      ),
      if (state.next.isNotEmpty)
        TextButton(
          onPressed: state.loading ? null : controller.more,
          child: Text(context.strings.loadMoreFiles),
        ),
    ],
  );
  List<Widget> _status(CommunityFavoriteListState state) {
    if (state.revoked) return [Text(context.strings.forumDenied)];
    if (state.error != null) {
      return [Text(context.strings.communityFavoriteRetry)];
    }
    if (!state.loading && state.entries.isEmpty) {
      return [Text(context.strings.communityFavoritesEmpty)];
    }
    return [];
  }

  Widget _entry(CommunityFavorite item) {
    final r = item.result;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      title: Text(
        r.title.isEmpty ? r.authorName : r.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${_kind(r.kind)} · ${r.snippet}',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: CommunityFavoriteButton(
        content: CommunityContentReference(kind: r.kind, id: r.id),
        onChanged: () => unawaited(controller.refresh()),
      ),
      onTap: () {
        _check();
        if (!controller.state.revoked) Navigator.pop(context, r);
      },
    );
  }

  String _kind(CommunitySearchKind kind) => switch (kind.value) {
    1 => context.strings.communitySearchThread,
    2 => context.strings.communitySearchReply,
    3 => context.strings.communitySearchPost,
    _ => context.strings.communitySearchComment,
  };
}
