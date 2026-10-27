import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/pairing_selection.dart';

class SelectionVault implements IdentityVault {
  bool saved = false;
  @override
  Future<DeviceRecord?> load(String origin) async => saved
    ? DeviceRecord(origin: origin, serverId: 's', serverKey: '', rootSeed: [], deviceSeed: []) : null;
  @override
  Future<void> save(DeviceRecord record) async { saved = true; }
}

void main() {
  test('Выбор ограничен известными пространствами и не создаёт grant', () async {
    final vault = SelectionVault(), controllers = <String, ChatController>{};
    for (var index = 0; index < 14; index++) {
      controllers['http://space$index'] = ChatController(vault);
    }
    final cubit = PairingSelectionCubit(() => controllers);
    cubit.select('http://unknown', true);
    expect(cubit.state.origins, isEmpty);
    for (final origin in controllers.keys) { cubit.select(origin, true); }
    expect(cubit.state.origins.length, 12);
    expect(cubit.state.fullManagement, isFalse);
    cubit.mode(true);
    expect(cubit.state.fullManagement, isTrue);
    cubit.reset();
    expect(cubit.state.origins, isEmpty);
    expect(cubit.state.fullManagement, isFalse);
    expect(vault.saved, isFalse);
    await cubit.close();
    for (final controller in controllers.values) { await controller.close(); }
  });
  test('Сохранённая личность блокирует всю подготовку до сетевых запросов', () async {
    final vault = SelectionVault()..saved = true;
    final controller = ChatController(vault);
    final cubit = PairingSelectionCubit(() => {'http://space': controller});
    cubit.select('http://space', true);
    await cubit.prepare();
    expect(cubit.state.prepared, isFalse);
    expect(cubit.state.busy, isFalse);
    expect(cubit.state.error, isNotEmpty);
    expect(controller.preview, isNull);
    await cubit.close(); await controller.close();
  });
}
