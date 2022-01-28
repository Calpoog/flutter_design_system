import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/utils/functions.dart';

import '../ui/panels/controls/controls/controls.dart';
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
  bool isFresh = true;

  void _storyListener() {
    args = _storyNotifier.story!.arguments;
  }

  void update(String name, dynamic value) {
    args!._update(name, value);
    isFresh = false;
    notifyListeners();
  }

  void reset() {
    args!._reset();
    isFresh = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _storyNotifier.removeListener(_storyListener);
    super.dispose();
  }
}

class Arguments {
  final ArgValues _initial;
  ArgValues _values;
  final ArgTypes _argTypes;
  final Story _story;

  Arguments(ArgValues values, this._argTypes, this._story)
      : _initial = values,
        _values = Map.of(values);

  T? value<T>(String name) {
    assert(_argTypes.containsKey(name), 'There is no arg definition \'$name\'');
    ArgType arg = _argTypes[name]!;

    assert(_values.containsKey(name) || arg.defaultValue != null || !arg.isRequired,
        'Story \'${_story.name}\' has no value provided for required arg \'$name\' and missing default value for its argType');

    return _values[name] ?? arg.defaultValue;
  }

  _reset() {
    _values = Map.of(_initial);
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
    assert(isRequired || defaultValue != null || defaultMapped != null || null is T,
        'Arg \'$name\' is not required but has no defaultValue and is non-nullable');

    this.control = control ?? Controls().choose(this);

    if (defaultMapped != null) {
      assert(mapping != null && mapping!.containsKey(defaultMapped),
          'Mapping default $defaultMapped does not exist as value in mapping');
      defaultValue = mapping![defaultMapped];
    }
  }

  bool checkArgType(dynamic value) => value is T;
}
