// This is a generated file - do not edit.
//
// Generated from space/v1/feed.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'feed.pb.dart' as $1;
import 'feed.pbjson.dart';

export 'feed.pb.dart';

abstract class FeedServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ListFeedPostsResponse> listFeedPosts(
      $pb.ServerContext ctx, $1.ListFeedPostsRequest request);
  $async.Future<$1.GetFeedPostResponse> getFeedPost(
      $pb.ServerContext ctx, $1.GetFeedPostRequest request);
  $async.Future<$1.CreateFeedPostResponse> createFeedPost(
      $pb.ServerContext ctx, $1.CreateFeedPostRequest request);
  $async.Future<$1.CommentFeedPostResponse> commentFeedPost(
      $pb.ServerContext ctx, $1.CommentFeedPostRequest request);
  $async.Future<$1.GetFeedAccessResponse> getFeedAccess(
      $pb.ServerContext ctx, $1.GetFeedAccessRequest request);
  $async.Future<$1.UpdateFeedAccessResponse> updateFeedAccess(
      $pb.ServerContext ctx, $1.UpdateFeedAccessRequest request);
  $async.Future<$1.ModerateFeedPostResponse> moderateFeedPost(
      $pb.ServerContext ctx, $1.ModerateFeedPostRequest request);
  $async.Future<$1.ModerateFeedCommentResponse> moderateFeedComment(
      $pb.ServerContext ctx, $1.ModerateFeedCommentRequest request);
  $async.Future<$1.ListFeedModerationResponse> listFeedModeration(
      $pb.ServerContext ctx, $1.ListFeedModerationRequest request);
  $async.Future<$1.ReportFeedContentResponse> reportFeedContent(
      $pb.ServerContext ctx, $1.ReportFeedContentRequest request);
  $async.Future<$1.ListFeedReportsResponse> listFeedReports(
      $pb.ServerContext ctx, $1.ListFeedReportsRequest request);
  $async.Future<$1.ResolveFeedReportResponse> resolveFeedReport(
      $pb.ServerContext ctx, $1.ResolveFeedReportRequest request);
  $async.Future<$1.MarkFeedPostReadResponse> markFeedPostRead(
      $pb.ServerContext ctx, $1.MarkFeedPostReadRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListFeedPosts':
        return $1.ListFeedPostsRequest();
      case 'GetFeedPost':
        return $1.GetFeedPostRequest();
      case 'CreateFeedPost':
        return $1.CreateFeedPostRequest();
      case 'CommentFeedPost':
        return $1.CommentFeedPostRequest();
      case 'GetFeedAccess':
        return $1.GetFeedAccessRequest();
      case 'UpdateFeedAccess':
        return $1.UpdateFeedAccessRequest();
      case 'ModerateFeedPost':
        return $1.ModerateFeedPostRequest();
      case 'ModerateFeedComment':
        return $1.ModerateFeedCommentRequest();
      case 'ListFeedModeration':
        return $1.ListFeedModerationRequest();
      case 'ReportFeedContent':
        return $1.ReportFeedContentRequest();
      case 'ListFeedReports':
        return $1.ListFeedReportsRequest();
      case 'ResolveFeedReport':
        return $1.ResolveFeedReportRequest();
      case 'MarkFeedPostRead':
        return $1.MarkFeedPostReadRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListFeedPosts':
        return listFeedPosts(ctx, request as $1.ListFeedPostsRequest);
      case 'GetFeedPost':
        return getFeedPost(ctx, request as $1.GetFeedPostRequest);
      case 'CreateFeedPost':
        return createFeedPost(ctx, request as $1.CreateFeedPostRequest);
      case 'CommentFeedPost':
        return commentFeedPost(ctx, request as $1.CommentFeedPostRequest);
      case 'GetFeedAccess':
        return getFeedAccess(ctx, request as $1.GetFeedAccessRequest);
      case 'UpdateFeedAccess':
        return updateFeedAccess(ctx, request as $1.UpdateFeedAccessRequest);
      case 'ModerateFeedPost':
        return moderateFeedPost(ctx, request as $1.ModerateFeedPostRequest);
      case 'ModerateFeedComment':
        return moderateFeedComment(
            ctx, request as $1.ModerateFeedCommentRequest);
      case 'ListFeedModeration':
        return listFeedModeration(ctx, request as $1.ListFeedModerationRequest);
      case 'ReportFeedContent':
        return reportFeedContent(ctx, request as $1.ReportFeedContentRequest);
      case 'ListFeedReports':
        return listFeedReports(ctx, request as $1.ListFeedReportsRequest);
      case 'ResolveFeedReport':
        return resolveFeedReport(ctx, request as $1.ResolveFeedReportRequest);
      case 'MarkFeedPostRead':
        return markFeedPostRead(ctx, request as $1.MarkFeedPostReadRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => FeedServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => FeedServiceBase$messageJson;
}
