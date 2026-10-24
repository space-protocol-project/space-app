// This is a generated file - do not edit.
//
// Generated from space/v1/community_overview.proto.

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

import 'community_search.pbjson.dart' as $0;

@$core.Deprecated('Use getCommunityOverviewRequestDescriptor instead')
const GetCommunityOverviewRequest$json = {
  '1': 'GetCommunityOverviewRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetCommunityOverviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommunityOverviewRequestDescriptor =
    $convert.base64Decode(
        'ChtHZXRDb21tdW5pdHlPdmVydmlld1JlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm'
        '5lbElkEhQKBWxpbWl0GAIgASgFUgVsaW1pdA==');

@$core.Deprecated('Use communityOverviewEntryDescriptor instead')
const CommunityOverviewEntry$json = {
  '1': 'CommunityOverviewEntry',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.CommunitySearchResult',
      '10': 'content'
    },
    {'1': 'unread_count', '3': 2, '4': 1, '5': 3, '10': 'unreadCount'},
    {
      '1': 'read_state_supported',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'readStateSupported'
    },
    {
      '1': 'unread_replies_to_you',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'unreadRepliesToYou'
    },
    {
      '1': 'first_unread_reply_sequence',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'firstUnreadReplySequence'
    },
  ],
};

/// Descriptor for `CommunityOverviewEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communityOverviewEntryDescriptor = $convert.base64Decode(
    'ChZDb21tdW5pdHlPdmVydmlld0VudHJ5EjkKB2NvbnRlbnQYASABKAsyHy5zcGFjZS52MS5Db2'
    '1tdW5pdHlTZWFyY2hSZXN1bHRSB2NvbnRlbnQSIQoMdW5yZWFkX2NvdW50GAIgASgDUgt1bnJl'
    'YWRDb3VudBIwChRyZWFkX3N0YXRlX3N1cHBvcnRlZBgDIAEoCFIScmVhZFN0YXRlU3VwcG9ydG'
    'VkEjEKFXVucmVhZF9yZXBsaWVzX3RvX3lvdRgEIAEoA1ISdW5yZWFkUmVwbGllc1RvWW91Ej0K'
    'G2ZpcnN0X3VucmVhZF9yZXBseV9zZXF1ZW5jZRgFIAEoA1IYZmlyc3RVbnJlYWRSZXBseVNlcX'
    'VlbmNl');

@$core.Deprecated('Use getCommunityOverviewResponseDescriptor instead')
const GetCommunityOverviewResponse$json = {
  '1': 'GetCommunityOverviewResponse',
  '2': [
    {
      '1': 'recent',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.CommunityOverviewEntry',
      '10': 'recent'
    },
    {
      '1': 'replies_to_you',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.space.v1.CommunityOverviewEntry',
      '10': 'repliesToYou'
    },
    {'1': 'pending_reports', '3': 3, '4': 1, '5': 3, '10': 'pendingReports'},
    {'1': 'can_moderate', '3': 4, '4': 1, '5': 8, '10': 'canModerate'},
  ],
};

/// Descriptor for `GetCommunityOverviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommunityOverviewResponseDescriptor = $convert.base64Decode(
    'ChxHZXRDb21tdW5pdHlPdmVydmlld1Jlc3BvbnNlEjgKBnJlY2VudBgBIAMoCzIgLnNwYWNlLn'
    'YxLkNvbW11bml0eU92ZXJ2aWV3RW50cnlSBnJlY2VudBJGCg5yZXBsaWVzX3RvX3lvdRgCIAMo'
    'CzIgLnNwYWNlLnYxLkNvbW11bml0eU92ZXJ2aWV3RW50cnlSDHJlcGxpZXNUb1lvdRInCg9wZW'
    '5kaW5nX3JlcG9ydHMYAyABKANSDnBlbmRpbmdSZXBvcnRzEiEKDGNhbl9tb2RlcmF0ZRgEIAEo'
    'CFILY2FuTW9kZXJhdGU=');

const $core.Map<$core.String, $core.dynamic> CommunityOverviewServiceBase$json =
    {
  '1': 'CommunityOverviewService',
  '2': [
    {
      '1': 'GetCommunityOverview',
      '2': '.space.v1.GetCommunityOverviewRequest',
      '3': '.space.v1.GetCommunityOverviewResponse'
    },
  ],
};

@$core.Deprecated('Use communityOverviewServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    CommunityOverviewServiceBase$messageJson = {
  '.space.v1.GetCommunityOverviewRequest': GetCommunityOverviewRequest$json,
  '.space.v1.GetCommunityOverviewResponse': GetCommunityOverviewResponse$json,
  '.space.v1.CommunityOverviewEntry': CommunityOverviewEntry$json,
  '.space.v1.CommunitySearchResult': $0.CommunitySearchResult$json,
};

/// Descriptor for `CommunityOverviewService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List communityOverviewServiceDescriptor = $convert.base64Decode(
    'ChhDb21tdW5pdHlPdmVydmlld1NlcnZpY2USZQoUR2V0Q29tbXVuaXR5T3ZlcnZpZXcSJS5zcG'
    'FjZS52MS5HZXRDb21tdW5pdHlPdmVydmlld1JlcXVlc3QaJi5zcGFjZS52MS5HZXRDb21tdW5p'
    'dHlPdmVydmlld1Jlc3BvbnNl');
