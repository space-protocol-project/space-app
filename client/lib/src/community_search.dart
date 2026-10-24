import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'generated/space/v1/community_search.pb.dart';
import 'community_search_api.dart';

export 'community_search_api.dart';

part 'community_search.freezed.dart';

@freezed
abstract class CommunitySearchState with _$CommunitySearchState {
  const factory CommunitySearchState({
    @Default('') String query,
    @Default([]) List<CommunitySearchResult> results,
    @Default('') String next,
    @Default(false) bool loading,
    @Default(false) bool invalid,
    @Default(false) bool revoked,
    Object? error,
  }) = _CommunitySearchState;
}

class CommunitySearchController extends Cubit<CommunitySearchState> {
  CommunitySearchController(this.api, this.channel)
    : super(const CommunitySearchState());
  final CommunitySearchApi api;
  final String channel;
  int _generation = 0;

  void invalidate() {
    ++_generation;
    if (!isClosed) emit(const CommunitySearchState(revoked: true));
  }

  Future<void> submit(String value) async {
    if (isClosed || state.revoked) return;
    final query = value.trim();
    final invalid = query.isEmpty || utf8.encode(query).length > 256;
    ++_generation;
    emit(CommunitySearchState(query: query, invalid: invalid));
    if (!invalid) await _load(false);
  }

  Future<void> refresh() async {
    if (state.query.isEmpty ||
        state.invalid ||
        state.loading ||
        state.revoked) {
      return;
    }
    await _load(false);
  }

  Future<void> more() async {
    if (state.next.isEmpty || state.loading || state.revoked) return;
    await _load(true);
  }

  Future<void> _load(bool append) async {
    final generation = ++_generation;
    final previous = state;
    emit(state.copyWith(loading: true, error: null));
    try {
      final page = await api.search(
        channel,
        previous.query,
        append ? previous.next : '',
      );
      if (isClosed || generation != _generation) return;
      emit(
        state.copyWith(
          loading: false,
          results: [if (append) ...previous.results, ...page.results],
          next: page.nextPageToken,
        ),
      );
    } catch (error) {
      if (isClosed || generation != _generation) return;
      // Любая ошибка убирает старые результаты, включая отозванный доступ.
      emit(CommunitySearchState(query: previous.query, error: error));
    }
  }

  @override
  Future<void> close() {
    ++_generation;
    return super.close();
  }
}
