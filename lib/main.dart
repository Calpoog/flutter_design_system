import 'package:flutter/material.dart';
import 'package:flutter_storybook/component.dart';
import 'package:flutter_storybook/controls.dart';

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
  builder: (BuildContext context, Arguments args) {
    return SizedBox(
      width: 200,
      child: TextButton(
        child: Text(args.value('text')),
        onPressed: () {},
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
    'align': ArgType<AlignmentGeometry>(
      name: 'align',
      description: 'The alignment of the text inside the button',
      mapping: {
        'Left': Alignment.centerLeft,
        'Right': Alignment.centerRight,
        'Center': Alignment.center,
      },
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
        Section(name: 'Library', children: [
          Folder(
            name: 'Widgets',
            children: [
              Component(buttonComponent),
              Component(textComponent),
            ],
          )
        ])
      ],
    );
  }
}
