import 'package:flutter/material.dart';
import 'package:space_admin_ui/space_admin_ui.dart'
    show spaceControls, SpacedControl;
export 'package:space_admin_ui/space_admin_ui.dart' show spaceControls;

const areaRadius = 20.0;

class RegionFrame extends StatelessWidget {
  const RegionFrame({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(areaRadius),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(areaRadius - 1),
        child: child,
      ),
    ),
  );
}

class SurfaceCard extends StatefulWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.color,
    this.hoverBorder = false,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final bool hoverBorder;
  @override
  State<SurfaceCard> createState() => _SurfaceCardState();
}

class _SurfaceCardState extends State<SurfaceCard> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (!widget.hoverBorder) {
      return Material(
        color: widget.color ?? colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(areaRadius),
          side: BorderSide(color: colors.outlineVariant),
        ),
        child: Padding(
          padding: widget.padding,
          child: spaceControls(widget.child),
        ),
      );
    }
    final card = AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: widget.color ?? colors.surface,
        borderRadius: BorderRadius.circular(areaRadius),
        border: Border.all(
          color: hovered
              ? colors.outlineVariant
              : colors.outlineVariant.withValues(alpha: 0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(areaRadius),
        child: Padding(
          padding: widget.padding,
          child: spaceControls(widget.child),
        ),
      ),
    );
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: card,
    );
  }
}

class PageBody extends StatelessWidget {
  const PageBody({
    super.key,
    required this.title,
    required this.description,
    required this.children,
  });
  final String title, description;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1050),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            ...children,
          ],
        ),
      ),
    ),
  );
}

class AdaptiveCards extends StatelessWidget {
  const AdaptiveCards({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      if (box.maxWidth < 650) {
        return Column(
          children: [
            for (final child in children)
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: SizedBox(width: double.infinity, child: child),
              ),
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 18),
            Expanded(child: children[i]),
          ],
        ],
      );
    },
  );
}

class SpaceActionButton extends StatelessWidget implements SpacedControl {
  const SpaceActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: colors.surfaceContainerHigh,
        foregroundColor: colors.onSurface,
        side: BorderSide(color: colors.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        minimumSize: const Size(0, 60),
        visualDensity: VisualDensity.standard,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 19,
              color: onPressed == null
                  ? colors.onSurfaceVariant
                  : colors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
