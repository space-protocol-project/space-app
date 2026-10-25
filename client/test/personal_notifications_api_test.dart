import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/personal_notifications.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' as sp;

class _Session implements SpaceSession {
  @override
  bool get participantProfilesSupported => false;
  _Session({this.supported = false, this.channels = const []});
  final bool supported;
  final List<sp.Channel> channels;
  @override
  bool get personalNotificationsSupported => supported;
  @override
  List<sp.Channel> get availableChannels => channels;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('Прежний сервер не получает новые RPC уведомлений', () async {
    final api = SessionPersonalNotificationApi(_Session());
    final unsupported = throwsA(
      isA<GrpcError>().having(
        (error) => error.code,
        'code',
        StatusCode.unimplemented,
      ),
    );
    expect(api.sections, isEmpty);
    await expectLater(
      api.list(ListPersonalNotificationsRequest(channelId: 'general')),
      unsupported,
    );
    await expectLater(api.markRead('general', ['pn_1']), unsupported);
  });

  for (final scenario in [
    'hidden',
    'read-denied',
    'archived',
    'mls',
    'voice',
  ]) {
    test('Недоступная цель не вызывает RPC: $scenario', () async {
      final channel = sp.Channel(
        id: 'target',
        archived: scenario == 'archived',
        mlsGroupId: scenario == 'mls' ? [1] : [],
        permissions: sp.ChannelPermissions(
          visible: scenario != 'hidden',
          read: scenario != 'read-denied',
        ),
        views: [sp.View(type: scenario == 'voice' ? 'voice_room' : 'chat')],
      );
      final api = SessionPersonalNotificationApi(
        _Session(supported: true, channels: [channel]),
      );
      await expectLater(
        api.list(ListPersonalNotificationsRequest(channelId: 'target')),
        throwsA(
          isA<GrpcError>().having(
            (error) => error.code,
            'code',
            StatusCode.permissionDenied,
          ),
        ),
      );
    });
  }
}
