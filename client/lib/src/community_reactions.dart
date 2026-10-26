import 'dart:convert';
import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';

import 'community_reactions_api.dart';

export 'community_reactions_api.dart';
part 'community_reactions.freezed.dart';

@freezed
abstract class CommunityReactionsState with _$CommunityReactionsState {
  const factory CommunityReactionsState({
    @Default({}) Map<String, CommunityReactionState> entries,
    @Default({}) Set<String> busy,
    @Default({}) Map<String, Object> errors,
    @Default({}) Set<String> retryable,
    Object? loadError,
  }) = _CommunityReactionsState;
}

CommunityReactionState checkedReactionState(
  CommunityReactionState value,
  CommunityContentReference expected,
) {
  final emojis = <String>{};
  if (!value.hasContent() ||
      communityReactionKey(value.content) != communityReactionKey(expected) ||
      value.revision < Int64.ZERO ||
      value.reactions.length > 32) {
    throw const FormatException('Повреждённое состояние реакций');
  }
  for (final item in value.reactions) {
    if (!validCommunityEmoji(item.emoji) ||
        item.count <= Int64.ZERO ||
        !emojis.add(item.emoji)) {
      throw const FormatException('Повреждённая реакция');
    }
  }
  return value.deepCopy()..freeze();
}

bool validCommunityEmoji(String emoji) =>
    emoji.isNotEmpty &&
    utf8.encode(emoji).length <= 128 &&
    emoji.runes.length <= 32 &&
    !RegExp(r'[\x00-\x20\x7f-\x9f\u202a-\u202e\u2066-\u2069]').hasMatch(emoji);

bool definitiveReactionError(Object error) =>
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

class CommunityReactionsController extends Cubit<CommunityReactionsState> {
  CommunityReactionsController(this.api, this.channel)
    : _scopeId = api.scopeId,
      super(const CommunityReactionsState());
  final CommunityReactionApi api;
  final String channel;
  final String _scopeId;
  final _pending = <String, SetCommunityReactionRequest>{};
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
      if (validReactionReference(item)) {
        next[communityReactionKey(item)] = item.deepCopy()..freeze();
      }
    }
    if (_active == active && _sameKeys(next)) return;
    ++_generation;
    _reading = false;
    _active = active;
    _contents = next;
    _pending.clear();
    emit(const CommunityReactionsState());
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
    emit(const CommunityReactionsState());
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
      final entries = <String, CommunityReactionState>{};
      for (var start = 0; start < refs.length; start += 50) {
        if (!_current(generation)) return;
        final batch = refs.sublist(start, min(start + 50, refs.length));
        final response = await api.list(channel, batch);
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
    ListCommunityReactionsResponse page,
    List<CommunityContentReference> refs,
    Map<String, CommunityReactionState> entries,
  ) {
    if (page.states.length > refs.length) {
      throw const FormatException('Слишком много состояний реакций');
    }
    final expected = {for (final ref in refs) communityReactionKey(ref): ref};
    final seen = <String>{};
    for (final item in page.states) {
      final key = communityReactionKey(item.content);
      final ref = expected[key];
      if (ref == null || !seen.add(key)) {
        throw const FormatException('Лишнее состояние реакций');
      }
      entries[key] = checkedReactionState(item, ref);
    }
  }

  void _applyPage(Map<String, CommunityReactionState> entries) {
    for (final key in entries.keys.toList()) {
      final previous = state.entries[key];
      if (previous != null && previous.revision > entries[key]!.revision) {
        entries[key] = previous.deepCopy()
          ..canReact = entries[key]!.canReact
          ..freeze();
      }
    }
    final writable = entries.keys
        .where((key) => entries[key]!.canReact)
        .toSet();
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
    if (definitiveReactionError(error)) {
      ++_generation;
      _pending.clear();
      _reading = false;
      emit(CommunityReactionsState(loadError: error));
      return;
    }
    emit(state.copyWith(entries: {}, loadError: error));
  }

  Future<void> toggle(CommunityContentReference content, String emoji) async {
    if (isClosed ||
        !_bindingMatches() ||
        !_active ||
        !validCommunityEmoji(emoji)) {
      return;
    }
    final key = communityReactionKey(content);
    final entry = state.entries[key];
    if (entry == null || !entry.canReact || state.busy.contains(key)) return;
    if (_pending.containsKey(key)) return;
    final selected = entry.reactions.any((r) => r.emoji == emoji && r.selected);
    final random = Random.secure();
    _pending[key] = SetCommunityReactionRequest(
      channelId: channel,
      content: content,
      emoji: emoji,
      active: !selected,
      expectedRevision: entry.revision,
      idempotencyKey: base64UrlEncode(
        List.generate(24, (_) => random.nextInt(256)),
      ).replaceAll('=', ''),
    )..freeze();
    await retry(content);
  }

  Future<void> retry(CommunityContentReference content) async {
    if (isClosed || !_bindingMatches() || !_active) return;
    final key = communityReactionKey(content);
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

  CommunityReactionState _checkResult(
    SetCommunityReactionResponse result,
    SetCommunityReactionRequest request,
  ) {
    if (result.idempotencyKey != request.idempotencyKey ||
        result.appliedRevision < request.expectedRevision ||
        result.appliedRevision > result.state.revision) {
      throw const FormatException('Повреждённый ответ изменения реакции');
    }
    return checkedReactionState(result.state, request.content);
  }

  void _applied(String key, CommunityReactionState entry) {
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
    final retry = !definitiveReactionError(error);
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
    final key = communityReactionKey(content);
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
