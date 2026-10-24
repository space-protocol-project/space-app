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
    this.nextPinned = false,
    this.nextReplies = 0,
    this.error,
  });
  final bool busy, supported, nextPinned;
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
    bool? nextPinned,
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
    nextPinned: nextPinned ?? this.nextPinned,
    nextReplies: clearTopic ? 0 : nextReplies ?? this.nextReplies,
    error: error,
  );
}

class ForumController extends Cubit<ForumState> {
  ForumController(this.api) : super(const ForumState());
  final ForumApi api;
  ForumModeration? get moderation {
    final source = api;
    return source is ForumModeration &&
            (source as ForumModeration).moderationSupported
        ? source as ForumModeration
        : null;
  }

  Future<bool> moderateTopic(String action, String reason) => _run(() async {
    final previous = state;
    final topic = state.topic!;
    final updated = await moderation!.moderateTopic(
      state.section!.id,
      topic.id,
      action,
      reason,
      topic.revision,
    );
    if (isClosed) return;
    _replaceTopic(updated);
    await _refreshModeratedDiscussion(previous);
  });
  Future<bool> moderateReply(ForumReply reply, String reason) => _run(() async {
    final previous = state;
    final updated = await moderation!.moderateReply(
      state.section!.id,
      state.topic!.id,
      reply.id,
      !reply.hidden,
      reason,
      reply.revision,
    );
    if (isClosed) return;
    _replaceTopic(updated.thread);
    emit(
      state.copy(
        replies: state.replies
            .map((r) => r.id == updated.reply.id ? updated.reply : r)
            .toList(),
      ),
    );
    await _refreshModeratedDiscussion(previous);
  });
  Future<void> _refreshModeratedDiscussion(ForumState previous) async {
    final detail = await _moderationDetail(previous);
    if (!isClosed) {
      emit(
        state.copy(
          topic: detail.thread,
          replies: detail.replies,
          nextReplies: detail.nextSequence.toInt(),
        ),
      );
    }
  }

  Future<GetForumThreadResponse> _moderationDetail(ForumState previous) async {
    var after = previous.replies.isEmpty
        ? Int64.ZERO
        : previous.replies.first.sequence - Int64.ONE;
    final replies = <ForumReply>[];
    GetForumThreadResponse detail;
    do {
      detail = await api.thread(
        previous.section!.id,
        previous.topic!.id,
        after,
      );
      replies.addAll(detail.replies);
      after = detail.nextSequence;
    } while (after != Int64.ZERO &&
        detail.replies.isNotEmpty &&
        replies.length < previous.replies.length);
    return GetForumThreadResponse(
      thread: detail.thread,
      replies: replies,
      nextSequence: detail.nextSequence,
    );
  }

  Future<GetForumThreadResponse?> _syncDetail(ForumState previous) async {
    if (previous.topic == null) return null;
    if (moderation != null) return _moderationDetail(previous);
    return api.thread(
      previous.section!.id,
      previous.topic!.id,
      previous.topic!.replyCount,
    );
  }

  ForumNavigation? get navigation {
    final source = api;
    return source is ForumNavigation &&
            (source as ForumNavigation).navigationSupported
        ? source as ForumNavigation
        : null;
  }

  Future<ListForumThreadsResponse> _page(
    String channel,
    Int64 after,
    bool pinned,
  ) =>
      navigation?.navigationPage(channel, after, pinned) ??
      api.threads(channel, after);

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
    failedRead = '';
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
    final page = await _page(section.id, Int64.ZERO, false);
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
      nextPinned: page.nextPinned,
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
    final page = await _page(
      channel.id,
      Int64(append ? state.nextThreads : 0),
      append && state.nextPinned,
    );
    if (isClosed) return;
    emit(
      state.copy(
        threads: {
          for (final topic in [
            ...(append ? state.threads : <ForumThread>[]),
            ...page.threads,
          ])
            topic.id: topic,
        }.values.toList()..sort(compareTopics),
        nextThreads: page.nextSequence.toInt(),
        nextPinned: page.nextPinned,
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
    final listed = state.threads.where((t) => t.id == id).firstOrNull;
    emit(state.copy(clearTopic: true));
    final after =
        listed != null && listed.seen && listed.unreadCount > Int64.ZERO
        ? listed.readSequence
        : Int64.ZERO;
    await _openFrom(id, after);
  });
  Future<bool> openSearchResult(String id, int sequence) => _run(() async {
    emit(state.copy(clearTopic: true));
    await _openFrom(id, Int64(sequence > 0 ? sequence - 1 : 0));
  });

  Future<void> _openFrom(String id, Int64 after) async {
    final page = await api.thread(state.section!.id, id, after);
    if (!isClosed) {
      emit(
        state.copy(
          topic: page.thread,
          replies: page.replies,
          nextReplies: page.nextSequence.toInt(),
        ),
      );
    }
  }

  Future<bool> fromBeginning() =>
      _run(() => _openFrom(state.topic!.id, Int64.ZERO));
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
    threads.sort(compareTopics);
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
  static int compareTopics(ForumThread a, ForumThread b) {
    if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
    return a.sequence.compareTo(b.sequence);
  }

  Future<bool> pinTopic() => _run(() async {
    final topic = state.topic!;
    final updated = await navigation!.pinTopic(
      state.section!.id,
      topic.id,
      !topic.pinned,
      topic.revision,
    );
    if (isClosed) return;
    _replaceTopic(updated);
    await _loadThreads(false);
  });
  Future<bool> markRead() => _run(() async {
    final through = state.replies.isEmpty
        ? Int64.ZERO
        : state.replies.last.sequence;
    final updated = await navigation!.markRead(
      state.section!.id,
      state.topic!.id,
      through,
    );
    if (!isClosed) _replaceTopic(updated);
  });
  String failedRead = '';
  Future<void> markVisible(int sequence) async {
    final topic = state.topic;
    if (state.busy || isClosed || navigation == null || topic == null) return;
    if (topic.seen && topic.readSequence >= Int64(sequence)) return;
    final attempt = '${topic.id}:$sequence';
    if (failedRead == attempt) return;
    final success = await _run(() async {
      final updated = await navigation!.markRead(
        state.section!.id,
        topic.id,
        Int64(sequence),
      );
      if (!isClosed) _replaceTopic(updated);
    });
    failedRead = success ? '' : attempt;
  }

  bool syncing = false;
  Future<void> synchronize() async {
    if (syncing ||
        state.busy ||
        isClosed ||
        navigation == null ||
        state.section == null) {
      return;
    }
    syncing = true;
    final previous = state;
    try {
      final threads = <ForumThread>[];
      var after = Int64.ZERO;
      var pinned = false;
      ListForumThreadsResponse page;
      do {
        page = await _page(previous.section!.id, after, pinned);
        threads.addAll(page.threads);
        after = page.nextSequence;
        pinned = page.nextPinned;
      } while (after != Int64.ZERO &&
          page.threads.isNotEmpty &&
          threads.length < previous.threads.length);
      final detail = await _syncDetail(previous);
      if (!isClosed && identical(state, previous)) {
        failedRead = '';
        emit(
          state.copy(
            threads: threads,
            topic: detail?.thread,
            replies: synchronizedReplies(previous, detail),
            nextReplies: _synchronizedNext(previous, detail),
            nextThreads: after.toInt(),
            nextPinned: pinned,
          ),
        );
      }
    } catch (error) {
      if (!isClosed && identical(state, previous)) _failure(error);
    } finally {
      syncing = false;
    }
  }

  List<ForumReply> synchronizedReplies(
    ForumState previous,
    GetForumThreadResponse? detail,
  ) {
    if (moderation != null && detail != null) return detail.replies;
    if (detail == null || previous.nextReplies != 0) return previous.replies;
    return [...previous.replies, ...detail.replies];
  }

  int? _synchronizedNext(ForumState previous, GetForumThreadResponse? detail) {
    if (moderation != null) return detail?.nextSequence.toInt();
    return previous.nextReplies != 0
        ? previous.nextReplies
        : detail?.nextSequence.toInt();
  }

  void _replaceTopic(ForumThread topic) => emit(
    state.copy(
      topic: topic,
      threads: state.threads.map((t) => t.id == topic.id ? topic : t).toList(),
    ),
  );
}
