import 'package:flutter/services.dart';
import 'package:space_client/src/chat_history.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/saved_drafts.dart';
import 'package:space_client/src/voice_audio_settings.dart';
import 'package:space_client/src/voice_device_preferences.dart';
import 'package:space_client/src/voice_shortcut.dart';

import 'clean_install_support.dart';

OutboxScope cleanScope(DeviceRecord record, String principal) =>
    OutboxScope(record.origin, record.serverId, principal, record.grantId);

Future<void> seedCleanData(CleanContext c, SpaceSession owner) async {
  SavedDrafts.save(
    '${owner.record.origin}/private',
    'Черновик чистой установки',
  );
  await SavedDrafts.flush();
  await SavedVoiceDevicePreferences().save(
    const VoiceDeviceChoice(
      audio: VoiceAudioSettings(
        pushToTalk: true,
        shortcut: VoiceShortcut(key: LogicalKeyboardKey.space, control: true),
      ),
    ),
  );
  final message = await owner.send(
    'Обычная история до переноса',
    'clean-history-message',
  );
  final history =
      ChatHistory(
          serverId: owner.record.serverId,
          principalId: owner.principalId,
          grantId: owner.record.grantId,
        )
        ..title = 'История чистой установки'
        ..channels = owner.availableChannels;
  history.merge([message], DateTime.now());
  history.favorites.add('general/${message.id}');
  await LocalChatHistory(storage: c.storage)
      .write(owner.record.origin, history);
  await LocalChatOutbox(
    storage: c.storage,
    directory: () async => c.files,
  ).change(
    cleanScope(owner.record, owner.principalId),
    (_) => [
      PendingMessage(
        key: 'clean-queued-message',
        channelId: 'general',
        text: 'Сообщение в очереди',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    ],
  );
}

Future<void> verifyCleanData(CleanContext c) async {
  final expected = await c.expected();
  final origin = expected['origin'] as String;
  requireClean(
    await SavedDrafts.load('$origin/private') == 'Черновик чистой установки',
    'Потерян черновик',
  );
  final audio = (await SavedVoiceDevicePreferences().load()).audio;
  requireClean(
    audio.pushToTalk &&
        audio.shortcut.control &&
        audio.shortcut.key == LogicalKeyboardKey.space,
    'Не сохранены настройки рации',
  );
  final history = await LocalChatHistory(storage: c.storage).read(origin);
  requireClean(
    history != null &&
        history.title == 'История чистой установки' &&
        history.messages('general', DateTime.now()).single.text ==
            'Обычная история до переноса' &&
        history.favorites.length == 1,
    'Потеряна обычная история или избранное',
  );
  final record = await c.vault.load(origin);
  requireClean(record != null, 'Не восстановлена личность');
  final pending = await LocalChatOutbox(
    storage: c.storage,
    directory: () async => c.files,
  ).read(cleanScope(record!, expected['principal'] as String));
  requireClean(
    pending.length == 1 && pending.single.text == 'Сообщение в очереди',
    'Потеряна очередь',
  );
}
