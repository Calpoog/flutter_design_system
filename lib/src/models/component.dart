import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/explorer/explorer_items.dart';
import 'package:flutter_design_system/src/models/arguments.dart';
import 'package:flutter_design_system/src/models/globals.dart';
import 'package:flutter_design_system/src/models/story.dart';

typedef Decorator = Widget Function(BuildContext context, Widget child, Globals globals);

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
  final ArgTypes argTypes = {};
  final String? markdown;
  final String? markdownString;

  // Compositional values for individual stories
  final TemplateBuilder? builder;
  final EdgeInsets? componentPadding;

  Component({
    required String name,
    this.builder,
    this.decorator,
    required List<ArgType> argTypes,
    this.componentPadding,
    required List<Story> stories,
    bool? isExpanded,
    this.markdown,
    this.markdownString,
  }) : super(
          name: name,
          children: stories,
          isExpanded: isExpanded,
        ) {
    this.argTypes.addEntries(argTypes.map((a) => MapEntry(a.name, a)));
    for (final story in stories) {
      story.init(this);
    }
  }
}
