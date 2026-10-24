import '../src/files.dart';
import 'package:flutter/foundation.dart';

import '../src/generated/space/v1/space.pb.dart';
import '../src/recovery_card.dart';
import '../src/recovery_qr.dart';

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:space_api/space_api.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../src/core.dart';
import 'voice_room_management.dart';

class NativeAdminGateway extends SpaceGateway {
  NativeAdminGateway(super.origin, this.session);
  final SpaceAdministration session;
  @override
  String get tlsFingerprint => session is SpaceSession
      ? (session as SpaceSession).server.tlsFingerprint
      : '';
  @override
  String invitationLink(String token) {
    if (session is! SpaceSession) return super.invitationLink(token);
    final server = (session as SpaceSession).server;
    return spaceEndpointLink(
      server.endpoint,
      server.tlsFingerprint,
      server.serverId,
      server.announcement?.endpoints ?? const [],
      invitationToken: token,
    );
  }

  @override
  Future<Map<String, dynamic>> call(
    String path, {
    String token = '',
    Map<String, dynamic>? body,
    String? method,
  }) async {
    return _nativeAdminRequest(session, path, body: body, method: method);
  }
}

Future<Map<String, dynamic>> _nativeAdminRequest(
  SpaceAdministration session,
  String path, {
  Map<String, dynamic>? body,
  String? method,
}) async {
  try {
    return await session.adminRequest(path, body: body, method: method);
  } on GrpcError catch (e) {
    final status = switch (e.code) {
      StatusCode.permissionDenied => 403,
      StatusCode.aborted || StatusCode.alreadyExists => 409,
      StatusCode.invalidArgument => 400,
      StatusCode.notFound => 404,
      StatusCode.resourceExhausted => 429,
      StatusCode.failedPrecondition => 412,
      StatusCode.unauthenticated => 401,
      _ => 503,
    };
    throw SpaceApiError(
      status,
      e.code == StatusCode.permissionDenied
          ? 'Устройству нужны права управления. Используйте сопряжение или recovery-карточку с разрешением space.manage.'
          : e.message ?? 'Операция не выполнена',
    );
  }
}

Future<DeviceRecord> openAuthorityCard(String password, String label) async {
  final file = await openFile(
    acceptedTypeGroups: [
      XTypeGroup(label: label, extensions: ['json', 'png']),
    ],
  );
  if (file == null) {
    throw StateError('Выбор карточки отменён');
  }
  if (await file.length() > maxRecoveryImageBytes) {
    throw const FormatException('Карточка слишком большая');
  }
  return await recordFromRecovery(
    await compute(openCardInWorker, [
      await compute(artifactInWorker, await file.readAsBytes()),
      password,
    ]),
  );
}

Widget serverAdministration(
  BuildContext context,
  SpaceAdministration session, {
  VoidCallback? onDeviceRevoked,
  Key? key,
}) {
  return Theme(
    key: key,
    data: Theme.of(context)
        .copyWith(scaffoldBackgroundColor: Colors.transparent),
    child: AdminPage(
      autoConnect: true,
      channelManagement: session is SpaceSession
          ? VoiceRoomManagement(
              session: session,
              call: (path, {body, method}) => _nativeAdminRequest(
                session,
                path,
                body: body,
                method: method,
              ),
            )
          : null,
      login: ({bool create = false}) => session.adminIdentity(),
      gateway: (uri) => NativeAdminGateway(uri, session),
      authorizeDevice: session is AdministrativeDeviceControl
          ? (password) async {
              DeviceRecord? authority;
              if (!(session as DeviceManagement).hasRootAuthority) {
                authority = await openAuthorityCard(
                  password,
                  'Корневая карточка Space',
                );
              }
              await (session as AdministrativeDeviceControl)
                  .authorizeAdministration(authority: authority);
            }
          : null,
      revokeDevice: session is DeviceManagement
          ? (grant, password) async {
              final manager = session as DeviceManagement;
              DeviceRecord? authority;
              if (!manager.hasRootAuthority &&
                  grant['id'] != manager.currentGrantId) {
                authority = await openAuthorityCard(password, 'Карточка Space');
              }
              await manager.revokeDevice(
                DeviceGrant()..mergeFromProto3Json(grant),
                authority: authority,
              );
            }
          : null,
      onDeviceRevoked: onDeviceRevoked,
    ),
  );
}
