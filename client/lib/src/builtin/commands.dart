import 'package:protobuf/protobuf.dart';

import '../generated/space/v1/space.pb.dart';
import '../generated/space/v1/forum.pb.dart';
import '../generated/space/v1/feed.pb.dart';

const commandPlugins = <String, String>{
  'space.v1.CreateContentRequest': 'space.chat',
  'space.v1.UpdateContentRequest': 'space.chat',
  'space.v1.DeleteContentRequest': 'space.chat',
  'space.v1.ApplyContentMutationRequest': 'space.chat',
  'space.v1.SetReactionRequest': 'space.chat',
  'space.v1.PublishMlsRequest': 'space.chat',
  'space.v1.JoinVoiceRoomRequest': 'space.rooms',
  'space.v1.UpdateVoiceRoomRequest': 'space.rooms',
  'space.v1.LeaveVoiceRoomRequest': 'space.rooms',
  'space.v1.ReportForumContentRequest': 'space.discussions',
  'space.v1.ResolveForumReportRequest': 'space.discussions',
  'space.v1.CreateForumThreadRequest': 'space.discussions',
  'space.v1.ReplyForumThreadRequest': 'space.discussions',
  'space.v1.SetForumThreadPinnedRequest': 'space.discussions',
  'space.v1.MarkForumThreadReadRequest': 'space.discussions',
  'space.v1.CloseForumThreadRequest': 'space.discussions',
  'space.v1.ModerateForumThreadRequest': 'space.discussions',
  'space.v1.ModerateForumReplyRequest': 'space.discussions',
  'space.v1.CreateFeedPostRequest': 'space.feed',
  'space.v1.CommentFeedPostRequest': 'space.feed',
  'space.v1.UpdateFeedAccessRequest': 'space.feed',
  'space.v1.ModerateFeedPostRequest': 'space.feed',
  'space.v1.ModerateFeedCommentRequest': 'space.feed',
  'space.v1.ReportFeedContentRequest': 'space.feed',
  'space.v1.ResolveFeedReportRequest': 'space.feed',
  'space.v1.MarkFeedPostReadRequest': 'space.feed',
};
GeneratedMessage mutationAction(GeneratedMessage message) => switch (message) {
  ApplyContentMutationRequest(:final update) when message.hasUpdate() => update,
  ApplyContentMutationRequest(:final delete) when message.hasDelete() => delete,
  ApplyContentMutationRequest(:final reaction) when message.hasReaction() =>
    reaction,
  _ => message,
};
String commandChannel(GeneratedMessage message) {
  final value = mutationAction(message).getField(1);
  return value is String ? value : '';
}

bool retryableCommand(GeneratedMessage message) =>
    switch (mutationAction(message)) {
      CreateContentRequest(:final idempotencyKey) => idempotencyKey.isNotEmpty,
      UpdateContentRequest(:final idempotencyKey) => idempotencyKey.isNotEmpty,
      DeleteContentRequest(:final idempotencyKey) => idempotencyKey.isNotEmpty,
      SetReactionRequest(:final idempotencyKey) => idempotencyKey.isNotEmpty,
      PublishMlsRequest(:final requestId) => requestId.length == 16,
      _ => communityRetry(message),
    };
bool communityRetry(GeneratedMessage message) => switch (message) {
  CreateForumThreadRequest(:final idempotencyKey) => idempotencyKey.isNotEmpty,
  ReplyForumThreadRequest(:final idempotencyKey) => idempotencyKey.isNotEmpty,
  CreateFeedPostRequest(:final idempotencyKey) => idempotencyKey.isNotEmpty,
  CommentFeedPostRequest(:final idempotencyKey) => idempotencyKey.isNotEmpty,
  _ => false,
};
