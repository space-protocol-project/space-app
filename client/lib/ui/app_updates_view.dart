import 'package:flutter_bloc/flutter_bloc.dart';

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
  Widget build(BuildContext context) => BlocBuilder<AppUpdates, AppUpdateState>(
    bloc: updates,
    builder: (context, view) {
      final message = switch (view.status) {
        AppUpdateStatus.idle => '',
        AppUpdateStatus.checking => context.strings.updatesChecking,
        AppUpdateStatus.current => context.strings.updatesCurrent,
        AppUpdateStatus.available => context.strings.updatesAvailable(
          view.release!.tag,
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
                _updateActions(context, view),
                if (view.downloading) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          value: view.downloadedBytes / view.package!.size,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(100 * view.downloadedBytes / view.package!.size).floor()}%',
                      ),
                    ],
                  ),
                ],
                if (view.installing || view.installFailed) ...[
                  const SizedBox(height: 16),
                  Text(
                    view.installFailed
                        ? context.strings.updatesInstallFailed
                        : context.strings.updatesPreparing,
                  ),
                ],
                if (view.downloadFailed || view.downloadedPackage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    view.downloadFailed
                        ? context.strings.updatesDownloadFailed
                        : context.strings.updatesDownloaded,
                  ),
                ],
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(message, key: const ValueKey('app-update-status')),
                ],
                if (view.status == AppUpdateStatus.available) ...[
                  const SizedBox(height: 12),
                  Text(
                    view.package == null
                        ? context.strings.updatesPackageUnavailable
                        : context.strings.updatesPackage(
                            updates.platform,
                            (view.package!.size / (1024 * 1024))
                                .toStringAsFixed(1),
                          ),
                  ),
                ],
                if (view.release?.notes.isNotEmpty == true)
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(context.strings.updatesChanges),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SelectableText(view.release!.notes),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            view.installed.isEmpty
                ? context.strings.updatesUnknownVersion
                : context.strings.updatesInstalled(view.installed),
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
  Widget _updateActions(BuildContext context, AppUpdateState view) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      OutlinedButton.icon(
        key: const ValueKey('check-app-updates'),
        onPressed:
            view.downloading ||
                view.installing ||
                view.status == AppUpdateStatus.checking
            ? null
            : updates.check,
        icon: const Icon(Icons.refresh),
        label: Text(context.strings.updatesCheck),
      ),
      if (view.status == AppUpdateStatus.available && view.package != null)
        FilledButton.icon(
          key: const ValueKey('download-app-update'),
          onPressed:
              view.downloading ||
                  view.installing ||
                  view.downloadedPackage != null
              ? null
              : updates.download,
          icon: const Icon(Icons.download_outlined),
          label: Text(context.strings.updatesDownload),
        ),
      if (view.downloadedPackage != null &&
          installedCopy &&
          widget.prepareInstall != null &&
          updates.platform == 'windows-x64')
        FilledButton.icon(
          key: const ValueKey('install-app-update'),
          onPressed: view.installing
              ? null
              : () => updates.install(prepare: widget.prepareInstall!),
          icon: const Icon(Icons.restart_alt),
          label: Text(context.strings.updatesInstall),
        ),
      if (view.status == AppUpdateStatus.available)
        OutlinedButton.icon(
          onPressed: openRelease,
          icon: const Icon(Icons.open_in_new),
          label: Text(context.strings.updatesOpen),
        ),
    ],
  );
}
