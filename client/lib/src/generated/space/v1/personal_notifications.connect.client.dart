//
//  Generated code. Do not modify.
//  source: space/v1/personal_notifications.proto
//

import "package:connectrpc/connect.dart" as connect;

import "personal_notifications.pb.dart" as spacev1personal_notifications;
import "personal_notifications.connect.spec.dart" as specs;

/// core.personal.notifications.v1: только записи текущей личности в выбранном разделе.
extension type PersonalNotificationServiceClient(connect.Transport _transport) {
  Future<spacev1personal_notifications.ListPersonalNotificationsResponse>
  listPersonalNotifications(
    spacev1personal_notifications.ListPersonalNotificationsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PersonalNotificationService.listPersonalNotifications,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1personal_notifications.MarkPersonalNotificationsReadResponse>
  markPersonalNotificationsRead(
    spacev1personal_notifications.MarkPersonalNotificationsReadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PersonalNotificationService.markPersonalNotificationsRead,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
