//
//  Generated code. Do not modify.
//  source: space/v1/feed.proto
//

import "package:connectrpc/connect.dart" as connect;
import "feed.pb.dart" as spacev1feed;

/// core.feed.v1: экспериментальная лента публикаций по ADR-046.
abstract final class FeedService {
  /// Fully-qualified name of the FeedService service.
  static const name = 'space.v1.FeedService';

  static const listFeedPosts = connect.Spec(
    '/$name/ListFeedPosts',
    connect.StreamType.unary,
    spacev1feed.ListFeedPostsRequest.new,
    spacev1feed.ListFeedPostsResponse.new,
  );

  static const getFeedPost = connect.Spec(
    '/$name/GetFeedPost',
    connect.StreamType.unary,
    spacev1feed.GetFeedPostRequest.new,
    spacev1feed.GetFeedPostResponse.new,
  );

  static const createFeedPost = connect.Spec(
    '/$name/CreateFeedPost',
    connect.StreamType.unary,
    spacev1feed.CreateFeedPostRequest.new,
    spacev1feed.CreateFeedPostResponse.new,
  );

  static const commentFeedPost = connect.Spec(
    '/$name/CommentFeedPost',
    connect.StreamType.unary,
    spacev1feed.CommentFeedPostRequest.new,
    spacev1feed.CommentFeedPostResponse.new,
  );

  static const getFeedAccess = connect.Spec(
    '/$name/GetFeedAccess',
    connect.StreamType.unary,
    spacev1feed.GetFeedAccessRequest.new,
    spacev1feed.GetFeedAccessResponse.new,
  );

  static const updateFeedAccess = connect.Spec(
    '/$name/UpdateFeedAccess',
    connect.StreamType.unary,
    spacev1feed.UpdateFeedAccessRequest.new,
    spacev1feed.UpdateFeedAccessResponse.new,
  );

  static const moderateFeedPost = connect.Spec(
    '/$name/ModerateFeedPost',
    connect.StreamType.unary,
    spacev1feed.ModerateFeedPostRequest.new,
    spacev1feed.ModerateFeedPostResponse.new,
  );

  static const moderateFeedComment = connect.Spec(
    '/$name/ModerateFeedComment',
    connect.StreamType.unary,
    spacev1feed.ModerateFeedCommentRequest.new,
    spacev1feed.ModerateFeedCommentResponse.new,
  );

  static const listFeedModeration = connect.Spec(
    '/$name/ListFeedModeration',
    connect.StreamType.unary,
    spacev1feed.ListFeedModerationRequest.new,
    spacev1feed.ListFeedModerationResponse.new,
  );

  static const reportFeedContent = connect.Spec(
    '/$name/ReportFeedContent',
    connect.StreamType.unary,
    spacev1feed.ReportFeedContentRequest.new,
    spacev1feed.ReportFeedContentResponse.new,
  );

  static const listFeedReports = connect.Spec(
    '/$name/ListFeedReports',
    connect.StreamType.unary,
    spacev1feed.ListFeedReportsRequest.new,
    spacev1feed.ListFeedReportsResponse.new,
  );

  static const resolveFeedReport = connect.Spec(
    '/$name/ResolveFeedReport',
    connect.StreamType.unary,
    spacev1feed.ResolveFeedReportRequest.new,
    spacev1feed.ResolveFeedReportResponse.new,
  );

  /// core.feed.read.v1: персональная монотонная отметка, общая для устройств.
  static const markFeedPostRead = connect.Spec(
    '/$name/MarkFeedPostRead',
    connect.StreamType.unary,
    spacev1feed.MarkFeedPostReadRequest.new,
    spacev1feed.MarkFeedPostReadResponse.new,
  );
}
