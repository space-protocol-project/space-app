import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/chat_outbox.dart';
import 'outbox_recovery.dart';

class OutboxPanel extends StatelessWidget {
  const OutboxPanel({super.key, required this.controller, required this.state});
  final ChatController controller;
  final ChatState state;

  @override
  Widget build(BuildContext context) {
    final count = state.pendingMessages
        .where((entry) => entry.channelId == state.channelId)
        .length;
    if (count == 0 &&
        state.outboxError.isEmpty &&
        state.outboxSources.isEmpty) {
      return const SizedBox.shrink();
    }
    final size = MediaQuery.sizeOf(context);
    final compact =
        size.width < 600 ||
        size.height < 720 ||
        MediaQuery.textScalerOf(context).scale(14) > 18;
    if (!compact) return _details(context);
    return TextButton.icon(
      key: const ValueKey('open-outbox'),
      onPressed: () => _openDetails(context),
      icon: Icon(
        state.outboxError.isEmpty ? Icons.schedule : Icons.error_outline,
      ),
      label: Text('${context.strings.outboxTitle} · $count'),
    );
  }

  Future<void> _openDetails(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.strings.outboxTitle),
      content: SizedBox(
        width: 520,
        child: BlocBuilder<ChatController, ChatState>(
          bloc: controller,
          builder: (context, current) => OutboxPanel(
            controller: controller,
            state: current,
          )._details(context),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.strings.close),
        ),
      ],
    ),
  );

  Widget _details(BuildContext context) {
    final entries = state.pendingMessages
        .where((entry) => entry.channelId == state.channelId)
        .toList();
    if (entries.isEmpty &&
        state.outboxError.isEmpty &&
        state.outboxSources.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.outboxError.isNotEmpty) _storageError(context),
          if (entries.isNotEmpty) _messages(context, entries),
          for (final source in state.outboxSources)
            OutboxRecoveryButton(
              controller: controller,
              source: source,
              target: state.outboxRecoveryTarget,
              enabled: !state.busy,
            ),
        ],
      ),
    );
  }

  String _errorText(BuildContext context) => switch (state.outboxError) {
    'identity' => context.strings.outboxIdentityChanged,
    'full' => context.strings.outboxFull,
    'files-full' => context.strings.outboxFileLimit,
    _ => context.strings.outboxUnavailable,
  };

  Widget _storageError(BuildContext context) => Row(
    children: [
      Expanded(child: Text(_errorText(context))),
      IconButton(
        onPressed: () => controller.retryPending(''),
        tooltip: context.strings.outboxRetry,
        icon: const Icon(Icons.refresh),
      ),
    ],
  );

  Widget _messages(BuildContext context, List<PendingMessage> entries) =>
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 136),
        child: Material(
          type: MaterialType.transparency,
          child: ListView(
            shrinkWrap: true,
            children: [for (final entry in entries) _message(context, entry)],
          ),
        ),
      );

  Widget _message(BuildContext context, PendingMessage entry) => ListTile(
    key: ValueKey('pending-${entry.key}'),
    dense: true,
    contentPadding: EdgeInsets.zero,
    leading: Icon(entry.blocked ? Icons.error_outline : Icons.schedule),
    title: Text(
      entry.text.isEmpty ? context.strings.outboxFileMessage : entry.text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Text(
      [
        entry.blocked
            ? context.strings.outboxBlocked
            : context.strings.outboxWaiting,
        if (entry.localFiles.isNotEmpty)
          entry.localFiles.map((file) => file.name).join(', '),
      ].join(' · '),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (entry.blocked)
          IconButton(
            onPressed: () => controller.retryPending(entry.key),
            tooltip: context.strings.outboxRetry,
            icon: const Icon(Icons.refresh),
          ),
        IconButton(
          onPressed: () => _discard(context, entry),
          tooltip: context.strings.outboxDiscard,
          icon: const Icon(Icons.close),
        ),
      ],
    ),
  );

  Future<void> _discard(BuildContext context, PendingMessage entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.outboxDiscard),
        content: Text(context.strings.outboxDiscardDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.strings.cancelMessageChange),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.strings.outboxDiscard),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.discardPending(entry.key);
  }
}
