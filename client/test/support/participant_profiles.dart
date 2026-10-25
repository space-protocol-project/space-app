import 'dart:async';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:image/image.dart' as img;
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';

Uint8List sampleAvatar() => img.encodePng(
  img.Image(width: 16, height: 16, numChannels: 4)
    ..clear(img.ColorRgba8(90, 120, 150, 255)),
);

class FakeParticipantProfiles implements ParticipantProfiles {
  @override
  bool participantProfilesSupported = true;
  @override
  String profilePrincipalId = 'u_alice';
  ParticipantProfile value = ParticipantProfile(
    principalId: 'u_alice',
    displayName: 'Алиса',
  );
  Object? failure;
  Completer<ParticipantProfile>? pending;
  Completer<List<ParticipantProfile>>? listing;
  List<ParticipantProfile>? listed;
  final updates = <UpdateParticipantProfileRequest>[];
  final queries = <(String, List<String>)>[];
  @override
  Future<ParticipantProfile> getParticipantProfile() async =>
      pending?.future ?? value.deepCopy();
  @override
  Future<ParticipantProfile> updateParticipantProfile(
    UpdateParticipantProfileRequest request,
  ) async {
    updates.add(request.deepCopy());
    if (failure case final error?) throw error;
    if (value.revision != request.expectedRevision) {
      throw const GrpcError.aborted();
    }
    value.displayName = request.displayName;
    if (request.hasAvatarPng()) value.avatarPng = request.avatarPng;
    if (request.removeAvatar) value.clearAvatarPng();
    value.revision += Int64.ONE;
    return value.deepCopy();
  }

  @override
  Future<List<ParticipantProfile>> listParticipantProfiles(
    String channel,
    List<String> ids,
  ) async {
    queries.add((channel, List.of(ids)));
    if (listing case final pending?) return pending.future;
    return listed ??
        [
          for (final id in ids)
            ParticipantProfile(
              principalId: id,
              displayName: value.displayName,
              avatarPng: value.avatarPng,
            ),
        ];
  }
}
