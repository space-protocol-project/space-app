import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/chat_outbox.dart';
import 'outbox_label.dart';

class OutboxRecoveryButton extends StatelessWidget {
  const OutboxRecoveryButton({
    super.key,
    required this.controller,
    required this.source,
    required this.target,
    required this.enabled,
  });
  final ChatController controller;
  final OutboxScope source;
  final String target;
  final bool enabled;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    key: ValueKey('recover-outbox-${source.id}'),
    onPressed: enabled ? () => _open(context) : null,
    icon: const Icon(Icons.restore),
    label: Text(context.strings.outboxRecover),
  );

  Future<void> _open(BuildContext context) async {
    try {
      final entries = await controller.outboxStore.read(source);
      if (!context.mounted || entries.isEmpty) return;
      final accepted = await showDialog<bool>(
        context: context,
        builder: (_) => _RecoveryDialog(entries: entries, source: source),
      );
      if (accepted != true) return;
      final success = await controller.recoverOutbox(
        source,
        target,
        snapshot: outboxSnapshot(entries),
      );
      if (!context.mounted || success) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.outboxRecoverFailed)),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.outboxRecoverFailed)),
      );
    }
  }
}

class _RecoveryDialog extends StatefulWidget {
  const _RecoveryDialog({required this.entries, required this.source});
  final List<PendingMessage> entries;
  final OutboxScope source;
  @override
  State<_RecoveryDialog> createState() => _RecoveryDialogState();
}

class _RecoveryDialogState extends State<_RecoveryDialog> {
  bool trusted = false;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.strings.outboxRecover),
    content: SizedBox(
      width: 520,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.strings.outboxRecoverDescription),
            const SizedBox(height: 12),
            Text(widget.source.origin),
            Text('${context.strings.outboxTitle}: ${widget.entries.length}'),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.builder(
                itemCount: widget.entries.length,
                itemBuilder: (_, index) =>
                    _entry(context, widget.entries[index]),
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: trusted,
              onChanged: (value) => setState(() => trusted = value == true),
              title: Text(context.strings.outboxRecoverTrust),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text(context.strings.cancelMessageChange),
      ),
      TextButton(
        onPressed: trusted ? () => Navigator.pop(context, true) : null,
        child: Text(context.strings.outboxRecoverSend),
      ),
    ],
  );

  Widget _entry(BuildContext context, PendingMessage entry) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(
      outboxEntryTitle(context, entry),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Text(
      [
        entry.channelId,
        ...entry.localFiles.map((file) => file.name),
      ].join(' · '),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
