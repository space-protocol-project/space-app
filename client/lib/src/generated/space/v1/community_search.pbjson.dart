// This is a generated file - do not edit.
//
// Generated from space/v1/community_search.proto.

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

@$core.Deprecated('Use communitySearchKindDescriptor instead')
const CommunitySearchKind$json = {
  '1': 'CommunitySearchKind',
  '2': [
    {'1': 'COMMUNITY_SEARCH_KIND_UNSPECIFIED', '2': 0},
    {'1': 'COMMUNITY_SEARCH_KIND_FORUM_THREAD', '2': 1},
    {'1': 'COMMUNITY_SEARCH_KIND_FORUM_REPLY', '2': 2},
    {'1': 'COMMUNITY_SEARCH_KIND_FEED_POST', '2': 3},
    {'1': 'COMMUNITY_SEARCH_KIND_FEED_COMMENT', '2': 4},
  ],
};

/// Descriptor for `CommunitySearchKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List communitySearchKindDescriptor = $convert.base64Decode(
    'ChNDb21tdW5pdHlTZWFyY2hLaW5kEiUKIUNPTU1VTklUWV9TRUFSQ0hfS0lORF9VTlNQRUNJRk'
    'lFRBAAEiYKIkNPTU1VTklUWV9TRUFSQ0hfS0lORF9GT1JVTV9USFJFQUQQARIlCiFDT01NVU5J'
    'VFlfU0VBUkNIX0tJTkRfRk9SVU1fUkVQTFkQAhIjCh9DT01NVU5JVFlfU0VBUkNIX0tJTkRfRk'
    'VFRF9QT1NUEAMSJgoiQ09NTVVOSVRZX1NFQVJDSF9LSU5EX0ZFRURfQ09NTUVOVBAE');

@$core.Deprecated('Use searchCommunityContentRequestDescriptor instead')
const SearchCommunityContentRequest$json = {
  '1': 'SearchCommunityContentRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'query', '3': 2, '4': 1, '5': 9, '10': 'query'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
    {'1': 'limit', '3': 4, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `SearchCommunityContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchCommunityContentRequestDescriptor =
    $convert.base64Decode(
        'Ch1TZWFyY2hDb21tdW5pdHlDb250ZW50UmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaG'
        'FubmVsSWQSFAoFcXVlcnkYAiABKAlSBXF1ZXJ5Eh0KCnBhZ2VfdG9rZW4YAyABKAlSCXBhZ2VU'
        'b2tlbhIUCgVsaW1pdBgEIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use communitySearchResultDescriptor instead')
const CommunitySearchResult$json = {
  '1': 'CommunitySearchResult',
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
    {'1': 'parent_id', '3': 3, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'snippet', '3': 5, '4': 1, '5': 9, '10': 'snippet'},
    {'1': 'author_id', '3': 6, '4': 1, '5': 9, '10': 'authorId'},
    {'1': 'author_name', '3': 7, '4': 1, '5': 9, '10': 'authorName'},
    {'1': 'created_at_unix', '3': 8, '4': 1, '5': 3, '10': 'createdAtUnix'},
    {'1': 'sequence', '3': 9, '4': 1, '5': 3, '10': 'sequence'},
  ],
};

/// Descriptor for `CommunitySearchResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communitySearchResultDescriptor = $convert.base64Decode(
    'ChVDb21tdW5pdHlTZWFyY2hSZXN1bHQSMQoEa2luZBgBIAEoDjIdLnNwYWNlLnYxLkNvbW11bm'
    'l0eVNlYXJjaEtpbmRSBGtpbmQSDgoCaWQYAiABKAlSAmlkEhsKCXBhcmVudF9pZBgDIAEoCVII'
    'cGFyZW50SWQSFAoFdGl0bGUYBCABKAlSBXRpdGxlEhgKB3NuaXBwZXQYBSABKAlSB3NuaXBwZX'
    'QSGwoJYXV0aG9yX2lkGAYgASgJUghhdXRob3JJZBIfCgthdXRob3JfbmFtZRgHIAEoCVIKYXV0'
    'aG9yTmFtZRImCg9jcmVhdGVkX2F0X3VuaXgYCCABKANSDWNyZWF0ZWRBdFVuaXgSGgoIc2VxdW'
    'VuY2UYCSABKANSCHNlcXVlbmNl');

@$core.Deprecated('Use searchCommunityContentResponseDescriptor instead')
const SearchCommunityContentResponse$json = {
  '1': 'SearchCommunityContentResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.CommunitySearchResult',
      '10': 'results'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `SearchCommunityContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchCommunityContentResponseDescriptor =
    $convert.base64Decode(
        'Ch5TZWFyY2hDb21tdW5pdHlDb250ZW50UmVzcG9uc2USOQoHcmVzdWx0cxgBIAMoCzIfLnNwYW'
        'NlLnYxLkNvbW11bml0eVNlYXJjaFJlc3VsdFIHcmVzdWx0cxImCg9uZXh0X3BhZ2VfdG9rZW4Y'
        'AiABKAlSDW5leHRQYWdlVG9rZW4=');

const $core.Map<$core.String, $core.dynamic> CommunitySearchServiceBase$json = {
  '1': 'CommunitySearchService',
  '2': [
    {
      '1': 'SearchCommunityContent',
      '2': '.space.v1.SearchCommunityContentRequest',
      '3': '.space.v1.SearchCommunityContentResponse'
    },
  ],
};

@$core.Deprecated('Use communitySearchServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    CommunitySearchServiceBase$messageJson = {
  '.space.v1.SearchCommunityContentRequest': SearchCommunityContentRequest$json,
  '.space.v1.SearchCommunityContentResponse':
      SearchCommunityContentResponse$json,
  '.space.v1.CommunitySearchResult': CommunitySearchResult$json,
};

/// Descriptor for `CommunitySearchService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List communitySearchServiceDescriptor = $convert.base64Decode(
    'ChZDb21tdW5pdHlTZWFyY2hTZXJ2aWNlEmsKFlNlYXJjaENvbW11bml0eUNvbnRlbnQSJy5zcG'
    'FjZS52MS5TZWFyY2hDb21tdW5pdHlDb250ZW50UmVxdWVzdBooLnNwYWNlLnYxLlNlYXJjaENv'
    'bW11bml0eUNvbnRlbnRSZXNwb25zZQ==');
