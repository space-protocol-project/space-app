// This is a generated file - do not edit.
//
// Generated from space/v1/forum.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'forum.pb.dart' as $1;
import 'forum.pbjson.dart';

export 'forum.pb.dart';

abstract class ForumServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ListForumThreadsResponse> listForumThreads(
      $pb.ServerContext ctx, $1.ListForumThreadsRequest request);
  $async.Future<$1.GetForumThreadResponse> getForumThread(
      $pb.ServerContext ctx, $1.GetForumThreadRequest request);
  $async.Future<$1.CreateForumThreadResponse> createForumThread(
      $pb.ServerContext ctx, $1.CreateForumThreadRequest request);
  $async.Future<$1.ReplyForumThreadResponse> replyForumThread(
      $pb.ServerContext ctx, $1.ReplyForumThreadRequest request);
  $async.Future<$1.SetForumThreadPinnedResponse> setForumThreadPinned(
      $pb.ServerContext ctx, $1.SetForumThreadPinnedRequest request);
  $async.Future<$1.MarkForumThreadReadResponse> markForumThreadRead(
      $pb.ServerContext ctx, $1.MarkForumThreadReadRequest request);
  $async.Future<$1.CloseForumThreadResponse> closeForumThread(
      $pb.ServerContext ctx, $1.CloseForumThreadRequest request);
  $async.Future<$1.ModerateForumThreadResponse> moderateForumThread(
      $pb.ServerContext ctx, $1.ModerateForumThreadRequest request);
  $async.Future<$1.ModerateForumReplyResponse> moderateForumReply(
      $pb.ServerContext ctx, $1.ModerateForumReplyRequest request);
  $async.Future<$1.ListForumModerationResponse> listForumModeration(
      $pb.ServerContext ctx, $1.ListForumModerationRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListForumThreads':
        return $1.ListForumThreadsRequest();
      case 'GetForumThread':
        return $1.GetForumThreadRequest();
      case 'CreateForumThread':
        return $1.CreateForumThreadRequest();
      case 'ReplyForumThread':
        return $1.ReplyForumThreadRequest();
      case 'SetForumThreadPinned':
        return $1.SetForumThreadPinnedRequest();
      case 'MarkForumThreadRead':
        return $1.MarkForumThreadReadRequest();
      case 'CloseForumThread':
        return $1.CloseForumThreadRequest();
      case 'ModerateForumThread':
        return $1.ModerateForumThreadRequest();
      case 'ModerateForumReply':
        return $1.ModerateForumReplyRequest();
      case 'ListForumModeration':
        return $1.ListForumModerationRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListForumThreads':
        return listForumThreads(ctx, request as $1.ListForumThreadsRequest);
      case 'GetForumThread':
        return getForumThread(ctx, request as $1.GetForumThreadRequest);
      case 'CreateForumThread':
        return createForumThread(ctx, request as $1.CreateForumThreadRequest);
      case 'ReplyForumThread':
        return replyForumThread(ctx, request as $1.ReplyForumThreadRequest);
      case 'SetForumThreadPinned':
        return setForumThreadPinned(
            ctx, request as $1.SetForumThreadPinnedRequest);
      case 'MarkForumThreadRead':
        return markForumThreadRead(
            ctx, request as $1.MarkForumThreadReadRequest);
      case 'CloseForumThread':
        return closeForumThread(ctx, request as $1.CloseForumThreadRequest);
      case 'ModerateForumThread':
        return moderateForumThread(
            ctx, request as $1.ModerateForumThreadRequest);
      case 'ModerateForumReply':
        return moderateForumReply(ctx, request as $1.ModerateForumReplyRequest);
      case 'ListForumModeration':
        return listForumModeration(
            ctx, request as $1.ListForumModerationRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ForumServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ForumServiceBase$messageJson;
}
