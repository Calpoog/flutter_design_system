import 'package:flutter/widgets.dart';

import 'arguments.dart';
import 'component.dart';

class Story {
  final String name;
  late final ComponentMeta component;
  ArgsBuilder? builder;
  final ArgValues args;
  late final Arguments arguments;

  Story({required this.name, ArgValues? args}) : this.args = Map.of(args ?? {});

  void init(ComponentMeta component) {
    this.component = component;
    _updateValues(args);
    arguments = Arguments(args, component.argTypes);
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

class StoryNotifier extends ChangeNotifier {
  Story? story;

  void update(Story story) {
    this.story = story;
    debugPrint('Selected $story ${story.toString()}');
    notifyListeners();
  }
}
