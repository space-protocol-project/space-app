import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../l10n/failure_strings.dart';
import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/core.dart';
import '../src/local_failure.dart';
import '../src/file_picker.dart';
import '../src/pairing_approval_cubit.dart';
import '../src/pairing_qr.dart';
import 'camera_scanner.dart';

class PairingApprovalPanel extends StatefulWidget {
  const PairingApprovalPanel({super.key, required this.controller,
    required this.readAuthority, this.blocked = false});
  final ChatController controller;
  final Future<DeviceRecord?> Function() readAuthority;
  final bool blocked;
  @override
  State<PairingApprovalPanel> createState() => _PairingApprovalPanelState();
}

class _PairingApprovalPanelState extends State<PairingApprovalPanel> with WidgetsBindingObserver {
  late final cubit = PairingApprovalCubit(server: () => widget.controller.preview,
      manager: () => widget.controller.deviceManagement);
  final code = TextEditingController(), entered = TextEditingController();
  StreamSubscription<ChatState>? subscription;
  Discovery? server;
  DeviceManagement? manager;
  bool externalInput = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    watchController();
  }

  void watchController() {
    server = widget.controller.preview;
    manager = widget.controller.deviceManagement;
    subscription = widget.controller.stream.listen((_) {
      if (identical(server, widget.controller.preview) && identical(manager, widget.controller.deviceManagement)) return;
      server = widget.controller.preview;
      manager = widget.controller.deviceManagement;
      cubit.reset();
    });
  }

  @override
  void didUpdateWidget(covariant PairingApprovalPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      unawaited(subscription?.cancel());
      cubit.reset();
      watchController();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!externalInput && [AppLifecycleState.paused, AppLifecycleState.hidden, AppLifecycleState.detached].contains(state)) cubit.reset();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(subscription?.cancel());
    unawaited(cubit.close());
    code.dispose();
    entered.dispose();
    super.dispose();
  }

  Future<bool> confirm(String text) => confirmRecoveryAction(context, text);

  Future<void> prepare() => cubit.prepare(
    confirm: (pair) => confirm(context.strings.pairingPrepareConfirm(pair.deviceName,
      pair.administrative ? context.strings.pairingManageRequest : context.strings.pairingChatRequest)),
    readAuthority: () => withExternalInput(widget.readAuthority),
  );

  Future<String?> pickImage() async {
    final file = await openFile(acceptedTypeGroups: const [XTypeGroup(label: 'QR',
      extensions: ['png', 'jpg', 'jpeg'], mimeTypes: ['image/png', 'image/jpeg'])]);
    if (file == null) return null;
    if (await file.length() > 8 * 1024 * 1024) throw const FormatException('QR');
    final text = await compute(pairingQrFromImage, await file.readAsBytes());
    if (text == null) throw const FormatException('QR');
    return text;
  }

  Future<T> withExternalInput<T>(Future<T> Function() read) async {
    externalInput = true;
    try {
      return await read();
    } finally {
      externalInput = false;
    }
  }

  Future<void> scan({bool camera = false}) => cubit.scan(() => withExternalInput(
    () => camera ? scanPairingCamera(context) : pickImage()));

  AdminLocalizations get adminStrings => AdminLocalizations.of(context) ??
      lookupAdminLocalizations(Locale(Localizations.localeOf(context).languageCode));

  String message(PairingApprovalState state) {
    if (state.error is FormatException) return context.strings.pairingQrInvalid;
    if (state.error != null) return localFailureText(context, classifyFailure(state.error!));
    return switch (state.messageKey) {
      'pairingReady' => context.strings.pairingReady,
      'pairingSigned' => context.strings.pairingSigned,
      'pairingMismatch' => context.strings.pairingMismatch,
      'pairingExpired' => context.strings.pairingExpired,
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<PairingApprovalCubit, PairingApprovalState>(
    bloc: cubit,
    listener: (_, state) {
      if (code.text != state.code) code.text = state.code;
      if (!state.prepared) entered.clear();
    },
    builder: (context, state) => Card(child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(adminStrings.pairingApproveTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(adminStrings.pairingApproveHelp),
        const SizedBox(height: 12),
        TextField(controller: code, enabled: !state.busy && !widget.blocked,
          onChanged: cubit.setCode, decoration: InputDecoration(labelText: adminStrings.pairingCode, hintText: 'pc_…')),
        const SizedBox(height: 12),
        _actions(state),
        if (state.prepared) ..._comparison(state),
        ..._status(state),
      ]),
    )),
  );

  List<Widget> _status(PairingApprovalState state) => [
    if (state.busy) const LinearProgressIndicator(),
    if (message(state).isNotEmpty) ...[const SizedBox(height: 12), Text(message(state))],
  ];

  bool enabled(PairingApprovalState state) => !widget.blocked && !state.busy &&
      widget.controller.connected && widget.controller.deviceManagement != null;

  Widget _actions(PairingApprovalState state) => Wrap(spacing: 12, runSpacing: 12, children: [
    OutlinedButton.icon(onPressed: enabled(state) ? () => scan(camera: true) : null,
      icon: const Icon(Icons.qr_code_scanner), label: Text(context.strings.spaceQrCamera)),
    OutlinedButton.icon(onPressed: enabled(state) ? scan : null,
      icon: const Icon(Icons.image_outlined), label: Text(context.strings.spaceQrImage)),
    OutlinedButton.icon(onPressed: enabled(state) ? prepare : null,
      icon: const Icon(Icons.verified_user_outlined), label: Text(adminStrings.pairingPrepare)),
  ]);

  List<Widget> _comparison(PairingApprovalState state) => [
    const SizedBox(height: 12), Text(adminStrings.pairingComparison),
    SelectableText(state.verification, style: Theme.of(context).textTheme.titleLarge),
    const SizedBox(height: 12),
    TextField(controller: entered, enabled: enabled(state),
      decoration: InputDecoration(labelText: adminStrings.pairingEnteredCode)),
    const SizedBox(height: 12),
    FilledButton(onPressed: enabled(state) ? () => cubit.approve(entered.text,
      () => confirm(context.strings.pairingSignConfirm)) : null,
      child: Text(adminStrings.pairingSign)),
    TextButton(onPressed: state.busy ? null : cubit.reset, child: Text(context.strings.recoveryCancel)),
  ];
}
