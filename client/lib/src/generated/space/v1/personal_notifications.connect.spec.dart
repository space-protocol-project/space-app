//
//  Generated code. Do not modify.
//  source: space/v1/personal_notifications.proto
//

import "package:connectrpc/connect.dart" as connect;

import "personal_notifications.pb.dart" as spacev1personal_notifications;

/// core.personal.notifications.v1: только записи текущей личности в выбранном разделе.
abstract final class PersonalNotificationService {
  /// Fully-qualified name of the PersonalNotificationService service.
  static const name = 'space.v1.PersonalNotificationService';

  static const listPersonalNotifications = connect.Spec(
    '/$name/ListPersonalNotifications',
    connect.StreamType.unary,
    spacev1personal_notifications.ListPersonalNotificationsRequest.new,
    spacev1personal_notifications.ListPersonalNotificationsResponse.new,
  );

  static const markPersonalNotificationsRead = connect.Spec(
    '/$name/MarkPersonalNotificationsRead',
    connect.StreamType.unary,
    spacev1personal_notifications.MarkPersonalNotificationsReadRequest.new,
    spacev1personal_notifications.MarkPersonalNotificationsReadResponse.new,
  );
}
