import 'package:flutter/material.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:flutter_storybook/ui/panels/canvas/background_popup.dart';
import 'package:flutter_storybook/ui/panels/canvas/device_popup.dart';
import 'package:flutter_storybook/ui/panels/tools/tool.dart';
import 'package:provider/provider.dart';

import '../../../models/arguments.dart';
import '../../../models/story.dart';
import '../../utils/theme.dart';
import '../controls_panel.dart';
import '../panel.dart';
import '../../utils/bordered.dart';

class CanvasPanel extends Panel {
  CanvasPanel({Key? key})
      : super(
          name: 'Canvas',
          key: key,
          tools: [
            Tool(
              name: 'Zoom in',
              icon: Icons.zoom_in_outlined,
              onPressed: (context) => context.read<DeviceNotifier>().adjustZoom(0.2),
            ),
            Tool(
              name: 'Zoom out',
              icon: Icons.zoom_out_outlined,
              onPressed: (context) => context.read<DeviceNotifier>().adjustZoom(-0.2),
            ),
            Tool(
              name: 'Reset zoom',
              icon: Icons.youtube_searched_for_outlined,
              onPressed: (context) => context.read<DeviceNotifier>().setZoom(1.0),
              divide: true,
            ),
            BackgroundTool(),
            DevicesTool(),
          ],
        );

  @override
  Widget build(BuildContext context) {
    final Arguments args = context.watch<ArgsNotifier>().args!;
    final Story story = context.read<StoryNotifier>().story!;

    return Column(
      children: [
        Expanded(
          child: _ScalableCanvas(
            child: story.builder != null ? story.builder!(context, args) : story.component.builder!(context, args),
          ),
        ),
        const AddOns(),
      ],
    );
  }
}

class _ScalableCanvas extends StatelessWidget {
  final Widget child;

  const _ScalableCanvas({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    final device = context.watch<DeviceNotifier>();
    final story = context.read<StoryNotifier>().story!;
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
            padding: story.componentPadding ??
                story.component.componentPadding ??
                context.read<StorybookConfig>().componentPadding,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: context.watch<BackgroundNotifier>().color ?? Colors.white,
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
