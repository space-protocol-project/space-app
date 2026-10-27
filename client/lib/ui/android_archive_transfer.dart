import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/archive_documents.dart';
import '../src/archive_transfer_cubit.dart';
import 'components.dart';
import 'migration_password_dialog.dart';

class AndroidArchiveTransfer extends StatefulWidget {
  const AndroidArchiveTransfer({super.key, required this.export, required this.restore, this.documents});
  final ArchiveTransferAction export, restore;
  final ArchiveDocuments? documents;
  @override
  State<AndroidArchiveTransfer> createState() => _AndroidArchiveTransferState();
}

class _AndroidArchiveTransferState extends State<AndroidArchiveTransfer> {
  late final cubit = ArchiveTransferCubit(widget.documents ?? AndroidArchiveDocuments(),
    export: widget.export, restore: widget.restore);
  @override
  void initState() { super.initState(); unawaited(cubit.load()); }
  @override
  void dispose() { unawaited(cubit.close()); super.dispose(); }

  Future<void> _password({required bool importing}) async {
    final password = await migrationPassword(context, importing: importing, device: true);
    if (password == null || !mounted) return;
    if (importing) { await cubit.apply(password); }
    else { await cubit.prepare(password); }
  }
  Future<void> _discard() async {
    final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: Text(context.strings.archiveDeleteTitle),
      content: Text(context.strings.archiveDeleteHelp),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.strings.close)),
        TextButton(onPressed: () => Navigator.pop(context, true), child: Text(context.strings.archiveDelete)),
      ],
    ));
    if (confirmed == true) await cubit.discard();
  }
  @override
  Widget build(BuildContext context) => BlocBuilder<ArchiveTransferCubit, ArchiveTransferState>(
    bloc: cubit,
    builder: (context, state) {
      final strings = context.strings;
      return PopScope(canPop: !state.busy, child: SurfaceCard(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.deviceTransferTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(strings.archiveStreamingHelp),
          const SizedBox(height: 20),
          if (state.busy) ..._progress(context, state) else ..._actions(context, state),
          if (state.error != null) ..._error(context, state.error!),
        ],
      )));
    },
  );

  List<Widget> _progress(BuildContext context, ArchiveTransferState state) {
    final strings = context.strings;
    return [const LinearProgressIndicator(), const SizedBox(height: 12),
      Text(state.cancellable ? strings.archiveCopyProgress(state.bytes ~/ (1024 * 1024)) : strings.archiveCritical),
      if (state.status.isNotEmpty) Text(state.status),
      if (state.cancellable) TextButton(onPressed: state.cancelling ? null : cubit.cancel,
        child: Text(state.cancelling ? strings.archiveCancelling : strings.close)),
    ];
  }
  List<Widget> _error(BuildContext context, Object error) => [
    const SizedBox(height: 16),
    Text('$error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
    const SizedBox(height: 8),
    TextButton(onPressed: cubit.load, child: Text(context.strings.archiveRetry)),
  ];

  List<Widget> _actions(BuildContext context, ArchiveTransferState state) {
    final strings = context.strings, pending = state.pending;
    if (state.finished) return _finished(context, state);
    if (pending == null) {
      return [
        FilledButton(onPressed: () => _password(importing: false), child: Text(strings.deviceTransferExport)),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: cubit.pick, child: Text(strings.deviceTransferRestore)),
      ];
    }
    if (pending.mode == ArchiveMode.exporting) {
      return _exportActions(context, pending);
    }
    return [Text(strings.archiveImportReady), const SizedBox(height: 12),
      FilledButton(onPressed: () => _password(importing: true), child: Text(strings.deviceTransferRestore)),
      if (pending.phase != ArchivePhase.applying) TextButton(onPressed: _discard, child: Text(strings.archiveDelete)),
    ];
  }
  List<Widget> _finished(BuildContext context, ArchiveTransferState state) {
    final strings = context.strings;
    return [Text(state.saved ? strings.archiveSaved : strings.deviceTransferFinished),
      const SizedBox(height: 12),
      FilledButton(onPressed: () => exit(0), child: Text(strings.deviceTransferClose)),
      if (state.saved) ...[
        const SizedBox(height: 12),
        TextButton(onPressed: cubit.save, child: Text(strings.archiveSave)),
        TextButton(onPressed: _discard, child: Text(strings.archiveDelete)),
      ],
    ];
  }
  List<Widget> _exportActions(BuildContext context, ArchiveWorkspace pending) {
    final strings = context.strings;
    return [Text(strings.archiveRetained), const SizedBox(height: 12),
      FilledButton(onPressed: pending.complete ? cubit.save : () => _password(importing: false),
        child: Text(pending.complete ? strings.archiveSave : strings.archiveRetry)),
      if (pending.complete) TextButton(onPressed: _discard, child: Text(strings.archiveDelete)),
    ];
  }
}
