import 'dart:convert';

import 'package:space_admin_ui/avatar_data.dart';
export 'package:space_admin_ui/avatar_data.dart';

import 'generated/space/v1/space.pb.dart';

abstract interface class ParticipantProfiles {
  bool get participantProfilesSupported;
  String get profilePrincipalId;
  Future<ParticipantProfile> getParticipantProfile();
  Future<ParticipantProfile> updateParticipantProfile(
    UpdateParticipantProfileRequest request,
  );
  Future<List<ParticipantProfile>> listParticipantProfiles(
    String channel,
    List<String> ids,
  );
}

ParticipantProfiles? participantProfiles(Object? session) =>
    session is ParticipantProfiles && session.participantProfilesSupported
    ? session
    : null;

bool validProfileName(String name) =>
    name.runes.length <= 40 &&
    !name.runes.any((r) => r >= 0xd800 && r <= 0xdfff) &&
    utf8.encode(name).length <= 160 &&
    !RegExp(r'[\x00-\x1f\x7f-\x9f\u202a-\u202e\u2066-\u2069]').hasMatch(name);

ParticipantProfile checkedParticipantProfile(
  ParticipantProfile value, {
  String? principal,
}) {
  if (!RegExp(r'^[\x20-\x7e]{1,128}$').hasMatch(value.principalId) ||
      (principal != null && principal != value.principalId) ||
      value.revision.toInt() < 0 ||
      !validProfileName(value.displayName) ||
      (value.avatarPng.isNotEmpty && !validProfileAvatar(value.avatarPng))) {
    throw const FormatException('Повреждён профиль участника');
  }
  return value.deepCopy()..freeze();
}

/// Меняет только имя, сохраняя аватар и проверяя ревизию.
Future<ParticipantProfile> updateParticipantName(
  ParticipantProfiles api,
  String name,
) async {
  final current = await api.getParticipantProfile();
  return api.updateParticipantProfile(
    UpdateParticipantProfileRequest(
      displayName: name,
      expectedRevision: current.revision,
    ),
  );
}
