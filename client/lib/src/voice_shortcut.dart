import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Запись сочетания временно закрывает передачу даже при уже удерживаемой клавише.
final voiceShortcutRecording = ValueNotifier(false);

class VoiceShortcut {
  const VoiceShortcut({
    this.key = LogicalKeyboardKey.f8,
    this.control = false,
    this.alt = false,
    this.shift = false,
    this.meta = false,
  });
  final LogicalKeyboardKey key;
  final bool control, alt, shift, meta;

  static bool usable(LogicalKeyboardKey key) =>
      key != LogicalKeyboardKey.escape &&
      !const [
        LogicalKeyboardKey.controlLeft,
        LogicalKeyboardKey.controlRight,
        LogicalKeyboardKey.shiftLeft,
        LogicalKeyboardKey.shiftRight,
        LogicalKeyboardKey.altLeft,
        LogicalKeyboardKey.altRight,
        LogicalKeyboardKey.metaLeft,
        LogicalKeyboardKey.metaRight,
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.shift,
        LogicalKeyboardKey.alt,
        LogicalKeyboardKey.meta,
      ].contains(key) &&
      key.keyId != 0;

  bool get modifiersMatch {
    final keyboard = HardwareKeyboard.instance;
    return keyboard.isControlPressed == control &&
        keyboard.isAltPressed == alt &&
        keyboard.isShiftPressed == shift &&
        keyboard.isMetaPressed == meta;
  }

  String get label => [
    if (control) 'Ctrl',
    if (alt) 'Alt',
    if (shift) 'Shift',
    if (meta) 'Meta',
    key == LogicalKeyboardKey.space ? 'Space' : key.keyLabel,
  ].join(' + ');

  static VoiceShortcut fromKey(LogicalKeyboardKey key) => VoiceShortcut(
    key: key,
    control: HardwareKeyboard.instance.isControlPressed,
    alt: HardwareKeyboard.instance.isAltPressed,
    shift: HardwareKeyboard.instance.isShiftPressed,
    meta: HardwareKeyboard.instance.isMetaPressed,
  );

  factory VoiceShortcut.fromJson(Object? value) {
    if (value is! Map) return const VoiceShortcut();
    final id = value['key'];
    final key = id is int
        ? LogicalKeyboardKey.findKeyByKeyId(id) ?? _unicodeKey(id)
        : null;
    if (key == null || !usable(key)) return const VoiceShortcut();
    return VoiceShortcut(
      key: key,
      control: value['control'] == true,
      alt: value['alt'] == true,
      shift: value['shift'] == true,
      meta: value['meta'] == true,
    );
  }

  static LogicalKeyboardKey? _unicodeKey(int id) {
    if (id < 0x20 ||
        id > 0x10ffff ||
        (id >= 0x7f && id <= 0x9f) ||
        (id >= 0xd800 && id <= 0xdfff)) {
      return null;
    }
    return LogicalKeyboardKey(id);
  }

  Map<String, Object> toJson() => {
    'key': key.keyId,
    'control': control,
    'alt': alt,
    'shift': shift,
    'meta': meta,
  };
}
