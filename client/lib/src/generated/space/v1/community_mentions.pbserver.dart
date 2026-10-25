// This is a generated file - do not edit.
//
// Generated from space/v1/community_mentions.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'community_mentions.pb.dart' as $1;
import 'community_mentions.pbjson.dart';

export 'community_mentions.pb.dart';

abstract class CommunityMentionServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ListMentionCandidatesResponse> listMentionCandidates(
      $pb.ServerContext ctx, $1.ListMentionCandidatesRequest request);
  $async.Future<$1.MarkCommunityMentionsReadResponse> markCommunityMentionsRead(
      $pb.ServerContext ctx, $1.MarkCommunityMentionsReadRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListMentionCandidates':
        return $1.ListMentionCandidatesRequest();
      case 'MarkCommunityMentionsRead':
        return $1.MarkCommunityMentionsReadRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListMentionCandidates':
        return listMentionCandidates(
            ctx, request as $1.ListMentionCandidatesRequest);
      case 'MarkCommunityMentionsRead':
        return markCommunityMentionsRead(
            ctx, request as $1.MarkCommunityMentionsReadRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      CommunityMentionServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => CommunityMentionServiceBase$messageJson;
}
