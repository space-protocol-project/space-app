// This is a generated file - do not edit.
//
// Generated from space/v1/forum.proto.

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

@$core.Deprecated('Use forumThreadDescriptor instead')
const ForumThread$json = {
  '1': 'ForumThread',
  '2': [
    {
      '1': 'attachments',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Asset',
      '10': 'attachments'
    },
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'author_id', '3': 3, '4': 1, '5': 9, '10': 'authorId'},
    {'1': 'author_name', '3': 4, '4': 1, '5': 9, '10': 'authorName'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'text', '3': 6, '4': 1, '5': 9, '10': 'text'},
    {'1': 'created_at_unix', '3': 7, '4': 1, '5': 3, '10': 'createdAtUnix'},
    {'1': 'sequence', '3': 8, '4': 1, '5': 3, '10': 'sequence'},
    {'1': 'revision', '3': 9, '4': 1, '5': 3, '10': 'revision'},
    {'1': 'closed', '3': 10, '4': 1, '5': 8, '10': 'closed'},
    {'1': 'reply_count', '3': 11, '4': 1, '5': 3, '10': 'replyCount'},
  ],
};

/// Descriptor for `ForumThread`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forumThreadDescriptor = $convert.base64Decode(
    'CgtGb3J1bVRocmVhZBIxCgthdHRhY2htZW50cxgMIAMoCzIPLnNwYWNlLnYxLkFzc2V0UgthdH'
    'RhY2htZW50cxIOCgJpZBgBIAEoCVICaWQSHQoKY2hhbm5lbF9pZBgCIAEoCVIJY2hhbm5lbElk'
    'EhsKCWF1dGhvcl9pZBgDIAEoCVIIYXV0aG9ySWQSHwoLYXV0aG9yX25hbWUYBCABKAlSCmF1dG'
    'hvck5hbWUSFAoFdGl0bGUYBSABKAlSBXRpdGxlEhIKBHRleHQYBiABKAlSBHRleHQSJgoPY3Jl'
    'YXRlZF9hdF91bml4GAcgASgDUg1jcmVhdGVkQXRVbml4EhoKCHNlcXVlbmNlGAggASgDUghzZX'
    'F1ZW5jZRIaCghyZXZpc2lvbhgJIAEoA1IIcmV2aXNpb24SFgoGY2xvc2VkGAogASgIUgZjbG9z'
    'ZWQSHwoLcmVwbHlfY291bnQYCyABKANSCnJlcGx5Q291bnQ=');

@$core.Deprecated('Use forumReplyDescriptor instead')
const ForumReply$json = {
  '1': 'ForumReply',
  '2': [
    {
      '1': 'attachments',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Asset',
      '10': 'attachments'
    },
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'author_id', '3': 3, '4': 1, '5': 9, '10': 'authorId'},
    {'1': 'author_name', '3': 4, '4': 1, '5': 9, '10': 'authorName'},
    {'1': 'text', '3': 5, '4': 1, '5': 9, '10': 'text'},
    {'1': 'created_at_unix', '3': 6, '4': 1, '5': 3, '10': 'createdAtUnix'},
    {'1': 'sequence', '3': 7, '4': 1, '5': 3, '10': 'sequence'},
  ],
};

/// Descriptor for `ForumReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forumReplyDescriptor = $convert.base64Decode(
    'CgpGb3J1bVJlcGx5EjEKC2F0dGFjaG1lbnRzGAggAygLMg8uc3BhY2UudjEuQXNzZXRSC2F0dG'
    'FjaG1lbnRzEg4KAmlkGAEgASgJUgJpZBIbCgl0aHJlYWRfaWQYAiABKAlSCHRocmVhZElkEhsK'
    'CWF1dGhvcl9pZBgDIAEoCVIIYXV0aG9ySWQSHwoLYXV0aG9yX25hbWUYBCABKAlSCmF1dGhvck'
    '5hbWUSEgoEdGV4dBgFIAEoCVIEdGV4dBImCg9jcmVhdGVkX2F0X3VuaXgYBiABKANSDWNyZWF0'
    'ZWRBdFVuaXgSGgoIc2VxdWVuY2UYByABKANSCHNlcXVlbmNl');

@$core.Deprecated('Use listForumThreadsRequestDescriptor instead')
const ListForumThreadsRequest$json = {
  '1': 'ListForumThreadsRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after_sequence', '3': 2, '4': 1, '5': 3, '10': 'afterSequence'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListForumThreadsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listForumThreadsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0Rm9ydW1UaHJlYWRzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSW'
    'QSJQoOYWZ0ZXJfc2VxdWVuY2UYAiABKANSDWFmdGVyU2VxdWVuY2USFAoFbGltaXQYAyABKAVS'
    'BWxpbWl0');

@$core.Deprecated('Use listForumThreadsResponseDescriptor instead')
const ListForumThreadsResponse$json = {
  '1': 'ListForumThreadsResponse',
  '2': [
    {
      '1': 'threads',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ForumThread',
      '10': 'threads'
    },
    {'1': 'next_sequence', '3': 2, '4': 1, '5': 3, '10': 'nextSequence'},
  ],
};

/// Descriptor for `ListForumThreadsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listForumThreadsResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0Rm9ydW1UaHJlYWRzUmVzcG9uc2USLwoHdGhyZWFkcxgBIAMoCzIVLnNwYWNlLnYxLk'
    'ZvcnVtVGhyZWFkUgd0aHJlYWRzEiMKDW5leHRfc2VxdWVuY2UYAiABKANSDG5leHRTZXF1ZW5j'
    'ZQ==');

@$core.Deprecated('Use getForumThreadRequestDescriptor instead')
const GetForumThreadRequest$json = {
  '1': 'GetForumThreadRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'after_sequence', '3': 3, '4': 1, '5': 3, '10': 'afterSequence'},
    {'1': 'limit', '3': 4, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetForumThreadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getForumThreadRequestDescriptor = $convert.base64Decode(
    'ChVHZXRGb3J1bVRocmVhZFJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbElkEh'
    'sKCXRocmVhZF9pZBgCIAEoCVIIdGhyZWFkSWQSJQoOYWZ0ZXJfc2VxdWVuY2UYAyABKANSDWFm'
    'dGVyU2VxdWVuY2USFAoFbGltaXQYBCABKAVSBWxpbWl0');

@$core.Deprecated('Use getForumThreadResponseDescriptor instead')
const GetForumThreadResponse$json = {
  '1': 'GetForumThreadResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ForumThread',
      '10': 'thread'
    },
    {
      '1': 'replies',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ForumReply',
      '10': 'replies'
    },
    {'1': 'next_sequence', '3': 3, '4': 1, '5': 3, '10': 'nextSequence'},
  ],
};

/// Descriptor for `GetForumThreadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getForumThreadResponseDescriptor = $convert.base64Decode(
    'ChZHZXRGb3J1bVRocmVhZFJlc3BvbnNlEi0KBnRocmVhZBgBIAEoCzIVLnNwYWNlLnYxLkZvcn'
    'VtVGhyZWFkUgZ0aHJlYWQSLgoHcmVwbGllcxgCIAMoCzIULnNwYWNlLnYxLkZvcnVtUmVwbHlS'
    'B3JlcGxpZXMSIwoNbmV4dF9zZXF1ZW5jZRgDIAEoA1IMbmV4dFNlcXVlbmNl');

@$core.Deprecated('Use createForumThreadRequestDescriptor instead')
const CreateForumThreadRequest$json = {
  '1': 'CreateForumThreadRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'idempotency_key', '3': 4, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'attachment_ids', '3': 5, '4': 3, '5': 9, '10': 'attachmentIds'},
  ],
};

/// Descriptor for `CreateForumThreadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createForumThreadRequestDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVGb3J1bVRocmVhZFJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbE'
    'lkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRISCgR0ZXh0GAMgASgJUgR0ZXh0EicKD2lkZW1wb3Rl'
    'bmN5X2tleRgEIAEoCVIOaWRlbXBvdGVuY3lLZXkSJQoOYXR0YWNobWVudF9pZHMYBSADKAlSDW'
    'F0dGFjaG1lbnRJZHM=');

@$core.Deprecated('Use createForumThreadResponseDescriptor instead')
const CreateForumThreadResponse$json = {
  '1': 'CreateForumThreadResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ForumThread',
      '10': 'thread'
    },
  ],
};

/// Descriptor for `CreateForumThreadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createForumThreadResponseDescriptor =
    $convert.base64Decode(
        'ChlDcmVhdGVGb3J1bVRocmVhZFJlc3BvbnNlEi0KBnRocmVhZBgBIAEoCzIVLnNwYWNlLnYxLk'
        'ZvcnVtVGhyZWFkUgZ0aHJlYWQ=');

@$core.Deprecated('Use replyForumThreadRequestDescriptor instead')
const ReplyForumThreadRequest$json = {
  '1': 'ReplyForumThreadRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'idempotency_key', '3': 4, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'attachment_ids', '3': 5, '4': 3, '5': 9, '10': 'attachmentIds'},
  ],
};

/// Descriptor for `ReplyForumThreadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyForumThreadRequestDescriptor = $convert.base64Decode(
    'ChdSZXBseUZvcnVtVGhyZWFkUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSW'
    'QSGwoJdGhyZWFkX2lkGAIgASgJUgh0aHJlYWRJZBISCgR0ZXh0GAMgASgJUgR0ZXh0EicKD2lk'
    'ZW1wb3RlbmN5X2tleRgEIAEoCVIOaWRlbXBvdGVuY3lLZXkSJQoOYXR0YWNobWVudF9pZHMYBS'
    'ADKAlSDWF0dGFjaG1lbnRJZHM=');

@$core.Deprecated('Use replyForumThreadResponseDescriptor instead')
const ReplyForumThreadResponse$json = {
  '1': 'ReplyForumThreadResponse',
  '2': [
    {
      '1': 'reply',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ForumReply',
      '10': 'reply'
    },
    {
      '1': 'thread',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ForumThread',
      '10': 'thread'
    },
  ],
};

/// Descriptor for `ReplyForumThreadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyForumThreadResponseDescriptor = $convert.base64Decode(
    'ChhSZXBseUZvcnVtVGhyZWFkUmVzcG9uc2USKgoFcmVwbHkYASABKAsyFC5zcGFjZS52MS5Gb3'
    'J1bVJlcGx5UgVyZXBseRItCgZ0aHJlYWQYAiABKAsyFS5zcGFjZS52MS5Gb3J1bVRocmVhZFIG'
    'dGhyZWFk');

@$core.Deprecated('Use closeForumThreadRequestDescriptor instead')
const CloseForumThreadRequest$json = {
  '1': 'CloseForumThreadRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {
      '1': 'expected_revision',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `CloseForumThreadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeForumThreadRequestDescriptor = $convert.base64Decode(
    'ChdDbG9zZUZvcnVtVGhyZWFkUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSW'
    'QSGwoJdGhyZWFkX2lkGAIgASgJUgh0aHJlYWRJZBIrChFleHBlY3RlZF9yZXZpc2lvbhgDIAEo'
    'A1IQZXhwZWN0ZWRSZXZpc2lvbg==');

@$core.Deprecated('Use closeForumThreadResponseDescriptor instead')
const CloseForumThreadResponse$json = {
  '1': 'CloseForumThreadResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ForumThread',
      '10': 'thread'
    },
  ],
};

/// Descriptor for `CloseForumThreadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeForumThreadResponseDescriptor =
    $convert.base64Decode(
        'ChhDbG9zZUZvcnVtVGhyZWFkUmVzcG9uc2USLQoGdGhyZWFkGAEgASgLMhUuc3BhY2UudjEuRm'
        '9ydW1UaHJlYWRSBnRocmVhZA==');

const $core.Map<$core.String, $core.dynamic> ForumServiceBase$json = {
  '1': 'ForumService',
  '2': [
    {
      '1': 'ListForumThreads',
      '2': '.space.v1.ListForumThreadsRequest',
      '3': '.space.v1.ListForumThreadsResponse'
    },
    {
      '1': 'GetForumThread',
      '2': '.space.v1.GetForumThreadRequest',
      '3': '.space.v1.GetForumThreadResponse'
    },
    {
      '1': 'CreateForumThread',
      '2': '.space.v1.CreateForumThreadRequest',
      '3': '.space.v1.CreateForumThreadResponse'
    },
    {
      '1': 'ReplyForumThread',
      '2': '.space.v1.ReplyForumThreadRequest',
      '3': '.space.v1.ReplyForumThreadResponse'
    },
    {
      '1': 'CloseForumThread',
      '2': '.space.v1.CloseForumThreadRequest',
      '3': '.space.v1.CloseForumThreadResponse'
    },
  ],
};

@$core.Deprecated('Use forumServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ForumServiceBase$messageJson = {
  '.space.v1.ListForumThreadsRequest': ListForumThreadsRequest$json,
  '.space.v1.ListForumThreadsResponse': ListForumThreadsResponse$json,
  '.space.v1.ForumThread': ForumThread$json,
  '.space.v1.Asset': $0.Asset$json,
  '.space.v1.GetForumThreadRequest': GetForumThreadRequest$json,
  '.space.v1.GetForumThreadResponse': GetForumThreadResponse$json,
  '.space.v1.ForumReply': ForumReply$json,
  '.space.v1.CreateForumThreadRequest': CreateForumThreadRequest$json,
  '.space.v1.CreateForumThreadResponse': CreateForumThreadResponse$json,
  '.space.v1.ReplyForumThreadRequest': ReplyForumThreadRequest$json,
  '.space.v1.ReplyForumThreadResponse': ReplyForumThreadResponse$json,
  '.space.v1.CloseForumThreadRequest': CloseForumThreadRequest$json,
  '.space.v1.CloseForumThreadResponse': CloseForumThreadResponse$json,
};

/// Descriptor for `ForumService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List forumServiceDescriptor = $convert.base64Decode(
    'CgxGb3J1bVNlcnZpY2USWQoQTGlzdEZvcnVtVGhyZWFkcxIhLnNwYWNlLnYxLkxpc3RGb3J1bV'
    'RocmVhZHNSZXF1ZXN0GiIuc3BhY2UudjEuTGlzdEZvcnVtVGhyZWFkc1Jlc3BvbnNlElMKDkdl'
    'dEZvcnVtVGhyZWFkEh8uc3BhY2UudjEuR2V0Rm9ydW1UaHJlYWRSZXF1ZXN0GiAuc3BhY2Uudj'
    'EuR2V0Rm9ydW1UaHJlYWRSZXNwb25zZRJcChFDcmVhdGVGb3J1bVRocmVhZBIiLnNwYWNlLnYx'
    'LkNyZWF0ZUZvcnVtVGhyZWFkUmVxdWVzdBojLnNwYWNlLnYxLkNyZWF0ZUZvcnVtVGhyZWFkUm'
    'VzcG9uc2USWQoQUmVwbHlGb3J1bVRocmVhZBIhLnNwYWNlLnYxLlJlcGx5Rm9ydW1UaHJlYWRS'
    'ZXF1ZXN0GiIuc3BhY2UudjEuUmVwbHlGb3J1bVRocmVhZFJlc3BvbnNlElkKEENsb3NlRm9ydW'
    '1UaHJlYWQSIS5zcGFjZS52MS5DbG9zZUZvcnVtVGhyZWFkUmVxdWVzdBoiLnNwYWNlLnYxLkNs'
    'b3NlRm9ydW1UaHJlYWRSZXNwb25zZQ==');
