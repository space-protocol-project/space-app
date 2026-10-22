import 'generated/space/v1/voice.pb.dart';

class VoiceNetworkSettings {
  const VoiceNetworkSettings.local()
    : iceServers = const [],
      relayOnly = false,
      expiresAtUnix = 0,
      mediaCapacity = 8;
  const VoiceNetworkSettings._(
    this.iceServers,
    this.relayOnly,
    this.expiresAtUnix,
    this.mediaCapacity,
  );
  final List<Map<String, dynamic>> iceServers;
  final bool relayOnly;
  final int expiresAtUnix;
  final int mediaCapacity;

  factory VoiceNetworkSettings.fromReply(GetVoiceConfigurationResponse reply) {
    if (reply.iceServers.length > 2) {
      throw StateError('Некорректная конфигурация ICE');
    }
    final entries = reply.iceServers.map(_entry).toList(growable: false);
    final hasTurn = entries.any((entry) => entry.containsKey('username'));
    final expiry = reply.expiresAtUnix.toInt();
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if ((reply.relayOnly && !hasTurn) ||
        (hasTurn && (expiry < now + 30 || expiry > now + 87000))) {
      throw StateError('Недействительный срок доступа к TURN');
    }
    final capacity = reply.mediaCapacity == 0 ? 8 : reply.mediaCapacity;
    if (capacity != 8 && capacity != 32) {
      throw StateError('Некорректная вместимость голосового сервера');
    }
    return VoiceNetworkSettings._(entries, reply.relayOnly, expiry, capacity);
  }

  static Map<String, dynamic> _entry(VoiceIceServer entry) {
    if (entry.urls.isEmpty || entry.urls.length > 8) {
      throw StateError('Некорректный список ICE');
    }
    final isTurn = entry.urls.first.startsWith('turn');
    for (final url in entry.urls) {
      if (!_validURL(url, isTurn)) {
        throw StateError('Некорректный адрес ICE');
      }
    }
    if (isTurn &&
        (entry.username.isEmpty ||
            entry.credential.isEmpty ||
            entry.username.length > 128 ||
            entry.credential.length > 256)) {
      throw StateError('Некорректный доступ к TURN');
    }
    return {
      'urls': entry.urls.toList(growable: false),
      if (isTurn) 'username': entry.username,
      if (isTurn) 'credential': entry.credential,
    };
  }

  static bool _validURL(String url, bool turn) {
    if (url.length > 256 || RegExp(r'[\s@]').hasMatch(url)) {
      return false;
    }
    final uri = Uri.tryParse(url);
    if (uri == null || uri.path.isEmpty || uri.hasFragment) {
      return false;
    }
    return turn ? ['turn', 'turns'].contains(uri.scheme) : uri.scheme == 'stun';
  }

  Map<String, dynamic> get peerConfiguration => {
    'iceServers': iceServers,
    'iceTransportPolicy': relayOnly ? 'relay' : 'all',
    'sdpSemantics': 'unified-plan',
  };
}
