import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';

void main() {
  runApp(const MyApp());
}

final Component textComponent = Component(
  name: 'Card',
  builder: (BuildContext context, Arguments args) => const Card(
    child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Text('This is a card'),
    ),
  ),
  argTypes: [],
  stories: [
    Story(
      name: 'Card',
    ),
  ],
);

final buttonComponent = Component(
  name: 'Button',
  markdownString: 'This is the component markdown.',
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
      defaultValue: Colors.grey,
      // isRequired: true,
    ),
  ],
  stories: [
    Story(
      name: 'Default',
      markdownString: 'The default button.',
      // args: baseArgs,
    ),
    Story(
      name: 'Primary',
      markdownString: 'A primary button for primary things.',
      args: const {
        'text': 'Primary',
        'color': Colors.blue,
      },
    ),
    Story(
      name: 'Secondary',
      markdownString: 'A secondary button for secondary things.',
      args: const {
        'text': 'Secondary',
        'color': Colors.green,
      },
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
