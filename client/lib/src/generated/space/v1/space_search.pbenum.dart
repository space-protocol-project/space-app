// This is a generated file - do not edit.
//
// Generated from space/v1/space_search.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SpaceSearchKind extends $pb.ProtobufEnum {
  static const SpaceSearchKind SPACE_SEARCH_KIND_UNSPECIFIED =
      SpaceSearchKind._(
          0, _omitEnumNames ? '' : 'SPACE_SEARCH_KIND_UNSPECIFIED');
  static const SpaceSearchKind SPACE_SEARCH_KIND_CHAT_MESSAGE =
      SpaceSearchKind._(
          1, _omitEnumNames ? '' : 'SPACE_SEARCH_KIND_CHAT_MESSAGE');
  static const SpaceSearchKind SPACE_SEARCH_KIND_FORUM_THREAD =
      SpaceSearchKind._(
          2, _omitEnumNames ? '' : 'SPACE_SEARCH_KIND_FORUM_THREAD');
  static const SpaceSearchKind SPACE_SEARCH_KIND_FORUM_REPLY =
      SpaceSearchKind._(
          3, _omitEnumNames ? '' : 'SPACE_SEARCH_KIND_FORUM_REPLY');
  static const SpaceSearchKind SPACE_SEARCH_KIND_FEED_POST =
      SpaceSearchKind._(4, _omitEnumNames ? '' : 'SPACE_SEARCH_KIND_FEED_POST');
  static const SpaceSearchKind SPACE_SEARCH_KIND_FEED_COMMENT =
      SpaceSearchKind._(
          5, _omitEnumNames ? '' : 'SPACE_SEARCH_KIND_FEED_COMMENT');

  static const $core.List<SpaceSearchKind> values = <SpaceSearchKind>[
    SPACE_SEARCH_KIND_UNSPECIFIED,
    SPACE_SEARCH_KIND_CHAT_MESSAGE,
    SPACE_SEARCH_KIND_FORUM_THREAD,
    SPACE_SEARCH_KIND_FORUM_REPLY,
    SPACE_SEARCH_KIND_FEED_POST,
    SPACE_SEARCH_KIND_FEED_COMMENT,
  ];

  static final $core.List<SpaceSearchKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static SpaceSearchKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SpaceSearchKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
