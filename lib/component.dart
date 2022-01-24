import 'package:flutter/material.dart';
import 'package:flutter_storybook/storybook.dart';
import 'controls.dart';

typedef ArgTypes = Map<String, ArgType>;
typedef ArgValues = Map<String, dynamic>;
typedef Decorator = Widget Function(Widget child);
typedef ArgsBuilder = Widget Function(BuildContext context, Arguments args);

class ArgsNotifier extends ChangeNotifier {
  ArgsNotifier(this._storyNotifier) {
    _storyListener();
    _storyNotifier.addListener(_storyListener);
  }

  final StoryNotifier _storyNotifier;
  Arguments? args;

  void _storyListener() {
    args = _storyNotifier.story!.arguments;
  }

  void update(String name, dynamic value) {
    args!._update(name, value);
    notifyListeners();
  }

  @override
  void dispose() {
    _storyNotifier.removeListener(_storyListener);
    super.dispose();
  }
}

class Arguments {
  ArgValues _values;
  final ArgTypes _argTypes;

  Arguments(this._values, this._argTypes);

  T? value<T>(String name) {
    assert(_argTypes.containsKey(name), 'There is no arg definition \'$name\'');
    ArgType arg = _argTypes[name]!;

    assert(_values.containsKey(name) || arg.defaultValue != null || !arg.isRequired,
        'No value provided for required arg \'$name\' and missing default value for its argType');

    return _values[name];
  }

  _update(String name, dynamic value) {
    _values = Map.of(_values)
      ..update(
        name,
        (current) => value,
        ifAbsent: () => value,
      );
    debugPrint('Updating arg $name to ${value.toString()}');
  }
}

class ArgType<T> {
  final String name;
  final Type type;
  final bool isRequired;
  final String description;
  T? defaultValue;
  final String? defaultMapped;
  final Map<String, T>? mapping;
  late final ControlBuilder control;

  ArgType({
    required this.name,
    required this.description,
    this.defaultValue,
    this.defaultMapped,
    ControlBuilder? control,
    this.mapping,
    this.isRequired = false,
  }) : type = T {
    this.control = control ?? Controls().choose(this);

    if (defaultMapped != null) {
      assert(mapping != null && mapping!.containsKey(defaultMapped),
          'Mapping default $defaultMapped does not exist as value in mapping');
      defaultValue = mapping![defaultMapped];
    }
  }

  bool _checkArgType(dynamic value) => value is T;
}

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
        assert(argType._checkArgType(value),
            '\'$argName\' arg with type ${value.runtimeType} does not match arg definition type of ${argType.type}');
        return value;
      } else {
        assert(argType.mapping!.containsKey(value), '$value missing from mapping');
        return argType.mapping![value];
      }
    });
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
