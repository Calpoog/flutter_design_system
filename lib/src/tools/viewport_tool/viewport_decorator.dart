import 'package:flutter/material.dart';
import 'viewport_tool.dart';
import '../../ui/utils/theme.dart';
import 'package:provider/provider.dart';

class ViewportDecorator extends StatelessWidget {
  final Widget child;

  const ViewportDecorator({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    final device = context.watch<ViewportProvider>();
    const duration = Duration(milliseconds: 150);
    final hasDevice = device.size != null;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        primary: false,
        child: SingleChildScrollView(
          primary: false,
          scrollDirection: Axis.horizontal,
          child: Container(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            alignment: Alignment.topCenter,
            child: AnimatedContainer(
              margin: EdgeInsets.all(hasDevice ? 10 : 0),
              padding: hasDevice ? const EdgeInsets.all(1.0) : null,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              foregroundDecoration: BoxDecoration(
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
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
