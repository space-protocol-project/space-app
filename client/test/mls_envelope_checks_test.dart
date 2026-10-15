import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/mls/envelope_checks.dart';
import 'package:space_client/src/rpc_clients.dart';

void main() {
  test('Дубликаты, перестановка и пропуск отклоняют страницу до применения первого события', () {
    final channel = <String, dynamic>{'cursor': 0, 'joined': true};
    MlsEnvelope event(int sequence) =>
        MlsEnvelope(sequence: Int64(sequence), kind: 'application');
    for (final sequences in [
      [1, 1],
      [2, 1],
      [1, 3],
    ]) {
      expect(
        () => requireMlsPage(
          channel,
          ListMlsEnvelopesResponse(
            envelopes: sequences.map(event),
            nextSequence: Int64(sequences.last),
          ),
        ),
        throwsStateError,
      );
      expect(channel['cursor'], 0);
    }
  });
  final request = PublishMlsRequest(
    requestId: List.filled(16, 1),
    kind: 'application',
    expectedEpoch: Int64(2),
    ciphertext: [1, 2, 3],
  );
  const scope = {'grant_id': 'device', 'principal_id': 'person'};
  MlsEnvelope valid() => MlsEnvelope(
    sequence: Int64(7),
    requestId: request.requestId,
    kind: request.kind,
    epoch: request.expectedEpoch,
    ciphertext: request.ciphertext,
    authorGrantId: 'device',
    authorId: 'person',
  );

  test('Подменённое подтверждение отправки отклоняется', () {
    requireMlsAcknowledgement(request, valid(), scope);
    final mutations = <void Function(MlsEnvelope)>[
      (e) => e.ciphertext = [9],
      (e) => e.requestId = List.filled(16, 9),
      (e) => e.authorGrantId = 'other',
      (e) => e.authorId = 'other',
      (e) => e.kind = 'transfer',
      (e) => e.epoch = Int64(3),
      (e) => e.sequence = Int64.ZERO,
      (e) => e.addedGrantId = 'other',
      (e) => e.removedGrantId = 'other',
      (e) => e.newManagerGrantId = 'other',
      (e) => e.welcome = [9],
    ];
    for (final mutate in mutations) {
      final envelope = valid();
      mutate(envelope);
      expect(
        () => requireMlsAcknowledgement(request, envelope, scope),
        throwsStateError,
      );
      if (envelope.welcome.isEmpty) {
        expect(mlsReceipt(envelope), isNot(mlsReceipt(valid())));
      }
    }
  });

  test('После вступления события не пропускаются и не повторяются', () {
    final channel = <String, dynamic>{'cursor': 6, 'joined': true};
    requireMlsSequence(channel, valid());
    for (final sequence in [0, 5, 6, 8, 100]) {
      expect(
        () => requireMlsSequence(channel, valid()..sequence = Int64(sequence)),
        throwsStateError,
      );
    }
    requireMlsSequence({'cursor': 0, 'joined': false}, valid());
  });
}
