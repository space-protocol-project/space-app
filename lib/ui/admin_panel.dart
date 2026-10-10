import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';

import '../src/generated/space/v1/space.pb.dart';
import '../src/recovery_card.dart';
import '../src/recovery_qr.dart';

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:space_api/space_api.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../src/core.dart';

class NativeAdminGateway extends SpaceGateway {
  NativeAdminGateway(super.origin, this.session);
  final SpaceAdministration session;
  @override
  String get tlsFingerprint => session is SpaceSession
      ? (session as SpaceSession).server.tlsFingerprint
      : '';
  @override
  Future<Map<String, dynamic>> call(
    String path, {
    String token = '',
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
}

Future<void> openServerAdministration(
  BuildContext context,
  SpaceAdministration session, {
  VoidCallback? onDeviceRevoked,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 1000),
    builder: (context) => SizedBox(
      height: MediaQuery.sizeOf(context).height * .9,
      child: AdminPage(
        autoConnect: true,
        login: ({bool create = false}) => session.adminIdentity(),
        gateway: (uri) => NativeAdminGateway(uri, session),
        authorizeDevice: session is AdministrativeDeviceControl
            ? (password) async {
                DeviceRecord? authority;
                if (!(session as DeviceManagement).hasRootAuthority) {
                  final file = await openFile(
                    acceptedTypeGroups: const [
                      XTypeGroup(
                        label: 'Корневая карточка Space',
                        extensions: ['json', 'png'],
                      ),
                    ],
                  );
                  if (file == null) throw StateError('Выбор карточки отменён');
                  if (await file.length() > maxRecoveryImageBytes) {
                    throw const FormatException('Карточка слишком большая');
                  }
                  authority = await recordFromRecovery(
                    await compute(openCardInWorker, [
                      await compute(artifactInWorker, await file.readAsBytes()),
                      password,
                    ]),
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
                  final file = await openFile(
                    acceptedTypeGroups: const [
                      XTypeGroup(
                        label: 'Карточка Space',
                        extensions: ['json', 'png'],
                      ),
                    ],
                  );
                  if (file == null) throw StateError('Выбор карточки отменён');
                  if (await file.length() > maxRecoveryImageBytes) {
                    throw const FormatException('Карточка слишком большая');
                  }
                  authority = await recordFromRecovery(
                    await compute(openCardInWorker, [
                      await compute(artifactInWorker, await file.readAsBytes()),
                      password,
                    ]),
                  );
                }
                await manager.revokeDevice(
                  DeviceGrant()..mergeFromProto3Json(grant),
                  authority: authority,
                );
              }
            : null,
        onDeviceRevoked: () {
          onDeviceRevoked?.call();
          if (context.mounted) Navigator.pop(context);
        },
        onClose: () => Navigator.pop(context),
      ),
    ),
  );
}
