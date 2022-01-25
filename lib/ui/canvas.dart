import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/arguments.dart';
import '../models/story.dart';
import 'controls_panel.dart';
import 'panel.dart';
import 'utils/bordered.dart';

class ComponentCanvas extends StatefulWidget {
  const ComponentCanvas(this.story, {Key? key}) : super(key: key);

  final Story story;

  @override
  State<ComponentCanvas> createState() => _ComponentCanvasState();
}

class _ComponentCanvasState extends State<ComponentCanvas> {
  bool addOnsOpen = true;

  @override
  Widget build(BuildContext context) {
    final Arguments args = context.watch<ArgsNotifier>().args!;
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              child: Center(
                child: widget.story.builder != null
                    ? widget.story.builder!(context, args)
                    : widget.story.component.builder!(context, args),
              ),
            ),
          ),
        ),
        AnimatedSlide(
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
                child: PanelWidget(
                  tools: [
                    Tool(
                      name: 'close',
                      icon: Icons.close_outlined,
                      onPressed: () => setState(() => addOnsOpen = !addOnsOpen),
                    ),
                  ],
                  panels: [
                    Panel(name: 'Controls', content: const ControlsPanel()),
                    Panel(name: 'Actions', content: const Center(child: Text('Docs'))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
