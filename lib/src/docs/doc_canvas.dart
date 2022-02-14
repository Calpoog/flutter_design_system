import 'package:flutter/material.dart';
import '../controls/controls_panel.dart';
import '../models/arguments.dart';
import '../models/story.dart';
import '../canvas/canvas.dart';
import '../tools/zoom_tool/zoom_decorator.dart';
import '../tools/zoom_tool/zoom_tool.dart';
import '../ui/toolbar.dart';
import '../ui/utils/bordered.dart';
import '../ui/utils/section.dart';
import 'package:provider/provider.dart';

class DocCanvas extends StatelessWidget {
  const DocCanvas({
    Key? key,
    required this.story,
    this.showArgsTable = false,
  }) : super(key: key);

  final Story story;
  final bool showArgsTable;

  @override
  Widget build(BuildContext context) {
    final tools = zoomTools();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ZoomProvider()),
        ChangeNotifierProvider(create: (context) => Arguments(story: story)),
      ],
      child: Column(
        children: [
          Section(
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
          if (showArgsTable)
            Section(
              child: ControlsPanel(story: story),
              margin: const EdgeInsets.only(bottom: 20.0),
            ),
        ],
      ),
    );
  }
}
