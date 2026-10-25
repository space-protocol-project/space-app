import 'package:fixnum/fixnum.dart';
import 'package:space_client/src/community_overview.dart';
import 'package:space_client/src/generated/space/v1/community_overview.pb.dart';
import 'package:space_client/src/generated/space/v1/community_search.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';

import '../../integration_test/fixtures/gallery_session.dart';

class SiteGallerySession extends GallerySession
    implements CommunityOverviewSource {
  SiteGallerySession() {
    availableChannels.addAll(communityOverview.sections);
  }

  @override
  final CommunityOverviewApi communityOverview = _GalleryCommunities();
}

class _GalleryCommunities implements CommunityOverviewApi {
  @override
  bool get supported => true;

  @override
  final sections = [
    _section('forum', 'Обсуждения', 'forum'),
    _section('feed', 'Новости сообщества', 'feed'),
  ];

  @override
  Future<void> refresh() async {}

  @override
  Future<GetCommunityOverviewResponse> overview(String channel) async =>
      GetCommunityOverviewResponse(
        recent: [
          if (channel == 'forum')
            _entry('meeting', 'Куда отправимся на выходных?', false),
          if (channel == 'feed')
            _entry('photos', 'Фотографии с нашей последней встречи', true),
        ],
      );
}

Channel _section(String id, String title, String kind) => Channel(
  id: id,
  title: title,
  views: [View(id: kind, type: kind)],
  permissions: ChannelPermissions(visible: true, read: true, write: true),
);

CommunityOverviewEntry _entry(String id, String title, bool feed) =>
    CommunityOverviewEntry(
      content: CommunitySearchResult(
        id: id,
        parentId: id,
        title: title,
        snippet: feed
            ? 'Спасибо всем за отличный день вместе!'
            : 'Обсуждаем идеи и выбираем маршрут.',
        authorId: 'Мария',
        authorName: 'Мария',
        kind: feed
            ? CommunitySearchKind.COMMUNITY_SEARCH_KIND_FEED_POST
            : CommunitySearchKind.COMMUNITY_SEARCH_KIND_FORUM_THREAD,
        createdAtUnix: Int64(
          DateTime.utc(2026, 10, 25, 12).millisecondsSinceEpoch ~/ 1000,
        ),
      ),
      unreadCount: Int64(feed ? 1 : 3),
      readStateSupported: true,
    );
