// This is a generated file - do not edit.
//
// Generated from space/v1/participant_follows.proto.

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

import 'community_mentions.pbjson.dart' as $2;
import 'feed.pbjson.dart' as $0;
import 'space.pbjson.dart' as $1;

@$core.Deprecated('Use participantFollowStateDescriptor instead')
const ParticipantFollowState$json = {
  '1': 'ParticipantFollowState',
  '2': [
    {'1': 'principal_id', '3': 1, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'following', '3': 2, '4': 1, '5': 8, '10': 'following'},
  ],
};

/// Descriptor for `ParticipantFollowState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantFollowStateDescriptor =
    $convert.base64Decode(
        'ChZQYXJ0aWNpcGFudEZvbGxvd1N0YXRlEiEKDHByaW5jaXBhbF9pZBgBIAEoCVILcHJpbmNpcG'
        'FsSWQSHAoJZm9sbG93aW5nGAIgASgIUglmb2xsb3dpbmc=');

@$core.Deprecated('Use getParticipantFollowStatesRequestDescriptor instead')
const GetParticipantFollowStatesRequest$json = {
  '1': 'GetParticipantFollowStatesRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'principal_ids', '3': 2, '4': 3, '5': 9, '10': 'principalIds'},
  ],
};

/// Descriptor for `GetParticipantFollowStatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getParticipantFollowStatesRequestDescriptor =
    $convert.base64Decode(
        'CiFHZXRQYXJ0aWNpcGFudEZvbGxvd1N0YXRlc1JlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCV'
        'IJY2hhbm5lbElkEiMKDXByaW5jaXBhbF9pZHMYAiADKAlSDHByaW5jaXBhbElkcw==');

@$core.Deprecated('Use getParticipantFollowStatesResponseDescriptor instead')
const GetParticipantFollowStatesResponse$json = {
  '1': 'GetParticipantFollowStatesResponse',
  '2': [
    {
      '1': 'states',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ParticipantFollowState',
      '10': 'states'
    },
    {'1': 'revision', '3': 2, '4': 1, '5': 3, '10': 'revision'},
  ],
};

/// Descriptor for `GetParticipantFollowStatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getParticipantFollowStatesResponseDescriptor =
    $convert.base64Decode(
        'CiJHZXRQYXJ0aWNpcGFudEZvbGxvd1N0YXRlc1Jlc3BvbnNlEjgKBnN0YXRlcxgBIAMoCzIgLn'
        'NwYWNlLnYxLlBhcnRpY2lwYW50Rm9sbG93U3RhdGVSBnN0YXRlcxIaCghyZXZpc2lvbhgCIAEo'
        'A1IIcmV2aXNpb24=');

@$core.Deprecated('Use setParticipantFollowRequestDescriptor instead')
const SetParticipantFollowRequest$json = {
  '1': 'SetParticipantFollowRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'principal_id', '3': 2, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'following', '3': 3, '4': 1, '5': 8, '10': 'following'},
    {
      '1': 'expected_revision',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `SetParticipantFollowRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setParticipantFollowRequestDescriptor = $convert.base64Decode(
    'ChtTZXRQYXJ0aWNpcGFudEZvbGxvd1JlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm'
    '5lbElkEiEKDHByaW5jaXBhbF9pZBgCIAEoCVILcHJpbmNpcGFsSWQSHAoJZm9sbG93aW5nGAMg'
    'ASgIUglmb2xsb3dpbmcSKwoRZXhwZWN0ZWRfcmV2aXNpb24YBCABKANSEGV4cGVjdGVkUmV2aX'
    'Npb24=');

@$core.Deprecated('Use setParticipantFollowResponseDescriptor instead')
const SetParticipantFollowResponse$json = {
  '1': 'SetParticipantFollowResponse',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ParticipantFollowState',
      '10': 'state'
    },
    {'1': 'revision', '3': 2, '4': 1, '5': 3, '10': 'revision'},
  ],
};

/// Descriptor for `SetParticipantFollowResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setParticipantFollowResponseDescriptor =
    $convert.base64Decode(
        'ChxTZXRQYXJ0aWNpcGFudEZvbGxvd1Jlc3BvbnNlEjYKBXN0YXRlGAEgASgLMiAuc3BhY2Uudj'
        'EuUGFydGljaXBhbnRGb2xsb3dTdGF0ZVIFc3RhdGUSGgoIcmV2aXNpb24YAiABKANSCHJldmlz'
        'aW9u');

@$core.Deprecated('Use listFollowingParticipantsRequestDescriptor instead')
const ListFollowingParticipantsRequest$json = {
  '1': 'ListFollowingParticipantsRequest',
  '2': [
    {'1': 'page_token', '3': 1, '4': 1, '5': 9, '10': 'pageToken'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListFollowingParticipantsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFollowingParticipantsRequestDescriptor =
    $convert.base64Decode(
        'CiBMaXN0Rm9sbG93aW5nUGFydGljaXBhbnRzUmVxdWVzdBIdCgpwYWdlX3Rva2VuGAEgASgJUg'
        'lwYWdlVG9rZW4SFAoFbGltaXQYAiABKAVSBWxpbWl0');

@$core.Deprecated('Use followingParticipantDescriptor instead')
const FollowingParticipant$json = {
  '1': 'FollowingParticipant',
  '2': [
    {'1': 'principal_id', '3': 1, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'available', '3': 3, '4': 1, '5': 8, '10': 'available'},
  ],
};

/// Descriptor for `FollowingParticipant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followingParticipantDescriptor = $convert.base64Decode(
    'ChRGb2xsb3dpbmdQYXJ0aWNpcGFudBIhCgxwcmluY2lwYWxfaWQYASABKAlSC3ByaW5jaXBhbE'
    'lkEiEKDGRpc3BsYXlfbmFtZRgCIAEoCVILZGlzcGxheU5hbWUSHAoJYXZhaWxhYmxlGAMgASgI'
    'UglhdmFpbGFibGU=');

@$core.Deprecated('Use listFollowingParticipantsResponseDescriptor instead')
const ListFollowingParticipantsResponse$json = {
  '1': 'ListFollowingParticipantsResponse',
  '2': [
    {
      '1': 'participants',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.FollowingParticipant',
      '10': 'participants'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'revision', '3': 3, '4': 1, '5': 3, '10': 'revision'},
  ],
};

/// Descriptor for `ListFollowingParticipantsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFollowingParticipantsResponseDescriptor =
    $convert.base64Decode(
        'CiFMaXN0Rm9sbG93aW5nUGFydGljaXBhbnRzUmVzcG9uc2USQgoMcGFydGljaXBhbnRzGAEgAy'
        'gLMh4uc3BhY2UudjEuRm9sbG93aW5nUGFydGljaXBhbnRSDHBhcnRpY2lwYW50cxImCg9uZXh0'
        'X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQYWdlVG9rZW4SGgoIcmV2aXNpb24YAyABKANSCHJldm'
        'lzaW9u');

@$core.Deprecated('Use listPersonalFeedRequestDescriptor instead')
const ListPersonalFeedRequest$json = {
  '1': 'ListPersonalFeedRequest',
  '2': [
    {'1': 'page_token', '3': 1, '4': 1, '5': 9, '10': 'pageToken'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListPersonalFeedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPersonalFeedRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0UGVyc29uYWxGZWVkUmVxdWVzdBIdCgpwYWdlX3Rva2VuGAEgASgJUglwYWdlVG9rZW'
        '4SFAoFbGltaXQYAiABKAVSBWxpbWl0');

@$core.Deprecated('Use personalFeedEntryDescriptor instead')
const PersonalFeedEntry$json = {
  '1': 'PersonalFeedEntry',
  '2': [
    {'1': 'channel_title', '3': 1, '4': 1, '5': 9, '10': 'channelTitle'},
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

/// Descriptor for `PersonalFeedEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List personalFeedEntryDescriptor = $convert.base64Decode(
    'ChFQZXJzb25hbEZlZWRFbnRyeRIjCg1jaGFubmVsX3RpdGxlGAEgASgJUgxjaGFubmVsVGl0bG'
    'USJgoEcG9zdBgCIAEoCzISLnNwYWNlLnYxLkZlZWRQb3N0UgRwb3N0');

@$core.Deprecated('Use listPersonalFeedResponseDescriptor instead')
const ListPersonalFeedResponse$json = {
  '1': 'ListPersonalFeedResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.PersonalFeedEntry',
      '10': 'entries'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'revision', '3': 3, '4': 1, '5': 3, '10': 'revision'},
  ],
};

/// Descriptor for `ListPersonalFeedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPersonalFeedResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0UGVyc29uYWxGZWVkUmVzcG9uc2USNQoHZW50cmllcxgBIAMoCzIbLnNwYWNlLnYxLl'
    'BlcnNvbmFsRmVlZEVudHJ5UgdlbnRyaWVzEiYKD25leHRfcGFnZV90b2tlbhgCIAEoCVINbmV4'
    'dFBhZ2VUb2tlbhIaCghyZXZpc2lvbhgDIAEoA1IIcmV2aXNpb24=');

const $core.Map<$core.String, $core.dynamic> ParticipantFollowServiceBase$json =
    {
  '1': 'ParticipantFollowService',
  '2': [
    {
      '1': 'GetParticipantFollowStates',
      '2': '.space.v1.GetParticipantFollowStatesRequest',
      '3': '.space.v1.GetParticipantFollowStatesResponse'
    },
    {
      '1': 'SetParticipantFollow',
      '2': '.space.v1.SetParticipantFollowRequest',
      '3': '.space.v1.SetParticipantFollowResponse'
    },
    {
      '1': 'ListFollowingParticipants',
      '2': '.space.v1.ListFollowingParticipantsRequest',
      '3': '.space.v1.ListFollowingParticipantsResponse'
    },
    {
      '1': 'ListPersonalFeed',
      '2': '.space.v1.ListPersonalFeedRequest',
      '3': '.space.v1.ListPersonalFeedResponse'
    },
  ],
};

@$core.Deprecated('Use participantFollowServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ParticipantFollowServiceBase$messageJson = {
  '.space.v1.GetParticipantFollowStatesRequest':
      GetParticipantFollowStatesRequest$json,
  '.space.v1.GetParticipantFollowStatesResponse':
      GetParticipantFollowStatesResponse$json,
  '.space.v1.ParticipantFollowState': ParticipantFollowState$json,
  '.space.v1.SetParticipantFollowRequest': SetParticipantFollowRequest$json,
  '.space.v1.SetParticipantFollowResponse': SetParticipantFollowResponse$json,
  '.space.v1.ListFollowingParticipantsRequest':
      ListFollowingParticipantsRequest$json,
  '.space.v1.ListFollowingParticipantsResponse':
      ListFollowingParticipantsResponse$json,
  '.space.v1.FollowingParticipant': FollowingParticipant$json,
  '.space.v1.ListPersonalFeedRequest': ListPersonalFeedRequest$json,
  '.space.v1.ListPersonalFeedResponse': ListPersonalFeedResponse$json,
  '.space.v1.PersonalFeedEntry': PersonalFeedEntry$json,
  '.space.v1.FeedPost': $0.FeedPost$json,
  '.space.v1.Asset': $1.Asset$json,
  '.space.v1.CommunityMention': $2.CommunityMention$json,
};

/// Descriptor for `ParticipantFollowService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List participantFollowServiceDescriptor = $convert.base64Decode(
    'ChhQYXJ0aWNpcGFudEZvbGxvd1NlcnZpY2USdwoaR2V0UGFydGljaXBhbnRGb2xsb3dTdGF0ZX'
    'MSKy5zcGFjZS52MS5HZXRQYXJ0aWNpcGFudEZvbGxvd1N0YXRlc1JlcXVlc3QaLC5zcGFjZS52'
    'MS5HZXRQYXJ0aWNpcGFudEZvbGxvd1N0YXRlc1Jlc3BvbnNlEmUKFFNldFBhcnRpY2lwYW50Rm'
    '9sbG93EiUuc3BhY2UudjEuU2V0UGFydGljaXBhbnRGb2xsb3dSZXF1ZXN0GiYuc3BhY2UudjEu'
    'U2V0UGFydGljaXBhbnRGb2xsb3dSZXNwb25zZRJ0ChlMaXN0Rm9sbG93aW5nUGFydGljaXBhbn'
    'RzEiouc3BhY2UudjEuTGlzdEZvbGxvd2luZ1BhcnRpY2lwYW50c1JlcXVlc3QaKy5zcGFjZS52'
    'MS5MaXN0Rm9sbG93aW5nUGFydGljaXBhbnRzUmVzcG9uc2USWQoQTGlzdFBlcnNvbmFsRmVlZB'
    'IhLnNwYWNlLnYxLkxpc3RQZXJzb25hbEZlZWRSZXF1ZXN0GiIuc3BhY2UudjEuTGlzdFBlcnNv'
    'bmFsRmVlZFJlc3BvbnNl');
