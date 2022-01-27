import 'package:flutter/widgets.dart';

import 'controls.dart';
import 'story.dart';

typedef ArgTypes = Map<String, ArgType>;
typedef ArgValues = Map<String, dynamic>;
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

    return _values[name] ?? arg.defaultValue;
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

  bool checkArgType(dynamic value) => value is T;
}
