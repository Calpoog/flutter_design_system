import 'package:flutter/material.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:provider/provider.dart';

import '../../models/arguments.dart';
import '../../models/story.dart';
import '../text.dart';
import '../theme.dart';
import 'controls_panel.dart';
import 'panel.dart';
import '../utils/bordered.dart';

class DeviceNotifier extends ChangeNotifier {
  double zoom = 1.0;
  Size? size;

  setZoom(double zoom) {
    this.zoom = zoom;
    notifyListeners();
  }

  adjustZoom(double amount) {
    zoom += amount;
    notifyListeners();
  }

  setSize(Size? size) {
    this.size = size;
    notifyListeners();
  }
}

class CanvasPanel extends Panel {
  CanvasPanel({Key? key})
      : super(
          name: 'Canvas',
          key: key,
          tools: [
            Tool(
              name: 'zoomIn',
              icon: Icons.zoom_in_outlined,
              onPressed: (context) => context.read<DeviceNotifier>().adjustZoom(0.2),
            ),
            Tool(
              name: 'zoomOut',
              icon: Icons.zoom_out_outlined,
              onPressed: (context) => context.read<DeviceNotifier>().adjustZoom(-0.2),
            ),
            Tool(
              name: 'zoomReset',
              icon: Icons.youtube_searched_for_outlined,
              onPressed: (context) => context.read<DeviceNotifier>().setZoom(1.0),
            ),
            Tool(name: 'backgrounds', icon: Icons.image_outlined),
            Tool(
              name: 'deviceSize',
              icon: Icons.devices_outlined,
              popup: (context, close) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const AppText.body('Reset viewport'),
                    dense: true,
                    onTap: () {
                      context.read<DeviceNotifier>().setSize(null);
                      close();
                    },
                  ),
                  ...context
                      .read<StorybookConfig>()
                      .deviceSizes
                      .entries
                      .map(
                        (entry) => ListTile(
                          title: AppText.body(entry.key),
                          dense: true,
                          onTap: () {
                            context.read<DeviceNotifier>().setSize(entry.value);
                            close();
                          },
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
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
    const duration = Duration(milliseconds: 200);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        primary: false,
        child: Container(
          color: theme.border,
          alignment: Alignment.topCenter,
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Colors.white,
              border: device.size != null
                  ? Border.all(
                      color: context.read<AppTheme>().body,
                    )
                  : null,
            ),
            duration: duration,
            width: device.size?.width ?? constraints.maxWidth,
            height: device.size?.height ?? constraints.maxHeight,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.topLeft,
            child: AnimatedScale(
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
                  icon: Icons.close_outlined,
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
