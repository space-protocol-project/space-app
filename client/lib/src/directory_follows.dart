import 'package:fixnum/fixnum.dart';

import 'directory_document.dart';
import 'participant_follows_api.dart';

Future<({List<String> ids, int revision})> directoryFollowing(
  ParticipantFollowApi api,
  bool Function() active,
) async {
  final ids = <String>{}, tokens = <String>{};
  var token = '', revision = -1;
  do {
    directoryRequire(active() && tokens.add(token) && tokens.length <= 256);
    final page = await api
        .following(token)
        .timeout(const Duration(seconds: 10));
    directoryRequire(active());
    final current = page.revision.toInt();
    directoryInt(current);
    if (revision >= 0) directoryRequire(current == revision);
    revision = current;
    for (final participant in page.participants) {
      final id = participant.principalId;
      directoryRequire(
        RegExp(r'^u_[a-f0-9]{64}$').hasMatch(id) &&
            id != api.principalId &&
            ids.add(id),
      );
    }
    directoryRequire(ids.length <= 4096);
    token = directoryText(page.nextPageToken, max: 2048);
  } while (token.isNotEmpty);
  return (ids: ids.toList()..sort(), revision: revision);
}

Future<int> applyDirectoryFollowing(
  Map<String, dynamic> space,
  ParticipantFollowApi api,
  String channel,
  bool Function() active,
) async {
  directoryRequire(active() && api.principalId == space['principal_id']);
  final snapshot = await directoryFollowing(api, active);
  var revision = snapshot.revision, applied = 0;
  final existing = snapshot.ids.toSet();
  for (final id in (space['following'] as List).cast<String>()) {
    if (existing.contains(id)) continue;
    directoryRequire(active());
    final response = await api
        .set(
          SetParticipantFollowRequest(
            channelId: channel,
            principalId: id,
            following: true,
            expectedRevision: Int64(revision),
          ),
        )
        .timeout(const Duration(seconds: 10));
    directoryRequire(
      active() &&
          response.hasState() &&
          response.state.principalId == id &&
          response.state.following,
    );
    directoryRequire(response.revision > Int64(revision));
    revision = response.revision.toInt();
    applied++;
  }
  return applied;
}
