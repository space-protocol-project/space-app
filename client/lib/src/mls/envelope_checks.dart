import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../rpc_clients.dart';

// Служебные поля сервера не подтверждают доставку другого ciphertext.
void requireMlsAcknowledgement(
  PublishMlsRequest request,
  MlsEnvelope envelope,
  Map<String, dynamic> scope,
) {
  if (envelope.sequence.toInt() <= 0 ||
      envelope.authorGrantId != scope['grant_id'] ||
      envelope.authorId != scope['principal_id'] ||
      envelope.kind != request.kind ||
      envelope.epoch != request.expectedEpoch ||
      base64Encode(envelope.requestId) != base64Encode(request.requestId) ||
      base64Encode(envelope.ciphertext) != base64Encode(request.ciphertext) ||
      envelope.addedGrantId != request.addGrantId ||
      envelope.removedGrantId != request.removeGrantId ||
      envelope.newManagerGrantId != request.newManagerGrantId ||
      base64Encode(envelope.welcome) != base64Encode(request.welcome)) {
    throw StateError('Подтверждение сервера не соответствует MLS-запросу');
  }
}

String mlsReceipt(MlsEnvelope envelope) => sha256
    .convert(
      utf8.encode(
        jsonEncode([
          envelope.sequence.toString(),
          envelope.epoch.toString(),
          envelope.kind,
          envelope.authorId,
          envelope.authorGrantId,
          base64Encode(envelope.requestId),
          base64Encode(envelope.ciphertext),
          envelope.addedGrantId,
          envelope.removedGrantId,
          envelope.newManagerGrantId,
        ]),
      ),
    )
    .toString();

void requireMlsSequence(Map<String, dynamic> channel, MlsEnvelope envelope) {
  final previous = channel['cursor'] as int;
  final next = envelope.sequence.toInt();
  if (next <= previous || (channel['joined'] == true && next != previous + 1)) {
    throw StateError('Нарушен порядок событий MLS');
  }
}

void requireMlsPage(
  Map<String, dynamic> channel,
  ListMlsEnvelopesResponse page,
) {
  if (page.envelopes.length > 20 ||
      page.writeToBuffer().length > 2 * 1024 * 1024 + 8192) {
    throw StateError('Превышен предел страницы MLS');
  }
  final next = Map<String, dynamic>.from(channel);
  for (final envelope in page.envelopes) {
    requireMlsSequence(next, envelope);
    if (!const {
      'commit',
      'update',
      'application',
      'transfer',
    }.contains(envelope.kind)) {
      throw StateError('Неизвестный тип MLS-пакета');
    }
    next['cursor'] = envelope.sequence.toInt();
    next['joined'] = true;
  }
  if (page.nextSequence.toInt() != next['cursor']) {
    throw StateError('Курсор страницы MLS не совпадает с событиями');
  }
}
