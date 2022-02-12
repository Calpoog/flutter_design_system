import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// ignore: prefer_relative_imports
import 'package:flutter_design_system/src/tools/zoom_tool/zoom_tool.dart';
import 'package:provider/provider.dart';

class ZoomDecorator extends StatefulWidget {
  const ZoomDecorator({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<ZoomDecorator> createState() => _ZoomDecoratorState();
}

class _ZoomDecoratorState extends State<ZoomDecorator> {
  Size? initialSize;

  void onChildSized(Size size) {
    debugPrint('sized $size');
    initialSize = size;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ZoomProvider>();
    const duration = Duration(milliseconds: 150);

    return Stack(
      children: [
        AnimatedContainer(
          // color: Colors.green,
          duration: duration,
          height: initialSize == null ? null : initialSize!.height * provider.zoom,
          width: initialSize == null ? null : initialSize!.width * provider.zoom,
        ),
        AnimatedScale(
          alignment: Alignment.topLeft,
          duration: duration,
          scale: provider.zoom,
          child: MeasurableWidget(
            child: widget.child,
            onChange: onChildSized,
          ),
        ),
      ],
    );
  }
}

class MeasurableWidget extends SingleChildRenderObjectWidget {
  const MeasurableWidget({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  final void Function(Size size) onChange;

  @override
  RenderObject createRenderObject(BuildContext context) => MeasureSizeRenderObject(onChange);
}

class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);

  final void Function(Size size) onChange;
  Size _prevSize = Size.zero;

  @override
  void performLayout() {
    super.performLayout();
    Size newSize = child?.size ?? Size.zero;
    if (_prevSize == newSize) return;
    _prevSize = newSize;
    WidgetsBinding.instance?.addPostFrameCallback((_) => onChange(newSize));
  }
}
