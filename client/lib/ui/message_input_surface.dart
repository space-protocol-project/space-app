import 'package:flutter/material.dart';

import 'space_appearance.dart';

class MessageInputSurface extends StatelessWidget {
  const MessageInputSurface({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.bottomCenter,
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: SpaceAppearance.conversationWidth,
      ),
      child: GlassSurface(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 14),
          child: child,
        ),
      ),
    ),
  );
}

InputDecoration messageInputDecoration(String hint) => InputDecoration(
  hintText: hint,
  counterText: '',
  filled: false,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  border: InputBorder.none,
  enabledBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  focusedErrorBorder: InputBorder.none,
);
