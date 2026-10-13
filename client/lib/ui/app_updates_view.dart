import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/strings.dart';
import '../src/app_updates.dart';
import 'components.dart';

class AppUpdatesView extends StatefulWidget {
  const AppUpdatesView({super.key, this.updates});
  final AppUpdates? updates;
  @override
  State<AppUpdatesView> createState() => _AppUpdatesViewState();
}

class _AppUpdatesViewState extends State<AppUpdatesView> {
  late final updates = widget.updates ?? AppUpdates();
  @override
  void initState() {
    super.initState();
    unawaited(updates.initialize());
  }

  @override
  void dispose() {
    if (widget.updates == null) updates.dispose();
    super.dispose();
  }

  Future<void> openRelease() async {
    final url = updates.release?.url;
    if (url == null) return;
    try {
      if (await launchUrl(url, mode: LaunchMode.externalApplication)) return;
    } catch (_) {}
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.updatesOpenFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: updates,
    builder: (context, _) {
      final message = switch (updates.status) {
        AppUpdateStatus.idle => '',
        AppUpdateStatus.checking => context.strings.updatesChecking,
        AppUpdateStatus.current => context.strings.updatesCurrent,
        AppUpdateStatus.available => context.strings.updatesAvailable(
          updates.release!.tag,
        ),
        AppUpdateStatus.empty => context.strings.updatesEmpty,
        AppUpdateStatus.failed => context.strings.updatesFailed,
      };
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.strings.updatesTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OutlinedButton.icon(
                      key: const ValueKey('check-app-updates'),
                      onPressed: updates.status == AppUpdateStatus.checking
                          ? null
                          : updates.check,
                      icon: const Icon(Icons.refresh),
                      label: Text(context.strings.updatesCheck),
                    ),
                    if (updates.status == AppUpdateStatus.available)
                      FilledButton.icon(
                        onPressed: openRelease,
                        icon: const Icon(Icons.open_in_new),
                        label: Text(context.strings.updatesOpen),
                      ),
                  ],
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(message, key: const ValueKey('app-update-status')),
                ],
                if (updates.release?.notes.isNotEmpty == true)
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(context.strings.updatesChanges),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SelectableText(updates.release!.notes),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            updates.installed.isEmpty
                ? context.strings.updatesUnknownVersion
                : context.strings.updatesInstalled(updates.installed),
            key: const ValueKey('installed-app-version'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    },
  );
}
