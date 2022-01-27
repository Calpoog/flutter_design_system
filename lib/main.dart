import 'package:flutter/material.dart';

import 'models/arguments.dart';
import 'models/component.dart';
import 'models/controls.dart';
import 'models/story.dart';
import 'storybook.dart';
import 'ui/explorer.dart';

void main() {
  runApp(const MyApp());
}

final ComponentMeta textComponent = ComponentMeta(
  name: 'Text',
  builder: (BuildContext context, Arguments args) => Text(args.value('text')),
  argTypes: {
    'text': ArgType<String>(
      name: 'text',
      description: 'The text to display',
      isRequired: true,
    ),
  },
  stories: [
    Story(
      name: 'Text',
      args: {
        'text': 'Some text',
      },
    ),
  ],
);

const baseArgs = {
  'text': 'Default',
  'color': Colors.red,
  'shape': 'Stadium',
};

final ComponentMeta buttonComponent = ComponentMeta(
  name: 'Button',
  componentPadding: const EdgeInsets.all(20),
  builder: (BuildContext context, Arguments args) {
    return SizedBox(
      width: 200,
      child: TextButton(
        child: Text(args.value('text')),
        onPressed: args.value('disabled') ? null : () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(args.value('color')),
          shape: MaterialStateProperty.all<OutlinedBorder>(args.value('shape')),
          alignment: args.value('align'),
        ),
      ),
    );
  },
  argTypes: {
    'text': ArgType<String>(
      name: 'text',
      description: 'The button text',
      isRequired: true,
    ),
    'align': ArgType<AlignmentGeometry>(
      name: 'align',
      description: 'The alignment of the text inside the button',
      mapping: {
        'Left': Alignment.centerLeft,
        'Right': Alignment.centerRight,
        'Center': Alignment.center,
      },
    ),
    'disabled': ArgType<bool>(
      name: 'disabled',
      description: 'A toggle',
      defaultValue: false,
    ),
    'color': ArgType<Color>(
      name: 'color',
      description: 'The button color',
      defaultValue: Colors.red,
      isRequired: true,
    ),
    'shape': ArgType<OutlinedBorder>(
      name: 'shape',
      description: 'The button shape',
      isRequired: true,
      defaultMapped: 'Stadium',
      mapping: {
        'Stadium': const StadiumBorder(),
        'Rounded': const RoundedRectangleBorder(),
      },
      control: Controls().radio(),
    ),
  },
  stories: [
    Story(
      name: 'Default',
      args: baseArgs,
    ),
    Story(
      name: 'Primary',
      args: Map.of(baseArgs)
        ..addAll(const {
          'text': 'Primary',
          'color': Colors.blue,
        }),
    ),
    Story(
      name: 'Secondary',
      args: Map.of(baseArgs)
        ..addAll(const {
          'text': 'Secondary',
          'color': Colors.green,
        }),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Storybook(
      explorer: [
        Root(name: 'Library', children: [
          Folder(
            name: 'Widgets',
            children: [
              Component(component: buttonComponent),
              Component(component: textComponent),
            ],
          )
        ]),
        Root(name: 'Something', children: [
          Component(component: buttonComponent),
          Component(component: textComponent),
        ])
      ],
    );
  }
}
