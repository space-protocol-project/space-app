import 'mention_data.dart';
import 'chat_outbox.dart';
import 'generated/space/v1/space.pb.dart';
import 'queued_mutation.dart';

List<Content> projectQueuedMutations(
  List<Content> messages,
  List<PendingMessage> pending,
  String principal,
) {
  final projected = {for (final message in messages) message.id: message};
  final blocked = <String>{};
  for (final entry in pending) {
    if (entry.blocked) blocked.add(entry.channelId);
    final change = entry.mutation;
    if (change == null || blocked.contains(entry.channelId)) continue;
    final original = projected[change.id];
    if (original == null ||
        original.channelId != entry.channelId ||
        original.deleted) {
      continue;
    }
    final copy = original.deepCopy();
    _projectChange(copy, entry, principal);
    projected[change.id] = copy;
  }
  return projected.values.toList();
}

void _projectChange(Content message, PendingMessage entry, String principal) {
  final change = entry.mutation!;
  switch (change.kind) {
    case MutationKind.edit:
      message.text = entry.text;
      message.mentions
        ..clear()
        ..addAll(change.mentions);
    case MutationKind.delete:
      message.deleted = true;
      message.text = '';
      message.mentions.clear();
      message.attachments.clear();
      message.reactions.clear();
    case MutationKind.reaction:
      final reaction = message.reactions
          .where((item) => item.emoji == change.emoji)
          .firstOrNull;
      if (change.active) {
        final item = reaction ?? Reaction(emoji: change.emoji);
        if (reaction == null) message.reactions.add(item);
        if (!item.principalIds.contains(principal)) {
          item.principalIds.add(principal);
        }
      } else {
        reaction?.principalIds.remove(principal);
        message.reactions.removeWhere((item) => item.principalIds.isEmpty);
      }
  }
}

List<PendingMessage> acknowledgeMutation(
  List<PendingMessage> saved,
  PendingMessage confirmed,
  int applied,
) => saved
    .where((entry) => entry.key != confirmed.key)
    .map(
      (entry) => entry.mutation?.after == confirmed.key
          ? entry.withMutation(entry.mutation!.following(applied))
          : entry,
    )
    .toList();

void checkMutationReceipt(
  OutboxScope scope,
  PendingMessage entry,
  MutationReceipt receipt,
) {
  final change = entry.mutation!;
  final content = receipt.content;
  if (receipt.key != entry.key ||
      content.id != change.id ||
      content.channelId != entry.channelId ||
      content.authorId != change.author ||
      content.sequence.toInt() != change.sequence) {
    throw const FormatException('Подтверждение другого изменения');
  }
  final difference = receipt.appliedRevision - change.revision;
  final minimum = change.kind == MutationKind.reaction ? 0 : 1;
  if (difference < minimum ||
      difference > 1 ||
      content.revision.toInt() < receipt.appliedRevision) {
    throw const FormatException('Неверная версия изменения');
  }
  if (content.revision.toInt() == receipt.appliedRevision &&
      !_matchesChange(content, entry, scope.principalId)) {
    throw const FormatException('Изменение не подтверждено');
  }
}

bool _matchesChange(Content content, PendingMessage entry, String principal) {
  final change = entry.mutation!;
  return switch (change.kind) {
    MutationKind.edit =>
      !content.deleted &&
          content.text == entry.text &&
          sameMentions(content.mentions, change.mentions),
    MutationKind.delete =>
      content.deleted &&
          content.text.isEmpty &&
          content.attachments.isEmpty &&
          content.reactions.isEmpty,
    MutationKind.reaction =>
      !content.deleted &&
          content.reactions.any(
                (item) =>
                    item.emoji == change.emoji &&
                    item.principalIds.contains(principal),
              ) ==
              change.active,
  };
}
