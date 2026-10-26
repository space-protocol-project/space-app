import 'generated/space/v1/participant_follows.pb.dart';
export 'generated/space/v1/participant_follows.pb.dart';

abstract interface class ParticipantFollowApi {
  String get scopeId;
  String get principalId;
  Future<GetParticipantFollowStatesResponse> states(String channel, List<String> ids);
  Future<SetParticipantFollowResponse> set(SetParticipantFollowRequest request);
  Future<ListFollowingParticipantsResponse> following(String token);
  Future<ListPersonalFeedResponse> feed(String token);
}
