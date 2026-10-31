import 'package:connectrpc/connect.dart' as connect;
import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/extensions_p1/command_cubit.dart';
import 'package:space_client/src/extensions_p1/command_snapshot.dart';
import 'package:space_client/src/extensions_p1/command_transport.dart';
import 'package:space_client/src/generated/space/v1/extensions_p1.pb.dart';

const binding = (server: 'https://space.test', space: 'space1', installation: 'install1', principal: 'alice');

class MemoryJournalStorage implements SecureKeyStorage {
  final values = <String, String>{};
  bool failWrite = false;
  @override
  Future<String?> read({required String key}) async => values[key];
  @override
  Future<void> write({required String key, required String value}) async {
    if (failWrite) throw StateError('Запись недоступна');
    values[key] = value;
  }
  @override
  Future<void> delete({required String key}) async { values.remove(key); }
}

class ProbeTransport implements ExtensionCommandTransport {
  final sent = <List<int>>[];
  int contexts = 0;
  int reconciles = 0;
  int cancellations = 0;
  connect.Code? firstFailure = connect.Code.unavailable;
  bool confirmed = true;
  void Function()? afterFailure;
  @override
  Future<GetExtensionMutationContextResponse> context(String instance) async {
    contexts++;
    return GetExtensionMutationContextResponse(historyId: 'a' * 32, retryLeaseId: 'b' * 32)
      ..retryWindowRemainingMs = Int64(30000);
  }
  @override
  Future<ExecuteExtensionCommandResponse> execute(ExecuteExtensionCommandRequest request) async {
    sent.add(request.writeToBuffer());
    if (sent.length == 1 && firstFailure != null) {
      afterFailure?.call();
      throw connect.ConnectException(firstFailure!, 'Потеря ответа');
    }
    return ExecuteExtensionCommandResponse(effect: request.effect, stateRevision: request.expectedStateRevision + 1);
  }
  @override
  Future<ReconcileExtensionCommandResponse> reconcile(ExecuteExtensionCommandRequest request) async {
    reconciles++;
    return ReconcileExtensionCommandResponse(
      outcome: confirmed ? ExtensionCommandOutcome.EXTENSION_COMMAND_OUTCOME_CONFIRMED : ExtensionCommandOutcome.EXTENSION_COMMAND_OUTCOME_UNKNOWN,
      receipt: confirmed ? ExecuteExtensionCommandResponse(effect: request.effect, stateRevision: request.expectedStateRevision + 1) : null,
    );
  }
  @override
  void cancel() { cancellations++; }
}

ExecuteExtensionCommandRequest command() => ExecuteExtensionCommandRequest(
  instanceId: 'demo', command: 'acknowledge', payloadJson: [123, 125],
  effect: ExtensionCommandEffect.EXTENSION_COMMAND_EFFECT_MUTATION,
  idempotencyKey: 'client-command-001',
);

void main() {
  late MemoryJournalStorage storage;
  late ExtensionCommandJournal journal;
  late ProbeTransport transport;
  late ExtensionCommandCubit cubit;
  var current = binding;
  setUp(() {
    current = binding;
    storage = MemoryJournalStorage();
    journal = ExtensionCommandJournal(storage, binding);
    transport = ProbeTransport();
    cubit = ExtensionCommandCubit(transport, journal, () => current);
  });
  tearDown(() async { await cubit.close(); });

  test('Потеря ответа: повторяет те же байты и сохраняет снимок до отправки', () async {
    final input = command();
    final pending = cubit.start(input);
    input.payloadJson = [91, 93];
    await pending;
    expect(cubit.state.phase, 'confirmed');
    expect(transport.sent, hasLength(2));
    expect(transport.sent[0], transport.sent[1]);
    expect((await journal.read())!.bytes, transport.sent[0]);
    expect((await journal.read())!.request.payloadJson, [123, 125]);
    expect(transport.contexts, 1);
  });

  test('Ошибка сохранения запрещает первую отправку', () async {
    storage.failWrite = true;
    await expectLater(cubit.start(command()), throwsStateError);
    expect(transport.sent, isEmpty);
  });

  test('Новая команда не перезаписывает незавершённую', () async {
    await cubit.start(command());
    final next = ExtensionCommandCubit(transport, journal, () => current);
    await expectLater(next.start(command()), throwsStateError);
    await next.close();
    expect(transport.contexts, 1);
  });

  test('После повторного открытия только сверка, без нового окна и исполнения', () async {
    transport.firstFailure = connect.Code.unauthenticated;
    await cubit.start(command());
    expect(cubit.state.phase, 'reauthenticate');
    final reopened = ExtensionCommandCubit(transport, ExtensionCommandJournal(storage, binding), () => current);
    await reopened.reconcile();
    expect(reopened.state.phase, 'confirmed');
    expect(transport.sent, hasLength(1));
    expect(transport.contexts, 1);
    await reopened.close();
  });

  test('UNKNOWN сохраняет неопределённость и не повторяет команду', () async {
    transport.firstFailure = connect.Code.failedPrecondition;
    transport.confirmed = false;
    await cubit.start(command());
    await cubit.reconcile();
    expect(cubit.state.unknown, isTrue);
    expect(transport.sent, hasLength(1));
  });

  test('Смена principal после потери ответа останавливает повтор', () async {
    transport.afterFailure = () { current = (server: binding.server, space: binding.space, installation: binding.installation, principal: 'bob'); };
    await cubit.start(command());
    expect(transport.sent, hasLength(1));
    expect(cubit.state.unknown, isTrue);
    await cubit.reconcile();
    expect(transport.reconciles, 0);
  });

  test('Отмена во время задержки запрещает следующую отправку', () async {
    final waiting = cubit.stream.firstWhere((s) => s.phase == 'retry_same_request');
    final pending = cubit.start(command());
    await waiting;
    cubit.cancel();
    await pending;
    expect(transport.sent, hasLength(1));
    expect(cubit.state.unknown, isTrue);
    expect(transport.cancellations, 1);
  });

  test('Сохранённый контекст нельзя заменить новым', () async {
    final old = command()..historyId = 'a' * 32;
    await expectLater(cubit.start(old), throwsStateError);
    expect(transport.contexts, 0);
  });
}
