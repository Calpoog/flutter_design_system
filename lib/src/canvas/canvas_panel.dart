import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';
import 'package:flutter_design_system/src/tools/viewport_tool/viewport_tool.dart';
import 'package:provider/provider.dart';
import 'package:flutter_design_system/src/tools/theme_tool/theme_tool.dart';
import 'package:flutter_design_system/src/tools/models/tool.dart';
import 'package:flutter_design_system/src/controls/controls_panel.dart';
import 'package:flutter_design_system/src/ui/panels/panel.dart';
import 'package:flutter_design_system/src/ui/utils/bordered.dart';

class CanvasPanel extends Panel {
  CanvasPanel({Key? key})
      : super(
          name: 'Canvas',
          key: key,
          tools: [
            Tool(
              name: 'Zoom in',
              icon: Icons.zoom_in_outlined,
              onPressed: (context) => context.read<ViewportProvider>().adjustZoom(0.2),
            ),
            Tool(
              name: 'Zoom out',
              icon: Icons.zoom_out_outlined,
              onPressed: (context) => context.read<ViewportProvider>().adjustZoom(-0.2),
            ),
            Tool(
              name: 'Reset zoom',
              icon: Icons.youtube_searched_for_outlined,
              onPressed: (context) => context.read<ViewportProvider>().setZoom(1.0),
              divide: true,
            ),
            ThemeTool(),
            ViewportTool(),
          ],
        );

  @override
  Widget build(BuildContext context) {
    final Arguments args = context.watch<Arguments>();
    final Story story = context.read<Story>();
    final StorybookConfig config = context.read<StorybookConfig>();
    Widget child = story.builder != null ? story.builder!(context, args) : story.component.builder!(context, args);

    child = Container(
      padding: story.componentPadding ?? story.component.componentPadding ?? config.componentPadding,
      child: child,
    );

    if (story.component.decorator != null) {
      child = story.component.decorator!(context, child);
    }
    if (config.decorator != null) {
      child = config.decorator!(context, child);
    }
    for (final tool in tools) {
      child = tool.decorator != null ? tool.decorator!(context, child) : child;
    }

    return Column(
      children: [
        Expanded(
          child: child,
        ),
        const AddOns(),
      ],
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
    return AnimatedSlide(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      offset: addOnsOpen ? Offset.zero : const Offset(0, 251 / 300),
      child: GestureDetector(
        onTap: () {
          if (!addOnsOpen) setState(() => addOnsOpen = true);
        },
        child: Bordered.top(
          child: SizedBox(
            height: 300,
            child: PanelGroup(
              tools: [
                Tool(
                  name: 'close',
                  icon: addOnsOpen ? Icons.expand_more : Icons.expand_less,
                  onPressed: (_) => setState(() => addOnsOpen = !addOnsOpen),
                ),
              ],
              panels: [
                ControlsPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
