import 'dart:convert';
import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';

import 'community_favorites_api.dart';

export 'community_favorites_api.dart';
part 'community_favorites.freezed.dart';

@freezed
abstract class CommunityFavoritesState with _$CommunityFavoritesState {
  const factory CommunityFavoritesState({
    @Default({}) Map<String, CommunityFavoriteState> entries,
    @Default({}) Set<String> busy,
    @Default({}) Map<String, Object> errors,
    @Default({}) Set<String> retryable,
    Object? loadError,
  }) = _CommunityFavoritesState;
}

CommunityFavoriteState checkedFavoriteState(
  CommunityFavoriteState value,
  CommunityContentReference expected,
) {
  if (!value.hasContent() ||
      communityFavoriteKey(value.content) != communityFavoriteKey(expected) ||
      value.revision < Int64.ZERO) {
    throw const FormatException('Повреждённое состояние избранного');
  }
  return value.deepCopy()..freeze();
}

bool definitiveFavoriteError(Object error) =>
    error is GrpcError &&
    const [
      StatusCode.invalidArgument,
      StatusCode.notFound,
      StatusCode.permissionDenied,
      StatusCode.unauthenticated,
      StatusCode.unimplemented,
      StatusCode.failedPrecondition,
      StatusCode.aborted,
      StatusCode.alreadyExists,
      StatusCode.resourceExhausted,
    ].contains(error.code);

class CommunityFavoritesController extends Cubit<CommunityFavoritesState> {
  CommunityFavoritesController(this.api, this.channel)
    : _scopeId = api.scopeId,
      super(const CommunityFavoritesState());
  final CommunityFavoriteApi api;
  final String channel;
  final String _scopeId;
  final _pending = <String, SetCommunityFavoriteRequest>{};
  Map<String, CommunityContentReference> _contents = {};
  bool _active = false, _reading = false;
  int _generation = 0;

  Future<void> select(
    Iterable<CommunityContentReference> contents, {
    required bool active,
  }) async {
    if (isClosed || !_bindingMatches()) return;
    final next = <String, CommunityContentReference>{};
    for (final item in contents) {
      if (validFavoriteReference(item)) {
        next[communityFavoriteKey(item)] = item.deepCopy()..freeze();
      }
    }
    if (_active == active && _sameKeys(next)) return;
    ++_generation;
    _reading = false;
    _active = active;
    _contents = next;
    _pending.clear();
    emit(const CommunityFavoritesState());
    if (active) await refresh();
  }

  bool _sameKeys(Map<String, CommunityContentReference> next) =>
      next.length == _contents.length && next.keys.every(_contents.containsKey);

  bool _current(int generation) =>
      !isClosed && _bindingMatches() && _active && generation == _generation;

  bool _bindingMatches() {
    if (api.scopeId == _scopeId) return true;
    ++_generation;
    _active = false;
    _reading = false;
    _pending.clear();
    emit(const CommunityFavoritesState());
    return false;
  }

  Future<void> refresh() async {
    if (isClosed ||
        !_bindingMatches() ||
        !_active ||
        _reading ||
        _contents.isEmpty) {
      return;
    }
    final generation = _generation;
    _reading = true;
    try {
      final refs = _contents.values.toList(growable: false);
      final entries = <String, CommunityFavoriteState>{};
      for (var start = 0; start < refs.length; start += 50) {
        if (!_current(generation)) return;
        final batch = refs.sublist(start, min(start + 50, refs.length));
        final response = await api.states(channel, batch);
        _readPage(response, batch, entries);
      }
      if (_current(generation)) _applyPage(entries);
    } catch (error) {
      if (_current(generation)) _readFailed(error);
    } finally {
      if (generation == _generation) _reading = false;
    }
  }

  void _readPage(
    GetCommunityFavoriteStatesResponse page,
    List<CommunityContentReference> refs,
    Map<String, CommunityFavoriteState> entries,
  ) {
    if (page.states.length > refs.length) {
      throw const FormatException('Слишком много состояний избранного');
    }
    final expected = {for (final ref in refs) communityFavoriteKey(ref): ref};
    final seen = <String>{};
    for (final item in page.states) {
      final key = communityFavoriteKey(item.content);
      final ref = expected[key];
      if (ref == null || !seen.add(key)) {
        throw const FormatException('Лишнее состояние избранного');
      }
      entries[key] = checkedFavoriteState(item, ref);
    }
  }

  void _applyPage(Map<String, CommunityFavoriteState> entries) {
    for (final key in entries.keys.toList()) {
      final previous = state.entries[key];
      if (previous != null && previous.revision > entries[key]!.revision) {
        entries[key] = previous;
      }
    }
    final writable = entries.keys.toSet();
    _pending.removeWhere((key, _) => !writable.contains(key));
    emit(
      state.copyWith(
        entries: entries,
        loadError: null,
        busy: state.busy.intersection(writable),
        retryable: state.retryable.intersection(writable),
      ),
    );
  }

  void _readFailed(Object error) {
    if (definitiveFavoriteError(error)) {
      ++_generation;
      _pending.clear();
      _reading = false;
      emit(CommunityFavoritesState(loadError: error));
      return;
    }
    emit(state.copyWith(entries: {}, loadError: error));
  }

  Future<void> toggle(CommunityContentReference content) async {
    if (isClosed || !_bindingMatches() || !_active) return;
    final key = communityFavoriteKey(content);
    final entry = state.entries[key];
    if (entry == null ||
        state.busy.contains(key) ||
        _pending.containsKey(key)) {
      return;
    }
    final random = Random.secure();
    _pending[key] = SetCommunityFavoriteRequest(
      channelId: channel,
      content: content,
      saved: !entry.saved,
      expectedRevision: entry.revision,
      idempotencyKey: base64UrlEncode(
        List.generate(24, (_) => random.nextInt(256)),
      ).replaceAll('=', ''),
    )..freeze();
    await retry(content);
  }

  Future<void> retry(CommunityContentReference content) async {
    if (isClosed || !_bindingMatches() || !_active) return;
    final key = communityFavoriteKey(content);
    final request = _pending[key];
    if (request == null || state.busy.contains(key)) return;
    final generation = _generation;
    emit(state.copyWith(busy: {...state.busy, key}));
    try {
      final result = await api.set(request);
      final entry = _checkResult(result, request);
      if (!_current(generation) ||
          _pending[key]?.idempotencyKey != request.idempotencyKey) {
        return;
      }
      _pending.remove(key);
      _applied(key, entry);
    } catch (error) {
      if (_current(generation)) _writeFailed(key, error);
    }
  }

  CommunityFavoriteState _checkResult(
    SetCommunityFavoriteResponse result,
    SetCommunityFavoriteRequest request,
  ) {
    if (result.idempotencyKey != request.idempotencyKey ||
        result.appliedRevision < request.expectedRevision ||
        result.appliedRevision > result.state.revision) {
      throw const FormatException('Повреждённый ответ изменения отметки');
    }
    return checkedFavoriteState(result.state, request.content);
  }

  void _applied(String key, CommunityFavoriteState entry) {
    final previous = state.entries[key];
    final newest = previous != null && previous.revision > entry.revision
        ? previous
        : entry;
    emit(
      state.copyWith(
        entries: {...state.entries, key: newest},
        busy: {...state.busy}..remove(key),
        errors: {...state.errors}..remove(key),
        retryable: {...state.retryable}..remove(key),
      ),
    );
  }

  void _writeFailed(String key, Object error) {
    final retry = !definitiveFavoriteError(error);
    if (!retry) _pending.remove(key);
    final retryable = {...state.retryable}..remove(key);
    if (retry) retryable.add(key);
    emit(
      state.copyWith(
        entries: {...state.entries}..remove(key),
        busy: {...state.busy}..remove(key),
        errors: {...state.errors, key: error},
        retryable: retryable,
      ),
    );
    if (!retry) refresh();
  }

  Future<void> recover(CommunityContentReference content) async {
    if (isClosed || !_bindingMatches()) return;
    final key = communityFavoriteKey(content);
    if (_pending.containsKey(key)) {
      await retry(content);
      return;
    }
    emit(state.copyWith(errors: {...state.errors}..remove(key)));
    await refresh();
  }

  @override
  Future<void> close() {
    ++_generation;
    _pending.clear();
    return super.close();
  }
}
