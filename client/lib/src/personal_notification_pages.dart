import 'generated/space/v1/personal_notifications.pb.dart';
import 'personal_notification_scope.dart';

void validateNotificationPage(
  PersonalNotificationScope scope,
  ListPersonalNotificationsRequest request,
  ListPersonalNotificationsResponse page,
) {
  final after = request.afterSequence.toInt(),
      through = page.throughSequence.toInt(),
      next = page.nextSequence.toInt();
  if (through < after ||
      next < after ||
      next > through ||
      page.notifications.length > (request.limit > 0 ? request.limit : 50)) {
    throw const FormatException('Неверные границы уведомлений');
  }
  if (request.throughSequence > 0 &&
      request.throughSequence != page.throughSequence) {
    throw const FormatException('Изменилась граница страницы');
  }
  var previous = after;
  final ids = <String>{};
  for (final notice in page.notifications) {
    if (!ids.add(notice.id) ||
        !_validNotification(scope, notice) ||
        notice.sequence.toInt() <= previous ||
        notice.sequence.toInt() > through) {
      throw const FormatException('Некорректная запись уведомления');
    }
    previous = notice.sequence.toInt();
  }
  _validatePageEnd(request, page, previous);
}

void _validatePageEnd(
  ListPersonalNotificationsRequest request,
  ListPersonalNotificationsResponse page,
  int last,
) {
  if (request.baselineOnly && (page.notifications.isNotEmpty || page.hasMore)) {
    throw const FormatException('Начальная граница содержит записи');
  }
  if (page.hasMore) {
    if (page.notifications.isEmpty ||
        page.nextSequence.toInt() != last ||
        page.nextSequence >= page.throughSequence) {
      throw const FormatException('Страница не продвигает курсор');
    }
  } else if (page.nextSequence != page.throughSequence) {
    throw const FormatException('Незавершённая страница уведомлений');
  }
}

bool _validNotification(
  PersonalNotificationScope scope,
  PersonalNotification n,
) =>
    scope.accepts(n) &&
    [
      n.id,
      n.contentId,
      n.parentId,
      n.authorId,
    ].every((part) => part.isNotEmpty && part.length <= 128) &&
    _validTargetSequence(n) &&
    n.reasons > 0 &&
    n.reasons <= 3 &&
    n.unreadReasons >= 0 &&
    (n.unreadReasons & ~n.reasons) == 0 &&
    n.snippet.runes.length <= 240 &&
    n.title.length <= 320;

bool _validTargetSequence(PersonalNotification n) {
  final root =
      n.targetKind ==
          NotificationTargetKind.NOTIFICATION_TARGET_KIND_FORUM_THREAD ||
      n.targetKind == NotificationTargetKind.NOTIFICATION_TARGET_KIND_FEED_POST;
  return n.targetSequence >= (root ? 0 : 1) &&
      n.targetSequence.toInt() < 9223372036854775807;
}
