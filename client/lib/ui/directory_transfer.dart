import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/directory_backup.dart';
import '../src/directory_transfer_cubit.dart';
import '../src/directory_transfer_qr.dart';
import '../src/file_picker.dart';
import 'camera_scanner.dart';
import 'components.dart';

class DirectoryTransferPanel extends StatefulWidget {
  const DirectoryTransferPanel({
    super.key,
    required this.service,
    required this.controller,
  });
  final DirectoryBackupService service;
  final ChatController controller;
  @override
  State<DirectoryTransferPanel> createState() => _DirectoryTransferPanelState();
}

class _DirectoryTransferPanelState extends State<DirectoryTransferPanel>
    with WidgetsBindingObserver {
  late final cubit = DirectoryTransferCubit(widget.service, widget.controller);
  final request = TextEditingController(), comparison = TextEditingController();
  bool externalInput = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed || externalInput || !cubit.active) {
      return;
    }
    unawaited(cubit.cancel());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    request.dispose();
    comparison.dispose();
    unawaited(cubit.close());
    super.dispose();
  }

  Future<void> readQr(bool camera) async {
    externalInput = true;
    try {
      final text = camera ? await scanDirectoryCamera(context) : await _image();
      if (mounted && text != null) request.text = text;
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.directoryBackupError)),
        );
      }
    } finally {
      externalInput = false;
    }
  }

  Future<String?> _image() async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'QR', extensions: ['png', 'jpg', 'jpeg']),
      ],
    );
    if (file == null) return null;
    if (await file.length() > 8 * 1024 * 1024) {
      throw const FormatException('QR');
    }
    final text = await compute(
      directoryTransferFromImage,
      await file.readAsBytes(),
    );
    if (text == null) throw const FormatException('QR');
    return text;
  }

  Future<void> confirm() async {
    if (await confirmRecoveryAction(
          context,
          context.strings.directoryTransferCompareHelp,
        ) &&
        mounted) {
      await cubit.confirm(comparison.text);
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

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DirectoryTransferCubit, DirectoryTransferState>(
        bloc: cubit,
        builder: (context, state) => SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.strings.directoryTransferTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(context.strings.directoryTransferHelp),
              const SizedBox(height: 12),
              SelectableText(
                widget.controller.preview?.origin.toString() ??
                    context.strings.directoryTransferRelay,
              ),
              const SizedBox(height: 20),
              ...content(state),
            ],
          ),
        ),
      );
  List<Widget> content(DirectoryTransferState state) => switch (state.stage) {
    DirectoryTransferStage.idle => idle(state),
    DirectoryTransferStage.waiting => waiting(state),
    DirectoryTransferStage.compare => compare(state),
    DirectoryTransferStage.sending => [
      const LinearProgressIndicator(),
      cancel(),
    ],
    DirectoryTransferStage.preview => preview(state),
    DirectoryTransferStage.done => [
      Text(context.strings.directoryTransferDone),
      cancel(),
    ],
    DirectoryTransferStage.failed => [
      Text(context.strings.directoryTransferError),
      cancel(),
    ],
  };
  Widget cancel() => TextButton(
    onPressed: () {
      comparison.clear();
      unawaited(cubit.cancel());
    },
    child: Text(context.strings.recoveryCancel),
  );
  List<Widget> idle(DirectoryTransferState state) => [
    FilledButton(
      onPressed: widget.controller.preview == null ? null : () => cubit.start(),
      child: Text(context.strings.directoryTransferReceive),
    ),
    const Divider(height: 32),
    Text(context.strings.directoryTransferSelect),
    ...widget.service.preferences.origins.map(
      (origin) => CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: state.selected.contains(origin),
        onChanged: (value) => cubit.select(origin, value ?? false),
        title: Text(origin),
      ),
    ),
    const SizedBox(height: 12),
    TextField(
      controller: request,
      maxLines: 3,
      maxLength: 3072,
      decoration: InputDecoration(
        labelText: context.strings.directoryTransferRequest,
      ),
    ),
    const SizedBox(height: 12),
    Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        OutlinedButton(
          onPressed: () => readQr(true),
          child: const Icon(Icons.qr_code_scanner),
        ),
        OutlinedButton(
          onPressed: () => readQr(false),
          child: const Icon(Icons.image_outlined),
        ),
        FilledButton(
          onPressed: state.selected.isEmpty || widget.controller.preview == null
              ? null
              : () => cubit.start(qr: request.text.trim()),
          child: Text(context.strings.directoryTransferSend),
        ),
      ],
    ),
  ];
  List<Widget> waiting(DirectoryTransferState state) => [
    Text(context.strings.directoryTransferWaiting),
    if (state.qr.isNotEmpty) ...[
      const SizedBox(height: 16),
      FutureBuilder(
        future: compute(directoryTransferPng, state.qr),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LinearProgressIndicator();
          return Image.memory(
            snapshot.data!,
            width: 260,
            height: 260,
            filterQuality: FilterQuality.none,
          );
        },
      ),
      const SizedBox(height: 12),
      OutlinedButton(
        onPressed: () => Clipboard.setData(ClipboardData(text: state.qr)),
        child: Text(context.strings.directoryTransferCopy),
      ),
    ],
    cancel(),
  ];
  List<Widget> compare(DirectoryTransferState state) => [
    Text(context.strings.directoryTransferCompareHelp),
    const SizedBox(height: 16),
    SelectableText(state.sas, style: Theme.of(context).textTheme.headlineSmall),
    const SizedBox(height: 16),
    if (!state.receiving)
      TextField(
        controller: comparison,
        maxLength: 40,
        decoration: InputDecoration(
          labelText: context.strings.directoryTransferComparison,
        ),
      ),
    const SizedBox(height: 12),
    FilledButton(
      onPressed: confirm,
      child: Text(context.strings.directoryTransferConfirm),
    ),
    cancel(),
  ];
  List<Widget> preview(DirectoryTransferState state) {
    final plan = state.plan!;
    return [
      Text(context.strings.directoryBackupPreview(plan.document.spaces.length)),
      if (plan.unknown) Text(context.strings.directoryBackupUnverified),
      const SizedBox(height: 12),
      ...plan.document.spaces.map((space) => Text(space['origin'] as String)),
      ...plan.conflicts.map(Text.new),
      const SizedBox(height: 16),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: state.replaceSettings,
        onChanged: (value) => cubit.replaceSettings(value ?? false),
        title: Text(context.strings.directoryBackupSettings),
      ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: plan.conflicts.isNotEmpty ? null : apply,
        child: Text(context.strings.directoryBackupApply),
      ),
      cancel(),
    ];
  }
}
