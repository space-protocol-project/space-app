import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/strings.dart';
import '../src/attachments.dart';
import 'attachment_widgets.dart';
import 'emoji_picker.dart';
import 'message_input_surface.dart';
import 'accent_controls.dart';

/// Одно поле ввода для чата и форума.
class MessageDraftField extends StatelessWidget {
  const MessageDraftField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.hint,
    this.fieldKey,
    this.focusNode,
    this.maxLength = 1024,
  });
  final TextEditingController controller;
  final bool enabled;
  final String hint;
  final Key? fieldKey;
  final FocusNode? focusNode;
  final int maxLength;

  @override
  Widget build(BuildContext context) => TextField(
    key: fieldKey,
    focusNode: focusNode,
    controller: controller,
    enabled: enabled,
    minLines: 3,
    maxLines: null,
    maxLength: maxLength,
    decoration: messageInputDecoration(hint),
  );
}

class MessageComposerActions extends StatelessWidget {
  const MessageComposerActions({
    super.key,
    required this.controller,
    required this.enabled,
    required this.send,
    required this.queue,
    this.canAttach = false,
    this.editing = false,
    this.sendKey,
  });
  final TextEditingController controller;
  final bool enabled, canAttach, editing;
  final VoidCallback send;
  final AttachmentQueue queue;
  final Key? sendKey;

  @override
  Widget build(BuildContext context) => Row(
    key: const ValueKey('composer-actions'),
    children: [
      if (canAttach) AttachFileButton(queue: queue, enabled: enabled),
      EmojiButton(controller: controller, enabled: enabled),
      const Spacer(),
      IconButton.filled(
        key: sendKey,
        onPressed: enabled ? send : null,
        tooltip: editing
            ? context.strings.saveMessage
            : context.strings.sendMessage,
        style: sendButtonStyle(context),
        icon: Icon(editing ? Icons.check : Icons.arrow_upward),
      ),
    ],
  );
}

KeyEventResult messageDraftKeyEvent(
  KeyEvent event,
  TextEditingController controller, {
  required bool sendWithShift,
  required VoidCallback send,
  int maxLength = 1024,
}) {
  final keyboard = HardwareKeyboard.instance;
  final composing = controller.value.composing;
  if (event is KeyUpEvent ||
      ![
        LogicalKeyboardKey.enter,
        LogicalKeyboardKey.numpadEnter,
      ].contains(event.logicalKey) ||
      keyboard.isControlPressed ||
      keyboard.isAltPressed ||
      keyboard.isMetaPressed ||
      (composing.isValid && !composing.isCollapsed)) {
    return KeyEventResult.ignored;
  }
  if (event is KeyDownEvent) {
    if (keyboard.isShiftPressed == sendWithShift) {
      send();
    } else {
      _insertMessageNewline(controller, maxLength);
    }
  }
  return KeyEventResult.handled;
}

void _insertMessageNewline(TextEditingController controller, int maxLength) {
  final value = controller.value, selection = controller.selection;
  final start = selection.isValid ? selection.start : value.text.length;
  final end = selection.isValid ? selection.end : value.text.length;
  final updated = value.text.replaceRange(start, end, '\n');
  if (updated.characters.length <= maxLength) {
    controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: start + 1),
    );
  }
}
