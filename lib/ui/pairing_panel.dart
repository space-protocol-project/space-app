import 'dart:async';

import 'package:flutter/material.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../src/chat_controller.dart';
import '../src/core.dart';
import '../src/pairing.dart';

class PairingStartPanel extends StatefulWidget {
  const PairingStartPanel({
    super.key,
    required this.controller,
    required this.onConnected,
  });
  final ChatController controller;
  final Future<void> Function(String) onConnected;
  @override
  State<PairingStartPanel> createState() => _PairingStartPanelState();
}

class _PairingStartPanelState extends State<PairingStartPanel> {
  PendingPairing? pending;
  DeviceRecord? candidate;
  Timer? timer;
  bool busy = false, polling = false;
  String error = '', verification = '';
  @override
  void dispose() {
    timer?.cancel();
    unawaited(pending?.close() ?? Future<void>.value());
    super.dispose();
  }

  Future<void> start() async {
    final server = widget.controller.preview;
    if (server == null || busy || pending != null) return;
    setState(() {
      busy = true;
      error = '';
    });
    try {
      final result = await PendingPairing.start(server);
      if (!mounted) {
        await result.close();
        return;
      }
      setState(() => pending = result);
      timer = Timer.periodic(const Duration(seconds: 2), (_) => poll());
    } catch (_) {
      if (mounted) {
        setState(
          () => error = 'Не удалось начать сопряжение. Проверьте сервер и доступность PostgreSQL.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> poll() async {
    final current = pending;
    if (current == null || polling || candidate != null) return;
    polling = true;
    try {
      final response = await current.poll();
      if (!mounted || pending != current) return;
      if (response.pairing.state == 'cancelled') {
        throw const FormatException('Сопряжение отменено');
      }
      if (response.pairing.state == 'approved') {
        final record = await current.verifiedRecord(response);
        final code = await pairVerificationCode(
          current.server.serverId,
          current.request.pairing.id,
          record.rootPublicKey,
          current.request.pairing.publicKey,
          administrative: current.request.pairing.administrative,
        );
        if (!mounted || pending != current) return;
        timer?.cancel();
        setState(() {
          candidate = record;
          verification = code;
        });
      }
      if (response.pairing.state == 'pending' && current.proposedRoot != null) {
        final code = await pairVerificationCode(
          current.server.serverId,
          current.request.pairing.id,
          current.proposedRoot!,
          current.request.pairing.publicKey,
          administrative: current.request.pairing.administrative,
        );
        if (mounted && pending == current) setState(() => verification = code);
      }
    } catch (_) {
      if (mounted && pending == current) {
        timer?.cancel();
        setState(
          () => error = 'Код истёк, отменён или подтверждение не прошло проверку. Начните заново.',
        );
      }
    } finally {
      polling = false;
    }
  }

  Future<void> cancel() async {
    timer?.cancel();
    final current = pending;
    setState(() {
      pending = null;
      candidate = null;
      verification = '';
      error = '';
    });
    await current?.close();
  }

  Future<void> accept() async {
    final current = pending, record = candidate;
    if (current == null || record == null || busy) return;
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сверьте код на двух устройствах'),
        content: Text(
          'На подтверждающем устройстве должен отображаться код $verification. Совпадает? Сохранённая здесь идентичность для ${record.origin} будет заменена; сначала сохраните её карточку, если это другой аккаунт.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Код совпадает'),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;
    setState(() => busy = true);
    try {
      await widget.controller.connect(
        restoredRecord: record,
        pairingId: current.request.pairing.id,
      );
      if (!mounted) return;
      if (!widget.controller.connected) {
        setState(() => error = widget.controller.error);
        return;
      }
      current.claimed = true;
      await current.close();
      pending = null;
      await widget.onConnected(record.origin);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PairingStartView(
    busy: busy,
    connectionBusy: widget.controller.busy,
    connected: widget.controller.connected,
    code: pending?.request.code ?? '',
    signatureVerified: candidate != null,
    verification: verification,
    error: error,
    onStart: start,
    onAccept: accept,
    onCancel: cancel,
  );
}
