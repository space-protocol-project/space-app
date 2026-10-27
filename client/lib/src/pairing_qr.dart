import 'dart:convert';
import 'dart:typed_data';

import 'core.dart';
import 'generated/space/v1/space.pb.dart';
import 'recovery_qr.dart';
import 'space_link_qr.dart';

const pairingQrPrefix = 'space-pairing:v2:';

// QR содержит только публичный запрос. Poll token и seed сюда не попадают.
class PairingQr {
  PairingQr(
    this.serverId,
    this.serverKey,
    this.origin,
    this.code,
    this.id,
    this.publicKey,
    this.administrative,
    this.expiresAt, {
    this.fullManagement = false,
  });
  final String serverId, serverKey, origin, code, id, publicKey;
  final bool administrative;
  final bool fullManagement;
  final int expiresAt;

  factory PairingQr.request(Discovery server, CreatePairingResponse request) =>
      PairingQr(
        server.serverId,
        url64(server.publicKey),
        server.origin.toString(),
        request.code,
        request.pairing.id,
        url64(request.pairing.publicKey),
        request.pairing.administrative,
        request.pairing.expiresAt.toInt(),
        fullManagement: request.pairing.fullManagement,
      );

  String encode() =>
      pairingQrPrefix +
      base64Url.encode(
        utf8.encode(
          jsonEncode({
            'server': serverId,
            'key': serverKey,
            'origin': origin,
            'code': code,
            'id': id,
            'device': publicKey,
            'manage': administrative,
            'full': fullManagement,
            'expires': expiresAt,
          }),
        ),
      );

  static PairingQr parse(String text) {
    if (text.length > 2048 || !text.startsWith(pairingQrPrefix)) {
      throw const FormatException('QR');
    }
    final data = jsonDecode(
      utf8.decode(base64Url.decode(text.substring(pairingQrPrefix.length))),
    );
    if (data is! Map || data.length != 9) throw const FormatException('QR');
    if (data case {
      'server': String server,
      'key': String key,
      'origin': String origin,
      'code': String code,
      'id': String id,
      'device': String device,
      'manage': bool manage,
      'full': bool full,
      'expires': int expires,
    }) {
      final result = PairingQr(
        server,
        key,
        origin,
        code,
        id,
        device,
        manage,
        expires,
        fullManagement: full,
      );
      result._validate();
      return result;
    }
    throw const FormatException('QR');
  }

  void _validate() {
    if (fullManagement && !administrative) throw const FormatException('QR');
    if (!RegExp(r'^pc_[A-Za-z0-9_-]{43}$').hasMatch(code) ||
        !RegExp(r'^pr_[A-Za-z0-9_-]{43}$').hasMatch(id) ||
        !RegExp(r'^[A-Za-z0-9_-]{43}$').hasMatch(serverKey) ||
        !RegExp(r'^[A-Za-z0-9_-]{43}$').hasMatch(publicKey) ||
        serverId.isEmpty ||
        serverId.length > 128) {
      throw const FormatException('QR');
    }
    final uri = Uri.parse(origin);
    if (!['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw const FormatException('QR');
    }
    ensureActive();
  }

  void ensureActive() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (expiresAt <= now || expiresAt > now + 305) {
      throw const FormatException('QR');
    }
  }

  void checkServer(Discovery server) {
    ensureActive();
    if (serverId != server.serverId ||
        serverKey != url64(server.publicKey) ||
        origin != server.origin.toString()) {
      throw const FormatException('QR');
    }
  }

  void checkPair(Pairing pair) {
    ensureActive();
    if (id != pair.id ||
        publicKey != url64(pair.publicKey) ||
        administrative != pair.administrative ||
        fullManagement != pair.fullManagement ||
        expiresAt != pair.expiresAt.toInt()) {
      throw const FormatException('QR');
    }
  }
}

Uint8List pairingPng(String text) {
  PairingQr.parse(text);
  return qrPng(text);
}

String? pairingQrFromImage(Uint8List bytes) {
  final text = qrTextFromImage(bytes);
  if (text == null) return null;
  try {
    PairingQr.parse(text);
    return text;
  } catch (_) {
    return null;
  }
}
