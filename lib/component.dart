import 'package:flutter/material.dart';
import 'controls.dart';

typedef ArgTypes = Map<String, ArgType>;
typedef ArgValues = Map<String, dynamic>;
typedef Decorator = Widget Function(Widget child);
typedef ArgsBuilder = Widget Function(BuildContext context, ArgValues args);

class Args with ChangeNotifier {
  ArgValues _values;
  final ArgTypes _argTypes;

  Args(this._values, this._argTypes) {
    _values.forEach((name, value) {
      assert(_argTypes.containsKey(name), 'There is no matching arg definition for \'$name\'');
      ArgType arg = _argTypes[name]!;
      if (arg.control is! OptionsControl) {
        assert(arg._checkArgType(value),
            '\'$name\' arg with type ${value.runtimeType} does not match arg definition type of ${arg.type}');
      } else {
        OptionsControl control = arg.control as OptionsControl;
        assert(value is String, 'Value $value for ArgType with OptionsControl should be a String');
        assert(control.options.containsKey(value), 'Value $value missing from enum options');
      }
    });
  }

  T? value<T>(String name) {
    assert(_argTypes.containsKey(name), 'There is no arg definition \'$name\'');
    ArgType arg = _argTypes[name]!;

    assert(_values.containsKey(name) || arg.defaultValue != null || !arg.isRequired,
        'No value provided for required arg \'$name\' and missing default value for its argType');

    if (arg.control is! OptionsControl) {
      return _values[name] as T ?? arg.defaultValue;
    } else {
      OptionsControl control = arg.control as OptionsControl;
      // has already been asserted that the value is a string and exists within the control options
      return control.options[_values[name]];
    }
  }

  dynamic controlValue(String name) {
    return _values[name];
  }

  updateValue(String name, dynamic value) {
    _values = Map.of(_values)
      ..update(
        name,
        (current) => value,
        ifAbsent: () => value,
      );
    debugPrint('Updating arg $name to ${value.toString()}');
    notifyListeners();
  }
}

class ArgType<T> {
  final String name;
  final Type type;
  final bool isRequired;
  final String description;
  final dynamic defaultValue;
  final Control control;

  ArgType({
    required this.name,
    required this.description,
    this.defaultValue,
    required this.control,
    this.isRequired = false,
  }) : type = T {
    if (defaultValue != null) {
      if (control is! OptionsControl) {
        assert(_checkArgType(defaultValue), 'defaultValue should be of type $type');
      } else {
        assert(defaultValue is String,
            'defaultValue for OptionsControl should be String type but was ${defaultValue.runtimeType}');
      }
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
  final ComponentMeta component;
  final ArgValues? args;
  ArgsBuilder? builder;

  Story({required this.name, required this.component, this.args});
}

class ComponentMeta {
  final String name;
  final Decorator? decorator;
  final ArgTypes argTypes;
  final ArgValues? args;
  final ArgTypes actions = {};
  final ArgsBuilder? builder;
  final Map<String, Story> stories = {};

  ComponentMeta({
    required this.name,
    this.builder,
    this.decorator,
    this.args,
    required this.argTypes,
  });

  void story({String name = '', required ArgValues args, ArgValues? extend}) {
    final String storyName = name;
    ArgValues values = args;
    if (extend != null) {
      values = Map.of(extend)..addAll(args);
    }
    this.args.forEach((name, ArgType arg) {
      assert(
          !arg.isRequired || values.containsKey(name), '${this.name} $storyName story missing required arg \'$name\'');
    });
    stories[name] = Story(name, this, values);
  }

  void define<T>({
    required String name,
    String description = '',
    isRequired = false,
    dynamic defaultValue,
    Control? control,
  }) {
    if (control == null) {
      switch (T) {
        case String:
          control = TextControl();
          break;
        default:
          control = NoControl();
      }
    }
    control.name = name;

    args[name] = ArgType<T>(
      name: name,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      control: control,
    );
  }

  void action<T>({
    required String name,
    String description = '',
    isRequired = false,
    dynamic defaultValue,
  }) {
    actions[name] = ArgType<T>(
      name: name,
      description: description,
      isRequired: isRequired,
      defaultValue: defaultValue,
      control: NoControl(),
    );
  }

  ComponentActions createActions() => ComponentActions(actions);
}
