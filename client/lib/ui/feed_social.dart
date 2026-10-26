import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/feed_api.dart';
import '../src/feed_controller.dart';
import '../src/generated/space/v1/feed.pb.dart';
import 'feed.dart' show FeedComposer;
import 'participant_profile.dart';

class FeedQuote extends StatelessWidget {
  const FeedQuote({super.key, required this.post, required this.open});
  final FeedPost? post;
  final VoidCallback open;

  @override
  Widget build(BuildContext context) {
    final source = post;
    final available = source != null && !source.hidden;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.strings.feedRepost,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          if (available) ...[
            ParticipantName(
              principal: source.authorId,
              fallback: source.authorName,
            ),
            const SizedBox(height: 8),
            Text(source.text, maxLines: 5, overflow: TextOverflow.ellipsis),
            if (source.attachments.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.attach_file, size: 18),
              ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: open,
              child: Text(context.strings.feedOpenOriginal),
            ),
          ] else
            Text(context.strings.feedOriginalUnavailable),
        ],
      ),
    );
  }
}

class FeedDraftReference extends StatelessWidget {
  const FeedDraftReference({
    super.key,
    required this.state,
    required this.cancel,
  });
  final FeedDraftState state;
  final VoidCallback cancel;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Icon(state.repostOf.isEmpty ? Icons.reply : Icons.repeat, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            state.repostOf.isEmpty
                ? context.strings.feedReplyTo(state.replySequence.toString())
                : context.strings.feedRepostHint,
          ),
        ),
        IconButton(
          key: const ValueKey('feed-clear-reference'),
          tooltip: context.strings.feedCancelReference,
          onPressed: state.busy ? null : cancel,
          icon: const Icon(Icons.close),
        ),
      ],
    ),
  );
}

Future<void> showFeedShare(
  BuildContext context, {
  required FeedApi api,
  required FeedPost post,
  required Future<void> Function() refresh,
  required bool sendWithShift,
}) async {
  BuildContext? dialogContext;
  final draft = FeedDraftCubit(
    api: api,
    channel: post.channelId,
    post: '',
    sent: () async {
      final current = dialogContext;
      if (current != null && current.mounted) Navigator.pop(current);
      await refresh();
    },
  )..repost(post);
  try {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 640,
              maxHeight: MediaQuery.sizeOf(context).height * .85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.strings.feedShare,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (!draft.state.busy) Navigator.pop(context);
                        },
                        tooltip: context.strings.forumBack,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FeedComposer(draft: draft, sendWithShift: sendWithShift),
                ],
              ),
            ),
          ),
        );
      },
    );
  } finally {
    await draft.close();
  }
}
