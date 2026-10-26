//
//  Generated code. Do not modify.
//  source: space/v1/participant_follows.proto
//

import "package:connectrpc/connect.dart" as connect;
import "participant_follows.pb.dart" as spacev1participant_follows;
import "participant_follows.connect.spec.dart" as specs;

/// core.participant.follows.v1: личные подписки и лента внутри пространства.
extension type ParticipantFollowServiceClient (connect.Transport _transport) {
  Future<spacev1participant_follows.GetParticipantFollowStatesResponse> getParticipantFollowStates(
    spacev1participant_follows.GetParticipantFollowStatesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ParticipantFollowService.getParticipantFollowStates,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1participant_follows.SetParticipantFollowResponse> setParticipantFollow(
    spacev1participant_follows.SetParticipantFollowRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ParticipantFollowService.setParticipantFollow,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1participant_follows.ListFollowingParticipantsResponse> listFollowingParticipants(
    spacev1participant_follows.ListFollowingParticipantsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ParticipantFollowService.listFollowingParticipants,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1participant_follows.ListPersonalFeedResponse> listPersonalFeed(
    spacev1participant_follows.ListPersonalFeedRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ParticipantFollowService.listPersonalFeed,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
