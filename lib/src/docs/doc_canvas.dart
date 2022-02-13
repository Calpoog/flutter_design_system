import 'package:flutter/material.dart';
import '../../flutter_design_system.dart';
import '../canvas/canvas.dart';
import '../tools/zoom_tool/zoom_decorator.dart';
import '../tools/zoom_tool/zoom_tool.dart';
import '../ui/toolbar.dart';
import '../ui/utils/bordered.dart';
import '../ui/utils/section.dart';
import 'package:provider/provider.dart';

class DocCanvas extends StatelessWidget {
  const DocCanvas({Key? key, required this.story}) : super(key: key);

  final Story story;

  @override
  Widget build(BuildContext context) {
    final tools = zoomTools();

    return ChangeNotifierProvider(
      create: (_) => ZoomProvider(),
      child: Section(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Bordered.bottom(
              child: Toolbar(tools: tools),
            ),
            Canvas(
              story: story,
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
