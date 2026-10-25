import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'avatar_data.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    super.key,
    this.data = const [],
    this.radius = 16,
    this.fallback,
  });
  final List<int> data;
  final double radius;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final placeholder = CircleAvatar(
      radius: radius,
      child: fallback ?? Icon(Icons.person_outline, size: radius * 1.15),
    );
    if (!validProfileAvatar(data)) return placeholder;
    return ClipOval(
      child: Image.memory(
        Uint8List.fromList(data),
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}

List<int> memberAvatarData(Object? encoded) {
  if (encoded is! String || encoded.length > 10924) return const [];
  try {
    return base64Decode(encoded);
  } catch (_) {
    return const [];
  }
}
