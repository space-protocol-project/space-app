import 'package:fixnum/fixnum.dart';

import 'core.dart' show AttachmentSession;

import 'generated/space/v1/forum.pb.dart';
import 'generated/space/v1/space.pb.dart' show Channel;

abstract interface class ForumApi {
  bool get supported;
  List<Channel> get sections;
  Future<void> refresh();
  Future<ListForumThreadsResponse> threads(String channel, Int64 after);
  Future<GetForumThreadResponse> thread(String channel, String id, Int64 after);
  Future<ForumThread> create(
    String channel,
    String title,
    String text,
    String key, [
    List<String> attachments = const [],
  ]);
  Future<ReplyForumThreadResponse> reply(
    String channel,
    String id,
    String text,
    String key, [
    List<String> attachments = const [],
  ]);
  Future<ForumThread> closeTopic(String channel, String id, Int64 revision);
}

abstract interface class ForumMedia {
  AttachmentSession? get attachmentSession;
  bool get attachmentsEnabled;
}

abstract interface class ForumNavigation {
  bool get navigationSupported;
  Future<ListForumThreadsResponse> navigationPage(
    String channel,
    Int64 after,
    bool afterPinned,
  );
  Future<ForumThread> pinTopic(
    String channel,
    String id,
    bool pinned,
    Int64 revision,
  );
  Future<ForumThread> markRead(String channel, String id, Int64 through);
}
