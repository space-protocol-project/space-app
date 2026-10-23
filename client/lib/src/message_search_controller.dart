import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'message_search.dart';
import 'rpc_clients.dart';

part 'message_search_controller.freezed.dart';

typedef MessageSearch = Future<MessageSearchPage> Function(String, String);

@freezed
abstract class MessageSearchState with _$MessageSearchState {
  const factory MessageSearchState({
    @Default('') String query,
    @Default('') String next,
    @Default([]) List<Content> messages,
    @Default(false) bool loading,
    @Default(false) bool failed,
    @Default(false) bool allChannels,
  }) = _MessageSearchState;
}

/// Владеет задержкой поиска и не принимает ответы от прежнего запроса.
class MessageSearchController extends Cubit<MessageSearchState> {
  MessageSearchController({
    this.searchMessages,
    this.searchAllChannels,
    this.delay = const Duration(milliseconds: 300),
  }) : super(const MessageSearchState());

  static const resultLimit = 200;
  final Duration delay;
  MessageSearch? searchMessages, searchAllChannels;
  Timer? _debounce;
  int _generation = 0;

  MessageSearch? get activeSearch =>
      state.allChannels ? searchAllChannels : searchMessages;

  void changeQuery(String query) {
    if (isClosed) return;
    _debounce?.cancel();
    _generation++;
    emit(MessageSearchState(query: query, allChannels: state.allChannels));
    if (activeSearch == null || query.trim().runes.length < 2) return;
    _debounce = Timer(delay, load);
  }

  void selectAllChannels(bool allChannels) {
    if (isClosed || allChannels == state.allChannels) return;
    emit(state.copyWith(allChannels: allChannels));
    changeQuery(state.query);
  }

  Future<void> load({bool more = false}) async {
    final search = activeSearch;
    if (search == null || !_canLoad(more)) return;
    _debounce?.cancel();
    final generation = _generation;
    final before = state;
    emit(before.copyWith(loading: true, failed: false));
    try {
      final page = await search(before.query.trim(), more ? before.next : '');
      if (!_current(generation)) return;
      emit(
        state.copyWith(
          messages: _merge(more ? before.messages : [], page.messages),
          next: page.next,
          loading: false,
        ),
      );
    } catch (_) {
      if (_current(generation)) {
        emit(state.copyWith(loading: false, failed: true));
      }
    }
  }

  bool _canLoad(bool more) {
    if (isClosed || state.loading) return false;
    if (state.query.trim().runes.length < 2) return false;
    return !more ||
        state.next.isNotEmpty && state.messages.length < resultLimit;
  }

  bool _current(int generation) => !isClosed && generation == _generation;

  List<Content> _merge(List<Content> previous, List<Content> page) => {
    for (final message in [...previous, ...page])
      (message.channelId, message.id): message,
  }.values.take(resultLimit).toList();

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
