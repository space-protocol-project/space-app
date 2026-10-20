// Только одноразовые стенды файлов и восстановления, не настройки приложения.
import 'package:space_client/src/core.dart';

Future<void> enableFixtureAttachments(SpaceSession owner) async {
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
  await owner.refreshChannels();
}
