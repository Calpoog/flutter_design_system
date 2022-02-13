import 'package:flutter/material.dart';
import '../models/component.dart';
import '../models/globals.dart';
import '../models/story.dart';
import '../models/arguments.dart';
import '../design_system.dart';
import '../consumer.dart' as consumer;
import 'package:provider/provider.dart';

import 'sub_story.dart';

class Canvas extends StatelessWidget {
  Canvas({Key? key, List<Decorator>? decorators, this.story}) : super(key: key) {
    this.decorators = decorators ?? [];
  }

  final Story? story;

  /// Additional decorators for this specific canvas. Usually from tools.
  late final List<Decorator> decorators;

  @override
  Widget build(BuildContext context) {
    final story = this.story ?? context.watch<Story>();
    final config = context.read<DesignSystemConfig>();
    final globals = consumer.Globals(context.watch<Globals>());

    context.watch<Arguments>();
    Widget child = SubStory(story: story);

    child = Container(
      padding: story.componentPadding ?? story.component.componentPadding ?? config.componentPadding,
      child: child,
    );

    if (story.component.decorator != null) {
      child = story.component.decorator!(context, child, globals);
    }
    for (final decorator in config.decorators) {
      child = decorator(context, child, globals);
    }
    for (final decorator in decorators) {
      child = decorator(context, child, globals);
    }

    return child;
  }
}
