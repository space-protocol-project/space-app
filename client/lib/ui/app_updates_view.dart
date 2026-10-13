import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/strings.dart';
import '../src/app_updates.dart';
import 'components.dart';

class AppUpdatesView extends StatefulWidget {
  const AppUpdatesView({super.key, this.updates, this.prepareInstall});
  final AppUpdates? updates;
  final Future<void> Function()? prepareInstall;
  @override
  State<AppUpdatesView> createState() => _AppUpdatesViewState();
}

class _AppUpdatesViewState extends State<AppUpdatesView> {
  late final updates = widget.updates ?? AppUpdates();
  bool installedCopy = false;
  @override
  void initState() {
    super.initState();
    unawaited(checkInstalledCopy());
    if (updates.installed.isEmpty && updates.status == AppUpdateStatus.idle) {
      unawaited(updates.initialize());
    }
  }

  Future<void> checkInstalledCopy() async {
    try {
      final directory = await updates.installationDirectory();
      if (mounted) setState(() => installedCopy = directory != null);
    } catch (_) {}
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
                      onPressed:
                          updates.downloading ||
                              updates.installing ||
                              updates.status == AppUpdateStatus.checking
                          ? null
                          : updates.check,
                      icon: const Icon(Icons.refresh),
                      label: Text(context.strings.updatesCheck),
                    ),
                    if (updates.status == AppUpdateStatus.available &&
                        updates.package != null)
                      FilledButton.icon(
                        key: const ValueKey('download-app-update'),
                        onPressed:
                            updates.downloading ||
                                updates.installing ||
                                updates.downloadedPackage != null
                            ? null
                            : updates.download,
                        icon: const Icon(Icons.download_outlined),
                        label: Text(context.strings.updatesDownload),
                      ),
                    if (updates.downloadedPackage != null &&
                        installedCopy &&
                        widget.prepareInstall != null &&
                        updates.platform == 'windows-x64')
                      FilledButton.icon(
                        key: const ValueKey('install-app-update'),
                        onPressed: updates.installing
                            ? null
                            : () => updates.install(
                                prepare: widget.prepareInstall!,
                              ),
                        icon: const Icon(Icons.restart_alt),
                        label: Text(context.strings.updatesInstall),
                      ),
                    if (updates.status == AppUpdateStatus.available)
                      OutlinedButton.icon(
                        onPressed: openRelease,
                        icon: const Icon(Icons.open_in_new),
                        label: Text(context.strings.updatesOpen),
                      ),
                  ],
                ),
                if (updates.downloading) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          value:
                              updates.downloadedBytes / updates.package!.size,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(100 * updates.downloadedBytes / updates.package!.size).floor()}%',
                      ),
                    ],
                  ),
                ],
                if (updates.installing || updates.installFailed) ...[
                  const SizedBox(height: 16),
                  Text(
                    updates.installFailed
                        ? context.strings.updatesInstallFailed
                        : context.strings.updatesPreparing,
                  ),
                ],
                if (updates.downloadFailed ||
                    updates.downloadedPackage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    updates.downloadFailed
                        ? context.strings.updatesDownloadFailed
                        : context.strings.updatesDownloaded,
                  ),
                ],
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(message, key: const ValueKey('app-update-status')),
                ],
                if (updates.status == AppUpdateStatus.available) ...[
                  const SizedBox(height: 12),
                  Text(
                    updates.package == null
                        ? context.strings.updatesPackageUnavailable
                        : context.strings.updatesPackage(
                            updates.platform,
                            (updates.package!.size / (1024 * 1024))
                                .toStringAsFixed(1),
                          ),
                  ),
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
