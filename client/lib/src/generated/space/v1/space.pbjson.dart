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

@$core.Deprecated('Use listDevicesRequestDescriptor instead')
const ListDevicesRequest$json = {
  '1': 'ListDevicesRequest',
};

/// Descriptor for `ListDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDevicesRequestDescriptor =
    $convert.base64Decode('ChJMaXN0RGV2aWNlc1JlcXVlc3Q=');

@$core.Deprecated('Use revokeCurrentDeviceRequestDescriptor instead')
const RevokeCurrentDeviceRequest$json = {
  '1': 'RevokeCurrentDeviceRequest',
};

/// Descriptor for `RevokeCurrentDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeCurrentDeviceRequestDescriptor =
    $convert.base64Decode('ChpSZXZva2VDdXJyZW50RGV2aWNlUmVxdWVzdA==');

@$core.Deprecated('Use revokeCurrentDeviceResponseDescriptor instead')
const RevokeCurrentDeviceResponse$json = {
  '1': 'RevokeCurrentDeviceResponse',
};

/// Descriptor for `RevokeCurrentDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeCurrentDeviceResponseDescriptor =
    $convert.base64Decode('ChtSZXZva2VDdXJyZW50RGV2aWNlUmVzcG9uc2U=');

@$core.Deprecated('Use deviceGrantDescriptor instead')
const DeviceGrant$json = {
  '1': 'DeviceGrant',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'public_key', '3': 2, '4': 1, '5': 12, '10': 'publicKey'},
    {'1': 'scopes', '3': 3, '4': 3, '5': 9, '10': 'scopes'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'revoked', '3': 5, '4': 1, '5': 8, '10': 'revoked'},
    {'1': 'parent_grant_id', '3': 6, '4': 1, '5': 9, '10': 'parentGrantId'},
    {'1': 'recovery', '3': 7, '4': 1, '5': 8, '10': 'recovery'},
    {'1': 'auth_epoch', '3': 8, '4': 1, '5': 3, '10': 'authEpoch'},
    {'1': 'signature_kind', '3': 9, '4': 1, '5': 9, '10': 'signatureKind'},
    {
      '1': 'registration_transcript',
      '3': 10,
      '4': 1,
      '5': 12,
      '10': 'registrationTranscript'
    },
    {'1': 'signature', '3': 11, '4': 1, '5': 12, '10': 'signature'},
    {
      '1': 'parent_transcript',
      '3': 12,
      '4': 1,
      '5': 12,
      '10': 'parentTranscript'
    },
    {
      '1': 'parent_signature',
      '3': 13,
      '4': 1,
      '5': 12,
      '10': 'parentSignature'
    },
    {
      '1': 'retention_proof',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.space.v1.RetentionProof',
      '10': 'retentionProof'
    },
    {'1': 'retainable', '3': 15, '4': 1, '5': 8, '10': 'retainable'},
  ],
};

/// Descriptor for `DeviceGrant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceGrantDescriptor = $convert.base64Decode(
    'CgtEZXZpY2VHcmFudBIOCgJpZBgBIAEoCVICaWQSHQoKcHVibGljX2tleRgCIAEoDFIJcHVibG'
    'ljS2V5EhYKBnNjb3BlcxgDIAMoCVIGc2NvcGVzEh0KCmV4cGlyZXNfYXQYBCABKANSCWV4cGly'
    'ZXNBdBIYCgdyZXZva2VkGAUgASgIUgdyZXZva2VkEiYKD3BhcmVudF9ncmFudF9pZBgGIAEoCV'
    'INcGFyZW50R3JhbnRJZBIaCghyZWNvdmVyeRgHIAEoCFIIcmVjb3ZlcnkSHQoKYXV0aF9lcG9j'
    'aBgIIAEoA1IJYXV0aEVwb2NoEiUKDnNpZ25hdHVyZV9raW5kGAkgASgJUg1zaWduYXR1cmVLaW'
    '5kEjcKF3JlZ2lzdHJhdGlvbl90cmFuc2NyaXB0GAogASgMUhZyZWdpc3RyYXRpb25UcmFuc2Ny'
    'aXB0EhwKCXNpZ25hdHVyZRgLIAEoDFIJc2lnbmF0dXJlEisKEXBhcmVudF90cmFuc2NyaXB0GA'
    'wgASgMUhBwYXJlbnRUcmFuc2NyaXB0EikKEHBhcmVudF9zaWduYXR1cmUYDSABKAxSD3BhcmVu'
    'dFNpZ25hdHVyZRJBCg9yZXRlbnRpb25fcHJvb2YYDiABKAsyGC5zcGFjZS52MS5SZXRlbnRpb2'
    '5Qcm9vZlIOcmV0ZW50aW9uUHJvb2YSHgoKcmV0YWluYWJsZRgPIAEoCFIKcmV0YWluYWJsZQ==');

@$core.Deprecated('Use retentionProofDescriptor instead')
const RetentionProof$json = {
  '1': 'RetentionProof',
  '2': [
    {'1': 'grant_id', '3': 1, '4': 1, '5': 9, '10': 'grantId'},
    {'1': 'public_key', '3': 2, '4': 1, '5': 12, '10': 'publicKey'},
    {'1': 'scopes', '3': 3, '4': 3, '5': 9, '10': 'scopes'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'index', '3': 5, '4': 1, '5': 13, '10': 'index'},
    {'1': 'count', '3': 6, '4': 1, '5': 13, '10': 'count'},
    {'1': 'siblings', '3': 7, '4': 3, '5': 12, '10': 'siblings'},
  ],
};

/// Descriptor for `RetentionProof`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retentionProofDescriptor = $convert.base64Decode(
    'Cg5SZXRlbnRpb25Qcm9vZhIZCghncmFudF9pZBgBIAEoCVIHZ3JhbnRJZBIdCgpwdWJsaWNfa2'
    'V5GAIgASgMUglwdWJsaWNLZXkSFgoGc2NvcGVzGAMgAygJUgZzY29wZXMSHQoKZXhwaXJlc19h'
    'dBgEIAEoA1IJZXhwaXJlc0F0EhQKBWluZGV4GAUgASgNUgVpbmRleBIUCgVjb3VudBgGIAEoDV'
    'IFY291bnQSGgoIc2libGluZ3MYByADKAxSCHNpYmxpbmdz');

@$core.Deprecated('Use listDevicesResponseDescriptor instead')
const ListDevicesResponse$json = {
  '1': 'ListDevicesResponse',
  '2': [
    {
      '1': 'devices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.DeviceGrant',
      '10': 'devices'
    },
  ],
};

/// Descriptor for `ListDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDevicesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0RGV2aWNlc1Jlc3BvbnNlEi8KB2RldmljZXMYASADKAsyFS5zcGFjZS52MS5EZXZpY2'
    'VHcmFudFIHZGV2aWNlcw==');

@$core.Deprecated('Use pairingDescriptor instead')
const Pairing$json = {
  '1': 'Pairing',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'device_name', '3': 2, '4': 1, '5': 9, '10': 'deviceName'},
    {'1': 'public_key', '3': 3, '4': 1, '5': 12, '10': 'publicKey'},
    {'1': 'administrative', '3': 4, '4': 1, '5': 8, '10': 'administrative'},
    {'1': 'created_at', '3': 5, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'expires_at', '3': 6, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'state', '3': 7, '4': 1, '5': 9, '10': 'state'},
    {
      '1': 'proposed_root_public_key',
      '3': 8,
      '4': 1,
      '5': 12,
      '10': 'proposedRootPublicKey'
    },
  ],
};

/// Descriptor for `Pairing`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pairingDescriptor = $convert.base64Decode(
    'CgdQYWlyaW5nEg4KAmlkGAEgASgJUgJpZBIfCgtkZXZpY2VfbmFtZRgCIAEoCVIKZGV2aWNlTm'
    'FtZRIdCgpwdWJsaWNfa2V5GAMgASgMUglwdWJsaWNLZXkSJgoOYWRtaW5pc3RyYXRpdmUYBCAB'
    'KAhSDmFkbWluaXN0cmF0aXZlEh0KCmNyZWF0ZWRfYXQYBSABKANSCWNyZWF0ZWRBdBIdCgpleH'
    'BpcmVzX2F0GAYgASgDUglleHBpcmVzQXQSFAoFc3RhdGUYByABKAlSBXN0YXRlEjcKGHByb3Bv'
    'c2VkX3Jvb3RfcHVibGljX2tleRgIIAEoDFIVcHJvcG9zZWRSb290UHVibGljS2V5');

@$core.Deprecated('Use createPairingRequestDescriptor instead')
const CreatePairingRequest$json = {
  '1': 'CreatePairingRequest',
  '2': [
    {'1': 'public_key', '3': 1, '4': 1, '5': 12, '10': 'publicKey'},
    {'1': 'device_name', '3': 2, '4': 1, '5': 9, '10': 'deviceName'},
    {'1': 'administrative', '3': 3, '4': 1, '5': 8, '10': 'administrative'},
  ],
};

/// Descriptor for `CreatePairingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPairingRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVQYWlyaW5nUmVxdWVzdBIdCgpwdWJsaWNfa2V5GAEgASgMUglwdWJsaWNLZXkSHw'
    'oLZGV2aWNlX25hbWUYAiABKAlSCmRldmljZU5hbWUSJgoOYWRtaW5pc3RyYXRpdmUYAyABKAhS'
    'DmFkbWluaXN0cmF0aXZl');

@$core.Deprecated('Use createPairingResponseDescriptor instead')
const CreatePairingResponse$json = {
  '1': 'CreatePairingResponse',
  '2': [
    {
      '1': 'pairing',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Pairing',
      '10': 'pairing'
    },
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'poll_token', '3': 3, '4': 1, '5': 9, '10': 'pollToken'},
  ],
};

/// Descriptor for `CreatePairingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPairingResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVQYWlyaW5nUmVzcG9uc2USKwoHcGFpcmluZxgBIAEoCzIRLnNwYWNlLnYxLlBhaX'
    'JpbmdSB3BhaXJpbmcSEgoEY29kZRgCIAEoCVIEY29kZRIdCgpwb2xsX3Rva2VuGAMgASgJUglw'
    'b2xsVG9rZW4=');

@$core.Deprecated('Use inspectPairingRequestDescriptor instead')
const InspectPairingRequest$json = {
  '1': 'InspectPairingRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `InspectPairingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inspectPairingRequestDescriptor =
    $convert.base64Decode(
        'ChVJbnNwZWN0UGFpcmluZ1JlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZQ==');

@$core.Deprecated('Use inspectPairingResponseDescriptor instead')
const InspectPairingResponse$json = {
  '1': 'InspectPairingResponse',
  '2': [
    {
      '1': 'pairing',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Pairing',
      '10': 'pairing'
    },
  ],
};

/// Descriptor for `InspectPairingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inspectPairingResponseDescriptor =
    $convert.base64Decode(
        'ChZJbnNwZWN0UGFpcmluZ1Jlc3BvbnNlEisKB3BhaXJpbmcYASABKAsyES5zcGFjZS52MS5QYW'
        'lyaW5nUgdwYWlyaW5n');

@$core.Deprecated('Use pollPairingRequestDescriptor instead')
const PollPairingRequest$json = {
  '1': 'PollPairingRequest',
  '2': [
    {'1': 'poll_token', '3': 1, '4': 1, '5': 9, '10': 'pollToken'},
  ],
};

/// Descriptor for `PollPairingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pollPairingRequestDescriptor =
    $convert.base64Decode(
        'ChJQb2xsUGFpcmluZ1JlcXVlc3QSHQoKcG9sbF90b2tlbhgBIAEoCVIJcG9sbFRva2Vu');

@$core.Deprecated('Use pollPairingResponseDescriptor instead')
const PollPairingResponse$json = {
  '1': 'PollPairingResponse',
  '2': [
    {
      '1': 'pairing',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Pairing',
      '10': 'pairing'
    },
    {'1': 'grant_id', '3': 2, '4': 1, '5': 9, '10': 'grantId'},
    {'1': 'root_public_key', '3': 3, '4': 1, '5': 12, '10': 'rootPublicKey'},
    {'1': 'transcript', '3': 4, '4': 1, '5': 12, '10': 'transcript'},
    {'1': 'signature', '3': 5, '4': 1, '5': 12, '10': 'signature'},
    {
      '1': 'parent_transcript',
      '3': 6,
      '4': 1,
      '5': 12,
      '10': 'parentTranscript'
    },
    {'1': 'parent_signature', '3': 7, '4': 1, '5': 12, '10': 'parentSignature'},
    {'1': 'parent_grant_id', '3': 8, '4': 1, '5': 9, '10': 'parentGrantId'},
    {
      '1': 'root_history',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.space.v1.RootHistoryProof',
      '10': 'rootHistory'
    },
  ],
};

/// Descriptor for `PollPairingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pollPairingResponseDescriptor = $convert.base64Decode(
    'ChNQb2xsUGFpcmluZ1Jlc3BvbnNlEisKB3BhaXJpbmcYASABKAsyES5zcGFjZS52MS5QYWlyaW'
    '5nUgdwYWlyaW5nEhkKCGdyYW50X2lkGAIgASgJUgdncmFudElkEiYKD3Jvb3RfcHVibGljX2tl'
    'eRgDIAEoDFINcm9vdFB1YmxpY0tleRIeCgp0cmFuc2NyaXB0GAQgASgMUgp0cmFuc2NyaXB0Eh'
    'wKCXNpZ25hdHVyZRgFIAEoDFIJc2lnbmF0dXJlEisKEXBhcmVudF90cmFuc2NyaXB0GAYgASgM'
    'UhBwYXJlbnRUcmFuc2NyaXB0EikKEHBhcmVudF9zaWduYXR1cmUYByABKAxSD3BhcmVudFNpZ2'
    '5hdHVyZRImCg9wYXJlbnRfZ3JhbnRfaWQYCCABKAlSDXBhcmVudEdyYW50SWQSPQoMcm9vdF9o'
    'aXN0b3J5GAkgAygLMhouc3BhY2UudjEuUm9vdEhpc3RvcnlQcm9vZlILcm9vdEhpc3Rvcnk=');

@$core.Deprecated('Use cancelPairingRequestDescriptor instead')
const CancelPairingRequest$json = {
  '1': 'CancelPairingRequest',
  '2': [
    {'1': 'poll_token', '3': 1, '4': 1, '5': 9, '10': 'pollToken'},
  ],
};

/// Descriptor for `CancelPairingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelPairingRequestDescriptor = $convert.base64Decode(
    'ChRDYW5jZWxQYWlyaW5nUmVxdWVzdBIdCgpwb2xsX3Rva2VuGAEgASgJUglwb2xsVG9rZW4=');

@$core.Deprecated('Use cancelPairingResponseDescriptor instead')
const CancelPairingResponse$json = {
  '1': 'CancelPairingResponse',
};

/// Descriptor for `CancelPairingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelPairingResponseDescriptor =
    $convert.base64Decode('ChVDYW5jZWxQYWlyaW5nUmVzcG9uc2U=');

@$core.Deprecated('Use claimPairingRequestDescriptor instead')
const ClaimPairingRequest$json = {
  '1': 'ClaimPairingRequest',
  '2': [
    {'1': 'pairing_id', '3': 1, '4': 1, '5': 9, '10': 'pairingId'},
  ],
};

/// Descriptor for `ClaimPairingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List claimPairingRequestDescriptor = $convert.base64Decode(
    'ChNDbGFpbVBhaXJpbmdSZXF1ZXN0Eh0KCnBhaXJpbmdfaWQYASABKAlSCXBhaXJpbmdJZA==');

@$core.Deprecated('Use claimPairingResponseDescriptor instead')
const ClaimPairingResponse$json = {
  '1': 'ClaimPairingResponse',
};

/// Descriptor for `ClaimPairingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List claimPairingResponseDescriptor =
    $convert.base64Decode('ChRDbGFpbVBhaXJpbmdSZXNwb25zZQ==');

@$core.Deprecated('Use proposePairingRequestDescriptor instead')
const ProposePairingRequest$json = {
  '1': 'ProposePairingRequest',
  '2': [
    {'1': 'pairing_id', '3': 1, '4': 1, '5': 9, '10': 'pairingId'},
  ],
};

/// Descriptor for `ProposePairingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List proposePairingRequestDescriptor = $convert.base64Decode(
    'ChVQcm9wb3NlUGFpcmluZ1JlcXVlc3QSHQoKcGFpcmluZ19pZBgBIAEoCVIJcGFpcmluZ0lk');

@$core.Deprecated('Use proposePairingResponseDescriptor instead')
const ProposePairingResponse$json = {
  '1': 'ProposePairingResponse',
};

/// Descriptor for `ProposePairingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List proposePairingResponseDescriptor =
    $convert.base64Decode('ChZQcm9wb3NlUGFpcmluZ1Jlc3BvbnNl');

@$core.Deprecated('Use updateProfileRequestDescriptor instead')
const UpdateProfileRequest$json = {
  '1': 'UpdateProfileRequest',
  '2': [
    {'1': 'nickname', '3': 1, '4': 1, '5': 9, '10': 'nickname'},
  ],
};

/// Descriptor for `UpdateProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProfileRequestDescriptor =
    $convert.base64Decode(
        'ChRVcGRhdGVQcm9maWxlUmVxdWVzdBIaCghuaWNrbmFtZRgBIAEoCVIIbmlja25hbWU=');

@$core.Deprecated('Use updateProfileResponseDescriptor instead')
const UpdateProfileResponse$json = {
  '1': 'UpdateProfileResponse',
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

/// Descriptor for `UpdateProfileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProfileResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQcm9maWxlUmVzcG9uc2USKAoGbWVtYmVyGAEgASgLMhAuc3BhY2UudjEuTWVtYm'
    'VyUgZtZW1iZXI=');

@$core.Deprecated('Use memberDescriptor instead')
const Member$json = {
  '1': 'Member',
  '2': [
    {'1': 'principal_id', '3': 1, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    {'1': 'blocked', '3': 3, '4': 1, '5': 8, '10': 'blocked'},
    {'1': 'revision', '3': 4, '4': 1, '5': 3, '10': 'revision'},
    {
      '1': 'storage_limit_bytes',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'storageLimitBytes',
      '17': true
    },
    {'1': 'nickname', '3': 6, '4': 1, '5': 9, '10': 'nickname'},
  ],
  '8': [
    {'1': '_storage_limit_bytes'},
  ],
};

/// Descriptor for `Member`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberDescriptor = $convert.base64Decode(
    'CgZNZW1iZXISIQoMcHJpbmNpcGFsX2lkGAEgASgJUgtwcmluY2lwYWxJZBISCgRyb2xlGAIgAS'
    'gJUgRyb2xlEhgKB2Jsb2NrZWQYAyABKAhSB2Jsb2NrZWQSGgoIcmV2aXNpb24YBCABKANSCHJl'
    'dmlzaW9uEjMKE3N0b3JhZ2VfbGltaXRfYnl0ZXMYBSABKANIAFIRc3RvcmFnZUxpbWl0Qnl0ZX'
    'OIAQESGgoIbmlja25hbWUYBiABKAlSCG5pY2tuYW1lQhYKFF9zdG9yYWdlX2xpbWl0X2J5dGVz');

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
    {
      '1': 'storage_limit_bytes',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'storageLimitBytes',
      '17': true
    },
    {
      '1': 'reset_storage_limit',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'resetStorageLimit'
    },
  ],
  '8': [
    {'1': '_storage_limit_bytes'},
  ],
};

/// Descriptor for `UpdateMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMemberRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVNZW1iZXJSZXF1ZXN0EiEKDHByaW5jaXBhbF9pZBgBIAEoCVILcHJpbmNpcGFsSW'
    'QSEgoEcm9sZRgCIAEoCVIEcm9sZRIYCgdibG9ja2VkGAMgASgIUgdibG9ja2VkEisKEWV4cGVj'
    'dGVkX3JldmlzaW9uGAQgASgDUhBleHBlY3RlZFJldmlzaW9uEjMKE3N0b3JhZ2VfbGltaXRfYn'
    'l0ZXMYBSABKANIAFIRc3RvcmFnZUxpbWl0Qnl0ZXOIAQESLgoTcmVzZXRfc3RvcmFnZV9saW1p'
    'dBgGIAEoCFIRcmVzZXRTdG9yYWdlTGltaXRCFgoUX3N0b3JhZ2VfbGltaXRfYnl0ZXM=');

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
    {'1': 'first_login_owner', '3': 2, '4': 1, '5': 8, '10': 'firstLoginOwner'},
  ],
};

/// Descriptor for `GetSetupStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSetupStatusResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRTZXR1cFN0YXR1c1Jlc3BvbnNlEiAKC2luaXRpYWxpemVkGAEgASgIUgtpbml0aWFsaX'
        'plZBIqChFmaXJzdF9sb2dpbl9vd25lchgCIAEoCFIPZmlyc3RMb2dpbk93bmVy');

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

@$core.Deprecated('Use serverIconDescriptor instead')
const ServerIcon$json = {
  '1': 'ServerIcon',
  '2': [
    {'1': 'preset', '3': 1, '4': 1, '5': 9, '10': 'preset'},
    {'1': 'media_type', '3': 2, '4': 1, '5': 9, '10': 'mediaType'},
    {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `ServerIcon`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverIconDescriptor = $convert.base64Decode(
    'CgpTZXJ2ZXJJY29uEhYKBnByZXNldBgBIAEoCVIGcHJlc2V0Eh0KCm1lZGlhX3R5cGUYAiABKA'
    'lSCW1lZGlhVHlwZRISCgRkYXRhGAMgASgMUgRkYXRh');

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
    {
      '1': 'icon',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ServerIcon',
      '10': 'icon'
    },
    {
      '1': 'storage_limit_bytes',
      '3': 7,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'storageLimitBytes',
      '17': true
    },
    {
      '1': 'member_storage_limit_bytes',
      '3': 8,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'memberStorageLimitBytes',
      '17': true
    },
    {
      '1': 'attachments_enabled',
      '3': 9,
      '4': 1,
      '5': 8,
      '9': 2,
      '10': 'attachmentsEnabled',
      '17': true
    },
  ],
  '8': [
    {'1': '_storage_limit_bytes'},
    {'1': '_member_storage_limit_bytes'},
    {'1': '_attachments_enabled'},
  ],
};

/// Descriptor for `SpaceSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spaceSettingsDescriptor = $convert.base64Decode(
    'Cg1TcGFjZVNldHRpbmdzEhQKBXRpdGxlGAEgASgJUgV0aXRsZRIdCgpjaGF0X3RpdGxlGAIgAS'
    'gJUgljaGF0VGl0bGUSIQoMY2hhdF9lbmFibGVkGAMgASgIUgtjaGF0RW5hYmxlZBIvChNyZWdp'
    'c3RyYXRpb25fcG9saWN5GAQgASgJUhJyZWdpc3RyYXRpb25Qb2xpY3kSGgoIcmV2aXNpb24YBS'
    'ABKANSCHJldmlzaW9uEigKBGljb24YBiABKAsyFC5zcGFjZS52MS5TZXJ2ZXJJY29uUgRpY29u'
    'EjMKE3N0b3JhZ2VfbGltaXRfYnl0ZXMYByABKANIAFIRc3RvcmFnZUxpbWl0Qnl0ZXOIAQESQA'
    'oabWVtYmVyX3N0b3JhZ2VfbGltaXRfYnl0ZXMYCCABKANIAVIXbWVtYmVyU3RvcmFnZUxpbWl0'
    'Qnl0ZXOIAQESNAoTYXR0YWNobWVudHNfZW5hYmxlZBgJIAEoCEgCUhJhdHRhY2htZW50c0VuYW'
    'JsZWSIAQFCFgoUX3N0b3JhZ2VfbGltaXRfYnl0ZXNCHQobX21lbWJlcl9zdG9yYWdlX2xpbWl0'
    'X2J5dGVzQhYKFF9hdHRhY2htZW50c19lbmFibGVk');

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
    {
      '1': 'icon',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ServerIcon',
      '10': 'icon'
    },
    {
      '1': 'storage_limit_bytes',
      '3': 7,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'storageLimitBytes',
      '17': true
    },
    {
      '1': 'member_storage_limit_bytes',
      '3': 8,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'memberStorageLimitBytes',
      '17': true
    },
    {
      '1': 'attachments_enabled',
      '3': 9,
      '4': 1,
      '5': 8,
      '9': 2,
      '10': 'attachmentsEnabled',
      '17': true
    },
  ],
  '8': [
    {'1': '_storage_limit_bytes'},
    {'1': '_member_storage_limit_bytes'},
    {'1': '_attachments_enabled'},
  ],
};

/// Descriptor for `UpdateSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTZXR0aW5nc1JlcXVlc3QSFAoFdGl0bGUYASABKAlSBXRpdGxlEh0KCmNoYXRfdG'
    'l0bGUYAiABKAlSCWNoYXRUaXRsZRIhCgxjaGF0X2VuYWJsZWQYAyABKAhSC2NoYXRFbmFibGVk'
    'Ei8KE3JlZ2lzdHJhdGlvbl9wb2xpY3kYBCABKAlSEnJlZ2lzdHJhdGlvblBvbGljeRIrChFleH'
    'BlY3RlZF9yZXZpc2lvbhgFIAEoA1IQZXhwZWN0ZWRSZXZpc2lvbhIoCgRpY29uGAYgASgLMhQu'
    'c3BhY2UudjEuU2VydmVySWNvblIEaWNvbhIzChNzdG9yYWdlX2xpbWl0X2J5dGVzGAcgASgDSA'
    'BSEXN0b3JhZ2VMaW1pdEJ5dGVziAEBEkAKGm1lbWJlcl9zdG9yYWdlX2xpbWl0X2J5dGVzGAgg'
    'ASgDSAFSF21lbWJlclN0b3JhZ2VMaW1pdEJ5dGVziAEBEjQKE2F0dGFjaG1lbnRzX2VuYWJsZW'
    'QYCSABKAhIAlISYXR0YWNobWVudHNFbmFibGVkiAEBQhYKFF9zdG9yYWdlX2xpbWl0X2J5dGVz'
    'Qh0KG19tZW1iZXJfc3RvcmFnZV9saW1pdF9ieXRlc0IWChRfYXR0YWNobWVudHNfZW5hYmxlZA'
    '==');

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
    {'1': 'recovery', '3': 6, '4': 1, '5': 8, '10': 'recovery'},
    {'1': 'recovery_grant_id', '3': 7, '4': 1, '5': 9, '10': 'recoveryGrantId'},
    {'1': 'pairing_id', '3': 8, '4': 1, '5': 9, '10': 'pairingId'},
  ],
};

/// Descriptor for `CreateChallengeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChallengeRequestDescriptor = $convert.base64Decode(
    'ChZDcmVhdGVDaGFsbGVuZ2VSZXF1ZXN0EhgKB3B1cnBvc2UYASABKAlSB3B1cnBvc2USJgoPcm'
    '9vdF9wdWJsaWNfa2V5GAIgASgMUg1yb290UHVibGljS2V5EioKEWRldmljZV9wdWJsaWNfa2V5'
    'GAMgASgMUg9kZXZpY2VQdWJsaWNLZXkSGQoIZ3JhbnRfaWQYBCABKAlSB2dyYW50SWQSJgoOYW'
    'RtaW5pc3RyYXRpdmUYBSABKAhSDmFkbWluaXN0cmF0aXZlEhoKCHJlY292ZXJ5GAYgASgIUghy'
    'ZWNvdmVyeRIqChFyZWNvdmVyeV9ncmFudF9pZBgHIAEoCVIPcmVjb3ZlcnlHcmFudElkEh0KCn'
    'BhaXJpbmdfaWQYCCABKAlSCXBhaXJpbmdJZA==');

@$core.Deprecated('Use createChallengeResponseDescriptor instead')
const CreateChallengeResponse$json = {
  '1': 'CreateChallengeResponse',
  '2': [
    {'1': 'challenge_id', '3': 1, '4': 1, '5': 9, '10': 'challengeId'},
    {'1': 'transcript', '3': 2, '4': 1, '5': 12, '10': 'transcript'},
    {
      '1': 'root_history',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.RootHistoryProof',
      '10': 'rootHistory'
    },
    {
      '1': 'retention_proof',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.space.v1.RetentionProof',
      '10': 'retentionProof'
    },
  ],
};

/// Descriptor for `CreateChallengeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChallengeResponseDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVDaGFsbGVuZ2VSZXNwb25zZRIhCgxjaGFsbGVuZ2VfaWQYASABKAlSC2NoYWxsZW'
    '5nZUlkEh4KCnRyYW5zY3JpcHQYAiABKAxSCnRyYW5zY3JpcHQSPQoMcm9vdF9oaXN0b3J5GAMg'
    'AygLMhouc3BhY2UudjEuUm9vdEhpc3RvcnlQcm9vZlILcm9vdEhpc3RvcnkSQQoPcmV0ZW50aW'
    '9uX3Byb29mGAQgASgLMhguc3BhY2UudjEuUmV0ZW50aW9uUHJvb2ZSDnJldGVudGlvblByb29m');

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
    {'1': 'mls_supported', '3': 7, '4': 1, '5': 8, '10': 'mlsSupported'},
    {
      '1': 'attachments_enabled',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'attachmentsEnabled'
    },
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
    {
      '1': 'icon',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ServerIcon',
      '10': 'icon'
    },
  ],
};

/// Descriptor for `GetManifestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getManifestResponseDescriptor = $convert.base64Decode(
    'ChNHZXRNYW5pZmVzdFJlc3BvbnNlEiMKDW1sc19zdXBwb3J0ZWQYByABKAhSDG1sc1N1cHBvcn'
    'RlZBIvChNhdHRhY2htZW50c19lbmFibGVkGAYgASgIUhJhdHRhY2htZW50c0VuYWJsZWQSKQoQ'
    'cHJvdG9jb2xfdmVyc2lvbhgBIAEoCVIPcHJvdG9jb2xWZXJzaW9uEhsKCXNlcnZlcl9pZBgCIA'
    'EoCVIIc2VydmVySWQSLQoIY2hhbm5lbHMYAyADKAsyES5zcGFjZS52MS5DaGFubmVsUghjaGFu'
    'bmVscxIUCgV0aXRsZRgEIAEoCVIFdGl0bGUSKAoEaWNvbhgFIAEoCzIULnNwYWNlLnYxLlNlcn'
    'Zlckljb25SBGljb24=');

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
    {'1': 'position', '3': 4, '4': 1, '5': 5, '10': 'position'},
    {'1': 'archived', '3': 5, '4': 1, '5': 8, '10': 'archived'},
    {'1': 'revision', '3': 6, '4': 1, '5': 3, '10': 'revision'},
    {
      '1': 'permissions',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ChannelPermissions',
      '10': 'permissions'
    },
    {'1': 'public_preview', '3': 8, '4': 1, '5': 8, '10': 'publicPreview'},
    {
      '1': 'latest_message_sequence',
      '3': 9,
      '4': 1,
      '5': 3,
      '10': 'latestMessageSequence'
    },
    {'1': 'mls_group_id', '3': 10, '4': 1, '5': 12, '10': 'mlsGroupId'},
  ],
};

/// Descriptor for `Channel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelDescriptor = $convert.base64Decode(
    'CgdDaGFubmVsEg4KAmlkGAEgASgJUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSJAoFdmlld3'
    'MYAyADKAsyDi5zcGFjZS52MS5WaWV3UgV2aWV3cxIaCghwb3NpdGlvbhgEIAEoBVIIcG9zaXRp'
    'b24SGgoIYXJjaGl2ZWQYBSABKAhSCGFyY2hpdmVkEhoKCHJldmlzaW9uGAYgASgDUghyZXZpc2'
    'lvbhI+CgtwZXJtaXNzaW9ucxgHIAEoCzIcLnNwYWNlLnYxLkNoYW5uZWxQZXJtaXNzaW9uc1IL'
    'cGVybWlzc2lvbnMSJQoOcHVibGljX3ByZXZpZXcYCCABKAhSDXB1YmxpY1ByZXZpZXcSNgoXbG'
    'F0ZXN0X21lc3NhZ2Vfc2VxdWVuY2UYCSABKANSFWxhdGVzdE1lc3NhZ2VTZXF1ZW5jZRIgCgxt'
    'bHNfZ3JvdXBfaWQYCiABKAxSCm1sc0dyb3VwSWQ=');

@$core.Deprecated('Use channelPermissionsDescriptor instead')
const ChannelPermissions$json = {
  '1': 'ChannelPermissions',
  '2': [
    {'1': 'visible', '3': 1, '4': 1, '5': 8, '10': 'visible'},
    {'1': 'read', '3': 2, '4': 1, '5': 8, '10': 'read'},
    {'1': 'write', '3': 3, '4': 1, '5': 8, '10': 'write'},
    {'1': 'manage', '3': 4, '4': 1, '5': 8, '10': 'manage'},
  ],
};

/// Descriptor for `ChannelPermissions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelPermissionsDescriptor = $convert.base64Decode(
    'ChJDaGFubmVsUGVybWlzc2lvbnMSGAoHdmlzaWJsZRgBIAEoCFIHdmlzaWJsZRISCgRyZWFkGA'
    'IgASgIUgRyZWFkEhQKBXdyaXRlGAMgASgIUgV3cml0ZRIWCgZtYW5hZ2UYBCABKAhSBm1hbmFn'
    'ZQ==');

@$core.Deprecated('Use channelAccessRuleDescriptor instead')
const ChannelAccessRule$json = {
  '1': 'ChannelAccessRule',
  '2': [
    {'1': 'role', '3': 1, '4': 1, '5': 9, '10': 'role'},
    {'1': 'principal_id', '3': 2, '4': 1, '5': 9, '10': 'principalId'},
    {
      '1': 'permissions',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ChannelPermissions',
      '10': 'permissions'
    },
  ],
};

/// Descriptor for `ChannelAccessRule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelAccessRuleDescriptor = $convert.base64Decode(
    'ChFDaGFubmVsQWNjZXNzUnVsZRISCgRyb2xlGAEgASgJUgRyb2xlEiEKDHByaW5jaXBhbF9pZB'
    'gCIAEoCVILcHJpbmNpcGFsSWQSPgoLcGVybWlzc2lvbnMYAyABKAsyHC5zcGFjZS52MS5DaGFu'
    'bmVsUGVybWlzc2lvbnNSC3Blcm1pc3Npb25z');

@$core.Deprecated('Use listChannelsRequestDescriptor instead')
const ListChannelsRequest$json = {
  '1': 'ListChannelsRequest',
  '2': [
    {'1': 'include_archived', '3': 1, '4': 1, '5': 8, '10': 'includeArchived'},
  ],
};

/// Descriptor for `ListChannelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChannelsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0Q2hhbm5lbHNSZXF1ZXN0EikKEGluY2x1ZGVfYXJjaGl2ZWQYASABKAhSD2luY2x1ZG'
    'VBcmNoaXZlZA==');

@$core.Deprecated('Use listChannelsResponseDescriptor instead')
const ListChannelsResponse$json = {
  '1': 'ListChannelsResponse',
  '2': [
    {
      '1': 'channels',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Channel',
      '10': 'channels'
    },
  ],
};

/// Descriptor for `ListChannelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChannelsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0Q2hhbm5lbHNSZXNwb25zZRItCghjaGFubmVscxgBIAMoCzIRLnNwYWNlLnYxLkNoYW'
    '5uZWxSCGNoYW5uZWxz');

@$core.Deprecated('Use createChannelRequestDescriptor instead')
const CreateChannelRequest$json = {
  '1': 'CreateChannelRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'view_type', '3': 3, '4': 1, '5': 9, '10': 'viewType'},
    {'1': 'position', '3': 4, '4': 1, '5': 5, '10': 'position'},
    {'1': 'public_preview', '3': 5, '4': 1, '5': 8, '10': 'publicPreview'},
    {'1': 'mls_group_id', '3': 6, '4': 1, '5': 12, '10': 'mlsGroupId'},
  ],
};

/// Descriptor for `CreateChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChannelRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVDaGFubmVsUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSFA'
    'oFdGl0bGUYAiABKAlSBXRpdGxlEhsKCXZpZXdfdHlwZRgDIAEoCVIIdmlld1R5cGUSGgoIcG9z'
    'aXRpb24YBCABKAVSCHBvc2l0aW9uEiUKDnB1YmxpY19wcmV2aWV3GAUgASgIUg1wdWJsaWNQcm'
    'V2aWV3EiAKDG1sc19ncm91cF9pZBgGIAEoDFIKbWxzR3JvdXBJZA==');

@$core.Deprecated('Use updateChannelRequestDescriptor instead')
const UpdateChannelRequest$json = {
  '1': 'UpdateChannelRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'position', '3': 3, '4': 1, '5': 5, '10': 'position'},
    {'1': 'archived', '3': 4, '4': 1, '5': 8, '10': 'archived'},
    {'1': 'public_preview', '3': 5, '4': 1, '5': 8, '10': 'publicPreview'},
    {
      '1': 'expected_revision',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `UpdateChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateChannelRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVDaGFubmVsUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSFA'
    'oFdGl0bGUYAiABKAlSBXRpdGxlEhoKCHBvc2l0aW9uGAMgASgFUghwb3NpdGlvbhIaCghhcmNo'
    'aXZlZBgEIAEoCFIIYXJjaGl2ZWQSJQoOcHVibGljX3ByZXZpZXcYBSABKAhSDXB1YmxpY1ByZX'
    'ZpZXcSKwoRZXhwZWN0ZWRfcmV2aXNpb24YBiABKANSEGV4cGVjdGVkUmV2aXNpb24=');

@$core.Deprecated('Use deleteChannelRequestDescriptor instead')
const DeleteChannelRequest$json = {
  '1': 'DeleteChannelRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `DeleteChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteChannelRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVDaGFubmVsUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSKw'
    'oRZXhwZWN0ZWRfcmV2aXNpb24YAiABKANSEGV4cGVjdGVkUmV2aXNpb24=');

@$core.Deprecated('Use deleteChannelResponseDescriptor instead')
const DeleteChannelResponse$json = {
  '1': 'DeleteChannelResponse',
};

/// Descriptor for `DeleteChannelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteChannelResponseDescriptor =
    $convert.base64Decode('ChVEZWxldGVDaGFubmVsUmVzcG9uc2U=');

@$core.Deprecated('Use createChannelResponseDescriptor instead')
const CreateChannelResponse$json = {
  '1': 'CreateChannelResponse',
  '2': [
    {
      '1': 'channel',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Channel',
      '10': 'channel'
    },
  ],
};

/// Descriptor for `CreateChannelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChannelResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVDaGFubmVsUmVzcG9uc2USKwoHY2hhbm5lbBgBIAEoCzIRLnNwYWNlLnYxLkNoYW'
    '5uZWxSB2NoYW5uZWw=');

@$core.Deprecated('Use updateChannelResponseDescriptor instead')
const UpdateChannelResponse$json = {
  '1': 'UpdateChannelResponse',
  '2': [
    {
      '1': 'channel',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Channel',
      '10': 'channel'
    },
  ],
};

/// Descriptor for `UpdateChannelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateChannelResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVDaGFubmVsUmVzcG9uc2USKwoHY2hhbm5lbBgBIAEoCzIRLnNwYWNlLnYxLkNoYW'
    '5uZWxSB2NoYW5uZWw=');

@$core.Deprecated('Use getChannelAccessRequestDescriptor instead')
const GetChannelAccessRequest$json = {
  '1': 'GetChannelAccessRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
  ],
};

/// Descriptor for `GetChannelAccessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChannelAccessRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRDaGFubmVsQWNjZXNzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSW'
        'Q=');

@$core.Deprecated('Use updateChannelAccessRequestDescriptor instead')
const UpdateChannelAccessRequest$json = {
  '1': 'UpdateChannelAccessRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {
      '1': 'expected_revision',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
    {
      '1': 'rules',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ChannelAccessRule',
      '10': 'rules'
    },
  ],
};

/// Descriptor for `UpdateChannelAccessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateChannelAccessRequestDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVDaGFubmVsQWNjZXNzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubm'
        'VsSWQSKwoRZXhwZWN0ZWRfcmV2aXNpb24YAiABKANSEGV4cGVjdGVkUmV2aXNpb24SMQoFcnVs'
        'ZXMYAyADKAsyGy5zcGFjZS52MS5DaGFubmVsQWNjZXNzUnVsZVIFcnVsZXM=');

@$core.Deprecated('Use getChannelAccessResponseDescriptor instead')
const GetChannelAccessResponse$json = {
  '1': 'GetChannelAccessResponse',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'revision', '3': 2, '4': 1, '5': 3, '10': 'revision'},
    {
      '1': 'rules',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ChannelAccessRule',
      '10': 'rules'
    },
  ],
};

/// Descriptor for `GetChannelAccessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChannelAccessResponseDescriptor = $convert.base64Decode(
    'ChhHZXRDaGFubmVsQWNjZXNzUmVzcG9uc2USHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbE'
    'lkEhoKCHJldmlzaW9uGAIgASgDUghyZXZpc2lvbhIxCgVydWxlcxgDIAMoCzIbLnNwYWNlLnYx'
    'LkNoYW5uZWxBY2Nlc3NSdWxlUgVydWxlcw==');

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
    {'1': 'sequence', '3': 5, '4': 1, '5': 3, '10': 'sequence'},
    {
      '1': 'created_at_unix_ms',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'createdAtUnixMs'
    },
    {'1': 'revision', '3': 7, '4': 1, '5': 3, '10': 'revision'},
    {
      '1': 'updated_at_unix_ms',
      '3': 8,
      '4': 1,
      '5': 3,
      '10': 'updatedAtUnixMs'
    },
    {'1': 'deleted', '3': 9, '4': 1, '5': 8, '10': 'deleted'},
    {
      '1': 'attachments',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Asset',
      '10': 'attachments'
    },
    {
      '1': 'reactions',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Reaction',
      '10': 'reactions'
    },
  ],
};

/// Descriptor for `Content`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contentDescriptor = $convert.base64Decode(
    'CgdDb250ZW50Eg4KAmlkGAEgASgJUgJpZBIdCgpjaGFubmVsX2lkGAIgASgJUgljaGFubmVsSW'
    'QSEgoEdGV4dBgDIAEoCVIEdGV4dBIbCglhdXRob3JfaWQYBCABKAlSCGF1dGhvcklkEhoKCHNl'
    'cXVlbmNlGAUgASgDUghzZXF1ZW5jZRIrChJjcmVhdGVkX2F0X3VuaXhfbXMYBiABKANSD2NyZW'
    'F0ZWRBdFVuaXhNcxIaCghyZXZpc2lvbhgHIAEoA1IIcmV2aXNpb24SKwoSdXBkYXRlZF9hdF91'
    'bml4X21zGAggASgDUg91cGRhdGVkQXRVbml4TXMSGAoHZGVsZXRlZBgJIAEoCFIHZGVsZXRlZB'
    'IxCgthdHRhY2htZW50cxgKIAMoCzIPLnNwYWNlLnYxLkFzc2V0UgthdHRhY2htZW50cxIwCgly'
    'ZWFjdGlvbnMYCyADKAsyEi5zcGFjZS52MS5SZWFjdGlvblIJcmVhY3Rpb25z');

@$core.Deprecated('Use updateContentRequestDescriptor instead')
const UpdateContentRequest$json = {
  '1': 'UpdateContentRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {
      '1': 'expected_revision',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `UpdateContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateContentRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVDb250ZW50UmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSDg'
    'oCaWQYAiABKAlSAmlkEhIKBHRleHQYAyABKAlSBHRleHQSKwoRZXhwZWN0ZWRfcmV2aXNpb24Y'
    'BCABKANSEGV4cGVjdGVkUmV2aXNpb24=');

@$core.Deprecated('Use updateContentResponseDescriptor instead')
const UpdateContentResponse$json = {
  '1': 'UpdateContentResponse',
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

/// Descriptor for `UpdateContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateContentResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVDb250ZW50UmVzcG9uc2USKwoHY29udGVudBgBIAEoCzIRLnNwYWNlLnYxLkNvbn'
    'RlbnRSB2NvbnRlbnQ=');

@$core.Deprecated('Use deleteContentRequestDescriptor instead')
const DeleteContentRequest$json = {
  '1': 'DeleteContentRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'expected_revision',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `DeleteContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteContentRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVDb250ZW50UmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSDg'
    'oCaWQYAiABKAlSAmlkEisKEWV4cGVjdGVkX3JldmlzaW9uGAMgASgDUhBleHBlY3RlZFJldmlz'
    'aW9u');

@$core.Deprecated('Use deleteContentResponseDescriptor instead')
const DeleteContentResponse$json = {
  '1': 'DeleteContentResponse',
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

/// Descriptor for `DeleteContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteContentResponseDescriptor = $convert.base64Decode(
    'ChVEZWxldGVDb250ZW50UmVzcG9uc2USKwoHY29udGVudBgBIAEoCzIRLnNwYWNlLnYxLkNvbn'
    'RlbnRSB2NvbnRlbnQ=');

@$core.Deprecated('Use createContentRequestDescriptor instead')
const CreateContentRequest$json = {
  '1': 'CreateContentRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'attachment_ids', '3': 4, '4': 3, '5': 9, '10': 'attachmentIds'},
  ],
};

/// Descriptor for `CreateContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createContentRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVDb250ZW50UmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSEg'
    'oEdGV4dBgCIAEoCVIEdGV4dBInCg9pZGVtcG90ZW5jeV9rZXkYAyABKAlSDmlkZW1wb3RlbmN5'
    'S2V5EiUKDmF0dGFjaG1lbnRfaWRzGAQgAygJUg1hdHRhY2htZW50SWRz');

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

@$core.Deprecated('Use createRootRotationRequestDescriptor instead')
const CreateRootRotationRequest$json = {
  '1': 'CreateRootRotationRequest',
  '2': [
    {'1': 'operation_id', '3': 1, '4': 1, '5': 9, '10': 'operationId'},
    {
      '1': 'expected_auth_epoch',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'expectedAuthEpoch'
    },
    {
      '1': 'new_root_public_key',
      '3': 3,
      '4': 1,
      '5': 12,
      '10': 'newRootPublicKey'
    },
    {
      '1': 'new_device_public_key',
      '3': 4,
      '4': 1,
      '5': 12,
      '10': 'newDevicePublicKey'
    },
    {'1': 'profile', '3': 5, '4': 1, '5': 9, '10': 'profile'},
    {
      '1': 'retained_grant_ids',
      '3': 6,
      '4': 3,
      '5': 9,
      '10': 'retainedGrantIds'
    },
    {
      '1': 'retained_devices_hash',
      '3': 7,
      '4': 1,
      '5': 12,
      '10': 'retainedDevicesHash'
    },
  ],
};

/// Descriptor for `CreateRootRotationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRootRotationRequestDescriptor = $convert.base64Decode(
    'ChlDcmVhdGVSb290Um90YXRpb25SZXF1ZXN0EiEKDG9wZXJhdGlvbl9pZBgBIAEoCVILb3Blcm'
    'F0aW9uSWQSLgoTZXhwZWN0ZWRfYXV0aF9lcG9jaBgCIAEoA1IRZXhwZWN0ZWRBdXRoRXBvY2gS'
    'LQoTbmV3X3Jvb3RfcHVibGljX2tleRgDIAEoDFIQbmV3Um9vdFB1YmxpY0tleRIxChVuZXdfZG'
    'V2aWNlX3B1YmxpY19rZXkYBCABKAxSEm5ld0RldmljZVB1YmxpY0tleRIYCgdwcm9maWxlGAUg'
    'ASgJUgdwcm9maWxlEiwKEnJldGFpbmVkX2dyYW50X2lkcxgGIAMoCVIQcmV0YWluZWRHcmFudE'
    'lkcxIyChVyZXRhaW5lZF9kZXZpY2VzX2hhc2gYByABKAxSE3JldGFpbmVkRGV2aWNlc0hhc2g=');

@$core.Deprecated('Use createRootRotationResponseDescriptor instead')
const CreateRootRotationResponse$json = {
  '1': 'CreateRootRotationResponse',
  '2': [
    {'1': 'challenge_id', '3': 1, '4': 1, '5': 9, '10': 'challengeId'},
    {'1': 'transcript', '3': 2, '4': 1, '5': 12, '10': 'transcript'},
  ],
};

/// Descriptor for `CreateRootRotationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRootRotationResponseDescriptor =
    $convert.base64Decode(
        'ChpDcmVhdGVSb290Um90YXRpb25SZXNwb25zZRIhCgxjaGFsbGVuZ2VfaWQYASABKAlSC2NoYW'
        'xsZW5nZUlkEh4KCnRyYW5zY3JpcHQYAiABKAxSCnRyYW5zY3JpcHQ=');

@$core.Deprecated('Use completeRootRotationRequestDescriptor instead')
const CompleteRootRotationRequest$json = {
  '1': 'CompleteRootRotationRequest',
  '2': [
    {'1': 'challenge_id', '3': 1, '4': 1, '5': 9, '10': 'challengeId'},
    {'1': 'old_signature', '3': 2, '4': 1, '5': 12, '10': 'oldSignature'},
    {'1': 'new_signature', '3': 3, '4': 1, '5': 12, '10': 'newSignature'},
  ],
};

/// Descriptor for `CompleteRootRotationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeRootRotationRequestDescriptor =
    $convert.base64Decode(
        'ChtDb21wbGV0ZVJvb3RSb3RhdGlvblJlcXVlc3QSIQoMY2hhbGxlbmdlX2lkGAEgASgJUgtjaG'
        'FsbGVuZ2VJZBIjCg1vbGRfc2lnbmF0dXJlGAIgASgMUgxvbGRTaWduYXR1cmUSIwoNbmV3X3Np'
        'Z25hdHVyZRgDIAEoDFIMbmV3U2lnbmF0dXJl');

@$core.Deprecated('Use completeRootRotationResponseDescriptor instead')
const CompleteRootRotationResponse$json = {
  '1': 'CompleteRootRotationResponse',
  '2': [
    {'1': 'principal_id', '3': 1, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'auth_epoch', '3': 2, '4': 1, '5': 3, '10': 'authEpoch'},
    {'1': 'grant_id', '3': 3, '4': 1, '5': 9, '10': 'grantId'},
    {'1': 'transcript', '3': 4, '4': 1, '5': 12, '10': 'transcript'},
    {'1': 'old_signature', '3': 5, '4': 1, '5': 12, '10': 'oldSignature'},
    {'1': 'new_signature', '3': 6, '4': 1, '5': 12, '10': 'newSignature'},
  ],
};

/// Descriptor for `CompleteRootRotationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeRootRotationResponseDescriptor = $convert.base64Decode(
    'ChxDb21wbGV0ZVJvb3RSb3RhdGlvblJlc3BvbnNlEiEKDHByaW5jaXBhbF9pZBgBIAEoCVILcH'
    'JpbmNpcGFsSWQSHQoKYXV0aF9lcG9jaBgCIAEoA1IJYXV0aEVwb2NoEhkKCGdyYW50X2lkGAMg'
    'ASgJUgdncmFudElkEh4KCnRyYW5zY3JpcHQYBCABKAxSCnRyYW5zY3JpcHQSIwoNb2xkX3NpZ2'
    '5hdHVyZRgFIAEoDFIMb2xkU2lnbmF0dXJlEiMKDW5ld19zaWduYXR1cmUYBiABKAxSDG5ld1Np'
    'Z25hdHVyZQ==');

@$core.Deprecated('Use rootHistoryProofDescriptor instead')
const RootHistoryProof$json = {
  '1': 'RootHistoryProof',
  '2': [
    {'1': 'transcript', '3': 1, '4': 1, '5': 12, '10': 'transcript'},
    {'1': 'old_signature', '3': 2, '4': 1, '5': 12, '10': 'oldSignature'},
    {'1': 'new_signature', '3': 3, '4': 1, '5': 12, '10': 'newSignature'},
  ],
};

/// Descriptor for `RootHistoryProof`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rootHistoryProofDescriptor = $convert.base64Decode(
    'ChBSb290SGlzdG9yeVByb29mEh4KCnRyYW5zY3JpcHQYASABKAxSCnRyYW5zY3JpcHQSIwoNb2'
    'xkX3NpZ25hdHVyZRgCIAEoDFIMb2xkU2lnbmF0dXJlEiMKDW5ld19zaWduYXR1cmUYAyABKAxS'
    'DG5ld1NpZ25hdHVyZQ==');

@$core.Deprecated('Use updateChannelAccessResponseDescriptor instead')
const UpdateChannelAccessResponse$json = {
  '1': 'UpdateChannelAccessResponse',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'revision', '3': 2, '4': 1, '5': 3, '10': 'revision'},
    {
      '1': 'rules',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ChannelAccessRule',
      '10': 'rules'
    },
  ],
};

/// Descriptor for `UpdateChannelAccessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateChannelAccessResponseDescriptor =
    $convert.base64Decode(
        'ChtVcGRhdGVDaGFubmVsQWNjZXNzUmVzcG9uc2USHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm'
        '5lbElkEhoKCHJldmlzaW9uGAIgASgDUghyZXZpc2lvbhIxCgVydWxlcxgDIAMoCzIbLnNwYWNl'
        'LnYxLkNoYW5uZWxBY2Nlc3NSdWxlUgVydWxlcw==');

@$core.Deprecated('Use watchChannelsRequestDescriptor instead')
const WatchChannelsRequest$json = {
  '1': 'WatchChannelsRequest',
  '2': [
    {'1': 'include_archived', '3': 1, '4': 1, '5': 8, '10': 'includeArchived'},
  ],
};

/// Descriptor for `WatchChannelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchChannelsRequestDescriptor = $convert.base64Decode(
    'ChRXYXRjaENoYW5uZWxzUmVxdWVzdBIpChBpbmNsdWRlX2FyY2hpdmVkGAEgASgIUg9pbmNsdW'
    'RlQXJjaGl2ZWQ=');

@$core.Deprecated('Use watchChannelsResponseDescriptor instead')
const WatchChannelsResponse$json = {
  '1': 'WatchChannelsResponse',
  '2': [
    {
      '1': 'attachments_enabled',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'attachmentsEnabled'
    },
    {
      '1': 'channels',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Channel',
      '10': 'channels'
    },
    {'1': 'space_title', '3': 2, '4': 1, '5': 9, '10': 'spaceTitle'},
    {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    {'1': 'heartbeat', '3': 4, '4': 1, '5': 8, '10': 'heartbeat'},
    {'1': 'server_id', '3': 5, '4': 1, '5': 9, '10': 'serverId'},
    {
      '1': 'icon',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ServerIcon',
      '10': 'icon'
    },
  ],
};

/// Descriptor for `WatchChannelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchChannelsResponseDescriptor = $convert.base64Decode(
    'ChVXYXRjaENoYW5uZWxzUmVzcG9uc2USLwoTYXR0YWNobWVudHNfZW5hYmxlZBgHIAEoCFISYX'
    'R0YWNobWVudHNFbmFibGVkEi0KCGNoYW5uZWxzGAEgAygLMhEuc3BhY2UudjEuQ2hhbm5lbFII'
    'Y2hhbm5lbHMSHwoLc3BhY2VfdGl0bGUYAiABKAlSCnNwYWNlVGl0bGUSEgoEcm9sZRgDIAEoCV'
    'IEcm9sZRIcCgloZWFydGJlYXQYBCABKAhSCWhlYXJ0YmVhdBIbCglzZXJ2ZXJfaWQYBSABKAlS'
    'CHNlcnZlcklkEigKBGljb24YBiABKAsyFC5zcGFjZS52MS5TZXJ2ZXJJY29uUgRpY29u');

@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'channel_id', '3': 2, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'author_id', '3': 3, '4': 1, '5': 9, '10': 'authorId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'byte_size', '3': 5, '4': 1, '5': 3, '10': 'byteSize'},
    {'1': 'sha256', '3': 6, '4': 1, '5': 12, '10': 'sha256'},
    {'1': 'media_type', '3': 7, '4': 1, '5': 9, '10': 'mediaType'},
    {
      '1': 'created_at_unix_ms',
      '3': 8,
      '4': 1,
      '5': 3,
      '10': 'createdAtUnixMs'
    },
    {'1': 'storage_group', '3': 9, '4': 1, '5': 9, '10': 'storageGroup'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIOCgJpZBgBIAEoCVICaWQSHQoKY2hhbm5lbF9pZBgCIAEoCVIJY2hhbm5lbElkEh'
    'sKCWF1dGhvcl9pZBgDIAEoCVIIYXV0aG9ySWQSEgoEbmFtZRgEIAEoCVIEbmFtZRIbCglieXRl'
    'X3NpemUYBSABKANSCGJ5dGVTaXplEhYKBnNoYTI1NhgGIAEoDFIGc2hhMjU2Eh0KCm1lZGlhX3'
    'R5cGUYByABKAlSCW1lZGlhVHlwZRIrChJjcmVhdGVkX2F0X3VuaXhfbXMYCCABKANSD2NyZWF0'
    'ZWRBdFVuaXhNcxIjCg1zdG9yYWdlX2dyb3VwGAkgASgJUgxzdG9yYWdlR3JvdXA=');

@$core.Deprecated('Use beginUploadRequestDescriptor instead')
const BeginUploadRequest$json = {
  '1': 'BeginUploadRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'byte_size', '3': 3, '4': 1, '5': 3, '10': 'byteSize'},
    {'1': 'sha256', '3': 4, '4': 1, '5': 12, '10': 'sha256'},
    {'1': 'idempotency_key', '3': 5, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'encrypted', '3': 6, '4': 1, '5': 8, '10': 'encrypted'},
  ],
};

/// Descriptor for `BeginUploadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List beginUploadRequestDescriptor = $convert.base64Decode(
    'ChJCZWdpblVwbG9hZFJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbElkEhIKBG'
    '5hbWUYAiABKAlSBG5hbWUSGwoJYnl0ZV9zaXplGAMgASgDUghieXRlU2l6ZRIWCgZzaGEyNTYY'
    'BCABKAxSBnNoYTI1NhInCg9pZGVtcG90ZW5jeV9rZXkYBSABKAlSDmlkZW1wb3RlbmN5S2V5Eh'
    'wKCWVuY3J5cHRlZBgGIAEoCFIJZW5jcnlwdGVk');

@$core.Deprecated('Use beginUploadResponseDescriptor instead')
const BeginUploadResponse$json = {
  '1': 'BeginUploadResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Asset',
      '10': 'asset'
    },
    {'1': 'received_bytes', '3': 2, '4': 1, '5': 3, '10': 'receivedBytes'},
    {'1': 'chunk_size', '3': 3, '4': 1, '5': 5, '10': 'chunkSize'},
  ],
};

/// Descriptor for `BeginUploadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List beginUploadResponseDescriptor = $convert.base64Decode(
    'ChNCZWdpblVwbG9hZFJlc3BvbnNlEiUKBWFzc2V0GAEgASgLMg8uc3BhY2UudjEuQXNzZXRSBW'
    'Fzc2V0EiUKDnJlY2VpdmVkX2J5dGVzGAIgASgDUg1yZWNlaXZlZEJ5dGVzEh0KCmNodW5rX3Np'
    'emUYAyABKAVSCWNodW5rU2l6ZQ==');

@$core.Deprecated('Use uploadChunkRequestDescriptor instead')
const UploadChunkRequest$json = {
  '1': 'UploadChunkRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'offset', '3': 2, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `UploadChunkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadChunkRequestDescriptor = $convert.base64Decode(
    'ChJVcGxvYWRDaHVua1JlcXVlc3QSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQSFgoGb2Zmc2'
    'V0GAIgASgDUgZvZmZzZXQSEgoEZGF0YRgDIAEoDFIEZGF0YQ==');

@$core.Deprecated('Use uploadChunkResponseDescriptor instead')
const UploadChunkResponse$json = {
  '1': 'UploadChunkResponse',
  '2': [
    {'1': 'received_bytes', '3': 1, '4': 1, '5': 3, '10': 'receivedBytes'},
  ],
};

/// Descriptor for `UploadChunkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadChunkResponseDescriptor = $convert.base64Decode(
    'ChNVcGxvYWRDaHVua1Jlc3BvbnNlEiUKDnJlY2VpdmVkX2J5dGVzGAEgASgDUg1yZWNlaXZlZE'
    'J5dGVz');

@$core.Deprecated('Use completeUploadRequestDescriptor instead')
const CompleteUploadRequest$json = {
  '1': 'CompleteUploadRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `CompleteUploadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeUploadRequestDescriptor =
    $convert.base64Decode(
        'ChVDb21wbGV0ZVVwbG9hZFJlcXVlc3QSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQ=');

@$core.Deprecated('Use completeUploadResponseDescriptor instead')
const CompleteUploadResponse$json = {
  '1': 'CompleteUploadResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `CompleteUploadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeUploadResponseDescriptor =
    $convert.base64Decode(
        'ChZDb21wbGV0ZVVwbG9hZFJlc3BvbnNlEiUKBWFzc2V0GAEgASgLMg8uc3BhY2UudjEuQXNzZX'
        'RSBWFzc2V0');

@$core.Deprecated('Use cancelUploadRequestDescriptor instead')
const CancelUploadRequest$json = {
  '1': 'CancelUploadRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `CancelUploadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelUploadRequestDescriptor =
    $convert.base64Decode(
        'ChNDYW5jZWxVcGxvYWRSZXF1ZXN0EhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElk');

@$core.Deprecated('Use cancelUploadResponseDescriptor instead')
const CancelUploadResponse$json = {
  '1': 'CancelUploadResponse',
};

/// Descriptor for `CancelUploadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelUploadResponseDescriptor =
    $convert.base64Decode('ChRDYW5jZWxVcGxvYWRSZXNwb25zZQ==');

@$core.Deprecated('Use downloadChunkRequestDescriptor instead')
const DownloadChunkRequest$json = {
  '1': 'DownloadChunkRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'offset', '3': 2, '4': 1, '5': 3, '10': 'offset'},
  ],
};

/// Descriptor for `DownloadChunkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadChunkRequestDescriptor = $convert.base64Decode(
    'ChREb3dubG9hZENodW5rUmVxdWVzdBIZCghhc3NldF9pZBgBIAEoCVIHYXNzZXRJZBIWCgZvZm'
    'ZzZXQYAiABKANSBm9mZnNldA==');

@$core.Deprecated('Use downloadChunkResponseDescriptor instead')
const DownloadChunkResponse$json = {
  '1': 'DownloadChunkResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Asset',
      '10': 'asset'
    },
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    {'1': 'next_offset', '3': 3, '4': 1, '5': 3, '10': 'nextOffset'},
  ],
};

/// Descriptor for `DownloadChunkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadChunkResponseDescriptor = $convert.base64Decode(
    'ChVEb3dubG9hZENodW5rUmVzcG9uc2USJQoFYXNzZXQYASABKAsyDy5zcGFjZS52MS5Bc3NldF'
    'IFYXNzZXQSEgoEZGF0YRgCIAEoDFIEZGF0YRIfCgtuZXh0X29mZnNldBgDIAEoA1IKbmV4dE9m'
    'ZnNldA==');

@$core.Deprecated('Use listMyAssetsRequestDescriptor instead')
const ListMyAssetsRequest$json = {
  '1': 'ListMyAssetsRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after', '3': 2, '4': 1, '5': 9, '10': 'after'},
  ],
};

/// Descriptor for `ListMyAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMyAssetsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0TXlBc3NldHNSZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW5uZWxJZBIUCg'
    'VhZnRlchgCIAEoCVIFYWZ0ZXI=');

@$core.Deprecated('Use listMyAssetsResponseDescriptor instead')
const ListMyAssetsResponse$json = {
  '1': 'ListMyAssetsResponse',
  '2': [
    {
      '1': 'assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Asset',
      '10': 'assets'
    },
    {'1': 'next_cursor', '3': 2, '4': 1, '5': 9, '10': 'nextCursor'},
  ],
};

/// Descriptor for `ListMyAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMyAssetsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0TXlBc3NldHNSZXNwb25zZRInCgZhc3NldHMYASADKAsyDy5zcGFjZS52MS5Bc3NldF'
    'IGYXNzZXRzEh8KC25leHRfY3Vyc29yGAIgASgJUgpuZXh0Q3Vyc29y');

@$core.Deprecated('Use listChannelAssetsRequestDescriptor instead')
const ListChannelAssetsRequest$json = {
  '1': 'ListChannelAssetsRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after', '3': 2, '4': 1, '5': 9, '10': 'after'},
    {'1': 'author_id', '3': 3, '4': 1, '5': 9, '10': 'authorId'},
  ],
};

/// Descriptor for `ListChannelAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChannelAssetsRequestDescriptor =
    $convert.base64Decode(
        'ChhMaXN0Q2hhbm5lbEFzc2V0c1JlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbE'
        'lkEhQKBWFmdGVyGAIgASgJUgVhZnRlchIbCglhdXRob3JfaWQYAyABKAlSCGF1dGhvcklk');

@$core.Deprecated('Use listChannelAssetsResponseDescriptor instead')
const ListChannelAssetsResponse$json = {
  '1': 'ListChannelAssetsResponse',
  '2': [
    {
      '1': 'assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.Asset',
      '10': 'assets'
    },
    {'1': 'next_cursor', '3': 2, '4': 1, '5': 9, '10': 'nextCursor'},
    {
      '1': 'authors',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ListChannelAssetsResponse.AuthorsEntry',
      '10': 'authors'
    },
  ],
  '3': [ListChannelAssetsResponse_AuthorsEntry$json],
};

@$core.Deprecated('Use listChannelAssetsResponseDescriptor instead')
const ListChannelAssetsResponse_AuthorsEntry$json = {
  '1': 'AuthorsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ListChannelAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChannelAssetsResponseDescriptor = $convert.base64Decode(
    'ChlMaXN0Q2hhbm5lbEFzc2V0c1Jlc3BvbnNlEicKBmFzc2V0cxgBIAMoCzIPLnNwYWNlLnYxLk'
    'Fzc2V0UgZhc3NldHMSHwoLbmV4dF9jdXJzb3IYAiABKAlSCm5leHRDdXJzb3ISSgoHYXV0aG9y'
    'cxgDIAMoCzIwLnNwYWNlLnYxLkxpc3RDaGFubmVsQXNzZXRzUmVzcG9uc2UuQXV0aG9yc0VudH'
    'J5UgdhdXRob3JzGjoKDEF1dGhvcnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgC'
    'IAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use mlsDeviceDescriptor instead')
const MlsDevice$json = {
  '1': 'MlsDevice',
  '2': [
    {'1': 'grant_id', '3': 1, '4': 1, '5': 9, '10': 'grantId'},
    {'1': 'principal_id', '3': 2, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'binding', '3': 3, '4': 1, '5': 12, '10': 'binding'},
    {'1': 'key_package', '3': 4, '4': 1, '5': 12, '10': 'keyPackage'},
  ],
};

/// Descriptor for `MlsDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mlsDeviceDescriptor = $convert.base64Decode(
    'CglNbHNEZXZpY2USGQoIZ3JhbnRfaWQYASABKAlSB2dyYW50SWQSIQoMcHJpbmNpcGFsX2lkGA'
    'IgASgJUgtwcmluY2lwYWxJZBIYCgdiaW5kaW5nGAMgASgMUgdiaW5kaW5nEh8KC2tleV9wYWNr'
    'YWdlGAQgASgMUgprZXlQYWNrYWdl');

@$core.Deprecated('Use registerMlsDeviceRequestDescriptor instead')
const RegisterMlsDeviceRequest$json = {
  '1': 'RegisterMlsDeviceRequest',
  '2': [
    {'1': 'binding', '3': 1, '4': 1, '5': 12, '10': 'binding'},
    {'1': 'key_package', '3': 2, '4': 1, '5': 12, '10': 'keyPackage'},
  ],
};

/// Descriptor for `RegisterMlsDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerMlsDeviceRequestDescriptor =
    $convert.base64Decode(
        'ChhSZWdpc3Rlck1sc0RldmljZVJlcXVlc3QSGAoHYmluZGluZxgBIAEoDFIHYmluZGluZxIfCg'
        'trZXlfcGFja2FnZRgCIAEoDFIKa2V5UGFja2FnZQ==');

@$core.Deprecated('Use registerMlsDeviceResponseDescriptor instead')
const RegisterMlsDeviceResponse$json = {
  '1': 'RegisterMlsDeviceResponse',
  '2': [
    {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.MlsDevice',
      '10': 'device'
    },
  ],
};

/// Descriptor for `RegisterMlsDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerMlsDeviceResponseDescriptor =
    $convert.base64Decode(
        'ChlSZWdpc3Rlck1sc0RldmljZVJlc3BvbnNlEisKBmRldmljZRgBIAEoCzITLnNwYWNlLnYxLk'
        '1sc0RldmljZVIGZGV2aWNl');

@$core.Deprecated('Use listMlsDevicesRequestDescriptor instead')
const ListMlsDevicesRequest$json = {
  '1': 'ListMlsDevicesRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after', '3': 2, '4': 1, '5': 9, '10': 'after'},
  ],
};

/// Descriptor for `ListMlsDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMlsDevicesRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0TWxzRGV2aWNlc1JlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbElkEh'
    'QKBWFmdGVyGAIgASgJUgVhZnRlcg==');

@$core.Deprecated('Use listMlsDevicesResponseDescriptor instead')
const ListMlsDevicesResponse$json = {
  '1': 'ListMlsDevicesResponse',
  '2': [
    {
      '1': 'devices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.MlsDevice',
      '10': 'devices'
    },
    {'1': 'next_cursor', '3': 2, '4': 1, '5': 9, '10': 'nextCursor'},
  ],
};

/// Descriptor for `ListMlsDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMlsDevicesResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0TWxzRGV2aWNlc1Jlc3BvbnNlEi0KB2RldmljZXMYASADKAsyEy5zcGFjZS52MS5NbH'
        'NEZXZpY2VSB2RldmljZXMSHwoLbmV4dF9jdXJzb3IYAiABKAlSCm5leHRDdXJzb3I=');

@$core.Deprecated('Use getMlsChannelRequestDescriptor instead')
const GetMlsChannelRequest$json = {
  '1': 'GetMlsChannelRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
  ],
};

/// Descriptor for `GetMlsChannelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMlsChannelRequestDescriptor = $convert.base64Decode(
    'ChRHZXRNbHNDaGFubmVsUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQ=');

@$core.Deprecated('Use getMlsChannelResponseDescriptor instead')
const GetMlsChannelResponse$json = {
  '1': 'GetMlsChannelResponse',
  '2': [
    {'1': 'group_id', '3': 1, '4': 1, '5': 12, '10': 'groupId'},
    {'1': 'epoch', '3': 2, '4': 1, '5': 3, '10': 'epoch'},
    {
      '1': 'devices',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.MlsDevice',
      '10': 'devices'
    },
  ],
};

/// Descriptor for `GetMlsChannelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMlsChannelResponseDescriptor = $convert.base64Decode(
    'ChVHZXRNbHNDaGFubmVsUmVzcG9uc2USGQoIZ3JvdXBfaWQYASABKAxSB2dyb3VwSWQSFAoFZX'
    'BvY2gYAiABKANSBWVwb2NoEi0KB2RldmljZXMYAyADKAsyEy5zcGFjZS52MS5NbHNEZXZpY2VS'
    'B2RldmljZXM=');

@$core.Deprecated('Use publishMlsRequestDescriptor instead')
const PublishMlsRequest$json = {
  '1': 'PublishMlsRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 12, '10': 'requestId'},
    {'1': 'expected_epoch', '3': 3, '4': 1, '5': 3, '10': 'expectedEpoch'},
    {'1': 'kind', '3': 4, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'ciphertext', '3': 5, '4': 1, '5': 12, '10': 'ciphertext'},
    {'1': 'add_grant_id', '3': 6, '4': 1, '5': 9, '10': 'addGrantId'},
    {'1': 'remove_grant_id', '3': 7, '4': 1, '5': 9, '10': 'removeGrantId'},
    {'1': 'welcome', '3': 8, '4': 1, '5': 12, '10': 'welcome'},
    {'1': 'attachment_ids', '3': 9, '4': 3, '5': 9, '10': 'attachmentIds'},
    {
      '1': 'new_manager_grant_id',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'newManagerGrantId'
    },
  ],
};

/// Descriptor for `PublishMlsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishMlsRequestDescriptor = $convert.base64Decode(
    'ChFQdWJsaXNoTWxzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSHQoKcm'
    'VxdWVzdF9pZBgCIAEoDFIJcmVxdWVzdElkEiUKDmV4cGVjdGVkX2Vwb2NoGAMgASgDUg1leHBl'
    'Y3RlZEVwb2NoEhIKBGtpbmQYBCABKAlSBGtpbmQSHgoKY2lwaGVydGV4dBgFIAEoDFIKY2lwaG'
    'VydGV4dBIgCgxhZGRfZ3JhbnRfaWQYBiABKAlSCmFkZEdyYW50SWQSJgoPcmVtb3ZlX2dyYW50'
    'X2lkGAcgASgJUg1yZW1vdmVHcmFudElkEhgKB3dlbGNvbWUYCCABKAxSB3dlbGNvbWUSJQoOYX'
    'R0YWNobWVudF9pZHMYCSADKAlSDWF0dGFjaG1lbnRJZHMSLwoUbmV3X21hbmFnZXJfZ3JhbnRf'
    'aWQYCiABKAlSEW5ld01hbmFnZXJHcmFudElk');

@$core.Deprecated('Use mlsEnvelopeDescriptor instead')
const MlsEnvelope$json = {
  '1': 'MlsEnvelope',
  '2': [
    {'1': 'sequence', '3': 1, '4': 1, '5': 3, '10': 'sequence'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 12, '10': 'requestId'},
    {'1': 'epoch', '3': 3, '4': 1, '5': 3, '10': 'epoch'},
    {'1': 'kind', '3': 4, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'ciphertext', '3': 5, '4': 1, '5': 12, '10': 'ciphertext'},
    {'1': 'author_grant_id', '3': 6, '4': 1, '5': 9, '10': 'authorGrantId'},
    {'1': 'author_id', '3': 7, '4': 1, '5': 9, '10': 'authorId'},
    {
      '1': 'created_at_unix_ms',
      '3': 8,
      '4': 1,
      '5': 3,
      '10': 'createdAtUnixMs'
    },
    {'1': 'added_grant_id', '3': 9, '4': 1, '5': 9, '10': 'addedGrantId'},
    {'1': 'removed_grant_id', '3': 10, '4': 1, '5': 9, '10': 'removedGrantId'},
    {'1': 'welcome', '3': 11, '4': 1, '5': 12, '10': 'welcome'},
    {
      '1': 'roster',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.space.v1.MlsDevice',
      '10': 'roster'
    },
    {
      '1': 'new_manager_grant_id',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'newManagerGrantId'
    },
  ],
};

/// Descriptor for `MlsEnvelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mlsEnvelopeDescriptor = $convert.base64Decode(
    'CgtNbHNFbnZlbG9wZRIaCghzZXF1ZW5jZRgBIAEoA1IIc2VxdWVuY2USHQoKcmVxdWVzdF9pZB'
    'gCIAEoDFIJcmVxdWVzdElkEhQKBWVwb2NoGAMgASgDUgVlcG9jaBISCgRraW5kGAQgASgJUgRr'
    'aW5kEh4KCmNpcGhlcnRleHQYBSABKAxSCmNpcGhlcnRleHQSJgoPYXV0aG9yX2dyYW50X2lkGA'
    'YgASgJUg1hdXRob3JHcmFudElkEhsKCWF1dGhvcl9pZBgHIAEoCVIIYXV0aG9ySWQSKwoSY3Jl'
    'YXRlZF9hdF91bml4X21zGAggASgDUg9jcmVhdGVkQXRVbml4TXMSJAoOYWRkZWRfZ3JhbnRfaW'
    'QYCSABKAlSDGFkZGVkR3JhbnRJZBIoChByZW1vdmVkX2dyYW50X2lkGAogASgJUg5yZW1vdmVk'
    'R3JhbnRJZBIYCgd3ZWxjb21lGAsgASgMUgd3ZWxjb21lEisKBnJvc3RlchgMIAMoCzITLnNwYW'
    'NlLnYxLk1sc0RldmljZVIGcm9zdGVyEi8KFG5ld19tYW5hZ2VyX2dyYW50X2lkGA0gASgJUhFu'
    'ZXdNYW5hZ2VyR3JhbnRJZA==');

@$core.Deprecated('Use publishMlsResponseDescriptor instead')
const PublishMlsResponse$json = {
  '1': 'PublishMlsResponse',
  '2': [
    {
      '1': 'envelope',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.MlsEnvelope',
      '10': 'envelope'
    },
  ],
};

/// Descriptor for `PublishMlsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishMlsResponseDescriptor = $convert.base64Decode(
    'ChJQdWJsaXNoTWxzUmVzcG9uc2USMQoIZW52ZWxvcGUYASABKAsyFS5zcGFjZS52MS5NbHNFbn'
    'ZlbG9wZVIIZW52ZWxvcGU=');

@$core.Deprecated('Use listMlsEnvelopesRequestDescriptor instead')
const ListMlsEnvelopesRequest$json = {
  '1': 'ListMlsEnvelopesRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after_sequence', '3': 2, '4': 1, '5': 3, '10': 'afterSequence'},
  ],
};

/// Descriptor for `ListMlsEnvelopesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMlsEnvelopesRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0TWxzRW52ZWxvcGVzUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSW'
        'QSJQoOYWZ0ZXJfc2VxdWVuY2UYAiABKANSDWFmdGVyU2VxdWVuY2U=');

@$core.Deprecated('Use listMlsEnvelopesResponseDescriptor instead')
const ListMlsEnvelopesResponse$json = {
  '1': 'ListMlsEnvelopesResponse',
  '2': [
    {
      '1': 'envelopes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.MlsEnvelope',
      '10': 'envelopes'
    },
    {'1': 'next_sequence', '3': 2, '4': 1, '5': 3, '10': 'nextSequence'},
  ],
};

/// Descriptor for `ListMlsEnvelopesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMlsEnvelopesResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0TWxzRW52ZWxvcGVzUmVzcG9uc2USMwoJZW52ZWxvcGVzGAEgAygLMhUuc3BhY2Uudj'
    'EuTWxzRW52ZWxvcGVSCWVudmVsb3BlcxIjCg1uZXh0X3NlcXVlbmNlGAIgASgDUgxuZXh0U2Vx'
    'dWVuY2U=');

@$core.Deprecated('Use reactionDescriptor instead')
const Reaction$json = {
  '1': 'Reaction',
  '2': [
    {'1': 'emoji', '3': 1, '4': 1, '5': 9, '10': 'emoji'},
    {'1': 'principal_ids', '3': 2, '4': 3, '5': 9, '10': 'principalIds'},
  ],
};

/// Descriptor for `Reaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reactionDescriptor = $convert.base64Decode(
    'CghSZWFjdGlvbhIUCgVlbW9qaRgBIAEoCVIFZW1vamkSIwoNcHJpbmNpcGFsX2lkcxgCIAMoCV'
    'IMcHJpbmNpcGFsSWRz');

@$core.Deprecated('Use setReactionRequestDescriptor instead')
const SetReactionRequest$json = {
  '1': 'SetReactionRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {'1': 'emoji', '3': 3, '4': 1, '5': 9, '10': 'emoji'},
    {'1': 'active', '3': 4, '4': 1, '5': 8, '10': 'active'},
    {
      '1': 'expected_revision',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
  ],
};

/// Descriptor for `SetReactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setReactionRequestDescriptor = $convert.base64Decode(
    'ChJTZXRSZWFjdGlvblJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbElkEg4KAm'
    'lkGAIgASgJUgJpZBIUCgVlbW9qaRgDIAEoCVIFZW1vamkSFgoGYWN0aXZlGAQgASgIUgZhY3Rp'
    'dmUSKwoRZXhwZWN0ZWRfcmV2aXNpb24YBSABKANSEGV4cGVjdGVkUmV2aXNpb24=');

@$core.Deprecated('Use setReactionResponseDescriptor instead')
const SetReactionResponse$json = {
  '1': 'SetReactionResponse',
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

/// Descriptor for `SetReactionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setReactionResponseDescriptor = $convert.base64Decode(
    'ChNTZXRSZWFjdGlvblJlc3BvbnNlEisKB2NvbnRlbnQYASABKAsyES5zcGFjZS52MS5Db250ZW'
    '50Ugdjb250ZW50');

const $core.Map<$core.String, $core.dynamic> ChannelServiceBase$json = {
  '1': 'ChannelService',
  '2': [
    {
      '1': 'WatchChannels',
      '2': '.space.v1.WatchChannelsRequest',
      '3': '.space.v1.WatchChannelsResponse',
      '4': {},
      '6': true
    },
    {
      '1': 'ListChannels',
      '2': '.space.v1.ListChannelsRequest',
      '3': '.space.v1.ListChannelsResponse',
      '4': {}
    },
    {
      '1': 'CreateChannel',
      '2': '.space.v1.CreateChannelRequest',
      '3': '.space.v1.CreateChannelResponse',
      '4': {}
    },
    {
      '1': 'UpdateChannel',
      '2': '.space.v1.UpdateChannelRequest',
      '3': '.space.v1.UpdateChannelResponse',
      '4': {}
    },
    {
      '1': 'DeleteChannel',
      '2': '.space.v1.DeleteChannelRequest',
      '3': '.space.v1.DeleteChannelResponse',
      '4': {}
    },
    {
      '1': 'GetChannelAccess',
      '2': '.space.v1.GetChannelAccessRequest',
      '3': '.space.v1.GetChannelAccessResponse',
      '4': {}
    },
    {
      '1': 'UpdateChannelAccess',
      '2': '.space.v1.UpdateChannelAccessRequest',
      '3': '.space.v1.UpdateChannelAccessResponse',
      '4': {}
    },
    {
      '1': 'GetManifest',
      '2': '.space.v1.GetManifestRequest',
      '3': '.space.v1.GetManifestResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use channelServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ChannelServiceBase$messageJson = {
  '.space.v1.WatchChannelsRequest': WatchChannelsRequest$json,
  '.space.v1.WatchChannelsResponse': WatchChannelsResponse$json,
  '.space.v1.Channel': Channel$json,
  '.space.v1.View': View$json,
  '.space.v1.ChannelPermissions': ChannelPermissions$json,
  '.space.v1.ServerIcon': ServerIcon$json,
  '.space.v1.ListChannelsRequest': ListChannelsRequest$json,
  '.space.v1.ListChannelsResponse': ListChannelsResponse$json,
  '.space.v1.CreateChannelRequest': CreateChannelRequest$json,
  '.space.v1.CreateChannelResponse': CreateChannelResponse$json,
  '.space.v1.UpdateChannelRequest': UpdateChannelRequest$json,
  '.space.v1.UpdateChannelResponse': UpdateChannelResponse$json,
  '.space.v1.DeleteChannelRequest': DeleteChannelRequest$json,
  '.space.v1.DeleteChannelResponse': DeleteChannelResponse$json,
  '.space.v1.GetChannelAccessRequest': GetChannelAccessRequest$json,
  '.space.v1.GetChannelAccessResponse': GetChannelAccessResponse$json,
  '.space.v1.ChannelAccessRule': ChannelAccessRule$json,
  '.space.v1.UpdateChannelAccessRequest': UpdateChannelAccessRequest$json,
  '.space.v1.UpdateChannelAccessResponse': UpdateChannelAccessResponse$json,
  '.space.v1.GetManifestRequest': GetManifestRequest$json,
  '.space.v1.GetManifestResponse': GetManifestResponse$json,
};

/// Descriptor for `ChannelService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List channelServiceDescriptor = $convert.base64Decode(
    'Cg5DaGFubmVsU2VydmljZRJyCg1XYXRjaENoYW5uZWxzEh4uc3BhY2UudjEuV2F0Y2hDaGFubm'
    'Vsc1JlcXVlc3QaHy5zcGFjZS52MS5XYXRjaENoYW5uZWxzUmVzcG9uc2UiHoLT5JMCGBIWL2Fw'
    'aS92MS9jaGFubmVscy93YXRjaDABEmcKDExpc3RDaGFubmVscxIdLnNwYWNlLnYxLkxpc3RDaG'
    'FubmVsc1JlcXVlc3QaHi5zcGFjZS52MS5MaXN0Q2hhbm5lbHNSZXNwb25zZSIYgtPkkwISEhAv'
    'YXBpL3YxL2NoYW5uZWxzEm0KDUNyZWF0ZUNoYW5uZWwSHi5zcGFjZS52MS5DcmVhdGVDaGFubm'
    'VsUmVxdWVzdBofLnNwYWNlLnYxLkNyZWF0ZUNoYW5uZWxSZXNwb25zZSIbgtPkkwIVOgEqIhAv'
    'YXBpL3YxL2NoYW5uZWxzEnoKDVVwZGF0ZUNoYW5uZWwSHi5zcGFjZS52MS5VcGRhdGVDaGFubm'
    'VsUmVxdWVzdBofLnNwYWNlLnYxLlVwZGF0ZUNoYW5uZWxSZXNwb25zZSIogtPkkwIiOgEqMh0v'
    'YXBpL3YxL2NoYW5uZWxzL3tjaGFubmVsX2lkfRJ3Cg1EZWxldGVDaGFubmVsEh4uc3BhY2Uudj'
    'EuRGVsZXRlQ2hhbm5lbFJlcXVlc3QaHy5zcGFjZS52MS5EZWxldGVDaGFubmVsUmVzcG9uc2Ui'
    'JYLT5JMCHyodL2FwaS92MS9jaGFubmVscy97Y2hhbm5lbF9pZH0ShwEKEEdldENoYW5uZWxBY2'
    'Nlc3MSIS5zcGFjZS52MS5HZXRDaGFubmVsQWNjZXNzUmVxdWVzdBoiLnNwYWNlLnYxLkdldENo'
    'YW5uZWxBY2Nlc3NSZXNwb25zZSIsgtPkkwImEiQvYXBpL3YxL2NoYW5uZWxzL3tjaGFubmVsX2'
    'lkfS9hY2Nlc3MSkwEKE1VwZGF0ZUNoYW5uZWxBY2Nlc3MSJC5zcGFjZS52MS5VcGRhdGVDaGFu'
    'bmVsQWNjZXNzUmVxdWVzdBolLnNwYWNlLnYxLlVwZGF0ZUNoYW5uZWxBY2Nlc3NSZXNwb25zZS'
    'IvgtPkkwIpOgEqGiQvYXBpL3YxL2NoYW5uZWxzL3tjaGFubmVsX2lkfS9hY2Nlc3MSZAoLR2V0'
    'TWFuaWZlc3QSHC5zcGFjZS52MS5HZXRNYW5pZmVzdFJlcXVlc3QaHS5zcGFjZS52MS5HZXRNYW'
    '5pZmVzdFJlc3BvbnNlIhiC0+STAhISEC9hcGkvdjEvbWFuaWZlc3Q=');

const $core.Map<$core.String, $core.dynamic> ContentServiceBase$json = {
  '1': 'ContentService',
  '2': [
    {
      '1': 'SetReaction',
      '2': '.space.v1.SetReactionRequest',
      '3': '.space.v1.SetReactionResponse'
    },
    {
      '1': 'UpdateContent',
      '2': '.space.v1.UpdateContentRequest',
      '3': '.space.v1.UpdateContentResponse',
      '4': {}
    },
    {
      '1': 'DeleteContent',
      '2': '.space.v1.DeleteContentRequest',
      '3': '.space.v1.DeleteContentResponse',
      '4': {}
    },
    {
      '1': 'CreateContent',
      '2': '.space.v1.CreateContentRequest',
      '3': '.space.v1.CreateContentResponse',
      '4': {}
    },
    {
      '1': 'ListContent',
      '2': '.space.v1.ListContentRequest',
      '3': '.space.v1.ListContentResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use contentServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ContentServiceBase$messageJson = {
  '.space.v1.SetReactionRequest': SetReactionRequest$json,
  '.space.v1.SetReactionResponse': SetReactionResponse$json,
  '.space.v1.Content': Content$json,
  '.space.v1.Asset': Asset$json,
  '.space.v1.Reaction': Reaction$json,
  '.space.v1.UpdateContentRequest': UpdateContentRequest$json,
  '.space.v1.UpdateContentResponse': UpdateContentResponse$json,
  '.space.v1.DeleteContentRequest': DeleteContentRequest$json,
  '.space.v1.DeleteContentResponse': DeleteContentResponse$json,
  '.space.v1.CreateContentRequest': CreateContentRequest$json,
  '.space.v1.CreateContentResponse': CreateContentResponse$json,
  '.space.v1.ListContentRequest': ListContentRequest$json,
  '.space.v1.ListContentResponse': ListContentResponse$json,
};

/// Descriptor for `ContentService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List contentServiceDescriptor = $convert.base64Decode(
    'Cg5Db250ZW50U2VydmljZRJKCgtTZXRSZWFjdGlvbhIcLnNwYWNlLnYxLlNldFJlYWN0aW9uUm'
    'VxdWVzdBodLnNwYWNlLnYxLlNldFJlYWN0aW9uUmVzcG9uc2UShAEKDVVwZGF0ZUNvbnRlbnQS'
    'Hi5zcGFjZS52MS5VcGRhdGVDb250ZW50UmVxdWVzdBofLnNwYWNlLnYxLlVwZGF0ZUNvbnRlbn'
    'RSZXNwb25zZSIygtPkkwIsOgEqMicvdjEvY2hhbm5lbHMve2NoYW5uZWxfaWR9L2NvbnRlbnRz'
    'L3tpZH0SgQEKDURlbGV0ZUNvbnRlbnQSHi5zcGFjZS52MS5EZWxldGVDb250ZW50UmVxdWVzdB'
    'ofLnNwYWNlLnYxLkRlbGV0ZUNvbnRlbnRSZXNwb25zZSIvgtPkkwIpKicvdjEvY2hhbm5lbHMv'
    'e2NoYW5uZWxfaWR9L2NvbnRlbnRzL3tpZH0SggEKDUNyZWF0ZUNvbnRlbnQSHi5zcGFjZS52MS'
    '5DcmVhdGVDb250ZW50UmVxdWVzdBofLnNwYWNlLnYxLkNyZWF0ZUNvbnRlbnRSZXNwb25zZSIw'
    'gtPkkwIqOgEqIiUvYXBpL3YxL2NoYW5uZWxzL3tjaGFubmVsX2lkfS9jb250ZW50EnkKC0xpc3'
    'RDb250ZW50Ehwuc3BhY2UudjEuTGlzdENvbnRlbnRSZXF1ZXN0Gh0uc3BhY2UudjEuTGlzdENv'
    'bnRlbnRSZXNwb25zZSItgtPkkwInEiUvYXBpL3YxL2NoYW5uZWxzL3tjaGFubmVsX2lkfS9jb2'
    '50ZW50');

const $core.Map<$core.String, $core.dynamic> AssetServiceBase$json = {
  '1': 'AssetService',
  '2': [
    {
      '1': 'BeginUpload',
      '2': '.space.v1.BeginUploadRequest',
      '3': '.space.v1.BeginUploadResponse'
    },
    {
      '1': 'UploadChunk',
      '2': '.space.v1.UploadChunkRequest',
      '3': '.space.v1.UploadChunkResponse'
    },
    {
      '1': 'CompleteUpload',
      '2': '.space.v1.CompleteUploadRequest',
      '3': '.space.v1.CompleteUploadResponse'
    },
    {
      '1': 'CancelUpload',
      '2': '.space.v1.CancelUploadRequest',
      '3': '.space.v1.CancelUploadResponse'
    },
    {
      '1': 'DownloadChunk',
      '2': '.space.v1.DownloadChunkRequest',
      '3': '.space.v1.DownloadChunkResponse'
    },
    {
      '1': 'ListMyAssets',
      '2': '.space.v1.ListMyAssetsRequest',
      '3': '.space.v1.ListMyAssetsResponse'
    },
    {
      '1': 'ListChannelAssets',
      '2': '.space.v1.ListChannelAssetsRequest',
      '3': '.space.v1.ListChannelAssetsResponse'
    },
  ],
};

@$core.Deprecated('Use assetServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AssetServiceBase$messageJson = {
  '.space.v1.BeginUploadRequest': BeginUploadRequest$json,
  '.space.v1.BeginUploadResponse': BeginUploadResponse$json,
  '.space.v1.Asset': Asset$json,
  '.space.v1.UploadChunkRequest': UploadChunkRequest$json,
  '.space.v1.UploadChunkResponse': UploadChunkResponse$json,
  '.space.v1.CompleteUploadRequest': CompleteUploadRequest$json,
  '.space.v1.CompleteUploadResponse': CompleteUploadResponse$json,
  '.space.v1.CancelUploadRequest': CancelUploadRequest$json,
  '.space.v1.CancelUploadResponse': CancelUploadResponse$json,
  '.space.v1.DownloadChunkRequest': DownloadChunkRequest$json,
  '.space.v1.DownloadChunkResponse': DownloadChunkResponse$json,
  '.space.v1.ListMyAssetsRequest': ListMyAssetsRequest$json,
  '.space.v1.ListMyAssetsResponse': ListMyAssetsResponse$json,
  '.space.v1.ListChannelAssetsRequest': ListChannelAssetsRequest$json,
  '.space.v1.ListChannelAssetsResponse': ListChannelAssetsResponse$json,
  '.space.v1.ListChannelAssetsResponse.AuthorsEntry':
      ListChannelAssetsResponse_AuthorsEntry$json,
};

/// Descriptor for `AssetService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List assetServiceDescriptor = $convert.base64Decode(
    'CgxBc3NldFNlcnZpY2USSgoLQmVnaW5VcGxvYWQSHC5zcGFjZS52MS5CZWdpblVwbG9hZFJlcX'
    'Vlc3QaHS5zcGFjZS52MS5CZWdpblVwbG9hZFJlc3BvbnNlEkoKC1VwbG9hZENodW5rEhwuc3Bh'
    'Y2UudjEuVXBsb2FkQ2h1bmtSZXF1ZXN0Gh0uc3BhY2UudjEuVXBsb2FkQ2h1bmtSZXNwb25zZR'
    'JTCg5Db21wbGV0ZVVwbG9hZBIfLnNwYWNlLnYxLkNvbXBsZXRlVXBsb2FkUmVxdWVzdBogLnNw'
    'YWNlLnYxLkNvbXBsZXRlVXBsb2FkUmVzcG9uc2USTQoMQ2FuY2VsVXBsb2FkEh0uc3BhY2Uudj'
    'EuQ2FuY2VsVXBsb2FkUmVxdWVzdBoeLnNwYWNlLnYxLkNhbmNlbFVwbG9hZFJlc3BvbnNlElAK'
    'DURvd25sb2FkQ2h1bmsSHi5zcGFjZS52MS5Eb3dubG9hZENodW5rUmVxdWVzdBofLnNwYWNlLn'
    'YxLkRvd25sb2FkQ2h1bmtSZXNwb25zZRJNCgxMaXN0TXlBc3NldHMSHS5zcGFjZS52MS5MaXN0'
    'TXlBc3NldHNSZXF1ZXN0Gh4uc3BhY2UudjEuTGlzdE15QXNzZXRzUmVzcG9uc2USXAoRTGlzdE'
    'NoYW5uZWxBc3NldHMSIi5zcGFjZS52MS5MaXN0Q2hhbm5lbEFzc2V0c1JlcXVlc3QaIy5zcGFj'
    'ZS52MS5MaXN0Q2hhbm5lbEFzc2V0c1Jlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> AuthServiceBase$json = {
  '1': 'AuthService',
  '2': [
    {
      '1': 'CreateRootRotation',
      '2': '.space.v1.CreateRootRotationRequest',
      '3': '.space.v1.CreateRootRotationResponse',
      '4': {}
    },
    {
      '1': 'CompleteRootRotation',
      '2': '.space.v1.CompleteRootRotationRequest',
      '3': '.space.v1.CompleteRootRotationResponse',
      '4': {}
    },
    {
      '1': 'ProposePairing',
      '2': '.space.v1.ProposePairingRequest',
      '3': '.space.v1.ProposePairingResponse',
      '4': {}
    },
    {
      '1': 'CreatePairing',
      '2': '.space.v1.CreatePairingRequest',
      '3': '.space.v1.CreatePairingResponse',
      '4': {}
    },
    {
      '1': 'InspectPairing',
      '2': '.space.v1.InspectPairingRequest',
      '3': '.space.v1.InspectPairingResponse',
      '4': {}
    },
    {
      '1': 'PollPairing',
      '2': '.space.v1.PollPairingRequest',
      '3': '.space.v1.PollPairingResponse',
      '4': {}
    },
    {
      '1': 'CancelPairing',
      '2': '.space.v1.CancelPairingRequest',
      '3': '.space.v1.CancelPairingResponse',
      '4': {}
    },
    {
      '1': 'ClaimPairing',
      '2': '.space.v1.ClaimPairingRequest',
      '3': '.space.v1.ClaimPairingResponse',
      '4': {}
    },
    {
      '1': 'RevokeCurrentDevice',
      '2': '.space.v1.RevokeCurrentDeviceRequest',
      '3': '.space.v1.RevokeCurrentDeviceResponse',
      '4': {}
    },
    {
      '1': 'ListDevices',
      '2': '.space.v1.ListDevicesRequest',
      '3': '.space.v1.ListDevicesResponse',
      '4': {}
    },
    {
      '1': 'Logout',
      '2': '.space.v1.LogoutRequest',
      '3': '.space.v1.LogoutResponse',
      '4': {}
    },
    {
      '1': 'CreateChallenge',
      '2': '.space.v1.CreateChallengeRequest',
      '3': '.space.v1.CreateChallengeResponse',
      '4': {}
    },
    {
      '1': 'CompleteChallenge',
      '2': '.space.v1.CompleteChallengeRequest',
      '3': '.space.v1.CompleteChallengeResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use authServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AuthServiceBase$messageJson = {
  '.space.v1.CreateRootRotationRequest': CreateRootRotationRequest$json,
  '.space.v1.CreateRootRotationResponse': CreateRootRotationResponse$json,
  '.space.v1.CompleteRootRotationRequest': CompleteRootRotationRequest$json,
  '.space.v1.CompleteRootRotationResponse': CompleteRootRotationResponse$json,
  '.space.v1.ProposePairingRequest': ProposePairingRequest$json,
  '.space.v1.ProposePairingResponse': ProposePairingResponse$json,
  '.space.v1.CreatePairingRequest': CreatePairingRequest$json,
  '.space.v1.CreatePairingResponse': CreatePairingResponse$json,
  '.space.v1.Pairing': Pairing$json,
  '.space.v1.InspectPairingRequest': InspectPairingRequest$json,
  '.space.v1.InspectPairingResponse': InspectPairingResponse$json,
  '.space.v1.PollPairingRequest': PollPairingRequest$json,
  '.space.v1.PollPairingResponse': PollPairingResponse$json,
  '.space.v1.RootHistoryProof': RootHistoryProof$json,
  '.space.v1.CancelPairingRequest': CancelPairingRequest$json,
  '.space.v1.CancelPairingResponse': CancelPairingResponse$json,
  '.space.v1.ClaimPairingRequest': ClaimPairingRequest$json,
  '.space.v1.ClaimPairingResponse': ClaimPairingResponse$json,
  '.space.v1.RevokeCurrentDeviceRequest': RevokeCurrentDeviceRequest$json,
  '.space.v1.RevokeCurrentDeviceResponse': RevokeCurrentDeviceResponse$json,
  '.space.v1.ListDevicesRequest': ListDevicesRequest$json,
  '.space.v1.ListDevicesResponse': ListDevicesResponse$json,
  '.space.v1.DeviceGrant': DeviceGrant$json,
  '.space.v1.RetentionProof': RetentionProof$json,
  '.space.v1.LogoutRequest': LogoutRequest$json,
  '.space.v1.LogoutResponse': LogoutResponse$json,
  '.space.v1.CreateChallengeRequest': CreateChallengeRequest$json,
  '.space.v1.CreateChallengeResponse': CreateChallengeResponse$json,
  '.space.v1.CompleteChallengeRequest': CompleteChallengeRequest$json,
  '.space.v1.CompleteChallengeResponse': CompleteChallengeResponse$json,
};

/// Descriptor for `AuthService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List authServiceDescriptor = $convert.base64Decode(
    'CgtBdXRoU2VydmljZRKHAQoSQ3JlYXRlUm9vdFJvdGF0aW9uEiMuc3BhY2UudjEuQ3JlYXRlUm'
    '9vdFJvdGF0aW9uUmVxdWVzdBokLnNwYWNlLnYxLkNyZWF0ZVJvb3RSb3RhdGlvblJlc3BvbnNl'
    'IiaC0+STAiA6ASoiGy9hcGkvdjEvYXV0aC9yb290LXJvdGF0aW9ucxKWAQoUQ29tcGxldGVSb2'
    '90Um90YXRpb24SJS5zcGFjZS52MS5Db21wbGV0ZVJvb3RSb3RhdGlvblJlcXVlc3QaJi5zcGFj'
    'ZS52MS5Db21wbGV0ZVJvb3RSb3RhdGlvblJlc3BvbnNlIi+C0+STAik6ASoiJC9hcGkvdjEvYX'
    'V0aC9yb290LXJvdGF0aW9ucy9jb21wbGV0ZRJ9Cg5Qcm9wb3NlUGFpcmluZxIfLnNwYWNlLnYx'
    'LlByb3Bvc2VQYWlyaW5nUmVxdWVzdBogLnNwYWNlLnYxLlByb3Bvc2VQYWlyaW5nUmVzcG9uc2'
    'UiKILT5JMCIjoBKiIdL2FwaS92MS9hdXRoL3BhaXJpbmdzL3Byb3Bvc2UScgoNQ3JlYXRlUGFp'
    'cmluZxIeLnNwYWNlLnYxLkNyZWF0ZVBhaXJpbmdSZXF1ZXN0Gh8uc3BhY2UudjEuQ3JlYXRlUG'
    'FpcmluZ1Jlc3BvbnNlIiCC0+STAho6ASoiFS9hcGkvdjEvYXV0aC9wYWlyaW5ncxJ9Cg5JbnNw'
    'ZWN0UGFpcmluZxIfLnNwYWNlLnYxLkluc3BlY3RQYWlyaW5nUmVxdWVzdBogLnNwYWNlLnYxLk'
    'luc3BlY3RQYWlyaW5nUmVzcG9uc2UiKILT5JMCIjoBKiIdL2FwaS92MS9hdXRoL3BhaXJpbmdz'
    'L2luc3BlY3QScQoLUG9sbFBhaXJpbmcSHC5zcGFjZS52MS5Qb2xsUGFpcmluZ1JlcXVlc3QaHS'
    '5zcGFjZS52MS5Qb2xsUGFpcmluZ1Jlc3BvbnNlIiWC0+STAh86ASoiGi9hcGkvdjEvYXV0aC9w'
    'YWlyaW5ncy9wb2xsEnkKDUNhbmNlbFBhaXJpbmcSHi5zcGFjZS52MS5DYW5jZWxQYWlyaW5nUm'
    'VxdWVzdBofLnNwYWNlLnYxLkNhbmNlbFBhaXJpbmdSZXNwb25zZSIngtPkkwIhOgEqIhwvYXBp'
    'L3YxL2F1dGgvcGFpcmluZ3MvY2FuY2VsEnUKDENsYWltUGFpcmluZxIdLnNwYWNlLnYxLkNsYW'
    'ltUGFpcmluZ1JlcXVlc3QaHi5zcGFjZS52MS5DbGFpbVBhaXJpbmdSZXNwb25zZSImgtPkkwIg'
    'OgEqIhsvYXBpL3YxL2F1dGgvcGFpcmluZ3MvY2xhaW0SkgEKE1Jldm9rZUN1cnJlbnREZXZpY2'
    'USJC5zcGFjZS52MS5SZXZva2VDdXJyZW50RGV2aWNlUmVxdWVzdBolLnNwYWNlLnYxLlJldm9r'
    'ZUN1cnJlbnREZXZpY2VSZXNwb25zZSIugtPkkwIoOgEqIiMvYXBpL3YxL2F1dGgvZGV2aWNlcy'
    '9jdXJyZW50L3Jldm9rZRJoCgtMaXN0RGV2aWNlcxIcLnNwYWNlLnYxLkxpc3REZXZpY2VzUmVx'
    'dWVzdBodLnNwYWNlLnYxLkxpc3REZXZpY2VzUmVzcG9uc2UiHILT5JMCFhIUL2FwaS92MS9hdX'
    'RoL2RldmljZXMSWwoGTG9nb3V0Ehcuc3BhY2UudjEuTG9nb3V0UmVxdWVzdBoYLnNwYWNlLnYx'
    'LkxvZ291dFJlc3BvbnNlIh6C0+STAhg6ASoiEy9hcGkvdjEvYXV0aC9sb2dvdXQSegoPQ3JlYX'
    'RlQ2hhbGxlbmdlEiAuc3BhY2UudjEuQ3JlYXRlQ2hhbGxlbmdlUmVxdWVzdBohLnNwYWNlLnYx'
    'LkNyZWF0ZUNoYWxsZW5nZVJlc3BvbnNlIiKC0+STAhw6ASoiFy9hcGkvdjEvYXV0aC9jaGFsbG'
    'VuZ2VzEn4KEUNvbXBsZXRlQ2hhbGxlbmdlEiIuc3BhY2UudjEuQ29tcGxldGVDaGFsbGVuZ2VS'
    'ZXF1ZXN0GiMuc3BhY2UudjEuQ29tcGxldGVDaGFsbGVuZ2VSZXNwb25zZSIggtPkkwIaOgEqIh'
    'UvYXBpL3YxL2F1dGgvc2Vzc2lvbnM=');

const $core.Map<$core.String, $core.dynamic> SyncServiceBase$json = {
  '1': 'SyncService',
  '2': [
    {
      '1': 'Subscribe',
      '2': '.space.v1.SubscribeRequest',
      '3': '.space.v1.SubscribeResponse',
      '4': {},
      '6': true
    },
    {
      '1': 'ListEvents',
      '2': '.space.v1.ListEventsRequest',
      '3': '.space.v1.ListEventsResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use syncServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    SyncServiceBase$messageJson = {
  '.space.v1.SubscribeRequest': SubscribeRequest$json,
  '.space.v1.SubscribeResponse': SubscribeResponse$json,
  '.space.v1.Event': Event$json,
  '.space.v1.Content': Content$json,
  '.space.v1.Asset': Asset$json,
  '.space.v1.Reaction': Reaction$json,
  '.space.v1.ListEventsRequest': ListEventsRequest$json,
  '.space.v1.ListEventsResponse': ListEventsResponse$json,
};

/// Descriptor for `SyncService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List syncServiceDescriptor = $convert.base64Decode(
    'CgtTeW5jU2VydmljZRJ+CglTdWJzY3JpYmUSGi5zcGFjZS52MS5TdWJzY3JpYmVSZXF1ZXN0Gh'
    'suc3BhY2UudjEuU3Vic2NyaWJlUmVzcG9uc2UiNoLT5JMCMBIuL2FwaS92MS9jaGFubmVscy97'
    'Y2hhbm5lbF9pZH0vZXZlbnRzL3N1YnNjcmliZTABEnUKCkxpc3RFdmVudHMSGy5zcGFjZS52MS'
    '5MaXN0RXZlbnRzUmVxdWVzdBocLnNwYWNlLnYxLkxpc3RFdmVudHNSZXNwb25zZSIsgtPkkwIm'
    'EiQvYXBpL3YxL2NoYW5uZWxzL3tjaGFubmVsX2lkfS9ldmVudHM=');

const $core.Map<$core.String, $core.dynamic> AdminServiceBase$json = {
  '1': 'AdminService',
  '2': [
    {
      '1': 'ListMembers',
      '2': '.space.v1.ListMembersRequest',
      '3': '.space.v1.ListMembersResponse',
      '4': {}
    },
    {
      '1': 'UpdateMember',
      '2': '.space.v1.UpdateMemberRequest',
      '3': '.space.v1.UpdateMemberResponse',
      '4': {}
    },
    {
      '1': 'CreateInvite',
      '2': '.space.v1.CreateInviteRequest',
      '3': '.space.v1.CreateInviteResponse',
      '4': {}
    },
    {
      '1': 'ListInvites',
      '2': '.space.v1.ListInvitesRequest',
      '3': '.space.v1.ListInvitesResponse',
      '4': {}
    },
    {
      '1': 'RevokeInvite',
      '2': '.space.v1.RevokeInviteRequest',
      '3': '.space.v1.RevokeInviteResponse',
      '4': {}
    },
    {
      '1': 'GetSetupStatus',
      '2': '.space.v1.GetSetupStatusRequest',
      '3': '.space.v1.GetSetupStatusResponse',
      '4': {}
    },
    {
      '1': 'ClaimOwner',
      '2': '.space.v1.ClaimOwnerRequest',
      '3': '.space.v1.ClaimOwnerResponse',
      '4': {}
    },
    {
      '1': 'GetSettings',
      '2': '.space.v1.GetSettingsRequest',
      '3': '.space.v1.GetSettingsResponse',
      '4': {}
    },
    {
      '1': 'UpdateSettings',
      '2': '.space.v1.UpdateSettingsRequest',
      '3': '.space.v1.UpdateSettingsResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use adminServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AdminServiceBase$messageJson = {
  '.space.v1.ListMembersRequest': ListMembersRequest$json,
  '.space.v1.ListMembersResponse': ListMembersResponse$json,
  '.space.v1.Member': Member$json,
  '.space.v1.UpdateMemberRequest': UpdateMemberRequest$json,
  '.space.v1.UpdateMemberResponse': UpdateMemberResponse$json,
  '.space.v1.CreateInviteRequest': CreateInviteRequest$json,
  '.space.v1.CreateInviteResponse': CreateInviteResponse$json,
  '.space.v1.Invite': Invite$json,
  '.space.v1.ListInvitesRequest': ListInvitesRequest$json,
  '.space.v1.ListInvitesResponse': ListInvitesResponse$json,
  '.space.v1.RevokeInviteRequest': RevokeInviteRequest$json,
  '.space.v1.RevokeInviteResponse': RevokeInviteResponse$json,
  '.space.v1.GetSetupStatusRequest': GetSetupStatusRequest$json,
  '.space.v1.GetSetupStatusResponse': GetSetupStatusResponse$json,
  '.space.v1.ClaimOwnerRequest': ClaimOwnerRequest$json,
  '.space.v1.ClaimOwnerResponse': ClaimOwnerResponse$json,
  '.space.v1.SpaceSettings': SpaceSettings$json,
  '.space.v1.ServerIcon': ServerIcon$json,
  '.space.v1.GetSettingsRequest': GetSettingsRequest$json,
  '.space.v1.GetSettingsResponse': GetSettingsResponse$json,
  '.space.v1.UpdateSettingsRequest': UpdateSettingsRequest$json,
  '.space.v1.UpdateSettingsResponse': UpdateSettingsResponse$json,
};

/// Descriptor for `AdminService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List adminServiceDescriptor = $convert.base64Decode(
    'CgxBZG1pblNlcnZpY2USaQoLTGlzdE1lbWJlcnMSHC5zcGFjZS52MS5MaXN0TWVtYmVyc1JlcX'
    'Vlc3QaHS5zcGFjZS52MS5MaXN0TWVtYmVyc1Jlc3BvbnNlIh2C0+STAhcSFS9hcGkvdjEvc3Bh'
    'Y2UvbWVtYmVycxJ+CgxVcGRhdGVNZW1iZXISHS5zcGFjZS52MS5VcGRhdGVNZW1iZXJSZXF1ZX'
    'N0Gh4uc3BhY2UudjEuVXBkYXRlTWVtYmVyUmVzcG9uc2UiL4LT5JMCKToBKjIkL2FwaS92MS9z'
    'cGFjZS9tZW1iZXJzL3twcmluY2lwYWxfaWR9Em8KDENyZWF0ZUludml0ZRIdLnNwYWNlLnYxLk'
    'NyZWF0ZUludml0ZVJlcXVlc3QaHi5zcGFjZS52MS5DcmVhdGVJbnZpdGVSZXNwb25zZSIggtPk'
    'kwIaOgEqIhUvYXBpL3YxL3NwYWNlL2ludml0ZXMSaQoLTGlzdEludml0ZXMSHC5zcGFjZS52MS'
    '5MaXN0SW52aXRlc1JlcXVlc3QaHS5zcGFjZS52MS5MaXN0SW52aXRlc1Jlc3BvbnNlIh2C0+ST'
    'AhcSFS9hcGkvdjEvc3BhY2UvaW52aXRlcxKCAQoMUmV2b2tlSW52aXRlEh0uc3BhY2UudjEuUm'
    'V2b2tlSW52aXRlUmVxdWVzdBoeLnNwYWNlLnYxLlJldm9rZUludml0ZVJlc3BvbnNlIjOC0+ST'
    'Ai06ASoiKC9hcGkvdjEvc3BhY2UvaW52aXRlcy97aW52aXRlX2lkfS9yZXZva2UScAoOR2V0U2'
    'V0dXBTdGF0dXMSHy5zcGFjZS52MS5HZXRTZXR1cFN0YXR1c1JlcXVlc3QaIC5zcGFjZS52MS5H'
    'ZXRTZXR1cFN0YXR1c1Jlc3BvbnNlIhuC0+STAhUSEy9hcGkvdjEvc3BhY2Uvc2V0dXASbQoKQ2'
    'xhaW1Pd25lchIbLnNwYWNlLnYxLkNsYWltT3duZXJSZXF1ZXN0Ghwuc3BhY2UudjEuQ2xhaW1P'
    'd25lclJlc3BvbnNlIiSC0+STAh46ASoiGS9hcGkvdjEvc3BhY2Uvc2V0dXAvY2xhaW0SagoLR2'
    'V0U2V0dGluZ3MSHC5zcGFjZS52MS5HZXRTZXR0aW5nc1JlcXVlc3QaHS5zcGFjZS52MS5HZXRT'
    'ZXR0aW5nc1Jlc3BvbnNlIh6C0+STAhgSFi9hcGkvdjEvc3BhY2Uvc2V0dGluZ3MSdgoOVXBkYX'
    'RlU2V0dGluZ3MSHy5zcGFjZS52MS5VcGRhdGVTZXR0aW5nc1JlcXVlc3QaIC5zcGFjZS52MS5V'
    'cGRhdGVTZXR0aW5nc1Jlc3BvbnNlIiGC0+STAhs6ASoyFi9hcGkvdjEvc3BhY2Uvc2V0dGluZ3'
    'M=');

const $core.Map<$core.String, $core.dynamic> MembershipServiceBase$json = {
  '1': 'MembershipService',
  '2': [
    {
      '1': 'UpdateProfile',
      '2': '.space.v1.UpdateProfileRequest',
      '3': '.space.v1.UpdateProfileResponse'
    },
    {
      '1': 'PreviewInvite',
      '2': '.space.v1.PreviewInviteRequest',
      '3': '.space.v1.PreviewInviteResponse',
      '4': {}
    },
    {
      '1': 'AcceptInvite',
      '2': '.space.v1.AcceptInviteRequest',
      '3': '.space.v1.AcceptInviteResponse',
      '4': {}
    },
    {
      '1': 'GetMembership',
      '2': '.space.v1.GetMembershipRequest',
      '3': '.space.v1.GetMembershipResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use membershipServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    MembershipServiceBase$messageJson = {
  '.space.v1.UpdateProfileRequest': UpdateProfileRequest$json,
  '.space.v1.UpdateProfileResponse': UpdateProfileResponse$json,
  '.space.v1.Member': Member$json,
  '.space.v1.PreviewInviteRequest': PreviewInviteRequest$json,
  '.space.v1.PreviewInviteResponse': PreviewInviteResponse$json,
  '.space.v1.AcceptInviteRequest': AcceptInviteRequest$json,
  '.space.v1.AcceptInviteResponse': AcceptInviteResponse$json,
  '.space.v1.GetMembershipRequest': GetMembershipRequest$json,
  '.space.v1.GetMembershipResponse': GetMembershipResponse$json,
};

/// Descriptor for `MembershipService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List membershipServiceDescriptor = $convert.base64Decode(
    'ChFNZW1iZXJzaGlwU2VydmljZRJQCg1VcGRhdGVQcm9maWxlEh4uc3BhY2UudjEuVXBkYXRlUH'
    'JvZmlsZVJlcXVlc3QaHy5zcGFjZS52MS5VcGRhdGVQcm9maWxlUmVzcG9uc2USfwoNUHJldmll'
    'd0ludml0ZRIeLnNwYWNlLnYxLlByZXZpZXdJbnZpdGVSZXF1ZXN0Gh8uc3BhY2UudjEuUHJldm'
    'lld0ludml0ZVJlc3BvbnNlIi2C0+STAic6ASoiIi9hcGkvdjEvbWVtYmVyc2hpcC9pbnZpdGVz'
    'L3ByZXZpZXcSewoMQWNjZXB0SW52aXRlEh0uc3BhY2UudjEuQWNjZXB0SW52aXRlUmVxdWVzdB'
    'oeLnNwYWNlLnYxLkFjY2VwdEludml0ZVJlc3BvbnNlIiyC0+STAiY6ASoiIS9hcGkvdjEvbWVt'
    'YmVyc2hpcC9pbnZpdGVzL2FjY2VwdBJsCg1HZXRNZW1iZXJzaGlwEh4uc3BhY2UudjEuR2V0TW'
    'VtYmVyc2hpcFJlcXVlc3QaHy5zcGFjZS52MS5HZXRNZW1iZXJzaGlwUmVzcG9uc2UiGoLT5JMC'
    'FBISL2FwaS92MS9tZW1iZXJzaGlw');

const $core.Map<$core.String, $core.dynamic> MlsServiceBase$json = {
  '1': 'MlsService',
  '2': [
    {
      '1': 'RegisterMlsDevice',
      '2': '.space.v1.RegisterMlsDeviceRequest',
      '3': '.space.v1.RegisterMlsDeviceResponse'
    },
    {
      '1': 'ListMlsDevices',
      '2': '.space.v1.ListMlsDevicesRequest',
      '3': '.space.v1.ListMlsDevicesResponse'
    },
    {
      '1': 'GetMlsChannel',
      '2': '.space.v1.GetMlsChannelRequest',
      '3': '.space.v1.GetMlsChannelResponse'
    },
    {
      '1': 'PublishMls',
      '2': '.space.v1.PublishMlsRequest',
      '3': '.space.v1.PublishMlsResponse'
    },
    {
      '1': 'ListMlsEnvelopes',
      '2': '.space.v1.ListMlsEnvelopesRequest',
      '3': '.space.v1.ListMlsEnvelopesResponse'
    },
  ],
};

@$core.Deprecated('Use mlsServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    MlsServiceBase$messageJson = {
  '.space.v1.RegisterMlsDeviceRequest': RegisterMlsDeviceRequest$json,
  '.space.v1.RegisterMlsDeviceResponse': RegisterMlsDeviceResponse$json,
  '.space.v1.MlsDevice': MlsDevice$json,
  '.space.v1.ListMlsDevicesRequest': ListMlsDevicesRequest$json,
  '.space.v1.ListMlsDevicesResponse': ListMlsDevicesResponse$json,
  '.space.v1.GetMlsChannelRequest': GetMlsChannelRequest$json,
  '.space.v1.GetMlsChannelResponse': GetMlsChannelResponse$json,
  '.space.v1.PublishMlsRequest': PublishMlsRequest$json,
  '.space.v1.PublishMlsResponse': PublishMlsResponse$json,
  '.space.v1.MlsEnvelope': MlsEnvelope$json,
  '.space.v1.ListMlsEnvelopesRequest': ListMlsEnvelopesRequest$json,
  '.space.v1.ListMlsEnvelopesResponse': ListMlsEnvelopesResponse$json,
};

/// Descriptor for `MlsService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List mlsServiceDescriptor = $convert.base64Decode(
    'CgpNbHNTZXJ2aWNlElwKEVJlZ2lzdGVyTWxzRGV2aWNlEiIuc3BhY2UudjEuUmVnaXN0ZXJNbH'
    'NEZXZpY2VSZXF1ZXN0GiMuc3BhY2UudjEuUmVnaXN0ZXJNbHNEZXZpY2VSZXNwb25zZRJTCg5M'
    'aXN0TWxzRGV2aWNlcxIfLnNwYWNlLnYxLkxpc3RNbHNEZXZpY2VzUmVxdWVzdBogLnNwYWNlLn'
    'YxLkxpc3RNbHNEZXZpY2VzUmVzcG9uc2USUAoNR2V0TWxzQ2hhbm5lbBIeLnNwYWNlLnYxLkdl'
    'dE1sc0NoYW5uZWxSZXF1ZXN0Gh8uc3BhY2UudjEuR2V0TWxzQ2hhbm5lbFJlc3BvbnNlEkcKCl'
    'B1Ymxpc2hNbHMSGy5zcGFjZS52MS5QdWJsaXNoTWxzUmVxdWVzdBocLnNwYWNlLnYxLlB1Ymxp'
    'c2hNbHNSZXNwb25zZRJZChBMaXN0TWxzRW52ZWxvcGVzEiEuc3BhY2UudjEuTGlzdE1sc0Vudm'
    'Vsb3Blc1JlcXVlc3QaIi5zcGFjZS52MS5MaXN0TWxzRW52ZWxvcGVzUmVzcG9uc2U=');
