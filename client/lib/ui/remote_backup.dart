import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../l10n/strings.dart';
import 'directory_settings_merge.dart';
import '../src/directory_archive.dart';
import '../src/directory_backup.dart';
import '../src/file_picker.dart';
import '../src/remote_backup.dart';
import '../src/remote_backup_cubit.dart';
import '../src/user_export_file.dart';

class RemoteBackupPanel extends StatefulWidget {
  const RemoteBackupPanel({super.key, required this.service, this.controller});
  final DirectoryBackupService service;
  final RemoteBackupCubit? controller;
  @override
  State<RemoteBackupPanel> createState() => _RemoteBackupPanelState();
}

class _RemoteBackupPanelState extends State<RemoteBackupPanel> {
  late final cubit =
      widget.controller ??
      RemoteBackupCubit(RemoteBackupService(widget.service));
  String? selectedSpace;
  final files = UserExportFileService();
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) unawaited(cubit.load());
  }

  @override
  void dispose() {
    if (widget.controller == null) unawaited(cubit.close());
    super.dispose();
  }

  Future<bool> saveKit(String raw) async {
    if (!await confirmRecoveryAction(
          context,
          context.strings.remoteBackupKitHelp,
        ) ||
        !mounted) {
      return false;
    }
    final path = await files.choose(
      'space.spacebackupkit',
      binary: true,
      extension: 'spacebackupkit',
    );
    if (path == null) return false;
    try {
      await files.write(path, Uint8List.fromList(utf8.encode(raw)));
      return true;
    } catch (_) {
      await files.discard(path);
      rethrow;
    }
  }

  Future<void> importKit() async {
    cubit.reset();
    try {
      final file = await openFile(
        acceptedTypeGroups: const [
          XTypeGroup(
            label: 'Space backup kit',
            extensions: ['spacebackupkit'],
            mimeTypes: ['application/octet-stream'],
          ),
        ],
      );
      if (file == null || !mounted) return;
      if (await file.length() > 8192) throw const FormatException();
      final bytes = await DirectoryArchive.readStream(file.openRead());
      await cubit.importKit(utf8.decode(bytes));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.remoteBackupError)),
        );
      }
    }
  }

  Future<void> publish() async {
    final password = await askRecoveryPassword(context, creating: true);
    if (password != null && mounted) await cubit.publish(password);
  }

  Future<void> preview() async {
    cubit.reset();
    final password = await askRecoveryPassword(context, creating: false);
    if (password != null && mounted) {
      await cubit.preview(password);
    }
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

  Future<void> revoke() async {
    if (await confirmRecoveryAction(
          context,
          context.strings.remoteBackupRevokeHelp,
        ) &&
        mounted) {
      await cubit.revoke();
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<RemoteBackupCubit, RemoteBackupState>(
        bloc: cubit,
        builder: (context, state) => Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.strings.remoteBackupTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(context.strings.remoteBackupHelp),
                const SizedBox(height: 16),
                if (state.kit == null) ..._setup(state),
                if (state.kit != null) ..._configured(state),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: state.busy ? null : importKit,
                  child: Text(context.strings.remoteBackupImportKit),
                ),
                if (state.busy) const LinearProgressIndicator(),
                ..._result(state),
              ],
            ),
          ),
        ),
      );
  List<Widget> _setup(RemoteBackupState state) {
    final spaces = cubit.spaces;
    final selected = spaces.any((space) => space.origin == selectedSpace)
        ? selectedSpace
        : null;
    return [
      DropdownButtonFormField<String>(
        initialValue: selected,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: context.strings.remoteBackupStorage,
        ),
        items: spaces
            .map(
              (space) => DropdownMenuItem(
                value: space.origin,
                child: Text(space.title, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: state.busy
            ? null
            : (value) => setState(() => selectedSpace = value),
      ),
      const SizedBox(height: 16),
      OutlinedButton(
        onPressed: state.busy || selected == null
            ? null
            : () => cubit.setup(selected, saveKit),
        child: Text(context.strings.remoteBackupSetup),
      ),
    ];
  }

  List<Widget> _configured(RemoteBackupState state) => [
    Text('${context.strings.remoteBackupStorage}: ${state.kit!.space.origin}'),
    const SizedBox(height: 16),
    Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        OutlinedButton(
          onPressed: state.busy ? null : publish,
          child: Text(context.strings.remoteBackupPublish),
        ),
        OutlinedButton(
          onPressed: state.busy ? null : preview,
          child: Text(context.strings.remoteBackupRead),
        ),
        TextButton(
          onPressed: state.busy ? null : cubit.configure,
          child: Text(context.strings.remoteBackupConfigure),
        ),
        TextButton(
          onPressed: state.busy ? null : () => cubit.exportKit(saveKit),
          child: Text(context.strings.remoteBackupSaveKit),
        ),
        TextButton(
          onPressed: state.busy ? null : revoke,
          child: Text(context.strings.remoteBackupRevoke),
        ),
      ],
    ),
  ];
  List<Widget> _result(RemoteBackupState state) => [
    if (state.error != null) ...[
      const SizedBox(height: 12),
      Text(context.strings.remoteBackupError),
    ],
    if (state.message == 'saved') ...[
      const SizedBox(height: 12),
      Text(context.strings.remoteBackupSaved),
    ],
    if (state.message == 'configured') ...[
      const SizedBox(height: 12),
      Text(context.strings.remoteBackupConfigured),
    ],
    if (state.message == 'restored') ...[
      const SizedBox(height: 12),
      Text(context.strings.directoryBackupRestored),
    ],
    if (state.message == 'revoked') ...[
      const SizedBox(height: 12),
      Text(context.strings.remoteBackupRevoked),
    ],
    if (state.restore != null) ..._preview(state),
  ];
  List<Widget> _preview(RemoteBackupState state) {
    final restore = state.restore!, plan = restore.plan;
    return [
      const SizedBox(height: 16),
      Text('${context.strings.remoteBackupVerified} ${restore.head.revision}'),
      Text(context.strings.remoteBackupFreshness),
      const SizedBox(height: 12),
      Text(context.strings.directoryBackupPreview(plan.document.spaces.length)),
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
      ...plan.conflicts.map((value) => Text(value)),
      ..._restoreActions(state),
    ];
  }

  List<Widget> _restoreActions(RemoteBackupState state) {
    final restore = state.restore!, plan = restore.plan;
    return [
      const SizedBox(height: 12),
      DirectorySettingsMergePanel(plan: plan, enabled: state.replaceSettings,
        busy: state.busy, choices: state.settingsChoices,
        onEnabled: cubit.replaceSettings, onChoice: cubit.chooseSetting),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: state.busy || plan.conflicts.isNotEmpty || !plan.settingsResolved(state.replaceSettings, state.settingsChoices) ? null : apply,
        child: Text(context.strings.directoryBackupApply),
      ),
      TextButton(
        onPressed: state.busy ? null : cubit.reset,
        child: Text(context.strings.recoveryCancel),
      ),
    ];
  }
}
