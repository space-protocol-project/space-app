import 'dart:async';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';

import '../src/file_picker.dart';

import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import 'components.dart';
import 'migration_password_dialog.dart';
import 'android_archive_transfer.dart';

typedef DeviceTransferAction = Future<void> Function(
  String path,
  String password,
  void Function(String) progress,
);

class DeviceTransferArea extends StatefulWidget {
  const DeviceTransferArea({
    super.key,
    required this.export,
    required this.restore,
  });
  final DeviceTransferAction export, restore;
  @override
  State<DeviceTransferArea> createState() => _DeviceTransferAreaState();
}

class _DeviceTransferAreaState extends State<DeviceTransferArea> {
  bool busy = false, dragging = false;

  Future<void> _export() async {
    final destination = await getSaveLocation(
      suggestedName: 'Space-device.spacedevice',
      acceptedTypeGroups: const [
        XTypeGroup(label: 'Space', extensions: ['spacedevice']),
      ],
    );
    if (destination != null) await _run(destination.path, importing: false);
  }

  Future<void> _pick() async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'Space', extensions: ['spacedevice', 'pending']),
      ],
    );
    if (file != null) await _run(file.path, importing: true);
  }

  Future<void> _drop(DropDetails details) async {
    setState(() => dragging = false);
    if (busy) return;
    if (details.items.length != 1 || details.items.single is! DropFileItem) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.deviceTransferOneFile)),
      );
      return;
    }
    final item = details.items.single as DropFileItem;
    final path = item.localPath;
    if (path == null) return;
    await _run(path, importing: true);
  }

  Future<void> _run(String path, {required bool importing}) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      final password = await migrationPassword(
        context,
        importing: importing,
        device: true,
      );
      if (password == null || !mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _TransferOperation(
          path: path,
          password: password,
          importing: importing,
          action: importing ? widget.restore : widget.export,
        ),
      );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Platform.isAndroid
      ? AndroidArchiveTransfer(export: widget.export, restore: widget.restore)
      : SurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.strings.deviceTransferTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(context.strings.deviceTransferHelp),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, size) {
            final tiles = [
              _tile(
                Icons.move_up_outlined,
                context.strings.deviceTransferExport,
                context.strings.deviceTransferExportHelp,
                _export,
              ),
              DropTarget(
                enabled: !busy,
                onEnter: (_) => setState(() => dragging = true),
                onLeave: () => setState(() => dragging = false),
                onDrop: _drop,
                child: _tile(
                  Icons.move_down_outlined,
                  context.strings.deviceTransferRestore,
                  context.strings.deviceTransferRestoreHelp,
                  _pick,
                  highlighted: dragging,
                ),
              ),
            ];
            if (size.maxWidth < 560) {
              return Column(
                children: [tiles[0], const SizedBox(height: 12), tiles[1]],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: tiles[0]),
                const SizedBox(width: 12),
                Expanded(child: tiles[1]),
              ],
            );
          },
        ),
      ],
    ),
  );

  Widget _tile(
    IconData icon,
    String title,
    String help,
    VoidCallback action, {
    bool highlighted = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      enabled: !busy,
      label: title,
      child: Material(
        color: highlighted
            ? scheme.primaryContainer
            : scheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: highlighted ? scheme.primary : scheme.outlineVariant,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: busy ? null : action,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 190),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 42),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(help, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TransferOperation extends StatefulWidget {
  const _TransferOperation({
    required this.path,
    required this.password,
    required this.importing,
    required this.action,
  });
  final String path, password;
  final bool importing;
  final DeviceTransferAction action;
  @override
  State<_TransferOperation> createState() => _TransferOperationState();
}

class _TransferOperationState extends State<_TransferOperation> {
  String status = '', error = '';
  bool finished = false;
  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    try {
      await widget.action(widget.path, widget.password, (text) {
        if (mounted) setState(() => status = text);
      });
      if (mounted) setState(() => finished = true);
    } catch (problem) {
      if (mounted) setState(() => error = problem.toString());
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: error.isNotEmpty,
    child: AlertDialog(
      title: Text(
        widget.importing
            ? context.strings.deviceTransferRestore
            : context.strings.deviceTransferExport,
      ),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!finished && error.isEmpty) const LinearProgressIndicator(),
            const SizedBox(height: 20),
            Text(error.isNotEmpty ? error : status),
            if (finished) ...[
              const SizedBox(height: 16),
              Text(widget.path),
              const SizedBox(height: 16),
              Text(context.strings.deviceTransferFinished),
            ],
          ],
        ),
      ),
      actions: [
        if (error.isNotEmpty)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.strings.close),
          ),
        if (finished)
          FilledButton(
            onPressed: () => exit(0),
            child: Text(context.strings.deviceTransferClose),
          ),
      ],
    ),
  );
}
