import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/home_controller.dart';
import 'home_backup_editor.dart';
import 'home_disk_panel.dart' show homeDiskSize;

class HomeBackupPanel extends StatefulWidget {
  const HomeBackupPanel({super.key, required this.home, required this.view});
  final HomeController home;
  final HomeState view;
  @override
  State<HomeBackupPanel> createState() => _HomeBackupPanelState();
}

class _HomeBackupPanelState extends State<HomeBackupPanel> {
  HomeBackupSettings? settings;
  bool working = false, failed = false;

  Future<void> load({bool editing = false}) async {
    setState(() {
      working = true;
      failed = false;
    });
    try {
      final result = await widget.home.backupSettings();
      if (result == null || !mounted) return;
      setState(() => settings = result);
      if (!editing) return;
      final policy = await editHomeBackupPolicy(context, result);
      if (policy == null) return;
      await widget.home.saveBackupPolicy(policy);
      final updated = await widget.home.backupSettings();
      if (mounted) setState(() => settings = updated);
    } catch (_) {
      if (mounted) setState(() => failed = true);
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 24),
      Text(
        context.strings.homeBackupTitle,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Text(context.strings.homeBackupHelp),
      Wrap(
        spacing: 12,
        children: [
          OutlinedButton.icon(
            key: const ValueKey('backup-configure'),
            onPressed: working || widget.view.busy
                ? null
                : () => load(editing: true),
            icon: const Icon(Icons.schedule_outlined),
            label: Text(context.strings.homeBackupConfigure),
          ),
          TextButton(
            onPressed: working || widget.view.busy ? null : load,
            child: Text(context.strings.homeBackupRefresh),
          ),
        ],
      ),
      if (working) const LinearProgressIndicator(),
      if (failed)
        Text(
          context.strings.homeBackupFailed,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      if (settings != null) ..._status(settings!),
    ],
  );

  List<Widget> _status(HomeBackupSettings current) => [
    Text(_label(current)),
    Text(
      '${context.strings.homeBackupLast}: ${_date(current.status.lastSuccessAt)}',
    ),
    Text(
      '${context.strings.homeBackupNext}: ${current.policy.enabled ? _date(current.status.nextAt) : '—'}',
    ),
    Text(
      '${context.strings.homeDiskBackups}: ${current.status.count} · ${homeDiskSize(current.status.bytes)}',
    ),
    if (current.status.limited || current.status.protected > 0)
      Text(context.strings.homeBackupProtected),
    if (!current.supported) Text(context.strings.homeBackupUnsupported),
  ];

  String _label(HomeBackupSettings current) {
    if (!current.policy.enabled) return context.strings.homeBackupOff;
    return switch (current.status.code) {
      'running' => context.strings.homeBackupRunning,
      'ok' => context.strings.homeBackupOK,
      'space_low' => context.strings.homeBackupSpace,
      'failed' || 'invalid_policy' => context.strings.homeBackupFailed,
      _ => context.strings.homeBackupWaiting,
    };
  }

  String _date(int milliseconds) {
    if (milliseconds == 0) return '—';
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds).toLocal();
    final material = MaterialLocalizations.of(context);
    return '${material.formatShortDate(date)} ${material.formatTimeOfDay(TimeOfDay.fromDateTime(date))}';
  }
}
