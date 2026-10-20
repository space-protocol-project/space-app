// This is a generated file - do not edit.
//
// Generated from space/v1/voice.proto.

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

@$core.Deprecated('Use voiceParticipantDescriptor instead')
const VoiceParticipant$json = {
  '1': 'VoiceParticipant',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'principal_id', '3': 2, '4': 1, '5': 9, '10': 'principalId'},
    {'1': 'device_id', '3': 3, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'nickname', '3': 4, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'muted', '3': 5, '4': 1, '5': 8, '10': 'muted'},
    {'1': 'deafened', '3': 6, '4': 1, '5': 8, '10': 'deafened'},
    {
      '1': 'audio_slot',
      '3': 7,
      '4': 1,
      '5': 13,
      '9': 0,
      '10': 'audioSlot',
      '17': true
    },
  ],
  '8': [
    {'1': '_audio_slot'},
  ],
};

/// Descriptor for `VoiceParticipant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceParticipantDescriptor = $convert.base64Decode(
    'ChBWb2ljZVBhcnRpY2lwYW50Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZBIhCgxwcm'
    'luY2lwYWxfaWQYAiABKAlSC3ByaW5jaXBhbElkEhsKCWRldmljZV9pZBgDIAEoCVIIZGV2aWNl'
    'SWQSGgoIbmlja25hbWUYBCABKAlSCG5pY2tuYW1lEhQKBW11dGVkGAUgASgIUgVtdXRlZBIaCg'
    'hkZWFmZW5lZBgGIAEoCFIIZGVhZmVuZWQSIgoKYXVkaW9fc2xvdBgHIAEoDUgAUglhdWRpb1Ns'
    'b3SIAQFCDQoLX2F1ZGlvX3Nsb3Q=');

@$core.Deprecated('Use voiceRoomStateDescriptor instead')
const VoiceRoomState$json = {
  '1': 'VoiceRoomState',
  '2': [
    {
      '1': 'participants',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.VoiceParticipant',
      '10': 'participants'
    },
    {'1': 'can_publish', '3': 2, '4': 1, '5': 8, '10': 'canPublish'},
    {'1': 'capacity', '3': 3, '4': 1, '5': 5, '10': 'capacity'},
  ],
};

/// Descriptor for `VoiceRoomState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceRoomStateDescriptor = $convert.base64Decode(
    'Cg5Wb2ljZVJvb21TdGF0ZRI+CgxwYXJ0aWNpcGFudHMYASADKAsyGi5zcGFjZS52MS5Wb2ljZV'
    'BhcnRpY2lwYW50UgxwYXJ0aWNpcGFudHMSHwoLY2FuX3B1Ymxpc2gYAiABKAhSCmNhblB1Ymxp'
    'c2gSGgoIY2FwYWNpdHkYAyABKAVSCGNhcGFjaXR5');

@$core.Deprecated('Use joinVoiceRoomRequestDescriptor instead')
const JoinVoiceRoomRequest$json = {
  '1': 'JoinVoiceRoomRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'offer_sdp', '3': 2, '4': 1, '5': 9, '10': 'offerSdp'},
  ],
};

/// Descriptor for `JoinVoiceRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinVoiceRoomRequestDescriptor = $convert.base64Decode(
    'ChRKb2luVm9pY2VSb29tUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUgljaGFubmVsSWQSGw'
    'oJb2ZmZXJfc2RwGAIgASgJUghvZmZlclNkcA==');

@$core.Deprecated('Use joinVoiceRoomResponseDescriptor instead')
const JoinVoiceRoomResponse$json = {
  '1': 'JoinVoiceRoomResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'answer_sdp', '3': 2, '4': 1, '5': 9, '10': 'answerSdp'},
    {
      '1': 'state',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.space.v1.VoiceRoomState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `JoinVoiceRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinVoiceRoomResponseDescriptor = $convert.base64Decode(
    'ChVKb2luVm9pY2VSb29tUmVzcG9uc2USHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEh'
    '0KCmFuc3dlcl9zZHAYAiABKAlSCWFuc3dlclNkcBIuCgVzdGF0ZRgDIAEoCzIYLnNwYWNlLnYx'
    'LlZvaWNlUm9vbVN0YXRlUgVzdGF0ZQ==');

@$core.Deprecated('Use updateVoiceRoomRequestDescriptor instead')
const UpdateVoiceRoomRequest$json = {
  '1': 'UpdateVoiceRoomRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'muted', '3': 3, '4': 1, '5': 8, '10': 'muted'},
    {'1': 'deafened', '3': 4, '4': 1, '5': 8, '10': 'deafened'},
  ],
};

/// Descriptor for `UpdateVoiceRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateVoiceRoomRequestDescriptor = $convert.base64Decode(
    'ChZVcGRhdGVWb2ljZVJvb21SZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW5uZWxJZB'
    'IdCgpzZXNzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQSFAoFbXV0ZWQYAyABKAhSBW11dGVkEhoK'
    'CGRlYWZlbmVkGAQgASgIUghkZWFmZW5lZA==');

@$core.Deprecated('Use updateVoiceRoomResponseDescriptor instead')
const UpdateVoiceRoomResponse$json = {
  '1': 'UpdateVoiceRoomResponse',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.VoiceRoomState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `UpdateVoiceRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateVoiceRoomResponseDescriptor =
    $convert.base64Decode(
        'ChdVcGRhdGVWb2ljZVJvb21SZXNwb25zZRIuCgVzdGF0ZRgBIAEoCzIYLnNwYWNlLnYxLlZvaW'
        'NlUm9vbVN0YXRlUgVzdGF0ZQ==');

@$core.Deprecated('Use leaveVoiceRoomRequestDescriptor instead')
const LeaveVoiceRoomRequest$json = {
  '1': 'LeaveVoiceRoomRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `LeaveVoiceRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveVoiceRoomRequestDescriptor = $convert.base64Decode(
    'ChVMZWF2ZVZvaWNlUm9vbVJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbElkEh'
    '0KCnNlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZA==');

@$core.Deprecated('Use leaveVoiceRoomResponseDescriptor instead')
const LeaveVoiceRoomResponse$json = {
  '1': 'LeaveVoiceRoomResponse',
};

/// Descriptor for `LeaveVoiceRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveVoiceRoomResponseDescriptor =
    $convert.base64Decode('ChZMZWF2ZVZvaWNlUm9vbVJlc3BvbnNl');

@$core.Deprecated('Use getVoiceRoomRequestDescriptor instead')
const GetVoiceRoomRequest$json = {
  '1': 'GetVoiceRoomRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
  ],
};

/// Descriptor for `GetVoiceRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVoiceRoomRequestDescriptor = $convert.base64Decode(
    'ChNHZXRWb2ljZVJvb21SZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW5uZWxJZA==');

@$core.Deprecated('Use getVoiceRoomResponseDescriptor instead')
const GetVoiceRoomResponse$json = {
  '1': 'GetVoiceRoomResponse',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.VoiceRoomState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `GetVoiceRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVoiceRoomResponseDescriptor = $convert.base64Decode(
    'ChRHZXRWb2ljZVJvb21SZXNwb25zZRIuCgVzdGF0ZRgBIAEoCzIYLnNwYWNlLnYxLlZvaWNlUm'
    '9vbVN0YXRlUgVzdGF0ZQ==');

@$core.Deprecated('Use voiceIceServerDescriptor instead')
const VoiceIceServer$json = {
  '1': 'VoiceIceServer',
  '2': [
    {'1': 'urls', '3': 1, '4': 3, '5': 9, '10': 'urls'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'credential', '3': 3, '4': 1, '5': 9, '10': 'credential'},
  ],
};

/// Descriptor for `VoiceIceServer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceIceServerDescriptor = $convert.base64Decode(
    'Cg5Wb2ljZUljZVNlcnZlchISCgR1cmxzGAEgAygJUgR1cmxzEhoKCHVzZXJuYW1lGAIgASgJUg'
    'h1c2VybmFtZRIeCgpjcmVkZW50aWFsGAMgASgJUgpjcmVkZW50aWFs');

@$core.Deprecated('Use getVoiceConfigurationRequestDescriptor instead')
const GetVoiceConfigurationRequest$json = {
  '1': 'GetVoiceConfigurationRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
  ],
};

/// Descriptor for `GetVoiceConfigurationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVoiceConfigurationRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXRWb2ljZUNvbmZpZ3VyYXRpb25SZXF1ZXN0Eh0KCmNoYW5uZWxfaWQYASABKAlSCWNoYW'
        '5uZWxJZA==');

@$core.Deprecated('Use getVoiceConfigurationResponseDescriptor instead')
const GetVoiceConfigurationResponse$json = {
  '1': 'GetVoiceConfigurationResponse',
  '2': [
    {
      '1': 'ice_servers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.VoiceIceServer',
      '10': 'iceServers'
    },
    {'1': 'relay_only', '3': 2, '4': 1, '5': 8, '10': 'relayOnly'},
    {'1': 'expires_at_unix', '3': 3, '4': 1, '5': 3, '10': 'expiresAtUnix'},
  ],
};

/// Descriptor for `GetVoiceConfigurationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVoiceConfigurationResponseDescriptor =
    $convert.base64Decode(
        'Ch1HZXRWb2ljZUNvbmZpZ3VyYXRpb25SZXNwb25zZRI5CgtpY2Vfc2VydmVycxgBIAMoCzIYLn'
        'NwYWNlLnYxLlZvaWNlSWNlU2VydmVyUgppY2VTZXJ2ZXJzEh0KCnJlbGF5X29ubHkYAiABKAhS'
        'CXJlbGF5T25seRImCg9leHBpcmVzX2F0X3VuaXgYAyABKANSDWV4cGlyZXNBdFVuaXg=');

const $core.Map<$core.String, $core.dynamic> VoiceServiceBase$json = {
  '1': 'VoiceService',
  '2': [
    {
      '1': 'GetVoiceConfiguration',
      '2': '.space.v1.GetVoiceConfigurationRequest',
      '3': '.space.v1.GetVoiceConfigurationResponse'
    },
    {
      '1': 'JoinVoiceRoom',
      '2': '.space.v1.JoinVoiceRoomRequest',
      '3': '.space.v1.JoinVoiceRoomResponse'
    },
    {
      '1': 'UpdateVoiceRoom',
      '2': '.space.v1.UpdateVoiceRoomRequest',
      '3': '.space.v1.UpdateVoiceRoomResponse'
    },
    {
      '1': 'LeaveVoiceRoom',
      '2': '.space.v1.LeaveVoiceRoomRequest',
      '3': '.space.v1.LeaveVoiceRoomResponse'
    },
    {
      '1': 'GetVoiceRoom',
      '2': '.space.v1.GetVoiceRoomRequest',
      '3': '.space.v1.GetVoiceRoomResponse'
    },
  ],
};

@$core.Deprecated('Use voiceServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    VoiceServiceBase$messageJson = {
  '.space.v1.GetVoiceConfigurationRequest': GetVoiceConfigurationRequest$json,
  '.space.v1.GetVoiceConfigurationResponse': GetVoiceConfigurationResponse$json,
  '.space.v1.VoiceIceServer': VoiceIceServer$json,
  '.space.v1.JoinVoiceRoomRequest': JoinVoiceRoomRequest$json,
  '.space.v1.JoinVoiceRoomResponse': JoinVoiceRoomResponse$json,
  '.space.v1.VoiceRoomState': VoiceRoomState$json,
  '.space.v1.VoiceParticipant': VoiceParticipant$json,
  '.space.v1.UpdateVoiceRoomRequest': UpdateVoiceRoomRequest$json,
  '.space.v1.UpdateVoiceRoomResponse': UpdateVoiceRoomResponse$json,
  '.space.v1.LeaveVoiceRoomRequest': LeaveVoiceRoomRequest$json,
  '.space.v1.LeaveVoiceRoomResponse': LeaveVoiceRoomResponse$json,
  '.space.v1.GetVoiceRoomRequest': GetVoiceRoomRequest$json,
  '.space.v1.GetVoiceRoomResponse': GetVoiceRoomResponse$json,
};

/// Descriptor for `VoiceService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List voiceServiceDescriptor = $convert.base64Decode(
    'CgxWb2ljZVNlcnZpY2USaAoVR2V0Vm9pY2VDb25maWd1cmF0aW9uEiYuc3BhY2UudjEuR2V0Vm'
    '9pY2VDb25maWd1cmF0aW9uUmVxdWVzdBonLnNwYWNlLnYxLkdldFZvaWNlQ29uZmlndXJhdGlv'
    'blJlc3BvbnNlElAKDUpvaW5Wb2ljZVJvb20SHi5zcGFjZS52MS5Kb2luVm9pY2VSb29tUmVxdW'
    'VzdBofLnNwYWNlLnYxLkpvaW5Wb2ljZVJvb21SZXNwb25zZRJWCg9VcGRhdGVWb2ljZVJvb20S'
    'IC5zcGFjZS52MS5VcGRhdGVWb2ljZVJvb21SZXF1ZXN0GiEuc3BhY2UudjEuVXBkYXRlVm9pY2'
    'VSb29tUmVzcG9uc2USUwoOTGVhdmVWb2ljZVJvb20SHy5zcGFjZS52MS5MZWF2ZVZvaWNlUm9v'
    'bVJlcXVlc3QaIC5zcGFjZS52MS5MZWF2ZVZvaWNlUm9vbVJlc3BvbnNlEk0KDEdldFZvaWNlUm'
    '9vbRIdLnNwYWNlLnYxLkdldFZvaWNlUm9vbVJlcXVlc3QaHi5zcGFjZS52MS5HZXRWb2ljZVJv'
    'b21SZXNwb25zZQ==');
