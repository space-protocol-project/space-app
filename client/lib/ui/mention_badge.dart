import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/generated/space/v1/community_mentions.pb.dart';

class MentionBadge extends StatelessWidget {
  const MentionBadge({
    super.key,
    required this.mentions,
    required this.principal,
  });
  final List<CommunityMention> mentions;
  final String principal;

  @override
  Widget build(BuildContext context) {
    if (mentions.isEmpty) return const SizedBox.shrink();
    final mine = mentions.any((mention) => mention.principalId == principal);
    final labels = mentions
        .map((m) => '@${m.displayName} (${m.principalId})')
        .toSet()
        .join('\n');
    return Tooltip(
      message: mine ? '${context.strings.dashboardMention}\n$labels' : labels,
      child: Icon(
        Icons.alternate_email,
        size: 15,
        color: mine
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
