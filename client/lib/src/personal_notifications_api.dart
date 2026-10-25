import 'generated/space/v1/personal_notifications.pb.dart';
import 'generated/space/v1/space.pb.dart' show Channel;

abstract interface class PersonalNotificationApi {
  bool get supported;
  String get principalId;
  List<Channel> get sections;
  Future<void> refresh();
  Future<ListPersonalNotificationsResponse> list(
    ListPersonalNotificationsRequest request,
  );
  Future<void> markRead(String channel, List<String> ids);
  Future<void> markChatRead(String channel, List<String> contentIds);
}

abstract interface class PersonalNotificationSource {
  PersonalNotificationApi? get personalNotifications;
}

bool readableNotificationSection(Channel channel) =>
    !channel.archived &&
    channel.permissions.visible &&
    channel.permissions.read &&
    channel.mlsGroupId.isEmpty &&
    channel.views.any(
      (view) => const ['chat', 'forum', 'feed'].contains(view.type),
    );
