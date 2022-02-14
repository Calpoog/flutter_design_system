import 'package:flutter/widgets.dart';
import 'arg_type.dart';
import 'arguments.dart';
import 'component.dart';
import '../explorer/explorer_items.dart';
import '../controls/controls.dart';
import 'documentable.dart';

/// A representation of a story in the design system.
///
/// A [Story] is usable as an item in the explorer.
///
/// A [Story] defines what is rendered in the canvas, metadata about its
/// arguments, controls, and documentation.
class Story extends ExplorerItem implements Documentable {
  /// The [Component] definition this story belongs to.
  late final Component component;

  /// A builder for the [Story] which can use dynamic values from [Arguments]
  /// to use interactivity from controls.
  ///
  /// If null, it will use the [TemplateBuilder] defined by the parent
  /// [Component] definition.
  final TemplateBuilder? builder;

  /// The initial arg values for a story.
  late final ArgValues initial;

  /// The current arg values which can change as users interact with controls.
  late ArgValues args;

  /// Padding to put around the widget when displayed in the canvas and docs.
  final EdgeInsets? componentPadding;

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

  /// Whether to use controls for the args when viewing the story.
  ///
  /// `true` by default.
  ///
  /// In some cases you may have a customizable component, but a variant of it
  /// that is used for some specific purpose. In this case, for the story showing
  /// the important variant, you can turn off controls on a per-story basis so
  /// its inputs can't be modified in the preview.
  final bool useControls;

  /// Creates a Story.
  Story({
    required String name,
    ArgValues? args,
    this.builder,
    this.componentPadding,
    this.markdownFile,
    this.markdownString,
    this.docWidget,
    this.useControls = true,
  })  : args = Map.of(args ?? {}),
        super(name: name);

  /// Initializes the [Story] with a reference to its parent [Component] and
  /// validates [ArgType]s requirements.
  init(Component component) {
    this.component = component;
    _processValues(args);
  }

  // Validates that values adhere to ArgTypes
  // Updates ArgValues values from String to a mapped type
  _processValues(ArgValues values) {
    values.updateAll((argName, value) {
      assert(component.argTypes.containsKey(argName), 'No ArgType defined for \'$argName\'');
      ArgType argType = component.argTypes[argName]!;
      if (argType.mapping == null) {
        assert(argType.checkArgType(value),
            '\'$argName\' arg with type ${value.runtimeType} does not match arg definition type of ${argType.type}');
        return value;
      } else {
        assert(argType.mapping!.containsKey(value), '$value missing from mapping');
        return argType.mapping![value];
      }
    });
    initial = Map.of(values);
  }

  /// Resets all current arg values back to their initial values.
  resetArgs() {
    args = Map.of(initial);
  }

  /// Updates the value of an arg.
  updateArg(String name, dynamic value) {
    args[name] = value;
  }

  /// Restores arg values from the URL by deserializing them based on the
  /// [ArgType]s control.
  restoreArgs(Map<String, String> queryArgs) {
    final argTypes = component.argTypes;
    for (final queryArg in queryArgs.entries) {
      final argName = queryArg.key;
      final argValue = queryArg.value;
      if (argTypes.containsKey(argName)) {
        final value = argTypes[argName]!.control.deserialize(argValue);
        updateArg(argName, value);
      }
    }
  }

  /// Serializes the current arg values for use in the URL.
  Map<String, String> serializeArgs() {
    Map<String, String> serialized = {};
    for (final argType in component.argTypes.values) {
      if (argType.control is! NoControl) {
        var value = args[argType.name];
        var initialValue = initial[argType.name];
        value = value != null ? argType.control.serialize(value) : null;
        initialValue = initialValue != null ? argType.control.serialize(initialValue) : null;
        if (value != null && value != initialValue) {
          serialized[argType.name] = value;
        }
      }
    }
    return serialized;
  }
}
