import 'mention_data.dart';
import 'generated/space/v1/community_mentions.pb.dart';
import 'generated/space/v1/space.pb.dart';

enum MutationKind { edit, delete, reaction }

class QueuedMutation {
  const QueuedMutation({
    required this.kind,
    required this.id,
    required this.author,
    required this.sequence,
    required this.revision,
    this.hasAttachments = false,
    this.emoji = '',
    this.active = false,
    this.after = '',
    this.mentions = const [],
  });
  factory QueuedMutation.forMessage(
    Content message,
    MutationKind kind, {
    String emoji = '',
    bool active = false,
    String after = '',
    List<CommunityMention> mentions = const [],
  }) => QueuedMutation(
    kind: kind,
    id: message.id,
    author: message.authorId,
    sequence: message.sequence.toInt(),
    revision: message.revision.toInt(),
    hasAttachments: message.attachments.isNotEmpty,
    emoji: emoji,
    active: active,
    mentions: mentions,
    after: after,
  );
  final MutationKind kind;
  final List<CommunityMention> mentions;
  final String id, author, emoji, after;
  final int sequence, revision;
  final bool active, hasAttachments;

  QueuedMutation following(int applied) => QueuedMutation(
    kind: kind,
    id: id,
    author: author,
    sequence: sequence,
    revision: applied,
    hasAttachments: hasAttachments,
    emoji: emoji,
    active: active,
    mentions: mentions,
  );

  QueuedMutation dependingOn(String key) => QueuedMutation(
    kind: kind,
    id: id,
    author: author,
    sequence: sequence,
    revision: revision,
    hasAttachments: hasAttachments,
    emoji: emoji,
    active: active,
    mentions: mentions,
    after: key,
  );

  Map<String, dynamic> toJson() => {
    'kind': kind.name,
    'id': id,
    'author': author,
    'sequence': sequence,
    'revision': revision,
    'files': hasAttachments,
    'emoji': emoji,
    'active': active,
    'after': after,
    if (mentions.isNotEmpty) 'mentions': mentionJson(mentions),
  };
  factory QueuedMutation.fromJson(Map<String, dynamic> value) {
    final result = QueuedMutation(
      kind: MutationKind.values.byName(value['kind'] as String),
      id: value['id'] as String,
      author: value['author'] as String,
      sequence: value['sequence'] as int,
      revision: value['revision'] as int,
      hasAttachments: value['files'] as bool,
      emoji: value['emoji'] as String,
      active: value['active'] as bool,
      after: value['after'] as String,
      mentions: (value['mentions'] as List? ?? [])
          .map((m) => CommunityMention()..mergeFromProto3Json(m))
          .toList(),
    );
    result.validate();
    return result;
  }
  void validate() {
    _validateTarget();
    _validateMentions();
    _validateReaction();
  }

  void _validateMentions() {
    if (mentions.length > 10 ||
        (kind != MutationKind.edit && mentions.isNotEmpty)) {
      throw const FormatException('Недопустимые упоминания изменения');
    }
  }

  void _validateTarget() {
    if (id.isEmpty ||
        id.length > 128 ||
        author.isEmpty ||
        author.length > 128 ||
        sequence < 1 ||
        revision < 1 ||
        after.length > 128) {
      throw const FormatException('Недопустимая цель изменения');
    }
  }

  void _validateReaction() {
    if (kind != MutationKind.reaction) {
      if (emoji.isNotEmpty || active) {
        throw const FormatException('Неожиданная реакция');
      }
      return;
    }
    if (emoji.isEmpty || emoji.runes.length > 16 || emoji.length > 64) {
      throw const FormatException('Недопустимая реакция');
    }
  }
}

class MutationReceipt {
  MutationReceipt(this.content, this.key, this.appliedRevision);
  final Content content;
  final String key;
  final int appliedRevision;
}

abstract interface class QueuedMutationSession {
  Future<MutationReceipt> mutateQueued(
    String channelId,
    String key,
    String text,
    QueuedMutation mutation,
  );
}
