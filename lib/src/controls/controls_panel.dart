import 'package:flutter/material.dart';
import '../models/arguments.dart';
import '../tools/ui/tool_button.dart';
import 'package:provider/provider.dart';
import '../ui/panels/panel.dart';
import '../models/story.dart';
import '../ui/utils/text.dart';
import '../ui/utils/bordered.dart';

class ControlsPanel extends Panel {
  const ControlsPanel({Key? key, this.story}) : super(name: 'Controls', key: key);

  final Story? story;

  @override
  Widget build(BuildContext context) {
    final Story story = this.story ?? context.watch<Story>();
    return KeyedSubtree(
      key: ValueKey(story),
      child: SingleChildScrollView(
        primary: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    const _Cell(
                      flex: 2,
                      child: AppText.title('Name'),
                    ),
                    const _Cell(
                      flex: 4,
                      child: AppText.title('Description'),
                    ),
                    const _Cell(
                      flex: 2,
                      child: AppText.title('Default'),
                    ),
                    if (story.useControls)
                      _Cell(
                        flex: 4,
                        child: Row(
                          children: [
                            const AppText.title('Control'),
                            const Expanded(child: SizedBox()),
                            ToolButton(
                              icon: Icons.replay,
                              onPressed: () {
                                context.read<Arguments>().reset();
                              },
                              name: 'Reset controls',
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              for (final arg in story.component.argTypes.values)
                Bordered.top(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Cell(
                          flex: 2,
                          child: Row(
                            children: [
                              AppText.body(
                                arg.name,
                                weight: FontWeight.bold,
                              ),
                              if (arg.isRequired) const AppText('*', color: Colors.red),
                            ],
                          ),
                        ),
                        _Cell(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.body(arg.description),
                              const SizedBox(height: 5),
                              CodeText(arg.type.toString()),
                            ],
                          ),
                        ),
                        _Cell(
                          flex: 2,
                          child: Tooltip(
                            message: arg.defaultValue.toString(),
                            child: CodeText(arg.defaultValue.toString()),
                          ),
                        ),
                        if (story.useControls)
                          _Cell(
                            flex: 4,
                            child: arg.control.build(context),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final int flex;
  final Widget child;

  const _Cell({Key? key, this.flex = 1, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: child,
      ),
    );
  }
}
