part of 'core.dart';

class SessionForumApi implements ForumApi, ForumMedia, ForumNavigation {
  SessionForumApi(this.session);
  final SpaceSession session;
  @override
  AttachmentSession get attachmentSession => session;
  @override
  bool get attachmentsEnabled =>
      session.attachmentsEnabled && session.forumAttachmentsSupported;
  @override
  bool get supported => session.forumSupported;
  @override
  List<Channel> get sections => session.availableChannels
      .where(
        (c) =>
            !c.archived &&
            c.permissions.read &&
            c.views.any((v) => v.type == 'forum'),
      )
      .toList(growable: false);
  @override
  Future<void> refresh() => session.refreshChannels();
  @override
  Future<forum.ListForumThreadsResponse> threads(
    String channel,
    Int64 after,
  ) async {
    await session._ensureSession();
    return session.channel.unary(
      forum_specs.ForumService.listForumThreads,
      forum.ListForumThreadsRequest(channelId: channel, afterSequence: after),
      options: session._options,
    );
  }

  @override
  Future<forum.GetForumThreadResponse> thread(
    String channel,
    String id,
    Int64 after,
  ) async {
    await session._ensureSession();
    return session.channel.unary(
      forum_specs.ForumService.getForumThread,
      forum.GetForumThreadRequest(
        channelId: channel,
        threadId: id,
        afterSequence: after,
      ),
      options: session._options,
    );
  }

  @override
  Future<forum.ForumThread> create(
    String channel,
    String title,
    String text,
    String key, [
    List<String> attachments = const [],
  ]) async {
    _checkAttachments(attachments);
    await session._ensureSession();
    final response = await session.channel.unary(
      forum_specs.ForumService.createForumThread,
      forum.CreateForumThreadRequest(
        channelId: channel,
        title: title,
        text: text,
        idempotencyKey: key,
        attachmentIds: attachments,
      ),
      options: session._options,
    );
    return response.thread;
  }

  @override
  Future<forum.ReplyForumThreadResponse> reply(
    String channel,
    String id,
    String text,
    String key, [
    List<String> attachments = const [],
  ]) async {
    _checkAttachments(attachments);
    await session._ensureSession();
    return session.channel.unary(
      forum_specs.ForumService.replyForumThread,
      forum.ReplyForumThreadRequest(
        channelId: channel,
        threadId: id,
        text: text,
        idempotencyKey: key,
        attachmentIds: attachments,
      ),
      options: session._options,
    );
  }

  @override
  Future<forum.ForumThread> closeTopic(
    String channel,
    String id,
    Int64 revision,
  ) async {
    await session._ensureSession();
    final response = await session.channel.unary(
      forum_specs.ForumService.closeForumThread,
      forum.CloseForumThreadRequest(
        channelId: channel,
        threadId: id,
        expectedRevision: revision,
      ),
      options: session._options,
    );
    return response.thread;
  }

  @override
  bool get navigationSupported => session.forumNavigationSupported;
  @override
  Future<forum.ListForumThreadsResponse> navigationPage(
    String channel,
    Int64 after,
    bool afterPinned,
  ) async {
    await session._ensureSession();
    return session.channel.unary(
      forum_specs.ForumService.listForumThreads,
      forum.ListForumThreadsRequest(
        channelId: channel,
        afterSequence: after,
        pinnedFirst: true,
        afterPinned: afterPinned,
      ),
      options: session._options,
    );
  }

  @override
  Future<forum.ForumThread> pinTopic(
    String channel,
    String id,
    bool pinned,
    Int64 revision,
  ) async {
    await session._ensureSession();
    final response = await session.channel.unary(
      forum_specs.ForumService.setForumThreadPinned,
      forum.SetForumThreadPinnedRequest(
        channelId: channel,
        threadId: id,
        pinned: pinned,
        expectedRevision: revision,
      ),
      options: session._options,
    );
    return response.thread;
  }

  @override
  Future<forum.ForumThread> markRead(
    String channel,
    String id,
    Int64 through,
  ) async {
    await session._ensureSession();
    final response = await session.channel.unary(
      forum_specs.ForumService.markForumThreadRead,
      forum.MarkForumThreadReadRequest(
        channelId: channel,
        threadId: id,
        throughSequence: through,
      ),
      options: session._options,
    );
    return response.thread;
  }

  void _checkAttachments(List<String> attachments) {
    if (attachments.isNotEmpty && !attachmentsEnabled) {
      throw const GrpcError.failedPrecondition(
        'Форумные вложения недоступны на этом сервере',
      );
    }
  }
}
