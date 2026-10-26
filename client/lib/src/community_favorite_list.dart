import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'community_favorites_api.dart';

part 'community_favorite_list.freezed.dart';

typedef _FavoritePage = ({
  List<CommunityFavorite> entries,
  String next,
  int read,
});

@freezed
abstract class CommunityFavoriteListState with _$CommunityFavoriteListState {
  const factory CommunityFavoriteListState({
    @Default([]) List<CommunityFavorite> entries,
    @Default('') String next,
    @Default(false) bool loading,
    @Default(false) bool revoked,
    Object? error,
  }) = _CommunityFavoriteListState;
}

CommunityFavorite checkedCommunityFavorite(CommunityFavorite value) {
  final r = value.result;
  final ref = CommunityContentReference(kind: r.kind, id: r.id);
  if (!value.hasResult() ||
      !validFavoriteReference(ref) ||
      !validFavoriteReference(
        CommunityContentReference(kind: r.kind, id: r.parentId),
      ) ||
      value.savedAtUnixMicros <= Int64.ZERO ||
      r.sequence < Int64.ZERO ||
      r.createdAtUnix < Int64.ZERO ||
      r.snippet.runes.length > 240 ||
      r.title.runes.length > 512) {
    throw const FormatException('Повреждённая запись избранного');
  }
  return value.deepCopy()..freeze();
}

class CommunityFavoriteListController
    extends Cubit<CommunityFavoriteListState> {
  CommunityFavoriteListController(
    this.api,
    this.channel, {
    bool Function()? available,
  }) : _available = available ?? (() => true),
       _scopeId = api.scopeId,
       super(const CommunityFavoriteListState());
  final CommunityFavoriteApi api;
  final String channel, _scopeId;
  final bool Function() _available;
  int _generation = 0, _pages = 1;
  bool _matches() {
    if (_available() && api.scopeId == _scopeId) return true;
    invalidate();
    return false;
  }

  void invalidate() {
    if (isClosed) return;
    ++_generation;
    emit(const CommunityFavoriteListState(revoked: true));
  }

  bool _current(int generation) =>
      !isClosed && _matches() && !state.revoked && generation == _generation;
  Future<void> refresh() => _load(false);
  Future<void> more() => _load(true);
  Future<void> _load(bool more) async {
    if (isClosed || !_matches() || state.revoked || state.loading) return;
    if (more && state.next.isEmpty) return;
    final generation = ++_generation;
    emit(state.copyWith(loading: true, error: null));
    try {
      final result = await _fetch(more, generation);
      if (result == null || !_current(generation)) return;
      _pages = more ? _pages + 1 : result.read;
      emit(
        CommunityFavoriteListState(entries: result.entries, next: result.next),
      );
    } catch (error) {
      if (_current(generation)) emit(CommunityFavoriteListState(error: error));
    }
  }

  Future<_FavoritePage?> _fetch(bool more, int generation) async {
    final entries = more ? [...state.entries] : <CommunityFavorite>[];
    final seen = {
      for (final item in entries) '${item.result.kind.value}:${item.result.id}',
    };
    var token = more ? state.next : '';
    final tokens = <String>{if (token.isNotEmpty) token};
    var read = 0;
    do {
      final page = await api.list(channel, token);
      if (!_current(generation)) return null;
      _append(page, entries, seen);
      token = _nextToken(page, tokens);
      ++read;
    } while (!more && token.isNotEmpty && read < _pages);
    return (entries: entries, next: token, read: read);
  }

  String _nextToken(ListCommunityFavoritesResponse page, Set<String> tokens) {
    final token = page.nextPageToken;
    if (token.length > 1024 || (token.isNotEmpty && !tokens.add(token))) {
      throw const FormatException('Повреждённая страница избранного');
    }
    return token;
  }

  void _append(
    ListCommunityFavoritesResponse page,
    List<CommunityFavorite> entries,
    Set<String> seen,
  ) {
    if (page.favorites.length > 50 ||
        entries.length + page.favorites.length > 5000) {
      throw const FormatException('Слишком много записей избранного');
    }
    for (final value in page.favorites) {
      final item = checkedCommunityFavorite(value);
      final key = '${item.result.kind.value}:${item.result.id}';
      if (!seen.add(key)) {
        throw const FormatException('Повтор записи избранного');
      }
      entries.add(item);
    }
  }

  @override
  Future<void> close() {
    ++_generation;
    return super.close();
  }
}
