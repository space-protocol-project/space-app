import 'package:flutter/material.dart';

import '../src/generated/space/v1/space.pb.dart';

class ReactionPeople extends StatelessWidget {
  const ReactionPeople({super.key, required this.reaction, this.authorName});
  final Reaction reaction;
  final String Function(String)? authorName;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('${reaction.emoji} ${reaction.principalIds.length}'),
      const SizedBox(width: 6),
      SizedBox(
        width: reaction.principalIds.take(3).length * 15.0 + 7,
        height: 24,
        child: Stack(
          children: [
            for (var i = 0; i < reaction.principalIds.length && i < 3; i++)
              Positioned(
                left: i * 15.0,
                child: _person(context, reaction.principalIds[i]),
              ),
          ],
        ),
      ),
    ],
  );

  Widget _person(BuildContext context, String id) {
    final name = authorName?.call(id) ?? id;
    final colors = Theme.of(context).colorScheme;
    final background = Color.alphaBlend(
      _color(id).withValues(alpha: .5),
      colors.surfaceContainerHigh,
    );
    return Tooltip(
      message: name == id ? id : '$name\n$id',
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: Border.all(color: colors.surfaceContainerHigh, width: 1.5),
        ),
        child: Text(
          _initials(name),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    if (name.startsWith('u_')) {
      return name.substring(2).characters.take(2).toString().toUpperCase();
    }
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.characters.first)
        .join()
        .toUpperCase();
  }

  Color _color(String id) {
    const colors = [
      Color(0xff83a598),
      Color(0xffd3869b),
      Color(0xffb8bb26),
      Color(0xfffabd2f),
      Color(0xff8ec07c),
    ];
    return colors[id.codeUnits.fold(0, (sum, c) => sum + c) % colors.length];
  }
}
