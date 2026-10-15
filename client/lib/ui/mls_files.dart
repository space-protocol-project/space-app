import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/strings.dart';

typedef MlsDownload = Future<void> Function(
  Map<String, dynamic> message,
  Map<String, dynamic> file,
);

// Названия и авторы берутся из локально расшифрованных сообщений.
class MlsFilesPanel extends StatefulWidget {
  const MlsFilesPanel({
    super.key,
    required this.messages,
    required this.ownId,
    required this.download,
  });
  final List<Map<String, dynamic>> messages;
  final String ownId;
  final MlsDownload download;
  @override
  State<MlsFilesPanel> createState() => _MlsFilesPanelState();
}

class _MlsFilesPanelState extends State<MlsFilesPanel> {
  String author = '';
  List<({Map<String, dynamic> message, Map<String, dynamic> file})> entries() {
    final result =
        <({Map<String, dynamic> message, Map<String, dynamic> file})>[];
    for (final message in widget.messages.reversed) {
      if (author.isNotEmpty && message['author_id'] != author) continue;
      for (final file
          in ((message['message'] as Map)['files'] as List)
              .cast<Map<String, dynamic>>()) {
        result.add((message: message, file: file));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final files = entries();
    final authors = {
      widget.ownId,
      ...widget.messages.map((m) => m['author_id'] as String),
    };
    final selected = authors.contains(author) ? author : '';
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.strings.mlsFiles),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: selected,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text(context.strings.allFileAuthors),
                ),
                for (final id in authors)
                  DropdownMenuItem(
                    value: id,
                    child: Text(
                      id == widget.ownId ? context.strings.myFiles : id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) => setState(() => author = value ?? ''),
            ),
            const SizedBox(height: 12),
            Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: files.length,
                itemBuilder: (context, index) => fileRow(files, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fileRow(
    List<({Map<String, dynamic> message, Map<String, dynamic> file})> files,
    int index,
  ) {
    final item = files[index];
    final date = DateFormat.yMMMd().format(
      DateTime.fromMillisecondsSinceEpoch(item.message['time'] as int),
    );
    final previous = index == 0
        ? ''
        : DateFormat.yMMMd().format(
            DateTime.fromMillisecondsSinceEpoch(
              files[index - 1].message['time'] as int,
            ),
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (date != previous)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(date, style: Theme.of(context).textTheme.labelSmall),
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.insert_drive_file_outlined),
          title: Text(
            item.file['name'] as String,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => widget.download(item.message, item.file),
        ),
      ],
    );
  }
}
