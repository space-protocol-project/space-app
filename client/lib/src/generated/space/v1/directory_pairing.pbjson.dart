// This is a generated file - do not edit.
//
// Generated from space/v1/directory_pairing.proto.

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

@$core.Deprecated('Use createDirectoryTransferRequestDescriptor instead')
const CreateDirectoryTransferRequest$json = {
  '1': 'CreateDirectoryTransferRequest',
  '2': [
    {'1': 'profile', '3': 1, '4': 1, '5': 9, '10': 'profile'},
  ],
};

/// Descriptor for `CreateDirectoryTransferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createDirectoryTransferRequestDescriptor =
    $convert.base64Decode(
        'Ch5DcmVhdGVEaXJlY3RvcnlUcmFuc2ZlclJlcXVlc3QSGAoHcHJvZmlsZRgBIAEoCVIHcHJvZm'
        'lsZQ==');

@$core.Deprecated('Use createDirectoryTransferResponseDescriptor instead')
const CreateDirectoryTransferResponse$json = {
  '1': 'CreateDirectoryTransferResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'owner_token', '3': 2, '4': 1, '5': 9, '10': 'ownerToken'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'created_at', '3': 4, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'expires_at', '3': 5, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `CreateDirectoryTransferResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createDirectoryTransferResponseDescriptor =
    $convert.base64Decode(
        'Ch9DcmVhdGVEaXJlY3RvcnlUcmFuc2ZlclJlc3BvbnNlEg4KAmlkGAEgASgJUgJpZBIfCgtvd2'
        '5lcl90b2tlbhgCIAEoCVIKb3duZXJUb2tlbhISCgRjb2RlGAMgASgJUgRjb2RlEh0KCmNyZWF0'
        'ZWRfYXQYBCABKANSCWNyZWF0ZWRBdBIdCgpleHBpcmVzX2F0GAUgASgDUglleHBpcmVzQXQ=');

@$core.Deprecated('Use openDirectoryTransferRequestDescriptor instead')
const OpenDirectoryTransferRequest$json = {
  '1': 'OpenDirectoryTransferRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `OpenDirectoryTransferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openDirectoryTransferRequestDescriptor =
    $convert.base64Decode(
        'ChxPcGVuRGlyZWN0b3J5VHJhbnNmZXJSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGU=');

@$core.Deprecated('Use openDirectoryTransferResponseDescriptor instead')
const OpenDirectoryTransferResponse$json = {
  '1': 'OpenDirectoryTransferResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'peer_token', '3': 2, '4': 1, '5': 9, '10': 'peerToken'},
    {'1': 'created_at', '3': 3, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `OpenDirectoryTransferResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openDirectoryTransferResponseDescriptor =
    $convert.base64Decode(
        'Ch1PcGVuRGlyZWN0b3J5VHJhbnNmZXJSZXNwb25zZRIOCgJpZBgBIAEoCVICaWQSHQoKcGVlcl'
        '90b2tlbhgCIAEoCVIJcGVlclRva2VuEh0KCmNyZWF0ZWRfYXQYAyABKANSCWNyZWF0ZWRBdBId'
        'CgpleHBpcmVzX2F0GAQgASgDUglleHBpcmVzQXQ=');

@$core.Deprecated('Use writeDirectoryFrameRequestDescriptor instead')
const WriteDirectoryFrameRequest$json = {
  '1': 'WriteDirectoryFrameRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'sequence', '3': 3, '4': 1, '5': 13, '10': 'sequence'},
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
    {'1': 'final_record', '3': 5, '4': 1, '5': 8, '10': 'finalRecord'},
  ],
};

/// Descriptor for `WriteDirectoryFrameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeDirectoryFrameRequestDescriptor =
    $convert.base64Decode(
        'ChpXcml0ZURpcmVjdG9yeUZyYW1lUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSFAoFdG9rZW4YAi'
        'ABKAlSBXRva2VuEhoKCHNlcXVlbmNlGAMgASgNUghzZXF1ZW5jZRISCgRkYXRhGAQgASgMUgRk'
        'YXRhEiEKDGZpbmFsX3JlY29yZBgFIAEoCFILZmluYWxSZWNvcmQ=');

@$core.Deprecated('Use writeDirectoryFrameResponseDescriptor instead')
const WriteDirectoryFrameResponse$json = {
  '1': 'WriteDirectoryFrameResponse',
};

/// Descriptor for `WriteDirectoryFrameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeDirectoryFrameResponseDescriptor =
    $convert.base64Decode('ChtXcml0ZURpcmVjdG9yeUZyYW1lUmVzcG9uc2U=');

@$core.Deprecated('Use readDirectoryFrameRequestDescriptor instead')
const ReadDirectoryFrameRequest$json = {
  '1': 'ReadDirectoryFrameRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'sequence', '3': 3, '4': 1, '5': 13, '10': 'sequence'},
  ],
};

/// Descriptor for `ReadDirectoryFrameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readDirectoryFrameRequestDescriptor =
    $convert.base64Decode(
        'ChlSZWFkRGlyZWN0b3J5RnJhbWVSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBIUCgV0b2tlbhgCIA'
        'EoCVIFdG9rZW4SGgoIc2VxdWVuY2UYAyABKA1SCHNlcXVlbmNl');

@$core.Deprecated('Use readDirectoryFrameResponseDescriptor instead')
const ReadDirectoryFrameResponse$json = {
  '1': 'ReadDirectoryFrameResponse',
  '2': [
    {'1': 'available', '3': 1, '4': 1, '5': 8, '10': 'available'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    {'1': 'final_record', '3': 3, '4': 1, '5': 8, '10': 'finalRecord'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `ReadDirectoryFrameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readDirectoryFrameResponseDescriptor =
    $convert.base64Decode(
        'ChpSZWFkRGlyZWN0b3J5RnJhbWVSZXNwb25zZRIcCglhdmFpbGFibGUYASABKAhSCWF2YWlsYW'
        'JsZRISCgRkYXRhGAIgASgMUgRkYXRhEiEKDGZpbmFsX3JlY29yZBgDIAEoCFILZmluYWxSZWNv'
        'cmQSHQoKZXhwaXJlc19hdBgEIAEoA1IJZXhwaXJlc0F0');

@$core.Deprecated('Use closeDirectoryTransferRequestDescriptor instead')
const CloseDirectoryTransferRequest$json = {
  '1': 'CloseDirectoryTransferRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `CloseDirectoryTransferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeDirectoryTransferRequestDescriptor =
    $convert.base64Decode(
        'Ch1DbG9zZURpcmVjdG9yeVRyYW5zZmVyUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSFAoFdG9rZW'
        '4YAiABKAlSBXRva2Vu');

@$core.Deprecated('Use closeDirectoryTransferResponseDescriptor instead')
const CloseDirectoryTransferResponse$json = {
  '1': 'CloseDirectoryTransferResponse',
};

/// Descriptor for `CloseDirectoryTransferResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeDirectoryTransferResponseDescriptor =
    $convert.base64Decode('Ch5DbG9zZURpcmVjdG9yeVRyYW5zZmVyUmVzcG9uc2U=');

const $core.Map<$core.String, $core.dynamic> DirectoryPairingServiceBase$json =
    {
  '1': 'DirectoryPairingService',
  '2': [
    {
      '1': 'CreateDirectoryTransfer',
      '2': '.space.v1.CreateDirectoryTransferRequest',
      '3': '.space.v1.CreateDirectoryTransferResponse'
    },
    {
      '1': 'OpenDirectoryTransfer',
      '2': '.space.v1.OpenDirectoryTransferRequest',
      '3': '.space.v1.OpenDirectoryTransferResponse'
    },
    {
      '1': 'WriteDirectoryFrame',
      '2': '.space.v1.WriteDirectoryFrameRequest',
      '3': '.space.v1.WriteDirectoryFrameResponse'
    },
    {
      '1': 'ReadDirectoryFrame',
      '2': '.space.v1.ReadDirectoryFrameRequest',
      '3': '.space.v1.ReadDirectoryFrameResponse'
    },
    {
      '1': 'CloseDirectoryTransfer',
      '2': '.space.v1.CloseDirectoryTransferRequest',
      '3': '.space.v1.CloseDirectoryTransferResponse'
    },
  ],
};

@$core.Deprecated('Use directoryPairingServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DirectoryPairingServiceBase$messageJson = {
  '.space.v1.CreateDirectoryTransferRequest':
      CreateDirectoryTransferRequest$json,
  '.space.v1.CreateDirectoryTransferResponse':
      CreateDirectoryTransferResponse$json,
  '.space.v1.OpenDirectoryTransferRequest': OpenDirectoryTransferRequest$json,
  '.space.v1.OpenDirectoryTransferResponse': OpenDirectoryTransferResponse$json,
  '.space.v1.WriteDirectoryFrameRequest': WriteDirectoryFrameRequest$json,
  '.space.v1.WriteDirectoryFrameResponse': WriteDirectoryFrameResponse$json,
  '.space.v1.ReadDirectoryFrameRequest': ReadDirectoryFrameRequest$json,
  '.space.v1.ReadDirectoryFrameResponse': ReadDirectoryFrameResponse$json,
  '.space.v1.CloseDirectoryTransferRequest': CloseDirectoryTransferRequest$json,
  '.space.v1.CloseDirectoryTransferResponse':
      CloseDirectoryTransferResponse$json,
};

/// Descriptor for `DirectoryPairingService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List directoryPairingServiceDescriptor = $convert.base64Decode(
    'ChdEaXJlY3RvcnlQYWlyaW5nU2VydmljZRJuChdDcmVhdGVEaXJlY3RvcnlUcmFuc2ZlchIoLn'
    'NwYWNlLnYxLkNyZWF0ZURpcmVjdG9yeVRyYW5zZmVyUmVxdWVzdBopLnNwYWNlLnYxLkNyZWF0'
    'ZURpcmVjdG9yeVRyYW5zZmVyUmVzcG9uc2USaAoVT3BlbkRpcmVjdG9yeVRyYW5zZmVyEiYuc3'
    'BhY2UudjEuT3BlbkRpcmVjdG9yeVRyYW5zZmVyUmVxdWVzdBonLnNwYWNlLnYxLk9wZW5EaXJl'
    'Y3RvcnlUcmFuc2ZlclJlc3BvbnNlEmIKE1dyaXRlRGlyZWN0b3J5RnJhbWUSJC5zcGFjZS52MS'
    '5Xcml0ZURpcmVjdG9yeUZyYW1lUmVxdWVzdBolLnNwYWNlLnYxLldyaXRlRGlyZWN0b3J5RnJh'
    'bWVSZXNwb25zZRJfChJSZWFkRGlyZWN0b3J5RnJhbWUSIy5zcGFjZS52MS5SZWFkRGlyZWN0b3'
    'J5RnJhbWVSZXF1ZXN0GiQuc3BhY2UudjEuUmVhZERpcmVjdG9yeUZyYW1lUmVzcG9uc2USawoW'
    'Q2xvc2VEaXJlY3RvcnlUcmFuc2ZlchInLnNwYWNlLnYxLkNsb3NlRGlyZWN0b3J5VHJhbnNmZX'
    'JSZXF1ZXN0Giguc3BhY2UudjEuQ2xvc2VEaXJlY3RvcnlUcmFuc2ZlclJlc3BvbnNl');
