// This is a generated file - do not edit.
//
// Generated from space/v1/personal_notifications.proto.

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

@$core.Deprecated('Use notificationTargetKindDescriptor instead')
const NotificationTargetKind$json = {
  '1': 'NotificationTargetKind',
  '2': [
    {'1': 'NOTIFICATION_TARGET_KIND_UNSPECIFIED', '2': 0},
    {'1': 'NOTIFICATION_TARGET_KIND_FORUM_THREAD', '2': 1},
    {'1': 'NOTIFICATION_TARGET_KIND_FORUM_REPLY', '2': 2},
    {'1': 'NOTIFICATION_TARGET_KIND_FEED_POST', '2': 3},
    {'1': 'NOTIFICATION_TARGET_KIND_FEED_COMMENT', '2': 4},
    {'1': 'NOTIFICATION_TARGET_KIND_CHAT_MESSAGE', '2': 5},
  ],
};

/// Descriptor for `NotificationTargetKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List notificationTargetKindDescriptor = $convert.base64Decode(
    'ChZOb3RpZmljYXRpb25UYXJnZXRLaW5kEigKJE5PVElGSUNBVElPTl9UQVJHRVRfS0lORF9VTl'
    'NQRUNJRklFRBAAEikKJU5PVElGSUNBVElPTl9UQVJHRVRfS0lORF9GT1JVTV9USFJFQUQQARIo'
    'CiROT1RJRklDQVRJT05fVEFSR0VUX0tJTkRfRk9SVU1fUkVQTFkQAhImCiJOT1RJRklDQVRJT0'
    '5fVEFSR0VUX0tJTkRfRkVFRF9QT1NUEAMSKQolTk9USUZJQ0FUSU9OX1RBUkdFVF9LSU5EX0ZF'
    'RURfQ09NTUVOVBAEEikKJU5PVElGSUNBVElPTl9UQVJHRVRfS0lORF9DSEFUX01FU1NBR0UQBQ'
    '==');

@$core.Deprecated('Use personalNotificationDescriptor instead')
const PersonalNotification$json = {
  '1': 'PersonalNotification',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'sequence', '3': 2, '4': 1, '5': 3, '10': 'sequence'},
    {'1': 'channel_id', '3': 3, '4': 1, '5': 9, '10': 'channelId'},
    {
      '1': 'target_kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.space.v1.NotificationTargetKind',
      '10': 'targetKind'
    },
    {'1': 'content_id', '3': 5, '4': 1, '5': 9, '10': 'contentId'},
    {'1': 'parent_id', '3': 6, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'target_sequence', '3': 7, '4': 1, '5': 3, '10': 'targetSequence'},
    {'1': 'author_id', '3': 8, '4': 1, '5': 9, '10': 'authorId'},
    {'1': 'author_name', '3': 9, '4': 1, '5': 9, '10': 'authorName'},
    {'1': 'title', '3': 10, '4': 1, '5': 9, '10': 'title'},
    {'1': 'snippet', '3': 11, '4': 1, '5': 9, '10': 'snippet'},
    {'1': 'reasons', '3': 12, '4': 1, '5': 5, '10': 'reasons'},
    {'1': 'unread_reasons', '3': 13, '4': 1, '5': 5, '10': 'unreadReasons'},
    {'1': 'created_at_unix', '3': 14, '4': 1, '5': 3, '10': 'createdAtUnix'},
  ],
};

/// Descriptor for `PersonalNotification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List personalNotificationDescriptor = $convert.base64Decode(
    'ChRQZXJzb25hbE5vdGlmaWNhdGlvbhIOCgJpZBgBIAEoCVICaWQSGgoIc2VxdWVuY2UYAiABKA'
    'NSCHNlcXVlbmNlEh0KCmNoYW5uZWxfaWQYAyABKAlSCWNoYW5uZWxJZBJBCgt0YXJnZXRfa2lu'
    'ZBgEIAEoDjIgLnNwYWNlLnYxLk5vdGlmaWNhdGlvblRhcmdldEtpbmRSCnRhcmdldEtpbmQSHQ'
    'oKY29udGVudF9pZBgFIAEoCVIJY29udGVudElkEhsKCXBhcmVudF9pZBgGIAEoCVIIcGFyZW50'
    'SWQSJwoPdGFyZ2V0X3NlcXVlbmNlGAcgASgDUg50YXJnZXRTZXF1ZW5jZRIbCglhdXRob3JfaW'
    'QYCCABKAlSCGF1dGhvcklkEh8KC2F1dGhvcl9uYW1lGAkgASgJUgphdXRob3JOYW1lEhQKBXRp'
    'dGxlGAogASgJUgV0aXRsZRIYCgdzbmlwcGV0GAsgASgJUgdzbmlwcGV0EhgKB3JlYXNvbnMYDC'
    'ABKAVSB3JlYXNvbnMSJQoOdW5yZWFkX3JlYXNvbnMYDSABKAVSDXVucmVhZFJlYXNvbnMSJgoP'
    'Y3JlYXRlZF9hdF91bml4GA4gASgDUg1jcmVhdGVkQXRVbml4');

@$core.Deprecated('Use listPersonalNotificationsRequestDescriptor instead')
const ListPersonalNotificationsRequest$json = {
  '1': 'ListPersonalNotificationsRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'after_sequence', '3': 2, '4': 1, '5': 3, '10': 'afterSequence'},
    {'1': 'through_sequence', '3': 3, '4': 1, '5': 3, '10': 'throughSequence'},
    {'1': 'unread_only', '3': 4, '4': 1, '5': 8, '10': 'unreadOnly'},
    {'1': 'limit', '3': 5, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'baseline_only', '3': 6, '4': 1, '5': 8, '10': 'baselineOnly'},
  ],
};

/// Descriptor for `ListPersonalNotificationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPersonalNotificationsRequestDescriptor = $convert.base64Decode(
    'CiBMaXN0UGVyc29uYWxOb3RpZmljYXRpb25zUmVxdWVzdBIdCgpjaGFubmVsX2lkGAEgASgJUg'
    'ljaGFubmVsSWQSJQoOYWZ0ZXJfc2VxdWVuY2UYAiABKANSDWFmdGVyU2VxdWVuY2USKQoQdGhy'
    'b3VnaF9zZXF1ZW5jZRgDIAEoA1IPdGhyb3VnaFNlcXVlbmNlEh8KC3VucmVhZF9vbmx5GAQgAS'
    'gIUgp1bnJlYWRPbmx5EhQKBWxpbWl0GAUgASgFUgVsaW1pdBIjCg1iYXNlbGluZV9vbmx5GAYg'
    'ASgIUgxiYXNlbGluZU9ubHk=');

@$core.Deprecated('Use listPersonalNotificationsResponseDescriptor instead')
const ListPersonalNotificationsResponse$json = {
  '1': 'ListPersonalNotificationsResponse',
  '2': [
    {
      '1': 'notifications',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.space.v1.PersonalNotification',
      '10': 'notifications'
    },
    {'1': 'next_sequence', '3': 2, '4': 1, '5': 3, '10': 'nextSequence'},
    {'1': 'through_sequence', '3': 3, '4': 1, '5': 3, '10': 'throughSequence'},
    {'1': 'has_more', '3': 4, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `ListPersonalNotificationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPersonalNotificationsResponseDescriptor =
    $convert.base64Decode(
        'CiFMaXN0UGVyc29uYWxOb3RpZmljYXRpb25zUmVzcG9uc2USRAoNbm90aWZpY2F0aW9ucxgBIA'
        'MoCzIeLnNwYWNlLnYxLlBlcnNvbmFsTm90aWZpY2F0aW9uUg1ub3RpZmljYXRpb25zEiMKDW5l'
        'eHRfc2VxdWVuY2UYAiABKANSDG5leHRTZXF1ZW5jZRIpChB0aHJvdWdoX3NlcXVlbmNlGAMgAS'
        'gDUg90aHJvdWdoU2VxdWVuY2USGQoIaGFzX21vcmUYBCABKAhSB2hhc01vcmU=');

@$core.Deprecated('Use markPersonalNotificationsReadRequestDescriptor instead')
const MarkPersonalNotificationsReadRequest$json = {
  '1': 'MarkPersonalNotificationsReadRequest',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'ids', '3': 2, '4': 3, '5': 9, '10': 'ids'},
    {'1': 'chat_content_ids', '3': 3, '4': 3, '5': 9, '10': 'chatContentIds'},
  ],
};

/// Descriptor for `MarkPersonalNotificationsReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markPersonalNotificationsReadRequestDescriptor =
    $convert.base64Decode(
        'CiRNYXJrUGVyc29uYWxOb3RpZmljYXRpb25zUmVhZFJlcXVlc3QSHQoKY2hhbm5lbF9pZBgBIA'
        'EoCVIJY2hhbm5lbElkEhAKA2lkcxgCIAMoCVIDaWRzEigKEGNoYXRfY29udGVudF9pZHMYAyAD'
        'KAlSDmNoYXRDb250ZW50SWRz');

@$core.Deprecated('Use markPersonalNotificationsReadResponseDescriptor instead')
const MarkPersonalNotificationsReadResponse$json = {
  '1': 'MarkPersonalNotificationsReadResponse',
};

/// Descriptor for `MarkPersonalNotificationsReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markPersonalNotificationsReadResponseDescriptor =
    $convert
        .base64Decode('CiVNYXJrUGVyc29uYWxOb3RpZmljYXRpb25zUmVhZFJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic>
    PersonalNotificationServiceBase$json = {
  '1': 'PersonalNotificationService',
  '2': [
    {
      '1': 'ListPersonalNotifications',
      '2': '.space.v1.ListPersonalNotificationsRequest',
      '3': '.space.v1.ListPersonalNotificationsResponse'
    },
    {
      '1': 'MarkPersonalNotificationsRead',
      '2': '.space.v1.MarkPersonalNotificationsReadRequest',
      '3': '.space.v1.MarkPersonalNotificationsReadResponse'
    },
  ],
};

@$core.Deprecated('Use personalNotificationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    PersonalNotificationServiceBase$messageJson = {
  '.space.v1.ListPersonalNotificationsRequest':
      ListPersonalNotificationsRequest$json,
  '.space.v1.ListPersonalNotificationsResponse':
      ListPersonalNotificationsResponse$json,
  '.space.v1.PersonalNotification': PersonalNotification$json,
  '.space.v1.MarkPersonalNotificationsReadRequest':
      MarkPersonalNotificationsReadRequest$json,
  '.space.v1.MarkPersonalNotificationsReadResponse':
      MarkPersonalNotificationsReadResponse$json,
};

/// Descriptor for `PersonalNotificationService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List personalNotificationServiceDescriptor = $convert.base64Decode(
    'ChtQZXJzb25hbE5vdGlmaWNhdGlvblNlcnZpY2USdAoZTGlzdFBlcnNvbmFsTm90aWZpY2F0aW'
    '9ucxIqLnNwYWNlLnYxLkxpc3RQZXJzb25hbE5vdGlmaWNhdGlvbnNSZXF1ZXN0Gisuc3BhY2Uu'
    'djEuTGlzdFBlcnNvbmFsTm90aWZpY2F0aW9uc1Jlc3BvbnNlEoABCh1NYXJrUGVyc29uYWxOb3'
    'RpZmljYXRpb25zUmVhZBIuLnNwYWNlLnYxLk1hcmtQZXJzb25hbE5vdGlmaWNhdGlvbnNSZWFk'
    'UmVxdWVzdBovLnNwYWNlLnYxLk1hcmtQZXJzb25hbE5vdGlmaWNhdGlvbnNSZWFkUmVzcG9uc2'
    'U=');
