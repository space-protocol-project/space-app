import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';

import 'forum_api.dart';
import 'generated/space/v1/forum.pb.dart';
import 'generated/space/v1/space.pb.dart' show Channel;

class ForumState {
  const ForumState({
    this.busy = false,
    this.supported = true,
    this.sections = const [],
    this.section,
    this.threads = const [],
    this.topic,
    this.replies = const [],
    this.nextThreads = 0,
    this.nextReplies = 0,
    this.error,
  });
  final bool busy, supported;
  final List<Channel> sections;
  final Channel? section;
  final List<ForumThread> threads;
  final ForumThread? topic;
  final List<ForumReply> replies;
  final int nextThreads, nextReplies;
  final Object? error;
  ForumState copy({
    bool? busy,
    List<ForumThread>? threads,
    ForumThread? topic,
    List<ForumReply>? replies,
    int? nextThreads,
    int? nextReplies,
    Object? error,
    bool clearTopic = false,
  }) => ForumState(
    busy: busy ?? this.busy,
    supported: supported,
    sections: sections,
    section: section,
    threads: threads ?? this.threads,
    topic: clearTopic ? null : topic ?? this.topic,
    replies: clearTopic ? const [] : replies ?? this.replies,
    nextThreads: nextThreads ?? this.nextThreads,
    nextReplies: clearTopic ? 0 : nextReplies ?? this.nextReplies,
    error: error,
  );
}

class ForumController extends Cubit<ForumState> {
  ForumController(this.api) : super(const ForumState());
  final ForumApi api;

  Future<bool> _run(Future<void> Function() action) async {
    if (state.busy || isClosed) return false;
    emit(state.copy(busy: true));
    try {
      await action();
      return true;
    } catch (e) {
      if (!isClosed) _failure(e);
      return false;
    } finally {
      if (!isClosed) emit(state.copy(busy: false, error: state.error));
    }
  }

  void _failure(Object error) {
    if (error is GrpcError &&
        [
          StatusCode.permissionDenied,
          StatusCode.notFound,
          StatusCode.unauthenticated,
        ].contains(error.code)) {
      emit(ForumState(error: error));
    } else {
      emit(state.copy(error: error));
    }
  }

  Future<bool> refresh() => _run(() async {
    final previousChannel = state.section?.id;
    final previousTopic = state.topic?.id;
    await api.refresh();
    if (isClosed) return;
    final sections = api.sections;
    final section =
        sections.where((c) => c.id == previousChannel).firstOrNull ??
        sections.firstOrNull;
    final fresh = await _refreshContent(
      sections,
      section,
      previousChannel,
      previousTopic,
    );
    if (!isClosed) emit(fresh);
  });

  Future<ForumState> _refreshContent(
    List<Channel> sections,
    Channel? section,
    String? previousChannel,
    String? previousTopic,
  ) async {
    if (!api.supported || section == null) {
      return ForumState(
        busy: true,
        supported: api.supported,
        sections: sections,
        section: section,
      );
    }
    final page = await api.threads(section.id, Int64.ZERO);
    GetForumThreadResponse? detail;
    if (previousTopic != null && section.id == previousChannel) {
      detail = await api.thread(section.id, previousTopic, Int64.ZERO);
    }
    return ForumState(
      busy: true,
      sections: sections,
      section: section,
      threads: page.threads,
      nextThreads: page.nextSequence.toInt(),
      topic: detail?.thread,
      replies: detail?.replies ?? const [],
      nextReplies: detail?.nextSequence.toInt() ?? 0,
    );
  }

  Future<bool> selectSection(Channel section) => _run(() async {
    emit(ForumState(busy: true, sections: state.sections, section: section));
    await _loadThreads(false);
  });

  Future<void> _loadThreads(bool append) async {
    final channel = state.section;
    if (channel == null) return;
    final page = await api.threads(
      channel.id,
      Int64(append ? state.nextThreads : 0),
    );
    if (isClosed) return;
    emit(
      state.copy(
        threads: [if (append) ...state.threads, ...page.threads],
        nextThreads: page.nextSequence.toInt(),
      ),
    );
  }

  Future<bool> moreThreads() => _run(() => _loadThreads(true));

  Future<void> _loadTopic(String id, bool append) async {
    final page = await api.thread(
      state.section!.id,
      id,
      Int64(append ? state.nextReplies : 0),
    );
    if (isClosed) return;
    emit(
      state.copy(
        topic: page.thread,
        replies: [if (append) ...state.replies, ...page.replies],
        nextReplies: page.nextSequence.toInt(),
      ),
    );
  }

  Future<bool> openTopic(String id) => _run(() async {
    emit(state.copy(clearTopic: true));
    await _loadTopic(id, false);
  });
  Future<bool> moreReplies() => _run(() => _loadTopic(state.topic!.id, true));
  void back() {
    if (!state.busy) emit(state.copy(clearTopic: true));
  }

  Future<bool> create(
    String title,
    String text,
    String key, [
    List<String> attachments = const [],
  ]) => _run(() async {
    final topic = await api.create(
      state.section!.id,
      title,
      text,
      key,
      attachments,
    );
    if (isClosed) return;
    // Повтор с тем же ключом возвращает ту же тему, не дублируя список.
    final threads = state.threads.where((t) => t.id != topic.id).toList();
    if (state.nextThreads == 0) threads.add(topic);
    threads.sort((a, b) => a.sequence.compareTo(b.sequence));
    emit(
      state.copy(
        threads: threads,
        topic: topic,
        replies: const [],
        nextReplies: 0,
      ),
    );
  });

  Future<bool> reply(
    String text,
    String key, [
    List<String> attachments = const [],
  ]) => _run(() async {
    final response = await api.reply(
      state.section!.id,
      state.topic!.id,
      text,
      key,
      attachments,
    );
    if (isClosed) return;
    _replaceTopic(response.thread);
    await _loadTopic(response.thread.id, false);
  });

  Future<bool> closeTopic() => _run(() async {
    final topic = state.topic!;
    final closed = await api.closeTopic(
      state.section!.id,
      topic.id,
      topic.revision,
    );
    if (isClosed) return;
    _replaceTopic(closed);
  });
  void _replaceTopic(ForumThread topic) => emit(
    state.copy(
      topic: topic,
      threads: state.threads.map((t) => t.id == topic.id ? topic : t).toList(),
    ),
  );
}
