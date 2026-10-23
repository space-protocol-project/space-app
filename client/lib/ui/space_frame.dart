import 'package:flutter/material.dart';

import 'space_appearance.dart';

export 'package:space_admin_ui/space_admin_ui.dart' show SpaceContentInsets;

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
            key: const ValueKey('space-workspace'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                compact ? 0 : SpaceAppearance.radius,
              ),
              child: LayoutBuilder(builder: _layout),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _layout(BuildContext context, BoxConstraints box) {
    final desiredWidth = compact ? 320.0 : SpaceAppearance.sidebarWidth;
    final availableWidth = (box.maxWidth - 56).clamp(0.0, double.infinity);
    final navigationWidth = desiredWidth.clamp(0.0, availableWidth);
    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            width: navigationWidth,
            child: _navigation(),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: navigationOpen ? 1 : 0),
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            builder: (context, progress, child) => _foreground(
              context,
              box,
              navigationWidth * progress,
              progress,
              child!,
            ),
            child: content,
          ),
          if (compact && !navigationOpen && openNavigation != null)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: 24,
              child: _NavigationSwipe(
                opening: true,
                onSwipe: openNavigation!,
                child: const SizedBox.expand(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _navigation() => ClipRect(
    child: IgnorePointer(
      ignoring: !navigationOpen,
      child: ExcludeFocus(
        excluding: !navigationOpen,
        child: ExcludeSemantics(
          excluding: !navigationOpen,
          child: _NavigationSwipe(
            opening: false,
            onSwipe: closeNavigation ?? () {},
            child: sidebar,
          ),
        ),
      ),
    ),
  );

  Widget _foreground(
    BuildContext context,
    BoxConstraints box,
    double offset,
    double progress,
    Widget child,
  ) {
    final radius = BorderRadius.circular(
      compact ? SpaceAppearance.radius * progress : 0,
    );
    return Positioned(
      top: 0,
      bottom: 0,
      left: offset,
      width: compact ? box.maxWidth : box.maxWidth - offset,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: compact ? .16 * progress : 0,
              ),
              blurRadius: 24,
              offset: const Offset(-4, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: ColoredBox(
            key: const ValueKey('space-content'),
            color: SpaceAppearance.of(context).main,
            child: _content(context, child),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, Widget child) {
    final modal = compact && navigationOpen;
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeFocus(
          excluding: modal,
          child: ExcludeSemantics(
            excluding: modal,
            child: IgnorePointer(ignoring: modal, child: child),
          ),
        ),
        if (modal)
          _NavigationSwipe(
            opening: false,
            onSwipe: closeNavigation ?? () {},
            child: Semantics(
              button: true,
              label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
              onDismiss: closeNavigation,
              child: GestureDetector(
                key: const ValueKey('navigation-dismiss'),
                behavior: HitTestBehavior.opaque,
                onTap: closeNavigation,
                child: ColoredBox(color: Colors.black.withValues(alpha: .12)),
              ),
            ),
          ),
      ],
    );
  }
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
