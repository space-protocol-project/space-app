// This is a generated file - do not edit.
//
// Generated from space/v1/remote_backup.proto.

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

@$core.Deprecated('Use backupHeadDescriptor instead')
const BackupHead$json = {
  '1': 'BackupHead',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'revision', '3': 2, '4': 1, '5': 3, '10': 'revision'},
    {'1': 'digest', '3': 3, '4': 1, '5': 9, '10': 'digest'},
    {'1': 'parent', '3': 4, '4': 1, '5': 9, '10': 'parent'},
    {'1': 'archive_digest', '3': 5, '4': 1, '5': 9, '10': 'archiveDigest'},
  ],
};

/// Descriptor for `BackupHead`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backupHeadDescriptor = $convert.base64Decode(
    'CgpCYWNrdXBIZWFkEg4KAmlkGAEgASgJUgJpZBIaCghyZXZpc2lvbhgCIAEoA1IIcmV2aXNpb2'
    '4SFgoGZGlnZXN0GAMgASgJUgZkaWdlc3QSFgoGcGFyZW50GAQgASgJUgZwYXJlbnQSJQoOYXJj'
    'aGl2ZV9kaWdlc3QYBSABKAlSDWFyY2hpdmVEaWdlc3Q=');

@$core.Deprecated('Use createBackupSlotResponseDescriptor instead')
const CreateBackupSlotResponse$json = {
  '1': 'CreateBackupSlotResponse',
  '2': [
    {
      '1': 'head',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.BackupHead',
      '10': 'head'
    },
  ],
};

/// Descriptor for `CreateBackupSlotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createBackupSlotResponseDescriptor =
    $convert.base64Decode(
        'ChhDcmVhdGVCYWNrdXBTbG90UmVzcG9uc2USKAoEaGVhZBgBIAEoCzIULnNwYWNlLnYxLkJhY2'
        't1cEhlYWRSBGhlYWQ=');

@$core.Deprecated('Use revokeBackupSlotRequestDescriptor instead')
const RevokeBackupSlotRequest$json = {
  '1': 'RevokeBackupSlotRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `RevokeBackupSlotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeBackupSlotRequestDescriptor = $convert
    .base64Decode('ChdSZXZva2VCYWNrdXBTbG90UmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use revokeBackupSlotResponseDescriptor instead')
const RevokeBackupSlotResponse$json = {
  '1': 'RevokeBackupSlotResponse',
};

/// Descriptor for `RevokeBackupSlotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeBackupSlotResponseDescriptor =
    $convert.base64Decode('ChhSZXZva2VCYWNrdXBTbG90UmVzcG9uc2U=');

@$core.Deprecated('Use putBackupResponseDescriptor instead')
const PutBackupResponse$json = {
  '1': 'PutBackupResponse',
  '2': [
    {
      '1': 'head',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.BackupHead',
      '10': 'head'
    },
  ],
};

/// Descriptor for `PutBackupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List putBackupResponseDescriptor = $convert.base64Decode(
    'ChFQdXRCYWNrdXBSZXNwb25zZRIoCgRoZWFkGAEgASgLMhQuc3BhY2UudjEuQmFja3VwSGVhZF'
    'IEaGVhZA==');

@$core.Deprecated('Use advanceBackupWitnessResponseDescriptor instead')
const AdvanceBackupWitnessResponse$json = {
  '1': 'AdvanceBackupWitnessResponse',
  '2': [
    {
      '1': 'head',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.BackupHead',
      '10': 'head'
    },
  ],
};

/// Descriptor for `AdvanceBackupWitnessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceBackupWitnessResponseDescriptor =
    $convert.base64Decode(
        'ChxBZHZhbmNlQmFja3VwV2l0bmVzc1Jlc3BvbnNlEigKBGhlYWQYASABKAsyFC5zcGFjZS52MS'
        '5CYWNrdXBIZWFkUgRoZWFk');

@$core.Deprecated('Use createBackupSlotRequestDescriptor instead')
const CreateBackupSlotRequest$json = {
  '1': 'CreateBackupSlotRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'read_hash', '3': 2, '4': 1, '5': 12, '10': 'readHash'},
    {'1': 'write_hash', '3': 3, '4': 1, '5': 12, '10': 'writeHash'},
    {'1': 'witness', '3': 4, '4': 1, '5': 8, '10': 'witness'},
  ],
};

/// Descriptor for `CreateBackupSlotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createBackupSlotRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVCYWNrdXBTbG90UmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSGwoJcmVhZF9oYXNoGA'
    'IgASgMUghyZWFkSGFzaBIdCgp3cml0ZV9oYXNoGAMgASgMUgl3cml0ZUhhc2gSGAoHd2l0bmVz'
    'cxgEIAEoCFIHd2l0bmVzcw==');

@$core.Deprecated('Use putBackupRequestDescriptor instead')
const PutBackupRequest$json = {
  '1': 'PutBackupRequest',
  '2': [
    {
      '1': 'head',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.BackupHead',
      '10': 'head'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'archive', '3': 3, '4': 1, '5': 12, '10': 'archive'},
  ],
};

/// Descriptor for `PutBackupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List putBackupRequestDescriptor = $convert.base64Decode(
    'ChBQdXRCYWNrdXBSZXF1ZXN0EigKBGhlYWQYASABKAsyFC5zcGFjZS52MS5CYWNrdXBIZWFkUg'
    'RoZWFkEhQKBXRva2VuGAIgASgJUgV0b2tlbhIYCgdhcmNoaXZlGAMgASgMUgdhcmNoaXZl');

@$core.Deprecated('Use getBackupRequestDescriptor instead')
const GetBackupRequest$json = {
  '1': 'GetBackupRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'revision', '3': 3, '4': 1, '5': 3, '10': 'revision'},
  ],
};

/// Descriptor for `GetBackupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBackupRequestDescriptor = $convert.base64Decode(
    'ChBHZXRCYWNrdXBSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBIUCgV0b2tlbhgCIAEoCVIFdG9rZW'
    '4SGgoIcmV2aXNpb24YAyABKANSCHJldmlzaW9u');

@$core.Deprecated('Use getBackupResponseDescriptor instead')
const GetBackupResponse$json = {
  '1': 'GetBackupResponse',
  '2': [
    {
      '1': 'head',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.BackupHead',
      '10': 'head'
    },
    {'1': 'archive', '3': 2, '4': 1, '5': 12, '10': 'archive'},
  ],
};

/// Descriptor for `GetBackupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBackupResponseDescriptor = $convert.base64Decode(
    'ChFHZXRCYWNrdXBSZXNwb25zZRIoCgRoZWFkGAEgASgLMhQuc3BhY2UudjEuQmFja3VwSGVhZF'
    'IEaGVhZBIYCgdhcmNoaXZlGAIgASgMUgdhcmNoaXZl');

@$core.Deprecated('Use advanceBackupWitnessRequestDescriptor instead')
const AdvanceBackupWitnessRequest$json = {
  '1': 'AdvanceBackupWitnessRequest',
  '2': [
    {
      '1': 'head',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.BackupHead',
      '10': 'head'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `AdvanceBackupWitnessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceBackupWitnessRequestDescriptor =
    $convert.base64Decode(
        'ChtBZHZhbmNlQmFja3VwV2l0bmVzc1JlcXVlc3QSKAoEaGVhZBgBIAEoCzIULnNwYWNlLnYxLk'
        'JhY2t1cEhlYWRSBGhlYWQSFAoFdG9rZW4YAiABKAlSBXRva2Vu');

@$core.Deprecated('Use readBackupWitnessRequestDescriptor instead')
const ReadBackupWitnessRequest$json = {
  '1': 'ReadBackupWitnessRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'challenge', '3': 3, '4': 1, '5': 9, '10': 'challenge'},
  ],
};

/// Descriptor for `ReadBackupWitnessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readBackupWitnessRequestDescriptor =
    $convert.base64Decode(
        'ChhSZWFkQmFja3VwV2l0bmVzc1JlcXVlc3QSDgoCaWQYASABKAlSAmlkEhQKBXRva2VuGAIgAS'
        'gJUgV0b2tlbhIcCgljaGFsbGVuZ2UYAyABKAlSCWNoYWxsZW5nZQ==');

@$core.Deprecated('Use readBackupWitnessResponseDescriptor instead')
const ReadBackupWitnessResponse$json = {
  '1': 'ReadBackupWitnessResponse',
  '2': [
    {
      '1': 'head',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.BackupHead',
      '10': 'head'
    },
    {'1': 'challenge', '3': 2, '4': 1, '5': 9, '10': 'challenge'},
    {'1': 'signature', '3': 3, '4': 1, '5': 12, '10': 'signature'},
  ],
};

/// Descriptor for `ReadBackupWitnessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readBackupWitnessResponseDescriptor = $convert.base64Decode(
    'ChlSZWFkQmFja3VwV2l0bmVzc1Jlc3BvbnNlEigKBGhlYWQYASABKAsyFC5zcGFjZS52MS5CYW'
    'NrdXBIZWFkUgRoZWFkEhwKCWNoYWxsZW5nZRgCIAEoCVIJY2hhbGxlbmdlEhwKCXNpZ25hdHVy'
    'ZRgDIAEoDFIJc2lnbmF0dXJl');

const $core.Map<$core.String, $core.dynamic> RemoteBackupServiceBase$json = {
  '1': 'RemoteBackupService',
  '2': [
    {
      '1': 'CreateBackupSlot',
      '2': '.space.v1.CreateBackupSlotRequest',
      '3': '.space.v1.CreateBackupSlotResponse'
    },
    {
      '1': 'RevokeBackupSlot',
      '2': '.space.v1.RevokeBackupSlotRequest',
      '3': '.space.v1.RevokeBackupSlotResponse'
    },
    {
      '1': 'PutBackup',
      '2': '.space.v1.PutBackupRequest',
      '3': '.space.v1.PutBackupResponse'
    },
    {
      '1': 'GetBackup',
      '2': '.space.v1.GetBackupRequest',
      '3': '.space.v1.GetBackupResponse'
    },
    {
      '1': 'AdvanceBackupWitness',
      '2': '.space.v1.AdvanceBackupWitnessRequest',
      '3': '.space.v1.AdvanceBackupWitnessResponse'
    },
    {
      '1': 'ReadBackupWitness',
      '2': '.space.v1.ReadBackupWitnessRequest',
      '3': '.space.v1.ReadBackupWitnessResponse'
    },
  ],
};

@$core.Deprecated('Use remoteBackupServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    RemoteBackupServiceBase$messageJson = {
  '.space.v1.CreateBackupSlotRequest': CreateBackupSlotRequest$json,
  '.space.v1.CreateBackupSlotResponse': CreateBackupSlotResponse$json,
  '.space.v1.BackupHead': BackupHead$json,
  '.space.v1.RevokeBackupSlotRequest': RevokeBackupSlotRequest$json,
  '.space.v1.RevokeBackupSlotResponse': RevokeBackupSlotResponse$json,
  '.space.v1.PutBackupRequest': PutBackupRequest$json,
  '.space.v1.PutBackupResponse': PutBackupResponse$json,
  '.space.v1.GetBackupRequest': GetBackupRequest$json,
  '.space.v1.GetBackupResponse': GetBackupResponse$json,
  '.space.v1.AdvanceBackupWitnessRequest': AdvanceBackupWitnessRequest$json,
  '.space.v1.AdvanceBackupWitnessResponse': AdvanceBackupWitnessResponse$json,
  '.space.v1.ReadBackupWitnessRequest': ReadBackupWitnessRequest$json,
  '.space.v1.ReadBackupWitnessResponse': ReadBackupWitnessResponse$json,
};

/// Descriptor for `RemoteBackupService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List remoteBackupServiceDescriptor = $convert.base64Decode(
    'ChNSZW1vdGVCYWNrdXBTZXJ2aWNlElkKEENyZWF0ZUJhY2t1cFNsb3QSIS5zcGFjZS52MS5Dcm'
    'VhdGVCYWNrdXBTbG90UmVxdWVzdBoiLnNwYWNlLnYxLkNyZWF0ZUJhY2t1cFNsb3RSZXNwb25z'
    'ZRJZChBSZXZva2VCYWNrdXBTbG90EiEuc3BhY2UudjEuUmV2b2tlQmFja3VwU2xvdFJlcXVlc3'
    'QaIi5zcGFjZS52MS5SZXZva2VCYWNrdXBTbG90UmVzcG9uc2USRAoJUHV0QmFja3VwEhouc3Bh'
    'Y2UudjEuUHV0QmFja3VwUmVxdWVzdBobLnNwYWNlLnYxLlB1dEJhY2t1cFJlc3BvbnNlEkQKCU'
    'dldEJhY2t1cBIaLnNwYWNlLnYxLkdldEJhY2t1cFJlcXVlc3QaGy5zcGFjZS52MS5HZXRCYWNr'
    'dXBSZXNwb25zZRJlChRBZHZhbmNlQmFja3VwV2l0bmVzcxIlLnNwYWNlLnYxLkFkdmFuY2VCYW'
    'NrdXBXaXRuZXNzUmVxdWVzdBomLnNwYWNlLnYxLkFkdmFuY2VCYWNrdXBXaXRuZXNzUmVzcG9u'
    'c2USXAoRUmVhZEJhY2t1cFdpdG5lc3MSIi5zcGFjZS52MS5SZWFkQmFja3VwV2l0bmVzc1JlcX'
    'Vlc3QaIy5zcGFjZS52MS5SZWFkQmFja3VwV2l0bmVzc1Jlc3BvbnNl');
