import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../key_vault.dart';
import '../generated/space/v1/extensions_p1.pb.dart';

typedef ExtensionCommandBinding = ({
  String server,
  String space,
  String installation,
  String principal,
});

String commandBindingKey(ExtensionCommandBinding b) => jsonEncode([
  b.server, b.space, b.installation, b.principal,
]);

// Снимок содержит точные protobuf-байты. Токен сессии в него не входит.
class ExtensionCommandSnapshot {
  ExtensionCommandSnapshot(this.binding, ExecuteExtensionCommandRequest request)
    : bytes = List<int>.unmodifiable(request.writeToBuffer());

  ExtensionCommandSnapshot._(this.binding, this.bytes);
  final String binding;
  final List<int> bytes;
  ExecuteExtensionCommandRequest get request =>
      ExecuteExtensionCommandRequest.fromBuffer(bytes);

  String encode() => jsonEncode({
    'version': 1, 'binding': binding, 'request': base64Encode(bytes),
  });

  static ExtensionCommandSnapshot decode(String raw) {
    if (raw.length > 40000) throw const FormatException('Большой снимок');
    final value = jsonDecode(raw);
    if (value is! Map<String, dynamic> || value.length != 3 ||
        value['version'] != 1 || value['binding'] is! String ||
        value['request'] is! String) {
      throw const FormatException('Некорректный снимок');
    }
    final bytes = base64Decode(value['request'] as String);
    final request = ExecuteExtensionCommandRequest.fromBuffer(bytes);
    validateNewExtensionCommand(request, contextRequired: true);
    return ExtensionCommandSnapshot._(
      value['binding'] as String, List<int>.unmodifiable(bytes),
    );
  }
}

void validateNewExtensionCommand(
  ExecuteExtensionCommandRequest r, {bool contextRequired = false}
) {
  if (r.effect != ExtensionCommandEffect.EXTENSION_COMMAND_EFFECT_MUTATION ||
      r.instanceId.isEmpty || r.command.isEmpty ||
      !RegExp(r'^[A-Za-z0-9_-]{16,128}$').hasMatch(r.idempotencyKey) ||
      r.payloadJson.length > 16384) {
    throw const FormatException('Некорректная команда');
  }
  if (contextRequired &&
      (!RegExp(r'^[0-9a-f]{32}$').hasMatch(r.historyId) ||
       !RegExp(r'^[0-9a-f]{32}$').hasMatch(r.retryLeaseId))) {
    throw const FormatException('Отсутствует контекст команды');
  }
}

// Один незавершённый запрос на привязку в экспериментальном исполнителе.
// Приложение передаёт защищённое хранилище; ошибка записи запрещает отправку.
class ExtensionCommandJournal {
  ExtensionCommandJournal(this.storage, ExtensionCommandBinding binding)
    : bindingKey = commandBindingKey(binding),
      key = 'space.p1.command.${sha256.convert(utf8.encode(commandBindingKey(binding)))}';
  final SecureKeyStorage storage;
  final String bindingKey;
  final String key;

  Future<ExtensionCommandSnapshot?> read() async {
    final raw = await storage.read(key: key);
    if (raw == null) return null;
    final snapshot = ExtensionCommandSnapshot.decode(raw);
    if (snapshot.binding != bindingKey) {
      throw const FormatException('Изменилась привязка команды');
    }
    return snapshot;
  }

  Future<void> save(ExtensionCommandSnapshot snapshot) async {
    if (snapshot.binding != bindingKey || await read() != null) {
      throw StateError('Есть незавершённая команда или другая привязка');
    }
    await storage.write(key: key, value: snapshot.encode());
  }
}
