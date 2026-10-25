import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../community_mentions.dart';
import '../generated/space/v1/community_mentions.pb.dart';
import '../saved_drafts.dart';
import 'mentions.dart';

typedef SaveMlsDraft = void Function(
  String scope,
  String text, {
  List<CommunityMention> mentions,
});

// Восстановление и запись привязаны к конкретному защищённому профилю и группе.
class MlsMentionDraftCubit extends MentionDraftCubit {
  MlsMentionDraftCubit(
    this.scope, {
    this.loadText = SavedDrafts.load,
    this.loadMentions = SavedDrafts.loadMentions,
    this.save = SavedDrafts.save,
  }) {
    _subscription = stream.listen((value) {
      save(scope, value.text, mentions: value.mentions);
    });
  }

  final String scope;
  final Future<String> Function(String) loadText;
  final Future<List<CommunityMention>> Function(String, String) loadMentions;
  final SaveMlsDraft save;
  late final StreamSubscription<MentionDraftState> _subscription;
  int _generation = 0;

  @override
  void onChange(Change<MentionDraftState> change) {
    _generation++;
    super.onChange(change);
  }

  Future<void> load() async {
    final generation = _generation;
    try {
      final text = await loadText(scope);
      final selected = await loadMentions(scope, text);
      requireMlsMentions(text, selected);
      if (isClosed || generation != _generation || state.text.isNotEmpty) {
        return;
      }
      restore(text, selected);
    } catch (_) {
      // Повреждённый или недоступный черновик не заменяет текущий ввод.
    }
  }

  @override
  Future<void> close() async {
    final changed = _generation > 0;
    _generation++;
    if (changed) save(scope, state.text, mentions: state.mentions);
    await _subscription.cancel();
    await super.close();
  }
}
