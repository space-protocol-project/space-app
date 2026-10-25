import 'generated/space/v1/space.pb.dart' show Content;
import 'generated/space/v1/community_mentions.pb.dart';
import 'generated/space/v1/forum.pb.dart';

abstract interface class CommunityMentionApi {
  String get principalId;
  Future<List<MentionCandidate>> candidates(
    String channel,
    String parent,
    String query,
  );
  Future<void> markRead(
    String channel,
    List<CommunityContentReference> content,
  );
}

abstract interface class CommunityMentionSource {
  CommunityMentionApi? get communityMentions;
}

CommunityMentionApi? communityMentionsFor(Object api) =>
    api is CommunityMentionSource ? api.communityMentions : null;

abstract interface class ForumMentionWriter {
  Future<ForumThread> createMentioned(
    String channel,
    String title,
    String text,
    String key,
    List<String> attachments,
    List<CommunityMention> mentions,
  );
  Future<ReplyForumThreadResponse> replyMentioned(
    String channel,
    String parent,
    String text,
    String key,
    List<String> attachments,
    List<CommunityMention> mentions,
  );
}

abstract interface class ChatMentionWriter {
  Future<Content> sendMentioned(
    String channel,
    String text,
    String key,
    List<String> attachments,
    String replyTo,
    List<CommunityMention> mentions,
  );
  Future<Content> updateMentioned(
    Content message,
    String text,
    List<CommunityMention> mentions,
  );
}
