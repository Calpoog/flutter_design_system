import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/controls/controls_panel.dart';
import 'package:flutter_design_system/src/docs/doc_canvas.dart';
import 'package:flutter_design_system/src/docs/docs.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_design_system/src/models/arguments.dart';
import 'package:flutter_design_system/src/ui/utils/section.dart';
import 'package:flutter_design_system/src/ui/utils/text.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DocsPage extends StatelessWidget {
  const DocsPage({
    Key? key,
    required this.story,
  }) : super(key: key);

  final Story story;

  @override
  Widget build(BuildContext context) {
    final component = story.component;
    final List<Story> stories = List.from(component.children as List<Story>);
    final primary = stories.removeAt(0);
    final int storyIndex = component.children?.indexOf(story) ?? 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return PageStorage(
          bucket: PageStorageBucket(),
          child: ScrollablePositionedList.builder(
            padding: const EdgeInsets.all(20.0),
            initialScrollIndex: storyIndex + (storyIndex > 0 ? 1 : 0),
            itemCount: 1 + (stories.isNotEmpty ? stories.length + 1 : 0),
            itemBuilder: (context, index) {
              if (index == 0) return _PrimaryWidget(primary: primary);
              if (index == 1) return const ReadingWidth(child: H3('Stories', useRule: true));
              return _StoryWidget(story: stories[index - 2]);
            },
          ),
        );
      },
    );
  }
}

class ReadingWidth extends StatelessWidget {
  const ReadingWidth({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: SizedBox(
          width: min(800, constraints.maxWidth),
          child: child,
        ),
      ),
    );
  }
}

class _StoryWidget extends StatelessWidget {
  const _StoryWidget({Key? key, required this.story}) : super(key: key);

  final Story story;

  @override
  Widget build(BuildContext context) {
    return ReadingWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H4(story.name, useRule: false),
          ChangeNotifierProvider(
            create: (context) => Arguments(story),
            child: DocCanvas(story: story),
          ),
          DocsWidget(story),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _PrimaryWidget extends StatelessWidget {
  const _PrimaryWidget({Key? key, required this.primary}) : super(key: key);

  final Story primary;

  @override
  Widget build(BuildContext context) {
    return ReadingWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H1(primary.component.name),
          // Component-level documentation
          DocsWidget(primary.component),
          const SizedBox(height: 30),
          // The widget shown at the top is the "primary" aka first Story
          // and displays with the args list and controls
          ChangeNotifierProvider(
            create: (context) => Arguments(primary),
            child: Column(
              children: [
                DocCanvas(story: primary),
                if (primary.component.argTypes.isNotEmpty)
                  Section(
                    child: ControlsPanel(),
                    margin: const EdgeInsets.only(bottom: 20.0),
                  ),
              ],
            ),
          ),
          // Primary-story-specific documentation comes after
          DocsWidget(primary),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
