import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/docs.dart';
import 'package:provider/provider.dart';

import '../models/story.dart';
import '../models/arguments.dart';
import 'canvas.dart';
import 'panel.dart';

class ComponentView extends StatelessWidget {
  const ComponentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoryNotifier selected = context.watch<StoryNotifier>();

    return ChangeNotifierProvider(
      create: (context) => ArgsNotifier(selected),
      child: KeyedSubtree(
        key: ValueKey('${selected.story!.component.name}-${selected.story!.name}'),
        child: PanelWidget(panels: [
          Panel(name: 'Canvas', content: ComponentCanvas(selected.story!), tools: [
            Tool(name: 'zoom in', icon: Icons.zoom_in_outlined),
            Tool(name: 'zoom out', icon: Icons.zoom_out_outlined),
            Tool(name: 'zoom reset', icon: Icons.youtube_searched_for_outlined),
            Tool(name: 'backgrounds', icon: Icons.image_outlined),
          ]),
          Panel(name: 'Docs', content: Docs()),
        ]),
      ),
    );
  }
}
