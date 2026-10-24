import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/community_search.dart';
import '../src/generated/space/v1/community_search.pb.dart';

void revealCommunityResult(BuildContext? Function() locate) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final target = locate();
    if (target != null && target.mounted) {
      unawaited(Scrollable.ensureVisible(target));
    }
  });
}

Future<CommunitySearchResult?> showCommunitySearch(
  BuildContext context, {
  required CommunitySearchApi api,
  required String channel,
  required String title,
  required Stream<Object?> changes,
  required bool Function() available,
}) => showDialog<CommunitySearchResult>(
  context: context,
  builder: (_) => _CommunitySearchDialog(
    api: api,
    channel: channel,
    title: title,
    changes: changes,
    available: available,
  ),
);

class _CommunitySearchDialog extends StatefulWidget {
  const _CommunitySearchDialog({
    required this.api,
    required this.channel,
    required this.title,
    required this.changes,
    required this.available,
  });
  final CommunitySearchApi api;
  final String channel, title;
  final Stream<Object?> changes;
  final bool Function() available;
  @override
  State<_CommunitySearchDialog> createState() => _CommunitySearchDialogState();
}

class _CommunitySearchDialogState extends State<_CommunitySearchDialog> {
  late final controller = CommunitySearchController(widget.api, widget.channel);
  final input = TextEditingController();
  StreamSubscription<Object?>? subscription;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    subscription = widget.changes.listen((_) => checkAccess());
    checkAccess();
    timer = Timer.periodic(const Duration(seconds: 10), (_) {
      checkAccess();
      unawaited(controller.refresh());
    });
  }

  void checkAccess() {
    if (!widget.available()) controller.invalidate();
  }

  @override
  void dispose() {
    timer?.cancel();
    unawaited(subscription?.cancel());
    unawaited(controller.close());
    input.dispose();
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
        child: BlocBuilder<CommunitySearchController, CommunitySearchState>(
          bloc: controller,
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    tooltip: context.strings.forumBack,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _input(state),
              const SizedBox(height: 12),
              if (state.loading) const LinearProgressIndicator(),
              ..._status(state),
              Expanded(
                child: ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (_, index) => _result(state.results[index]),
                ),
              ),
              if (state.next.isNotEmpty)
                TextButton(
                  onPressed: state.loading ? null : controller.more,
                  child: Text(context.strings.loadMoreFiles),
                ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _input(CommunitySearchState state) => TextField(
    controller: input,
    autofocus: true,
    enabled: !state.revoked,
    textInputAction: TextInputAction.search,
    onSubmitted: controller.submit,
    decoration: InputDecoration(
      labelText: context.strings.communitySearchHint,
      errorText: state.invalid ? context.strings.communitySearchInvalid : null,
      suffixIcon: IconButton(
        tooltip: context.strings.search,
        onPressed: state.revoked ? null : () => controller.submit(input.text),
        icon: const Icon(Icons.search),
      ),
    ),
  );

  List<Widget> _status(CommunitySearchState state) {
    if (state.revoked) return [Text(context.strings.communitySearchRevoked)];
    if (state.error != null) return [Text(context.strings.messageSearchFailed)];
    if (state.query.isNotEmpty &&
        !state.loading &&
        !state.invalid &&
        state.results.isEmpty) {
      return [Text(context.strings.communitySearchEmpty)];
    }
    return [];
  }

  String _kind(CommunitySearchKind kind) => switch (kind) {
    CommunitySearchKind.COMMUNITY_SEARCH_KIND_FORUM_THREAD =>
      context.strings.communitySearchThread,
    CommunitySearchKind.COMMUNITY_SEARCH_KIND_FORUM_REPLY =>
      context.strings.communitySearchReply,
    CommunitySearchKind.COMMUNITY_SEARCH_KIND_FEED_POST =>
      context.strings.communitySearchPost,
    _ => context.strings.communitySearchComment,
  };

  Widget _result(CommunitySearchResult result) => ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    title: Text(
      '${_kind(result.kind)} · ${result.title.isEmpty ? result.authorName : result.title}',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Text(
      result.snippet,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ),
    onTap: () {
      checkAccess();
      if (!controller.state.revoked) Navigator.pop(context, result);
    },
  );
}
