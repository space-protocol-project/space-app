import 'dart:convert';
import 'dart:typed_data';

import 'core.dart';
import 'directory_document.dart';
import 'recovery_qr.dart';
import 'space_link_qr.dart';

const directoryTransferPrefix = 'space-directory-pair:v1:';
const directoryNoiseProfile = 'Noise_XX_25519_ChaChaPoly_SHA256';

class DirectoryTransferQr {
  const DirectoryTransferQr(
    this.origin,
    this.server,
    this.key,
    this.tls,
    this.id,
    this.code,
    this.public,
    this.expires,
  );
  final String origin, server, key, tls, id, code, public;
  final int expires;
  String get context =>
      'space/directory-pair/v1\u0000$origin\u0000$server\u0000$key\u0000$id\u0000$expires';

  String encode() =>
      directoryTransferPrefix +
      base64Url.encode(
        utf8.encode(
          jsonEncode({
            'v': 1,
            'origin': origin,
            'server': server,
            'key': key,
            'tls': tls,
            'id': id,
            'code': code,
            'public': public,
            'expires': expires,
          }),
        ),
      );

  factory DirectoryTransferQr.parse(String text) {
    directoryRequire(
      text.length <= 3072 && text.startsWith(directoryTransferPrefix),
    );
    final data = directoryMap(
      jsonDecode(
        utf8.decode(
          base64Url.decode(text.substring(directoryTransferPrefix.length)),
        ),
      ),
      'code,expires,id,key,origin,public,server,tls,v',
    );
    directoryInt(data['v'], min: 1, max: 1);
    final result = switch (data) {
      {
        'origin': String origin,
        'server': String server,
        'key': String key,
        'tls': String tls,
        'id': String id,
        'code': String code,
        'public': String public,
        'expires': int expires,
      } => DirectoryTransferQr(
        directoryAddress(origin),
        directoryText(server, max: 128),
        directoryBytes(key, 32),
        directoryText(tls, max: 64),
        directoryText(id, max: 46),
        directoryText(code, max: 46),
        directoryBytes(public, 32),
        directoryInt(expires, min: 1),
      ),
      _ => throw const FormatException('Повреждён запрос передачи каталога'),
    };
    result._validate();
    return result;
  }

  void _validate() {
    directoryRequire(
      origin.length <= 512 &&
          Uri.parse(origin).path.isEmpty &&
          parseConnectionInput(origin).origin.toString() == origin,
    );
    directoryRequire(tls.isEmpty || RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(tls));
    directoryRequire(RegExp(r'^dt_[A-Za-z0-9_-]{43}$').hasMatch(id));
    directoryRequire(RegExp(r'^dc_[A-Za-z0-9_-]{43}$').hasMatch(code));
    directoryRequire(server.isNotEmpty);
    ensureActive();
  }

  void ensureActive() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    directoryRequire(expires > now && expires <= now + 305);
  }

  void checkServer(Discovery selected) {
    ensureActive();
    directoryRequire(
      origin == selected.origin.toString() &&
          server == selected.serverId &&
          key == url64(selected.publicKey) &&
          tls == selected.tlsFingerprint,
    );
  }
}

Uint8List directoryTransferPng(String text) {
  DirectoryTransferQr.parse(text);
  return qrPng(text);
}

String? directoryTransferFromImage(Uint8List bytes) {
  final text = qrTextFromImage(bytes);
  if (text == null) return null;
  try {
    DirectoryTransferQr.parse(text);
    return text;
  } catch (_) {
    return null;
  }
}
