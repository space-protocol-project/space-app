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
  });
  final bool compact;
  final Widget rail, sidebar, content;
  final bool navigationOpen;
  final VoidCallback? closeNavigation;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        compact ? 4 : 10,
        compact ? 4 : 10,
        compact ? 4 : 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: compact ? 52 : SpaceAppearance.railWidth,
            child: rail,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SpaceAppearance.radius),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!compact) sidebar,
                      Expanded(
                        key: const ValueKey('space-content'),
                        child: ColoredBox(
                          color: SpaceAppearance.of(context).main,
                          child: content,
                        ),
                      ),
                    ],
                  ),
                  if (compact)
                    Positioned.fill(
                      child: ClipRect(
                        child: Stack(
                          children: [
                            if (navigationOpen)
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: closeNavigation,
                                  child: ColoredBox(
                                    color: Colors.black.withValues(alpha: .18),
                                  ),
                                ),
                              ),
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              width: SpaceAppearance.sidebarWidth,
                              child: IgnorePointer(
                                ignoring: !navigationOpen,
                                child: ExcludeFocus(
                                  excluding: !navigationOpen,
                                  child: AnimatedSlide(
                                    offset: navigationOpen
                                        ? Offset.zero
                                        : const Offset(-1, 0),
                                    duration:
                                        MediaQuery.disableAnimationsOf(context)
                                        ? Duration.zero
                                        : const Duration(milliseconds: 280),
                                    curve: Curves.easeOutCubic,
                                    child: AnimatedOpacity(
                                      opacity: navigationOpen ? 1 : 0,
                                      duration:
                                          MediaQuery.disableAnimationsOf(
                                            context,
                                          )
                                          ? Duration.zero
                                          : const Duration(milliseconds: 200),
                                      child: sidebar,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

class SpaceHeader extends StatelessWidget {
  const SpaceHeader({
    super.key,
    required this.title,
    required this.leading,
    required this.actions,
    this.subtitle,
  });
  final String title;
  final String? subtitle;
  final List<Widget> leading, actions;
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: SpaceAppearance.headerHeight),
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
