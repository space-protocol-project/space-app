import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/app_shutdown.dart';
import '../src/extensions_p1/local_session_cubit.dart';

class LocalExtensionSessionScope extends StatefulWidget {
  const LocalExtensionSessionScope({
    super.key,
    required this.child,
    this.access,
    this.shutdown,
  });
  final Widget child;
  final LocalSessionCubit? access;
  final AppShutdown? shutdown;

  @override
  State<LocalExtensionSessionScope> createState() =>
      _LocalExtensionSessionScopeState();
}

class _LocalExtensionSessionScopeState extends State<LocalExtensionSessionScope>
    with WidgetsBindingObserver {
  late LocalSessionCubit access;
  late bool owned;

  @override
  void initState() {
    super.initState();
    _attach();
    WidgetsBinding.instance.addObserver(this);
  }

  void _attach() {
    owned = widget.access == null;
    access = widget.access ?? LocalSessionCubit();
    // Подключение к новому дереву не переносит разблокировку из прежнего.
    access.lock();
    access.setForeground(
      WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed,
    );
    widget.shutdown?.addStopBarrier(access.stop);
    if (widget.shutdown != null &&
        widget.shutdown!.state != AppShutdownState.ready) {
      access.stop();
    }
  }

  void _detach(AppShutdown? shutdown) {
    shutdown?.removeStopBarrier(access.stop);
    access.lock();
    if (owned) unawaited(access.close());
  }

  @override
  void didUpdateWidget(LocalExtensionSessionScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.access == widget.access &&
        oldWidget.shutdown == widget.shutdown) {
      return;
    }
    _detach(oldWidget.shutdown);
    _attach();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    access.setForeground(state == AppLifecycleState.resumed);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _detach(widget.shutdown);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocProvider.value(value: access, child: widget.child);
}
