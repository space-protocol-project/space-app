import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/generated/space/v1/voice.pb.dart';
import 'package:space_client/src/voice_network.dart';

void main() {
  test('Согласование 32 участников и совместимость с прежним сервером', () {
    expect(
      VoiceNetworkSettings.fromReply(GetVoiceConfigurationResponse())
          .mediaCapacity,
      8,
    );
    expect(
      VoiceNetworkSettings.fromReply(
        GetVoiceConfigurationResponse(mediaCapacity: 32),
      ).mediaCapacity,
      32,
    );
    expect(
      () => VoiceNetworkSettings.fromReply(
        GetVoiceConfigurationResponse(mediaCapacity: 33),
      ),
      throwsStateError,
    );
  });

  GetVoiceConfigurationResponse turn() => GetVoiceConfigurationResponse(
    relayOnly: true,
    expiresAtUnix: Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600),
    iceServers: [
      VoiceIceServer(
        urls: ['turn:relay.example.org:3478?transport=tcp'],
        username: 'temporary',
        credential: 'temporary-password',
      ),
    ],
  );

  test('TURN передаётся WebRTC вместе с relay-only без общей тайны', () {
    final configuration = VoiceNetworkSettings.fromReply(turn());
    expect(configuration.peerConfiguration['iceTransportPolicy'], 'relay');
    expect(configuration.iceServers.single['urls'], [
      'turn:relay.example.org:3478?transport=tcp',
    ]);
    expect(configuration.iceServers.single['username'], 'temporary');
    expect(configuration.iceServers.single['credential'], 'temporary-password');
  });
  test('Без конфигурации сохраняется локальное соединение', () {
    final configuration = VoiceNetworkSettings.fromReply(
      GetVoiceConfigurationResponse(),
    );
    expect(configuration.iceServers, isEmpty);
    expect(configuration.peerConfiguration['iceTransportPolicy'], 'all');
  });
  test('Нельзя молча заменить обязательный TURN прямым маршрутом', () {
    final response = turn()..iceServers.clear();
    expect(() => VoiceNetworkSettings.fromReply(response), throwsStateError);
  });
  test('Истёкший пароль, пустой доступ и посторонние схемы отклоняются', () {
    final expired = turn()..expiresAtUnix = Int64(1);
    final missing = turn();
    missing.iceServers.single.credential = '';
    final wrong = turn();
    wrong.iceServers.single.urls[0] = 'https://relay.example.org';
    for (final response in [expired, missing, wrong]) {
      expect(() => VoiceNetworkSettings.fromReply(response), throwsStateError);
    }
  });
}
