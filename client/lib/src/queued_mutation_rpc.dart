part of 'core.dart';

extension _QueuedMutationRpc on SpaceSession {
  Future<MutationReceipt> _mutateQueued(
    String channelId,
    String key,
    String text,
    QueuedMutation change,
  ) async {
    if (change.mentions.isNotEmpty && !chatMentionsSupported) {
      throw const GrpcError.unimplemented();
    }
    final revision = Int64(change.revision);
    final request = switch (change.kind) {
      MutationKind.edit => ApplyContentMutationRequest(
        update: UpdateContentRequest(
          channelId: channelId,
          id: change.id,
          text: text,
          mentions: change.mentions,
          expectedRevision: revision,
          idempotencyKey: key,
        ),
      ),
      MutationKind.delete => ApplyContentMutationRequest(
        delete: DeleteContentRequest(
          channelId: channelId,
          id: change.id,
          expectedRevision: revision,
          idempotencyKey: key,
        ),
      ),
      MutationKind.reaction => ApplyContentMutationRequest(
        reaction: SetReactionRequest(
          channelId: channelId,
          id: change.id,
          expectedRevision: revision,
          emoji: change.emoji,
          active: change.active,
          idempotencyKey: key,
        ),
      ),
    };
    final result = await ContentServiceClient(channel)
        .applyContentMutation(request, options: _options);
    return MutationReceipt(
      result.content,
      result.idempotencyKey,
      result.appliedRevision.toInt(),
    );
  }
}
