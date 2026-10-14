import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Высота поля зависит от текста и масштаба; уведомление приходит после layout.
class MeasureSize extends SingleChildRenderObjectWidget {
  const MeasureSize({super.key, required this.onChange, required super.child});
  final ValueChanged<Size> onChange;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      _SizeObserver(onChange);
  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderProxyBox renderObject,
  ) {
    (renderObject as _SizeObserver).onChange = onChange;
  }
}

class _SizeObserver extends RenderProxyBox {
  _SizeObserver(this.onChange);
  ValueChanged<Size> onChange;
  Size? previous;
  @override
  void performLayout() {
    super.performLayout();
    if (size == previous) return;
    previous = size;
    final measured = size;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (attached) onChange(measured);
    });
  }
}
