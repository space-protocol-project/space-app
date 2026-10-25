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

import 'feed.pb.dart' as $2;
import 'feed.pbjson.dart';

export 'feed.pb.dart';

abstract class FeedServiceBase extends $pb.GeneratedService {
  $async.Future<$2.ListFeedPostsResponse> listFeedPosts(
      $pb.ServerContext ctx, $2.ListFeedPostsRequest request);
  $async.Future<$2.GetFeedPostResponse> getFeedPost(
      $pb.ServerContext ctx, $2.GetFeedPostRequest request);
  $async.Future<$2.CreateFeedPostResponse> createFeedPost(
      $pb.ServerContext ctx, $2.CreateFeedPostRequest request);
  $async.Future<$2.CommentFeedPostResponse> commentFeedPost(
      $pb.ServerContext ctx, $2.CommentFeedPostRequest request);
  $async.Future<$2.GetFeedAccessResponse> getFeedAccess(
      $pb.ServerContext ctx, $2.GetFeedAccessRequest request);
  $async.Future<$2.UpdateFeedAccessResponse> updateFeedAccess(
      $pb.ServerContext ctx, $2.UpdateFeedAccessRequest request);
  $async.Future<$2.ModerateFeedPostResponse> moderateFeedPost(
      $pb.ServerContext ctx, $2.ModerateFeedPostRequest request);
  $async.Future<$2.ModerateFeedCommentResponse> moderateFeedComment(
      $pb.ServerContext ctx, $2.ModerateFeedCommentRequest request);
  $async.Future<$2.ListFeedModerationResponse> listFeedModeration(
      $pb.ServerContext ctx, $2.ListFeedModerationRequest request);
  $async.Future<$2.ReportFeedContentResponse> reportFeedContent(
      $pb.ServerContext ctx, $2.ReportFeedContentRequest request);
  $async.Future<$2.ListFeedReportsResponse> listFeedReports(
      $pb.ServerContext ctx, $2.ListFeedReportsRequest request);
  $async.Future<$2.ResolveFeedReportResponse> resolveFeedReport(
      $pb.ServerContext ctx, $2.ResolveFeedReportRequest request);
  $async.Future<$2.MarkFeedPostReadResponse> markFeedPostRead(
      $pb.ServerContext ctx, $2.MarkFeedPostReadRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListFeedPosts':
        return $2.ListFeedPostsRequest();
      case 'GetFeedPost':
        return $2.GetFeedPostRequest();
      case 'CreateFeedPost':
        return $2.CreateFeedPostRequest();
      case 'CommentFeedPost':
        return $2.CommentFeedPostRequest();
      case 'GetFeedAccess':
        return $2.GetFeedAccessRequest();
      case 'UpdateFeedAccess':
        return $2.UpdateFeedAccessRequest();
      case 'ModerateFeedPost':
        return $2.ModerateFeedPostRequest();
      case 'ModerateFeedComment':
        return $2.ModerateFeedCommentRequest();
      case 'ListFeedModeration':
        return $2.ListFeedModerationRequest();
      case 'ReportFeedContent':
        return $2.ReportFeedContentRequest();
      case 'ListFeedReports':
        return $2.ListFeedReportsRequest();
      case 'ResolveFeedReport':
        return $2.ResolveFeedReportRequest();
      case 'MarkFeedPostRead':
        return $2.MarkFeedPostReadRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListFeedPosts':
        return listFeedPosts(ctx, request as $2.ListFeedPostsRequest);
      case 'GetFeedPost':
        return getFeedPost(ctx, request as $2.GetFeedPostRequest);
      case 'CreateFeedPost':
        return createFeedPost(ctx, request as $2.CreateFeedPostRequest);
      case 'CommentFeedPost':
        return commentFeedPost(ctx, request as $2.CommentFeedPostRequest);
      case 'GetFeedAccess':
        return getFeedAccess(ctx, request as $2.GetFeedAccessRequest);
      case 'UpdateFeedAccess':
        return updateFeedAccess(ctx, request as $2.UpdateFeedAccessRequest);
      case 'ModerateFeedPost':
        return moderateFeedPost(ctx, request as $2.ModerateFeedPostRequest);
      case 'ModerateFeedComment':
        return moderateFeedComment(
            ctx, request as $2.ModerateFeedCommentRequest);
      case 'ListFeedModeration':
        return listFeedModeration(ctx, request as $2.ListFeedModerationRequest);
      case 'ReportFeedContent':
        return reportFeedContent(ctx, request as $2.ReportFeedContentRequest);
      case 'ListFeedReports':
        return listFeedReports(ctx, request as $2.ListFeedReportsRequest);
      case 'ResolveFeedReport':
        return resolveFeedReport(ctx, request as $2.ResolveFeedReportRequest);
      case 'MarkFeedPostRead':
        return markFeedPostRead(ctx, request as $2.MarkFeedPostReadRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => FeedServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => FeedServiceBase$messageJson;
}
