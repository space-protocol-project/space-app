import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../l10n/failure_strings.dart';
import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/pairing_cubit.dart';
import '../src/pairing.dart';
import '../src/core.dart';

class PairingStartPanel extends StatefulWidget {
  const PairingStartPanel({
    super.key,
    required this.controller,
    required this.onConnected,
    this.fullManagement = false,
    this.checkRecord,
  });
  final ChatController controller;
  final Future<void> Function(String) onConnected;
  final bool fullManagement;
  final Future<void> Function(DeviceRecord)? checkRecord;
  @override
  State<PairingStartPanel> createState() => _PairingStartPanelState();
}

class _PairingStartPanelState extends State<PairingStartPanel>
    with WidgetsBindingObserver {
  late PairingCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = createCubit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant PairingStartPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller || oldWidget.fullManagement != widget.fullManagement) {
      unawaited(cubit.close());
      cubit = createCubit();
    }
  }

  PairingCubit createCubit() => PairingCubit(widget.controller,
    checkRecord: widget.checkRecord,
    create: (server) => PendingPairing.start(server, fullManagement: widget.fullManagement));

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if ([
      AppLifecycleState.paused,
      AppLifecycleState.detached,
      AppLifecycleState.hidden,
    ].contains(state)) {
      unawaited(cubit.cancel());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(cubit.close());
    super.dispose();
  }

  Future<void> accept() async {
    final active = cubit;
    final revision = active.revision;
    final origin = active.candidateOrigin;
    if (origin == null) return;
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.pairingCompareTitle),
        content: Text(
          context.strings.pairingAcceptConfirm(
            active.state.verification,
            origin,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.strings.recoveryCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.strings.pairingMatches),
          ),
        ],
      ),
    );
    if (approved != true || !mounted || active != cubit) return;
    if (await active.accept(revision) && mounted && active == cubit) {
      await widget.onConnected(origin);
    }
  }

  String errorText(PairingIssue? issue) => switch (issue) {
    null => '',
    PairingIssue.start => context.strings.pairingStartFailed,
    PairingIssue.cancelled => context.strings.pairingCancelled,
    PairingIssue.connection => chatFailureText(context, widget.controller),
    PairingIssue.network => context.strings.pairingNetworkError,
    PairingIssue.verification => context.strings.pairingVerificationError,
    PairingIssue.expired => context.strings.pairingExpired,
  };

  @override
  Widget build(BuildContext context) => BlocBuilder<PairingCubit, PairingState>(
    bloc: cubit,
    builder: (context, state) => PairingStartView(
      busy: state.busy,
      connectionBusy: widget.controller.busy,
      connected: widget.controller.connected,
      code: state.code,
      qrPreview: state.qr == null
          ? null
          : Image.memory(
              state.qr!,
              width: 240,
              height: 240,
              filterQuality: FilterQuality.none,
              semanticLabel: context.strings.pairingCompareTitle,
            ),
      signatureVerified: state.verified,
      verification: state.verification,
      error: errorText(state.issue),
      onStart: cubit.start,
      onAccept: accept,
      onCancel: cubit.cancel,
    ),
  );
}
