import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/pairing_approval_cubit.dart';
import 'package:space_client/src/pairing_qr.dart';

import 'pairing_qr_test.dart' show testRequest, testServer;

class ApprovalManager implements DeviceManagement {
  int preparations = 0, signatures = 0;
  @override
  bool get hasRootAuthority => true;
  @override
  Future<String> preparePairing(
    Pairing pairing, {
    DeviceRecord? authority,
  }) async {
    preparations++;
    return 'ABCD-EFGH';
  }

  @override
  Future<String> approvePairing(
    Pairing pairing, {
    DeviceRecord? authority,
  }) async {
    signatures++;
    return 'ABCD-EFGH';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late ApprovalManager manager;
  late PairingApprovalCubit cubit;
  late CreatePairingResponse request;
  var inspections = 0;
  var clock = DateTime.now();
  setUp(() {
    clock = DateTime.now();
    manager = ApprovalManager();
    request = testRequest();
    inspections = 0;
    cubit = PairingApprovalCubit(
      now: () => clock,
      server: testServer,
      manager: () => manager,
      inspect: (_, _) async {
        inspections++;
        return request.pairing;
      },
    );
  });
  tearDown(() => cubit.close());
  Future<void> prepare() => cubit.prepare(
    confirm: (_) async => true,
    readAuthority: () async => null,
  );

  test('Считывание QR только заполняет код', () {
    cubit.readQr(PairingQr.request(testServer(), request).encode());
    expect(cubit.state.code, request.code);
    expect(inspections, 0);
    expect(manager.preparations, 0);
    expect(manager.signatures, 0);
  });

  test(
    'Требуются подготовка, совпадение SAS и отдельное подтверждение',
    () async {
      cubit.setCode(request.code);
      await prepare();
      expect(cubit.state.prepared, isTrue);
      expect(manager.signatures, 0);
      await cubit.approve('wrong', () async => true);
      expect(cubit.state.messageKey, 'pairingMismatch');
      await cubit.approve('abcd efgh', () async => false);
      expect(manager.signatures, 0);
      await cubit.approve('abcd efgh', () async => true);
      expect(manager.signatures, 1);
      expect(cubit.state.prepared, isFalse);
      expect(cubit.state.messageKey, 'pairingSigned');
    },
  );

  test('Изменённые права после QR не доходят до подготовки', () async {
    cubit.readQr(PairingQr.request(testServer(), request).encode());
    request.pairing.administrative = true;
    await prepare();
    expect(cubit.state.error, isFormatException);
    expect(manager.preparations, 0);
  });

  test(
    'Смена кода или отмена сбрасывает подготовленное подтверждение',
    () async {
      cubit.setCode(request.code);
      await prepare();
      cubit.setCode('other');
      await cubit.approve('ABCD-EFGH', () async => true);
      expect(manager.signatures, 0);
      expect(cubit.state.verification, isEmpty);
    },
  );

  test('Отмена во время диалога исключает позднюю подпись', () async {
    cubit.setCode(request.code);
    await prepare();
    final confirmed = Completer<bool>();
    final signing = cubit.approve('ABCD-EFGH', () => confirmed.future);
    cubit.reset();
    confirmed.complete(true);
    await signing;
    expect(manager.signatures, 0);
  });

  test('Отмена во время inspect исключает подготовку', () async {
    final response = Completer<Pairing>();
    await cubit.close();
    cubit = PairingApprovalCubit(
      server: testServer,
      manager: () => manager,
      inspect: (_, _) => response.future,
    );
    cubit.setCode(request.code);
    final preparing = prepare();
    cubit.reset();
    response.complete(request.pairing);
    await preparing;
    expect(manager.preparations, 0);
    expect(cubit.state.prepared, isFalse);
  });

  test('Истечение между подготовкой и подписью не выдаёт grant', () async {
    cubit.setCode(request.code);
    await prepare();
    clock = clock.add(const Duration(minutes: 6));
    await cubit.approve('ABCD-EFGH', () async => true);
    expect(manager.signatures, 0);
  });
  test('Поздний QR после отмены не восстанавливает код', () async {
    final picked = Completer<String?>();
    final scanning = cubit.scan(() => picked.future);
    expect(cubit.state.busy, isTrue);
    cubit.reset();
    picked.complete(PairingQr.request(testServer(), request).encode());
    await scanning;
    expect(cubit.state.code, isEmpty);
    expect(inspections, 0);
  });

  test('QR другого пространства отвергается без сетевого запроса', () {
    final other = Discovery(Uri.parse('https://other.org'), 'other', List.filled(32, 9));
    cubit.readQr(PairingQr.request(other, request).encode());
    expect(cubit.state.code, isEmpty);
    expect(cubit.state.error, isFormatException);
    expect(inspections, 0);
  });

  test('Смена пространства сбрасывает подготовку внутри Cubit', () async {
    final changes = StreamController<Object?>();
    var selected = testServer();
    await cubit.close();
    cubit = PairingApprovalCubit(server: () => selected, manager: () => manager,
      inspect: (_, _) async => request.pairing, contextChanges: changes.stream);
    cubit.setCode(request.code);
    await prepare();
    selected = Discovery(Uri.parse('https://other.org'), 'other', List.filled(32, 9));
    changes.add(null);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.prepared, isFalse);
    await cubit.approve('ABCD-EFGH', () async => true);
    expect(manager.signatures, 0);
    await changes.close();
  });

}
