import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';
import 'package:flutter_design_system/src/canvas/canvas.dart';
import 'package:flutter_design_system/src/tools/zoom_tool/zoom_decorator.dart';
import 'package:flutter_design_system/src/tools/zoom_tool/zoom_tool.dart';
import 'package:flutter_design_system/src/ui/toolbar.dart';
import 'package:flutter_design_system/src/ui/utils/bordered.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class DocCanvas extends StatelessWidget {
  const DocCanvas({Key? key, required this.story}) : super(key: key);

  final Story story;

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    final tools = zoomTools();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Arguments(story)),
        ChangeNotifierProvider(create: (_) => ZoomProvider()),
      ],
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(color: theme.border),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Bordered.bottom(
              child: Toolbar(tools: tools),
            ),
            Canvas(
              decorators: [
                (context, child, globals) => ZoomDecorator(child: child),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
