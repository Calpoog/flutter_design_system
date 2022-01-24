import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../component.dart';
import '../storybook.dart';

class Explorer extends StatelessWidget {
  const Explorer({Key? key, required this.items}) : super(key: key);

  final List<Organized> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                FlutterLogo(),
                Text('Flutterbook'),
              ],
            ),
            ...items,
          ],
        ),
      ),
    );
  }
}

abstract class Organized extends StatelessWidget {
  const Organized({Key? key}) : super(key: key);
}

class Component extends Organized {
  const Component(this.component, {Key? key}) : super(key: key);

  final ComponentMeta component;

  @override
  Widget build(BuildContext context) {
    return component.stories.length > 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(component.name),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    for (final story in component.stories) Selectable(story),
                  ],
                ),
              ),
            ],
          )
        : Selectable(component.stories.first);
  }
}

class Selectable extends Organized {
  const Selectable(this.story, {Key? key}) : super(key: key);

  final Story story;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<StoryNotifier>().update(story);
      },
      child: Row(
        children: [
          const Icon(Icons.crop_square_outlined),
          Text(story.name),
        ],
      ),
    );
  }
}

class Folder extends Organized {
  const Folder({Key? key, required this.name, required this.children}) : super(key: key);

  final String name;
  final List<Organized> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.folder_outlined),
            Text(name),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class Section extends Organized {
  const Section({Key? key, required this.name, required this.children}) : super(key: key);

  final String name;
  final List<Organized> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name),
        ...children,
      ],
    );
  }
}
