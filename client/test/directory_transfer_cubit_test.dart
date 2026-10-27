import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/directory_transfer.dart';
import 'package:space_client/src/directory_transfer_cubit.dart';
import 'package:space_client/src/directory_transfer_qr.dart';
import 'package:space_client/src/directory_transfer_rpc.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_directory_noise/space_directory_noise.dart';

import 'fixtures/directory.dart';
import 'pairing_qr_test.dart' show testServer;

class ControlledDirectory extends DirectoryTransfer {
  ControlledDirectory(Discovery server)
    : super(server, RpcDirectoryRelay(server), const NativeDirectoryNoise());
  final request = Completer<DirectoryTransferQr>();
  int closures = 0;
  Completer<void>? closing;
  @override
  Future<DirectoryTransferQr> receiveStart() => request.future;
  @override
  Future<void> receiveHandshake() async {}
  @override
  Future<DirectoryRestorePlan> receive(DirectoryBackupService service) =>
      service.preview(directoryDocument());
  @override
  Future<void> close() async {
    closures++;
    await super.close();
    await closing?.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppPreferences preferences;
  late ChatController controller;
  late ControlledDirectory transfer;
  late DirectoryTransferCubit cubit;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    preferences = AppPreferences();
    controller = ChatController(DirectoryVault())..preview = testServer();
    final service = DirectoryBackupService(
      DirectoryRepository(DirectoryStorage()),
      DirectoryVault(),
      preferences,
      () => {},
    );
    transfer = ControlledDirectory(controller.preview!);
    cubit = DirectoryTransferCubit(
      service,
      controller,
      create: (_) => transfer,
    );
  });
  tearDown(() async {
    await cubit.close();
    await controller.close();
    await preferences.close();
  });
  DirectoryTransferQr qr() => DirectoryTransferQr(
    'https://space.example',
    'srv_example',
    url64(List.filled(32, 2)),
    '',
    'dt_${'a' * 43}',
    'dc_${'b' * 43}',
    url64(List.filled(32, 3)),
    DateTime.now().millisecondsSinceEpoch ~/ 1000 + 300,
  );
  test(
    'Поздний ответ после отмены не возвращает QR и состояние сравнения',
    () async {
      final pending = cubit.start();
      await cubit.cancel();
      transfer.request.complete(qr());
      await pending;
      expect(cubit.state.stage, DirectoryTransferStage.idle);
      expect(cubit.state.qr, isEmpty);
      expect(transfer.closures, 1);
    },
  );
  test(
    'Закрытие экрана не оставляет таймер и не публикует поздний результат',
    () async {
      final pending = cubit.start();
      await cubit.close();
      transfer.request.complete(qr());
      await pending;
      expect(cubit.isClosed, isTrue);
      expect(cubit.state.qr, isEmpty);
    },
  );
  test('Лимит выбора 12 и запрет менять выбор во время обмена', () async {
    for (var i = 0; i < 13; i++) {
      cubit.select('https://space$i.example', true);
    }
    expect(cubit.state.selected, hasLength(12));
    final pending = cubit.start();
    cubit.select('https://space0.example', false);
    expect(cubit.state.selected, hasLength(12));
    await cubit.cancel(expired: true);
    transfer.request.complete(qr());
    await pending;
    expect(cubit.state.stage, DirectoryTransferStage.failed);
    expect(cubit.state.mergeSettings, isFalse);
  });
  test('Каталог сначала показывается без изменений, явное применение завершается без вложенной блокировки', () async {
    final pending = cubit.start();
    transfer.request.complete(qr());
    await pending;
    expect(cubit.state.stage, DirectoryTransferStage.compare);
    await cubit.confirm('сверено');
    expect(cubit.state.stage, DirectoryTransferStage.preview);
    expect(preferences.origins, isEmpty);
    expect(cubit.state.mergeSettings, isFalse);
    await cubit.apply().timeout(const Duration(seconds: 5));
    expect(cubit.state.stage, DirectoryTransferStage.done);
    expect(preferences.origins, ['https://space.example']);
    expect(preferences.palette, 'gruvbox');
  });
  test(
    'Поздняя первая отмена не сбрасывает уже начатую новую попытку',
    () async {
      final old = transfer;
      old.closing = Completer<void>();
      final starting = cubit.start();
      final cancelling = cubit.cancel();
      await cubit.cancel();
      transfer = ControlledDirectory(controller.preview!);
      final next = cubit.start();
      old.closing!.complete();
      old.request.complete(qr());
      await cancelling;
      await starting;
      expect(cubit.state.stage, DirectoryTransferStage.waiting);
      expect(transfer.closures, 0);
      transfer.request.complete(qr());
      await next;
      expect(cubit.state.stage, DirectoryTransferStage.compare);
    },
  );
}
