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

import 'forum.pb.dart' as $2;
import 'forum.pbjson.dart';

export 'forum.pb.dart';

abstract class ForumServiceBase extends $pb.GeneratedService {
  $async.Future<$2.ReportForumContentResponse> reportForumContent(
      $pb.ServerContext ctx, $2.ReportForumContentRequest request);
  $async.Future<$2.ListForumReportsResponse> listForumReports(
      $pb.ServerContext ctx, $2.ListForumReportsRequest request);
  $async.Future<$2.ResolveForumReportResponse> resolveForumReport(
      $pb.ServerContext ctx, $2.ResolveForumReportRequest request);
  $async.Future<$2.ListForumThreadsResponse> listForumThreads(
      $pb.ServerContext ctx, $2.ListForumThreadsRequest request);
  $async.Future<$2.GetForumThreadResponse> getForumThread(
      $pb.ServerContext ctx, $2.GetForumThreadRequest request);
  $async.Future<$2.CreateForumThreadResponse> createForumThread(
      $pb.ServerContext ctx, $2.CreateForumThreadRequest request);
  $async.Future<$2.ReplyForumThreadResponse> replyForumThread(
      $pb.ServerContext ctx, $2.ReplyForumThreadRequest request);
  $async.Future<$2.SetForumThreadPinnedResponse> setForumThreadPinned(
      $pb.ServerContext ctx, $2.SetForumThreadPinnedRequest request);
  $async.Future<$2.MarkForumThreadReadResponse> markForumThreadRead(
      $pb.ServerContext ctx, $2.MarkForumThreadReadRequest request);
  $async.Future<$2.CloseForumThreadResponse> closeForumThread(
      $pb.ServerContext ctx, $2.CloseForumThreadRequest request);
  $async.Future<$2.ModerateForumThreadResponse> moderateForumThread(
      $pb.ServerContext ctx, $2.ModerateForumThreadRequest request);
  $async.Future<$2.ModerateForumReplyResponse> moderateForumReply(
      $pb.ServerContext ctx, $2.ModerateForumReplyRequest request);
  $async.Future<$2.ListForumModerationResponse> listForumModeration(
      $pb.ServerContext ctx, $2.ListForumModerationRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ReportForumContent':
        return $2.ReportForumContentRequest();
      case 'ListForumReports':
        return $2.ListForumReportsRequest();
      case 'ResolveForumReport':
        return $2.ResolveForumReportRequest();
      case 'ListForumThreads':
        return $2.ListForumThreadsRequest();
      case 'GetForumThread':
        return $2.GetForumThreadRequest();
      case 'CreateForumThread':
        return $2.CreateForumThreadRequest();
      case 'ReplyForumThread':
        return $2.ReplyForumThreadRequest();
      case 'SetForumThreadPinned':
        return $2.SetForumThreadPinnedRequest();
      case 'MarkForumThreadRead':
        return $2.MarkForumThreadReadRequest();
      case 'CloseForumThread':
        return $2.CloseForumThreadRequest();
      case 'ModerateForumThread':
        return $2.ModerateForumThreadRequest();
      case 'ModerateForumReply':
        return $2.ModerateForumReplyRequest();
      case 'ListForumModeration':
        return $2.ListForumModerationRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ReportForumContent':
        return reportForumContent(ctx, request as $2.ReportForumContentRequest);
      case 'ListForumReports':
        return listForumReports(ctx, request as $2.ListForumReportsRequest);
      case 'ResolveForumReport':
        return resolveForumReport(ctx, request as $2.ResolveForumReportRequest);
      case 'ListForumThreads':
        return listForumThreads(ctx, request as $2.ListForumThreadsRequest);
      case 'GetForumThread':
        return getForumThread(ctx, request as $2.GetForumThreadRequest);
      case 'CreateForumThread':
        return createForumThread(ctx, request as $2.CreateForumThreadRequest);
      case 'ReplyForumThread':
        return replyForumThread(ctx, request as $2.ReplyForumThreadRequest);
      case 'SetForumThreadPinned':
        return setForumThreadPinned(
            ctx, request as $2.SetForumThreadPinnedRequest);
      case 'MarkForumThreadRead':
        return markForumThreadRead(
            ctx, request as $2.MarkForumThreadReadRequest);
      case 'CloseForumThread':
        return closeForumThread(ctx, request as $2.CloseForumThreadRequest);
      case 'ModerateForumThread':
        return moderateForumThread(
            ctx, request as $2.ModerateForumThreadRequest);
      case 'ModerateForumReply':
        return moderateForumReply(ctx, request as $2.ModerateForumReplyRequest);
      case 'ListForumModeration':
        return listForumModeration(
            ctx, request as $2.ListForumModerationRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ForumServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ForumServiceBase$messageJson;
}
