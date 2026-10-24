import 'package:fixnum/fixnum.dart';

import 'core.dart' show AttachmentSession;
import 'generated/space/v1/feed.pb.dart';
import 'generated/space/v1/space.pb.dart' show Channel;

abstract interface class FeedApi {
  bool get supported;
  bool get attachmentsEnabled;
  AttachmentSession? get attachmentSession;
  List<Channel> get sections;
  Future<void> refresh();
  Future<ListFeedPostsResponse> posts(String channel, Int64 before);
  Future<GetFeedPostResponse> post(String channel, String id, Int64 after);
  Future<CreateFeedPostResponse> publish(CreateFeedPostRequest request);
  Future<CommentFeedPostResponse> comment(CommentFeedPostRequest request);
  Future<GetFeedAccessResponse> access(String channel);
  Future<UpdateFeedAccessResponse> saveAccess(UpdateFeedAccessRequest request);
  Future<ModerateFeedPostResponse> moderatePost(
    ModerateFeedPostRequest request,
  );
  Future<ModerateFeedCommentResponse> moderateComment(
    ModerateFeedCommentRequest request,
  );
  Future<void> report(ReportFeedContentRequest request);
  Future<ListFeedReportsResponse> reports(
    String channel,
    Int64 after,
    bool resolved,
  );
  Future<void> resolve(ResolveFeedReportRequest request);
  Future<ListFeedModerationResponse> log(
    String channel,
    String post,
    Int64 after,
  );
}
