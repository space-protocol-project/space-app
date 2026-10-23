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
    {'1': 'hidden', '3': 18, '4': 1, '5': 8, '10': 'hidden'},
    {'1': 'pinned', '3': 13, '4': 1, '5': 8, '10': 'pinned'},
    {
      '1': 'read_state_supported',
      '3': 14,
      '4': 1,
      '5': 8,
      '10': 'readStateSupported'
    },
    {'1': 'seen', '3': 15, '4': 1, '5': 8, '10': 'seen'},
    {'1': 'read_sequence', '3': 16, '4': 1, '5': 3, '10': 'readSequence'},
    {'1': 'unread_count', '3': 17, '4': 1, '5': 3, '10': 'unreadCount'},
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
    'CgtGb3J1bVRocmVhZBIWCgZoaWRkZW4YEiABKAhSBmhpZGRlbhIWCgZwaW5uZWQYDSABKAhSBn'
    'Bpbm5lZBIwChRyZWFkX3N0YXRlX3N1cHBvcnRlZBgOIAEoCFIScmVhZFN0YXRlU3VwcG9ydGVk'
    'EhIKBHNlZW4YDyABKAhSBHNlZW4SIwoNcmVhZF9zZXF1ZW5jZRgQIAEoA1IMcmVhZFNlcXVlbm'
    'NlEiEKDHVucmVhZF9jb3VudBgRIAEoA1ILdW5yZWFkQ291bnQSMQoLYXR0YWNobWVudHMYDCAD'
    'KAsyDy5zcGFjZS52MS5Bc3NldFILYXR0YWNobWVudHMSDgoCaWQYASABKAlSAmlkEh0KCmNoYW'
    '5uZWxfaWQYAiABKAlSCWNoYW5uZWxJZBIbCglhdXRob3JfaWQYAyABKAlSCGF1dGhvcklkEh8K'
    'C2F1dGhvcl9uYW1lGAQgASgJUgphdXRob3JOYW1lEhQKBXRpdGxlGAUgASgJUgV0aXRsZRISCg'
    'R0ZXh0GAYgASgJUgR0ZXh0EiYKD2NyZWF0ZWRfYXRfdW5peBgHIAEoA1INY3JlYXRlZEF0VW5p'
    'eBIaCghzZXF1ZW5jZRgIIAEoA1IIc2VxdWVuY2USGgoIcmV2aXNpb24YCSABKANSCHJldmlzaW'
    '9uEhYKBmNsb3NlZBgKIAEoCFIGY2xvc2VkEh8KC3JlcGx5X2NvdW50GAsgASgDUgpyZXBseUNv'
    'dW50');

@$core.Deprecated('Use forumReplyDescriptor instead')
const ForumReply$json = {
  '1': 'ForumReply',
  '2': [
    {'1': 'hidden', '3': 9, '4': 1, '5': 8, '10': 'hidden'},
    {'1': 'revision', '3': 10, '4': 1, '5': 3, '10': 'revision'},
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
    'CgpGb3J1bVJlcGx5EhYKBmhpZGRlbhgJIAEoCFIGaGlkZGVuEhoKCHJldmlzaW9uGAogASgDUg'
    'hyZXZpc2lvbhIxCgthdHRhY2htZW50cxgIIAMoCzIPLnNwYWNlLnYxLkFzc2V0UgthdHRhY2ht'
    'ZW50cxIOCgJpZBgBIAEoCVICaWQSGwoJdGhyZWFkX2lkGAIgASgJUgh0aHJlYWRJZBIbCglhdX'
    'Rob3JfaWQYAyABKAlSCGF1dGhvcklkEh8KC2F1dGhvcl9uYW1lGAQgASgJUgphdXRob3JOYW1l'
    'EhIKBHRleHQYBSABKAlSBHRleHQSJgoPY3JlYXRlZF9hdF91bml4GAYgASgDUg1jcmVhdGVkQX'
    'RVbml4EhoKCHNlcXVlbmNlGAcgASgDUghzZXF1ZW5jZQ==');

@$core.Deprecated('Use listForumThreadsRequestDescriptor instead')
const ListForumThreadsRequest$json = {
  '1': 'ListForumThreadsRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after_sequence', '3': 2, '4': 1, '5': 3, '10': 'afterSequence'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'pinned_first', '3': 4, '4': 1, '5': 8, '10': 'pinnedFirst'},
    {'1': 'after_pinned', '3': 5, '4': 1, '5': 8, '10': 'afterPinned'},
  ],
};

/// Descriptor for `ListForumThreadsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listForumThreadsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0Rm9ydW1UaHJlYWRzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSW'
    'QSJQoOYWZ0ZXJfc2VxdWVuY2UYAiABKANSDWFmdGVyU2VxdWVuY2USFAoFbGltaXQYAyABKAVS'
    'BWxpbWl0EiEKDHBpbm5lZF9maXJzdBgEIAEoCFILcGlubmVkRmlyc3QSIQoMYWZ0ZXJfcGlubm'
    'VkGAUgASgIUgthZnRlclBpbm5lZA==');

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
    {'1': 'next_pinned', '3': 3, '4': 1, '5': 8, '10': 'nextPinned'},
  ],
};

/// Descriptor for `ListForumThreadsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listForumThreadsResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0Rm9ydW1UaHJlYWRzUmVzcG9uc2USLwoHdGhyZWFkcxgBIAMoCzIVLnNwYWNlLnYxLk'
    'ZvcnVtVGhyZWFkUgd0aHJlYWRzEiMKDW5leHRfc2VxdWVuY2UYAiABKANSDG5leHRTZXF1ZW5j'
    'ZRIfCgtuZXh0X3Bpbm5lZBgDIAEoCFIKbmV4dFBpbm5lZA==');

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

@$core.Deprecated('Use setForumThreadPinnedRequestDescriptor instead')
const SetForumThreadPinnedRequest$json = {
  '1': 'SetForumThreadPinnedRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'pinned', '3': 3, '4': 1, '5': 8, '10': 'pinned'},
    {
      '1': 'expected_revision',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `SetForumThreadPinnedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setForumThreadPinnedRequestDescriptor =
    $convert.base64Decode(
        'ChtTZXRGb3J1bVRocmVhZFBpbm5lZFJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm'
        '5lbElkEhsKCXRocmVhZF9pZBgCIAEoCVIIdGhyZWFkSWQSFgoGcGlubmVkGAMgASgIUgZwaW5u'
        'ZWQSKwoRZXhwZWN0ZWRfcmV2aXNpb24YBCABKANSEGV4cGVjdGVkUmV2aXNpb24=');

@$core.Deprecated('Use setForumThreadPinnedResponseDescriptor instead')
const SetForumThreadPinnedResponse$json = {
  '1': 'SetForumThreadPinnedResponse',
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

/// Descriptor for `SetForumThreadPinnedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setForumThreadPinnedResponseDescriptor =
    $convert.base64Decode(
        'ChxTZXRGb3J1bVRocmVhZFBpbm5lZFJlc3BvbnNlEi0KBnRocmVhZBgBIAEoCzIVLnNwYWNlLn'
        'YxLkZvcnVtVGhyZWFkUgZ0aHJlYWQ=');

@$core.Deprecated('Use markForumThreadReadRequestDescriptor instead')
const MarkForumThreadReadRequest$json = {
  '1': 'MarkForumThreadReadRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'through_sequence', '3': 3, '4': 1, '5': 3, '10': 'throughSequence'},
  ],
};

/// Descriptor for `MarkForumThreadReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markForumThreadReadRequestDescriptor =
    $convert.base64Decode(
        'ChpNYXJrRm9ydW1UaHJlYWRSZWFkUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubm'
        'VsSWQSGwoJdGhyZWFkX2lkGAIgASgJUgh0aHJlYWRJZBIpChB0aHJvdWdoX3NlcXVlbmNlGAMg'
        'ASgDUg90aHJvdWdoU2VxdWVuY2U=');

@$core.Deprecated('Use markForumThreadReadResponseDescriptor instead')
const MarkForumThreadReadResponse$json = {
  '1': 'MarkForumThreadReadResponse',
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

/// Descriptor for `MarkForumThreadReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markForumThreadReadResponseDescriptor =
    $convert.base64Decode(
        'ChtNYXJrRm9ydW1UaHJlYWRSZWFkUmVzcG9uc2USLQoGdGhyZWFkGAEgASgLMhUuc3BhY2Uudj'
        'EuRm9ydW1UaHJlYWRSBnRocmVhZA==');

@$core.Deprecated('Use moderateForumThreadRequestDescriptor instead')
const ModerateForumThreadRequest$json = {
  '1': 'ModerateForumThreadRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'action', '3': 3, '4': 1, '5': 9, '10': 'action'},
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

/// Descriptor for `ModerateForumThreadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moderateForumThreadRequestDescriptor = $convert.base64Decode(
    'ChpNb2RlcmF0ZUZvcnVtVGhyZWFkUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubm'
    'VsSWQSGwoJdGhyZWFkX2lkGAIgASgJUgh0aHJlYWRJZBIWCgZhY3Rpb24YAyABKAlSBmFjdGlv'
    'bhIWCgZyZWFzb24YBCABKAlSBnJlYXNvbhIrChFleHBlY3RlZF9yZXZpc2lvbhgFIAEoA1IQZX'
    'hwZWN0ZWRSZXZpc2lvbg==');

@$core.Deprecated('Use moderateForumThreadResponseDescriptor instead')
const ModerateForumThreadResponse$json = {
  '1': 'ModerateForumThreadResponse',
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

/// Descriptor for `ModerateForumThreadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moderateForumThreadResponseDescriptor =
    $convert.base64Decode(
        'ChtNb2RlcmF0ZUZvcnVtVGhyZWFkUmVzcG9uc2USLQoGdGhyZWFkGAEgASgLMhUuc3BhY2Uudj'
        'EuRm9ydW1UaHJlYWRSBnRocmVhZA==');

@$core.Deprecated('Use moderateForumReplyRequestDescriptor instead')
const ModerateForumReplyRequest$json = {
  '1': 'ModerateForumReplyRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'reply_id', '3': 3, '4': 1, '5': 9, '10': 'replyId'},
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

/// Descriptor for `ModerateForumReplyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moderateForumReplyRequestDescriptor = $convert.base64Decode(
    'ChlNb2RlcmF0ZUZvcnVtUmVwbHlSZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW5uZW'
    'xJZBIbCgl0aHJlYWRfaWQYAiABKAlSCHRocmVhZElkEhkKCHJlcGx5X2lkGAMgASgJUgdyZXBs'
    'eUlkEhYKBmhpZGRlbhgEIAEoCFIGaGlkZGVuEhYKBnJlYXNvbhgFIAEoCVIGcmVhc29uEisKEW'
    'V4cGVjdGVkX3JldmlzaW9uGAYgASgDUhBleHBlY3RlZFJldmlzaW9u');

@$core.Deprecated('Use moderateForumReplyResponseDescriptor instead')
const ModerateForumReplyResponse$json = {
  '1': 'ModerateForumReplyResponse',
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

/// Descriptor for `ModerateForumReplyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moderateForumReplyResponseDescriptor =
    $convert.base64Decode(
        'ChpNb2RlcmF0ZUZvcnVtUmVwbHlSZXNwb25zZRIqCgVyZXBseRgBIAEoCzIULnNwYWNlLnYxLk'
        'ZvcnVtUmVwbHlSBXJlcGx5Ei0KBnRocmVhZBgCIAEoCzIVLnNwYWNlLnYxLkZvcnVtVGhyZWFk'
        'UgZ0aHJlYWQ=');

@$core.Deprecated('Use listForumModerationRequestDescriptor instead')
const ListForumModerationRequest$json = {
  '1': 'ListForumModerationRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'after_id', '3': 3, '4': 1, '5': 3, '10': 'afterId'},
    {'1': 'limit', '3': 4, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListForumModerationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listForumModerationRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0Rm9ydW1Nb2RlcmF0aW9uUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubm'
        'VsSWQSGwoJdGhyZWFkX2lkGAIgASgJUgh0aHJlYWRJZBIZCghhZnRlcl9pZBgDIAEoA1IHYWZ0'
        'ZXJJZBIUCgVsaW1pdBgEIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use forumModerationEventDescriptor instead')
const ForumModerationEvent$json = {
  '1': 'ForumModerationEvent',
  '2': [
    {'1': 'report_id', '3': 9, '4': 1, '5': 3, '10': 'reportId'},
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'reply_id', '3': 3, '4': 1, '5': 9, '10': 'replyId'},
    {'1': 'action', '3': 4, '4': 1, '5': 9, '10': 'action'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'actor_id', '3': 6, '4': 1, '5': 9, '10': 'actorId'},
    {'1': 'revision', '3': 7, '4': 1, '5': 3, '10': 'revision'},
    {'1': 'created_at_unix', '3': 8, '4': 1, '5': 3, '10': 'createdAtUnix'},
  ],
};

/// Descriptor for `ForumModerationEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forumModerationEventDescriptor = $convert.base64Decode(
    'ChRGb3J1bU1vZGVyYXRpb25FdmVudBIbCglyZXBvcnRfaWQYCSABKANSCHJlcG9ydElkEg4KAm'
    'lkGAEgASgDUgJpZBIbCgl0aHJlYWRfaWQYAiABKAlSCHRocmVhZElkEhkKCHJlcGx5X2lkGAMg'
    'ASgJUgdyZXBseUlkEhYKBmFjdGlvbhgEIAEoCVIGYWN0aW9uEhYKBnJlYXNvbhgFIAEoCVIGcm'
    'Vhc29uEhkKCGFjdG9yX2lkGAYgASgJUgdhY3RvcklkEhoKCHJldmlzaW9uGAcgASgDUghyZXZp'
    'c2lvbhImCg9jcmVhdGVkX2F0X3VuaXgYCCABKANSDWNyZWF0ZWRBdFVuaXg=');

@$core.Deprecated('Use listForumModerationResponseDescriptor instead')
const ListForumModerationResponse$json = {
  '1': 'ListForumModerationResponse',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ForumModerationEvent',
      '10': 'events'
    },
    {'1': 'next_id', '3': 2, '4': 1, '5': 3, '10': 'nextId'},
  ],
};

/// Descriptor for `ListForumModerationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listForumModerationResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0Rm9ydW1Nb2RlcmF0aW9uUmVzcG9uc2USNgoGZXZlbnRzGAEgAygLMh4uc3BhY2Uudj'
        'EuRm9ydW1Nb2RlcmF0aW9uRXZlbnRSBmV2ZW50cxIXCgduZXh0X2lkGAIgASgDUgZuZXh0SWQ=');

@$core.Deprecated('Use forumReportDescriptor instead')
const ForumReport$json = {
  '1': 'ForumReport',
  '2': [
    {'1': 'thread_title', '3': 10, '4': 1, '5': 9, '10': 'threadTitle'},
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'reply_id', '3': 3, '4': 1, '5': 9, '10': 'replyId'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'decision', '3': 5, '4': 1, '5': 9, '10': 'decision'},
    {'1': 'decision_reason', '3': 6, '4': 1, '5': 9, '10': 'decisionReason'},
    {'1': 'moderator_id', '3': 7, '4': 1, '5': 9, '10': 'moderatorId'},
    {'1': 'created_at_unix', '3': 8, '4': 1, '5': 3, '10': 'createdAtUnix'},
    {'1': 'resolved_at_unix', '3': 9, '4': 1, '5': 3, '10': 'resolvedAtUnix'},
  ],
};

/// Descriptor for `ForumReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forumReportDescriptor = $convert.base64Decode(
    'CgtGb3J1bVJlcG9ydBIhCgx0aHJlYWRfdGl0bGUYCiABKAlSC3RocmVhZFRpdGxlEg4KAmlkGA'
    'EgASgDUgJpZBIbCgl0aHJlYWRfaWQYAiABKAlSCHRocmVhZElkEhkKCHJlcGx5X2lkGAMgASgJ'
    'UgdyZXBseUlkEhYKBnJlYXNvbhgEIAEoCVIGcmVhc29uEhoKCGRlY2lzaW9uGAUgASgJUghkZW'
    'Npc2lvbhInCg9kZWNpc2lvbl9yZWFzb24YBiABKAlSDmRlY2lzaW9uUmVhc29uEiEKDG1vZGVy'
    'YXRvcl9pZBgHIAEoCVILbW9kZXJhdG9ySWQSJgoPY3JlYXRlZF9hdF91bml4GAggASgDUg1jcm'
    'VhdGVkQXRVbml4EigKEHJlc29sdmVkX2F0X3VuaXgYCSABKANSDnJlc29sdmVkQXRVbml4');

@$core.Deprecated('Use reportForumContentRequestDescriptor instead')
const ReportForumContentRequest$json = {
  '1': 'ReportForumContentRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'reply_id', '3': 3, '4': 1, '5': 9, '10': 'replyId'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReportForumContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportForumContentRequestDescriptor = $convert.base64Decode(
    'ChlSZXBvcnRGb3J1bUNvbnRlbnRSZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW5uZW'
    'xJZBIbCgl0aHJlYWRfaWQYAiABKAlSCHRocmVhZElkEhkKCHJlcGx5X2lkGAMgASgJUgdyZXBs'
    'eUlkEhYKBnJlYXNvbhgEIAEoCVIGcmVhc29u');

@$core.Deprecated('Use reportForumContentResponseDescriptor instead')
const ReportForumContentResponse$json = {
  '1': 'ReportForumContentResponse',
};

/// Descriptor for `ReportForumContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportForumContentResponseDescriptor =
    $convert.base64Decode('ChpSZXBvcnRGb3J1bUNvbnRlbnRSZXNwb25zZQ==');

@$core.Deprecated('Use listForumReportsRequestDescriptor instead')
const ListForumReportsRequest$json = {
  '1': 'ListForumReportsRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after_id', '3': 2, '4': 1, '5': 3, '10': 'afterId'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'resolved', '3': 4, '4': 1, '5': 8, '10': 'resolved'},
  ],
};

/// Descriptor for `ListForumReportsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listForumReportsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0Rm9ydW1SZXBvcnRzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSW'
    'QSGQoIYWZ0ZXJfaWQYAiABKANSB2FmdGVySWQSFAoFbGltaXQYAyABKAVSBWxpbWl0EhoKCHJl'
    'c29sdmVkGAQgASgIUghyZXNvbHZlZA==');

@$core.Deprecated('Use listForumReportsResponseDescriptor instead')
const ListForumReportsResponse$json = {
  '1': 'ListForumReportsResponse',
  '2': [
    {
      '1': 'reports',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ForumReport',
      '10': 'reports'
    },
    {'1': 'next_id', '3': 2, '4': 1, '5': 3, '10': 'nextId'},
  ],
};

/// Descriptor for `ListForumReportsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listForumReportsResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0Rm9ydW1SZXBvcnRzUmVzcG9uc2USLwoHcmVwb3J0cxgBIAMoCzIVLnNwYWNlLnYxLk'
        'ZvcnVtUmVwb3J0UgdyZXBvcnRzEhcKB25leHRfaWQYAiABKANSBm5leHRJZA==');

@$core.Deprecated('Use resolveForumReportRequestDescriptor instead')
const ResolveForumReportRequest$json = {
  '1': 'ResolveForumReportRequest',
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

/// Descriptor for `ResolveForumReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveForumReportRequestDescriptor = $convert.base64Decode(
    'ChlSZXNvbHZlRm9ydW1SZXBvcnRSZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW5uZW'
    'xJZBIbCglyZXBvcnRfaWQYAiABKANSCHJlcG9ydElkEhoKCGRlY2lzaW9uGAMgASgJUghkZWNp'
    'c2lvbhIWCgZyZWFzb24YBCABKAlSBnJlYXNvbhIrChFleHBlY3RlZF9yZXZpc2lvbhgFIAEoA1'
    'IQZXhwZWN0ZWRSZXZpc2lvbg==');

@$core.Deprecated('Use resolveForumReportResponseDescriptor instead')
const ResolveForumReportResponse$json = {
  '1': 'ResolveForumReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ForumReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `ResolveForumReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveForumReportResponseDescriptor =
    $convert.base64Decode(
        'ChpSZXNvbHZlRm9ydW1SZXBvcnRSZXNwb25zZRItCgZyZXBvcnQYASABKAsyFS5zcGFjZS52MS'
        '5Gb3J1bVJlcG9ydFIGcmVwb3J0');

const $core.Map<$core.String, $core.dynamic> ForumServiceBase$json = {
  '1': 'ForumService',
  '2': [
    {
      '1': 'ReportForumContent',
      '2': '.space.v1.ReportForumContentRequest',
      '3': '.space.v1.ReportForumContentResponse'
    },
    {
      '1': 'ListForumReports',
      '2': '.space.v1.ListForumReportsRequest',
      '3': '.space.v1.ListForumReportsResponse'
    },
    {
      '1': 'ResolveForumReport',
      '2': '.space.v1.ResolveForumReportRequest',
      '3': '.space.v1.ResolveForumReportResponse'
    },
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
      '1': 'SetForumThreadPinned',
      '2': '.space.v1.SetForumThreadPinnedRequest',
      '3': '.space.v1.SetForumThreadPinnedResponse'
    },
    {
      '1': 'MarkForumThreadRead',
      '2': '.space.v1.MarkForumThreadReadRequest',
      '3': '.space.v1.MarkForumThreadReadResponse'
    },
    {
      '1': 'CloseForumThread',
      '2': '.space.v1.CloseForumThreadRequest',
      '3': '.space.v1.CloseForumThreadResponse'
    },
    {
      '1': 'ModerateForumThread',
      '2': '.space.v1.ModerateForumThreadRequest',
      '3': '.space.v1.ModerateForumThreadResponse'
    },
    {
      '1': 'ModerateForumReply',
      '2': '.space.v1.ModerateForumReplyRequest',
      '3': '.space.v1.ModerateForumReplyResponse'
    },
    {
      '1': 'ListForumModeration',
      '2': '.space.v1.ListForumModerationRequest',
      '3': '.space.v1.ListForumModerationResponse'
    },
  ],
};

@$core.Deprecated('Use forumServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ForumServiceBase$messageJson = {
  '.space.v1.ReportForumContentRequest': ReportForumContentRequest$json,
  '.space.v1.ReportForumContentResponse': ReportForumContentResponse$json,
  '.space.v1.ListForumReportsRequest': ListForumReportsRequest$json,
  '.space.v1.ListForumReportsResponse': ListForumReportsResponse$json,
  '.space.v1.ForumReport': ForumReport$json,
  '.space.v1.ResolveForumReportRequest': ResolveForumReportRequest$json,
  '.space.v1.ResolveForumReportResponse': ResolveForumReportResponse$json,
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
  '.space.v1.SetForumThreadPinnedRequest': SetForumThreadPinnedRequest$json,
  '.space.v1.SetForumThreadPinnedResponse': SetForumThreadPinnedResponse$json,
  '.space.v1.MarkForumThreadReadRequest': MarkForumThreadReadRequest$json,
  '.space.v1.MarkForumThreadReadResponse': MarkForumThreadReadResponse$json,
  '.space.v1.CloseForumThreadRequest': CloseForumThreadRequest$json,
  '.space.v1.CloseForumThreadResponse': CloseForumThreadResponse$json,
  '.space.v1.ModerateForumThreadRequest': ModerateForumThreadRequest$json,
  '.space.v1.ModerateForumThreadResponse': ModerateForumThreadResponse$json,
  '.space.v1.ModerateForumReplyRequest': ModerateForumReplyRequest$json,
  '.space.v1.ModerateForumReplyResponse': ModerateForumReplyResponse$json,
  '.space.v1.ListForumModerationRequest': ListForumModerationRequest$json,
  '.space.v1.ListForumModerationResponse': ListForumModerationResponse$json,
  '.space.v1.ForumModerationEvent': ForumModerationEvent$json,
};

/// Descriptor for `ForumService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List forumServiceDescriptor = $convert.base64Decode(
    'CgxGb3J1bVNlcnZpY2USXwoSUmVwb3J0Rm9ydW1Db250ZW50EiMuc3BhY2UudjEuUmVwb3J0Rm'
    '9ydW1Db250ZW50UmVxdWVzdBokLnNwYWNlLnYxLlJlcG9ydEZvcnVtQ29udGVudFJlc3BvbnNl'
    'ElkKEExpc3RGb3J1bVJlcG9ydHMSIS5zcGFjZS52MS5MaXN0Rm9ydW1SZXBvcnRzUmVxdWVzdB'
    'oiLnNwYWNlLnYxLkxpc3RGb3J1bVJlcG9ydHNSZXNwb25zZRJfChJSZXNvbHZlRm9ydW1SZXBv'
    'cnQSIy5zcGFjZS52MS5SZXNvbHZlRm9ydW1SZXBvcnRSZXF1ZXN0GiQuc3BhY2UudjEuUmVzb2'
    'x2ZUZvcnVtUmVwb3J0UmVzcG9uc2USWQoQTGlzdEZvcnVtVGhyZWFkcxIhLnNwYWNlLnYxLkxp'
    'c3RGb3J1bVRocmVhZHNSZXF1ZXN0GiIuc3BhY2UudjEuTGlzdEZvcnVtVGhyZWFkc1Jlc3Bvbn'
    'NlElMKDkdldEZvcnVtVGhyZWFkEh8uc3BhY2UudjEuR2V0Rm9ydW1UaHJlYWRSZXF1ZXN0GiAu'
    'c3BhY2UudjEuR2V0Rm9ydW1UaHJlYWRSZXNwb25zZRJcChFDcmVhdGVGb3J1bVRocmVhZBIiLn'
    'NwYWNlLnYxLkNyZWF0ZUZvcnVtVGhyZWFkUmVxdWVzdBojLnNwYWNlLnYxLkNyZWF0ZUZvcnVt'
    'VGhyZWFkUmVzcG9uc2USWQoQUmVwbHlGb3J1bVRocmVhZBIhLnNwYWNlLnYxLlJlcGx5Rm9ydW'
    '1UaHJlYWRSZXF1ZXN0GiIuc3BhY2UudjEuUmVwbHlGb3J1bVRocmVhZFJlc3BvbnNlEmUKFFNl'
    'dEZvcnVtVGhyZWFkUGlubmVkEiUuc3BhY2UudjEuU2V0Rm9ydW1UaHJlYWRQaW5uZWRSZXF1ZX'
    'N0GiYuc3BhY2UudjEuU2V0Rm9ydW1UaHJlYWRQaW5uZWRSZXNwb25zZRJiChNNYXJrRm9ydW1U'
    'aHJlYWRSZWFkEiQuc3BhY2UudjEuTWFya0ZvcnVtVGhyZWFkUmVhZFJlcXVlc3QaJS5zcGFjZS'
    '52MS5NYXJrRm9ydW1UaHJlYWRSZWFkUmVzcG9uc2USWQoQQ2xvc2VGb3J1bVRocmVhZBIhLnNw'
    'YWNlLnYxLkNsb3NlRm9ydW1UaHJlYWRSZXF1ZXN0GiIuc3BhY2UudjEuQ2xvc2VGb3J1bVRocm'
    'VhZFJlc3BvbnNlEmIKE01vZGVyYXRlRm9ydW1UaHJlYWQSJC5zcGFjZS52MS5Nb2RlcmF0ZUZv'
    'cnVtVGhyZWFkUmVxdWVzdBolLnNwYWNlLnYxLk1vZGVyYXRlRm9ydW1UaHJlYWRSZXNwb25zZR'
    'JfChJNb2RlcmF0ZUZvcnVtUmVwbHkSIy5zcGFjZS52MS5Nb2RlcmF0ZUZvcnVtUmVwbHlSZXF1'
    'ZXN0GiQuc3BhY2UudjEuTW9kZXJhdGVGb3J1bVJlcGx5UmVzcG9uc2USYgoTTGlzdEZvcnVtTW'
    '9kZXJhdGlvbhIkLnNwYWNlLnYxLkxpc3RGb3J1bU1vZGVyYXRpb25SZXF1ZXN0GiUuc3BhY2Uu'
    'djEuTGlzdEZvcnVtTW9kZXJhdGlvblJlc3BvbnNl');
