import 'package:cryptography/cryptography.dart';

import 'core.dart';
import 'recovery_card.dart';

const recoverySpacesKind = 'space-recovery-spaces';
const maxRecoverySpaces = 12;

Future<Map<String, dynamic>> recoveryAccessPayload(DeviceRecord record) async {
  if (record.rootSeed.length != 32) {
    throw FormatException(
      'Нет ключа восстановления для ${record.origin}. Нужна исходная карточка.',
    );
  }
  await record.identity();
  final pair = await Ed25519().newKeyPairFromSeed(record.rootSeed);
  return {
    'v': record.rootHistory.isEmpty ? 1 : 2,
    'origin': record.origin,
    'endpoint': record.connectionAddress,
    'endpoints': record.endpoints.map((value) => value.toJson()).toList(),
    'endpoint_revision': record.endpointRevision,
    'endpoint_digest': record.endpointDigest,
    'server_id': record.serverId,
    'server_key': record.serverKey,
    if (record.tlsFingerprint.isNotEmpty)
      'tls_fingerprint': record.tlsFingerprint,
    'root_public_key': url64((await pair.extractPublicKey()).bytes),
    'credential': 'root',
    'secret': url64(record.rootSeed),
    if (record.rootHistory.isNotEmpty) 'root_history': record.rootHistory,
  };
}

Future<Map<String, dynamic>> recoverySpacesPayload(
  List<DeviceRecord> records,
) async {
  _checkCount(records.length);
  final cards = <Map<String, dynamic>>[];
  final origins = <String>{};
  for (final record in records) {
    if (!origins.add(record.origin)) {
      throw const FormatException('В архиве повторяется пространство');
    }
    cards.add(await recoveryAccessPayload(record));
  }
  return {'v': 1, 'kind': recoverySpacesKind, 'cards': cards};
}

/// Все записи проверяются до сетевых запросов и изменения хранилища.
Future<List<DeviceRecord>> restoreAccessInWorker(List<String> input) async {
  final payload = await openRecoveryCard(input[0], input[1]);
  if (!payload.containsKey('kind')) return [await recordFromRecovery(payload)];
  if (payload['kind'] != recoverySpacesKind || payload['v'] != 1) {
    throw const FormatException('Неподдерживаемый архив пространств');
  }
  final cards = payload['cards'];
  if (cards is! List) {
    throw const FormatException('Повреждён список пространств');
  }
  _checkCount(cards.length);
  final records = <DeviceRecord>[];
  final origins = <String>{};
  for (final card in cards) {
    if (card is! Map<String, dynamic> || card.containsKey('kind')) {
      throw const FormatException('Повреждена карточка пространства');
    }
    final record = await recordFromRecovery(card);
    if (!origins.add(record.origin)) {
      throw const FormatException('В архиве повторяется пространство');
    }
    records.add(record);
  }
  return records;
}

void _checkCount(int count) {
  if (count < 1 || count > maxRecoverySpaces) {
    throw const FormatException(
      'Архив должен содержать от 1 до 12 пространств',
    );
  }
}
