import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/community_reactions_api.dart';

CommunityContentReference reactionRef(String id, {int kind = 1}) =>
    CommunityContentReference(kind: CommunitySearchKind.valueOf(kind), id: id);

class FakeCommunityReactions implements CommunityReactionApi {
  @override
  String scopeId = 'fake';
  final values = <String, CommunityReactionState>{};
  final requests = <SetCommunityReactionRequest>[];
  final pages = <List<CommunityContentReference>>[];
  final applied = <String, SetCommunityReactionResponse>{};
  Future<ListCommunityReactionsResponse> Function(
    List<CommunityContentReference> refs,
  )?
  onList;
  Future<SetCommunityReactionResponse> Function(SetCommunityReactionRequest)?
  onSet;

  CommunityReactionState value(CommunityContentReference ref) =>
      values.putIfAbsent(
        communityReactionKey(ref),
        () => CommunityReactionState(content: ref, canReact: true),
      );

  @override
  Future<ListCommunityReactionsResponse> list(
    String channel,
    List<CommunityContentReference> contents,
  ) async {
    pages.add(contents);
    if (onList != null) return onList!(contents);
    return ListCommunityReactionsResponse(states: contents.map(value));
  }

  @override
  Future<SetCommunityReactionResponse> set(
    SetCommunityReactionRequest request,
  ) async {
    requests.add(request.deepCopy());
    if (onSet != null) return onSet!(request);
    return apply(request);
  }

  SetCommunityReactionResponse apply(SetCommunityReactionRequest request) {
    final previous = applied[request.idempotencyKey];
    if (previous != null) return previous.deepCopy();
    final key = communityReactionKey(request.content);
    final state = value(request.content).deepCopy();
    if (state.revision != request.expectedRevision) {
      throw const GrpcError.aborted();
    }
    final index = state.reactions.indexWhere((r) => r.emoji == request.emoji);
    if (index >= 0) state.reactions.removeAt(index);
    if (request.active) {
      state.reactions.add(
        CommunityReaction(
          emoji: request.emoji,
          count: Int64.ONE,
          selected: true,
        ),
      );
    }
    state.revision += Int64.ONE;
    values[key] = state;
    final result = SetCommunityReactionResponse(
      state: state.deepCopy(),
      idempotencyKey: request.idempotencyKey,
      appliedRevision: state.revision,
    );
    applied[request.idempotencyKey] = result.deepCopy();
    return result;
  }
}
