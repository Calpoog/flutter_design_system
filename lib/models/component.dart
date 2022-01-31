import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/explorer.dart';
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

class Component extends ExplorerItem {
  final Decorator? decorator;
  final ArgTypes argTypes;

  // Compositional values for individual stories
  final TemplateBuilder? builder;
  final EdgeInsets? componentPadding;

  Component({
    required String name,
    this.builder,
    this.decorator,
    required this.argTypes,
    this.componentPadding,
    required List<Story> stories,
    bool? isExpanded,
  }) : super(
          name: name,
          children: stories,
          isExpanded: isExpanded,
        ) {
    for (final story in stories) {
      story.init(this);
    }
  }
}
