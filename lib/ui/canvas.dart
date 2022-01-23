import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:provider/provider.dart';
import '../component.dart';

class ComponentCanvas extends StatelessWidget {
  const ComponentCanvas(this.component, {Key? key}) : super(key: key);

  final ComponentMeta component;

  @override
  Widget build(BuildContext context) {
    context.watch<Args>();
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        child: Center(
          child: component.builder(
            context,
            context.read<SelectedComponent>().story!.args,
            component.createActions(),
          ),
        ),
      ),
    );
  }
}
