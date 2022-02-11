import 'package:flutter/material.dart';
import 'package:flutter_design_system/flutter_design_system.dart';
import 'package:flutter_design_system/src/models/documentable.dart';
import 'package:flutter_design_system/src/models/globals.dart';

/// A builder for a wrapping widget around a [Story] with access to globals.
///
/// [child] will be the [Story] to wrap as well as any other decorators that were
/// applied first.
typedef Decorator = Widget Function(BuildContext context, Widget child, Globals globals);

// TODO
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

/// A representation of a component in the design system.
///
/// A [Component] is usable as an item in the explorer.
///
/// A component can have it's own top-level documentation and provides fallbacks
/// for configuration that isn't specified at a story level. If configuration
/// is also not provided at the component level, it will be inherited from the
/// configuration the [DesignSystem] level.
class Component extends ExplorerItem implements Documentable {
  final Decorator? decorator;
  final ArgTypes argTypes = {};
  @override
  final String? markdownFile;
  @override
  final String? markdownString;
  @override
  final Widget? docWidget;

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
    this.markdownFile,
    this.markdownString,
    this.docWidget,
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

  int get controlCount {
    int count = 0;
    for (var argType in argTypes.values) {
      if (argType.control is! NoControl) count++;
    }
    return count;
  }
}
