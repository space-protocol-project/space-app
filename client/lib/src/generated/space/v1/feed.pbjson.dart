// This is a generated file - do not edit.
//
// Generated from space/v1/feed.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import 'space.pbjson.dart' as $0;

@$core.Deprecated('Use feedPermissionsDescriptor instead')
const FeedPermissions$json = {
  '1': 'FeedPermissions',
  '2': [
    {'1': 'publish', '3': 1, '4': 1, '5': 8, '10': 'publish'},
    {'1': 'comment', '3': 2, '4': 1, '5': 8, '10': 'comment'},
  ],
};

/// Descriptor for `FeedPermissions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedPermissionsDescriptor = $convert.base64Decode(
    'Cg9GZWVkUGVybWlzc2lvbnMSGAoHcHVibGlzaBgBIAEoCFIHcHVibGlzaBIYCgdjb21tZW50GA'
    'IgASgIUgdjb21tZW50');

@$core.Deprecated('Use feedPostDescriptor instead')
const FeedPost$json = {
  '1': 'FeedPost',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'author_id', '3': 3, '4': 1, '5': 9, '10': 'authorId'},
    {'1': 'author_name', '3': 4, '4': 1, '5': 9, '10': 'authorName'},
    {'1': 'text', '3': 5, '4': 1, '5': 9, '10': 'text'},
    {'1': 'created_at_unix', '3': 6, '4': 1, '5': 3, '10': 'createdAtUnix'},
    {'1': 'sequence', '3': 7, '4': 1, '5': 3, '10': 'sequence'},
    {'1': 'revision', '3': 8, '4': 1, '5': 3, '10': 'revision'},
    {'1': 'comment_count', '3': 9, '4': 1, '5': 3, '10': 'commentCount'},
    {
      '1': 'attachments',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Asset',
      '10': 'attachments'
    },
    {'1': 'hidden', '3': 11, '4': 1, '5': 8, '10': 'hidden'},
    {
      '1': 'read_state_supported',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'readStateSupported'
    },
    {'1': 'seen', '3': 13, '4': 1, '5': 8, '10': 'seen'},
    {'1': 'read_sequence', '3': 14, '4': 1, '5': 3, '10': 'readSequence'},
    {'1': 'unread_count', '3': 15, '4': 1, '5': 3, '10': 'unreadCount'},
  ],
};

/// Descriptor for `FeedPost`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedPostDescriptor = $convert.base64Decode(
    'CghGZWVkUG9zdBIOCgJpZBgBIAEoCVICaWQSHQoKY2hhbm5lbF9pZBgCIAEoCVIJY2hhbm5lbE'
    'lkEhsKCWF1dGhvcl9pZBgDIAEoCVIIYXV0aG9ySWQSHwoLYXV0aG9yX25hbWUYBCABKAlSCmF1'
    'dGhvck5hbWUSEgoEdGV4dBgFIAEoCVIEdGV4dBImCg9jcmVhdGVkX2F0X3VuaXgYBiABKANSDW'
    'NyZWF0ZWRBdFVuaXgSGgoIc2VxdWVuY2UYByABKANSCHNlcXVlbmNlEhoKCHJldmlzaW9uGAgg'
    'ASgDUghyZXZpc2lvbhIjCg1jb21tZW50X2NvdW50GAkgASgDUgxjb21tZW50Q291bnQSMQoLYX'
    'R0YWNobWVudHMYCiADKAsyDy5zcGFjZS52MS5Bc3NldFILYXR0YWNobWVudHMSFgoGaGlkZGVu'
    'GAsgASgIUgZoaWRkZW4SMAoUcmVhZF9zdGF0ZV9zdXBwb3J0ZWQYDCABKAhSEnJlYWRTdGF0ZV'
    'N1cHBvcnRlZBISCgRzZWVuGA0gASgIUgRzZWVuEiMKDXJlYWRfc2VxdWVuY2UYDiABKANSDHJl'
    'YWRTZXF1ZW5jZRIhCgx1bnJlYWRfY291bnQYDyABKANSC3VucmVhZENvdW50');

@$core.Deprecated('Use markFeedPostReadRequestDescriptor instead')
const MarkFeedPostReadRequest$json = {
  '1': 'MarkFeedPostReadRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'post_id', '3': 2, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'through_sequence', '3': 3, '4': 1, '5': 3, '10': 'throughSequence'},
  ],
};

/// Descriptor for `MarkFeedPostReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markFeedPostReadRequestDescriptor = $convert.base64Decode(
    'ChdNYXJrRmVlZFBvc3RSZWFkUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSW'
    'QSFwoHcG9zdF9pZBgCIAEoCVIGcG9zdElkEikKEHRocm91Z2hfc2VxdWVuY2UYAyABKANSD3Ro'
    'cm91Z2hTZXF1ZW5jZQ==');

@$core.Deprecated('Use markFeedPostReadResponseDescriptor instead')
const MarkFeedPostReadResponse$json = {
  '1': 'MarkFeedPostReadResponse',
  '2': [
    {
      '1': 'post',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedPost',
      '10': 'post'
    },
  ],
};

/// Descriptor for `MarkFeedPostReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markFeedPostReadResponseDescriptor =
    $convert.base64Decode(
        'ChhNYXJrRmVlZFBvc3RSZWFkUmVzcG9uc2USJgoEcG9zdBgBIAEoCzISLnNwYWNlLnYxLkZlZW'
        'RQb3N0UgRwb3N0');

@$core.Deprecated('Use feedCommentDescriptor instead')
const FeedComment$json = {
  '1': 'FeedComment',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'post_id', '3': 2, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'author_id', '3': 3, '4': 1, '5': 9, '10': 'authorId'},
    {'1': 'author_name', '3': 4, '4': 1, '5': 9, '10': 'authorName'},
    {'1': 'text', '3': 5, '4': 1, '5': 9, '10': 'text'},
    {'1': 'created_at_unix', '3': 6, '4': 1, '5': 3, '10': 'createdAtUnix'},
    {'1': 'sequence', '3': 7, '4': 1, '5': 3, '10': 'sequence'},
    {'1': 'revision', '3': 8, '4': 1, '5': 3, '10': 'revision'},
    {
      '1': 'attachments',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Asset',
      '10': 'attachments'
    },
    {'1': 'hidden', '3': 10, '4': 1, '5': 8, '10': 'hidden'},
  ],
};

/// Descriptor for `FeedComment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedCommentDescriptor = $convert.base64Decode(
    'CgtGZWVkQ29tbWVudBIOCgJpZBgBIAEoCVICaWQSFwoHcG9zdF9pZBgCIAEoCVIGcG9zdElkEh'
    'sKCWF1dGhvcl9pZBgDIAEoCVIIYXV0aG9ySWQSHwoLYXV0aG9yX25hbWUYBCABKAlSCmF1dGhv'
    'ck5hbWUSEgoEdGV4dBgFIAEoCVIEdGV4dBImCg9jcmVhdGVkX2F0X3VuaXgYBiABKANSDWNyZW'
    'F0ZWRBdFVuaXgSGgoIc2VxdWVuY2UYByABKANSCHNlcXVlbmNlEhoKCHJldmlzaW9uGAggASgD'
    'UghyZXZpc2lvbhIxCgthdHRhY2htZW50cxgJIAMoCzIPLnNwYWNlLnYxLkFzc2V0UgthdHRhY2'
    'htZW50cxIWCgZoaWRkZW4YCiABKAhSBmhpZGRlbg==');

@$core.Deprecated('Use listFeedPostsRequestDescriptor instead')
const ListFeedPostsRequest$json = {
  '1': 'ListFeedPostsRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'before_sequence', '3': 2, '4': 1, '5': 3, '10': 'beforeSequence'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListFeedPostsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFeedPostsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0RmVlZFBvc3RzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSJw'
    'oPYmVmb3JlX3NlcXVlbmNlGAIgASgDUg5iZWZvcmVTZXF1ZW5jZRIUCgVsaW1pdBgDIAEoBVIF'
    'bGltaXQ=');

@$core.Deprecated('Use listFeedPostsResponseDescriptor instead')
const ListFeedPostsResponse$json = {
  '1': 'ListFeedPostsResponse',
  '2': [
    {
      '1': 'posts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.FeedPost',
      '10': 'posts'
    },
    {
      '1': 'next_before_sequence',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'nextBeforeSequence'
    },
    {
      '1': 'permissions',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedPermissions',
      '10': 'permissions'
    },
  ],
};

/// Descriptor for `ListFeedPostsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFeedPostsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0RmVlZFBvc3RzUmVzcG9uc2USKAoFcG9zdHMYASADKAsyEi5zcGFjZS52MS5GZWVkUG'
    '9zdFIFcG9zdHMSMAoUbmV4dF9iZWZvcmVfc2VxdWVuY2UYAiABKANSEm5leHRCZWZvcmVTZXF1'
    'ZW5jZRI7CgtwZXJtaXNzaW9ucxgDIAEoCzIZLnNwYWNlLnYxLkZlZWRQZXJtaXNzaW9uc1ILcG'
    'VybWlzc2lvbnM=');

@$core.Deprecated('Use getFeedPostRequestDescriptor instead')
const GetFeedPostRequest$json = {
  '1': 'GetFeedPostRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'post_id', '3': 2, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'after_sequence', '3': 3, '4': 1, '5': 3, '10': 'afterSequence'},
    {'1': 'limit', '3': 4, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetFeedPostRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFeedPostRequestDescriptor = $convert.base64Decode(
    'ChJHZXRGZWVkUG9zdFJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbElkEhcKB3'
    'Bvc3RfaWQYAiABKAlSBnBvc3RJZBIlCg5hZnRlcl9zZXF1ZW5jZRgDIAEoA1INYWZ0ZXJTZXF1'
    'ZW5jZRIUCgVsaW1pdBgEIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use getFeedPostResponseDescriptor instead')
const GetFeedPostResponse$json = {
  '1': 'GetFeedPostResponse',
  '2': [
    {
      '1': 'post',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedPost',
      '10': 'post'
    },
    {
      '1': 'comments',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.space.v1.FeedComment',
      '10': 'comments'
    },
    {'1': 'next_sequence', '3': 3, '4': 1, '5': 3, '10': 'nextSequence'},
    {
      '1': 'permissions',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedPermissions',
      '10': 'permissions'
    },
  ],
};

/// Descriptor for `GetFeedPostResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFeedPostResponseDescriptor = $convert.base64Decode(
    'ChNHZXRGZWVkUG9zdFJlc3BvbnNlEiYKBHBvc3QYASABKAsyEi5zcGFjZS52MS5GZWVkUG9zdF'
    'IEcG9zdBIxCghjb21tZW50cxgCIAMoCzIVLnNwYWNlLnYxLkZlZWRDb21tZW50Ughjb21tZW50'
    'cxIjCg1uZXh0X3NlcXVlbmNlGAMgASgDUgxuZXh0U2VxdWVuY2USOwoLcGVybWlzc2lvbnMYBC'
    'ABKAsyGS5zcGFjZS52MS5GZWVkUGVybWlzc2lvbnNSC3Blcm1pc3Npb25z');

@$core.Deprecated('Use createFeedPostRequestDescriptor instead')
const CreateFeedPostRequest$json = {
  '1': 'CreateFeedPostRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'attachment_ids', '3': 4, '4': 3, '5': 9, '10': 'attachmentIds'},
  ],
};

/// Descriptor for `CreateFeedPostRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createFeedPostRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVGZWVkUG9zdFJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbElkEh'
    'IKBHRleHQYAiABKAlSBHRleHQSJwoPaWRlbXBvdGVuY3lfa2V5GAMgASgJUg5pZGVtcG90ZW5j'
    'eUtleRIlCg5hdHRhY2htZW50X2lkcxgEIAMoCVINYXR0YWNobWVudElkcw==');

@$core.Deprecated('Use createFeedPostResponseDescriptor instead')
const CreateFeedPostResponse$json = {
  '1': 'CreateFeedPostResponse',
  '2': [
    {
      '1': 'post',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedPost',
      '10': 'post'
    },
  ],
};

/// Descriptor for `CreateFeedPostResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createFeedPostResponseDescriptor =
    $convert.base64Decode(
        'ChZDcmVhdGVGZWVkUG9zdFJlc3BvbnNlEiYKBHBvc3QYASABKAsyEi5zcGFjZS52MS5GZWVkUG'
        '9zdFIEcG9zdA==');

@$core.Deprecated('Use commentFeedPostRequestDescriptor instead')
const CommentFeedPostRequest$json = {
  '1': 'CommentFeedPostRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'post_id', '3': 2, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'idempotency_key', '3': 4, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'attachment_ids', '3': 5, '4': 3, '5': 9, '10': 'attachmentIds'},
  ],
};

/// Descriptor for `CommentFeedPostRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentFeedPostRequestDescriptor = $convert.base64Decode(
    'ChZDb21tZW50RmVlZFBvc3RSZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW5uZWxJZB'
    'IXCgdwb3N0X2lkGAIgASgJUgZwb3N0SWQSEgoEdGV4dBgDIAEoCVIEdGV4dBInCg9pZGVtcG90'
    'ZW5jeV9rZXkYBCABKAlSDmlkZW1wb3RlbmN5S2V5EiUKDmF0dGFjaG1lbnRfaWRzGAUgAygJUg'
    '1hdHRhY2htZW50SWRz');

@$core.Deprecated('Use commentFeedPostResponseDescriptor instead')
const CommentFeedPostResponse$json = {
  '1': 'CommentFeedPostResponse',
  '2': [
    {
      '1': 'comment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedComment',
      '10': 'comment'
    },
    {
      '1': 'post',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedPost',
      '10': 'post'
    },
  ],
};

/// Descriptor for `CommentFeedPostResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentFeedPostResponseDescriptor = $convert.base64Decode(
    'ChdDb21tZW50RmVlZFBvc3RSZXNwb25zZRIvCgdjb21tZW50GAEgASgLMhUuc3BhY2UudjEuRm'
    'VlZENvbW1lbnRSB2NvbW1lbnQSJgoEcG9zdBgCIAEoCzISLnNwYWNlLnYxLkZlZWRQb3N0UgRw'
    'b3N0');

@$core.Deprecated('Use feedAccessRuleDescriptor instead')
const FeedAccessRule$json = {
  '1': 'FeedAccessRule',
  '2': [
    {'1': 'role', '3': 1, '4': 1, '5': 9, '10': 'role'},
    {'1': 'principal_id', '3': 2, '4': 1, '5': 9, '10': 'principalId'},
    {
      '1': 'permissions',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedPermissions',
      '10': 'permissions'
    },
  ],
};

/// Descriptor for `FeedAccessRule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedAccessRuleDescriptor = $convert.base64Decode(
    'Cg5GZWVkQWNjZXNzUnVsZRISCgRyb2xlGAEgASgJUgRyb2xlEiEKDHByaW5jaXBhbF9pZBgCIA'
    'EoCVILcHJpbmNpcGFsSWQSOwoLcGVybWlzc2lvbnMYAyABKAsyGS5zcGFjZS52MS5GZWVkUGVy'
    'bWlzc2lvbnNSC3Blcm1pc3Npb25z');

@$core.Deprecated('Use getFeedAccessRequestDescriptor instead')
const GetFeedAccessRequest$json = {
  '1': 'GetFeedAccessRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
  ],
};

/// Descriptor for `GetFeedAccessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFeedAccessRequestDescriptor = $convert.base64Decode(
    'ChRHZXRGZWVkQWNjZXNzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQ=');

@$core.Deprecated('Use getFeedAccessResponseDescriptor instead')
const GetFeedAccessResponse$json = {
  '1': 'GetFeedAccessResponse',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'revision', '3': 2, '4': 1, '5': 3, '10': 'revision'},
    {
      '1': 'rules',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.FeedAccessRule',
      '10': 'rules'
    },
  ],
};

/// Descriptor for `GetFeedAccessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFeedAccessResponseDescriptor = $convert.base64Decode(
    'ChVHZXRGZWVkQWNjZXNzUmVzcG9uc2USHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbElkEh'
    'oKCHJldmlzaW9uGAIgASgDUghyZXZpc2lvbhIuCgVydWxlcxgDIAMoCzIYLnNwYWNlLnYxLkZl'
    'ZWRBY2Nlc3NSdWxlUgVydWxlcw==');

@$core.Deprecated('Use updateFeedAccessRequestDescriptor instead')
const UpdateFeedAccessRequest$json = {
  '1': 'UpdateFeedAccessRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
    {
      '1': 'rules',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.FeedAccessRule',
      '10': 'rules'
    },
  ],
};

/// Descriptor for `UpdateFeedAccessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateFeedAccessRequestDescriptor = $convert.base64Decode(
    'ChdVcGRhdGVGZWVkQWNjZXNzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSW'
    'QSKwoRZXhwZWN0ZWRfcmV2aXNpb24YAiABKANSEGV4cGVjdGVkUmV2aXNpb24SLgoFcnVsZXMY'
    'AyADKAsyGC5zcGFjZS52MS5GZWVkQWNjZXNzUnVsZVIFcnVsZXM=');

@$core.Deprecated('Use updateFeedAccessResponseDescriptor instead')
const UpdateFeedAccessResponse$json = {
  '1': 'UpdateFeedAccessResponse',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'revision', '3': 2, '4': 1, '5': 3, '10': 'revision'},
    {
      '1': 'rules',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.FeedAccessRule',
      '10': 'rules'
    },
  ],
};

/// Descriptor for `UpdateFeedAccessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateFeedAccessResponseDescriptor = $convert.base64Decode(
    'ChhVcGRhdGVGZWVkQWNjZXNzUmVzcG9uc2USHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbE'
    'lkEhoKCHJldmlzaW9uGAIgASgDUghyZXZpc2lvbhIuCgVydWxlcxgDIAMoCzIYLnNwYWNlLnYx'
    'LkZlZWRBY2Nlc3NSdWxlUgVydWxlcw==');

@$core.Deprecated('Use moderateFeedPostRequestDescriptor instead')
const ModerateFeedPostRequest$json = {
  '1': 'ModerateFeedPostRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'post_id', '3': 2, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'hidden', '3': 3, '4': 1, '5': 8, '10': 'hidden'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'expected_revision',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `ModerateFeedPostRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moderateFeedPostRequestDescriptor = $convert.base64Decode(
    'ChdNb2RlcmF0ZUZlZWRQb3N0UmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSW'
    'QSFwoHcG9zdF9pZBgCIAEoCVIGcG9zdElkEhYKBmhpZGRlbhgDIAEoCFIGaGlkZGVuEhYKBnJl'
    'YXNvbhgEIAEoCVIGcmVhc29uEisKEWV4cGVjdGVkX3JldmlzaW9uGAUgASgDUhBleHBlY3RlZF'
    'JldmlzaW9u');

@$core.Deprecated('Use moderateFeedPostResponseDescriptor instead')
const ModerateFeedPostResponse$json = {
  '1': 'ModerateFeedPostResponse',
  '2': [
    {
      '1': 'post',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedPost',
      '10': 'post'
    },
  ],
};

/// Descriptor for `ModerateFeedPostResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moderateFeedPostResponseDescriptor =
    $convert.base64Decode(
        'ChhNb2RlcmF0ZUZlZWRQb3N0UmVzcG9uc2USJgoEcG9zdBgBIAEoCzISLnNwYWNlLnYxLkZlZW'
        'RQb3N0UgRwb3N0');

@$core.Deprecated('Use moderateFeedCommentRequestDescriptor instead')
const ModerateFeedCommentRequest$json = {
  '1': 'ModerateFeedCommentRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'post_id', '3': 2, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'comment_id', '3': 3, '4': 1, '5': 9, '10': 'commentId'},
    {'1': 'hidden', '3': 4, '4': 1, '5': 8, '10': 'hidden'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'expected_revision',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `ModerateFeedCommentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moderateFeedCommentRequestDescriptor = $convert.base64Decode(
    'ChpNb2RlcmF0ZUZlZWRDb21tZW50UmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubm'
    'VsSWQSFwoHcG9zdF9pZBgCIAEoCVIGcG9zdElkEh0KCmNvbW1lbnRfaWQYAyABKAlSCWNvbW1l'
    'bnRJZBIWCgZoaWRkZW4YBCABKAhSBmhpZGRlbhIWCgZyZWFzb24YBSABKAlSBnJlYXNvbhIrCh'
    'FleHBlY3RlZF9yZXZpc2lvbhgGIAEoA1IQZXhwZWN0ZWRSZXZpc2lvbg==');

@$core.Deprecated('Use moderateFeedCommentResponseDescriptor instead')
const ModerateFeedCommentResponse$json = {
  '1': 'ModerateFeedCommentResponse',
  '2': [
    {
      '1': 'comment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedComment',
      '10': 'comment'
    },
    {
      '1': 'post',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedPost',
      '10': 'post'
    },
  ],
};

/// Descriptor for `ModerateFeedCommentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moderateFeedCommentResponseDescriptor =
    $convert.base64Decode(
        'ChtNb2RlcmF0ZUZlZWRDb21tZW50UmVzcG9uc2USLwoHY29tbWVudBgBIAEoCzIVLnNwYWNlLn'
        'YxLkZlZWRDb21tZW50Ugdjb21tZW50EiYKBHBvc3QYAiABKAsyEi5zcGFjZS52MS5GZWVkUG9z'
        'dFIEcG9zdA==');

@$core.Deprecated('Use listFeedModerationRequestDescriptor instead')
const ListFeedModerationRequest$json = {
  '1': 'ListFeedModerationRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'post_id', '3': 2, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'after_id', '3': 3, '4': 1, '5': 3, '10': 'afterId'},
    {'1': 'limit', '3': 4, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListFeedModerationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFeedModerationRequestDescriptor = $convert.base64Decode(
    'ChlMaXN0RmVlZE1vZGVyYXRpb25SZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW5uZW'
    'xJZBIXCgdwb3N0X2lkGAIgASgJUgZwb3N0SWQSGQoIYWZ0ZXJfaWQYAyABKANSB2FmdGVySWQS'
    'FAoFbGltaXQYBCABKAVSBWxpbWl0');

@$core.Deprecated('Use feedModerationEventDescriptor instead')
const FeedModerationEvent$json = {
  '1': 'FeedModerationEvent',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'post_id', '3': 2, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'comment_id', '3': 3, '4': 1, '5': 9, '10': 'commentId'},
    {'1': 'action', '3': 4, '4': 1, '5': 9, '10': 'action'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'actor_id', '3': 6, '4': 1, '5': 9, '10': 'actorId'},
    {'1': 'revision', '3': 7, '4': 1, '5': 3, '10': 'revision'},
    {'1': 'created_at_unix', '3': 8, '4': 1, '5': 3, '10': 'createdAtUnix'},
    {'1': 'report_id', '3': 9, '4': 1, '5': 3, '10': 'reportId'},
  ],
};

/// Descriptor for `FeedModerationEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedModerationEventDescriptor = $convert.base64Decode(
    'ChNGZWVkTW9kZXJhdGlvbkV2ZW50Eg4KAmlkGAEgASgDUgJpZBIXCgdwb3N0X2lkGAIgASgJUg'
    'Zwb3N0SWQSHQoKY29tbWVudF9pZBgDIAEoCVIJY29tbWVudElkEhYKBmFjdGlvbhgEIAEoCVIG'
    'YWN0aW9uEhYKBnJlYXNvbhgFIAEoCVIGcmVhc29uEhkKCGFjdG9yX2lkGAYgASgJUgdhY3Rvck'
    'lkEhoKCHJldmlzaW9uGAcgASgDUghyZXZpc2lvbhImCg9jcmVhdGVkX2F0X3VuaXgYCCABKANS'
    'DWNyZWF0ZWRBdFVuaXgSGwoJcmVwb3J0X2lkGAkgASgDUghyZXBvcnRJZA==');

@$core.Deprecated('Use listFeedModerationResponseDescriptor instead')
const ListFeedModerationResponse$json = {
  '1': 'ListFeedModerationResponse',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.FeedModerationEvent',
      '10': 'events'
    },
    {'1': 'next_id', '3': 2, '4': 1, '5': 3, '10': 'nextId'},
  ],
};

/// Descriptor for `ListFeedModerationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFeedModerationResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0RmVlZE1vZGVyYXRpb25SZXNwb25zZRI1CgZldmVudHMYASADKAsyHS5zcGFjZS52MS'
        '5GZWVkTW9kZXJhdGlvbkV2ZW50UgZldmVudHMSFwoHbmV4dF9pZBgCIAEoA1IGbmV4dElk');

@$core.Deprecated('Use feedReportDescriptor instead')
const FeedReport$json = {
  '1': 'FeedReport',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'post_id', '3': 2, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'comment_id', '3': 3, '4': 1, '5': 9, '10': 'commentId'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'decision', '3': 5, '4': 1, '5': 9, '10': 'decision'},
    {'1': 'decision_reason', '3': 6, '4': 1, '5': 9, '10': 'decisionReason'},
    {'1': 'moderator_id', '3': 7, '4': 1, '5': 9, '10': 'moderatorId'},
    {'1': 'created_at_unix', '3': 8, '4': 1, '5': 3, '10': 'createdAtUnix'},
    {'1': 'resolved_at_unix', '3': 9, '4': 1, '5': 3, '10': 'resolvedAtUnix'},
  ],
};

/// Descriptor for `FeedReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedReportDescriptor = $convert.base64Decode(
    'CgpGZWVkUmVwb3J0Eg4KAmlkGAEgASgDUgJpZBIXCgdwb3N0X2lkGAIgASgJUgZwb3N0SWQSHQ'
    'oKY29tbWVudF9pZBgDIAEoCVIJY29tbWVudElkEhYKBnJlYXNvbhgEIAEoCVIGcmVhc29uEhoK'
    'CGRlY2lzaW9uGAUgASgJUghkZWNpc2lvbhInCg9kZWNpc2lvbl9yZWFzb24YBiABKAlSDmRlY2'
    'lzaW9uUmVhc29uEiEKDG1vZGVyYXRvcl9pZBgHIAEoCVILbW9kZXJhdG9ySWQSJgoPY3JlYXRl'
    'ZF9hdF91bml4GAggASgDUg1jcmVhdGVkQXRVbml4EigKEHJlc29sdmVkX2F0X3VuaXgYCSABKA'
    'NSDnJlc29sdmVkQXRVbml4');

@$core.Deprecated('Use reportFeedContentRequestDescriptor instead')
const ReportFeedContentRequest$json = {
  '1': 'ReportFeedContentRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'post_id', '3': 2, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'comment_id', '3': 3, '4': 1, '5': 9, '10': 'commentId'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReportFeedContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportFeedContentRequestDescriptor = $convert.base64Decode(
    'ChhSZXBvcnRGZWVkQ29udGVudFJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbE'
    'lkEhcKB3Bvc3RfaWQYAiABKAlSBnBvc3RJZBIdCgpjb21tZW50X2lkGAMgASgJUgljb21tZW50'
    'SWQSFgoGcmVhc29uGAQgASgJUgZyZWFzb24=');

@$core.Deprecated('Use reportFeedContentResponseDescriptor instead')
const ReportFeedContentResponse$json = {
  '1': 'ReportFeedContentResponse',
};

/// Descriptor for `ReportFeedContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportFeedContentResponseDescriptor =
    $convert.base64Decode('ChlSZXBvcnRGZWVkQ29udGVudFJlc3BvbnNl');

@$core.Deprecated('Use listFeedReportsRequestDescriptor instead')
const ListFeedReportsRequest$json = {
  '1': 'ListFeedReportsRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after_id', '3': 2, '4': 1, '5': 3, '10': 'afterId'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'resolved', '3': 4, '4': 1, '5': 8, '10': 'resolved'},
  ],
};

/// Descriptor for `ListFeedReportsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFeedReportsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0RmVlZFJlcG9ydHNSZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW5uZWxJZB'
    'IZCghhZnRlcl9pZBgCIAEoA1IHYWZ0ZXJJZBIUCgVsaW1pdBgDIAEoBVIFbGltaXQSGgoIcmVz'
    'b2x2ZWQYBCABKAhSCHJlc29sdmVk');

@$core.Deprecated('Use listFeedReportsResponseDescriptor instead')
const ListFeedReportsResponse$json = {
  '1': 'ListFeedReportsResponse',
  '2': [
    {
      '1': 'reports',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.FeedReport',
      '10': 'reports'
    },
    {'1': 'next_id', '3': 2, '4': 1, '5': 3, '10': 'nextId'},
  ],
};

/// Descriptor for `ListFeedReportsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFeedReportsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0RmVlZFJlcG9ydHNSZXNwb25zZRIuCgdyZXBvcnRzGAEgAygLMhQuc3BhY2UudjEuRm'
        'VlZFJlcG9ydFIHcmVwb3J0cxIXCgduZXh0X2lkGAIgASgDUgZuZXh0SWQ=');

@$core.Deprecated('Use resolveFeedReportRequestDescriptor instead')
const ResolveFeedReportRequest$json = {
  '1': 'ResolveFeedReportRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'report_id', '3': 2, '4': 1, '5': 3, '10': 'reportId'},
    {'1': 'decision', '3': 3, '4': 1, '5': 9, '10': 'decision'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'expected_revision',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `ResolveFeedReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveFeedReportRequestDescriptor = $convert.base64Decode(
    'ChhSZXNvbHZlRmVlZFJlcG9ydFJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbE'
    'lkEhsKCXJlcG9ydF9pZBgCIAEoA1IIcmVwb3J0SWQSGgoIZGVjaXNpb24YAyABKAlSCGRlY2lz'
    'aW9uEhYKBnJlYXNvbhgEIAEoCVIGcmVhc29uEisKEWV4cGVjdGVkX3JldmlzaW9uGAUgASgDUh'
    'BleHBlY3RlZFJldmlzaW9u');

@$core.Deprecated('Use resolveFeedReportResponseDescriptor instead')
const ResolveFeedReportResponse$json = {
  '1': 'ResolveFeedReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.FeedReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `ResolveFeedReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveFeedReportResponseDescriptor =
    $convert.base64Decode(
        'ChlSZXNvbHZlRmVlZFJlcG9ydFJlc3BvbnNlEiwKBnJlcG9ydBgBIAEoCzIULnNwYWNlLnYxLk'
        'ZlZWRSZXBvcnRSBnJlcG9ydA==');

const $core.Map<$core.String, $core.dynamic> FeedServiceBase$json = {
  '1': 'FeedService',
  '2': [
    {
      '1': 'ListFeedPosts',
      '2': '.space.v1.ListFeedPostsRequest',
      '3': '.space.v1.ListFeedPostsResponse'
    },
    {
      '1': 'GetFeedPost',
      '2': '.space.v1.GetFeedPostRequest',
      '3': '.space.v1.GetFeedPostResponse'
    },
    {
      '1': 'CreateFeedPost',
      '2': '.space.v1.CreateFeedPostRequest',
      '3': '.space.v1.CreateFeedPostResponse'
    },
    {
      '1': 'CommentFeedPost',
      '2': '.space.v1.CommentFeedPostRequest',
      '3': '.space.v1.CommentFeedPostResponse'
    },
    {
      '1': 'GetFeedAccess',
      '2': '.space.v1.GetFeedAccessRequest',
      '3': '.space.v1.GetFeedAccessResponse'
    },
    {
      '1': 'UpdateFeedAccess',
      '2': '.space.v1.UpdateFeedAccessRequest',
      '3': '.space.v1.UpdateFeedAccessResponse'
    },
    {
      '1': 'ModerateFeedPost',
      '2': '.space.v1.ModerateFeedPostRequest',
      '3': '.space.v1.ModerateFeedPostResponse'
    },
    {
      '1': 'ModerateFeedComment',
      '2': '.space.v1.ModerateFeedCommentRequest',
      '3': '.space.v1.ModerateFeedCommentResponse'
    },
    {
      '1': 'ListFeedModeration',
      '2': '.space.v1.ListFeedModerationRequest',
      '3': '.space.v1.ListFeedModerationResponse'
    },
    {
      '1': 'ReportFeedContent',
      '2': '.space.v1.ReportFeedContentRequest',
      '3': '.space.v1.ReportFeedContentResponse'
    },
    {
      '1': 'ListFeedReports',
      '2': '.space.v1.ListFeedReportsRequest',
      '3': '.space.v1.ListFeedReportsResponse'
    },
    {
      '1': 'ResolveFeedReport',
      '2': '.space.v1.ResolveFeedReportRequest',
      '3': '.space.v1.ResolveFeedReportResponse'
    },
    {
      '1': 'MarkFeedPostRead',
      '2': '.space.v1.MarkFeedPostReadRequest',
      '3': '.space.v1.MarkFeedPostReadResponse'
    },
  ],
};

@$core.Deprecated('Use feedServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    FeedServiceBase$messageJson = {
  '.space.v1.ListFeedPostsRequest': ListFeedPostsRequest$json,
  '.space.v1.ListFeedPostsResponse': ListFeedPostsResponse$json,
  '.space.v1.FeedPost': FeedPost$json,
  '.space.v1.Asset': $0.Asset$json,
  '.space.v1.FeedPermissions': FeedPermissions$json,
  '.space.v1.GetFeedPostRequest': GetFeedPostRequest$json,
  '.space.v1.GetFeedPostResponse': GetFeedPostResponse$json,
  '.space.v1.FeedComment': FeedComment$json,
  '.space.v1.CreateFeedPostRequest': CreateFeedPostRequest$json,
  '.space.v1.CreateFeedPostResponse': CreateFeedPostResponse$json,
  '.space.v1.CommentFeedPostRequest': CommentFeedPostRequest$json,
  '.space.v1.CommentFeedPostResponse': CommentFeedPostResponse$json,
  '.space.v1.GetFeedAccessRequest': GetFeedAccessRequest$json,
  '.space.v1.GetFeedAccessResponse': GetFeedAccessResponse$json,
  '.space.v1.FeedAccessRule': FeedAccessRule$json,
  '.space.v1.UpdateFeedAccessRequest': UpdateFeedAccessRequest$json,
  '.space.v1.UpdateFeedAccessResponse': UpdateFeedAccessResponse$json,
  '.space.v1.ModerateFeedPostRequest': ModerateFeedPostRequest$json,
  '.space.v1.ModerateFeedPostResponse': ModerateFeedPostResponse$json,
  '.space.v1.ModerateFeedCommentRequest': ModerateFeedCommentRequest$json,
  '.space.v1.ModerateFeedCommentResponse': ModerateFeedCommentResponse$json,
  '.space.v1.ListFeedModerationRequest': ListFeedModerationRequest$json,
  '.space.v1.ListFeedModerationResponse': ListFeedModerationResponse$json,
  '.space.v1.FeedModerationEvent': FeedModerationEvent$json,
  '.space.v1.ReportFeedContentRequest': ReportFeedContentRequest$json,
  '.space.v1.ReportFeedContentResponse': ReportFeedContentResponse$json,
  '.space.v1.ListFeedReportsRequest': ListFeedReportsRequest$json,
  '.space.v1.ListFeedReportsResponse': ListFeedReportsResponse$json,
  '.space.v1.FeedReport': FeedReport$json,
  '.space.v1.ResolveFeedReportRequest': ResolveFeedReportRequest$json,
  '.space.v1.ResolveFeedReportResponse': ResolveFeedReportResponse$json,
  '.space.v1.MarkFeedPostReadRequest': MarkFeedPostReadRequest$json,
  '.space.v1.MarkFeedPostReadResponse': MarkFeedPostReadResponse$json,
};

/// Descriptor for `FeedService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List feedServiceDescriptor = $convert.base64Decode(
    'CgtGZWVkU2VydmljZRJQCg1MaXN0RmVlZFBvc3RzEh4uc3BhY2UudjEuTGlzdEZlZWRQb3N0c1'
    'JlcXVlc3QaHy5zcGFjZS52MS5MaXN0RmVlZFBvc3RzUmVzcG9uc2USSgoLR2V0RmVlZFBvc3QS'
    'HC5zcGFjZS52MS5HZXRGZWVkUG9zdFJlcXVlc3QaHS5zcGFjZS52MS5HZXRGZWVkUG9zdFJlc3'
    'BvbnNlElMKDkNyZWF0ZUZlZWRQb3N0Eh8uc3BhY2UudjEuQ3JlYXRlRmVlZFBvc3RSZXF1ZXN0'
    'GiAuc3BhY2UudjEuQ3JlYXRlRmVlZFBvc3RSZXNwb25zZRJWCg9Db21tZW50RmVlZFBvc3QSIC'
    '5zcGFjZS52MS5Db21tZW50RmVlZFBvc3RSZXF1ZXN0GiEuc3BhY2UudjEuQ29tbWVudEZlZWRQ'
    'b3N0UmVzcG9uc2USUAoNR2V0RmVlZEFjY2VzcxIeLnNwYWNlLnYxLkdldEZlZWRBY2Nlc3NSZX'
    'F1ZXN0Gh8uc3BhY2UudjEuR2V0RmVlZEFjY2Vzc1Jlc3BvbnNlElkKEFVwZGF0ZUZlZWRBY2Nl'
    'c3MSIS5zcGFjZS52MS5VcGRhdGVGZWVkQWNjZXNzUmVxdWVzdBoiLnNwYWNlLnYxLlVwZGF0ZU'
    'ZlZWRBY2Nlc3NSZXNwb25zZRJZChBNb2RlcmF0ZUZlZWRQb3N0EiEuc3BhY2UudjEuTW9kZXJh'
    'dGVGZWVkUG9zdFJlcXVlc3QaIi5zcGFjZS52MS5Nb2RlcmF0ZUZlZWRQb3N0UmVzcG9uc2USYg'
    'oTTW9kZXJhdGVGZWVkQ29tbWVudBIkLnNwYWNlLnYxLk1vZGVyYXRlRmVlZENvbW1lbnRSZXF1'
    'ZXN0GiUuc3BhY2UudjEuTW9kZXJhdGVGZWVkQ29tbWVudFJlc3BvbnNlEl8KEkxpc3RGZWVkTW'
    '9kZXJhdGlvbhIjLnNwYWNlLnYxLkxpc3RGZWVkTW9kZXJhdGlvblJlcXVlc3QaJC5zcGFjZS52'
    'MS5MaXN0RmVlZE1vZGVyYXRpb25SZXNwb25zZRJcChFSZXBvcnRGZWVkQ29udGVudBIiLnNwYW'
    'NlLnYxLlJlcG9ydEZlZWRDb250ZW50UmVxdWVzdBojLnNwYWNlLnYxLlJlcG9ydEZlZWRDb250'
    'ZW50UmVzcG9uc2USVgoPTGlzdEZlZWRSZXBvcnRzEiAuc3BhY2UudjEuTGlzdEZlZWRSZXBvcn'
    'RzUmVxdWVzdBohLnNwYWNlLnYxLkxpc3RGZWVkUmVwb3J0c1Jlc3BvbnNlElwKEVJlc29sdmVG'
    'ZWVkUmVwb3J0EiIuc3BhY2UudjEuUmVzb2x2ZUZlZWRSZXBvcnRSZXF1ZXN0GiMuc3BhY2Uudj'
    'EuUmVzb2x2ZUZlZWRSZXBvcnRSZXNwb25zZRJZChBNYXJrRmVlZFBvc3RSZWFkEiEuc3BhY2Uu'
    'djEuTWFya0ZlZWRQb3N0UmVhZFJlcXVlc3QaIi5zcGFjZS52MS5NYXJrRmVlZFBvc3RSZWFkUm'
    'VzcG9uc2U=');
