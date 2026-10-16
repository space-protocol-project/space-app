import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/strings.dart';
import '../src/home_controller.dart';
import '../src/home_diagnostics.dart';

String diagnosticText(BuildContext context, String code) {
  final strings = context.strings;
  if (code == 'local_interface_missing') return strings.homeDiagInterface;
  if (code.startsWith('local_') && code != 'local_ok') {
    return '${strings.homeDiagLocalPrefix}: ${diagnosticText(context, code.substring(6))}';
  }
  return switch (code) {
    'local_ok' => strings.homeDiagLocalOk,
    'route_ok' => strings.homeDiagRouteOk,
    'not_ready' => strings.homeDiagNotReady,
    'route_unreachable' => strings.homeDiagUnreachable,
    'dns_failed' => strings.homeDiagDNS,
    'certificate_ok' => strings.homeDiagCertificateOk,
    'certificate_missing' => strings.homeDiagCertificateMissing,
    'certificate_expired' => strings.homeDiagCertificateExpired,
    'certificate_mismatch' => strings.homeDiagCertificateMismatch,
    'discovery_invalid' => strings.homeDiagDiscovery,
    'wan_unknown' => strings.homeDiagWANUnknown,
    'wan_invalid' => strings.homeDiagWANInvalid,
    'wan_shared' => strings.homeDiagWANShared,
    'wan_private' => strings.homeDiagWANPrivate,
    'wan_ipv6_private' => strings.homeDiagIPv6Private,
    'wan_public' => strings.homeDiagWANPublic,
    'external_unverified' => strings.homeDiagExternal,
    'external_observed' => strings.homeDiagObserved,
    'budget_exhausted' => strings.homeDiagBudget,
    _ => strings.homeDiagUnknown,
  };
}

class HomeDiagnosticsPanel extends StatefulWidget {
  const HomeDiagnosticsPanel({
    super.key,
    required this.home,
    required this.view,
  });
  final HomeController home;
  final HomeState view;

  @override
  State<HomeDiagnosticsPanel> createState() => _HomeDiagnosticsPanelState();
}

class _HomeDiagnosticsPanelState extends State<HomeDiagnosticsPanel> {
  final wan = TextEditingController();

  @override
  void dispose() {
    wan.dispose();
    super.dispose();
  }

  Widget checkRow(HomeDiagnosticCheck check) {
    final colors = Theme.of(context).colorScheme;
    final (icon, color) = switch (check.status) {
      'ok' => (Icons.check_circle_outline, colors.primary),
      'failed' => (Icons.error_outline, colors.error),
      'warning' => (Icons.warning_amber_rounded, colors.tertiary),
      _ => (Icons.help_outline, colors.onSurfaceVariant),
    };
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(diagnosticText(context, check.code)),
                if (check.target.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: SelectableText(
                      check.target,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final view = widget.view;
    final strings = context.strings;
    final command = view.diagnosis?.outsideCommand ?? '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                strings.homeDiagTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              OutlinedButton.icon(
                onPressed: view.busy || view.diagnosing
                    ? null
                    : () => widget.home.diagnose(wanIP: wan.text),
                icon: view.diagnosing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.network_check, size: 18),
                label: Text(
                  view.diagnosing
                      ? strings.homeDiagRunning
                      : strings.homeDiagRun,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: wan,
            enabled: !view.diagnosing && !view.busy,
            maxLength: 45,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: strings.homeDiagWANLabel,
              helperText: strings.homeDiagWANHelp,
              helperMaxLines: 3,
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (view.diagnosisError != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                view.diagnosisError == HomeDiagnosisError.unsupported
                    ? strings.homeDiagUnsupported
                    : strings.homeDiagFailed,
              ),
            ),
          for (final check in view.diagnosis?.checks ?? <HomeDiagnosticCheck>[])
            checkRow(check),
          if (view.diagnosis?.externalCheckedAt case final time?)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                strings.homeDiagObservedAt(
                  MaterialLocalizations.of(context)
                      .formatTimeOfDay(TimeOfDay.fromDateTime(time)),
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          if (command.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              strings.homeDiagExternalHelp,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => Clipboard.setData(ClipboardData(text: command)),
              icon: const Icon(Icons.copy_outlined, size: 18),
              label: Text(strings.homeDiagCopyCommand),
            ),
          ],
        ],
      ),
    );
  }
}
