import 'home_operation_progress.dart';
import '../l10n/strings.dart';
import '../l10n/home_strings.dart';
import '../l10n/failure_strings.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../src/home_controller.dart';
import '../src/local_failure.dart';
import 'components.dart';

class HomePanel extends StatefulWidget {
  const HomePanel({
    super.key,
    required this.home,
    required this.onStart,
    required this.onStop,
    required this.openAdministration,
  });
  final HomeController home;
  final Future<void> Function(String) onStart;
  final Future<void> Function() onStop;
  final VoidCallback openAdministration;
  @override
  State<HomePanel> createState() => _HomePanelState();
}

class _HomePanelState extends State<HomePanel> {
  late final address = TextEditingController(text: widget.home.ip);
  bool detecting = false;
  bool detectionFailed = false;
  bool updateAction = false;

  Future<void> openRecoveryGuide() async {
    try {
      if (await launchUrl(
        Uri.parse(
          'https://github.com/space-protocol-project/space-app/blob/main/docs/HOME-RECOVERY.md',
        ),
        mode: LaunchMode.externalApplication,
      )) {
        return;
      }
    } catch (_) {}
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.homeRecoveryGuideFailed)),
      );
    }
  }

  Future<void> updateServer() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          widget.home.pendingUpdate
              ? context.strings.homeResumeUpdate
              : context.strings.homeUpdate,
        ),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.home.installedVersion} → ${widget.home.availableVersion}',
                ),
                const SizedBox(height: 16),
                Text(context.strings.homeUpdateConfirm),
                const Divider(height: 24),
                Text(context.strings.homeReleaseChanges),
                const SizedBox(height: 16),
                SelectableText(
                  widget.home.availableReleaseNotes.isEmpty
                      ? context.strings.homeNoReleaseNotes
                      : widget.home.availableReleaseNotes,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.strings.close),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              widget.home.pendingUpdate
                  ? context.strings.homeResumeUpdate
                  : context.strings.homeUpdate,
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => updateAction = true);
    try {
      final recovering = widget.home.pendingUpdate;
      if (!recovering && !await widget.home.prepareUpdate()) return;
      if (widget.home.running) await widget.onStop();
      if (!widget.home.running) {
        await widget.home.performUpdate(recover: recovering);
      }
    } finally {
      if (mounted) setState(() => updateAction = false);
    }
  }

  @override
  void dispose() {
    address.dispose();
    super.dispose();
  }

  Future<void> detect() async {
    setState(() {
      detecting = true;
      detectionFailed = false;
    });
    try {
      final ip = await widget.home.detectIP();
      if (mounted) address.text = ip;
    } catch (_) {
      if (mounted) {
        detectionFailed = true;
      }
    } finally {
      if (mounted) setState(() => detecting = false);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.home,
    builder: (context, _) {
      final home = widget.home;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.sensors),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.strings.homeTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: context.strings.close,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              home.ip.isEmpty
                  ? context.strings.homeFirstSetup
                  : context.strings.homeReuse,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: address,
              enabled: home.ip.isEmpty && !home.busy && !detecting,
              decoration: InputDecoration(
                labelText: context.strings.homeIP,
                hintText: context.strings.homeIPHint,
              ),
            ),
            if (home.ip.isEmpty) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: home.busy || detecting ? null : detect,
                icon: const Icon(Icons.public),
                label: Text(
                  detecting
                      ? context.strings.detectingIP
                      : context.strings.detectIP,
                ),
              ),
              Text(
                context.strings.homeIPPrivacy,
                style: TextStyle(fontSize: 12),
              ),
            ],
            if (detectionFailed) Text(context.strings.homeIPFailed),
            const SizedBox(height: 20),
            Text(context.strings.homePortHelp),
            const SizedBox(height: 20),
            if (home.busy && home.error.isEmpty) ...[
              HomeOperationProgress(home: home),
              const SizedBox(height: 16),
            ],
            if (!home.busy && home.phase != HomePhase.idle) ...[
              Text(home.phase.label(context)),
              const SizedBox(height: 16),
            ],
            if (home.error.isNotEmpty) ...[
              Text(
                home.failureCode == null
                    ? home.error
                    : localFailureText(context, home.failureCode!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
              if (home.spaceReport != null &&
                  home.failureCode == LocalFailureCode.homeSpaceLow)
                Text(
                  context.strings.homeSpaceDetails(
                    (home.spaceReport!.requiredBytes / (1024 * 1024))
                        .ceil()
                        .toString(),
                    (home.spaceReport!.availableBytes / (1024 * 1024))
                        .floor()
                        .toString(),
                  ),
                ),
            ],
            SpaceActionButton(
              onPressed:
                  home.busy ||
                      detecting ||
                      updateAction ||
                      (home.pendingUpdate && !home.running)
                  ? null
                  : () async {
                      if (home.running) {
                        await widget.onStop();
                      } else {
                        await widget.onStart(address.text);
                      }
                    },
              icon: home.running ? Icons.power_settings_new : Icons.sensors,
              label: home.running
                  ? context.strings.stopHome
                  : context.strings.goLive,
            ),
            if (home.updateAvailable || home.pendingUpdate) ...[
              const SizedBox(height: 16),
              if (home.installedVersion.isNotEmpty &&
                  home.availableVersion.isNotEmpty) ...[
                Text('${home.installedVersion} → ${home.availableVersion}'),
                const SizedBox(height: 12),
              ],
              OutlinedButton.icon(
                onPressed:
                    home.busy ||
                        detecting ||
                        updateAction ||
                        home.recoveryBlocked
                    ? null
                    : updateServer,
                icon: const Icon(Icons.system_update_alt),
                label: Text(
                  home.pendingUpdate
                      ? context.strings.homeResumeUpdate
                      : context.strings.homeUpdate,
                ),
              ),
              if (home.recoveryBlocked) ...[
                const SizedBox(height: 12),
                Text(context.strings.homeRecoveryHelp),
                TextButton.icon(
                  onPressed: openRecoveryGuide,
                  icon: const Icon(Icons.help_outline),
                  label: Text(context.strings.homeRecoveryGuide),
                ),
                OutlinedButton.icon(
                  key: const ValueKey('home-recovery-diagnostics'),
                  onPressed: () => Clipboard.setData(
                    ClipboardData(
                      text:
                          '${home.recoverySummary}\ncode: ${home.failureCode?.name}',
                    ),
                  ),
                  icon: const Icon(Icons.copy_outlined),
                  label: Text(context.strings.homeRecoveryCopy),
                ),
              ],
            ],
            if (home.state != null) ...[
              const SizedBox(height: 20),
              Text(context.strings.homeLink),
              const SizedBox(height: 16),
              SelectableText(home.state!.link),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Clipboard.setData(
                      ClipboardData(text: home.state!.link),
                    ),
                    icon: const Icon(Icons.copy),
                    label: Text(context.strings.copyLink),
                  ),
                  FilledButton.icon(
                    onPressed: widget.openAdministration,
                    icon: const Icon(Icons.tune),
                    label: Text(context.strings.manageServer),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                context.strings.homeInviteHelp,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
      );
    },
  );
}
