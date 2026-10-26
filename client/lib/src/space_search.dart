import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'space_search_api.dart';
export 'space_search_api.dart';

part 'space_search.freezed.dart';
part 'space_search_validation.dart';

@freezed
abstract class SpaceSearchState with _$SpaceSearchState {
  const factory SpaceSearchState({
    @Default('') String query,
    @Default([]) List<SpaceSearchResult> results,
    @Default('') String next,
    @Default(false) bool loading,
    @Default(false) bool invalid,
    @Default(false) bool revoked,
    @Default(false) bool capped,
    Object? error,
  }) = _SpaceSearchState;
}

class SpaceSearchController extends Cubit<SpaceSearchState> {
  SpaceSearchController(
    this.api, {
    required Map<String, String> channels,
    required this.available,
  }) : channels = Map.unmodifiable(channels),
       scope = api.scopeId,
       super(const SpaceSearchState());

  static const resultLimit = 500;
  final SpaceSearchApi api;
  final Map<String, String> channels;
  final bool Function() available;
  final String scope;
  final _tokens = <String>{};
  int _generation = 0;

  void invalidate() {
    if (isClosed || state.revoked) return;
    ++_generation;
    _tokens.clear();
    emit(const SpaceSearchState(revoked: true));
  }

  bool _current(int generation) {
    if (isClosed || generation != _generation) return false;
    if (scope != api.scopeId || !available()) invalidate();
    return !state.revoked;
  }

  Future<void> submit(String input) async {
    if (!_current(_generation)) return;
    final query = input.trim();
    final invalid =
        query.isEmpty ||
        query.contains('\u0000') ||
        utf8.encode(query).length > 256;
    ++_generation;
    _tokens.clear();
    emit(SpaceSearchState(query: query, invalid: invalid));
    if (!invalid) await _load(false);
  }

  Future<void> refresh() => submit(state.query);

  Future<void> more() async {
    if (state.loading || state.next.isEmpty || state.capped) return;
    await _load(true);
  }

  Future<void> _load(bool append) async {
    if (!_current(_generation)) return;
    final generation = ++_generation;
    final before = state;
    emit(state.copyWith(loading: true, error: null));
    try {
      final token = append ? before.next : '';
      final response = await api.search(before.query, token);
      if (!_current(generation)) return;
      final entries = _checkedSpacePage(
        response,
        append ? before.results : [],
        channels,
      );
      _checkToken(response.nextPageToken, token, entries.isEmpty);
      final capped = entries.length >= resultLimit;
      emit(
        state.copyWith(
          results: entries.take(resultLimit).toList(),
          next: capped ? '' : response.nextPageToken,
          capped: capped,
          loading: false,
        ),
      );
    } catch (error) {
      if (!_current(generation)) return;
      emit(SpaceSearchState(query: before.query, error: error));
    }
  }

  void _checkToken(String next, String previous, bool empty) {
    if (next.isEmpty) return;
    if (next.length > 1024 || !_spaceSearchText(next, 1024) ||
        next == previous || empty || !_tokens.add(next)) {
      throw StateError('Некорректная страница поиска пространства');
    }
  }

  @override
  Future<void> close() {
    ++_generation;
    return super.close();
  }
}
