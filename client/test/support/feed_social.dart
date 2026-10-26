import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:space_client/src/core.dart' show AttachmentSession;
import 'package:space_client/src/feed_api.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';

class SocialFeed implements FeedApi {
  final submitted = ValueNotifier('');
  final root = FeedPost(id: 'post', channelId: 'feed', authorId: 'author', authorName: 'Мария', text: 'Планы нашего сообщества', sequence: Int64.ONE);
  final first = FeedComment(id: 'comment', postId: 'post', authorId: 'author', authorName: 'Илья', text: 'Давайте обсудим здесь', sequence: Int64.ONE);
  @override
  bool get supported => true;
  @override
  bool get socialSupported => true;
  @override
  bool get attachmentsEnabled => false;
  @override
  AttachmentSession? get attachmentSession => null;
  @override
  List<Channel> get sections => [Channel(id: 'feed', title: 'Сообщество', views: [View(type: 'feed')], permissions: ChannelPermissions(visible: true, read: true))];
  @override
  Future<void> refresh() async {}
  @override
  Future<ListFeedPostsResponse> posts(String channel, Int64 before) async => ListFeedPostsResponse(posts: [root.deepCopy()], permissions: FeedPermissions(publish: true, comment: true));
  @override
  Future<GetFeedPostResponse> post(String channel, String id, Int64 after) async => GetFeedPostResponse(post: root.deepCopy(), comments: [first.deepCopy()], permissions: FeedPermissions(publish: true, comment: true));
  @override
  Future<CreateFeedPostResponse> publish(CreateFeedPostRequest request) async {
    submitted.value = 'repost:${request.repostOf}';
    return CreateFeedPostResponse(post: root.deepCopy());
  }
  @override
  Future<CommentFeedPostResponse> comment(CommentFeedPostRequest request) async {
    submitted.value = 'reply:${request.replyToCommentId}';
    return CommentFeedPostResponse(post: root.deepCopy(), comment: first.deepCopy());
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
