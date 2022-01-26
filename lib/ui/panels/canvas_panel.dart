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

class BackgroundNotifier extends ChangeNotifier {
  Color color = Colors.white;

  update(Color color) {
    this.color = color;
    notifyListeners();
  }
}

Widget _backgroundPopup(BuildContext context) {
  final overlay = context.read<OverlayNotifier>();
  final theme = context.read<AppTheme>();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: context
        .read<StorybookConfig>()
        .backgrounds
        .entries
        .map(
          (entry) => _buildPopupListTile(
            context,
            child: AppText.body(entry.key),
            trailing: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: entry.value,
                border: Border.all(color: theme.backgroundDark),
              ),
            ),
            onTap: () {
              context.read<BackgroundNotifier>().update(entry.value);
              overlay.close();
            },
          ),
        )
        .toList(),
  );
}

Widget _devicePopup(BuildContext context) {
  final device = context.read<DeviceNotifier>();
  final overlay = context.read<OverlayNotifier>();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildPopupListTile(
        context,
        child: const AppText.body('Reset viewport'),
        onTap: () {
          device.setSize(null);
          overlay.close();
        },
      ),
      ...context
          .read<StorybookConfig>()
          .deviceSizes
          .entries
          .map(
            (entry) => _buildPopupListTile(
              context,
              child: AppText.body(entry.key),
              onTap: () {
                device.setSize(entry.value);
                overlay.close();
              },
            ),
          )
          .toList(),
    ],
  );
}

Widget _buildPopupListTile(
  BuildContext context, {
  required Widget child,
  void Function()? onTap,
  Widget? trailing,
}) {
  return ListTile(
    title: child,
    hoverColor: context.read<AppTheme>().background,
    dense: true,
    onTap: onTap,
    trailing: trailing,
  );
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
            Tool(
              name: 'backgrounds',
              icon: Icons.image_outlined,
              popup: _backgroundPopup,
            ),
            Tool(
              name: 'deviceSize',
              icon: Icons.devices_outlined,
              popup: _devicePopup,
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
    final story = context.read<StoryNotifier>().story!;
    const duration = Duration(milliseconds: 150);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        primary: false,
        child: Container(
          color: theme.backgroundDark,
          alignment: Alignment.topCenter,
          child: AnimatedContainer(
            padding: story.componentPadding ??
                story.component.componentPadding ??
                context.read<StorybookConfig>().componentPadding,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: context.watch<BackgroundNotifier>().color,
              border: device.size != null
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
