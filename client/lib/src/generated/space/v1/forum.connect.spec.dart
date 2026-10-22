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

  static const closeForumThread = connect.Spec(
    '/$name/CloseForumThread',
    connect.StreamType.unary,
    spacev1forum.CloseForumThreadRequest.new,
    spacev1forum.CloseForumThreadResponse.new,
  );
}
