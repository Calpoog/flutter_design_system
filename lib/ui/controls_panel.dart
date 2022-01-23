import 'package:flutter/material.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:provider/provider.dart';

class ControlsPanel extends StatelessWidget {
  const ControlsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SelectedComponent selected = context.read<SelectedComponent>();
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: Text('Name'),
            ),
            Expanded(
              child: Text('Type'),
            ),
            Expanded(
              child: Text('Description'),
            ),
            Expanded(
              child: Text('Default'),
            ),
            Expanded(
              child: Text('Control'),
            ),
          ],
        ),
        for (final arg in selected.component!.args.values)
          Row(
            children: [
              Expanded(
                child: Text(arg.name),
              ),
              Expanded(
                child: Text(arg.type.toString()),
              ),
              Expanded(
                child: Text(arg.description),
              ),
              Expanded(
                child: Text(arg.defaultValue.runtimeType.toString()),
              ),
              Expanded(
                child: arg.control.build(context, selected.story!.initial[arg.control.name]),
              ),
            ],
          ),
      ],
    );
  }
}
