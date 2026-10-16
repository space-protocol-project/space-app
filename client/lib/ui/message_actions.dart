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
    required this.onEdit,
  });
  final ChatController controller;
  final Content message;
  final VoidCallback onEdit;

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
    onSelected: (deleting) => deleting
        ? showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                _MessageDialog(controller: controller, message: message),
          )
        : onEdit(),
  );
}

class _MessageDialog extends StatefulWidget {
  const _MessageDialog({required this.controller, required this.message});
  final ChatController controller;
  final Content message;

  @override
  State<_MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<_MessageDialog> {
  bool saving = false;
  String error = '';

  Future<void> save() async {
    setState(() {
      saving = true;
      error = '';
    });
    final success = await widget.controller.deleteMessage(widget.message);
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
      title: Text(context.strings.deleteMessage),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.strings.deleteMessageConfirm),
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
              : Text(context.strings.deleteMessage),
        ),
      ],
    ),
  );
}
