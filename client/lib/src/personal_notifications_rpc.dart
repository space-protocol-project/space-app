part of 'core.dart';

class SessionPersonalNotificationApi implements PersonalNotificationApi {
  SessionPersonalNotificationApi(this.session);
  final SpaceSession session;

  @override
  bool get supported => session.personalNotificationsSupported;
  @override
  String get principalId => session.principalId;
  @override
  List<Channel> get sections => supported
      ? session.availableChannels.where(readableNotificationSection).toList()
      : [];
  @override
  Future<void> refresh() => session.refreshChannels();

  void _requireSection(String channel) {
    if (!supported) throw const GrpcError.unimplemented();
    if (!sections.any((section) => section.id == channel)) {
      throw const GrpcError.permissionDenied('Уведомления недоступны');
    }
  }

  @override
  Future<notifications_pb.ListPersonalNotificationsResponse> list(
    notifications_pb.ListPersonalNotificationsRequest request,
  ) async {
    _requireSection(request.channelId);
    final principal = principalId;
    await session._ensureSession();
    _requirePrincipal(principal);
    _requireSection(request.channelId);
    return session.channel.unary(
      notifications_specs.PersonalNotificationService.listPersonalNotifications,
      request,
      options: session._options,
    );
  }

  @override
  Future<void> markRead(String channel, List<String> ids) => _mark(
    channel,
    notifications_pb.MarkPersonalNotificationsReadRequest(
      channelId: channel,
      ids: ids,
    ),
  );

  @override
  Future<void> markChatRead(String channel, List<String> contentIds) => _mark(
    channel,
    notifications_pb.MarkPersonalNotificationsReadRequest(
      channelId: channel,
      chatContentIds: contentIds,
    ),
  );

  Future<void> _mark(
    String channel,
    notifications_pb.MarkPersonalNotificationsReadRequest request,
  ) async {
    _requireSection(channel);
    final principal = principalId;
    await session._ensureSession();
    _requirePrincipal(principal);
    _requireSection(channel);
    await session.channel.unary(
      notifications_specs
          .PersonalNotificationService
          .markPersonalNotificationsRead,
      request,
      options: session._options,
    );
  }

  void _requirePrincipal(String expected) {
    if (principalId != expected) {
      throw const GrpcError.unauthenticated('Личность изменилась');
    }
  }
}
