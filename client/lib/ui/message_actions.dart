import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../l10n/failure_strings.dart';
import '../src/chat_controller.dart';
import '../src/generated/space/v1/space.pb.dart';

class MessageActions extends StatelessWidget {
  const MessageActions({
    super.key,
    required this.controller,
    required this.message,
  });
  final ChatController controller;
  final Content message;

  @override
  Widget build(BuildContext context) => PopupMenuButton<bool>(
    tooltip: context.strings.messageActions,
    icon: const Icon(Icons.more_horiz, size: 18),
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(minWidth: 160),
    itemBuilder: (context) => [
      PopupMenuItem(value: false, child: Text(context.strings.editMessage)),
      PopupMenuItem(value: true, child: Text(context.strings.deleteMessage)),
    ],
    onSelected: (deleting) => showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MessageDialog(
        controller: controller,
        message: message,
        deleting: deleting,
      ),
    ),
  );
}

class _MessageDialog extends StatefulWidget {
  const _MessageDialog({
    required this.controller,
    required this.message,
    required this.deleting,
  });
  final ChatController controller;
  final Content message;
  final bool deleting;

  @override
  State<_MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<_MessageDialog> {
  late final text = TextEditingController(text: widget.message.text);
  bool saving = false;
  String error = '';

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!widget.deleting &&
        (text.text.trim().isEmpty || utf8.encode(text.text).length > 4096)) {
      setState(() => error = context.strings.messageTextInvalid);
      return;
    }
    setState(() {
      saving = true;
      error = '';
    });
    final success = widget.deleting
        ? await widget.controller.deleteMessage(widget.message)
        : await widget.controller.updateMessage(widget.message, text.text);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      saving = false;
      error = chatFailureText(context, widget.controller);
      if (error.isEmpty) error = context.strings.failureOperationFailed;
    });
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !saving,
    child: AlertDialog(
      title: Text(
        widget.deleting
            ? context.strings.deleteMessage
            : context.strings.editMessage,
      ),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.deleting)
                Text(context.strings.deleteMessageConfirm)
              else
                TextField(
                  key: const ValueKey('message-edit-text'),
                  controller: text,
                  autofocus: true,
                  enabled: !saving,
                  minLines: 3,
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: context.strings.messageText,
                  ),
                ),
              if (error.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving ? null : () => Navigator.of(context).pop(),
          child: Text(context.strings.cancelMessageChange),
        ),
        FilledButton(
          onPressed: saving ? null : save,
          child: saving
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  widget.deleting
                      ? context.strings.deleteMessage
                      : context.strings.saveMessage,
                ),
        ),
      ],
    ),
  );
}
