import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'community_mentions_api.dart';
import 'mention_data.dart';
export 'mention_data.dart';
import 'generated/space/v1/community_mentions.pb.dart';
import 'generated/space/v1/community_search.pb.dart';

part 'community_mentions.freezed.dart';

@freezed
abstract class MentionDraftState with _$MentionDraftState {
  const factory MentionDraftState({
    @Default('') String text,
    @Default([]) List<CommunityMention> mentions,
  }) = _MentionDraftState;
}

class MentionDraftCubit extends Cubit<MentionDraftState> {
  MentionDraftCubit() : super(const MentionDraftState());

  void restore(String text, List<CommunityMention> mentions) {
    if (!isClosed) {
      emit(
        MentionDraftState(text: text, mentions: validMentions(text, mentions)),
      );
    }
  }

  void change(String text) {
    if (text == state.text || isClosed) return;
    final previous = state.text;
    var prefix = 0;
    while (prefix < previous.length &&
        prefix < text.length &&
        previous.codeUnitAt(prefix) == text.codeUnitAt(prefix)) {
      prefix++;
    }
    var suffix = 0;
    while (suffix < previous.length - prefix &&
        suffix < text.length - prefix &&
        previous.codeUnitAt(previous.length - suffix - 1) ==
            text.codeUnitAt(text.length - suffix - 1)) {
      suffix++;
    }
    final rebased = _rebase(
      prefix,
      previous.length - suffix,
      text.length - previous.length,
    );
    emit(MentionDraftState(text: text, mentions: validMentions(text, rebased)));
  }

  List<CommunityMention> _rebase(int start, int end, int delta) => [
    for (final mention in state.mentions)
      if (mention.start + mention.length <= start)
        mention
      else if (mention.start >= end)
        CommunityMention(
          principalId: mention.principalId,
          displayName: mention.displayName,
          start: mention.start + delta,
          length: mention.length,
        ),
  ];

  bool insert(MentionCandidate candidate, int start, int end) {
    if (state.mentions.length >= 10 ||
        start < 0 ||
        end < start ||
        end > state.text.length) {
      return false;
    }
    final label = '@${candidate.displayName}';
    change(state.text.replaceRange(start, end, '$label '));
    final mentions = [
      ...state.mentions,
      CommunityMention(
        principalId: candidate.principalId,
        displayName: candidate.displayName,
        start: start,
        length: label.length,
      ),
    ]..sort((a, b) => a.start.compareTo(b.start));
    emit(state.copyWith(mentions: validMentions(state.text, mentions)));
    return true;
  }

  List<CommunityMention> get trimmed {
    final offset = state.text.length - state.text.trimLeft().length;
    final rebased = state.mentions.map(
      (m) => CommunityMention(
        principalId: m.principalId,
        displayName: m.displayName,
        start: m.start - offset,
        length: m.length,
      ),
    );
    return validMentions(state.text.trim(), rebased);
  }
}

@freezed
abstract class MentionPickerState with _$MentionPickerState {
  const factory MentionPickerState({
    @Default(false) bool loading,
    @Default(false) bool failed,
    @Default([]) List<MentionCandidate> candidates,
  }) = _MentionPickerState;
}

class MentionPickerCubit extends Cubit<MentionPickerState> {
  MentionPickerCubit(this.api, this.channel, this.parent)
    : super(const MentionPickerState());
  final CommunityMentionApi api;
  final String channel, parent;
  int _generation = 0;
  Future<void> search(String query) async {
    final generation = ++_generation;
    emit(const MentionPickerState(loading: true));
    try {
      final candidates = await api.candidates(channel, parent, query);
      if (!isClosed && generation == _generation) {
        emit(MentionPickerState(candidates: candidates));
      }
    } catch (_) {
      if (!isClosed && generation == _generation) {
        emit(const MentionPickerState(failed: true));
      }
    }
  }
}

class MentionReadCubit extends Cubit<Set<String>> {
  MentionReadCubit(CommunityMentionApi? api) : _source = (() => api), super({});
  MentionReadCubit.fromSource(Object source)
    : _source = (() => communityMentionsFor(source)),
      super({});
  final CommunityMentionApi? Function() _source;
  CommunityMentionApi? get api => _source();
  final _pending = <String, CommunityContentReference>{};
  final _channels = <String, String>{};
  bool _sending = false;
  bool _failed = false;
  void retry() {
    _failed = false;
  }

  Future<void> visible(
    String channel,
    List<CommunityContentReference> content,
  ) async {
    if (api == null || isClosed || _failed) return;
    for (final ref in content) {
      final key = '${api!.principalId}:$channel:${ref.kind.value}:${ref.id}';
      if (!state.contains(key)) {
        _pending[key] = ref;
        _channels[key] = channel;
      }
    }
    await _flush(channel);
  }

  Future<void> _flush(String channel) async {
    if (_sending || _pending.isEmpty) return;
    _sending = true;
    // Вызов относится к одному разделу; контроллер создаётся вместе с источником.
    final batch = Map<String, CommunityContentReference>.fromEntries(
      _pending.entries.where((e) => _channels[e.key] == channel).take(50),
    );
    try {
      await api!.markRead(channel, batch.values.toList());
      if (!isClosed) emit({...state, ...batch.keys});
      for (final key in batch.keys) {
        _pending.remove(key);
        _channels.remove(key);
      }
    } catch (_) {
      _failed = true;
      _pending.clear();
      _channels.clear();
    } finally {
      _sending = false;
    }
    if (!isClosed && !_failed && _pending.isNotEmpty) {
      await _flush(_channels[_pending.keys.first]!);
    }
  }
}

CommunityContentReference? mentionedContent(
  CommunityMentionApi? api,
  Iterable<CommunityMention> mentions,
  CommunitySearchKind kind,
  String id,
) {
  if (api == null || !mentions.any((m) => m.principalId == api.principalId)) {
    return null;
  }
  return CommunityContentReference(kind: kind, id: id);
}
