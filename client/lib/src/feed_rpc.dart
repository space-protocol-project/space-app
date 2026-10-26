part of 'core.dart';

class SessionFeedApi
    implements
        FeedApi,
        CommunityMentionSource,
        CommunitySearchSource,
        FeedReadApi,
        CommunityReactionSource {
  SessionFeedApi(this.session);
  final SpaceSession session;
  late final _reactions = SessionCommunityReactionApi(session);
  @override
  CommunityReactionApi? get communityReactions =>
      session.communityReactionsSupported ? _reactions : null;
  late final _mentions = SessionCommunityMentionApi(session);
  @override
  CommunityMentionApi? get communityMentions =>
      session.communityMentionsSupported ? _mentions : null;
  @override
  CommunitySearchApi? get communitySearch => session.communitySearchSupported
      ? SessionCommunitySearchApi(session)
      : null;
  @override
  bool get supported => session.feedSupported;
  @override
  bool get readSupported => session.feedReadSupported;
  @override
  Future<feed.FeedPost> markRead(
    String channel,
    String post,
    Int64 through,
  ) async {
    if (!readSupported) throw const GrpcError.unimplemented();
    final response = await _call(
      feed_specs.FeedService.markFeedPostRead,
      feed.MarkFeedPostReadRequest(
        channelId: channel,
        postId: post,
        throughSequence: through,
      ),
    );
    return response.post;
  }

  @override
  bool get attachmentsEnabled => supported && session.attachmentsEnabled;
  @override
  AttachmentSession get attachmentSession => session;
  @override
  List<Channel> get sections => session.availableChannels
      .where(
        (c) =>
            !c.archived &&
            c.permissions.read &&
            c.views.any((v) => v.type == 'feed'),
      )
      .toList(growable: false);
  @override
  Future<void> refresh() => session.refreshChannels();

  Future<O> _call<I extends GeneratedMessage, O extends GeneratedMessage>(
    connect.Spec<I, O> spec,
    I request,
  ) async {
    if (!supported) throw const GrpcError.unimplemented();
    await session._ensureSession();
    return session.channel.unary(spec, request, options: session._options);
  }

  @override
  Future<feed.ListFeedPostsResponse> posts(String channel, Int64 before) =>
      _call(
        feed_specs.FeedService.listFeedPosts,
        feed.ListFeedPostsRequest(channelId: channel, beforeSequence: before),
      );
  @override
  Future<feed.GetFeedPostResponse> post(
    String channel,
    String id,
    Int64 after,
  ) => _call(
    feed_specs.FeedService.getFeedPost,
    feed.GetFeedPostRequest(
      channelId: channel,
      postId: id,
      afterSequence: after,
    ),
  );
  @override
  Future<feed.CreateFeedPostResponse> publish(
    feed.CreateFeedPostRequest request,
  ) => _call(feed_specs.FeedService.createFeedPost, request);
  @override
  Future<feed.CommentFeedPostResponse> comment(
    feed.CommentFeedPostRequest request,
  ) => _call(feed_specs.FeedService.commentFeedPost, request);
  @override
  Future<feed.GetFeedAccessResponse> access(String channel) => _call(
    feed_specs.FeedService.getFeedAccess,
    feed.GetFeedAccessRequest(channelId: channel),
  );
  @override
  Future<feed.UpdateFeedAccessResponse> saveAccess(
    feed.UpdateFeedAccessRequest request,
  ) => _call(feed_specs.FeedService.updateFeedAccess, request);
  @override
  Future<feed.ModerateFeedPostResponse> moderatePost(
    feed.ModerateFeedPostRequest request,
  ) => _call(feed_specs.FeedService.moderateFeedPost, request);
  @override
  Future<feed.ModerateFeedCommentResponse> moderateComment(
    feed.ModerateFeedCommentRequest request,
  ) => _call(feed_specs.FeedService.moderateFeedComment, request);
  @override
  Future<void> report(feed.ReportFeedContentRequest request) async {
    await _call(feed_specs.FeedService.reportFeedContent, request);
  }

  @override
  Future<feed.ListFeedReportsResponse> reports(
    String channel,
    Int64 after,
    bool resolved,
  ) => _call(
    feed_specs.FeedService.listFeedReports,
    feed.ListFeedReportsRequest(
      channelId: channel,
      afterId: after,
      resolved: resolved,
    ),
  );
  @override
  Future<void> resolve(feed.ResolveFeedReportRequest request) async {
    await _call(feed_specs.FeedService.resolveFeedReport, request);
  }

  @override
  Future<feed.ListFeedModerationResponse> log(
    String channel,
    String post,
    Int64 after,
  ) => _call(
    feed_specs.FeedService.listFeedModeration,
    feed.ListFeedModerationRequest(
      channelId: channel,
      postId: post,
      afterId: after,
    ),
  );
}
