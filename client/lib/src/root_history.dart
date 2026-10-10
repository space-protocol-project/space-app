import 'dart:convert';

import 'package:cryptography/cryptography.dart';

String _url(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');
List<int> _bytes(dynamic value, int? length) {
  if (value is! String || !RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(value)) {
    throw const FormatException('Повреждено доказательство смены ключа');
  }
  final bytes = base64Url.decode(base64Url.normalize(value));
  if (_url(bytes) != value || (length != null && bytes.length != length)) {
    throw const FormatException('Повреждено доказательство смены ключа');
  }
  return bytes;
}

class RootIdentity {
  RootIdentity(this.principalId, this.epoch, this.publicKey);
  final String principalId;
  final int epoch;
  final List<int> publicKey;
}

Future<String> rootPrincipal(List<int> key) async =>
    'u_${(await Sha256().hash(key)).bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';

const rotationFields =
    'auth_epoch,challenge_id,expires_at,issued_at,new_device_public_key,new_root_public_key,nonce,old_root_public_key,operation_id,origin,principal_id,purpose,scopes,server_id,v';

Future<RootIdentity> verifyRootHistory(
  List<Map<String, dynamic>> history,
  List<int> currentRoot,
  String origin,
  String serverId,
) async {
  if (currentRoot.length != 32 || history.length > 16) {
    throw const FormatException(
      'История корневых ключей слишком большая или повреждена',
    );
  }
  if (history.isEmpty) {
    return RootIdentity(await rootPrincipal(currentRoot), 1, currentRoot);
  }
  String? principal;
  List<int>? previous;
  var issuedBefore = 0;
  final seenRoots = <String>{};
  for (var index = 0; index < history.length; index++) {
    final proof = history[index];
    final raw = _bytes(proof['transcript'], null);
    if (raw.length > 2048) {
      throw const FormatException('Доказательство слишком большое');
    }
    final text = utf8.decode(raw);
    final t = jsonDecode(text) as Map<String, dynamic>;
    final fields = t.keys.toList()..sort();
    final canonical = jsonEncode({for (final name in fields) name: t[name]});
    final oldRoot = _bytes(t['old_root_public_key'], 32);
    final newRoot = _bytes(t['new_root_public_key'], 32);
    final device = _bytes(t['new_device_public_key'], 32);
    principal ??= await rootPrincipal(oldRoot);
    if (index == 0) seenRoots.add(_url(oldRoot));
    if (!seenRoots.add(_url(newRoot))) {
      throw const FormatException('История повторно использует прежний root');
    }
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final integers = ['auth_epoch', 'expires_at', 'issued_at', 'v'];
    final numbers = integers.every(
      (k) =>
          t[k] is int && (t[k] as int) > 0 && (t[k] as int) < 9007199254740991,
    );
    final scopes = jsonEncode(t['scopes']);
    if (!numbers ||
        fields.join(',') != rotationFields ||
        canonical != text ||
        t['v'] != 1 ||
        t['purpose'] != 'identity.root.rotate' ||
        t['auth_epoch'] != index + 1 ||
        t['principal_id'] != principal ||
        t['origin'] != origin ||
        t['server_id'] != serverId ||
        (previous != null && _url(oldRoot) != _url(previous)) ||
        _url(newRoot) == _url(oldRoot) ||
        _url(device) == _url(newRoot) ||
        _url(device) == _url(oldRoot) ||
        t['issued_at'] < issuedBefore ||
        t['issued_at'] > now + 5 ||
        t['expires_at'] <= t['issued_at'] ||
        t['expires_at'] - t['issued_at'] > 120 ||
        !RegExp(r'^rc_[A-Za-z0-9_-]{43}$')
            .hasMatch(t['challenge_id'] as String) ||
        !RegExp(r'^ro_[A-Za-z0-9_-]{43}$')
            .hasMatch(t['operation_id'] as String) ||
        _bytes(t['nonce'], 32).length != 32 ||
        (scopes != '["chat.read","chat.write"]' &&
            scopes != '["chat.read","chat.write","space.manage"]')) {
      throw const FormatException(
        'Цепочка смены root не соответствует идентичности',
      );
    }
    for (final role in ['old', 'new']) {
      final signed = [
        ...utf8.encode('space/root.rotate/$role/v1\u0000'),
        ...raw,
      ];
      final signature = Signature(
        _bytes(proof['${role}_signature'], 64),
        publicKey: SimplePublicKey(
          role == 'old' ? oldRoot : newRoot,
          type: KeyPairType.ed25519,
        ),
      );
      if (!await Ed25519().verify(signed, signature: signature)) {
        throw const FormatException('Подпись смены root недействительна');
      }
    }
    previous = newRoot;
    issuedBefore = t['issued_at'] as int;
  }
  if (_url(previous!) != _url(currentRoot)) {
    throw const FormatException(
      'Текущий root не завершает проверенную цепочку',
    );
  }
  return RootIdentity(principal!, history.length + 1, currentRoot);
}
