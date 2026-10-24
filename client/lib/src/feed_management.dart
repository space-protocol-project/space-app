import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';

import 'feed_api.dart';
import 'generated/space/v1/feed.pb.dart';

part 'feed_management.freezed.dart';

@freezed
abstract class FeedManagementState with _$FeedManagementState {
  const factory FeedManagementState({
    @Default(false) bool busy,
    @Default(false) bool resolved,
    @Default(0) int revision,
    @Default(0) int after,
    @Default([]) List<FeedAccessRule> rules,
    @Default([]) List<FeedReport> reports,
    @Default([]) List<FeedModerationEvent> log,
    Object? error,
  }) = _FeedManagementState;
}

class FeedManagement extends Cubit<FeedManagementState> {
  FeedManagement(this.api, this.channel) : super(const FeedManagementState());
  final FeedApi api;
  final String channel;
  int _generation = 0;

  Future<bool> _run(Future<void> Function(int generation) operation) async {
    if (isClosed || state.busy) return false;
    final generation = ++_generation;
    emit(state.copyWith(busy: true, error: null));
    try {
      await operation(generation);
      if (!_current(generation)) return false;
      emit(state.copyWith(busy: false));
      return true;
    } catch (error) {
      if (!_current(generation)) return false;
      final denied =
          error is GrpcError &&
          [
            StatusCode.permissionDenied,
            StatusCode.notFound,
            StatusCode.unauthenticated,
          ].contains(error.code);
      emit(
        state.copyWith(
          busy: false,
          error: error,
          reports: denied ? [] : state.reports,
          log: denied ? [] : state.log,
          rules: denied ? [] : state.rules,
          revision: denied ? 0 : state.revision,
        ),
      );
      return false;
    }
  }

  bool _current(int generation) => !isClosed && generation == _generation;

  Future<bool> loadPolicy() => _run((generation) async {
    final result = await api.access(channel);
    if (_current(generation)) {
      emit(
        state.copyWith(revision: result.revision.toInt(), rules: result.rules),
      );
    }
  });
  void rules(List<FeedAccessRule> value) {
    if (!state.busy) emit(state.copyWith(rules: value));
  }

  Future<bool> savePolicy() => _run((generation) async {
    final result = await api.saveAccess(
      UpdateFeedAccessRequest(
        channelId: channel,
        expectedRevision: Int64(state.revision),
        rules: state.rules,
      ),
    );
    if (_current(generation)) {
      emit(
        state.copyWith(revision: result.revision.toInt(), rules: result.rules),
      );
    }
  });

  Future<bool> loadReports({bool more = false, bool? resolved}) =>
      _run((generation) async {
        final selected = resolved ?? state.resolved;
        final page = await api.reports(
          channel,
          Int64(more ? state.after : 0),
          selected,
        );
        if (_current(generation)) {
          emit(
            state.copyWith(
              resolved: selected,
              reports: [
                ...(more ? state.reports : <FeedReport>[]),
                ...page.reports,
              ],
              after: page.nextId.toInt(),
            ),
          );
        }
      });

  Future<bool> resolve(FeedReport report, String decision, String reason) =>
      _run((_) async {
        final revision = decision == 'hide'
            ? await _revision(report)
            : Int64.ZERO;
        await api.resolve(
          ResolveFeedReportRequest(
            channelId: channel,
            reportId: report.id,
            decision: decision,
            reason: reason,
            expectedRevision: revision,
          ),
        );
      });
  Future<Int64> _revision(FeedReport report) async {
    var after = Int64.ZERO;
    do {
      final page = await api.post(channel, report.postId, after);
      if (report.commentId.isEmpty) return page.post.revision;
      final comment = page.comments
          .where((c) => c.id == report.commentId)
          .firstOrNull;
      if (comment != null) return comment.revision;
      after = page.nextSequence;
    } while (after != Int64.ZERO);
    throw const GrpcError.notFound();
  }

  Future<bool> report(String post, String comment, String reason) => _run(
    (_) => api.report(
      ReportFeedContentRequest(
        channelId: channel,
        postId: post,
        commentId: comment,
        reason: reason,
      ),
    ),
  );
  Future<bool> loadLog(String post, {bool more = false}) => _run((
    generation,
  ) async {
    final page = await api.log(channel, post, Int64(more ? state.after : 0));
    if (_current(generation)) {
      emit(
        state.copyWith(
          log: [
            ...(more ? state.log : <FeedModerationEvent>[]),
            ...page.events,
          ],
          after: page.nextId.toInt(),
        ),
      );
    }
  });
  @override
  Future<void> close() {
    ++_generation;
    return super.close();
  }
}
