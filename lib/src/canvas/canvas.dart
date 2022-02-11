import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/component.dart';
import 'package:flutter_design_system/src/models/globals.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_design_system/src/models/arguments.dart';
import 'package:flutter_design_system/src/design_system.dart';
import 'package:provider/provider.dart';

class Canvas extends StatelessWidget {
  Canvas({Key? key, List<Decorator>? decorators}) : super(key: key) {
    this.decorators = decorators ?? [];
  }

  /// Additional decorators for this specific canvas. Usually from tools.
  late final List<Decorator> decorators;

  @override
  Widget build(BuildContext context) {
    final args = context.watch<Arguments>();
    final story = context.watch<Story>();
    final config = context.read<DesignSystemConfig>();
    final globals = context.watch<Globals>();
    Widget child = story.builder != null
        ? story.builder!(context, args, globals)
        : story.component.builder!(context, args, globals);

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
