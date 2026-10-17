part of 'chat_controller.dart';

extension _ChatReplies on ChatController {
  void _requireReplySupport(LiveSession session, PendingMessage entry) {
    if (entry.replyTo.isEmpty) return;
    if (session is! ReplyMessageSession ||
        !(session as ReplyMessageSession).repliesSupported) {
      throw const GrpcError.failedPrecondition(
        'Обновите сервер для отправки ответа',
      );
    }
  }
}
