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
  Widget build(BuildContext context) {
    final size = compact ? 30.0 : 80.0;
    final ring = TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: home.operationProgress),
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
                value: value,
                strokeWidth: compact ? 2 : 5,
                backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                semanticsLabel: home.phase.label(context),
                semanticsValue: '${(value * 100).round()}%',
              ),
            ),
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
    if (compact) return ring;
    final remaining = home.downloadSecondsRemaining;
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
                home.phase.label(context),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(context.strings.homeProgressElapsed(home.elapsed.inSeconds)),
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
}
