import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/arguments.dart';
import '../../models/story.dart';
import 'controls_panel.dart';
import 'panel.dart';
import '../utils/bordered.dart';

class ZoomNotifier extends ChangeNotifier {
  double zoom = 1.0;

  update(double zoom) {
    this.zoom = zoom;
    notifyListeners();
  }

  adjust(double amount) {
    zoom += amount;
    notifyListeners();
  }
}

class CanvasPanel extends Panel {
  CanvasPanel({Key? key})
      : super(name: 'Canvas', key: key, tools: [
          Tool(
            name: 'zoomIn',
            icon: Icons.zoom_in_outlined,
            onPressed: (context) => context.read<ZoomNotifier>().adjust(0.2),
          ),
          Tool(
            name: 'zoomOut',
            icon: Icons.zoom_out_outlined,
            onPressed: (context) => context.read<ZoomNotifier>().adjust(-0.2),
          ),
          Tool(
            name: 'zoomReset',
            icon: Icons.youtube_searched_for_outlined,
            onPressed: (context) => context.read<ZoomNotifier>().update(1.0),
          ),
          Tool(name: 'backgrounds', icon: Icons.image_outlined),
        ]);

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
    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: context.watch<ZoomNotifier>().zoom,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Container(
          // TODO: Box sized for defined devices
          alignment: Alignment.center,
          child: Center(
            child: child,
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
