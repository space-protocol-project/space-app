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
  ],
};

/// Descriptor for `ExecuteExtensionCommandRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeExtensionCommandRequestDescriptor = $convert.base64Decode(
    'Ch5FeGVjdXRlRXh0ZW5zaW9uQ29tbWFuZFJlcXVlc3QSHwoLaW5zdGFuY2VfaWQYASABKAlSCm'
    'luc3RhbmNlSWQSGAoHY29tbWFuZBgCIAEoCVIHY29tbWFuZBIhCgxwYXlsb2FkX2pzb24YAyAB'
    'KAxSC3BheWxvYWRKc29uEjgKBmVmZmVjdBgEIAEoDjIgLnNwYWNlLnYxLkV4dGVuc2lvbkNvbW'
    '1hbmRFZmZlY3RSBmVmZmVjdBInCg9pZGVtcG90ZW5jeV9rZXkYBSABKAlSDmlkZW1wb3RlbmN5'
    'S2V5EjYKF2V4cGVjdGVkX3N0YXRlX3JldmlzaW9uGAYgASgEUhVleHBlY3RlZFN0YXRlUmV2aX'
    'Npb24=');

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
};

/// Descriptor for `ExtensionP1Service`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List extensionP1ServiceDescriptor = $convert.base64Decode(
    'ChJFeHRlbnNpb25QMVNlcnZpY2USUwoOUXVlcnlFeHRlbnNpb24SHy5zcGFjZS52MS5RdWVyeU'
    'V4dGVuc2lvblJlcXVlc3QaIC5zcGFjZS52MS5RdWVyeUV4dGVuc2lvblJlc3BvbnNlEm4KF0V4'
    'ZWN1dGVFeHRlbnNpb25Db21tYW5kEiguc3BhY2UudjEuRXhlY3V0ZUV4dGVuc2lvbkNvbW1hbm'
    'RSZXF1ZXN0Gikuc3BhY2UudjEuRXhlY3V0ZUV4dGVuc2lvbkNvbW1hbmRSZXNwb25zZQ==');
