import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'personal_notification_scope.dart';
import 'personal_notifications_controller.dart';
import 'generated/space/v1/personal_notifications.pb.dart';

part 'personal_inbox_controller.freezed.dart';

@freezed
abstract class PersonalInboxState with _$PersonalInboxState {
  const factory PersonalInboxState({
    PersonalNotificationScope? scope,
    @Default([]) List<PersonalNotification> items,
    @Default([]) List<int> history,
    @Default(false) bool loading,
    @Default(false) bool failed,
    @Default(false) bool marking,
    @Default(false) bool hasMore,
    @Default(0) int after,
    @Default(0) int through,
    @Default(0) int next,
  }) = _PersonalInboxState;
}

class PersonalInboxController extends Cubit<PersonalInboxState> {
  PersonalInboxController(
    this.notifications, {
    String? initialKey,
    Duration? interval = const Duration(seconds: 15),
  }) : super(const PersonalInboxState()) {
    _subscription = notifications.stream.listen((_) => _sourcesChanged());
    final scopes = notifications.state.scopes;
    final initial =
        scopes.where((s) => s.key == initialKey).firstOrNull ??
        scopes.firstOrNull;
    select(initial);
    if (interval != null) {
      _timer = Timer.periodic(interval, (_) => unawaited(reload()));
    }
  }
  final PersonalNotificationsController notifications;
  late final StreamSubscription<Object?> _subscription;
  Timer? _timer;
  int _generation = 0;

  void _sourcesChanged() {
    final previous = state.scope;
    if (previous == null) return;
    final next = notifications.state.scopes
        .where((s) => s.key == previous.key)
        .firstOrNull;
    if (!identical(previous, next)) select(next);
  }

  void select(PersonalNotificationScope? scope) {
    if (isClosed) return;
    ++_generation;
    emit(PersonalInboxState(scope: scope));
    if (scope != null) unawaited(_load(0, 0, const []));
  }

  bool _current(PersonalNotificationScope scope, int generation) =>
      !isClosed &&
      generation == _generation &&
      identical(state.scope, scope) &&
      notifications.current(scope);

  Future<void> refresh() async {
    if (isClosed || state.loading || state.marking) return;
    await _load(0, 0, const []);
  }

  Future<void> reload() async {
    if (isClosed || state.loading || state.marking) return;
    await _load(
      state.after,
      state.after == 0 ? 0 : state.through,
      state.history,
    );
  }

  Future<void> next() async {
    if (state.loading || state.marking || !state.hasMore) return;
    final history = [...state.history, state.after];
    await _load(
      state.next,
      state.through,
      history.skip((history.length - 128).clamp(0, 128)).toList(),
    );
  }

  Future<void> previous() async {
    if (state.loading || state.marking || state.history.isEmpty) return;
    final history = [...state.history];
    final after = history.removeLast();
    await _load(after, state.through, history);
  }

  Future<void> _load(int after, int through, List<int> history) async {
    final scope = state.scope;
    if (scope == null) return;
    final generation = ++_generation;
    emit(state.copyWith(loading: true, failed: false, items: []));
    try {
      final page = await notifications.read(
        scope,
        ListPersonalNotificationsRequest(
          channelId: scope.channel.id,
          afterSequence: Int64(after),
          throughSequence: Int64(through),
          unreadOnly: true,
          limit: 50,
        ),
      );
      if (!_current(scope, generation)) return;
      if (page == null) throw StateError('Раздел недоступен');
      emit(
        state.copyWith(
          loading: false,
          items: page.notifications.map((n) => n.deepCopy()..freeze()).toList(),
          after: after,
          through: page.throughSequence.toInt(),
          next: page.nextSequence.toInt(),
          history: history,
          hasMore: page.hasMore,
        ),
      );
    } catch (_) {
      if (_current(scope, generation)) {
        emit(state.copyWith(loading: false, failed: true, items: []));
      }
    }
  }

  Future<void> markRead(PersonalNotification notification) async {
    final scope = state.scope;
    if (scope == null || state.marking || state.loading) return;
    final generation = _generation;
    emit(state.copyWith(marking: true, failed: false));
    try {
      final marked = await notifications.markRead(scope, [notification.id]);
      if (!_current(scope, generation)) return;
      if (!marked) throw StateError('Просмотр не подтверждён');
      emit(
        state.copyWith(
          marking: false,
          items: state.items.where((n) => n.id != notification.id).toList(),
        ),
      );
    } catch (_) {
      if (_current(scope, generation)) {
        emit(state.copyWith(marking: false, failed: true));
      }
    }
  }

  @override
  Future<void> close() async {
    ++_generation;
    _timer?.cancel();
    await _subscription.cancel();
    return super.close();
  }
}
