import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:space_api/space_api.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../src/core.dart';

class NativeAdminGateway extends SpaceGateway {
  NativeAdminGateway(super.origin, this.session);
  final SpaceAdministration session;
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
  SpaceAdministration session,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 1000),
    builder: (context) => SizedBox(
      height: MediaQuery.sizeOf(context).height * .9,
      child: AdminPage(
        autoConnect: true,
        allowLogout: false,
        allowIdentityCreation: false,
        login: ({bool create = false}) => session.adminIdentity(),
        gateway: (uri) => NativeAdminGateway(uri, session),
        onClose: () => Navigator.pop(context),
      ),
    ),
  );
}
