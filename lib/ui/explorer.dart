import 'package:flutter/material.dart';
import '../models/story.dart';
import '../ui/text.dart';
import '../ui/theme.dart';
import 'package:provider/provider.dart';

import '../models/component.dart';

class Explorer extends StatelessWidget {
  const Explorer({Key? key, required this.items}) : super(key: key);

  final List<Organized> items;

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return SingleChildScrollView(
      child: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(size: 13),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: const [
                  FlutterLogo(
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  AppText(
                    'Flutterbook',
                    size: 20,
                    weight: FontWeight.w800,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  Positioned(
                    top: 7,
                    left: 10,
                    child: Icon(
                      Icons.search_outlined,
                      size: 16,
                      color: theme.unselected,
                    ),
                  ),
                  TextFormField(
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(30, 11, 20, 11),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: theme.unselected.withOpacity(0.4)),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    onChanged: (String value) {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...items,
            ],
          ),
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
    final theme = context.read<AppTheme>();
    final storyNotifier = context.read<StoryNotifier>();
    return component.stories.length > 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ExplorerItem(text: component.name, icon: Icons.widgets_outlined, iconColor: theme.component),
              Padding(
                padding: const EdgeInsets.only(left: 17),
                child: Column(
                  children: [
                    for (final story in component.stories)
                      _ExplorerItem(
                        text: story.name,
                        icon: Icons.bookmark_outline,
                        iconColor: theme.story,
                        onPressed: () => storyNotifier.update(story),
                      ),
                  ],
                ),
              ),
            ],
          )
        : _ExplorerItem(
            text: component.stories.first.name,
            icon: Icons.bookmark_outline,
            iconColor: theme.story,
            onPressed: () => storyNotifier.update(component.stories.first),
          );
  }
}

class Folder extends Organized {
  const Folder({Key? key, required this.name, required this.children}) : super(key: key);

  final String name;
  final List<Organized> children;

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return Column(
      children: [
        _ExplorerItem(
          text: name,
          icon: Icons.folder_outlined,
          iconColor: theme.folder,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 17),
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
    final theme = context.read<AppTheme>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          name.toUpperCase(),
          weight: FontWeight.w800,
          style: const TextStyle(letterSpacing: 2),
          color: theme.unselected,
          size: 12,
        ),
        const SizedBox(height: 5),
        ...children,
      ],
    );
  }
}

class _ExplorerItem extends Organized {
  final IconData icon;
  final Color? iconColor;
  final String text;
  final void Function()? onPressed;

  const _ExplorerItem({
    Key? key,
    required this.text,
    required this.icon,
    this.iconColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? theme.unselected,
            ),
            const SizedBox(width: 5),
            AppText(text)
          ],
        ),
      ),
    );
  }
}
