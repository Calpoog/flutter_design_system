import 'package:flutter/material.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/models/component.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/controls.dart';
import 'package:flutter_storybook/models/story.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:flutter_storybook/ui/explorer.dart';

void main() {
  runApp(const MyApp());
}

final Component textComponent = Component(
  name: 'Text',
  builder: (BuildContext context, Arguments args) => TextField(),
  argTypes: [
    ArgType<String>(
      name: 'text',
      description: 'The text to display',
      isRequired: true,
    ),
  ],
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
  'color': Colors.red,
  // 'shape': 'Stadium',
};

final buttonComponent = Component(
  name: 'Button',
  componentPadding: const EdgeInsets.all(20),
  builder: (BuildContext context, Arguments args) {
    return SizedBox(
      width: 200,
      child: TextButton(
        child: Text('${args.value('text')} ${args.value('number')}'),
        onPressed: (args.value('disabled') ?? false) ? null : () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(args.value('color')),
          shape: args.value('shape'),
          alignment: args.value('align'),
        ),
      ),
    );
  },
  argTypes: [
    ArgType<String>(
      name: 'text',
      description: 'The button text',
      defaultValue: 'Default',
      isRequired: true,
    ),
    ArgType<double?>(
      name: 'number',
      description: 'A number',
    ),
    ArgType<AlignmentGeometry?>(
      name: 'align',
      description: 'The alignment of the text inside the button',
      mapping: {
        'Left': Alignment.centerLeft,
        'Right': Alignment.centerRight,
        'Center': Alignment.center,
      },
    ),
    ArgType<MaterialStateProperty<OutlinedBorder>>(
      name: 'shape',
      description: 'The button shape',
      // isRequired: true,
      defaultMapped: 'Stadium',
      mapping: {
        'Stadium': MaterialStateProperty.all(const StadiumBorder()),
        'Rounded long lnas asslakdf jas asdkfa  niureiq q nqn wefqwe':
            MaterialStateProperty.all(const RoundedRectangleBorder()),
      },
      control: Controls().radio(),
    ),
    ArgType<bool?>(
      name: 'disabled',
      description: 'A toggle',
    ),
    ArgType<Color>(
      name: 'color',
      description: 'The button color',
      defaultValue: Colors.red,
      // isRequired: true,
    ),
  ],
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
        RootItem(name: 'Library', children: [
          FolderItem(
            name: 'Widgets',
            children: [
              buttonComponent,
              textComponent,
            ],
          )
        ]),
      ],
    );
  }
}
