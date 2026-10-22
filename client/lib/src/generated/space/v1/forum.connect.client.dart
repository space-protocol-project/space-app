//
//  Generated code. Do not modify.
//  source: space/v1/forum.proto
//

import "package:connectrpc/connect.dart" as connect;
import "forum.pb.dart" as spacev1forum;
import "forum.connect.spec.dart" as specs;

/// core.forum.v1: отдельные открытые форумные разделы с ACL канала.
extension type ForumServiceClient (connect.Transport _transport) {
  Future<spacev1forum.ListForumThreadsResponse> listForumThreads(
    spacev1forum.ListForumThreadsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ForumService.listForumThreads,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1forum.GetForumThreadResponse> getForumThread(
    spacev1forum.GetForumThreadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ForumService.getForumThread,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1forum.CreateForumThreadResponse> createForumThread(
    spacev1forum.CreateForumThreadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ForumService.createForumThread,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1forum.ReplyForumThreadResponse> replyForumThread(
    spacev1forum.ReplyForumThreadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ForumService.replyForumThread,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1forum.SetForumThreadPinnedResponse> setForumThreadPinned(
    spacev1forum.SetForumThreadPinnedRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ForumService.setForumThreadPinned,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1forum.MarkForumThreadReadResponse> markForumThreadRead(
    spacev1forum.MarkForumThreadReadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ForumService.markForumThreadRead,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1forum.CloseForumThreadResponse> closeForumThread(
    spacev1forum.CloseForumThreadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ForumService.closeForumThread,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
