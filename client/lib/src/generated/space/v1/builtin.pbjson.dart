// This is a generated file - do not edit.
//
// Generated from space/v1/builtin.proto.

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

import 'package:protobuf/well_known_types/google/protobuf/any.pbjson.dart'
    as $1;

import 'space.pbjson.dart' as $0;

@$core.Deprecated('Use builtinSectionDescriptor instead')
const BuiltinSection$json = {
  '1': 'BuiltinSection',
  '2': [
    {'1': 'instance_id', '3': 1, '4': 1, '5': 9, '10': 'instanceId'},
    {'1': 'installation_id', '3': 2, '4': 1, '5': 9, '10': 'installationId'},
    {'1': 'plugin_id', '3': 3, '4': 1, '5': 9, '10': 'pluginId'},
    {'1': 'version', '3': 4, '4': 1, '5': 9, '10': 'version'},
    {'1': 'view_id', '3': 5, '4': 1, '5': 9, '10': 'viewId'},
    {
      '1': 'channel',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.space.v1.Channel',
      '10': 'channel'
    },
  ],
};

/// Descriptor for `BuiltinSection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List builtinSectionDescriptor = $convert.base64Decode(
    'Cg5CdWlsdGluU2VjdGlvbhIfCgtpbnN0YW5jZV9pZBgBIAEoCVIKaW5zdGFuY2VJZBInCg9pbn'
    'N0YWxsYXRpb25faWQYAiABKAlSDmluc3RhbGxhdGlvbklkEhsKCXBsdWdpbl9pZBgDIAEoCVII'
    'cGx1Z2luSWQSGAoHdmVyc2lvbhgEIAEoCVIHdmVyc2lvbhIXCgd2aWV3X2lkGAUgASgJUgZ2aW'
    'V3SWQSKwoHY2hhbm5lbBgGIAEoCzIRLnNwYWNlLnYxLkNoYW5uZWxSB2NoYW5uZWw=');

@$core.Deprecated('Use listBuiltinSectionsRequestDescriptor instead')
const ListBuiltinSectionsRequest$json = {
  '1': 'ListBuiltinSectionsRequest',
};

/// Descriptor for `ListBuiltinSectionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBuiltinSectionsRequestDescriptor =
    $convert.base64Decode('ChpMaXN0QnVpbHRpblNlY3Rpb25zUmVxdWVzdA==');

@$core.Deprecated('Use listBuiltinSectionsResponseDescriptor instead')
const ListBuiltinSectionsResponse$json = {
  '1': 'ListBuiltinSectionsResponse',
  '2': [
    {
      '1': 'sections',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.BuiltinSection',
      '10': 'sections'
    },
  ],
};

/// Descriptor for `ListBuiltinSectionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBuiltinSectionsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0QnVpbHRpblNlY3Rpb25zUmVzcG9uc2USNAoIc2VjdGlvbnMYASADKAsyGC5zcGFjZS'
        '52MS5CdWlsdGluU2VjdGlvblIIc2VjdGlvbnM=');

@$core.Deprecated('Use openBuiltinSectionRequestDescriptor instead')
const OpenBuiltinSectionRequest$json = {
  '1': 'OpenBuiltinSectionRequest',
  '2': [
    {'1': 'instance_id', '3': 1, '4': 1, '5': 9, '10': 'instanceId'},
  ],
};

/// Descriptor for `OpenBuiltinSectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openBuiltinSectionRequestDescriptor =
    $convert.base64Decode(
        'ChlPcGVuQnVpbHRpblNlY3Rpb25SZXF1ZXN0Eh8KC2luc3RhbmNlX2lkGAEgASgJUgppbnN0YW'
        '5jZUlk');

@$core.Deprecated('Use openBuiltinSectionResponseDescriptor instead')
const OpenBuiltinSectionResponse$json = {
  '1': 'OpenBuiltinSectionResponse',
  '2': [
    {
      '1': 'section',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.space.v1.BuiltinSection',
      '10': 'section'
    },
    {
      '1': 'content',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'content'
    },
  ],
};

/// Descriptor for `OpenBuiltinSectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openBuiltinSectionResponseDescriptor =
    $convert.base64Decode(
        'ChpPcGVuQnVpbHRpblNlY3Rpb25SZXNwb25zZRIyCgdzZWN0aW9uGAEgASgLMhguc3BhY2Uudj'
        'EuQnVpbHRpblNlY3Rpb25SB3NlY3Rpb24SLgoHY29udGVudBgCIAEoCzIULmdvb2dsZS5wcm90'
        'b2J1Zi5BbnlSB2NvbnRlbnQ=');

@$core.Deprecated('Use executeBuiltinCommandRequestDescriptor instead')
const ExecuteBuiltinCommandRequest$json = {
  '1': 'ExecuteBuiltinCommandRequest',
  '2': [
    {'1': 'instance_id', '3': 1, '4': 1, '5': 9, '10': 'instanceId'},
    {
      '1': 'command',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'command'
    },
  ],
};

/// Descriptor for `ExecuteBuiltinCommandRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeBuiltinCommandRequestDescriptor =
    $convert.base64Decode(
        'ChxFeGVjdXRlQnVpbHRpbkNvbW1hbmRSZXF1ZXN0Eh8KC2luc3RhbmNlX2lkGAEgASgJUgppbn'
        'N0YW5jZUlkEi4KB2NvbW1hbmQYAiABKAsyFC5nb29nbGUucHJvdG9idWYuQW55Ugdjb21tYW5k');

@$core.Deprecated('Use executeBuiltinCommandResponseDescriptor instead')
const ExecuteBuiltinCommandResponse$json = {
  '1': 'ExecuteBuiltinCommandResponse',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'result'
    },
  ],
};

/// Descriptor for `ExecuteBuiltinCommandResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeBuiltinCommandResponseDescriptor =
    $convert.base64Decode(
        'Ch1FeGVjdXRlQnVpbHRpbkNvbW1hbmRSZXNwb25zZRIsCgZyZXN1bHQYASABKAsyFC5nb29nbG'
        'UucHJvdG9idWYuQW55UgZyZXN1bHQ=');

const $core.Map<$core.String, $core.dynamic> BuiltinExtensionServiceBase$json =
    {
  '1': 'BuiltinExtensionService',
  '2': [
    {
      '1': 'ListBuiltinSections',
      '2': '.space.v1.ListBuiltinSectionsRequest',
      '3': '.space.v1.ListBuiltinSectionsResponse'
    },
    {
      '1': 'OpenBuiltinSection',
      '2': '.space.v1.OpenBuiltinSectionRequest',
      '3': '.space.v1.OpenBuiltinSectionResponse'
    },
    {
      '1': 'ExecuteBuiltinCommand',
      '2': '.space.v1.ExecuteBuiltinCommandRequest',
      '3': '.space.v1.ExecuteBuiltinCommandResponse'
    },
  ],
};

@$core.Deprecated('Use builtinExtensionServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    BuiltinExtensionServiceBase$messageJson = {
  '.space.v1.ListBuiltinSectionsRequest': ListBuiltinSectionsRequest$json,
  '.space.v1.ListBuiltinSectionsResponse': ListBuiltinSectionsResponse$json,
  '.space.v1.BuiltinSection': BuiltinSection$json,
  '.space.v1.Channel': $0.Channel$json,
  '.space.v1.View': $0.View$json,
  '.space.v1.ChannelPermissions': $0.ChannelPermissions$json,
  '.space.v1.OpenBuiltinSectionRequest': OpenBuiltinSectionRequest$json,
  '.space.v1.OpenBuiltinSectionResponse': OpenBuiltinSectionResponse$json,
  '.google.protobuf.Any': $1.Any$json,
  '.space.v1.ExecuteBuiltinCommandRequest': ExecuteBuiltinCommandRequest$json,
  '.space.v1.ExecuteBuiltinCommandResponse': ExecuteBuiltinCommandResponse$json,
};

/// Descriptor for `BuiltinExtensionService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List builtinExtensionServiceDescriptor = $convert.base64Decode(
    'ChdCdWlsdGluRXh0ZW5zaW9uU2VydmljZRJiChNMaXN0QnVpbHRpblNlY3Rpb25zEiQuc3BhY2'
    'UudjEuTGlzdEJ1aWx0aW5TZWN0aW9uc1JlcXVlc3QaJS5zcGFjZS52MS5MaXN0QnVpbHRpblNl'
    'Y3Rpb25zUmVzcG9uc2USXwoST3BlbkJ1aWx0aW5TZWN0aW9uEiMuc3BhY2UudjEuT3BlbkJ1aW'
    'x0aW5TZWN0aW9uUmVxdWVzdBokLnNwYWNlLnYxLk9wZW5CdWlsdGluU2VjdGlvblJlc3BvbnNl'
    'EmgKFUV4ZWN1dGVCdWlsdGluQ29tbWFuZBImLnNwYWNlLnYxLkV4ZWN1dGVCdWlsdGluQ29tbW'
    'FuZFJlcXVlc3QaJy5zcGFjZS52MS5FeGVjdXRlQnVpbHRpbkNvbW1hbmRSZXNwb25zZQ==');
