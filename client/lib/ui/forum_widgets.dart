import '../src/generated/space/v1/community_mentions.pb.dart';
import 'community_mentions.dart';

import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';

import '../l10n/strings.dart';
import '../src/core.dart' show AttachmentSession;
import '../src/generated/space/v1/forum.pb.dart';
import '../src/generated/space/v1/space.pb.dart' show Asset;
import 'attachment_widgets.dart';
import 'space_appearance.dart';

String forumAuthor(String name, String id) {
  if (name.isNotEmpty) return name;
  return id.length > 16 ? '${id.substring(0, 16)}…' : id;
}

String forumDate(BuildContext context, int timestamp, {bool time = false}) {
  if (timestamp <= 0) return '—';
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
  final local = MaterialLocalizations.of(context);
  if (time) return local.formatTimeOfDay(TimeOfDay.fromDateTime(date));
  return local.formatShortDate(date);
}

class ForumTopicList extends StatelessWidget {
  const ForumTopicList({
    super.key,
    required this.topics,
    required this.open,
    required this.busy,
  });
  final List<ForumThread> topics;
  final ValueChanged<String> open;
  final bool busy;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Divider(height: 1),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                context.strings.forumListTitle,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            Text(
              context.strings.forumReplies,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
      const Divider(height: 1),
      for (final topic in topics) _row(context, topic),
    ],
  );
  Widget _row(BuildContext context, ForumThread topic) => InkWell(
    onTap: busy ? null : () => open(topic.id),
    child: Container(
      constraints: const BoxConstraints(minHeight: 80),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: SpaceAppearance.of(context).line),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.hidden ? context.strings.forumHiddenTopic : topic.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: topic.unreadCount > Int64.ZERO
                        ? FontWeight.w800
                        : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                _metadata(context, topic),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 44,
            child: Text(
              '${topic.replyCount}',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    ),
  );
  Widget _metadata(BuildContext context, ForumThread topic) => DefaultTextStyle(
    style: Theme.of(context).textTheme.bodySmall!
        .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    child: Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (topic.pinned) ...[
          const Icon(Icons.push_pin_outlined, size: 12),
          Text(context.strings.forumPinned),
          const Text('·'),
        ],
        if (topic.readStateSupported && topic.unreadCount > Int64.ZERO) ...[
          Text(
            '${context.strings.forumUnread}: ${topic.unreadCount}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text('·'),
        ],
        Tooltip(
          message: topic.authorId,
          child: Text(forumAuthor(topic.authorName, topic.authorId)),
        ),
        const Text('·'),
        Text(forumDate(context, topic.createdAtUnix.toInt())),
        if (topic.closed) ...[
          const Text('·'),
          const Icon(Icons.lock_outline, size: 12),
          Text(context.strings.forumClosedLabel),
        ],
      ],
    ),
  );
}

class ForumMessage extends StatelessWidget {
  const ForumMessage({
    super.key,
    this.mentions = const [],
    required this.author,
    required this.authorId,
    required this.text,
    required this.timestamp,
    this.original = false,
    this.assets = const [],
    this.session,
    this.trailing,
  });
  final List<CommunityMention> mentions;
  final String author, authorId, text;
  final int timestamp;
  final bool original;
  final List<Asset> assets;
  final AttachmentSession? session;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    final appearance = SpaceAppearance.of(context);
    return Container(
      padding: original
          ? const EdgeInsets.all(18)
          : const EdgeInsets.symmetric(vertical: 20),
      decoration: original
          ? BoxDecoration(
              color: appearance.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: appearance.line),
            )
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: appearance.line)),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(context),
          if (text.isNotEmpty) ...[
            const SizedBox(height: 14),
            CommunityMentionText(
              text,
              mentions: mentions,
              style: const TextStyle(height: 1.7),
            ),
          ],
          if (assets.isNotEmpty)
            MessageAttachments(assets: assets, session: session),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final name = forumAuthor(author, authorId);
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            name.isEmpty ? '?' : name.characters.first.toUpperCase(),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Tooltip(
            message: authorId,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Tooltip(
          message: forumDate(context, timestamp),
          child: Text(
            forumDate(context, timestamp, time: true),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class ForumPrivacy extends StatelessWidget {
  const ForumPrivacy({super.key});
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(
        Icons.shield_outlined,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          context.strings.forumPrivacyShort,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
      ),
    ],
  );
}

class ForumClosedNotice extends StatelessWidget {
  const ForumClosedNotice({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: SpaceAppearance.of(context).surface,
      border: Border.all(color: SpaceAppearance.of(context).line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lock_outline, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.strings.forumClosedHeading,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                context.strings.forumClosedDescription,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ForumAbout extends StatelessWidget {
  const ForumAbout({super.key, this.topic, this.manage});
  final ForumThread? topic;
  final VoidCallback? manage;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        topic == null
            ? context.strings.forumAboutSection
            : context.strings.forumAboutTopic,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 16),
      ..._details(context),
      const Divider(height: 40),
      const ForumPrivacy(),
      if (manage != null) ...[
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: manage,
          icon: const Icon(Icons.tune, size: 16),
          label: Text(context.strings.forumManage),
        ),
      ],
    ],
  );
  List<Widget> _details(BuildContext context) {
    final value = topic;
    if (value == null) {
      return [
        Text(
          context.strings.forumDescription,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ];
    }
    return [
      _detail(
        context,
        context.strings.forumState,
        value.hidden
            ? context.strings.forumHiddenTopic
            : value.closed
            ? context.strings.forumClosedLabel
            : context.strings.forumOpen,
      ),
      if (!value.hidden)
        _detail(
          context,
          context.strings.forumAuthor,
          forumAuthor(value.authorName, value.authorId),
        ),
      _detail(context, context.strings.forumReplies, '${value.replyCount}'),
      _detail(
        context,
        context.strings.forumCreated,
        forumDate(context, value.createdAtUnix.toInt()),
      ),
    ];
  }

  Widget _detail(BuildContext context, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    ),
  );
}
