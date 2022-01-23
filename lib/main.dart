import 'package:flutter/material.dart';
import 'package:flutter_storybook/component.dart';
import 'package:flutter_storybook/controls.dart';

import 'storybook.dart';
import 'ui/explorer.dart';

void main() {
  runApp(const MyApp());
}

final ComponentMeta buttonComponent = ComponentMeta(
  name: 'Button',
  builder: (BuildContext context, Args args, ComponentActions actions) {
    return SizedBox(
      width: 200,
      child: TextButton(
        child: Text(args.value<String>('text')!),
        onPressed: () => actions.fire('onPressed', [1, 'asdf']),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(args.value<Color>('color')!),
          shape: MaterialStateProperty.all<OutlinedBorder>(args.value<OutlinedBorder>('shape')!),
          alignment: args.value<AlignmentGeometry>('align'),
        ),
      ),
    );
  },
)
  ..define<String>(
    name: 'text',
    description: 'The button text',
    isRequired: true,
  )
  ..define<Color>(
    name: 'color',
    description: 'The button color',
    defaultValue: Colors.red,
    isRequired: true,
  )
  ..define<OutlinedBorder>(
    name: 'shape',
    description: 'The button shape',
    defaultValue: 'Stadium',
    isRequired: true,
    control: SelectControl<OutlinedBorder>(
      options: {
        'Stadium': const StadiumBorder(),
        'Rounded': const RoundedRectangleBorder(),
      },
    ),
  )
  ..define<AlignmentGeometry>(
    name: 'align',
    description: 'The alignment of the text inside the button',
    control: SelectControl<AlignmentGeometry>(
      options: {
        'Left': Alignment.centerLeft,
        'Right': Alignment.centerRight,
        'Center': Alignment.center,
      },
    ),
  )
  ..action<void Function()?>(
    name: 'onPressed',
    description: 'The callback for when the button is pressed',
  )
  ..story(name: 'Default', args: const {
    'text': 'Default',
    'color': Colors.red,
    'shape': 'Stadium',
  })
  ..story(name: 'Primary', extend: 'Default', args: const {
    'text': 'Primary',
    'color': Colors.blue,
  })
  ..story(name: 'Secondary', extend: 'Default', args: const {
    'text': 'Secondary',
    'color': Colors.green,
  });

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Storybook(
      explorer: [
        Section(name: 'Library', children: [
          Folder(
            name: 'Widgets',
            children: [
              Component(buttonComponent),
            ],
          )
        ])
      ],
    );
  }
}
