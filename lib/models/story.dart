import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/models/component.dart';
import 'package:flutter_storybook/ui/explorer/explorer_items.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/controls.dart';

class Story extends ExplorerItem {
  /// The [Component] definition this story belongs to.
  late final Component component;

  /// A builder for the [Story] which can use dynamic values from [Arguments]
  /// to use interactivity from controls.
  ///
  /// If null, it will use the [TemplateBuilder] defined by the parent
  /// [Component] definition.
  final TemplateBuilder? builder;

  /// The initial arg values for a story.
  final ArgValues initial;

  /// The current arg values which can change as users interact with controls.
  late ArgValues args;

  /// Padding to put around the widget when displayed in the canvas and docs.
  final EdgeInsets? componentPadding;

  Story({
    required String name,
    ArgValues? args,
    this.builder,
    this.componentPadding,
  })  : args = Map.of(args ?? {}),
        initial = Map.of(args ?? {}),
        super(name: name);

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
  }

  resetArgs() {
    args = Map.of(initial);
  }

  updateArg(String name, dynamic value) {
    args[name] = value;
  }

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

  Map<String, String> serializeArgs() {
    Map<String, String> serialized = {};
    for (final argType in component.argTypes.values) {
      if (argType.control is! NoControl) {
        var value = args[argType.name];
        value = value != null ? argType.control.serialize(value) : null;
        if (value != null) {
          serialized[argType.name] = value;
        }
      }
    }
    return serialized;
  }
}
