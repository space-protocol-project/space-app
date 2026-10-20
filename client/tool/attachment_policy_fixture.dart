// Только одноразовые стенды файлов и восстановления, не настройки приложения.
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';

Future<void> enableFixtureAttachments(SpaceAdministration owner) async {
  for (var attempt = 0; ; attempt++) {
    try {
      await _enable(owner);
      return;
    } on GrpcError catch (error) {
      // Закрытие первичной настройки может изменить ревизию после GET.
      if (error.code != StatusCode.aborted || attempt >= 2) rethrow;
    }
  }
}

Future<void> _enable(SpaceAdministration owner) async {
  final response = await owner.adminRequest('/api/v1/space/settings');
  final settings = Map<String, dynamic>.from(response['settings'] as Map);
  if (settings['attachmentsEnabled'] == true) return;
  await owner.adminRequest(
    '/api/v1/space/settings',
    method: 'PATCH',
    body: {
      'title': settings['title'],
      'chatTitle': settings['chatTitle'],
      'chatEnabled': settings['chatEnabled'],
      'registrationPolicy': settings['registrationPolicy'],
      'expectedRevision': settings['revision'],
      'attachmentsEnabled': true,
    },
  );
}
