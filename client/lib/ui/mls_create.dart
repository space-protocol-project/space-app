import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/core.dart';

class CreateMlsChannelButton extends StatelessWidget {
  const CreateMlsChannelButton({
    super.key,
    required this.session,
    required this.created,
  });
  final SpaceSession session;
  final ValueChanged<String> created;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    icon: const Icon(Icons.lock_outline),
    label: Text(context.strings.mlsCreate),
    onPressed: () async {
      final id = await showDialog<String>(
        context: context,
        builder: (_) => _CreateMlsDialog(session),
      );
      if (id != null && context.mounted) created(id);
    },
  );
}

class _CreateMlsDialog extends StatefulWidget {
  const _CreateMlsDialog(this.session);
  final SpaceSession session;
  @override
  State<_CreateMlsDialog> createState() => _CreateMlsDialogState();
}

class _CreateMlsDialogState extends State<_CreateMlsDialog> {
  final id = TextEditingController(), title = TextEditingController();
  bool busy = false;
  String error = '';

  @override
  void dispose() {
    id.dispose();
    title.dispose();
    super.dispose();
  }

  Future<void> create() async {
    if (!RegExp(r'^[a-z][a-z0-9_-]{0,63}$').hasMatch(id.text) ||
        title.text.trim().isEmpty) {
      setState(
        () =>
            error = 'Укажите название и идентификатор: латиница, цифры, _ и -',
      );
      return;
    }
    setState(() {
      busy = true;
      error = '';
    });
    try {
      await (await widget.session.mlsClient()).createChannel(
        id.text,
        title.text.trim(),
      );
      await widget.session.refreshChannels();
      if (mounted) Navigator.pop(context, id.text);
    } catch (_) {
      if (mounted) {
        setState(() {
          busy = false;
          error = 'Не удалось создать закрытый канал. Проверьте подключение и версию сервера.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.strings.mlsCreate),
    content: SizedBox(
      width: 440,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.strings.mlsExperimental),
          const SizedBox(height: 16),
          TextField(
            controller: id,
            enabled: !busy,
            decoration: InputDecoration(
              labelText: context.strings.mlsChannelId,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: title,
            enabled: !busy,
            decoration: InputDecoration(
              labelText: context.strings.mlsChannelTitle,
            ),
          ),
          if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(error),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: busy ? null : () => Navigator.pop(context),
        child: Text(context.strings.mlsCancel),
      ),
      FilledButton(
        onPressed: busy ? null : create,
        child: Text(context.strings.mlsCreate),
      ),
    ],
  );
}
