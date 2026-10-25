part of 'core.dart';

extension _ChatMentionGuard on SpaceSession {
  void _requireChatMentions(String channelId) {
    if (!chatMentionsSupported) throw const GrpcError.unimplemented();
    final target = availableChannels
        .where((c) => c.id == channelId)
        .firstOrNull;
    if (target == null ||
        target.archived ||
        !target.permissions.read ||
        !target.permissions.write ||
        target.mlsGroupId.isNotEmpty) {
      throw const GrpcError.permissionDenied(
        'Упоминание в этом чате недоступно',
      );
    }
  }
}

extension ChatMentionRpc on SpaceSession {
  // Реализация методов интерфейса находится в основном классе и делегирует сюда.
  Future<Content> _sendMentioned(
    String id,
    String text,
    String key,
    List<String> attachments,
    String reply,
    List<mentions_pb.CommunityMention> mentions,
  ) async {
    _requireChatMentions(id);
    if (reply.isNotEmpty && !repliesSupported) {
      throw const GrpcError.unimplemented();
    }
    await _ensureSession();
    return (await ContentServiceClient(channel).createContent(
      CreateContentRequest(
        channelId: id,
        text: text,
        idempotencyKey: key,
        attachmentIds: attachments,
        replyToId: reply,
        mentions: mentions,
      ),
      options: _options,
    )).content;
  }

  Future<Content> _updateMentioned(
    Content message,
    String text,
    List<mentions_pb.CommunityMention> mentions,
  ) async {
    _requireChatMentions(message.channelId);
    await _ensureSession();
    return (await ContentServiceClient(channel).updateContent(
      UpdateContentRequest(
        channelId: message.channelId,
        id: message.id,
        text: text,
        expectedRevision: message.revision,
        mentions: mentions,
      ),
      options: _options,
    )).content;
  }
}
