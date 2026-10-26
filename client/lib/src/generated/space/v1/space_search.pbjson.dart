// This is a generated file - do not edit.
//
// Generated from space/v1/space_search.proto.

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

@$core.Deprecated('Use spaceSearchKindDescriptor instead')
const SpaceSearchKind$json = {
  '1': 'SpaceSearchKind',
  '2': [
    {'1': 'SPACE_SEARCH_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SPACE_SEARCH_KIND_CHAT_MESSAGE', '2': 1},
    {'1': 'SPACE_SEARCH_KIND_FORUM_THREAD', '2': 2},
    {'1': 'SPACE_SEARCH_KIND_FORUM_REPLY', '2': 3},
    {'1': 'SPACE_SEARCH_KIND_FEED_POST', '2': 4},
    {'1': 'SPACE_SEARCH_KIND_FEED_COMMENT', '2': 5},
  ],
};

/// Descriptor for `SpaceSearchKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List spaceSearchKindDescriptor = $convert.base64Decode(
    'Cg9TcGFjZVNlYXJjaEtpbmQSIQodU1BBQ0VfU0VBUkNIX0tJTkRfVU5TUEVDSUZJRUQQABIiCh'
    '5TUEFDRV9TRUFSQ0hfS0lORF9DSEFUX01FU1NBR0UQARIiCh5TUEFDRV9TRUFSQ0hfS0lORF9G'
    'T1JVTV9USFJFQUQQAhIhCh1TUEFDRV9TRUFSQ0hfS0lORF9GT1JVTV9SRVBMWRADEh8KG1NQQU'
    'NFX1NFQVJDSF9LSU5EX0ZFRURfUE9TVBAEEiIKHlNQQUNFX1NFQVJDSF9LSU5EX0ZFRURfQ09N'
    'TUVOVBAF');

@$core.Deprecated('Use searchSpaceRequestDescriptor instead')
const SearchSpaceRequest$json = {
  '1': 'SearchSpaceRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'page_token', '3': 2, '4': 1, '5': 9, '10': 'pageToken'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `SearchSpaceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchSpaceRequestDescriptor = $convert.base64Decode(
    'ChJTZWFyY2hTcGFjZVJlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5Eh0KCnBhZ2VfdG9rZW'
    '4YAiABKAlSCXBhZ2VUb2tlbhIUCgVsaW1pdBgDIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use spaceSearchResultDescriptor instead')
const SpaceSearchResult$json = {
  '1': 'SpaceSearchResult',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'channel_title', '3': 2, '4': 1, '5': 9, '10': 'channelTitle'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.space.v1.SpaceSearchKind',
      '10': 'kind'
    },
    {'1': 'id', '3': 4, '4': 1, '5': 9, '10': 'id'},
    {'1': 'parent_id', '3': 5, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'snippet', '3': 7, '4': 1, '5': 9, '10': 'snippet'},
    {'1': 'author_id', '3': 8, '4': 1, '5': 9, '10': 'authorId'},
    {'1': 'author_name', '3': 9, '4': 1, '5': 9, '10': 'authorName'},
    {
      '1': 'created_at_unix_ms',
      '3': 10,
      '4': 1,
      '5': 3,
      '10': 'createdAtUnixMs'
    },
    {'1': 'sequence', '3': 11, '4': 1, '5': 3, '10': 'sequence'},
  ],
};

/// Descriptor for `SpaceSearchResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spaceSearchResultDescriptor = $convert.base64Decode(
    'ChFTcGFjZVNlYXJjaFJlc3VsdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSIwoNY2'
    'hhbm5lbF90aXRsZRgCIAEoCVIMY2hhbm5lbFRpdGxlEi0KBGtpbmQYAyABKA4yGS5zcGFjZS52'
    'MS5TcGFjZVNlYXJjaEtpbmRSBGtpbmQSDgoCaWQYBCABKAlSAmlkEhsKCXBhcmVudF9pZBgFIA'
    'EoCVIIcGFyZW50SWQSFAoFdGl0bGUYBiABKAlSBXRpdGxlEhgKB3NuaXBwZXQYByABKAlSB3Nu'
    'aXBwZXQSGwoJYXV0aG9yX2lkGAggASgJUghhdXRob3JJZBIfCgthdXRob3JfbmFtZRgJIAEoCV'
    'IKYXV0aG9yTmFtZRIrChJjcmVhdGVkX2F0X3VuaXhfbXMYCiABKANSD2NyZWF0ZWRBdFVuaXhN'
    'cxIaCghzZXF1ZW5jZRgLIAEoA1IIc2VxdWVuY2U=');

@$core.Deprecated('Use searchSpaceResponseDescriptor instead')
const SearchSpaceResponse$json = {
  '1': 'SearchSpaceResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.SpaceSearchResult',
      '10': 'results'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `SearchSpaceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchSpaceResponseDescriptor = $convert.base64Decode(
    'ChNTZWFyY2hTcGFjZVJlc3BvbnNlEjUKB3Jlc3VsdHMYASADKAsyGy5zcGFjZS52MS5TcGFjZV'
    'NlYXJjaFJlc3VsdFIHcmVzdWx0cxImCg9uZXh0X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQYWdl'
    'VG9rZW4=');

const $core.Map<$core.String, $core.dynamic> SpaceSearchServiceBase$json = {
  '1': 'SpaceSearchService',
  '2': [
    {
      '1': 'SearchSpace',
      '2': '.space.v1.SearchSpaceRequest',
      '3': '.space.v1.SearchSpaceResponse'
    },
  ],
};

@$core.Deprecated('Use spaceSearchServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    SpaceSearchServiceBase$messageJson = {
  '.space.v1.SearchSpaceRequest': SearchSpaceRequest$json,
  '.space.v1.SearchSpaceResponse': SearchSpaceResponse$json,
  '.space.v1.SpaceSearchResult': SpaceSearchResult$json,
};

/// Descriptor for `SpaceSearchService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List spaceSearchServiceDescriptor = $convert.base64Decode(
    'ChJTcGFjZVNlYXJjaFNlcnZpY2USSgoLU2VhcmNoU3BhY2USHC5zcGFjZS52MS5TZWFyY2hTcG'
    'FjZVJlcXVlc3QaHS5zcGFjZS52MS5TZWFyY2hTcGFjZVJlc3BvbnNl');
