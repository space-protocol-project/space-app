import 'dart:async';

import 'generated/space/v1/community_mentions.pb.dart';
import 'generated/space/v1/community_search.pb.dart';
import 'community_mentions.dart';
import 'community_mentions_api.dart';

import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';

import 'attachments.dart';
import 'core.dart' show newRequestKey;
import 'feed_api.dart';
import 'generated/space/v1/feed.pb.dart';
import 'generated/space/v1/space.pb.dart' show Channel;

part 'feed_controller.freezed.dart';

@freezed
abstract class FeedState with _$FeedState {
  const factory FeedState({
    @Default(false) bool loading,
    @Default(false) bool busy,
    @Default(false) bool supported,
    @Default([]) List<Channel> sections,
    Channel? section,
    @Default([]) List<FeedPost> posts,
    FeedPost? post,
    @Default([]) List<FeedComment> comments,
    @Default(0) int before,
    @Default(0) int after,
    @Default(0) int commentStart,
    FeedPermissions? permissions,
    Object? error,
  }) = _FeedState;
}

class FeedController extends Cubit<FeedState> {
  FeedController(this.api) : super(const FeedState());
  final FeedApi api;
  late final mentionReads = MentionReadCubit.fromSource(api);
  void markMentionsVisible(Set<int> sequences) {
    final channel = state.section?.id;
    final root = state.post;
    if (channel == null || root == null || root.hidden) return;
    final refs = <CommunityContentReference?>[
      if (sequences.contains(0))
        mentionedContent(
          mentionReads.api,
          root.mentions,
          CommunitySearchKind.COMMUNITY_SEARCH_KIND_FEED_POST,
          root.id,
        ),
      for (final child in state.comments.where(
        (c) => !c.hidden && sequences.contains(c.sequence.toInt()),
      ))
        mentionedContent(
          mentionReads.api,
          child.mentions,
          CommunitySearchKind.COMMUNITY_SEARCH_KIND_FEED_COMMENT,
          child.id,
        ),
    ];
    unawaited(mentionReads.visible(channel, refs.nonNulls.toList()));
  }

  final _drafts = <String, FeedDraftCubit>{};
  bool _reading = false;
  String _failedRead = '';
  FeedReadApi? get readApi => api is FeedReadApi ? api as FeedReadApi : null;
  bool get readingSupported =>
      readApi?.readSupported == true &&
      state.post?.readStateSupported == true &&
      state.post?.hidden == false;
  bool get readHasGap =>
      state.commentStart > (state.post?.readSequence.toInt() ?? 0);
  bool get _canMark =>
      readingSupported &&
      !_reading &&
      !state.loading &&
      !state.busy &&
      !isClosed;
  int _generation = 0;
  bool _current(int generation) => !isClosed && _generation == generation;

  Future<void> refresh() async {
    if (state.loading || state.busy) return;
    final generation = ++_generation;
    _failedRead = '';
    mentionReads.retry();
    final previous = state;
    emit(state.copyWith(loading: true, error: null));
    try {
      final fresh = await _snapshot(previous, generation);
      if (_current(generation) && fresh != null) emit(fresh);
    } catch (error) {
      _failure(generation, error);
    }
  }

  Future<FeedState?> _snapshot(FeedState previous, int generation) async {
    await api.refresh();
    if (!_current(generation)) return null;
    final sections = api.sections;
    final section =
        sections.where((c) => c.id == previous.section?.id).firstOrNull ??
        sections.firstOrNull;
    if (!api.supported || section == null) {
      return FeedState(supported: api.supported, sections: sections);
    }
    final page = await _allPosts(section.id, previous.posts.length);
    GetFeedPostResponse? detail;
    if (previous.post != null && section.id == previous.section?.id) {
      detail = await _allComments(
        section.id,
        previous.post!.id,
        previous.comments.length,
      );
    }
    return FeedState(
      supported: true,
      sections: sections,
      section: section,
      posts: _updatedPosts(page.posts, detail?.post),
      before: page.nextBeforeSequence.toInt(),
      post: detail?.post,
      comments: detail?.comments ?? [],
      after: detail?.nextSequence.toInt() ?? 0,
      permissions: detail?.permissions ?? page.permissions,
    );
  }

  Future<ListFeedPostsResponse> _allPosts(String channel, int keep) async {
    final posts = <FeedPost>[];
    var before = Int64.ZERO;
    ListFeedPostsResponse page;
    do {
      page = await api.posts(channel, before);
      posts.addAll(page.posts);
      before = page.nextBeforeSequence;
    } while (before != Int64.ZERO && posts.length < keep);
    return ListFeedPostsResponse(
      posts: posts,
      nextBeforeSequence: before,
      permissions: page.permissions,
    );
  }

  Future<GetFeedPostResponse> _allComments(
    String channel,
    String id,
    int keep,
  ) async {
    final comments = <FeedComment>[];
    var after = Int64.ZERO;
    GetFeedPostResponse page;
    do {
      page = await api.post(channel, id, after);
      if (page.post.hidden) {
        return GetFeedPostResponse(
          post: page.post,
          permissions: page.permissions,
        );
      }
      comments.addAll(page.comments);
      after = page.nextSequence;
    } while (after != Int64.ZERO && comments.length < keep);
    return GetFeedPostResponse(
      post: page.post,
      comments: comments,
      nextSequence: after,
      permissions: page.permissions,
    );
  }

  Future<void> select(Channel section) async {
    if (isClosed) return;
    ++_generation;
    emit(
      FeedState(
        supported: state.supported,
        sections: state.sections,
        section: section,
      ),
    );
    await refresh();
  }

  Future<void> open(String id, {int afterSequence = 0}) async {
    final channel = state.section?.id;
    if (channel == null) return;
    final generation = ++_generation;
    emit(
      state.copyWith(
        loading: true,
        post: null,
        comments: [],
        after: 0,
        error: null,
      ),
    );
    try {
      final page = await api.post(channel, id, Int64(afterSequence));
      if (_current(generation)) {
        emit(
          state.copyWith(
            loading: false,
            post: page.post,
            posts: _updatedPosts(state.posts, page.post),
            comments: page.comments,
            after: page.nextSequence.toInt(),
            commentStart: afterSequence,
            permissions: page.permissions,
          ),
        );
      }
    } catch (error) {
      _failure(generation, error);
    }
  }

  void back() {
    ++_generation;
    emit(state.copyWith(loading: false, post: null, comments: [], after: 0));
  }

  Future<void> markRead() async {
    _failedRead = '';
    mentionReads.retry();
    final visible = state.comments.where((comment) => !comment.hidden);
    await _markThrough(
      readHasGap ? 0 : visible.lastOrNull?.sequence.toInt() ?? 0,
    );
  }

  Future<void> openUnread() async {
    final post = state.post;
    if (post == null) return;
    await open(post.id, afterSequence: post.readSequence.toInt());
  }

  Future<void> markVisible(int sequence) async {
    final post = state.post;
    if (post == null) return;
    // Поиск мог пропустить ранние непрочитанные комментарии.
    await _markThrough(readHasGap ? 0 : sequence);
  }

  Future<void> _markThrough(int sequence) async {
    final post = state.post;
    if (!_canMark) return;
    if (post!.seen && post.readSequence >= Int64(sequence)) return;
    final channel = state.section!.id;
    final attempt = '$channel/${post.id}/$sequence';
    if (_failedRead == attempt) return;
    _reading = true;
    final generation = _generation;
    try {
      final updated = await readApi!.markRead(
        channel,
        post.id,
        Int64(sequence),
      );
      if (!_current(generation)) return;
      _failedRead = '';
      mentionReads.retry();
      emit(
        state.copyWith(
          post: updated,
          posts: _updatedPosts(state.posts, updated),
          error: null,
        ),
      );
    } catch (error) {
      if (_current(generation)) _failedRead = attempt;
      _failure(generation, error);
    } finally {
      _reading = false;
    }
  }

  Future<void> more() async {
    final previous = state;
    if (previous.section == null || previous.loading || previous.busy) return;
    final generation = ++_generation;
    emit(state.copyWith(loading: true, error: null));
    try {
      final fresh = await _nextPage(previous);
      if (_current(generation)) emit(fresh);
    } catch (error) {
      _failure(generation, error);
    }
  }

  Future<FeedState> _nextPage(FeedState previous) async {
    final channel = previous.section!.id;
    if (previous.post == null) {
      final page = await api.posts(channel, Int64(previous.before));
      return previous.copyWith(
        loading: false,
        error: null,
        posts: [...previous.posts, ...page.posts],
        before: page.nextBeforeSequence.toInt(),
        permissions: page.permissions,
      );
    }
    final page = await api.post(
      channel,
      previous.post!.id,
      Int64(previous.after),
    );
    return previous.copyWith(
      loading: false,
      error: null,
      post: page.post,
      posts: _updatedPosts(previous.posts, page.post),
      comments: page.post.hidden
          ? []
          : [...previous.comments, ...page.comments],
      after: page.nextSequence.toInt(),
      permissions: page.permissions,
    );
  }

  void _failure(int generation, Object error) {
    if (!_current(generation)) return;
    final denied =
        error is GrpcError &&
        [
          StatusCode.permissionDenied,
          StatusCode.notFound,
          StatusCode.unauthenticated,
        ].contains(error.code);
    if (denied) {
      emit(FeedState(supported: state.supported, error: error));
    } else {
      emit(state.copyWith(loading: false, busy: false, error: error));
    }
  }

  List<FeedPost> _updatedPosts(List<FeedPost> posts, FeedPost? updated) =>
      posts.map((post) => post.id == updated?.id ? updated! : post).toList();

  FeedDraftCubit draft() {
    final channel = state.section!.id;
    final post = state.post?.id ?? '';
    return _drafts.putIfAbsent(
      '$channel/$post',
      () => FeedDraftCubit(
        api: api,
        channel: channel,
        post: post,
        sent: () async {
          if (state.section?.id == channel && (state.post?.id ?? '') == post) {
            await refresh();
          }
        },
      ),
    );
  }

  Future<bool> moderate({FeedComment? comment, required String reason}) async {
    final channel = state.section!.id;
    final post = state.post!;
    final generation = ++_generation;
    emit(state.copyWith(busy: true, error: null));
    try {
      if (comment == null) {
        await api.moderatePost(
          ModerateFeedPostRequest(
            channelId: channel,
            postId: post.id,
            hidden: !post.hidden,
            reason: reason,
            expectedRevision: post.revision,
          ),
        );
      } else {
        await api.moderateComment(
          ModerateFeedCommentRequest(
            channelId: channel,
            postId: post.id,
            commentId: comment.id,
            hidden: !comment.hidden,
            reason: reason,
            expectedRevision: comment.revision,
          ),
        );
      }
      if (!_current(generation)) return false;
      emit(state.copyWith(busy: false));
      await refresh();
      return state.error == null;
    } catch (error) {
      _failure(generation, error);
      return false;
    }
  }

  @override
  Future<void> close() async {
    await mentionReads.close();
    ++_generation;
    for (final draft in _drafts.values) {
      await draft.close();
    }
    await super.close();
  }
}

@freezed
abstract class FeedDraftState with _$FeedDraftState {
  const factory FeedDraftState({
    @Default('') String text,
    @Default('') String key,
    @Default('') String payload,
    @Default('') String replyTo,
    @Default(0) int replySequence,
    @Default('') String repostOf,
    @Default(false) bool busy,
    @Default(false) bool failed,
  }) = _FeedDraftState;
}

class FeedDraftCubit extends Cubit<FeedDraftState> {
  FeedDraftCubit({
    required this.api,
    required this.channel,
    required this.post,
    required this.sent,
  }) : super(const FeedDraftState());
  final FeedApi api;
  final String channel, post;
  final Future<void> Function() sent;
  final queue = AttachmentQueue();
  final mentions = MentionDraftCubit();
  void reply(FeedComment comment) {
    if (state.busy || isClosed || !api.socialSupported) return;
    if (post.isEmpty || comment.postId != post || comment.hidden) return;
    emit(state.copyWith(replyTo: comment.id, replySequence: comment.sequence.toInt()));
  }

  void repost(FeedPost original) {
    if (state.busy || isClosed || !api.socialSupported) return;
    if (post.isNotEmpty || original.channelId != channel || original.hidden) return;
    final id = original.repostOf.isEmpty ? original.id : original.repostOf;
    emit(state.copyWith(repostOf: id));
  }

  void clearReference() {
    if (state.busy || isClosed) return;
    emit(state.copyWith(replyTo: '', replySequence: 0, repostOf: ''));
  }

  void change(String text) {
    if (state.busy || isClosed) return;
    mentions.change(text);
    emit(state.copyWith(text: text));
  }

  Future<bool> send() async {
    if (state.busy || queue.state.busy || isClosed) return false;
    final text = state.text.trim();
    if (_invalid(text)) {
      emit(state.copyWith(failed: true));
      return false;
    }
    final payload = jsonEncode([
      text,
      mentions.trimmed.map((m) => m.toProto3Json()).toList(),
      queue.state.files.map((f) => f.key).toList(),
      state.replyTo,
      state.repostOf,
    ]);
    final key = payload == state.payload ? state.key : newRequestKey();
    emit(state.copyWith(busy: true, failed: false, key: key, payload: payload));
    try {
      final ids = await _files();
      if (isClosed) return false;
      await _submit(text, key, ids);
      if (isClosed) return false;
      queue.clear();
      mentions.change('');
      emit(const FeedDraftState());
      await sent();
      return true;
    } catch (_) {
      if (!isClosed) emit(state.copyWith(busy: false, failed: true));
      return false;
    }
  }

  bool _invalid(String text) =>
      utf8.encode(text).length > 8192 ||
      (text.isEmpty && queue.state.files.isEmpty && state.repostOf.isEmpty);

  Future<void> _submit(String text, String key, List<String> ids) async {
    if (!api.socialSupported && (state.replyTo.isNotEmpty || state.repostOf.isNotEmpty)) {
      throw StateError('Социальная лента недоступна');
    }
    if (mentions.trimmed.isNotEmpty && communityMentionsFor(api) == null) {
      throw StateError('Упоминания недоступны');
    }
    if (post.isEmpty) {
      await api.publish(
        CreateFeedPostRequest(
          channelId: channel,
          text: text,
          idempotencyKey: key,
          attachmentIds: ids,
          mentions: mentions.trimmed,
          repostOf: state.repostOf,
        ),
      );
    } else {
      await api.comment(
        CommentFeedPostRequest(
          channelId: channel,
          postId: post,
          text: text,
          idempotencyKey: key,
          attachmentIds: ids,
          mentions: mentions.trimmed,
          replyToCommentId: state.replyTo,
        ),
      );
    }
  }

  Future<List<String>> _files() async {
    if (queue.state.files.isEmpty) return [];
    final session = api.attachmentSession;
    if (session == null || !api.attachmentsEnabled) {
      throw StateError('Вложения недоступны');
    }
    final ids = await queue.upload(session, channel);
    if (ids == null) throw StateError('Файлы не загружены');
    return ids;
  }

  @override
  Future<void> close() async {
    queue.cancel();
    await queue.close();
    await mentions.close();
    await super.close();
  }
}
