import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/community_mentions.pb.dart';
import 'package:space_client/src/generated/space/v1/personal_notifications.pb.dart';

import '../channels_test.dart' show ChannelVault;

Future<void> _openRegistration(SpaceSession owner) async {
  final current = await owner.adminRequest('/api/v1/space/settings');
  final settings = Map<String, dynamic>.from(current['settings'] as Map);
  await owner.adminRequest(
    '/api/v1/space/settings',
    method: 'PATCH',
    body: {
      ...settings,
      'registrationPolicy': 'open',
      'expectedRevision': settings['revision'],
    }..remove('revision'),
  );
}

Future<void> _denyRead(SpaceSession owner, String recipient) async {
  final current = await owner.adminRequest('/api/v1/channels/general/access');
  await owner.adminRequest(
    '/api/v1/channels/general/access',
    method: 'PUT',
    body: {
      'expectedRevision': current['revision'],
      'rules': [
        ...List<dynamic>.from(current['rules'] as List? ?? []),
        {
          'principalId': recipient,
          'permissions': {
            'visible': true,
            'read': false,
            'write': false,
            'manage': false,
          },
        },
      ],
    },
  );
}

void main() {
  final origin =
      Platform.environment['SPACE_PERSONAL_NOTIFICATIONS_TEST_ORIGIN'];
  test(
    'Уведомления: настоящий Dart/Connect, PostgreSQL, страницы и отзыв прав',
    () async {
      final uri = Uri.parse(origin!);
      expect(InternetAddress.tryParse(uri.host)?.isLoopback, isTrue);
      expect(uri.scheme, 'http');
      final server = await discover(origin);
      final owner = await SpaceSession.connect(server, ChannelVault());
      addTearDown(owner.close);
      expect(owner.role, 'owner');
      await _openRegistration(owner);
      final member = await SpaceSession.connect(server, ChannelVault());
      addTearDown(member.close);
      final api = SessionPersonalNotificationApi(member);
      expect(api.supported, isTrue);
      expect(api.sections.any((c) => c.id == 'general'), isTrue);
      final candidate = (await SessionCommunityMentionApi(
        owner,
      ).candidates('general', '', member.principalId)).single;
      final label = '@${candidate.displayName}';
      final mentions = [
        CommunityMention(
          principalId: candidate.principalId,
          displayName: candidate.displayName,
          length: label.length,
        ),
      ];
      for (var i = 0; i < 3; i++) {
        await owner.sendMentioned(
          'general',
          '$label $i',
          'notice-$i',
          [],
          '',
          mentions,
        );
      }
      final first = await api.list(
        ListPersonalNotificationsRequest(
          channelId: 'general',
          limit: 2,
          unreadOnly: true,
        ),
      );
      expect(first.notifications, hasLength(2));
      expect(first.hasMore, isTrue);
      expect(first.throughSequence, Int64(3));
      expect(
        first.notifications.first.targetKind,
        NotificationTargetKind.NOTIFICATION_TARGET_KIND_CHAT_MESSAGE,
      );
      final last = await api.list(
        ListPersonalNotificationsRequest(
          channelId: 'general',
          afterSequence: first.nextSequence,
          throughSequence: first.throughSequence,
          unreadOnly: true,
        ),
      );
      expect(last.notifications, hasLength(1));
      expect(last.hasMore, isFalse);
      expect(last.nextSequence, first.throughSequence);
      final id = first.notifications.first.id;
      await api.markRead('general', [id]);
      await api.markRead('general', [id]);
      expect(
        (await api.list(
          ListPersonalNotificationsRequest(
            channelId: 'general',
            unreadOnly: true,
          ),
        )).notifications,
        hasLength(2),
      );
      final baseline = await api.list(
        ListPersonalNotificationsRequest(
          channelId: 'general',
          baselineOnly: true,
        ),
      );
      expect(baseline.notifications, isEmpty);
      expect(baseline.nextSequence, Int64(3));
      await api.markChatRead('general', [last.notifications.single.contentId]);
      await api.markChatRead('general', [last.notifications.single.contentId]);
      expect(
        (await api.list(
          ListPersonalNotificationsRequest(
            channelId: 'general',
            unreadOnly: true,
          ),
        )).notifications,
        hasLength(1),
      );
      // Локальный каталог ещё разрешает чтение: отказ должен прийти с сервера.
      await _denyRead(owner, member.principalId);
      final denied = throwsA(
        isA<GrpcError>().having(
          (e) => e.code,
          'code',
          StatusCode.permissionDenied,
        ),
      );
      await expectLater(
        api.list(ListPersonalNotificationsRequest(channelId: 'general')),
        denied,
      );
      await expectLater(api.markRead('general', [id]), denied);
      await expectLater(
        api.markChatRead('general', [last.notifications.single.contentId]),
        denied,
      );
    },
    skip: origin == null
        ? 'Нужна отдельная локальная PostgreSQL и runtime'
        : false,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
