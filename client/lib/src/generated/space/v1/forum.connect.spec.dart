//
//  Generated code. Do not modify.
//  source: space/v1/forum.proto
//

import "package:connectrpc/connect.dart" as connect;
import "forum.pb.dart" as spacev1forum;

/// core.forum.v1: отдельные открытые форумные разделы с ACL канала.
abstract final class ForumService {
  /// Fully-qualified name of the ForumService service.
  static const name = 'space.v1.ForumService';

  static const reportForumContent = connect.Spec(
    '/$name/ReportForumContent',
    connect.StreamType.unary,
    spacev1forum.ReportForumContentRequest.new,
    spacev1forum.ReportForumContentResponse.new,
  );

  static const listForumReports = connect.Spec(
    '/$name/ListForumReports',
    connect.StreamType.unary,
    spacev1forum.ListForumReportsRequest.new,
    spacev1forum.ListForumReportsResponse.new,
  );

  static const resolveForumReport = connect.Spec(
    '/$name/ResolveForumReport',
    connect.StreamType.unary,
    spacev1forum.ResolveForumReportRequest.new,
    spacev1forum.ResolveForumReportResponse.new,
  );

  static const listForumThreads = connect.Spec(
    '/$name/ListForumThreads',
    connect.StreamType.unary,
    spacev1forum.ListForumThreadsRequest.new,
    spacev1forum.ListForumThreadsResponse.new,
  );

  static const getForumThread = connect.Spec(
    '/$name/GetForumThread',
    connect.StreamType.unary,
    spacev1forum.GetForumThreadRequest.new,
    spacev1forum.GetForumThreadResponse.new,
  );

  static const createForumThread = connect.Spec(
    '/$name/CreateForumThread',
    connect.StreamType.unary,
    spacev1forum.CreateForumThreadRequest.new,
    spacev1forum.CreateForumThreadResponse.new,
  );

  static const replyForumThread = connect.Spec(
    '/$name/ReplyForumThread',
    connect.StreamType.unary,
    spacev1forum.ReplyForumThreadRequest.new,
    spacev1forum.ReplyForumThreadResponse.new,
  );

  static const setForumThreadPinned = connect.Spec(
    '/$name/SetForumThreadPinned',
    connect.StreamType.unary,
    spacev1forum.SetForumThreadPinnedRequest.new,
    spacev1forum.SetForumThreadPinnedResponse.new,
  );

  static const markForumThreadRead = connect.Spec(
    '/$name/MarkForumThreadRead',
    connect.StreamType.unary,
    spacev1forum.MarkForumThreadReadRequest.new,
    spacev1forum.MarkForumThreadReadResponse.new,
  );

  static const closeForumThread = connect.Spec(
    '/$name/CloseForumThread',
    connect.StreamType.unary,
    spacev1forum.CloseForumThreadRequest.new,
    spacev1forum.CloseForumThreadResponse.new,
  );

  static const moderateForumThread = connect.Spec(
    '/$name/ModerateForumThread',
    connect.StreamType.unary,
    spacev1forum.ModerateForumThreadRequest.new,
    spacev1forum.ModerateForumThreadResponse.new,
  );

  static const moderateForumReply = connect.Spec(
    '/$name/ModerateForumReply',
    connect.StreamType.unary,
    spacev1forum.ModerateForumReplyRequest.new,
    spacev1forum.ModerateForumReplyResponse.new,
  );

  static const listForumModeration = connect.Spec(
    '/$name/ListForumModeration',
    connect.StreamType.unary,
    spacev1forum.ListForumModerationRequest.new,
    spacev1forum.ListForumModerationResponse.new,
  );
}
