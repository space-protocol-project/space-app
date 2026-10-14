import 'package:flutter/material.dart';

import 'space_appearance.dart';

class SpaceContentInsets extends InheritedWidget {
  const SpaceContentInsets({
    super.key,
    required this.top,
    required super.child,
  });
  final double top;
  static double topOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SpaceContentInsets>()?.top ??
      0;
  @override
  bool updateShouldNotify(SpaceContentInsets oldWidget) => top != oldWidget.top;
}

class SpaceFrame extends StatelessWidget {
  const SpaceFrame({
    super.key,
    required this.compact,
    required this.rail,
    required this.sidebar,
    required this.content,
    this.navigationOpen = false,
    this.closeNavigation,
    this.openNavigation,
  });
  final bool compact, navigationOpen;
  final Widget rail, sidebar, content;
  final VoidCallback? closeNavigation, openNavigation;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: compact
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!compact) SizedBox(width: SpaceAppearance.railWidth, child: rail),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                compact ? 0 : SpaceAppearance.radius,
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!compact) sidebar,
                      Expanded(
                        key: const ValueKey('space-content'),
                        child: ExcludeFocus(
                          excluding: compact && navigationOpen,
                          child: IgnorePointer(
                            ignoring: compact && navigationOpen,
                            child: ColoredBox(
                              color: SpaceAppearance.of(context).main,
                              child: content,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (compact)
                    Positioned.fill(
                      child: _NavigationOverlay(
                        open: navigationOpen,
                        onOpen: openNavigation,
                        onClose: closeNavigation,
                        child: sidebar,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _NavigationOverlay extends StatelessWidget {
  const _NavigationOverlay({
    required this.open,
    required this.child,
    this.onOpen,
    this.onClose,
  });
  final bool open;
  final Widget child;
  final VoidCallback? onOpen, onClose;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final reduced = MediaQuery.disableAnimationsOf(context);
      return ClipRect(
        child: Stack(
          children: [
            if (open)
              Positioned.fill(
                child: GestureDetector(
                  onTap: onClose,
                  child: ColoredBox(color: Colors.black.withValues(alpha: .35)),
                ),
              ),
            if (!open && onOpen != null)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: 24,
                child: _NavigationSwipe(
                  opening: true,
                  onSwipe: onOpen!,
                  child: const SizedBox.expand(),
                ),
              ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: (box.maxWidth - 48).clamp(0, 320),
              child: IgnorePointer(
                ignoring: !open,
                child: ExcludeFocus(
                  excluding: !open,
                  child: ExcludeSemantics(
                    excluding: !open,
                    child: AnimatedSlide(
                      offset: open ? Offset.zero : const Offset(-1, 0),
                      duration: reduced
                          ? Duration.zero
                          : const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      child: AnimatedOpacity(
                        opacity: open ? 1 : 0,
                        duration: reduced
                            ? Duration.zero
                            : const Duration(milliseconds: 200),
                        child: _NavigationSwipe(
                          opening: false,
                          onSwipe: onClose ?? () {},
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _NavigationSwipe extends StatefulWidget {
  const _NavigationSwipe({
    required this.opening,
    required this.onSwipe,
    required this.child,
  });
  final bool opening;
  final VoidCallback onSwipe;
  final Widget child;
  @override
  State<_NavigationSwipe> createState() => _NavigationSwipeState();
}

class _NavigationSwipeState extends State<_NavigationSwipe> {
  double distance = 0;
  void finish(DragEndDetails details) {
    final direction = widget.opening ? 1 : -1;
    if (distance * direction > 70 ||
        (details.primaryVelocity ?? 0) * direction > 500) {
      widget.onSwipe();
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onHorizontalDragStart: (_) => distance = 0,
    onHorizontalDragUpdate: (event) => distance += event.delta.dx,
    onHorizontalDragEnd: finish,
    child: widget.child,
  );
}

class SpaceHeader extends StatelessWidget {
  const SpaceHeader({
    super.key,
    required this.title,
    required this.leading,
    required this.actions,
    this.subtitle,
    this.minHeight = SpaceAppearance.headerHeight,
  });
  final String title;
  final double minHeight;
  final String? subtitle;
  final List<Widget> leading, actions;
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(minHeight: minHeight),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          ...leading,
          Expanded(
            child: IgnorePointer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
          ...actions,
        ],
      ),
    ),
  );
}
