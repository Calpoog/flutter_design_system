import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:flutter_storybook/ui/canvas.dart';
import 'package:flutter_storybook/ui/controls_panel.dart';
import 'package:provider/provider.dart';

import '../component.dart';

class ComponentView extends StatelessWidget {
  const ComponentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoryNotifier selected = context.watch<StoryNotifier>();

    return ChangeNotifierProvider(
      lazy: false,
      create: (context) => ArgsNotifier(selected),
      child: KeyedSubtree(
        key: ValueKey('${selected.story!.component.name}-${selected.story!.name}'),
        child: Column(
          children: [
            Expanded(
              child: ComponentCanvas(selected.story!),
            ),
            const ControlsPanel(),
          ],
        ),
      ),
    );
  }
}
