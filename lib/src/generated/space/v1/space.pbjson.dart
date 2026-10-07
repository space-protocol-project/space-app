// This is a generated file - do not edit.
//
// Generated from space/v1/space.proto.

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

@$core.Deprecated('Use subscribeRequestDescriptor instead')
const SubscribeRequest$json = {
  '1': 'SubscribeRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after', '3': 2, '4': 1, '5': 9, '10': 'after'},
  ],
};

/// Descriptor for `SubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeRequestDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpYmVSZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW5uZWxJZBIUCgVhZn'
    'RlchgCIAEoCVIFYWZ0ZXI=');

@$core.Deprecated('Use subscribeResponseDescriptor instead')
const SubscribeResponse$json = {
  '1': 'SubscribeResponse',
  '2': [
    {
      '1': 'event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Event',
      '10': 'event'
    },
    {'1': 'cursor', '3': 2, '4': 1, '5': 9, '10': 'cursor'},
    {'1': 'heartbeat', '3': 3, '4': 1, '5': 8, '10': 'heartbeat'},
  ],
};

/// Descriptor for `SubscribeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeResponseDescriptor = $convert.base64Decode(
    'ChFTdWJzY3JpYmVSZXNwb25zZRIlCgVldmVudBgBIAEoCzIPLnNwYWNlLnYxLkV2ZW50UgVldm'
    'VudBIWCgZjdXJzb3IYAiABKAlSBmN1cnNvchIcCgloZWFydGJlYXQYAyABKAhSCWhlYXJ0YmVh'
    'dA==');

@$core.Deprecated('Use createChallengeRequestDescriptor instead')
const CreateChallengeRequest$json = {
  '1': 'CreateChallengeRequest',
  '2': [
    {'1': 'purpose', '3': 1, '4': 1, '5': 9, '10': 'purpose'},
    {'1': 'root_public_key', '3': 2, '4': 1, '5': 12, '10': 'rootPublicKey'},
    {
      '1': 'device_public_key',
      '3': 3,
      '4': 1,
      '5': 12,
      '10': 'devicePublicKey'
    },
    {'1': 'grant_id', '3': 4, '4': 1, '5': 9, '10': 'grantId'},
  ],
};

/// Descriptor for `CreateChallengeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChallengeRequestDescriptor = $convert.base64Decode(
    'ChZDcmVhdGVDaGFsbGVuZ2VSZXF1ZXN0EhgKB3B1cnBvc2UYASABKAlSB3B1cnBvc2USJgoPcm'
    '9vdF9wdWJsaWNfa2V5GAIgASgMUg1yb290UHVibGljS2V5EioKEWRldmljZV9wdWJsaWNfa2V5'
    'GAMgASgMUg9kZXZpY2VQdWJsaWNLZXkSGQoIZ3JhbnRfaWQYBCABKAlSB2dyYW50SWQ=');

@$core.Deprecated('Use createChallengeResponseDescriptor instead')
const CreateChallengeResponse$json = {
  '1': 'CreateChallengeResponse',
  '2': [
    {'1': 'challenge_id', '3': 1, '4': 1, '5': 9, '10': 'challengeId'},
    {'1': 'transcript', '3': 2, '4': 1, '5': 12, '10': 'transcript'},
  ],
};

/// Descriptor for `CreateChallengeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChallengeResponseDescriptor =
    $convert.base64Decode(
        'ChdDcmVhdGVDaGFsbGVuZ2VSZXNwb25zZRIhCgxjaGFsbGVuZ2VfaWQYASABKAlSC2NoYWxsZW'
        '5nZUlkEh4KCnRyYW5zY3JpcHQYAiABKAxSCnRyYW5zY3JpcHQ=');

@$core.Deprecated('Use completeChallengeRequestDescriptor instead')
const CompleteChallengeRequest$json = {
  '1': 'CompleteChallengeRequest',
  '2': [
    {'1': 'challenge_id', '3': 1, '4': 1, '5': 9, '10': 'challengeId'},
    {'1': 'signature', '3': 2, '4': 1, '5': 12, '10': 'signature'},
  ],
};

/// Descriptor for `CompleteChallengeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeChallengeRequestDescriptor =
    $convert.base64Decode(
        'ChhDb21wbGV0ZUNoYWxsZW5nZVJlcXVlc3QSIQoMY2hhbGxlbmdlX2lkGAEgASgJUgtjaGFsbG'
        'VuZ2VJZBIcCglzaWduYXR1cmUYAiABKAxSCXNpZ25hdHVyZQ==');

@$core.Deprecated('Use completeChallengeResponseDescriptor instead')
const CompleteChallengeResponse$json = {
  '1': 'CompleteChallengeResponse',
  '2': [
    {'1': 'grant_id', '3': 1, '4': 1, '5': 9, '10': 'grantId'},
    {'1': 'principal_id', '3': 2, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'access_token', '3': 3, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `CompleteChallengeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeChallengeResponseDescriptor = $convert.base64Decode(
    'ChlDb21wbGV0ZUNoYWxsZW5nZVJlc3BvbnNlEhkKCGdyYW50X2lkGAEgASgJUgdncmFudElkEi'
    'EKDHByaW5jaXBhbF9pZBgCIAEoCVILcHJpbmNpcGFsSWQSIQoMYWNjZXNzX3Rva2VuGAMgASgJ'
    'UgthY2Nlc3NUb2tlbhIdCgpleHBpcmVzX2F0GAQgASgDUglleHBpcmVzQXQ=');

@$core.Deprecated('Use listEventsRequestDescriptor instead')
const ListEventsRequest$json = {
  '1': 'ListEventsRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after', '3': 2, '4': 1, '5': 9, '10': 'after'},
  ],
};

/// Descriptor for `ListEventsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEventsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0RXZlbnRzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSFAoFYW'
    'Z0ZXIYAiABKAlSBWFmdGVy');

@$core.Deprecated('Use listEventsResponseDescriptor instead')
const ListEventsResponse$json = {
  '1': 'ListEventsResponse',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Event',
      '10': 'events'
    },
    {'1': 'next_cursor', '3': 2, '4': 1, '5': 9, '10': 'nextCursor'},
  ],
};

/// Descriptor for `ListEventsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEventsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0RXZlbnRzUmVzcG9uc2USJwoGZXZlbnRzGAEgAygLMg8uc3BhY2UudjEuRXZlbnRSBm'
    'V2ZW50cxIfCgtuZXh0X2N1cnNvchgCIAEoCVIKbmV4dEN1cnNvcg==');

@$core.Deprecated('Use eventDescriptor instead')
const Event$json = {
  '1': 'Event',
  '2': [
    {'1': 'cursor', '3': 1, '4': 1, '5': 9, '10': 'cursor'},
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    {
      '1': 'content',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Content',
      '10': 'content'
    },
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode(
    'CgVFdmVudBIWCgZjdXJzb3IYASABKAlSBmN1cnNvchISCgR0eXBlGAIgASgJUgR0eXBlEisKB2'
    'NvbnRlbnQYAyABKAsyES5zcGFjZS52MS5Db250ZW50Ugdjb250ZW50');

@$core.Deprecated('Use getManifestRequestDescriptor instead')
const GetManifestRequest$json = {
  '1': 'GetManifestRequest',
};

/// Descriptor for `GetManifestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getManifestRequestDescriptor =
    $convert.base64Decode('ChJHZXRNYW5pZmVzdFJlcXVlc3Q=');

@$core.Deprecated('Use getManifestResponseDescriptor instead')
const GetManifestResponse$json = {
  '1': 'GetManifestResponse',
  '2': [
    {'1': 'protocol_version', '3': 1, '4': 1, '5': 9, '10': 'protocolVersion'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {
      '1': 'channels',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Channel',
      '10': 'channels'
    },
  ],
};

/// Descriptor for `GetManifestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getManifestResponseDescriptor = $convert.base64Decode(
    'ChNHZXRNYW5pZmVzdFJlc3BvbnNlEikKEHByb3RvY29sX3ZlcnNpb24YASABKAlSD3Byb3RvY2'
    '9sVmVyc2lvbhIbCglzZXJ2ZXJfaWQYAiABKAlSCHNlcnZlcklkEi0KCGNoYW5uZWxzGAMgAygL'
    'MhEuc3BhY2UudjEuQ2hhbm5lbFIIY2hhbm5lbHM=');

@$core.Deprecated('Use channelDescriptor instead')
const Channel$json = {
  '1': 'Channel',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'views',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.View',
      '10': 'views'
    },
  ],
};

/// Descriptor for `Channel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelDescriptor = $convert.base64Decode(
    'CgdDaGFubmVsEg4KAmlkGAEgASgJUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSJAoFdmlld3'
    'MYAyADKAsyDi5zcGFjZS52MS5WaWV3UgV2aWV3cw==');

@$core.Deprecated('Use viewDescriptor instead')
const View$json = {
  '1': 'View',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
  ],
};

/// Descriptor for `View`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List viewDescriptor = $convert
    .base64Decode('CgRWaWV3Eg4KAmlkGAEgASgJUgJpZBISCgR0eXBlGAIgASgJUgR0eXBl');

@$core.Deprecated('Use contentDescriptor instead')
const Content$json = {
  '1': 'Content',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'author_id', '3': 4, '4': 1, '5': 9, '10': 'authorId'},
  ],
};

/// Descriptor for `Content`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contentDescriptor = $convert.base64Decode(
    'CgdDb250ZW50Eg4KAmlkGAEgASgJUgJpZBIdCgpjaGFubmVsX2lkGAIgASgJUgljaGFubmVsSW'
    'QSEgoEdGV4dBgDIAEoCVIEdGV4dBIbCglhdXRob3JfaWQYBCABKAlSCGF1dGhvcklk');

@$core.Deprecated('Use createContentRequestDescriptor instead')
const CreateContentRequest$json = {
  '1': 'CreateContentRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `CreateContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createContentRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVDb250ZW50UmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSEg'
    'oEdGV4dBgCIAEoCVIEdGV4dBInCg9pZGVtcG90ZW5jeV9rZXkYAyABKAlSDmlkZW1wb3RlbmN5'
    'S2V5');

@$core.Deprecated('Use createContentResponseDescriptor instead')
const CreateContentResponse$json = {
  '1': 'CreateContentResponse',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Content',
      '10': 'content'
    },
  ],
};

/// Descriptor for `CreateContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createContentResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVDb250ZW50UmVzcG9uc2USKwoHY29udGVudBgBIAEoCzIRLnNwYWNlLnYxLkNvbn'
    'RlbnRSB2NvbnRlbnQ=');

@$core.Deprecated('Use listContentRequestDescriptor instead')
const ListContentRequest$json = {
  '1': 'ListContentRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after', '3': 2, '4': 1, '5': 9, '10': 'after'},
  ],
};

/// Descriptor for `ListContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listContentRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0Q29udGVudFJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbElkEhQKBW'
    'FmdGVyGAIgASgJUgVhZnRlcg==');

@$core.Deprecated('Use listContentResponseDescriptor instead')
const ListContentResponse$json = {
  '1': 'ListContentResponse',
  '2': [
    {
      '1': 'contents',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Content',
      '10': 'contents'
    },
    {'1': 'next_cursor', '3': 2, '4': 1, '5': 9, '10': 'nextCursor'},
  ],
};

/// Descriptor for `ListContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listContentResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0Q29udGVudFJlc3BvbnNlEi0KCGNvbnRlbnRzGAEgAygLMhEuc3BhY2UudjEuQ29udG'
    'VudFIIY29udGVudHMSHwoLbmV4dF9jdXJzb3IYAiABKAlSCm5leHRDdXJzb3I=');
