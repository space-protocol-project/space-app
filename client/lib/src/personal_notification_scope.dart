import 'dart:convert';

import 'chat_controller.dart';
import 'personal_notifications_api.dart';
import 'personal_notification_target.dart';
import 'generated/space/v1/personal_notifications.pb.dart';
import 'generated/space/v1/space.pb.dart' show Channel;

String notificationView(NotificationTargetKind kind) => switch (kind) {
  NotificationTargetKind.NOTIFICATION_TARGET_KIND_CHAT_MESSAGE => 'chat',
  NotificationTargetKind.NOTIFICATION_TARGET_KIND_FORUM_THREAD ||
  NotificationTargetKind.NOTIFICATION_TARGET_KIND_FORUM_REPLY => 'forum',
  NotificationTargetKind.NOTIFICATION_TARGET_KIND_FEED_POST ||
  NotificationTargetKind.NOTIFICATION_TARGET_KIND_FEED_COMMENT => 'feed',
  _ => '',
};

class PersonalNotificationScope {
  PersonalNotificationScope({
    required this.origin,
    required this.chat,
    required this.api,
    required this.channel,
  }) : principal = api.principalId,
       spaceTitle = chat.spaceTitle;
  final String origin, principal, spaceTitle;
  final ChatController chat;
  final PersonalNotificationApi api;
  final Channel channel;
  String get key => jsonEncode([origin, principal, channel.id]);
  String get label => '$spaceTitle · ${channel.title}';

  bool sameAs(PersonalNotificationScope other) =>
      identical(api, other.api) &&
      identical(chat, other.chat) &&
      principal == other.principal &&
      spaceTitle == other.spaceTitle &&
      channel.title == other.channel.title &&
      channel.permissions == other.channel.permissions &&
      channel.views.map((v) => v.type).join(',') ==
          other.channel.views.map((v) => v.type).join(',');

  bool valid() =>
      chat.connected &&
      !chat.reconnecting &&
      !chat.accessRemoved &&
      chat.knownOrigin == origin &&
      chat.principalId == principal &&
      identical(chat.personalNotifications, api) &&
      api.supported &&
      api.principalId == principal &&
      api.sections.any(_sameAccess);

  bool _sameAccess(Channel current) =>
      current.id == channel.id &&
      readableNotificationSection(current) &&
      current.permissions == channel.permissions &&
      current.views.map((v) => v.type).join(',') ==
          channel.views.map((v) => v.type).join(',');

  bool accepts(PersonalNotification notice) =>
      notice.channelId == channel.id &&
      channel.views.any(
        (view) => view.type == notificationView(notice.targetKind),
      );

  PersonalNotificationTarget target(PersonalNotification notice) =>
      PersonalNotificationTarget(
        origin,
        principal,
        channel.id,
        notice.sequence.toInt(),
        notice.id,
      );
}
