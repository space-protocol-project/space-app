import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/home_controller.dart';

String homeDiskSize(int bytes) {
  const gib = 1024 * 1024 * 1024;
  const mib = 1024 * 1024;
  if (bytes >= gib) return '${(bytes / gib).toStringAsFixed(2)} GiB';
  return '${(bytes / mib).toStringAsFixed(1)} MiB';
}

class HomeDiskPanel extends StatefulWidget {
  const HomeDiskPanel({super.key, required this.home, required this.view});
  final HomeController home;
  final HomeState view;
  @override
  State<HomeDiskPanel> createState() => _HomeDiskPanelState();
}

class _HomeDiskPanelState extends State<HomeDiskPanel> {
  HomeDiskReport? report;
  final selected = <String>{};
  bool working = false, failed = false;

  Future<void> scan() async {
    setState(() {
      working = true;
      failed = false;
    });
    try {
      final result = await widget.home.inspectDisk();
      if (mounted) {
        setState(() {
          report = result;
          selected.clear();
        });
      }
    } catch (_) {
      if (mounted) setState(() => failed = true);
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  Future<void> clean() async {
    final approved = report!;
    final choice = Set<String>.from(selected);
    final bytes = approved.candidates
        .where((item) => choice.contains(item.id))
        .fold(0, (sum, item) => sum + item.bytes);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.homeDiskClean),
        content: Text(
          '${context.strings.homeDiskConfirm}\n\n${choice.length} · ${homeDiskSize(bytes)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.strings.homeDiskClean),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      working = true;
      failed = false;
    });
    try {
      final done = await widget.home.cleanDisk(approved, choice);
      if (!done) throw StateError('Очистка не выполнена');
      if (mounted) {
        setState(() {
          report = null;
          selected.clear();
        });
        await scan();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          failed = true;
          report = null;
          selected.clear();
        });
      }
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = report;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          context.strings.homeDiskTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(context.strings.homeDiskPolicy),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          key: const ValueKey('home-disk-scan'),
          onPressed: working || widget.view.busy ? null : scan,
          icon: const Icon(Icons.storage_outlined),
          label: Text(context.strings.homeDiskScan),
        ),
        if (working) const LinearProgressIndicator(),
        if (failed)
          Text(
            context.strings.homeDiskFailed,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        if (current != null) ..._details(current),
      ],
    );
  }

  List<Widget> _details(HomeDiskReport current) => [
    const SizedBox(height: 12),
    _size(context.strings.homeDiskData, current.dataBytes),
    _size(context.strings.homeDiskRuntimes, current.runtimeBytes),
    _size(context.strings.homeDiskBackups, current.backupBytes),
    _size(context.strings.homeDiskRecoveries, current.recoveryBytes),
    _size(context.strings.homeDiskFree, current.availableBytes),
    const SizedBox(height: 12),
    Text(context.strings.homeDiskEstimate),
    if (current.candidates.isEmpty) Text(context.strings.homeDiskNothing),
    ...current.candidates.map(_candidate),
    if (widget.view.running) Text(context.strings.homeDiskStop),
    if (current.candidates.isNotEmpty)
      FilledButton.icon(
        key: const ValueKey('home-disk-clean'),
        onPressed:
            working ||
                widget.view.busy ||
                widget.view.running ||
                selected.isEmpty
            ? null
            : clean,
        icon: const Icon(Icons.cleaning_services_outlined),
        label: Text(context.strings.homeDiskClean),
      ),
  ];

  Widget _size(String label, int bytes) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Text('$label: ${homeDiskSize(bytes)}'),
  );

  Widget _candidate(HomeDiskItem item) => CheckboxListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(item.id),
    subtitle: Text(
      [
        homeDiskSize(item.bytes),
        if (item.modifiedAt != null)
          MaterialLocalizations.of(context)
              .formatShortDate(item.modifiedAt!.toLocal()),
      ].join(' · '),
    ),
    value: selected.contains(item.id),
    onChanged: working || widget.view.busy || widget.view.running
        ? null
        : (value) => setState(() {
            if (value == true) {
              selected.add(item.id);
            } else {
              selected.remove(item.id);
            }
          }),
  );
}
