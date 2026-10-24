import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/app_shutdown.dart';

class AppShutdownGate extends StatelessWidget {
  const AppShutdownGate({
    super.key,
    required this.shutdown,
    required this.child,
  });
  final AppShutdown? shutdown;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (shutdown == null) return child;
    return BlocBuilder<AppShutdown, AppShutdownState>(
      bloc: shutdown,
      builder: (context, state) {
        final stopping =
            state == AppShutdownState.stopping ||
            state == AppShutdownState.stopped;
        return Stack(
          children: [
            ExcludeFocus(
              excluding: stopping,
              child: AbsorbPointer(absorbing: stopping, child: child),
            ),
            if (stopping)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x99000000),
                  child: Center(
                    child: Material(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Завершение операций и остановка домашнего сервера…',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
