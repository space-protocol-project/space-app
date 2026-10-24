import 'generated/space/v1/community_overview.pb.dart';
import 'generated/space/v1/space.pb.dart' show Channel;

bool readableCommunity(Channel channel) =>
    !channel.archived &&
    channel.permissions.visible &&
    channel.permissions.read &&
    channel.mlsGroupId.isEmpty &&
    channel.views.any((view) => view.type == 'forum' || view.type == 'feed');

abstract interface class CommunityOverviewApi {
  bool get supported;
  List<Channel> get sections;
  Future<void> refresh();
  Future<GetCommunityOverviewResponse> overview(String channel);
}

abstract interface class CommunityOverviewSource {
  CommunityOverviewApi get communityOverview;
}

enum DashboardDestination { forum, feed, forumReports, feedReports }

class DashboardCommunityTarget {
  const DashboardCommunityTarget({
    required this.origin,
    required this.channel,
    required this.destination,
    this.id = '',
    this.replySequence = 0,
  });
  final String origin, channel, id;
  final DashboardDestination destination;
  final int replySequence;
}

class DashboardCommunitySection {
  const DashboardCommunitySection({
    required this.origin,
    required this.spaceTitle,
    required this.channel,
    required this.overview,
  });
  final String origin, spaceTitle;
  final Channel channel;
  final GetCommunityOverviewResponse overview;
  bool get forum => channel.views.any((view) => view.type == 'forum');

  DashboardCommunityTarget target({
    String id = '',
    int replySequence = 0,
    bool reports = false,
  }) => DashboardCommunityTarget(
    origin: origin,
    channel: channel.id,
    id: id,
    replySequence: replySequence,
    destination: switch ((forum, reports)) {
      (true, false) => DashboardDestination.forum,
      (false, false) => DashboardDestination.feed,
      (true, true) => DashboardDestination.forumReports,
      (false, true) => DashboardDestination.feedReports,
    },
  );
}
