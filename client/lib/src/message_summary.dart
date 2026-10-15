import 'generated/space/v1/space.pb.dart';

String messageSummary(Content message) => [
  if (message.text.trim().isNotEmpty) message.text,
  for (final asset in message.attachments) asset.name,
].join('\n');
