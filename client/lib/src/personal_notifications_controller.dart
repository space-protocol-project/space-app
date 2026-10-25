import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';

import 'chat_controller.dart';
import 'server_workspaces.dart';
import 'personal_notifications_api.dart';
import 'personal_notification_scope.dart';
import 'personal_notification_target.dart';
import 'personal_notification_pages.dart';
import 'generated/space/v1/personal_notifications.pb.dart';
import 'generated/space/v1/space.pb.dart' show Content;

part 'personal_notifications_controller.freezed.dart';
part 'personal_notification_delivery.dart';
part 'personal_notification_reads.dart';

@freezed
abstract class PersonalNotificationsState with _$PersonalNotificationsState {
  const factory PersonalNotificationsState({
    @Default([]) List<PersonalNotificationScope> scopes,
    @Default(false) bool enabled,
  }) = _PersonalNotificationsState;
}

typedef PersonalNoticeDelivery = Future<bool> Function(
  PersonalNotificationScope scope,
  List<PersonalNotification> notices,
);

class PersonalNotificationsController
    extends Cubit<PersonalNotificationsState> {
  PersonalNotificationsController(
    this.workspaces, {
    required this.deliver,
    Duration? interval = const Duration(seconds: 15),
  }) : super(const PersonalNotificationsState()) {
    _subscription = workspaces.stream.listen((_) => synchronize());
    if (interval != null) {
      _timer = Timer.periodic(interval, (_) => unawaited(poll()));
    }
    synchronize();
  }
  final ServerWorkspaces workspaces;
  final PersonalNoticeDelivery deliver;
  late final StreamSubscription<Object?> _subscription;
  Timer? _timer;
  final _sources = <String, PersonalNotificationScope>{};
  final _checkpoints = <String, _NotificationCheckpoint>{};
  final _denied = <String, PersonalNotificationScope>{};
  final _readDone = <String>{};
  final _reading = <String>{};
  final _readLater = <String, (PersonalNotificationScope, List<String>)>{};
  Future<void>? _polling;
  int _epoch = 0, _roundStart = 0;

  bool current(PersonalNotificationScope scope) =>
      !isClosed && identical(_sources[scope.key], scope) && scope.valid();
  PersonalNotificationScope? scopeFor(PersonalNotificationTarget target) =>
      _sources.values
          .where(
            (scope) =>
                scope.origin == target.origin &&
                scope.principal == target.principal &&
                scope.channel.id == target.channel,
          )
          .firstOrNull;

  void synchronize() {
    if (isClosed) return;
    final next = <String, PersonalNotificationScope>{};
    _checkpoints.removeWhere(
      (_, value) => !workspaces.controllers.containsKey(value.origin),
    );
    _denied.removeWhere(
      (_, value) => !workspaces.controllers.containsKey(value.origin),
    );
    for (final entry in workspaces.controllers.entries) {
      _collect(entry.key, entry.value, next);
    }
    final changed =
        next.length != _sources.length ||
        next.entries.any(
          (entry) => !identical(_sources[entry.key], entry.value),
        );
    _sources
      ..clear()
      ..addAll(next);
    if (changed) emit(state.copyWith(scopes: next.values.toList()));
    if (changed && state.enabled) {
      if (_polling == null) unawaited(poll());
    }
  }

  void _collect(
    String origin,
    ChatController chat,
    Map<String, PersonalNotificationScope> next,
  ) {
    if (!chat.connected || chat.reconnecting || chat.accessRemoved) return;
    final api = chat.personalNotifications;
    final keys = <String>{};
    if (api != null && api.supported && api.principalId == chat.principalId) {
      _collectSections(origin, chat, api, keys, next);
    }
    _denied.removeWhere(
      (key, scope) =>
          scope.origin == origin &&
          (!keys.contains(key) || !identical(scope.api, api)),
    );
    _forgetCheckpoints(origin, keys);
  }

  void _collectSections(
    String origin,
    ChatController chat,
    PersonalNotificationApi api,
    Set<String> keys,
    Map<String, PersonalNotificationScope> next,
  ) {
    for (final channel in api.sections.where(readableNotificationSection)) {
      final source = PersonalNotificationScope(
        origin: origin,
        chat: chat,
        api: api,
        channel: channel.deepCopy()..freeze(),
      );
      keys.add(source.key);
      if (identical(_denied[source.key]?.api, api)) continue;
      final old = _sources[source.key];
      next[source.key] = old != null && old.sameAs(source) ? old : source;
    }
  }

  void _forgetCheckpoints(String origin, Set<String> retained) {
    _checkpoints.removeWhere(
      (key, value) => value.origin == origin && !retained.contains(key),
    );
  }

  void setDeliveryEnabled(bool enabled) {
    if (isClosed || enabled == state.enabled) return;
    ++_epoch;
    _checkpoints.clear();
    emit(state.copyWith(enabled: enabled));
    if (enabled) unawaited(poll());
  }

  void invalidate(PersonalNotificationScope scope) {
    if (!current(scope)) return;
    _denied[scope.key] = scope;
    resetScope(scope);
    synchronize();
  }

  void resetScope(PersonalNotificationScope scope) {
    _checkpoints.remove(scope.key);
    _readLater.remove(scope.key);
    _readDone.removeWhere((key) => key.startsWith('${scope.key}:'));
  }

  Future<void> refreshSources() async {
    final apis = workspaces.controllers.values
        .where(
          (chat) => chat.connected && !chat.reconnecting && !chat.accessRemoved,
        )
        .map((chat) => chat.personalNotifications)
        .whereType<PersonalNotificationApi>()
        .where((api) => api.supported)
        .toSet();
    for (final api in apis) {
      try {
        await api.refresh().timeout(const Duration(seconds: 5));
        _denied.removeWhere((key, scope) => identical(scope.api, api));
      } catch (_) {
        /* Старый снимок не даёт полномочий на доставку. */
      }
    }
    synchronize();
  }

  Future<ListPersonalNotificationsResponse?> read(
    PersonalNotificationScope scope,
    ListPersonalNotificationsRequest request,
  ) async {
    if (!current(scope)) return null;
    try {
      final page = await scope.api
          .list(request)
          .timeout(const Duration(seconds: 5));
      if (!current(scope)) return null;
      validateNotificationPage(scope, request, page);
      return page;
    } on GrpcError catch (error) {
      if (_accessError(error)) invalidate(scope);
      rethrow;
    }
  }

  Future<PersonalNotification?> resolve(
    PersonalNotificationTarget target,
  ) async {
    final source = scopeFor(target);
    if (source == null) return null;
    final page = await read(
      source,
      ListPersonalNotificationsRequest(
        channelId: target.channel,
        afterSequence: Int64(target.sequence - 1),
        throughSequence: Int64(target.sequence),
        limit: 1,
      ),
    );
    final notice = page?.notifications.firstOrNull;
    return notice?.id == target.id &&
            notice?.sequence.toInt() == target.sequence
        ? notice
        : null;
  }

  bool _accessError(GrpcError error) => const [
    StatusCode.permissionDenied,
    StatusCode.unauthenticated,
    StatusCode.notFound,
    StatusCode.failedPrecondition,
  ].contains(error.code);

  @override
  Future<void> close() async {
    ++_epoch;
    _timer?.cancel();
    _sources.clear();
    _checkpoints.clear();
    _readLater.clear();
    _readDone.clear();
    await _subscription.cancel();
    return super.close();
  }
}

class _NotificationCheckpoint {
  _NotificationCheckpoint(PersonalNotificationScope scope, this.after)
    : origin = scope.origin;
  final String origin;
  int after, through = 0;
}
