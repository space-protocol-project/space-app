import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/directory_follows.dart';
import 'package:space_client/src/participant_follows_api.dart';

import 'fixtures/directory.dart';

class BackupFollowApi implements ParticipantFollowApi {
  @override
  String get scopeId => 'scope';
  @override
  String get principalId => directorySpace()['principal_id'] as String;
  final ids = <String>{};
  int revision = 1, calls = 0;
  bool deny = false;
  void Function()? afterSet;
  @override
  Future<ListFollowingParticipantsResponse> following(String token) async =>
      ListFollowingParticipantsResponse(
        revision: Int64(revision),
        participants: ids.map(
          (id) => FollowingParticipant(principalId: id, available: true),
        ),
      );
  @override
  Future<SetParticipantFollowResponse> set(
    SetParticipantFollowRequest request,
  ) async {
    if (deny) throw StateError('permission denied');
    expect(request.expectedRevision, Int64(revision));
    expect(request.following, isTrue);
    expect(request.channelId, 'feed');
    calls++;
    ids.add(request.principalId);
    revision++;
    afterSet?.call();
    return SetParticipantFollowResponse(
      revision: Int64(revision),
      state: ParticipantFollowState(
        principalId: request.principalId,
        following: true,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'Подписки добавляются без удалений, повтор не создаёт изменений',
    () async {
      final api = BackupFollowApi()..ids.add('u_${'e' * 64}');
      expect(
        await applyDirectoryFollowing(
          directorySpace(count: 2),
          api,
          'feed',
          () => true,
        ),
        2,
      );
      expect(api.ids.length, 3);
      expect(
        await applyDirectoryFollowing(
          directorySpace(count: 2),
          api,
          'feed',
          () => true,
        ),
        0,
      );
      expect(api.calls, 2);
    },
  );
  test(
    'Другая личность, отзыв доступа и серверный отказ не обходятся',
    () async {
      final api = BackupFollowApi();
      await expectLater(
        applyDirectoryFollowing(
          {...directorySpace(), 'principal_id': 'other'},
          api,
          'feed',
          () => true,
        ),
        throwsFormatException,
      );
      await expectLater(
        applyDirectoryFollowing(directorySpace(), api, 'feed', () => false),
        throwsFormatException,
      );
      api.deny = true;
      await expectLater(
        applyDirectoryFollowing(directorySpace(), api, 'feed', () => true),
        throwsStateError,
      );
      expect(api.calls, 0);
    },
  );
  test('Отмена после первой подписки останавливает продолжение; повтор дописывает остаток', () async {
    var active = true;
    final api = BackupFollowApi()..afterSet = () => active = false;
    await expectLater(
      applyDirectoryFollowing(
        directorySpace(count: 2),
        api,
        'feed',
        () => active,
      ),
      throwsFormatException,
    );
    expect(api.calls, 1);
    active = true;
    api.afterSet = null;
    expect(
      await applyDirectoryFollowing(
        directorySpace(count: 2),
        api,
        'feed',
        () => active,
      ),
      1,
    );
    expect(api.calls, 2);
  });
}
