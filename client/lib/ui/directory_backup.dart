import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../l10n/strings.dart';
import '../src/directory_archive.dart';
import '../src/directory_backup.dart';
import '../src/directory_backup_cubit.dart';
import '../src/file_picker.dart';
import '../src/user_export_file.dart';

class DirectoryBackupPanel extends StatefulWidget {
  const DirectoryBackupPanel({
    super.key,
    required this.service,
    this.controller,
  });
  final DirectoryBackupService service;
  final DirectoryBackupCubit? controller;
  @override
  State<DirectoryBackupPanel> createState() => _DirectoryBackupPanelState();
}

class _DirectoryBackupPanelState extends State<DirectoryBackupPanel> {
  late final cubit = widget.controller ?? DirectoryBackupCubit(widget.service);
  final files = UserExportFileService();
  @override
  void dispose() {
    if (widget.controller == null) unawaited(cubit.close());
    super.dispose();
  }

  Future<void> create() async {
    final password = await askRecoveryPassword(context, creating: true);
    if (password == null || !mounted) return;
    await cubit.export(password, (bytes) async {
      final path = await files.choose(
        'space-${DateTime.now().millisecondsSinceEpoch}.spacebackup',
        binary: true,
      );
      if (path == null) return false;
      if (!mounted) {
        await files.discard(path);
        return false;
      }
      try {
        await files.write(path, bytes);
        return true;
      } catch (_) {
        await files.discard(path);
        rethrow;
      }
    });
  }

  Future<void> read() async {
    cubit.reset();
    try {
      await _read();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.directoryBackupError)),
        );
      }
    }
  }

  Future<void> _read() async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'Space backup',
          extensions: ['spacebackup'],
          mimeTypes: ['application/octet-stream'],
        ),
      ],
    );
    if (file == null || !mounted) return;
    if (await file.length() > DirectoryArchive.maxFile) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.directoryBackupError)),
        );
      }
      return;
    }
    if (!mounted) return;
    final password = await askRecoveryPassword(context, creating: false);
    if (password == null || !mounted) return;
    await cubit.preview(
      await DirectoryArchive.readStream(file.openRead()),
      password,
    );
  }

  Future<void> apply() async {
    if (await confirmRecoveryAction(
          context,
          context.strings.directoryBackupConfirm,
        ) &&
        mounted) {
      await cubit.apply();
    }
  }

  Future<void> follows() async {
    if (await confirmRecoveryAction(
          context,
          context.strings.directoryBackupFollowsHelp,
        ) &&
        mounted) {
      await cubit.restoreFollowing();
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DirectoryBackupCubit, DirectoryBackupState>(
        bloc: cubit,
        builder: (context, state) => Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.strings.directoryBackupTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(context.strings.directoryBackupHelp),
                const SizedBox(height: 16),
                _actions(state),
                if (state.busy) ...[
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(),
                ],
                ..._result(state),
              ],
            ),
          ),
        ),
      );
  Widget _actions(DirectoryBackupState state) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      OutlinedButton(
        onPressed: state.busy ? null : create,
        child: Text(context.strings.directoryBackupCreate),
      ),
      OutlinedButton(
        onPressed: state.busy ? null : read,
        child: Text(context.strings.directoryBackupRead),
      ),
      TextButton(
        onPressed: state.busy ? null : cubit.resume,
        child: Text(context.strings.directoryBackupResume),
      ),
      TextButton(
        onPressed: state.busy ? null : follows,
        child: Text(context.strings.directoryBackupFollows),
      ),
    ],
  );
  List<Widget> _result(DirectoryBackupState state) => [
    if (state.plan != null) ..._preview(state),
    if (state.error != null) ...[
      const SizedBox(height: 12),
      Text(context.strings.directoryBackupError),
    ],
    if (state.message == 'saved') ...[
      const SizedBox(height: 12),
      Text(context.strings.directoryBackupSaved),
    ],
    if (state.message == 'restored') ...[
      const SizedBox(height: 12),
      Text(context.strings.directoryBackupRestored),
    ],
    if (state.results.isNotEmpty) ...[
      const SizedBox(height: 12),
      Text(context.strings.directoryBackupResults),
      ...state.results.map((result) => Text(result)),
    ],
  ];
  List<Widget> _preview(DirectoryBackupState state) {
    final plan = state.plan!;
    return [
      const SizedBox(height: 16),
      Text(context.strings.directoryBackupPreview(plan.document.spaces.length)),
      if (plan.unknown) Text(context.strings.directoryBackupUnverified),
      ...plan.document.spaces.map(
        (space) => Text(
          space['following_status'] == 'complete'
              ? context.strings.directoryBackupSpaceComplete(
                  space['origin'] as String,
                  (space['following'] as List).length,
                )
              : context.strings.directoryBackupSpaceIncomplete(
                  space['origin'] as String,
                  (space['following'] as List).length,
                ),
        ),
      ),
      ...plan.conflicts.map((conflict) => Text(conflict)),
      const SizedBox(height: 12),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: state.replaceSettings,
        onChanged: state.busy
            ? null
            : (value) => cubit.replaceSettings(value ?? false),
        title: Text(context.strings.directoryBackupSettings),
      ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: state.busy || plan.conflicts.isNotEmpty ? null : apply,
        child: Text(context.strings.directoryBackupApply),
      ),
      TextButton(
        onPressed: state.busy ? null : cubit.reset,
        child: Text(context.strings.recoveryCancel),
      ),
    ];
  }
}
