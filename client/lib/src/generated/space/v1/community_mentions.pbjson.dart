// This is a generated file - do not edit.
//
// Generated from space/v1/community_mentions.proto.

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

@$core.Deprecated('Use communityMentionDescriptor instead')
const CommunityMention$json = {
  '1': 'CommunityMention',
  '2': [
    {'1': 'principal_id', '3': 1, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'start', '3': 3, '4': 1, '5': 5, '10': 'start'},
    {'1': 'length', '3': 4, '4': 1, '5': 5, '10': 'length'},
  ],
};

/// Descriptor for `CommunityMention`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communityMentionDescriptor = $convert.base64Decode(
    'ChBDb21tdW5pdHlNZW50aW9uEiEKDHByaW5jaXBhbF9pZBgBIAEoCVILcHJpbmNpcGFsSWQSIQ'
    'oMZGlzcGxheV9uYW1lGAIgASgJUgtkaXNwbGF5TmFtZRIUCgVzdGFydBgDIAEoBVIFc3RhcnQS'
    'FgoGbGVuZ3RoGAQgASgFUgZsZW5ndGg=');

@$core.Deprecated('Use listMentionCandidatesRequestDescriptor instead')
const ListMentionCandidatesRequest$json = {
  '1': 'ListMentionCandidatesRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'parent_id', '3': 2, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'query', '3': 3, '4': 1, '5': 9, '10': 'query'},
  ],
};

/// Descriptor for `ListMentionCandidatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMentionCandidatesRequestDescriptor =
    $convert.base64Decode(
        'ChxMaXN0TWVudGlvbkNhbmRpZGF0ZXNSZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW'
        '5uZWxJZBIbCglwYXJlbnRfaWQYAiABKAlSCHBhcmVudElkEhQKBXF1ZXJ5GAMgASgJUgVxdWVy'
        'eQ==');

@$core.Deprecated('Use mentionCandidateDescriptor instead')
const MentionCandidate$json = {
  '1': 'MentionCandidate',
  '2': [
    {'1': 'principal_id', '3': 1, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
  ],
};

/// Descriptor for `MentionCandidate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mentionCandidateDescriptor = $convert.base64Decode(
    'ChBNZW50aW9uQ2FuZGlkYXRlEiEKDHByaW5jaXBhbF9pZBgBIAEoCVILcHJpbmNpcGFsSWQSIQ'
    'oMZGlzcGxheV9uYW1lGAIgASgJUgtkaXNwbGF5TmFtZQ==');

@$core.Deprecated('Use listMentionCandidatesResponseDescriptor instead')
const ListMentionCandidatesResponse$json = {
  '1': 'ListMentionCandidatesResponse',
  '2': [
    {
      '1': 'candidates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.MentionCandidate',
      '10': 'candidates'
    },
  ],
};

/// Descriptor for `ListMentionCandidatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMentionCandidatesResponseDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0TWVudGlvbkNhbmRpZGF0ZXNSZXNwb25zZRI6CgpjYW5kaWRhdGVzGAEgAygLMhouc3'
        'BhY2UudjEuTWVudGlvbkNhbmRpZGF0ZVIKY2FuZGlkYXRlcw==');

@$core.Deprecated('Use communityContentReferenceDescriptor instead')
const CommunityContentReference$json = {
  '1': 'CommunityContentReference',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.space.v1.CommunitySearchKind',
      '10': 'kind'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `CommunityContentReference`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communityContentReferenceDescriptor =
    $convert.base64Decode(
        'ChlDb21tdW5pdHlDb250ZW50UmVmZXJlbmNlEjEKBGtpbmQYASABKA4yHS5zcGFjZS52MS5Db2'
        '1tdW5pdHlTZWFyY2hLaW5kUgRraW5kEg4KAmlkGAIgASgJUgJpZA==');

@$core.Deprecated('Use markCommunityMentionsReadRequestDescriptor instead')
const MarkCommunityMentionsReadRequest$json = {
  '1': 'MarkCommunityMentionsReadRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {
      '1': 'contents',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.space.v1.CommunityContentReference',
      '10': 'contents'
    },
  ],
};

/// Descriptor for `MarkCommunityMentionsReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markCommunityMentionsReadRequestDescriptor =
    $convert.base64Decode(
        'CiBNYXJrQ29tbXVuaXR5TWVudGlvbnNSZWFkUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUg'
        'ljaGFubmVsSWQSPwoIY29udGVudHMYAiADKAsyIy5zcGFjZS52MS5Db21tdW5pdHlDb250ZW50'
        'UmVmZXJlbmNlUghjb250ZW50cw==');

@$core.Deprecated('Use markCommunityMentionsReadResponseDescriptor instead')
const MarkCommunityMentionsReadResponse$json = {
  '1': 'MarkCommunityMentionsReadResponse',
};

/// Descriptor for `MarkCommunityMentionsReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markCommunityMentionsReadResponseDescriptor =
    $convert.base64Decode('CiFNYXJrQ29tbXVuaXR5TWVudGlvbnNSZWFkUmVzcG9uc2U=');

const $core.Map<$core.String, $core.dynamic> CommunityMentionServiceBase$json =
    {
  '1': 'CommunityMentionService',
  '2': [
    {
      '1': 'ListMentionCandidates',
      '2': '.space.v1.ListMentionCandidatesRequest',
      '3': '.space.v1.ListMentionCandidatesResponse'
    },
    {
      '1': 'MarkCommunityMentionsRead',
      '2': '.space.v1.MarkCommunityMentionsReadRequest',
      '3': '.space.v1.MarkCommunityMentionsReadResponse'
    },
  ],
};

@$core.Deprecated('Use communityMentionServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    CommunityMentionServiceBase$messageJson = {
  '.space.v1.ListMentionCandidatesRequest': ListMentionCandidatesRequest$json,
  '.space.v1.ListMentionCandidatesResponse': ListMentionCandidatesResponse$json,
  '.space.v1.MentionCandidate': MentionCandidate$json,
  '.space.v1.MarkCommunityMentionsReadRequest':
      MarkCommunityMentionsReadRequest$json,
  '.space.v1.CommunityContentReference': CommunityContentReference$json,
  '.space.v1.MarkCommunityMentionsReadResponse':
      MarkCommunityMentionsReadResponse$json,
};

/// Descriptor for `CommunityMentionService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List communityMentionServiceDescriptor = $convert.base64Decode(
    'ChdDb21tdW5pdHlNZW50aW9uU2VydmljZRJoChVMaXN0TWVudGlvbkNhbmRpZGF0ZXMSJi5zcG'
    'FjZS52MS5MaXN0TWVudGlvbkNhbmRpZGF0ZXNSZXF1ZXN0Gicuc3BhY2UudjEuTGlzdE1lbnRp'
    'b25DYW5kaWRhdGVzUmVzcG9uc2USdAoZTWFya0NvbW11bml0eU1lbnRpb25zUmVhZBIqLnNwYW'
    'NlLnYxLk1hcmtDb21tdW5pdHlNZW50aW9uc1JlYWRSZXF1ZXN0Gisuc3BhY2UudjEuTWFya0Nv'
    'bW11bml0eU1lbnRpb25zUmVhZFJlc3BvbnNl');
