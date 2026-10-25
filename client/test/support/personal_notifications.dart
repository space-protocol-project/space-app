import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/personal_notifications.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' show Channel;
import 'package:space_client/src/personal_notifications_api.dart';
import 'package:space_client/src/server_workspaces.dart';

import '../channels_test.dart'
    show ChannelVault, MemoryHistory, MemoryPositions, chat;
import '../dashboard_workspaces_test.dart' show DashboardSession;
import 'chat_outbox.dart';

PersonalNotification personalNotice(
  int sequence, {
  String channel = 'general',
  NotificationTargetKind kind =
      NotificationTargetKind.NOTIFICATION_TARGET_KIND_CHAT_MESSAGE,
}) => PersonalNotification(
  id: 'pn_$sequence',
  sequence: Int64(sequence),
  channelId: channel,
  targetKind: kind,
  contentId: 'content-$sequence',
  parentId: 'parent-$sequence',
  targetSequence: Int64(sequence),
  authorId: 'other',
  authorName: 'Мария',
  title: 'Тема $sequence',
  snippet: 'Запись $sequence',
  reasons: 1,
  unreadReasons: 1,
);

class PersonalTestSession extends DashboardSession
    implements PersonalNotificationSource {
  PersonalTestSession() : super('Пространство') {
    availableChannels = [chat('general')];
  }
  String principal = 'u_test';
  @override
  String get principalId => principal;
  late final notifications = PersonalTestApi(this);
  @override
  PersonalNotificationApi? get personalNotifications =>
      notifications.supported ? notifications : null;
}

class PersonalTestApi implements PersonalNotificationApi {
  PersonalTestApi(this.session);
  final PersonalTestSession session;
  @override
  bool supported = true;
  @override
  String get principalId => session.principalId;
  @override
  List<Channel> get sections =>
      session.availableChannels.where(readableNotificationSection).toList();
  final data = <String, List<PersonalNotification>>{};
  final watermarks = <(String, String), int>{};
  List<PersonalNotification> get records =>
      data.putIfAbsent(principalId, () => []);
  final requests = <ListPersonalNotificationsRequest>[];
  final readIds = <List<String>>[], chatIds = <List<String>>[];
  Completer<void>? listGate;
  GrpcError? listError, markError;
  ListPersonalNotificationsResponse Function(ListPersonalNotificationsResponse)?
  alter;
  @override
  Future<void> refresh() async {}

  void add(PersonalNotification notice) {
    records.add(notice);
    watermarks[(principalId, notice.channelId)] = notice.sequence.toInt();
  }

  @override
  Future<ListPersonalNotificationsResponse> list(
    ListPersonalNotificationsRequest request,
  ) async {
    requests.add(request.deepCopy());
    final saved = records.map((n) => n.deepCopy()).toList();
    final latest = watermarks[(principalId, request.channelId)] ?? 0;
    await listGate?.future;
    if (listError != null) throw listError!;
    final through = request.throughSequence > 0
        ? request.throughSequence.toInt()
        : latest;
    if (request.afterSequence.toInt() > through || through > latest) {
      throw const GrpcError.invalidArgument();
    }
    if (request.baselineOnly) {
      return ListPersonalNotificationsResponse(
        nextSequence: Int64(through),
        throughSequence: Int64(through),
      );
    }
    final all = saved
        .where(
          (n) =>
              n.channelId == request.channelId &&
              n.sequence > request.afterSequence &&
              n.sequence.toInt() <= through &&
              (!request.unreadOnly || n.unreadReasons > 0),
        )
        .toList();
    final limit = request.limit > 0 ? request.limit : 50;
    final items = all.take(limit).toList();
    final page = ListPersonalNotificationsResponse(
      notifications: items,
      throughSequence: Int64(through),
      hasMore: all.length > limit,
      nextSequence: all.length > limit ? items.last.sequence : Int64(through),
    );
    return alter?.call(page) ?? page;
  }

  @override
  Future<void> markRead(String channel, List<String> ids) async {
    if (markError != null) throw markError!;
    readIds.add(ids);
    for (final notice in records.where(
      (n) => n.channelId == channel && ids.contains(n.id),
    )) {
      notice.unreadReasons = 0;
    }
  }

  @override
  Future<void> markChatRead(String channel, List<String> ids) async {
    if (markError != null) throw markError!;
    chatIds.add(ids);
    for (final notice in records.where(
      (n) => n.channelId == channel && ids.contains(n.contentId),
    )) {
      notice.unreadReasons = 0;
    }
  }
}

class PersonalTestWorkspace {
  final session = PersonalTestSession();
  static const origin = 'http://127.0.0.1:18080';
  late final ServerWorkspaces workspaces;
  ChatController get chatController => workspaces[origin]!;
  PersonalTestApi get api => session.notifications;

  Future<void> start() async {
    final vault = ChannelVault();
    workspaces = ServerWorkspaces(
      vault: vault,
      create: (_) => ChatController(
        vault,
        positions: MemoryPositions(),
        historyStore: MemoryHistory(),
        outboxStore: MemoryChatOutbox(),
        openSession: (_, _) async => session,
      ),
      resume: (origin, controller) async {
        controller.preview = Discovery(
          localOrigin(origin),
          'srv_test',
          List.filled(32, 1),
        );
        await controller.connect();
      },
    );
    await workspaces.synchronize([origin]);
    await workspaces.refresh();
    for (
      var attempt = 0;
      attempt < 100 && !chatController.connected;
      attempt++
    ) {
      await Future<void>.delayed(const Duration(milliseconds: 1));
    }
    if (!chatController.connected) {
      throw StateError('Тестовое подключение не готово');
    }
  }

  void dispose() => workspaces.dispose();
}
