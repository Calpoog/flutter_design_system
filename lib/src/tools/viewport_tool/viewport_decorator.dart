import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_design_system/src/storybook.dart';
import 'package:flutter_design_system/src/tools/viewport_tool/viewport_tool.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class ViewportDecorator extends StatelessWidget {
  final Widget child;

  const ViewportDecorator({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    final device = context.watch<ViewportProvider>();
    final story = context.read<Story>();
    const duration = Duration(milliseconds: 150);
    final hasDevice = device.size != null;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        primary: false,
        child: Container(
          color: theme.backgroundDark,
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          alignment: Alignment.topCenter,
          child: AnimatedContainer(
            margin: EdgeInsets.symmetric(vertical: hasDevice ? 10 : 0),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              // color: context.watch<ThemeProvider>().color ?? Colors.white,
              border: hasDevice
                  ? Border.all(
                      color: theme.body,
                    )
                  : null,
            ),
            duration: duration,
            width: device.size?.width ?? constraints.maxWidth,
            height: device.size?.height ?? constraints.maxHeight,
            alignment: Alignment.topLeft,
            child: AnimatedScale(
              alignment: Alignment.topLeft,
              duration: duration,
              scale: device.zoom,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
