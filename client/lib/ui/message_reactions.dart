import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/generated/space/v1/space.pb.dart';
import 'emoji_picker.dart';

class MessageReactionBar extends StatelessWidget {
  const MessageReactionBar({
    super.key,
    required this.reactions,
    required this.principalId,
    this.onSet,
    this.authorName,
  });
  final List<Reaction> reactions;
  final String principalId;
  final void Function(String emoji, bool active)? onSet;
  final String Function(String id)? authorName;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 5,
    runSpacing: 4,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      for (final reaction in reactions)
        InputChip(
          selected: reaction.principalIds.contains(principalId),
          showCheckmark: false,
          label: Text('${reaction.emoji} ${reaction.principalIds.length}'),
          onPressed: onSet == null
              ? null
              : () => onSet!(
                  reaction.emoji,
                  !reaction.principalIds.contains(principalId),
                ),
          deleteIcon: const Icon(Icons.expand_more, size: 16),
          deleteButtonTooltipMessage: context.strings.reactionParticipants,
          onDeleted: () => showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                '${reaction.emoji} · ${context.strings.reactionParticipants}',
              ),
              content: SizedBox(
                width: 320,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final id in reaction.principalIds)
                      ListTile(title: Text(authorName?.call(id) ?? id)),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    MaterialLocalizations.of(context).closeButtonTooltip,
                  ),
                ),
              ],
            ),
          ),
        ),
      if (onSet != null)
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: context.strings.addReaction,
          icon: const Icon(Icons.add_reaction_outlined, size: 18),
          onPressed: () async {
            final emoji = await pickEmoji(context);
            if (emoji != null && context.mounted) {
              onSet!(
                emoji,
                !reactions.any(
                  (r) =>
                      r.emoji == emoji && r.principalIds.contains(principalId),
                ),
              );
            }
          },
        ),
    ],
  );
}
