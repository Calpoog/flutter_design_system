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
    final SelectedComponent selected = context.watch<SelectedComponent>();
    final ComponentMeta component = selected.component!;
    final Args args = selected.story!.args;
    return ChangeNotifierProvider.value(
      value: args,
      child: KeyedSubtree(
        key: ValueKey('${component.name}-${selected.story!.name}'),
        child: Column(
          children: [
            Expanded(
              child: ComponentCanvas(component),
            ),
            const ControlsPanel(),
          ],
        ),
      ),
    );
  }
}
