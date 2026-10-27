import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../l10n/failure_strings.dart';
import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/pairing_cubit.dart';

class PairingStartPanel extends StatefulWidget {
  const PairingStartPanel({super.key, required this.controller, required this.onConnected});
  final ChatController controller;
  final Future<void> Function(String) onConnected;
  @override
  State<PairingStartPanel> createState() => _PairingStartPanelState();
}

class _PairingStartPanelState extends State<PairingStartPanel> with WidgetsBindingObserver {
  late PairingCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = PairingCubit(widget.controller);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant PairingStartPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      unawaited(cubit.close());
      cubit = PairingCubit(widget.controller);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if ([AppLifecycleState.paused, AppLifecycleState.detached, AppLifecycleState.hidden].contains(state)) {
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
    final approved = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: Text(context.strings.pairingCompareTitle),
      content: Text(context.strings.pairingAcceptConfirm(active.state.verification, origin)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.strings.recoveryCancel)),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(context.strings.pairingMatches)),
      ],
    ));
    if (approved != true || !mounted || active != cubit) return;
    if (await active.accept(revision) && mounted) await widget.onConnected(origin);
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
      qrPreview: state.qr == null ? null : Image.memory(state.qr!, width: 240, height: 240, filterQuality: FilterQuality.none, semanticLabel: context.strings.pairingCompareTitle),
      signatureVerified: state.verified,
      verification: state.verification,
      error: errorText(state.issue),
      onStart: cubit.start,
      onAccept: accept,
      onCancel: cubit.cancel,
    ),
  );
}
