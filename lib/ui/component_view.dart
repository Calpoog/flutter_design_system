import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/story.dart';
import '../models/arguments.dart';
import 'panels/canvas_panel.dart';
import 'panels/panel.dart';
import 'panels/docs_panel.dart';

class ComponentView extends StatelessWidget {
  const ComponentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoryNotifier selected = context.watch<StoryNotifier>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArgsNotifier(selected)),
        ChangeNotifierProvider(create: (context) => ZoomNotifier()),
      ],
      child: KeyedSubtree(
        key: ValueKey('${selected.story!.component.name}-${selected.story!.name}'),
        child: PanelGroup(panels: [
          CanvasPanel(),
          DocsPanel(),
        ]),
      ),
    );
  }
}
