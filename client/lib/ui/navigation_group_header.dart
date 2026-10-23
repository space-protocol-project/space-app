import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class NavigationGroupHeader extends StatelessWidget {
  const NavigationGroupHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.refreshTooltip,
    required this.onTap,
    required this.onRefresh,
    this.selected = false,
    this.leadingInset = 16,
  });

  final IconData icon;
  final String title, refreshTooltip;
  final VoidCallback? onTap, onRefresh;
  final bool selected;
  final double leadingInset;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.only(left: leadingInset),
    minLeadingWidth: 20,
    horizontalTitleGap: 28 - leadingInset,
    leading: Icon(icon, size: 20),
    title: Tooltip(
      message: title,
      child: AutoSizeText(
        title,
        style: Theme.of(context).textTheme.titleMedium,
        maxLines: 1,
        minFontSize: 12,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    selected: selected,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
    onTap: onTap,
    trailing: IconButton(
      tooltip: refreshTooltip,
      onPressed: onRefresh,
      icon: const Icon(Icons.refresh, size: 20),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 40, height: 48),
    ),
  );
}
