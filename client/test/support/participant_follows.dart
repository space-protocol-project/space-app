import 'package:fixnum/fixnum.dart';
import 'package:space_client/src/participant_follows_api.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';

class FakeFollows implements ParticipantFollowApi {
  @override
  String scopeId = 'space|me|device';
  @override
  String principalId = 'me';
  int revision = 0;
  final selected = <String>{};
  final requests = <SetParticipantFollowRequest>[];
  final batches = <List<String>>[];
  Future<ListPersonalFeedResponse> Function(String)? load;
  Future<GetParticipantFollowStatesResponse> Function()? readStates;
  Object? error;
  @override
  Future<GetParticipantFollowStatesResponse> states(
    String channel,
    List<String> ids,
  ) async {
    batches.add(ids);
    if (readStates != null) return readStates!();
    return GetParticipantFollowStatesResponse(
      revision: Int64(revision),
      states: [
        for (final id in ids)
          ParticipantFollowState(
            principalId: id,
            following: selected.contains(id),
          ),
      ],
    );
  }

  @override
  Future<SetParticipantFollowResponse> set(
    SetParticipantFollowRequest request,
  ) async {
    requests.add(request.deepCopy());
    if (error != null) throw error!;
    if (request.following) {
      selected.add(request.principalId);
    } else {
      selected.remove(request.principalId);
    }
    return SetParticipantFollowResponse(
      state: ParticipantFollowState(
        principalId: request.principalId,
        following: request.following,
      ),
      revision: Int64(++revision),
    );
  }

  @override
  Future<ListFollowingParticipantsResponse> following(String token) async =>
      ListFollowingParticipantsResponse(
        participants: [
          for (final id in selected.toList()..sort())
            FollowingParticipant(
              principalId: id,
              available: true,
              displayName: id,
            ),
        ],
        revision: Int64(revision),
      );
  @override
  Future<ListPersonalFeedResponse> feed(String token) async {
    if (error != null) throw error!;
    return load != null
        ? load!(token)
        : ListPersonalFeedResponse(
            entries: [entry('b', 2), entry('a', 1)],
            revision: Int64(revision),
          );
  }
}

PersonalFeedEntry entry(String id, int time, {String channel = 'first'}) =>
    PersonalFeedEntry(
      channelTitle: channel,
      post: FeedPost(
        id: id,
        channelId: channel,
        authorId: 'author',
        authorName: 'Автор',
        text: 'Публикация $id',
        createdAtUnix: Int64(time),
        sequence: Int64(time),
        revision: Int64.ONE,
      ),
    );
