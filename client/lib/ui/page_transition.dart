import 'package:flutter/widgets.dart';

/// Анимирует появление текущего экрана без удержания предыдущего содержимого.
class PageTransition extends StatefulWidget {
  const PageTransition({
    super.key,
    required this.transitionKey,
    required this.child,
  });
  final Object? transitionKey;
  final Widget child;

  @override
  State<PageTransition> createState() => _PageTransitionState();
}

class _PageTransitionState extends State<PageTransition>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
    value: 1,
  );
  late final curve = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
  );
  late final position = Tween(
    begin: const Offset(0, .012),
    end: Offset.zero,
  ).animate(curve);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeOf(context)?.disableAnimations == true) {
      animation.value = 1;
    }
  }

  @override
  void didUpdateWidget(PageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transitionKey == widget.transitionKey) return;
    if (MediaQuery.maybeOf(context)?.disableAnimations == true) {
      animation.value = 1;
    } else {
      animation.forward(from: 0);
    }
  }

  @override
  void dispose() {
    curve.dispose();
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: curve,
    child: SlideTransition(position: position, child: widget.child),
  );
}
