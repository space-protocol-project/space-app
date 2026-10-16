import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../src/home_controller.dart';
import '../l10n/strings.dart';
import '../l10n/home_strings.dart';

class HomeOperationProgress extends StatelessWidget {
  const HomeOperationProgress({
    super.key,
    required this.home,
    this.compact = false,
  });
  final HomeController home;
  final bool compact;
  @override
  Widget build(BuildContext context) => BlocBuilder<HomeController, HomeState>(
    bloc: home,
    builder: (context, state) => _build(context, state),
  );

  Widget _build(BuildContext context, HomeState state) {
    final ring = _progressRing(context, state);
    if (compact) return ring;
    final remaining = state.downloadSecondsRemaining;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ring,
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.phase.label(context),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(
                context.strings.homeProgressElapsed(state.elapsed.inSeconds),
              ),
              if (remaining != null)
                Text(context.strings.homeDownloadEstimate(remaining)),
              const SizedBox(height: 6),
              Text(
                context.strings.homeProgressHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _progressRing(BuildContext context, HomeState state) {
    final size = compact ? 30.0 : 80.0;
    final transferring = state.phase == HomePhase.transferring;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: state.operationProgress),
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: transferring ? null : value,
                strokeWidth: compact ? 2 : 5,
                backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                semanticsLabel: state.phase.label(context),
                semanticsValue: transferring
                    ? null
                    : '${(value * 100).round()}%',
              ),
            ),
            if (transferring)
              const Icon(Icons.swap_horiz)
            else
              Text(
                '${(value * 100).round()}%',
                style: TextStyle(
                  fontSize: compact ? 9 : 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
