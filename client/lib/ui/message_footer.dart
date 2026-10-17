import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MessageFooter extends MultiChildRenderObjectWidget {
  MessageFooter({super.key, Widget? reactions, required Widget metadata})
    : super(children: [reactions ?? const SizedBox.shrink(), metadata]);
  @override
  RenderObject createRenderObject(BuildContext context) => _FooterLayout();
}

class _FooterData extends ContainerBoxParentData<RenderBox> {}

class _FooterLayout extends RenderBox
    with
        ContainerRenderObjectMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        >,
        RenderBoxContainerDefaultsMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        > {
  @override
  void setupParentData(RenderBox child) => child.parentData = _FooterData();

  @override
  void performLayout() {
    final left = firstChild!, right = lastChild!;
    right.layout(
      BoxConstraints(maxWidth: constraints.maxWidth),
      parentUsesSize: true,
    );
    final available = math.max(
      0.0,
      constraints.maxWidth - right.size.width - 8,
    );
    left.layout(BoxConstraints(maxWidth: available), parentUsesSize: true);
    final gap = left.size.width == 0 || right.size.width == 0 ? 0 : 8.0;
    size = constraints.constrain(
      Size(
        left.size.width + gap + right.size.width,
        math.max(left.size.height, right.size.height),
      ),
    );
    (left.parentData! as ContainerBoxParentData<RenderBox>).offset =
        Offset.zero;
    (right.parentData! as ContainerBoxParentData<RenderBox>).offset = Offset(
      size.width - right.size.width,
      size.height - right.size.height,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);
  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
