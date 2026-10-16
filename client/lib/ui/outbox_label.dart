import 'package:flutter/widgets.dart';

import '../l10n/strings.dart';
import '../src/chat_outbox.dart';
import '../src/queued_mutation.dart';

String outboxEntryTitle(BuildContext context, PendingMessage entry) {
  final strings = context.strings;
  return switch (entry.mutation?.kind) {
    MutationKind.edit => '${strings.outboxEdit}: ${entry.text}',
    MutationKind.delete => strings.outboxDelete,
    MutationKind.reaction =>
      '${entry.mutation!.emoji} ${entry.mutation!.active ? strings.outboxReactionAdd : strings.outboxReactionRemove}',
    null => entry.text.isEmpty ? strings.outboxFileMessage : entry.text,
  };
}
