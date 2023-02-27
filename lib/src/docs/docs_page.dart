import 'package:flutter/material.dart';
import 'doc_canvas.dart';
import 'docs.dart';
import '../models/story.dart';
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
          DocCanvas(story: story),
          Docs(story),
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
          Docs(primary.component),
          const SizedBox(height: 30),
          // The widget shown at the top is the "primary" aka first Story
          // and displays with the args list and controls
          DocCanvas(
            story: primary,
            showArgsTable: primary.component.argTypes.isNotEmpty,
          ),
          // Primary-story-specific documentation comes after
          Docs(primary),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
