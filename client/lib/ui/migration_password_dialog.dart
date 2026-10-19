import 'package:flutter/material.dart';

import '../l10n/strings.dart';

Future<String?> migrationPassword(
  BuildContext context, {
  required bool importing,
  bool device = false,
}) => showDialog<String>(
  context: context,
  builder: (_) =>
      _MigrationPasswordDialog(importing: importing, device: device),
);

class _MigrationPasswordDialog extends StatefulWidget {
  const _MigrationPasswordDialog({
    required this.importing,
    this.device = false,
  });
  final bool importing;
  final bool device;
  @override
  State<_MigrationPasswordDialog> createState() =>
      _MigrationPasswordDialogState();
}

class _MigrationPasswordDialogState extends State<_MigrationPasswordDialog> {
  final password = TextEditingController();
  final confirmation = TextEditingController();
  bool get valid => widget.importing
      ? password.text.isNotEmpty
      : password.text.length >= 12 && password.text == confirmation.text;

  @override
  void dispose() {
    password.dispose();
    confirmation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.device
          ? (widget.importing
                ? context.strings.deviceTransferRestore
                : context.strings.deviceTransferExport)
          : context.strings.migrationTitle,
    ),
    content: SizedBox(
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.device
                  ? context.strings.deviceTransferPasswordHelp
                  : widget.importing
                  ? context.strings.migrationImportHelp
                  : context.strings.migrationExportHelp,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: password,
              obscureText: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: context.strings.migrationPassword,
              ),
            ),
            if (!widget.importing)
              TextField(
                controller: confirmation,
                obscureText: true,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: context.strings.migrationPasswordRepeat,
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.strings.close),
      ),
      FilledButton(
        onPressed: valid ? () => Navigator.pop(context, password.text) : null,
        child: Text(
          widget.importing
              ? context.strings.homeImport
              : context.strings.homeExport,
        ),
      ),
    ],
  );
}
