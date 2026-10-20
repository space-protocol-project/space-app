import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';

import '../tool/attachment_policy_fixture.dart';

class FixtureAdmin implements SpaceAdministration {
  int reads = 0, writes = 0;
  int conflicts = 1;
  int errorCode = StatusCode.aborted;
  Map<String, dynamic>? written;
  @override
  Future<Map<String, dynamic>> adminRequest(
    String path, {
    Map<String, dynamic>? body,
    String? method,
  }) async {
    if (method != 'PATCH') {
      reads++;
      return {
        'settings': {
          'title': 'Пространство',
          'chatTitle': 'Чат',
          'chatEnabled': true,
          'registrationPolicy': reads == 1 ? 'open' : 'closed',
          'revision': '$reads',
          'attachmentsEnabled': false,
        },
      };
    }
    writes++;
    if (writes <= conflicts) throw GrpcError.custom(errorCode, 'Конфликт');
    written = body;
    return {};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'Конфликт перечитывает настройки и сохраняет закрытую регистрацию',
    () async {
      final admin = FixtureAdmin();
      await enableFixtureAttachments(admin);
      expect(admin.reads, 2);
      expect(admin.written!['expectedRevision'], '2');
      expect(admin.written!['registrationPolicy'], 'closed');
      expect(admin.written!['attachmentsEnabled'], true);
    },
  );
  test('Повтор ограничен тремя попытками', () async {
    final admin = FixtureAdmin()..conflicts = 10;
    await expectLater(
      enableFixtureAttachments(admin),
      throwsA(isA<GrpcError>()),
    );
    expect(admin.writes, 3);
  });
  test('Ошибка прав не повторяется', () async {
    final admin = FixtureAdmin()..errorCode = StatusCode.permissionDenied;
    await expectLater(
      enableFixtureAttachments(admin),
      throwsA(isA<GrpcError>()),
    );
    expect(admin.writes, 1);
  });
}
