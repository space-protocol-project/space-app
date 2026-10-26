//
//  Generated code. Do not modify.
//  source: space/v1/participant_follows.proto
//

import "package:connectrpc/connect.dart" as connect;
import "participant_follows.pb.dart" as spacev1participant_follows;

/// core.participant.follows.v1: личные подписки и лента внутри пространства.
abstract final class ParticipantFollowService {
  /// Fully-qualified name of the ParticipantFollowService service.
  static const name = 'space.v1.ParticipantFollowService';

  static const getParticipantFollowStates = connect.Spec(
    '/$name/GetParticipantFollowStates',
    connect.StreamType.unary,
    spacev1participant_follows.GetParticipantFollowStatesRequest.new,
    spacev1participant_follows.GetParticipantFollowStatesResponse.new,
  );

  static const setParticipantFollow = connect.Spec(
    '/$name/SetParticipantFollow',
    connect.StreamType.unary,
    spacev1participant_follows.SetParticipantFollowRequest.new,
    spacev1participant_follows.SetParticipantFollowResponse.new,
  );

  static const listFollowingParticipants = connect.Spec(
    '/$name/ListFollowingParticipants',
    connect.StreamType.unary,
    spacev1participant_follows.ListFollowingParticipantsRequest.new,
    spacev1participant_follows.ListFollowingParticipantsResponse.new,
  );

  static const listPersonalFeed = connect.Spec(
    '/$name/ListPersonalFeed',
    connect.StreamType.unary,
    spacev1participant_follows.ListPersonalFeedRequest.new,
    spacev1participant_follows.ListPersonalFeedResponse.new,
  );
}
