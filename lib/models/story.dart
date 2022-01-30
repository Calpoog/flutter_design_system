import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/explorer.dart';

import 'arguments.dart';
import 'component.dart';

class Story extends ExplorerItem {
  late final Component component;
  ArgsBuilder? builder;
  final ArgValues args;
  late final Arguments arguments;
  final EdgeInsets? componentPadding;

  Story({
    required String name,
    ArgValues? args,
    this.componentPadding,
    bool? isExpanded,
  })  : args = Map.of(args ?? {}),
        super(
          name: name,
          isExpanded: isExpanded,
        );

  void init(Component component) {
    this.component = component;
    _updateValues(args);
    arguments = Arguments(args, component.argTypes, this);
  }

  // Validates that values adhere to ArgTypes
  // Updates ArgValues values from String to a mapped type
  _updateValues(ArgValues values) {
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
}
