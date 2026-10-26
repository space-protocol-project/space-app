import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/strings.dart';
import '../src/space_search.dart';

Future<SpaceSearchResult?> showSpaceSearch(BuildContext context, {
  required SpaceSearchApi api, required Map<String, String> channels,
  required Stream<Object?> changes, required bool Function() available,
  VoidCallback? chatSearch,
}) => showDialog<SpaceSearchResult>(context: context,
  builder: (_) => SpaceSearchDialog(api: api, channels: channels,
    changes: changes, available: available, chatSearch: chatSearch));

class SpaceSearchDialog extends StatefulWidget {
  const SpaceSearchDialog({super.key, required this.api, required this.channels,
    required this.changes, required this.available, this.chatSearch});
  final SpaceSearchApi api;
  final Map<String, String> channels;
  final Stream<Object?> changes;
  final bool Function() available;
  final VoidCallback? chatSearch;
  @override State<SpaceSearchDialog> createState() => _SpaceSearchDialogState();
}

class _SpaceSearchDialogState extends State<SpaceSearchDialog> {
  late final controller = SpaceSearchController(widget.api,
    channels: widget.channels, available: widget.available);
  final input = TextEditingController();
  StreamSubscription<Object?>? subscription;
  Timer? timer;
  @override void initState() {
    super.initState();
    subscription = widget.changes.listen((_) => _check());
    timer = Timer.periodic(const Duration(seconds: 10), (_) => _check());
    _check();
  }
  void _check() { if (!widget.available()) controller.invalidate(); }
  @override void dispose() {
    timer?.cancel();
    unawaited(subscription?.cancel());
    unawaited(controller.close());
    input.dispose();
    super.dispose();
  }
  @override Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.all(16),
    child: SizedBox(width: 720, height: MediaQuery.sizeOf(context).height * .8,
      child: Padding(padding: const EdgeInsets.all(16),
        child: BlocBuilder<SpaceSearchController, SpaceSearchState>(
          bloc: controller, builder: (_, state) => _body(state)))));

  Widget _body(SpaceSearchState state) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _header(state), const SizedBox(height: 12),
      TextField(key: const ValueKey('space-search-input'), controller: input,
        autofocus: true, enabled: !state.revoked,
        textInputAction: TextInputAction.search, onSubmitted: controller.submit,
        decoration: InputDecoration(labelText: context.strings.spaceSearchHint,
          errorText: state.invalid ? context.strings.communitySearchInvalid : null,
          suffixIcon: IconButton(tooltip: context.strings.search,
            onPressed: state.revoked ? null : () => controller.submit(input.text),
            icon: const Icon(Icons.search)))),
      const SizedBox(height: 12),
      if (state.loading) const LinearProgressIndicator(),
      ..._status(state),
      Expanded(child: ListView.builder(itemCount: state.results.length,
        itemBuilder: (_, index) => _entry(state.results[index]))),
      if (state.capped) Text(context.strings.spaceSearchLimit),
      if (state.next.isNotEmpty) TextButton(onPressed: state.loading ? null : controller.more,
        child: Text(context.strings.loadMoreFiles)),
    ]);

  Widget _header(SpaceSearchState state) => Row(children: [
    Expanded(child: Text(context.strings.spaceSearch, maxLines: 2, overflow: TextOverflow.ellipsis)),
    if (widget.chatSearch != null) IconButton(
      tooltip: context.strings.spaceSearchChatMode, icon: const Icon(Icons.chat_outlined),
      onPressed: () { Navigator.pop(context); widget.chatSearch!(); }),
    IconButton(tooltip: context.strings.forumRefresh, icon: const Icon(Icons.refresh),
      onPressed: state.loading || state.revoked ? null : controller.refresh),
    IconButton(tooltip: context.strings.close, icon: const Icon(Icons.close),
      onPressed: () => Navigator.pop(context)),
  ]);

  List<Widget> _status(SpaceSearchState state) {
    if (state.revoked) return [Text(context.strings.communitySearchRevoked)];
    if (state.error != null) return [Text(context.strings.messageSearchFailed)];
    if (state.query.isNotEmpty && !state.invalid && !state.loading && state.results.isEmpty) {
      return [Text(context.strings.communitySearchEmpty)];
    }
    return [];
  }

  String _kind(SpaceSearchKind kind) => switch (kind.value) {
    1 => context.strings.spaceSearchChat,
    2 => context.strings.communitySearchThread,
    3 => context.strings.communitySearchReply,
    4 => context.strings.communitySearchPost,
    _ => context.strings.communitySearchComment,
  };

  Widget _entry(SpaceSearchResult item) => ListTile(
    key: ValueKey('space-search-${spaceSearchKey(item)}'),
    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    title: Text('${item.channelTitle} · ${_kind(item.kind)}', maxLines: 2, overflow: TextOverflow.ellipsis),
    subtitle: Text([item.title, item.snippet, item.authorName].where((s) => s.isNotEmpty).join('\n'),
      maxLines: 5, overflow: TextOverflow.ellipsis),
    onTap: () { _check(); if (!controller.state.revoked) Navigator.pop(context, item); });
}
