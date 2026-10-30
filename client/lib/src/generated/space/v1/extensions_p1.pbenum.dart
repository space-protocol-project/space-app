// This is a generated file - do not edit.
//
// Generated from space/v1/extensions_p1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ExtensionCommandEffect extends $pb.ProtobufEnum {
  static const ExtensionCommandEffect EXTENSION_COMMAND_EFFECT_UNSPECIFIED =
      ExtensionCommandEffect._(
          0, _omitEnumNames ? '' : 'EXTENSION_COMMAND_EFFECT_UNSPECIFIED');
  static const ExtensionCommandEffect EXTENSION_COMMAND_EFFECT_NONE =
      ExtensionCommandEffect._(
          1, _omitEnumNames ? '' : 'EXTENSION_COMMAND_EFFECT_NONE');
  static const ExtensionCommandEffect EXTENSION_COMMAND_EFFECT_MUTATION =
      ExtensionCommandEffect._(
          2, _omitEnumNames ? '' : 'EXTENSION_COMMAND_EFFECT_MUTATION');

  static const $core.List<ExtensionCommandEffect> values =
      <ExtensionCommandEffect>[
    EXTENSION_COMMAND_EFFECT_UNSPECIFIED,
    EXTENSION_COMMAND_EFFECT_NONE,
    EXTENSION_COMMAND_EFFECT_MUTATION,
  ];

  static final $core.List<ExtensionCommandEffect?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ExtensionCommandEffect? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ExtensionCommandEffect._(super.value, super.name);
}

class ExtensionCommandOutcome extends $pb.ProtobufEnum {
  static const ExtensionCommandOutcome EXTENSION_COMMAND_OUTCOME_UNSPECIFIED =
      ExtensionCommandOutcome._(
          0, _omitEnumNames ? '' : 'EXTENSION_COMMAND_OUTCOME_UNSPECIFIED');

  /// Квитанция отсутствует; это НЕ доказательство отсутствия эффекта.
  static const ExtensionCommandOutcome EXTENSION_COMMAND_OUTCOME_UNKNOWN =
      ExtensionCommandOutcome._(
          1, _omitEnumNames ? '' : 'EXTENSION_COMMAND_OUTCOME_UNKNOWN');
  static const ExtensionCommandOutcome EXTENSION_COMMAND_OUTCOME_CONFIRMED =
      ExtensionCommandOutcome._(
          2, _omitEnumNames ? '' : 'EXTENSION_COMMAND_OUTCOME_CONFIRMED');

  static const $core.List<ExtensionCommandOutcome> values =
      <ExtensionCommandOutcome>[
    EXTENSION_COMMAND_OUTCOME_UNSPECIFIED,
    EXTENSION_COMMAND_OUTCOME_UNKNOWN,
    EXTENSION_COMMAND_OUTCOME_CONFIRMED,
  ];

  static final $core.List<ExtensionCommandOutcome?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ExtensionCommandOutcome? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ExtensionCommandOutcome._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
