import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/canvas/canvas.dart';
import 'package:flutter_design_system/src/tools/viewport_tool/viewport_decorator.dart';
import 'package:flutter_design_system/src/tools/viewport_tool/viewport_tool.dart';
import 'package:flutter_design_system/src/tools/theme_tool/theme_tool.dart';
import 'package:flutter_design_system/src/tools/models/tool.dart';
import 'package:flutter_design_system/src/controls/controls_panel.dart';
import 'package:flutter_design_system/src/tools/zoom_tool/zoom_decorator.dart';
import 'package:flutter_design_system/src/tools/zoom_tool/zoom_tool.dart';
import 'package:flutter_design_system/src/ui/panels/panel.dart';
import 'package:flutter_design_system/src/ui/utils/bordered.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class CanvasPanel extends Panel {
  CanvasPanel({Key? key})
      : super(
          name: 'Canvas',
          key: key,
          tools: [
            ...zoomTools(),
            ThemeTool(),
            ViewportTool(),
          ],
        );

  @override
  Widget build(BuildContext context) {
    return Column(
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
                onPressed: (_) => setState(() => addOnsOpen = !addOnsOpen),
              ),
            ],
            panels: [
              ControlsPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
