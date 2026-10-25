import 'message_body_layout.dart';
import 'message_footer.dart';
import 'message_markdown.dart';
import 'space_appearance.dart';
import '../l10n/strings.dart';

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.text,
    required this.author,
    required this.mine,
    this.grouped = false,
    this.sentAt,
    this.accepted = false,
    this.favorite = false,
    this.onToggleFavorite,
    this.actions,
    this.mentionBadge,
    this.reactions,
    this.reply,
    this.attachments,
    this.edited = false,
    this.deleted = false,
  });
  final String text, author;
  final bool mine, grouped, accepted;
  final DateTime? sentAt;
  final bool favorite, edited, deleted;
  final Widget? mentionBadge;
  final Widget? actions, attachments, reactions, reply;
  final VoidCallback? onToggleFavorite;

  String displayText(BuildContext context) =>
      text.isEmpty && attachments == null
      ? context.strings.messageUnavailable
      : text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, box) => Row(
        mainAxisAlignment: mine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine) ...[
            SizedBox(
              width: 32,
              child: grouped
                  ? null
                  : CircleAvatar(
                      radius: 16,
                      backgroundColor: colors.surfaceContainerHighest,
                      child: Icon(
                        Icons.person_outline,
                        size: 18,
                        color: colors.onSurface,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: box.maxWidth * (box.maxWidth < 500 ? .85 : .72),
              ),
              child: DecoratedBox(
                decoration: decoration(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: MessageBodyLayout(children: _content(context)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration decoration(BuildContext context) => BoxDecoration(
    color: mine
        ? SpaceAppearance.of(context).mine
        : messageBubbleColor(Theme.of(context).colorScheme, false),
    borderRadius: BorderRadius.only(
      topLeft: const Radius.circular(24),
      topRight: const Radius.circular(24),
      bottomLeft: Radius.circular(mine ? 24 : 6),
      bottomRight: Radius.circular(mine ? 6 : 24),
    ),
  );
  Widget _metadata(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (mentionBadge != null && !deleted) ...[
            mentionBadge!,
            const SizedBox(width: 6),
          ],
          ?actions,
          if (edited && !deleted) ...[
            Text(
              context.strings.messageEdited,
              style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
            ),
            const SizedBox(width: 6),
          ],
          if (sentAt != null)
            Tooltip(
              message:
                  '${MaterialLocalizations.of(context).formatFullDate(sentAt!)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(sentAt!))}',
              child: Text(
                MaterialLocalizations.of(context)
                    .formatTimeOfDay(TimeOfDay.fromDateTime(sentAt!)),
                style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
              ),
            ),
          if (accepted) ...[
            const SizedBox(width: 6),
            Tooltip(
              message: context.strings.messageAccepted,
              child: Icon(
                Icons.check,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _content(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return [
      if (!mine && !grouped) ...[
        Text(
          author,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: colors.secondary,
          ),
        ),
        const SizedBox(height: 4),
      ],
      if (!deleted) ?reply,
      if (deleted)
        Text(
          context.strings.messageDeleted,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: colors.onSurfaceVariant,
          ),
        )
      else
        MessageMarkdown(text: displayText(context)),
      if (!deleted) ?attachments,
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: MessageFooter(
          reactions: deleted ? null : reactions,
          metadata: _metadata(context),
        ),
      ),
    ];
  }
}

Color messageBubbleColor(ColorScheme colors, bool mine) => Color.alphaBlend(
  messageMarkerColor(colors, mine).withValues(alpha: .16),
  colors.surface,
);

Color messageMarkerColor(ColorScheme colors, bool mine) =>
    mine ? colors.primary : colors.secondary;
