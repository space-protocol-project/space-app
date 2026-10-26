// This is a generated file - do not edit.
//
// Generated from space/v1/community_reactions.proto.

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

import 'community_mentions.pbjson.dart' as $0;

@$core.Deprecated('Use communityReactionDescriptor instead')
const CommunityReaction$json = {
  '1': 'CommunityReaction',
  '2': [
    {'1': 'emoji', '3': 1, '4': 1, '5': 9, '10': 'emoji'},
    {'1': 'count', '3': 2, '4': 1, '5': 3, '10': 'count'},
    {'1': 'selected', '3': 3, '4': 1, '5': 8, '10': 'selected'},
  ],
};

/// Descriptor for `CommunityReaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communityReactionDescriptor = $convert.base64Decode(
    'ChFDb21tdW5pdHlSZWFjdGlvbhIUCgVlbW9qaRgBIAEoCVIFZW1vamkSFAoFY291bnQYAiABKA'
    'NSBWNvdW50EhoKCHNlbGVjdGVkGAMgASgIUghzZWxlY3RlZA==');

@$core.Deprecated('Use communityReactionStateDescriptor instead')
const CommunityReactionState$json = {
  '1': 'CommunityReactionState',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.CommunityContentReference',
      '10': 'content'
    },
    {'1': 'revision', '3': 2, '4': 1, '5': 3, '10': 'revision'},
    {
      '1': 'reactions',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.CommunityReaction',
      '10': 'reactions'
    },
    {'1': 'can_react', '3': 4, '4': 1, '5': 8, '10': 'canReact'},
  ],
};

/// Descriptor for `CommunityReactionState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communityReactionStateDescriptor = $convert.base64Decode(
    'ChZDb21tdW5pdHlSZWFjdGlvblN0YXRlEj0KB2NvbnRlbnQYASABKAsyIy5zcGFjZS52MS5Db2'
    '1tdW5pdHlDb250ZW50UmVmZXJlbmNlUgdjb250ZW50EhoKCHJldmlzaW9uGAIgASgDUghyZXZp'
    'c2lvbhI5CglyZWFjdGlvbnMYAyADKAsyGy5zcGFjZS52MS5Db21tdW5pdHlSZWFjdGlvblIJcm'
    'VhY3Rpb25zEhsKCWNhbl9yZWFjdBgEIAEoCFIIY2FuUmVhY3Q=');

@$core.Deprecated('Use listCommunityReactionsRequestDescriptor instead')
const ListCommunityReactionsRequest$json = {
  '1': 'ListCommunityReactionsRequest',
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

/// Descriptor for `ListCommunityReactionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCommunityReactionsRequestDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0Q29tbXVuaXR5UmVhY3Rpb25zUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaG'
        'FubmVsSWQSPwoIY29udGVudHMYAiADKAsyIy5zcGFjZS52MS5Db21tdW5pdHlDb250ZW50UmVm'
        'ZXJlbmNlUghjb250ZW50cw==');

@$core.Deprecated('Use listCommunityReactionsResponseDescriptor instead')
const ListCommunityReactionsResponse$json = {
  '1': 'ListCommunityReactionsResponse',
  '2': [
    {
      '1': 'states',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.CommunityReactionState',
      '10': 'states'
    },
  ],
};

/// Descriptor for `ListCommunityReactionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCommunityReactionsResponseDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0Q29tbXVuaXR5UmVhY3Rpb25zUmVzcG9uc2USOAoGc3RhdGVzGAEgAygLMiAuc3BhY2'
        'UudjEuQ29tbXVuaXR5UmVhY3Rpb25TdGF0ZVIGc3RhdGVz');

@$core.Deprecated('Use setCommunityReactionRequestDescriptor instead')
const SetCommunityReactionRequest$json = {
  '1': 'SetCommunityReactionRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {
      '1': 'content',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.space.v1.CommunityContentReference',
      '10': 'content'
    },
    {'1': 'emoji', '3': 3, '4': 1, '5': 9, '10': 'emoji'},
    {'1': 'active', '3': 4, '4': 1, '5': 8, '10': 'active'},
    {
      '1': 'expected_revision',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
    {'1': 'idempotency_key', '3': 6, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `SetCommunityReactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setCommunityReactionRequestDescriptor = $convert.base64Decode(
    'ChtTZXRDb21tdW5pdHlSZWFjdGlvblJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm'
    '5lbElkEj0KB2NvbnRlbnQYAiABKAsyIy5zcGFjZS52MS5Db21tdW5pdHlDb250ZW50UmVmZXJl'
    'bmNlUgdjb250ZW50EhQKBWVtb2ppGAMgASgJUgVlbW9qaRIWCgZhY3RpdmUYBCABKAhSBmFjdG'
    'l2ZRIrChFleHBlY3RlZF9yZXZpc2lvbhgFIAEoA1IQZXhwZWN0ZWRSZXZpc2lvbhInCg9pZGVt'
    'cG90ZW5jeV9rZXkYBiABKAlSDmlkZW1wb3RlbmN5S2V5');

@$core.Deprecated('Use setCommunityReactionResponseDescriptor instead')
const SetCommunityReactionResponse$json = {
  '1': 'SetCommunityReactionResponse',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.CommunityReactionState',
      '10': 'state'
    },
    {'1': 'idempotency_key', '3': 2, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'applied_revision', '3': 3, '4': 1, '5': 3, '10': 'appliedRevision'},
  ],
};

/// Descriptor for `SetCommunityReactionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setCommunityReactionResponseDescriptor = $convert.base64Decode(
    'ChxTZXRDb21tdW5pdHlSZWFjdGlvblJlc3BvbnNlEjYKBXN0YXRlGAEgASgLMiAuc3BhY2Uudj'
    'EuQ29tbXVuaXR5UmVhY3Rpb25TdGF0ZVIFc3RhdGUSJwoPaWRlbXBvdGVuY3lfa2V5GAIgASgJ'
    'Ug5pZGVtcG90ZW5jeUtleRIpChBhcHBsaWVkX3JldmlzaW9uGAMgASgDUg9hcHBsaWVkUmV2aX'
    'Npb24=');

const $core.Map<$core.String, $core.dynamic> CommunityReactionServiceBase$json =
    {
  '1': 'CommunityReactionService',
  '2': [
    {
      '1': 'ListCommunityReactions',
      '2': '.space.v1.ListCommunityReactionsRequest',
      '3': '.space.v1.ListCommunityReactionsResponse'
    },
    {
      '1': 'SetCommunityReaction',
      '2': '.space.v1.SetCommunityReactionRequest',
      '3': '.space.v1.SetCommunityReactionResponse'
    },
  ],
};

@$core.Deprecated('Use communityReactionServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    CommunityReactionServiceBase$messageJson = {
  '.space.v1.ListCommunityReactionsRequest': ListCommunityReactionsRequest$json,
  '.space.v1.CommunityContentReference': $0.CommunityContentReference$json,
  '.space.v1.ListCommunityReactionsResponse':
      ListCommunityReactionsResponse$json,
  '.space.v1.CommunityReactionState': CommunityReactionState$json,
  '.space.v1.CommunityReaction': CommunityReaction$json,
  '.space.v1.SetCommunityReactionRequest': SetCommunityReactionRequest$json,
  '.space.v1.SetCommunityReactionResponse': SetCommunityReactionResponse$json,
};

/// Descriptor for `CommunityReactionService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List communityReactionServiceDescriptor = $convert.base64Decode(
    'ChhDb21tdW5pdHlSZWFjdGlvblNlcnZpY2USawoWTGlzdENvbW11bml0eVJlYWN0aW9ucxInLn'
    'NwYWNlLnYxLkxpc3RDb21tdW5pdHlSZWFjdGlvbnNSZXF1ZXN0Giguc3BhY2UudjEuTGlzdENv'
    'bW11bml0eVJlYWN0aW9uc1Jlc3BvbnNlEmUKFFNldENvbW11bml0eVJlYWN0aW9uEiUuc3BhY2'
    'UudjEuU2V0Q29tbXVuaXR5UmVhY3Rpb25SZXF1ZXN0GiYuc3BhY2UudjEuU2V0Q29tbXVuaXR5'
    'UmVhY3Rpb25SZXNwb25zZQ==');
