// This is a generated file - do not edit.
//
// Generated from space/v1/personal_notifications.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class NotificationTargetKind extends $pb.ProtobufEnum {
  static const NotificationTargetKind NOTIFICATION_TARGET_KIND_UNSPECIFIED =
      NotificationTargetKind._(
          0, _omitEnumNames ? '' : 'NOTIFICATION_TARGET_KIND_UNSPECIFIED');
  static const NotificationTargetKind NOTIFICATION_TARGET_KIND_FORUM_THREAD =
      NotificationTargetKind._(
          1, _omitEnumNames ? '' : 'NOTIFICATION_TARGET_KIND_FORUM_THREAD');
  static const NotificationTargetKind NOTIFICATION_TARGET_KIND_FORUM_REPLY =
      NotificationTargetKind._(
          2, _omitEnumNames ? '' : 'NOTIFICATION_TARGET_KIND_FORUM_REPLY');
  static const NotificationTargetKind NOTIFICATION_TARGET_KIND_FEED_POST =
      NotificationTargetKind._(
          3, _omitEnumNames ? '' : 'NOTIFICATION_TARGET_KIND_FEED_POST');
  static const NotificationTargetKind NOTIFICATION_TARGET_KIND_FEED_COMMENT =
      NotificationTargetKind._(
          4, _omitEnumNames ? '' : 'NOTIFICATION_TARGET_KIND_FEED_COMMENT');
  static const NotificationTargetKind NOTIFICATION_TARGET_KIND_CHAT_MESSAGE =
      NotificationTargetKind._(
          5, _omitEnumNames ? '' : 'NOTIFICATION_TARGET_KIND_CHAT_MESSAGE');

  static const $core.List<NotificationTargetKind> values =
      <NotificationTargetKind>[
    NOTIFICATION_TARGET_KIND_UNSPECIFIED,
    NOTIFICATION_TARGET_KIND_FORUM_THREAD,
    NOTIFICATION_TARGET_KIND_FORUM_REPLY,
    NOTIFICATION_TARGET_KIND_FEED_POST,
    NOTIFICATION_TARGET_KIND_FEED_COMMENT,
    NOTIFICATION_TARGET_KIND_CHAT_MESSAGE,
  ];

  static final $core.List<NotificationTargetKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static NotificationTargetKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NotificationTargetKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
