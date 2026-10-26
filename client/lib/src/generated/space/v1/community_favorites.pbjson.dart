// This is a generated file - do not edit.
//
// Generated from space/v1/community_favorites.proto.

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
import 'community_search.pbjson.dart' as $1;

@$core.Deprecated('Use communityFavoriteStateDescriptor instead')
const CommunityFavoriteState$json = {
  '1': 'CommunityFavoriteState',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.CommunityContentReference',
      '10': 'content'
    },
    {'1': 'saved', '3': 2, '4': 1, '5': 8, '10': 'saved'},
    {'1': 'revision', '3': 3, '4': 1, '5': 3, '10': 'revision'},
  ],
};

/// Descriptor for `CommunityFavoriteState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communityFavoriteStateDescriptor = $convert.base64Decode(
    'ChZDb21tdW5pdHlGYXZvcml0ZVN0YXRlEj0KB2NvbnRlbnQYASABKAsyIy5zcGFjZS52MS5Db2'
    '1tdW5pdHlDb250ZW50UmVmZXJlbmNlUgdjb250ZW50EhQKBXNhdmVkGAIgASgIUgVzYXZlZBIa'
    'CghyZXZpc2lvbhgDIAEoA1IIcmV2aXNpb24=');

@$core.Deprecated('Use getCommunityFavoriteStatesRequestDescriptor instead')
const GetCommunityFavoriteStatesRequest$json = {
  '1': 'GetCommunityFavoriteStatesRequest',
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

/// Descriptor for `GetCommunityFavoriteStatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommunityFavoriteStatesRequestDescriptor =
    $convert.base64Decode(
        'CiFHZXRDb21tdW5pdHlGYXZvcml0ZVN0YXRlc1JlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCV'
        'IJY2hhbm5lbElkEj8KCGNvbnRlbnRzGAIgAygLMiMuc3BhY2UudjEuQ29tbXVuaXR5Q29udGVu'
        'dFJlZmVyZW5jZVIIY29udGVudHM=');

@$core.Deprecated('Use getCommunityFavoriteStatesResponseDescriptor instead')
const GetCommunityFavoriteStatesResponse$json = {
  '1': 'GetCommunityFavoriteStatesResponse',
  '2': [
    {
      '1': 'states',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.CommunityFavoriteState',
      '10': 'states'
    },
  ],
};

/// Descriptor for `GetCommunityFavoriteStatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommunityFavoriteStatesResponseDescriptor =
    $convert.base64Decode(
        'CiJHZXRDb21tdW5pdHlGYXZvcml0ZVN0YXRlc1Jlc3BvbnNlEjgKBnN0YXRlcxgBIAMoCzIgLn'
        'NwYWNlLnYxLkNvbW11bml0eUZhdm9yaXRlU3RhdGVSBnN0YXRlcw==');

@$core.Deprecated('Use listCommunityFavoritesRequestDescriptor instead')
const ListCommunityFavoritesRequest$json = {
  '1': 'ListCommunityFavoritesRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'page_token', '3': 2, '4': 1, '5': 9, '10': 'pageToken'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListCommunityFavoritesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCommunityFavoritesRequestDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0Q29tbXVuaXR5RmF2b3JpdGVzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaG'
        'FubmVsSWQSHQoKcGFnZV90b2tlbhgCIAEoCVIJcGFnZVRva2VuEhQKBWxpbWl0GAMgASgFUgVs'
        'aW1pdA==');

@$core.Deprecated('Use communityFavoriteDescriptor instead')
const CommunityFavorite$json = {
  '1': 'CommunityFavorite',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.CommunitySearchResult',
      '10': 'result'
    },
    {
      '1': 'saved_at_unix_micros',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'savedAtUnixMicros'
    },
  ],
};

/// Descriptor for `CommunityFavorite`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communityFavoriteDescriptor = $convert.base64Decode(
    'ChFDb21tdW5pdHlGYXZvcml0ZRI3CgZyZXN1bHQYASABKAsyHy5zcGFjZS52MS5Db21tdW5pdH'
    'lTZWFyY2hSZXN1bHRSBnJlc3VsdBIvChRzYXZlZF9hdF91bml4X21pY3JvcxgCIAEoA1IRc2F2'
    'ZWRBdFVuaXhNaWNyb3M=');

@$core.Deprecated('Use listCommunityFavoritesResponseDescriptor instead')
const ListCommunityFavoritesResponse$json = {
  '1': 'ListCommunityFavoritesResponse',
  '2': [
    {
      '1': 'favorites',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.CommunityFavorite',
      '10': 'favorites'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `ListCommunityFavoritesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCommunityFavoritesResponseDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0Q29tbXVuaXR5RmF2b3JpdGVzUmVzcG9uc2USOQoJZmF2b3JpdGVzGAEgAygLMhsuc3'
        'BhY2UudjEuQ29tbXVuaXR5RmF2b3JpdGVSCWZhdm9yaXRlcxImCg9uZXh0X3BhZ2VfdG9rZW4Y'
        'AiABKAlSDW5leHRQYWdlVG9rZW4=');

@$core.Deprecated('Use setCommunityFavoriteRequestDescriptor instead')
const SetCommunityFavoriteRequest$json = {
  '1': 'SetCommunityFavoriteRequest',
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
    {'1': 'saved', '3': 3, '4': 1, '5': 8, '10': 'saved'},
    {
      '1': 'expected_revision',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
    {'1': 'idempotency_key', '3': 5, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `SetCommunityFavoriteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setCommunityFavoriteRequestDescriptor = $convert.base64Decode(
    'ChtTZXRDb21tdW5pdHlGYXZvcml0ZVJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm'
    '5lbElkEj0KB2NvbnRlbnQYAiABKAsyIy5zcGFjZS52MS5Db21tdW5pdHlDb250ZW50UmVmZXJl'
    'bmNlUgdjb250ZW50EhQKBXNhdmVkGAMgASgIUgVzYXZlZBIrChFleHBlY3RlZF9yZXZpc2lvbh'
    'gEIAEoA1IQZXhwZWN0ZWRSZXZpc2lvbhInCg9pZGVtcG90ZW5jeV9rZXkYBSABKAlSDmlkZW1w'
    'b3RlbmN5S2V5');

@$core.Deprecated('Use setCommunityFavoriteResponseDescriptor instead')
const SetCommunityFavoriteResponse$json = {
  '1': 'SetCommunityFavoriteResponse',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.CommunityFavoriteState',
      '10': 'state'
    },
    {'1': 'idempotency_key', '3': 2, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'applied_revision', '3': 3, '4': 1, '5': 3, '10': 'appliedRevision'},
  ],
};

/// Descriptor for `SetCommunityFavoriteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setCommunityFavoriteResponseDescriptor = $convert.base64Decode(
    'ChxTZXRDb21tdW5pdHlGYXZvcml0ZVJlc3BvbnNlEjYKBXN0YXRlGAEgASgLMiAuc3BhY2Uudj'
    'EuQ29tbXVuaXR5RmF2b3JpdGVTdGF0ZVIFc3RhdGUSJwoPaWRlbXBvdGVuY3lfa2V5GAIgASgJ'
    'Ug5pZGVtcG90ZW5jeUtleRIpChBhcHBsaWVkX3JldmlzaW9uGAMgASgDUg9hcHBsaWVkUmV2aX'
    'Npb24=');

const $core.Map<$core.String, $core.dynamic> CommunityFavoriteServiceBase$json =
    {
  '1': 'CommunityFavoriteService',
  '2': [
    {
      '1': 'GetCommunityFavoriteStates',
      '2': '.space.v1.GetCommunityFavoriteStatesRequest',
      '3': '.space.v1.GetCommunityFavoriteStatesResponse'
    },
    {
      '1': 'ListCommunityFavorites',
      '2': '.space.v1.ListCommunityFavoritesRequest',
      '3': '.space.v1.ListCommunityFavoritesResponse'
    },
    {
      '1': 'SetCommunityFavorite',
      '2': '.space.v1.SetCommunityFavoriteRequest',
      '3': '.space.v1.SetCommunityFavoriteResponse'
    },
  ],
};

@$core.Deprecated('Use communityFavoriteServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    CommunityFavoriteServiceBase$messageJson = {
  '.space.v1.GetCommunityFavoriteStatesRequest':
      GetCommunityFavoriteStatesRequest$json,
  '.space.v1.CommunityContentReference': $0.CommunityContentReference$json,
  '.space.v1.GetCommunityFavoriteStatesResponse':
      GetCommunityFavoriteStatesResponse$json,
  '.space.v1.CommunityFavoriteState': CommunityFavoriteState$json,
  '.space.v1.ListCommunityFavoritesRequest': ListCommunityFavoritesRequest$json,
  '.space.v1.ListCommunityFavoritesResponse':
      ListCommunityFavoritesResponse$json,
  '.space.v1.CommunityFavorite': CommunityFavorite$json,
  '.space.v1.CommunitySearchResult': $1.CommunitySearchResult$json,
  '.space.v1.SetCommunityFavoriteRequest': SetCommunityFavoriteRequest$json,
  '.space.v1.SetCommunityFavoriteResponse': SetCommunityFavoriteResponse$json,
};

/// Descriptor for `CommunityFavoriteService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List communityFavoriteServiceDescriptor = $convert.base64Decode(
    'ChhDb21tdW5pdHlGYXZvcml0ZVNlcnZpY2USdwoaR2V0Q29tbXVuaXR5RmF2b3JpdGVTdGF0ZX'
    'MSKy5zcGFjZS52MS5HZXRDb21tdW5pdHlGYXZvcml0ZVN0YXRlc1JlcXVlc3QaLC5zcGFjZS52'
    'MS5HZXRDb21tdW5pdHlGYXZvcml0ZVN0YXRlc1Jlc3BvbnNlEmsKFkxpc3RDb21tdW5pdHlGYX'
    'Zvcml0ZXMSJy5zcGFjZS52MS5MaXN0Q29tbXVuaXR5RmF2b3JpdGVzUmVxdWVzdBooLnNwYWNl'
    'LnYxLkxpc3RDb21tdW5pdHlGYXZvcml0ZXNSZXNwb25zZRJlChRTZXRDb21tdW5pdHlGYXZvcm'
    'l0ZRIlLnNwYWNlLnYxLlNldENvbW11bml0eUZhdm9yaXRlUmVxdWVzdBomLnNwYWNlLnYxLlNl'
    'dENvbW11bml0eUZhdm9yaXRlUmVzcG9uc2U=');
