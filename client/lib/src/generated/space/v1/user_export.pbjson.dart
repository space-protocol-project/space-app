// This is a generated file - do not edit.
//
// Generated from space/v1/user_export.proto.

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

@$core.Deprecated('Use exportUserContentRequestDescriptor instead')
const ExportUserContentRequest$json = {
  '1': 'ExportUserContentRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {
      '1': 'created_after_unix_ms',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'createdAfterUnixMs'
    },
    {
      '1': 'created_before_unix_ms',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'createdBeforeUnixMs'
    },
  ],
};

/// Descriptor for `ExportUserContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportUserContentRequestDescriptor = $convert.base64Decode(
    'ChhFeHBvcnRVc2VyQ29udGVudFJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIAEoCVIJY2hhbm5lbE'
    'lkEjEKFWNyZWF0ZWRfYWZ0ZXJfdW5peF9tcxgCIAEoA1ISY3JlYXRlZEFmdGVyVW5peE1zEjMK'
    'FmNyZWF0ZWRfYmVmb3JlX3VuaXhfbXMYAyABKANSE2NyZWF0ZWRCZWZvcmVVbml4TXM=');

@$core.Deprecated('Use userExportAttachmentDescriptor instead')
const UserExportAttachment$json = {
  '1': 'UserExportAttachment',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'mime_type', '3': 3, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'byte_size', '3': 4, '4': 1, '5': 3, '10': 'byteSize'},
    {'1': 'sha256', '3': 5, '4': 1, '5': 12, '10': 'sha256'},
  ],
};

/// Descriptor for `UserExportAttachment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userExportAttachmentDescriptor = $convert.base64Decode(
    'ChRVc2VyRXhwb3J0QXR0YWNobWVudBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbm'
    'FtZRIbCgltaW1lX3R5cGUYAyABKAlSCG1pbWVUeXBlEhsKCWJ5dGVfc2l6ZRgEIAEoA1IIYnl0'
    'ZVNpemUSFgoGc2hhMjU2GAUgASgMUgZzaGEyNTY=');

@$core.Deprecated('Use userExportEntryDescriptor instead')
const UserExportEntry$json = {
  '1': 'UserExportEntry',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.space.v1.SpaceSearchKind',
      '10': 'kind'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {'1': 'channel_id', '3': 3, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'channel_title', '3': 4, '4': 1, '5': 9, '10': 'channelTitle'},
    {'1': 'parent_id', '3': 5, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'text', '3': 7, '4': 1, '5': 9, '10': 'text'},
    {
      '1': 'created_at_unix_ms',
      '3': 8,
      '4': 1,
      '5': 3,
      '10': 'createdAtUnixMs'
    },
    {'1': 'revision', '3': 9, '4': 1, '5': 3, '10': 'revision'},
    {
      '1': 'attachments',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.space.v1.UserExportAttachment',
      '10': 'attachments'
    },
    {'1': 'repost_of', '3': 11, '4': 1, '5': 9, '10': 'repostOf'},
  ],
};

/// Descriptor for `UserExportEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userExportEntryDescriptor = $convert.base64Decode(
    'Cg9Vc2VyRXhwb3J0RW50cnkSLQoEa2luZBgBIAEoDjIZLnNwYWNlLnYxLlNwYWNlU2VhcmNoS2'
    'luZFIEa2luZBIOCgJpZBgCIAEoCVICaWQSHQoKY2hhbm5lbF9pZBgDIAEoCVIJY2hhbm5lbElk'
    'EiMKDWNoYW5uZWxfdGl0bGUYBCABKAlSDGNoYW5uZWxUaXRsZRIbCglwYXJlbnRfaWQYBSABKA'
    'lSCHBhcmVudElkEhQKBXRpdGxlGAYgASgJUgV0aXRsZRISCgR0ZXh0GAcgASgJUgR0ZXh0EisK'
    'EmNyZWF0ZWRfYXRfdW5peF9tcxgIIAEoA1IPY3JlYXRlZEF0VW5peE1zEhoKCHJldmlzaW9uGA'
    'kgASgDUghyZXZpc2lvbhJACgthdHRhY2htZW50cxgKIAMoCzIeLnNwYWNlLnYxLlVzZXJFeHBv'
    'cnRBdHRhY2htZW50UgthdHRhY2htZW50cxIbCglyZXBvc3Rfb2YYCyABKAlSCHJlcG9zdE9m');

@$core.Deprecated('Use exportUserContentResponseDescriptor instead')
const ExportUserContentResponse$json = {
  '1': 'ExportUserContentResponse',
  '2': [
    {'1': 'format_version', '3': 1, '4': 1, '5': 13, '10': 'formatVersion'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'principal_id', '3': 3, '4': 1, '5': 9, '10': 'principalId'},
    {
      '1': 'generated_at_unix_ms',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'generatedAtUnixMs'
    },
    {
      '1': 'entries',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.space.v1.UserExportEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `ExportUserContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportUserContentResponseDescriptor = $convert.base64Decode(
    'ChlFeHBvcnRVc2VyQ29udGVudFJlc3BvbnNlEiUKDmZvcm1hdF92ZXJzaW9uGAEgASgNUg1mb3'
    'JtYXRWZXJzaW9uEhsKCXNlcnZlcl9pZBgCIAEoCVIIc2VydmVySWQSIQoMcHJpbmNpcGFsX2lk'
    'GAMgASgJUgtwcmluY2lwYWxJZBIvChRnZW5lcmF0ZWRfYXRfdW5peF9tcxgEIAEoA1IRZ2VuZX'
    'JhdGVkQXRVbml4TXMSMwoHZW50cmllcxgFIAMoCzIZLnNwYWNlLnYxLlVzZXJFeHBvcnRFbnRy'
    'eVIHZW50cmllcw==');

const $core.Map<$core.String, $core.dynamic> UserExportServiceBase$json = {
  '1': 'UserExportService',
  '2': [
    {
      '1': 'ExportUserContent',
      '2': '.space.v1.ExportUserContentRequest',
      '3': '.space.v1.ExportUserContentResponse'
    },
  ],
};

@$core.Deprecated('Use userExportServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    UserExportServiceBase$messageJson = {
  '.space.v1.ExportUserContentRequest': ExportUserContentRequest$json,
  '.space.v1.ExportUserContentResponse': ExportUserContentResponse$json,
  '.space.v1.UserExportEntry': UserExportEntry$json,
  '.space.v1.UserExportAttachment': UserExportAttachment$json,
};

/// Descriptor for `UserExportService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List userExportServiceDescriptor = $convert.base64Decode(
    'ChFVc2VyRXhwb3J0U2VydmljZRJcChFFeHBvcnRVc2VyQ29udGVudBIiLnNwYWNlLnYxLkV4cG'
    '9ydFVzZXJDb250ZW50UmVxdWVzdBojLnNwYWNlLnYxLkV4cG9ydFVzZXJDb250ZW50UmVzcG9u'
    'c2U=');
