// This is a generated file - do not edit.
//
// Generated from space/v1/extensions_p1.proto.

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

@$core.Deprecated('Use extensionCommandEffectDescriptor instead')
const ExtensionCommandEffect$json = {
  '1': 'ExtensionCommandEffect',
  '2': [
    {'1': 'EXTENSION_COMMAND_EFFECT_UNSPECIFIED', '2': 0},
    {'1': 'EXTENSION_COMMAND_EFFECT_NONE', '2': 1},
    {'1': 'EXTENSION_COMMAND_EFFECT_MUTATION', '2': 2},
  ],
};

/// Descriptor for `ExtensionCommandEffect`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List extensionCommandEffectDescriptor = $convert.base64Decode(
    'ChZFeHRlbnNpb25Db21tYW5kRWZmZWN0EigKJEVYVEVOU0lPTl9DT01NQU5EX0VGRkVDVF9VTl'
    'NQRUNJRklFRBAAEiEKHUVYVEVOU0lPTl9DT01NQU5EX0VGRkVDVF9OT05FEAESJQohRVhURU5T'
    'SU9OX0NPTU1BTkRfRUZGRUNUX01VVEFUSU9OEAI=');

@$core.Deprecated('Use extensionCommandOutcomeDescriptor instead')
const ExtensionCommandOutcome$json = {
  '1': 'ExtensionCommandOutcome',
  '2': [
    {'1': 'EXTENSION_COMMAND_OUTCOME_UNSPECIFIED', '2': 0},
    {'1': 'EXTENSION_COMMAND_OUTCOME_UNKNOWN', '2': 1},
    {'1': 'EXTENSION_COMMAND_OUTCOME_CONFIRMED', '2': 2},
  ],
};

/// Descriptor for `ExtensionCommandOutcome`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List extensionCommandOutcomeDescriptor = $convert.base64Decode(
    'ChdFeHRlbnNpb25Db21tYW5kT3V0Y29tZRIpCiVFWFRFTlNJT05fQ09NTUFORF9PVVRDT01FX1'
    'VOU1BFQ0lGSUVEEAASJQohRVhURU5TSU9OX0NPTU1BTkRfT1VUQ09NRV9VTktOT1dOEAESJwoj'
    'RVhURU5TSU9OX0NPTU1BTkRfT1VUQ09NRV9DT05GSVJNRUQQAg==');

@$core.Deprecated('Use extensionInstallationDescriptor instead')
const ExtensionInstallation$json = {
  '1': 'ExtensionInstallation',
  '2': [
    {'1': 'installation_id', '3': 1, '4': 1, '5': 9, '10': 'installationId'},
    {'1': 'state', '3': 2, '4': 1, '5': 9, '10': 'state'},
    {'1': 'revision', '3': 3, '4': 1, '5': 3, '10': 'revision'},
    {'1': 'generation', '3': 4, '4': 1, '5': 9, '10': 'generation'},
    {'1': 'binding_sha256', '3': 5, '4': 1, '5': 12, '10': 'bindingSha256'},
  ],
};

/// Descriptor for `ExtensionInstallation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List extensionInstallationDescriptor = $convert.base64Decode(
    'ChVFeHRlbnNpb25JbnN0YWxsYXRpb24SJwoPaW5zdGFsbGF0aW9uX2lkGAEgASgJUg5pbnN0YW'
    'xsYXRpb25JZBIUCgVzdGF0ZRgCIAEoCVIFc3RhdGUSGgoIcmV2aXNpb24YAyABKANSCHJldmlz'
    'aW9uEh4KCmdlbmVyYXRpb24YBCABKAlSCmdlbmVyYXRpb24SJQoOYmluZGluZ19zaGEyNTYYBS'
    'ABKAxSDWJpbmRpbmdTaGEyNTY=');

@$core.Deprecated('Use listExtensionInstallationsRequestDescriptor instead')
const ListExtensionInstallationsRequest$json = {
  '1': 'ListExtensionInstallationsRequest',
  '2': [
    {
      '1': 'after_installation_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'afterInstallationId'
    },
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'generation', '3': 3, '4': 1, '5': 9, '10': 'generation'},
  ],
};

/// Descriptor for `ListExtensionInstallationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExtensionInstallationsRequestDescriptor =
    $convert.base64Decode(
        'CiFMaXN0RXh0ZW5zaW9uSW5zdGFsbGF0aW9uc1JlcXVlc3QSMgoVYWZ0ZXJfaW5zdGFsbGF0aW'
        '9uX2lkGAEgASgJUhNhZnRlckluc3RhbGxhdGlvbklkEhsKCXBhZ2Vfc2l6ZRgCIAEoBVIIcGFn'
        'ZVNpemUSHgoKZ2VuZXJhdGlvbhgDIAEoCVIKZ2VuZXJhdGlvbg==');

@$core.Deprecated('Use listExtensionInstallationsResponseDescriptor instead')
const ListExtensionInstallationsResponse$json = {
  '1': 'ListExtensionInstallationsResponse',
  '2': [
    {
      '1': 'installations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ExtensionInstallation',
      '10': 'installations'
    },
    {
      '1': 'next_after_installation_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'nextAfterInstallationId'
    },
    {'1': 'generation', '3': 3, '4': 1, '5': 9, '10': 'generation'},
  ],
};

/// Descriptor for `ListExtensionInstallationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExtensionInstallationsResponseDescriptor =
    $convert.base64Decode(
        'CiJMaXN0RXh0ZW5zaW9uSW5zdGFsbGF0aW9uc1Jlc3BvbnNlEkUKDWluc3RhbGxhdGlvbnMYAS'
        'ADKAsyHy5zcGFjZS52MS5FeHRlbnNpb25JbnN0YWxsYXRpb25SDWluc3RhbGxhdGlvbnMSOwoa'
        'bmV4dF9hZnRlcl9pbnN0YWxsYXRpb25faWQYAiABKAlSF25leHRBZnRlckluc3RhbGxhdGlvbk'
        'lkEh4KCmdlbmVyYXRpb24YAyABKAlSCmdlbmVyYXRpb24=');

@$core.Deprecated('Use getExtensionInstallationRequestDescriptor instead')
const GetExtensionInstallationRequest$json = {
  '1': 'GetExtensionInstallationRequest',
  '2': [
    {'1': 'installation_id', '3': 1, '4': 1, '5': 9, '10': 'installationId'},
  ],
};

/// Descriptor for `GetExtensionInstallationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getExtensionInstallationRequestDescriptor =
    $convert.base64Decode(
        'Ch9HZXRFeHRlbnNpb25JbnN0YWxsYXRpb25SZXF1ZXN0EicKD2luc3RhbGxhdGlvbl9pZBgBIA'
        'EoCVIOaW5zdGFsbGF0aW9uSWQ=');

@$core.Deprecated('Use getExtensionInstallationResponseDescriptor instead')
const GetExtensionInstallationResponse$json = {
  '1': 'GetExtensionInstallationResponse',
  '2': [
    {
      '1': 'installation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ExtensionInstallation',
      '10': 'installation'
    },
  ],
};

/// Descriptor for `GetExtensionInstallationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getExtensionInstallationResponseDescriptor =
    $convert.base64Decode(
        'CiBHZXRFeHRlbnNpb25JbnN0YWxsYXRpb25SZXNwb25zZRJDCgxpbnN0YWxsYXRpb24YASABKA'
        'syHy5zcGFjZS52MS5FeHRlbnNpb25JbnN0YWxsYXRpb25SDGluc3RhbGxhdGlvbg==');

@$core.Deprecated('Use changeExtensionInstallationRequestDescriptor instead')
const ChangeExtensionInstallationRequest$json = {
  '1': 'ChangeExtensionInstallationRequest',
  '2': [
    {'1': 'installation_id', '3': 1, '4': 1, '5': 9, '10': 'installationId'},
    {'1': 'generation', '3': 2, '4': 1, '5': 9, '10': 'generation'},
    {
      '1': 'expected_revision',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'expectedRevision'
    },
    {'1': 'action', '3': 4, '4': 1, '5': 9, '10': 'action'},
  ],
};

/// Descriptor for `ChangeExtensionInstallationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeExtensionInstallationRequestDescriptor =
    $convert.base64Decode(
        'CiJDaGFuZ2VFeHRlbnNpb25JbnN0YWxsYXRpb25SZXF1ZXN0EicKD2luc3RhbGxhdGlvbl9pZB'
        'gBIAEoCVIOaW5zdGFsbGF0aW9uSWQSHgoKZ2VuZXJhdGlvbhgCIAEoCVIKZ2VuZXJhdGlvbhIr'
        'ChFleHBlY3RlZF9yZXZpc2lvbhgDIAEoA1IQZXhwZWN0ZWRSZXZpc2lvbhIWCgZhY3Rpb24YBC'
        'ABKAlSBmFjdGlvbg==');

@$core.Deprecated('Use changeExtensionInstallationResponseDescriptor instead')
const ChangeExtensionInstallationResponse$json = {
  '1': 'ChangeExtensionInstallationResponse',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 9, '10': 'state'},
    {'1': 'revision', '3': 2, '4': 1, '5': 3, '10': 'revision'},
    {'1': 'generation', '3': 3, '4': 1, '5': 9, '10': 'generation'},
  ],
};

/// Descriptor for `ChangeExtensionInstallationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeExtensionInstallationResponseDescriptor =
    $convert.base64Decode(
        'CiNDaGFuZ2VFeHRlbnNpb25JbnN0YWxsYXRpb25SZXNwb25zZRIUCgVzdGF0ZRgBIAEoCVIFc3'
        'RhdGUSGgoIcmV2aXNpb24YAiABKANSCHJldmlzaW9uEh4KCmdlbmVyYXRpb24YAyABKAlSCmdl'
        'bmVyYXRpb24=');

@$core.Deprecated('Use extensionInstallationAuditEntryDescriptor instead')
const ExtensionInstallationAuditEntry$json = {
  '1': 'ExtensionInstallationAuditEntry',
  '2': [
    {'1': 'revision', '3': 1, '4': 1, '5': 3, '10': 'revision'},
    {'1': 'generation', '3': 2, '4': 1, '5': 9, '10': 'generation'},
    {'1': 'action', '3': 3, '4': 1, '5': 9, '10': 'action'},
    {'1': 'actor', '3': 4, '4': 1, '5': 9, '10': 'actor'},
    {'1': 'principal_id', '3': 5, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'previous_state', '3': 6, '4': 1, '5': 9, '10': 'previousState'},
    {'1': 'state', '3': 7, '4': 1, '5': 9, '10': 'state'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 9, '10': 'createdAt'},
  ],
};

/// Descriptor for `ExtensionInstallationAuditEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List extensionInstallationAuditEntryDescriptor = $convert.base64Decode(
    'Ch9FeHRlbnNpb25JbnN0YWxsYXRpb25BdWRpdEVudHJ5EhoKCHJldmlzaW9uGAEgASgDUghyZX'
    'Zpc2lvbhIeCgpnZW5lcmF0aW9uGAIgASgJUgpnZW5lcmF0aW9uEhYKBmFjdGlvbhgDIAEoCVIG'
    'YWN0aW9uEhQKBWFjdG9yGAQgASgJUgVhY3RvchIhCgxwcmluY2lwYWxfaWQYBSABKAlSC3ByaW'
    '5jaXBhbElkEiUKDnByZXZpb3VzX3N0YXRlGAYgASgJUg1wcmV2aW91c1N0YXRlEhQKBXN0YXRl'
    'GAcgASgJUgVzdGF0ZRIdCgpjcmVhdGVkX2F0GAggASgJUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use listExtensionInstallationAuditRequestDescriptor instead')
const ListExtensionInstallationAuditRequest$json = {
  '1': 'ListExtensionInstallationAuditRequest',
  '2': [
    {'1': 'installation_id', '3': 1, '4': 1, '5': 9, '10': 'installationId'},
    {'1': 'generation', '3': 2, '4': 1, '5': 9, '10': 'generation'},
    {'1': 'after_revision', '3': 3, '4': 1, '5': 3, '10': 'afterRevision'},
    {'1': 'through_revision', '3': 4, '4': 1, '5': 3, '10': 'throughRevision'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListExtensionInstallationAuditRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExtensionInstallationAuditRequestDescriptor =
    $convert.base64Decode(
        'CiVMaXN0RXh0ZW5zaW9uSW5zdGFsbGF0aW9uQXVkaXRSZXF1ZXN0EicKD2luc3RhbGxhdGlvbl'
        '9pZBgBIAEoCVIOaW5zdGFsbGF0aW9uSWQSHgoKZ2VuZXJhdGlvbhgCIAEoCVIKZ2VuZXJhdGlv'
        'bhIlCg5hZnRlcl9yZXZpc2lvbhgDIAEoA1INYWZ0ZXJSZXZpc2lvbhIpChB0aHJvdWdoX3Jldm'
        'lzaW9uGAQgASgDUg90aHJvdWdoUmV2aXNpb24SGwoJcGFnZV9zaXplGAUgASgFUghwYWdlU2l6'
        'ZQ==');

@$core
    .Deprecated('Use listExtensionInstallationAuditResponseDescriptor instead')
const ListExtensionInstallationAuditResponse$json = {
  '1': 'ListExtensionInstallationAuditResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ExtensionInstallationAuditEntry',
      '10': 'entries'
    },
    {
      '1': 'next_after_revision',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'nextAfterRevision'
    },
    {'1': 'through_revision', '3': 3, '4': 1, '5': 3, '10': 'throughRevision'},
    {'1': 'generation', '3': 4, '4': 1, '5': 9, '10': 'generation'},
  ],
};

/// Descriptor for `ListExtensionInstallationAuditResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExtensionInstallationAuditResponseDescriptor =
    $convert.base64Decode(
        'CiZMaXN0RXh0ZW5zaW9uSW5zdGFsbGF0aW9uQXVkaXRSZXNwb25zZRJDCgdlbnRyaWVzGAEgAy'
        'gLMikuc3BhY2UudjEuRXh0ZW5zaW9uSW5zdGFsbGF0aW9uQXVkaXRFbnRyeVIHZW50cmllcxIu'
        'ChNuZXh0X2FmdGVyX3JldmlzaW9uGAIgASgDUhFuZXh0QWZ0ZXJSZXZpc2lvbhIpChB0aHJvdW'
        'doX3JldmlzaW9uGAMgASgDUg90aHJvdWdoUmV2aXNpb24SHgoKZ2VuZXJhdGlvbhgEIAEoCVIK'
        'Z2VuZXJhdGlvbg==');

@$core.Deprecated('Use getExtensionMutationContextRequestDescriptor instead')
const GetExtensionMutationContextRequest$json = {
  '1': 'GetExtensionMutationContextRequest',
  '2': [
    {'1': 'instance_id', '3': 1, '4': 1, '5': 9, '10': 'instanceId'},
    {
      '1': 'request_retry_window',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'requestRetryWindow'
    },
  ],
};

/// Descriptor for `GetExtensionMutationContextRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getExtensionMutationContextRequestDescriptor =
    $convert.base64Decode(
        'CiJHZXRFeHRlbnNpb25NdXRhdGlvbkNvbnRleHRSZXF1ZXN0Eh8KC2luc3RhbmNlX2lkGAEgAS'
        'gJUgppbnN0YW5jZUlkEjAKFHJlcXVlc3RfcmV0cnlfd2luZG93GAIgASgIUhJyZXF1ZXN0UmV0'
        'cnlXaW5kb3c=');

@$core.Deprecated('Use getExtensionMutationContextResponseDescriptor instead')
const GetExtensionMutationContextResponse$json = {
  '1': 'GetExtensionMutationContextResponse',
  '2': [
    {'1': 'history_id', '3': 1, '4': 1, '5': 9, '10': 'historyId'},
    {'1': 'retry_lease_id', '3': 2, '4': 1, '5': 9, '10': 'retryLeaseId'},
    {
      '1': 'retry_window_remaining_ms',
      '3': 3,
      '4': 1,
      '5': 4,
      '10': 'retryWindowRemainingMs'
    },
  ],
};

/// Descriptor for `GetExtensionMutationContextResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getExtensionMutationContextResponseDescriptor =
    $convert.base64Decode(
        'CiNHZXRFeHRlbnNpb25NdXRhdGlvbkNvbnRleHRSZXNwb25zZRIdCgpoaXN0b3J5X2lkGAEgAS'
        'gJUgloaXN0b3J5SWQSJAoOcmV0cnlfbGVhc2VfaWQYAiABKAlSDHJldHJ5TGVhc2VJZBI5Chly'
        'ZXRyeV93aW5kb3dfcmVtYWluaW5nX21zGAMgASgEUhZyZXRyeVdpbmRvd1JlbWFpbmluZ01z');

@$core.Deprecated('Use queryExtensionRequestDescriptor instead')
const QueryExtensionRequest$json = {
  '1': 'QueryExtensionRequest',
  '2': [
    {'1': 'instance_id', '3': 1, '4': 1, '5': 9, '10': 'instanceId'},
    {'1': 'query', '3': 2, '4': 1, '5': 9, '10': 'query'},
    {'1': 'payload_json', '3': 3, '4': 1, '5': 12, '10': 'payloadJson'},
  ],
};

/// Descriptor for `QueryExtensionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryExtensionRequestDescriptor = $convert.base64Decode(
    'ChVRdWVyeUV4dGVuc2lvblJlcXVlc3QSHwoLaW5zdGFuY2VfaWQYASABKAlSCmluc3RhbmNlSW'
    'QSFAoFcXVlcnkYAiABKAlSBXF1ZXJ5EiEKDHBheWxvYWRfanNvbhgDIAEoDFILcGF5bG9hZEpz'
    'b24=');

@$core.Deprecated('Use queryExtensionResponseDescriptor instead')
const QueryExtensionResponse$json = {
  '1': 'QueryExtensionResponse',
  '2': [
    {'1': 'document_json', '3': 1, '4': 1, '5': 12, '10': 'documentJson'},
    {'1': 'ui_api', '3': 2, '4': 1, '5': 9, '10': 'uiApi'},
  ],
};

/// Descriptor for `QueryExtensionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryExtensionResponseDescriptor =
    $convert.base64Decode(
        'ChZRdWVyeUV4dGVuc2lvblJlc3BvbnNlEiMKDWRvY3VtZW50X2pzb24YASABKAxSDGRvY3VtZW'
        '50SnNvbhIVCgZ1aV9hcGkYAiABKAlSBXVpQXBp');

@$core.Deprecated('Use executeExtensionCommandRequestDescriptor instead')
const ExecuteExtensionCommandRequest$json = {
  '1': 'ExecuteExtensionCommandRequest',
  '2': [
    {'1': 'instance_id', '3': 1, '4': 1, '5': 9, '10': 'instanceId'},
    {'1': 'command', '3': 2, '4': 1, '5': 9, '10': 'command'},
    {'1': 'payload_json', '3': 3, '4': 1, '5': 12, '10': 'payloadJson'},
    {
      '1': 'effect',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.space.v1.ExtensionCommandEffect',
      '10': 'effect'
    },
    {'1': 'idempotency_key', '3': 5, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {
      '1': 'expected_state_revision',
      '3': 6,
      '4': 1,
      '5': 4,
      '10': 'expectedStateRevision'
    },
    {'1': 'history_id', '3': 7, '4': 1, '5': 9, '10': 'historyId'},
    {'1': 'retry_lease_id', '3': 8, '4': 1, '5': 9, '10': 'retryLeaseId'},
  ],
};

/// Descriptor for `ExecuteExtensionCommandRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeExtensionCommandRequestDescriptor = $convert.base64Decode(
    'Ch5FeGVjdXRlRXh0ZW5zaW9uQ29tbWFuZFJlcXVlc3QSHwoLaW5zdGFuY2VfaWQYASABKAlSCm'
    'luc3RhbmNlSWQSGAoHY29tbWFuZBgCIAEoCVIHY29tbWFuZBIhCgxwYXlsb2FkX2pzb24YAyAB'
    'KAxSC3BheWxvYWRKc29uEjgKBmVmZmVjdBgEIAEoDjIgLnNwYWNlLnYxLkV4dGVuc2lvbkNvbW'
    '1hbmRFZmZlY3RSBmVmZmVjdBInCg9pZGVtcG90ZW5jeV9rZXkYBSABKAlSDmlkZW1wb3RlbmN5'
    'S2V5EjYKF2V4cGVjdGVkX3N0YXRlX3JldmlzaW9uGAYgASgEUhVleHBlY3RlZFN0YXRlUmV2aX'
    'Npb24SHQoKaGlzdG9yeV9pZBgHIAEoCVIJaGlzdG9yeUlkEiQKDnJldHJ5X2xlYXNlX2lkGAgg'
    'ASgJUgxyZXRyeUxlYXNlSWQ=');

@$core.Deprecated('Use executeExtensionCommandResponseDescriptor instead')
const ExecuteExtensionCommandResponse$json = {
  '1': 'ExecuteExtensionCommandResponse',
  '2': [
    {'1': 'document_json', '3': 1, '4': 1, '5': 12, '10': 'documentJson'},
    {
      '1': 'effect',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.space.v1.ExtensionCommandEffect',
      '10': 'effect'
    },
    {'1': 'state_revision', '3': 3, '4': 1, '5': 4, '10': 'stateRevision'},
    {'1': 'replayed', '3': 4, '4': 1, '5': 8, '10': 'replayed'},
  ],
};

/// Descriptor for `ExecuteExtensionCommandResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeExtensionCommandResponseDescriptor =
    $convert.base64Decode(
        'Ch9FeGVjdXRlRXh0ZW5zaW9uQ29tbWFuZFJlc3BvbnNlEiMKDWRvY3VtZW50X2pzb24YASABKA'
        'xSDGRvY3VtZW50SnNvbhI4CgZlZmZlY3QYAiABKA4yIC5zcGFjZS52MS5FeHRlbnNpb25Db21t'
        'YW5kRWZmZWN0UgZlZmZlY3QSJQoOc3RhdGVfcmV2aXNpb24YAyABKARSDXN0YXRlUmV2aXNpb2'
        '4SGgoIcmVwbGF5ZWQYBCABKAhSCHJlcGxheWVk');

@$core.Deprecated('Use reconcileExtensionCommandRequestDescriptor instead')
const ReconcileExtensionCommandRequest$json = {
  '1': 'ReconcileExtensionCommandRequest',
  '2': [
    {
      '1': 'command',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ExecuteExtensionCommandRequest',
      '10': 'command'
    },
  ],
};

/// Descriptor for `ReconcileExtensionCommandRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcileExtensionCommandRequestDescriptor =
    $convert.base64Decode(
        'CiBSZWNvbmNpbGVFeHRlbnNpb25Db21tYW5kUmVxdWVzdBJCCgdjb21tYW5kGAEgASgLMiguc3'
        'BhY2UudjEuRXhlY3V0ZUV4dGVuc2lvbkNvbW1hbmRSZXF1ZXN0Ugdjb21tYW5k');

@$core.Deprecated('Use reconcileExtensionCommandResponseDescriptor instead')
const ReconcileExtensionCommandResponse$json = {
  '1': 'ReconcileExtensionCommandResponse',
  '2': [
    {
      '1': 'outcome',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.space.v1.ExtensionCommandOutcome',
      '10': 'outcome'
    },
    {
      '1': 'receipt',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.space.v1.ExecuteExtensionCommandResponse',
      '10': 'receipt'
    },
    {
      '1': 'retry_window_known',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'retryWindowKnown'
    },
    {
      '1': 'retry_window_remaining_ms',
      '3': 4,
      '4': 1,
      '5': 4,
      '10': 'retryWindowRemainingMs'
    },
  ],
};

/// Descriptor for `ReconcileExtensionCommandResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcileExtensionCommandResponseDescriptor = $convert.base64Decode(
    'CiFSZWNvbmNpbGVFeHRlbnNpb25Db21tYW5kUmVzcG9uc2USOwoHb3V0Y29tZRgBIAEoDjIhLn'
    'NwYWNlLnYxLkV4dGVuc2lvbkNvbW1hbmRPdXRjb21lUgdvdXRjb21lEkMKB3JlY2VpcHQYAiAB'
    'KAsyKS5zcGFjZS52MS5FeGVjdXRlRXh0ZW5zaW9uQ29tbWFuZFJlc3BvbnNlUgdyZWNlaXB0Ei'
    'wKEnJldHJ5X3dpbmRvd19rbm93bhgDIAEoCFIQcmV0cnlXaW5kb3dLbm93bhI5ChlyZXRyeV93'
    'aW5kb3dfcmVtYWluaW5nX21zGAQgASgEUhZyZXRyeVdpbmRvd1JlbWFpbmluZ01z');

@$core.Deprecated('Use extensionMutationPlanDescriptor instead')
const ExtensionMutationPlan$json = {
  '1': 'ExtensionMutationPlan',
  '2': [
    {
      '1': 'expected_state_revision',
      '3': 1,
      '4': 1,
      '5': 4,
      '10': 'expectedStateRevision'
    },
    {
      '1': 'operations',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ExtensionMutationOperation',
      '10': 'operations'
    },
    {
      '1': 'events',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.space.v1.ExtensionMutationEvent',
      '10': 'events'
    },
  ],
};

/// Descriptor for `ExtensionMutationPlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List extensionMutationPlanDescriptor = $convert.base64Decode(
    'ChVFeHRlbnNpb25NdXRhdGlvblBsYW4SNgoXZXhwZWN0ZWRfc3RhdGVfcmV2aXNpb24YASABKA'
    'RSFWV4cGVjdGVkU3RhdGVSZXZpc2lvbhJECgpvcGVyYXRpb25zGAIgAygLMiQuc3BhY2UudjEu'
    'RXh0ZW5zaW9uTXV0YXRpb25PcGVyYXRpb25SCm9wZXJhdGlvbnMSOAoGZXZlbnRzGAMgAygLMi'
    'Auc3BhY2UudjEuRXh0ZW5zaW9uTXV0YXRpb25FdmVudFIGZXZlbnRz');

@$core.Deprecated('Use extensionMutationOperationDescriptor instead')
const ExtensionMutationOperation$json = {
  '1': 'ExtensionMutationOperation',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'put_json', '3': 2, '4': 1, '5': 12, '9': 0, '10': 'putJson'},
    {'1': 'delete', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'delete'},
  ],
  '8': [
    {'1': 'change'},
  ],
};

/// Descriptor for `ExtensionMutationOperation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List extensionMutationOperationDescriptor =
    $convert.base64Decode(
        'ChpFeHRlbnNpb25NdXRhdGlvbk9wZXJhdGlvbhIQCgNrZXkYASABKAlSA2tleRIbCghwdXRfan'
        'NvbhgCIAEoDEgAUgdwdXRKc29uEhgKBmRlbGV0ZRgDIAEoCEgAUgZkZWxldGVCCAoGY2hhbmdl');

@$core.Deprecated('Use extensionMutationEventDescriptor instead')
const ExtensionMutationEvent$json = {
  '1': 'ExtensionMutationEvent',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {'1': 'payload_json', '3': 2, '4': 1, '5': 12, '10': 'payloadJson'},
  ],
};

/// Descriptor for `ExtensionMutationEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List extensionMutationEventDescriptor =
    $convert.base64Decode(
        'ChZFeHRlbnNpb25NdXRhdGlvbkV2ZW50EhIKBHR5cGUYASABKAlSBHR5cGUSIQoMcGF5bG9hZF'
        '9qc29uGAIgASgMUgtwYXlsb2FkSnNvbg==');

const $core.Map<$core.String, $core.dynamic> ExtensionP1ServiceBase$json = {
  '1': 'ExtensionP1Service',
  '2': [
    {
      '1': 'QueryExtension',
      '2': '.space.v1.QueryExtensionRequest',
      '3': '.space.v1.QueryExtensionResponse'
    },
    {
      '1': 'ExecuteExtensionCommand',
      '2': '.space.v1.ExecuteExtensionCommandRequest',
      '3': '.space.v1.ExecuteExtensionCommandResponse'
    },
    {
      '1': 'ReconcileExtensionCommand',
      '2': '.space.v1.ReconcileExtensionCommandRequest',
      '3': '.space.v1.ReconcileExtensionCommandResponse'
    },
    {
      '1': 'GetExtensionMutationContext',
      '2': '.space.v1.GetExtensionMutationContextRequest',
      '3': '.space.v1.GetExtensionMutationContextResponse'
    },
    {
      '1': 'ListExtensionInstallations',
      '2': '.space.v1.ListExtensionInstallationsRequest',
      '3': '.space.v1.ListExtensionInstallationsResponse'
    },
    {
      '1': 'GetExtensionInstallation',
      '2': '.space.v1.GetExtensionInstallationRequest',
      '3': '.space.v1.GetExtensionInstallationResponse'
    },
    {
      '1': 'ChangeExtensionInstallation',
      '2': '.space.v1.ChangeExtensionInstallationRequest',
      '3': '.space.v1.ChangeExtensionInstallationResponse'
    },
    {
      '1': 'ListExtensionInstallationAudit',
      '2': '.space.v1.ListExtensionInstallationAuditRequest',
      '3': '.space.v1.ListExtensionInstallationAuditResponse'
    },
  ],
};

@$core.Deprecated('Use extensionP1ServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ExtensionP1ServiceBase$messageJson = {
  '.space.v1.QueryExtensionRequest': QueryExtensionRequest$json,
  '.space.v1.QueryExtensionResponse': QueryExtensionResponse$json,
  '.space.v1.ExecuteExtensionCommandRequest':
      ExecuteExtensionCommandRequest$json,
  '.space.v1.ExecuteExtensionCommandResponse':
      ExecuteExtensionCommandResponse$json,
  '.space.v1.ReconcileExtensionCommandRequest':
      ReconcileExtensionCommandRequest$json,
  '.space.v1.ReconcileExtensionCommandResponse':
      ReconcileExtensionCommandResponse$json,
  '.space.v1.GetExtensionMutationContextRequest':
      GetExtensionMutationContextRequest$json,
  '.space.v1.GetExtensionMutationContextResponse':
      GetExtensionMutationContextResponse$json,
  '.space.v1.ListExtensionInstallationsRequest':
      ListExtensionInstallationsRequest$json,
  '.space.v1.ListExtensionInstallationsResponse':
      ListExtensionInstallationsResponse$json,
  '.space.v1.ExtensionInstallation': ExtensionInstallation$json,
  '.space.v1.GetExtensionInstallationRequest':
      GetExtensionInstallationRequest$json,
  '.space.v1.GetExtensionInstallationResponse':
      GetExtensionInstallationResponse$json,
  '.space.v1.ChangeExtensionInstallationRequest':
      ChangeExtensionInstallationRequest$json,
  '.space.v1.ChangeExtensionInstallationResponse':
      ChangeExtensionInstallationResponse$json,
  '.space.v1.ListExtensionInstallationAuditRequest':
      ListExtensionInstallationAuditRequest$json,
  '.space.v1.ListExtensionInstallationAuditResponse':
      ListExtensionInstallationAuditResponse$json,
  '.space.v1.ExtensionInstallationAuditEntry':
      ExtensionInstallationAuditEntry$json,
};

/// Descriptor for `ExtensionP1Service`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List extensionP1ServiceDescriptor = $convert.base64Decode(
    'ChJFeHRlbnNpb25QMVNlcnZpY2USUwoOUXVlcnlFeHRlbnNpb24SHy5zcGFjZS52MS5RdWVyeU'
    'V4dGVuc2lvblJlcXVlc3QaIC5zcGFjZS52MS5RdWVyeUV4dGVuc2lvblJlc3BvbnNlEm4KF0V4'
    'ZWN1dGVFeHRlbnNpb25Db21tYW5kEiguc3BhY2UudjEuRXhlY3V0ZUV4dGVuc2lvbkNvbW1hbm'
    'RSZXF1ZXN0Gikuc3BhY2UudjEuRXhlY3V0ZUV4dGVuc2lvbkNvbW1hbmRSZXNwb25zZRJ0ChlS'
    'ZWNvbmNpbGVFeHRlbnNpb25Db21tYW5kEiouc3BhY2UudjEuUmVjb25jaWxlRXh0ZW5zaW9uQ2'
    '9tbWFuZFJlcXVlc3QaKy5zcGFjZS52MS5SZWNvbmNpbGVFeHRlbnNpb25Db21tYW5kUmVzcG9u'
    'c2USegobR2V0RXh0ZW5zaW9uTXV0YXRpb25Db250ZXh0Eiwuc3BhY2UudjEuR2V0RXh0ZW5zaW'
    '9uTXV0YXRpb25Db250ZXh0UmVxdWVzdBotLnNwYWNlLnYxLkdldEV4dGVuc2lvbk11dGF0aW9u'
    'Q29udGV4dFJlc3BvbnNlEncKGkxpc3RFeHRlbnNpb25JbnN0YWxsYXRpb25zEisuc3BhY2Uudj'
    'EuTGlzdEV4dGVuc2lvbkluc3RhbGxhdGlvbnNSZXF1ZXN0Giwuc3BhY2UudjEuTGlzdEV4dGVu'
    'c2lvbkluc3RhbGxhdGlvbnNSZXNwb25zZRJxChhHZXRFeHRlbnNpb25JbnN0YWxsYXRpb24SKS'
    '5zcGFjZS52MS5HZXRFeHRlbnNpb25JbnN0YWxsYXRpb25SZXF1ZXN0Giouc3BhY2UudjEuR2V0'
    'RXh0ZW5zaW9uSW5zdGFsbGF0aW9uUmVzcG9uc2USegobQ2hhbmdlRXh0ZW5zaW9uSW5zdGFsbG'
    'F0aW9uEiwuc3BhY2UudjEuQ2hhbmdlRXh0ZW5zaW9uSW5zdGFsbGF0aW9uUmVxdWVzdBotLnNw'
    'YWNlLnYxLkNoYW5nZUV4dGVuc2lvbkluc3RhbGxhdGlvblJlc3BvbnNlEoMBCh5MaXN0RXh0ZW'
    '5zaW9uSW5zdGFsbGF0aW9uQXVkaXQSLy5zcGFjZS52MS5MaXN0RXh0ZW5zaW9uSW5zdGFsbGF0'
    'aW9uQXVkaXRSZXF1ZXN0GjAuc3BhY2UudjEuTGlzdEV4dGVuc2lvbkluc3RhbGxhdGlvbkF1ZG'
    'l0UmVzcG9uc2U=');
