import 'package:flutter/material.dart';
import '../consumer.dart' as consumer;
import '../controls/controls.dart';
import '../explorer/explorer_items.dart';
import 'story.dart';
import 'arg_type.dart';
import 'documentable.dart';

/// A builder for a wrapping widget around a [Story] with access to globals.
///
/// [child] will be the [Story] to wrap as well as any other decorators that were
/// applied first.
typedef Decorator = Widget Function(BuildContext context, Widget child, consumer.Globals globals);

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
  /// A decorating wrapper for all [Story]s defined in the component.
  final Decorator? decorator;

  /// Argument definitions for documentation and controls purposes.
  final ArgTypes argTypes = {};

  /// A string path to a markdown file which must be accessible in the pubspec
  /// assets.
  @override
  final String? markdownFile;

  /// A string of markdown documentation.
  @override
  final String? markdownString;

  /// A [Widget] to render as documentation for ultimate flexibility.
  @override
  final Widget? docWidget;

  // Compositional values for individual stories

  /// The builder for the components stories.
  ///
  /// The builder allows you to construct a widget which can depend on values
  /// given to args defined in each story, which can change with controls, and
  /// can also use global values.
  final TemplateBuilder? builder;

  /// Padding around all children [Story]s when viewed in the canvas.
  final EdgeInsets? componentPadding;

  /// Creates a component.
  Component({
    required String name,
    this.builder,
    this.decorator,
    List<ArgType>? argTypes,
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
    if (argTypes != null) {
      this.argTypes.addEntries(argTypes.map((a) => MapEntry(a.name, a)));
    }
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
