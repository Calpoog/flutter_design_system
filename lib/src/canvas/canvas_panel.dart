import 'package:flutter/material.dart';
import '../tools/models/tool.dart';
import '../models/arguments.dart';
import '../models/story.dart';
import 'canvas.dart';
import '../tools/ui/divider.dart';
import '../tools/viewport_tool/viewport_decorator.dart';
import '../tools/theme_tool/theme_tool.dart';
import '../controls/controls_panel.dart';
import '../tools/viewport_tool/viewport_tool.dart';
import '../tools/zoom_tool/zoom_decorator.dart';
import '../tools/zoom_tool/zoom_tool.dart';
import '../ui/panels/panel.dart';
import '../ui/utils/bordered.dart';
import '../ui/utils/theme.dart';
import 'package:provider/provider.dart';

class CanvasPanel extends Panel {
  const CanvasPanel({Key? key})
      : super(
          name: 'Canvas',
          key: key,
        );

  @override
  List<Widget> toolsBuilder(BuildContext context) {
    return [...zoomTools(), const ToolDivider(), const ThemeTool(), const ViewportTool()];
  }

  @override
  Widget build(BuildContext context) {
    final story = context.read<Story>();
    return ChangeNotifierProvider(
      create: (context) => Arguments(story: story, context: context),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.topCenter,
              color: context.read<AppTheme>().backgroundDark,
              child: ViewportDecorator(
                child: Canvas(
                  decorators: [
                    (context, child, globals) => ZoomDecorator(child: child),
                    ThemeTool.decorator,
                  ],
                ),
              ),
            ),
          ),
          if (story.component.controlCount > 0) const AddOns(),
        ],
      ),
    );
  }
}

class AddOns extends StatefulWidget {
  const AddOns({Key? key}) : super(key: key);

  @override
  State<AddOns> createState() => _AddOnsState();
}

class _AddOnsState extends State<AddOns> {
  bool addOnsOpen = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      height: addOnsOpen ? 300 : 42,
      child: Bordered.top(
        child: GestureDetector(
          onTap: () {
            if (!addOnsOpen) setState(() => addOnsOpen = true);
          },
          child: PanelGroup(
            tools: [
              Tool(
                name: 'close',
                icon: addOnsOpen ? Icons.expand_more : Icons.expand_less,
                onPressed: () => setState(() => addOnsOpen = !addOnsOpen),
              ),
            ],
            panels: const [
              ControlsPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
