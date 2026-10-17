import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Ширина определяется содержимым; нижний ряд получает всю ширину пузырька.
class MessageBodyLayout extends MultiChildRenderObjectWidget {
  const MessageBodyLayout({super.key, required super.children});
  @override
  RenderObject createRenderObject(BuildContext context) => _MessageBody();
}

class _BodyParentData extends ContainerBoxParentData<RenderBox> {}

class _MessageBody extends RenderBox
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
  void setupParentData(RenderBox child) {
    if (child.parentData is! ContainerBoxParentData<RenderBox>) {
      child.parentData = _BodyParentData();
    }
  }

  @override
  void performLayout() {
    var width = 0.0, height = 0.0;
    var child = firstChild;
    while (child != null) {
      child.layout(
        BoxConstraints(maxWidth: constraints.maxWidth),
        parentUsesSize: true,
      );
      width = math.max(width, child.size.width);
      height += child.size.height;
      child =
          (child.parentData! as ContainerBoxParentData<RenderBox>).nextSibling;
    }
    final footer = lastChild;
    if (footer != null) {
      height -= footer.size.height;
      footer.layout(
        BoxConstraints.tightFor(width: width),
        parentUsesSize: true,
      );
      height += footer.size.height;
    }
    size = constraints.constrain(Size(width, height));
    var y = 0.0;
    child = firstChild;
    while (child != null) {
      final data = child.parentData! as ContainerBoxParentData<RenderBox>;
      data.offset = Offset(0, y);
      y += child.size.height;
      child = data.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);
  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
