import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/strings.dart';

Future<String?> pickRecoveryFile(BuildContext context) async {
  final directory = await getApplicationDocumentsDirectory();
  if (!context.mounted) return null;
  return showDialog<String>(
    context: context,
    builder: (_) => RecoveryFilePicker(initialDirectory: directory.path),
  );
}

Future<String?> pickRecoveryQrDestination(
  BuildContext context, {
  String name = 'space-recovery.png',
  String? label,
}) async {
  final directory = await getApplicationDocumentsDirectory();
  if (!context.mounted) return null;
  return showDialog<String>(
    context: context,
    builder: (_) => RecoveryFilePicker(
      initialDirectory: directory.path,
      saveName: name,
      saveLabel: label,
    ),
  );
}

class RecoveryFilePicker extends StatefulWidget {
  const RecoveryFilePicker({
    super.key,
    required this.initialDirectory,
    this.saveName,
    this.saveLabel,
  });
  final String initialDirectory;
  final String? saveName;
  final String? saveLabel;
  @override
  State<RecoveryFilePicker> createState() => _RecoveryFilePickerState();
}

class _RecoveryFilePickerState extends State<RecoveryFilePicker> {
  final path = TextEditingController();
  late String directory = widget.initialDirectory;
  List<FileSystemEntity> entries = [];
  bool loading = true;
  String error = '';
  int request = 0;
  @override
  void initState() {
    super.initState();
    if (widget.saveName != null) {
      path.text = '$directory${Platform.pathSeparator}${widget.saveName}';
    }
    load(directory);
  }

  @override
  void dispose() {
    request++;
    path.dispose();
    super.dispose();
  }

  Future<void> load(String value) async {
    final id = ++request;
    setState(() {
      loading = true;
      error = '';
    });
    try {
      final result = await Directory(value)
          .list(followLinks: false)
          .where(
            (entry) =>
                entry is Directory ||
                entry is File &&
                    RegExp(
                      r'\.(png|json)$',
                      caseSensitive: false,
                    ).hasMatch(entry.path),
          )
          .take(1000)
          .toList()
          .timeout(const Duration(seconds: 10));
      result.sort((a, b) {
        if (a is Directory && b is! Directory) return -1;
        if (b is Directory && a is! Directory) return 1;
        return a.path.toLowerCase().compareTo(b.path.toLowerCase());
      });
      if (mounted && id == request) {
        setState(() {
          directory = value;
          entries = result;
        });
      }
    } catch (_) {
      if (mounted && id == request) {
        setState(() => error = context.strings.recoveryFolderUnavailable);
      }
    } finally {
      if (mounted && id == request) setState(() => loading = false);
    }
  }

  void navigate(String value) {
    if (widget.saveName != null) {
      path.text = '$value${Platform.pathSeparator}${widget.saveName}';
    }
    load(value);
  }

  Widget _fileEntry(BuildContext context, int index) {
    final entry = entries[index];
    return ListTile(
      dense: true,
      leading: Icon(
        entry is Directory ? Icons.folder_outlined : Icons.description_outlined,
      ),
      title: Text(
        entry.uri.pathSegments.where((part) => part.isNotEmpty).last,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: loading
          ? null
          : () {
              if (entry is Directory) {
                navigate(entry.path);
              } else {
                setState(() => path.text = entry.path);
              }
            },
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.saveName == null
          ? context.strings.recoveryChooseFile
          : widget.saveLabel ?? context.strings.recoverySaveQr,
    ),
    content: SizedBox(
      width: 560,
      height: 420,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: context.strings.recoveryParentFolder,
                onPressed: loading
                    ? null
                    : () => navigate(Directory(directory).parent.path),
                icon: const Icon(Icons.arrow_upward),
              ),
              Expanded(
                child: Text(
                  directory,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (loading) const LinearProgressIndicator(),
          if (error.isNotEmpty) Text(error),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: _fileEntry,
            ),
          ),
          TextField(
            controller: path,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: context.strings.recoveryFilePath,
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) Navigator.pop(context, value);
            },
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.strings.close),
      ),
      FilledButton(
        onPressed: path.text.isEmpty
            ? null
            : () => Navigator.pop(context, path.text),
        child: Text(
          widget.saveName == null
              ? context.strings.recoveryOpenFile
              : widget.saveLabel ?? context.strings.recoverySaveQr,
        ),
      ),
    ],
  );
}
