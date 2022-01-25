import 'package:flutter/material.dart';
import 'arguments.dart';
import 'story.dart';

typedef Decorator = Widget Function(Widget child);

class ComponentActions {
  final ArgTypes actions;

  const ComponentActions(this.actions);

  log(String message) {
    debugPrint('Action log: $message');
  }

  fire(String name, [List<dynamic>? args]) {
    assert(actions.containsKey(name), 'No action definition for $name');
    String argStr = args?.toString() ?? '';
    debugPrint('$name(${argStr.substring(1, argStr.length - 1)})');
  }
}

class ComponentMeta {
  final String name;
  final Decorator? decorator;
  final ArgTypes argTypes;
  final List<Story> stories;

  // Compositional values for individual stories
  final ArgsBuilder? builder;
  final ArgValues? args;
  final ArgTypes actions = {};

  ComponentMeta({
    required this.name,
    this.builder,
    this.decorator,
    this.args,
    required this.stories,
    required this.argTypes,
  }) {
    for (final story in stories) {
      story.init(this);
    }
  }
}
