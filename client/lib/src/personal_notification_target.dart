import 'dart:convert';

class PersonalNotificationTarget {
  const PersonalNotificationTarget(
    this.origin,
    this.principal,
    this.channel,
    this.sequence,
    this.id,
  );
  final String origin, principal, channel, id;
  final int sequence;

  List<Object> get payload => [
    'personal',
    origin,
    principal,
    channel,
    sequence,
    id,
  ];

  static PersonalNotificationTarget? decode(String payload) {
    try {
      if (payload.length > 2048) return null;
      if (jsonDecode(payload) case [
        'personal',
        String origin,
        String principal,
        String channel,
        int sequence,
        String id,
      ]) {
        final valid = [
          origin,
          principal,
          channel,
        ].every((part) => part.isNotEmpty && part.length <= 1024);
        if (!valid ||
            id.isEmpty ||
            id.length > 128 ||
            sequence <= 0 ||
            sequence >= 9223372036854775807) {
          return null;
        }
        return PersonalNotificationTarget(
          origin,
          principal,
          channel,
          sequence,
          id,
        );
      }
    } catch (_) {
      // Повреждённая цель не становится адресом подключения.
    }
    return null;
  }
}
