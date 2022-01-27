import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_storybook/ui/panels/canvas/background_popup.dart';
import 'package:flutter_storybook/ui/panels/canvas/viewport_popup.dart';
import 'package:flutter_storybook/models/story.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/ui/panels/canvas/canvas_panel.dart';
import 'package:flutter_storybook/ui/panels/panel.dart';
import 'package:flutter_storybook/ui/panels/docs_panel.dart';

class ComponentView extends StatelessWidget {
  const ComponentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoryNotifier selected = context.watch<StoryNotifier>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArgsNotifier(selected)),
        ChangeNotifierProvider(create: (context) => ViewportNotifier()),
        ChangeNotifierProvider(create: (context) => BackgroundNotifier()),
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
