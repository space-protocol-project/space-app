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

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor =
    $convert.base64Decode('Cg1Mb2dvdXRSZXF1ZXN0');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor =
    $convert.base64Decode('Cg5Mb2dvdXRSZXNwb25zZQ==');

@$core.Deprecated('Use memberDescriptor instead')
const Member$json = {
  '1': 'Member',
  '2': [
    {'1': 'principal_id', '3': 1, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    {'1': 'blocked', '3': 3, '4': 1, '5': 8, '10': 'blocked'},
    {'1': 'revision', '3': 4, '4': 1, '5': 3, '10': 'revision'},
  ],
};

/// Descriptor for `Member`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberDescriptor = $convert.base64Decode(
    'CgZNZW1iZXISIQoMcHJpbmNpcGFsX2lkGAEgASgJUgtwcmluY2lwYWxJZBISCgRyb2xlGAIgAS'
    'gJUgRyb2xlEhgKB2Jsb2NrZWQYAyABKAhSB2Jsb2NrZWQSGgoIcmV2aXNpb24YBCABKANSCHJl'
    'dmlzaW9u');

@$core.Deprecated('Use listMembersRequestDescriptor instead')
const ListMembersRequest$json = {
  '1': 'ListMembersRequest',
  '2': [
    {'1': 'after', '3': 1, '4': 1, '5': 9, '10': 'after'},
  ],
};

/// Descriptor for `ListMembersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMembersRequestDescriptor = $convert
    .base64Decode('ChJMaXN0TWVtYmVyc1JlcXVlc3QSFAoFYWZ0ZXIYASABKAlSBWFmdGVy');

@$core.Deprecated('Use listMembersResponseDescriptor instead')
const ListMembersResponse$json = {
  '1': 'ListMembersResponse',
  '2': [
    {
      '1': 'members',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Member',
      '10': 'members'
    },
    {'1': 'next_cursor', '3': 2, '4': 1, '5': 9, '10': 'nextCursor'},
  ],
};

/// Descriptor for `ListMembersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMembersResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0TWVtYmVyc1Jlc3BvbnNlEioKB21lbWJlcnMYASADKAsyEC5zcGFjZS52MS5NZW1iZX'
    'JSB21lbWJlcnMSHwoLbmV4dF9jdXJzb3IYAiABKAlSCm5leHRDdXJzb3I=');

@$core.Deprecated('Use updateMemberRequestDescriptor instead')
const UpdateMemberRequest$json = {
  '1': 'UpdateMemberRequest',
  '2': [
    {'1': 'principal_id', '3': 1, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    {'1': 'blocked', '3': 3, '4': 1, '5': 8, '10': 'blocked'},
    {
      '1': 'expected_revision',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `UpdateMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMemberRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVNZW1iZXJSZXF1ZXN0EiEKDHByaW5jaXBhbF9pZBgBIAEoCVILcHJpbmNpcGFsSW'
    'QSEgoEcm9sZRgCIAEoCVIEcm9sZRIYCgdibG9ja2VkGAMgASgIUgdibG9ja2VkEisKEWV4cGVj'
    'dGVkX3JldmlzaW9uGAQgASgDUhBleHBlY3RlZFJldmlzaW9u');

@$core.Deprecated('Use updateMemberResponseDescriptor instead')
const UpdateMemberResponse$json = {
  '1': 'UpdateMemberResponse',
  '2': [
    {
      '1': 'member',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Member',
      '10': 'member'
    },
  ],
};

/// Descriptor for `UpdateMemberResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMemberResponseDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVNZW1iZXJSZXNwb25zZRIoCgZtZW1iZXIYASABKAsyEC5zcGFjZS52MS5NZW1iZX'
    'JSBm1lbWJlcg==');

@$core.Deprecated('Use inviteDescriptor instead')
const Invite$json = {
  '1': 'Invite',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'max_uses', '3': 4, '4': 1, '5': 5, '10': 'maxUses'},
    {'1': 'uses', '3': 5, '4': 1, '5': 5, '10': 'uses'},
    {'1': 'revoked', '3': 6, '4': 1, '5': 8, '10': 'revoked'},
  ],
};

/// Descriptor for `Invite`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inviteDescriptor = $convert.base64Decode(
    'CgZJbnZpdGUSDgoCaWQYASABKAlSAmlkEhIKBHJvbGUYAiABKAlSBHJvbGUSHQoKZXhwaXJlc1'
    '9hdBgDIAEoA1IJZXhwaXJlc0F0EhkKCG1heF91c2VzGAQgASgFUgdtYXhVc2VzEhIKBHVzZXMY'
    'BSABKAVSBHVzZXMSGAoHcmV2b2tlZBgGIAEoCFIHcmV2b2tlZA==');

@$core.Deprecated('Use createInviteRequestDescriptor instead')
const CreateInviteRequest$json = {
  '1': 'CreateInviteRequest',
  '2': [
    {'1': 'role', '3': 1, '4': 1, '5': 9, '10': 'role'},
    {'1': 'ttl_seconds', '3': 2, '4': 1, '5': 5, '10': 'ttlSeconds'},
    {'1': 'max_uses', '3': 3, '4': 1, '5': 5, '10': 'maxUses'},
  ],
};

/// Descriptor for `CreateInviteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createInviteRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVJbnZpdGVSZXF1ZXN0EhIKBHJvbGUYASABKAlSBHJvbGUSHwoLdHRsX3NlY29uZH'
    'MYAiABKAVSCnR0bFNlY29uZHMSGQoIbWF4X3VzZXMYAyABKAVSB21heFVzZXM=');

@$core.Deprecated('Use createInviteResponseDescriptor instead')
const CreateInviteResponse$json = {
  '1': 'CreateInviteResponse',
  '2': [
    {
      '1': 'invite',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Invite',
      '10': 'invite'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `CreateInviteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createInviteResponseDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVJbnZpdGVSZXNwb25zZRIoCgZpbnZpdGUYASABKAsyEC5zcGFjZS52MS5JbnZpdG'
    'VSBmludml0ZRIUCgV0b2tlbhgCIAEoCVIFdG9rZW4=');

@$core.Deprecated('Use listInvitesRequestDescriptor instead')
const ListInvitesRequest$json = {
  '1': 'ListInvitesRequest',
  '2': [
    {'1': 'after', '3': 1, '4': 1, '5': 9, '10': 'after'},
  ],
};

/// Descriptor for `ListInvitesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInvitesRequestDescriptor = $convert
    .base64Decode('ChJMaXN0SW52aXRlc1JlcXVlc3QSFAoFYWZ0ZXIYASABKAlSBWFmdGVy');

@$core.Deprecated('Use listInvitesResponseDescriptor instead')
const ListInvitesResponse$json = {
  '1': 'ListInvitesResponse',
  '2': [
    {
      '1': 'invites',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Invite',
      '10': 'invites'
    },
    {'1': 'next_cursor', '3': 2, '4': 1, '5': 9, '10': 'nextCursor'},
  ],
};

/// Descriptor for `ListInvitesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInvitesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0SW52aXRlc1Jlc3BvbnNlEioKB2ludml0ZXMYASADKAsyEC5zcGFjZS52MS5JbnZpdG'
    'VSB2ludml0ZXMSHwoLbmV4dF9jdXJzb3IYAiABKAlSCm5leHRDdXJzb3I=');

@$core.Deprecated('Use revokeInviteRequestDescriptor instead')
const RevokeInviteRequest$json = {
  '1': 'RevokeInviteRequest',
  '2': [
    {'1': 'invite_id', '3': 1, '4': 1, '5': 9, '10': 'inviteId'},
  ],
};

/// Descriptor for `RevokeInviteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeInviteRequestDescriptor =
    $convert.base64Decode(
        'ChNSZXZva2VJbnZpdGVSZXF1ZXN0EhsKCWludml0ZV9pZBgBIAEoCVIIaW52aXRlSWQ=');

@$core.Deprecated('Use revokeInviteResponseDescriptor instead')
const RevokeInviteResponse$json = {
  '1': 'RevokeInviteResponse',
};

/// Descriptor for `RevokeInviteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeInviteResponseDescriptor =
    $convert.base64Decode('ChRSZXZva2VJbnZpdGVSZXNwb25zZQ==');

@$core.Deprecated('Use previewInviteRequestDescriptor instead')
const PreviewInviteRequest$json = {
  '1': 'PreviewInviteRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `PreviewInviteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List previewInviteRequestDescriptor =
    $convert.base64Decode(
        'ChRQcmV2aWV3SW52aXRlUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4=');

@$core.Deprecated('Use previewInviteResponseDescriptor instead')
const PreviewInviteResponse$json = {
  '1': 'PreviewInviteResponse',
  '2': [
    {'1': 'role', '3': 1, '4': 1, '5': 9, '10': 'role'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `PreviewInviteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List previewInviteResponseDescriptor = $convert.base64Decode(
    'ChVQcmV2aWV3SW52aXRlUmVzcG9uc2USEgoEcm9sZRgBIAEoCVIEcm9sZRIbCglzZXJ2ZXJfaW'
    'QYAiABKAlSCHNlcnZlcklkEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIdCgpleHBpcmVzX2F0GAQg'
    'ASgDUglleHBpcmVzQXQ=');

@$core.Deprecated('Use acceptInviteRequestDescriptor instead')
const AcceptInviteRequest$json = {
  '1': 'AcceptInviteRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `AcceptInviteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acceptInviteRequestDescriptor =
    $convert.base64Decode(
        'ChNBY2NlcHRJbnZpdGVSZXF1ZXN0EhQKBXRva2VuGAEgASgJUgV0b2tlbg==');

@$core.Deprecated('Use acceptInviteResponseDescriptor instead')
const AcceptInviteResponse$json = {
  '1': 'AcceptInviteResponse',
  '2': [
    {
      '1': 'member',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Member',
      '10': 'member'
    },
  ],
};

/// Descriptor for `AcceptInviteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acceptInviteResponseDescriptor = $convert.base64Decode(
    'ChRBY2NlcHRJbnZpdGVSZXNwb25zZRIoCgZtZW1iZXIYASABKAsyEC5zcGFjZS52MS5NZW1iZX'
    'JSBm1lbWJlcg==');

@$core.Deprecated('Use getMembershipRequestDescriptor instead')
const GetMembershipRequest$json = {
  '1': 'GetMembershipRequest',
};

/// Descriptor for `GetMembershipRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMembershipRequestDescriptor =
    $convert.base64Decode('ChRHZXRNZW1iZXJzaGlwUmVxdWVzdA==');

@$core.Deprecated('Use getMembershipResponseDescriptor instead')
const GetMembershipResponse$json = {
  '1': 'GetMembershipResponse',
  '2': [
    {
      '1': 'member',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Member',
      '10': 'member'
    },
  ],
};

/// Descriptor for `GetMembershipResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMembershipResponseDescriptor = $convert.base64Decode(
    'ChVHZXRNZW1iZXJzaGlwUmVzcG9uc2USKAoGbWVtYmVyGAEgASgLMhAuc3BhY2UudjEuTWVtYm'
    'VyUgZtZW1iZXI=');

@$core.Deprecated('Use getSetupStatusRequestDescriptor instead')
const GetSetupStatusRequest$json = {
  '1': 'GetSetupStatusRequest',
};

/// Descriptor for `GetSetupStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSetupStatusRequestDescriptor =
    $convert.base64Decode('ChVHZXRTZXR1cFN0YXR1c1JlcXVlc3Q=');

@$core.Deprecated('Use getSetupStatusResponseDescriptor instead')
const GetSetupStatusResponse$json = {
  '1': 'GetSetupStatusResponse',
  '2': [
    {'1': 'initialized', '3': 1, '4': 1, '5': 8, '10': 'initialized'},
  ],
};

/// Descriptor for `GetSetupStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSetupStatusResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRTZXR1cFN0YXR1c1Jlc3BvbnNlEiAKC2luaXRpYWxpemVkGAEgASgIUgtpbml0aWFsaX'
        'plZA==');

@$core.Deprecated('Use claimOwnerRequestDescriptor instead')
const ClaimOwnerRequest$json = {
  '1': 'ClaimOwnerRequest',
  '2': [
    {'1': 'setup_code', '3': 1, '4': 1, '5': 9, '10': 'setupCode'},
  ],
};

/// Descriptor for `ClaimOwnerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List claimOwnerRequestDescriptor = $convert.base64Decode(
    'ChFDbGFpbU93bmVyUmVxdWVzdBIdCgpzZXR1cF9jb2RlGAEgASgJUglzZXR1cENvZGU=');

@$core.Deprecated('Use getSettingsRequestDescriptor instead')
const GetSettingsRequest$json = {
  '1': 'GetSettingsRequest',
};

/// Descriptor for `GetSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsRequestDescriptor =
    $convert.base64Decode('ChJHZXRTZXR0aW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use claimOwnerResponseDescriptor instead')
const ClaimOwnerResponse$json = {
  '1': 'ClaimOwnerResponse',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.SpaceSettings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `ClaimOwnerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List claimOwnerResponseDescriptor = $convert.base64Decode(
    'ChJDbGFpbU93bmVyUmVzcG9uc2USMwoIc2V0dGluZ3MYASABKAsyFy5zcGFjZS52MS5TcGFjZV'
    'NldHRpbmdzUghzZXR0aW5ncw==');

@$core.Deprecated('Use getSettingsResponseDescriptor instead')
const GetSettingsResponse$json = {
  '1': 'GetSettingsResponse',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.SpaceSettings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `GetSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsResponseDescriptor = $convert.base64Decode(
    'ChNHZXRTZXR0aW5nc1Jlc3BvbnNlEjMKCHNldHRpbmdzGAEgASgLMhcuc3BhY2UudjEuU3BhY2'
    'VTZXR0aW5nc1IIc2V0dGluZ3M=');

@$core.Deprecated('Use updateSettingsResponseDescriptor instead')
const UpdateSettingsResponse$json = {
  '1': 'UpdateSettingsResponse',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.SpaceSettings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `UpdateSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVTZXR0aW5nc1Jlc3BvbnNlEjMKCHNldHRpbmdzGAEgASgLMhcuc3BhY2UudjEuU3'
        'BhY2VTZXR0aW5nc1IIc2V0dGluZ3M=');

@$core.Deprecated('Use spaceSettingsDescriptor instead')
const SpaceSettings$json = {
  '1': 'SpaceSettings',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'chat_title', '3': 2, '4': 1, '5': 9, '10': 'chatTitle'},
    {'1': 'chat_enabled', '3': 3, '4': 1, '5': 8, '10': 'chatEnabled'},
    {
      '1': 'registration_policy',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'registrationPolicy'
    },
    {'1': 'revision', '3': 5, '4': 1, '5': 3, '10': 'revision'},
  ],
};

/// Descriptor for `SpaceSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spaceSettingsDescriptor = $convert.base64Decode(
    'Cg1TcGFjZVNldHRpbmdzEhQKBXRpdGxlGAEgASgJUgV0aXRsZRIdCgpjaGF0X3RpdGxlGAIgAS'
    'gJUgljaGF0VGl0bGUSIQoMY2hhdF9lbmFibGVkGAMgASgIUgtjaGF0RW5hYmxlZBIvChNyZWdp'
    'c3RyYXRpb25fcG9saWN5GAQgASgJUhJyZWdpc3RyYXRpb25Qb2xpY3kSGgoIcmV2aXNpb24YBS'
    'ABKANSCHJldmlzaW9u');

@$core.Deprecated('Use updateSettingsRequestDescriptor instead')
const UpdateSettingsRequest$json = {
  '1': 'UpdateSettingsRequest',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'chat_title', '3': 2, '4': 1, '5': 9, '10': 'chatTitle'},
    {'1': 'chat_enabled', '3': 3, '4': 1, '5': 8, '10': 'chatEnabled'},
    {
      '1': 'registration_policy',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'registrationPolicy'
    },
    {
      '1': 'expected_revision',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `UpdateSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTZXR0aW5nc1JlcXVlc3QSFAoFdGl0bGUYASABKAlSBXRpdGxlEh0KCmNoYXRfdG'
    'l0bGUYAiABKAlSCWNoYXRUaXRsZRIhCgxjaGF0X2VuYWJsZWQYAyABKAhSC2NoYXRFbmFibGVk'
    'Ei8KE3JlZ2lzdHJhdGlvbl9wb2xpY3kYBCABKAlSEnJlZ2lzdHJhdGlvblBvbGljeRIrChFleH'
    'BlY3RlZF9yZXZpc2lvbhgFIAEoA1IQZXhwZWN0ZWRSZXZpc2lvbg==');

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
    {'1': 'administrative', '3': 5, '4': 1, '5': 8, '10': 'administrative'},
  ],
};

/// Descriptor for `CreateChallengeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChallengeRequestDescriptor = $convert.base64Decode(
    'ChZDcmVhdGVDaGFsbGVuZ2VSZXF1ZXN0EhgKB3B1cnBvc2UYASABKAlSB3B1cnBvc2USJgoPcm'
    '9vdF9wdWJsaWNfa2V5GAIgASgMUg1yb290UHVibGljS2V5EioKEWRldmljZV9wdWJsaWNfa2V5'
    'GAMgASgMUg9kZXZpY2VQdWJsaWNLZXkSGQoIZ3JhbnRfaWQYBCABKAlSB2dyYW50SWQSJgoOYW'
    'RtaW5pc3RyYXRpdmUYBSABKAhSDmFkbWluaXN0cmF0aXZl');

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
    {'1': 'invitation_token', '3': 3, '4': 1, '5': 9, '10': 'invitationToken'},
  ],
};

/// Descriptor for `CompleteChallengeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeChallengeRequestDescriptor = $convert.base64Decode(
    'ChhDb21wbGV0ZUNoYWxsZW5nZVJlcXVlc3QSIQoMY2hhbGxlbmdlX2lkGAEgASgJUgtjaGFsbG'
    'VuZ2VJZBIcCglzaWduYXR1cmUYAiABKAxSCXNpZ25hdHVyZRIpChBpbnZpdGF0aW9uX3Rva2Vu'
    'GAMgASgJUg9pbnZpdGF0aW9uVG9rZW4=');

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
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `GetManifestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getManifestResponseDescriptor = $convert.base64Decode(
    'ChNHZXRNYW5pZmVzdFJlc3BvbnNlEikKEHByb3RvY29sX3ZlcnNpb24YASABKAlSD3Byb3RvY2'
    '9sVmVyc2lvbhIbCglzZXJ2ZXJfaWQYAiABKAlSCHNlcnZlcklkEi0KCGNoYW5uZWxzGAMgAygL'
    'MhEuc3BhY2UudjEuQ2hhbm5lbFIIY2hhbm5lbHMSFAoFdGl0bGUYBCABKAlSBXRpdGxl');

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
