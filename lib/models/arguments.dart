import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/routing/router_delegate.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/controls.dart';
import 'package:flutter_storybook/models/story.dart';

typedef ArgTypes = Map<String, ArgType>;
typedef ArgValues = Map<String, dynamic>;
typedef TemplateBuilder = Widget Function(BuildContext context, Arguments args);

// class ArgsNotifier extends ChangeNotifier {
//   ArgsNotifier(this.story, this.state);

//   final AppState state;
//   Story story;
//   bool isFresh = true;

//   void update(String name, dynamic value) {
//     story._updateArg(name, value);
//     isFresh = false;
//     notifyListeners();
//     state.argSet();
//   }

//   void reset() {
//     story._resetArgs();
//     isFresh = true;
//     notifyListeners();
//     state.argSet();
//   }
// }

class Arguments extends ChangeNotifier {
  final ArgValues _values;
  final Story _story;
  final ArgTypes _argTypes;
  final AppState _appState;
  bool isFresh = true;

  Arguments(Story story, AppState appState)
      : _story = story,
        _argTypes = story.component.argTypes,
        _values = story.args,
        _appState = appState;

  T? value<T>(String name) {
    assert(_argTypes.containsKey(name), 'There is no arg definition \'$name\'');
    ArgType arg = _argTypes[name]!;

    assert(_values.containsKey(name) || arg.defaultValue != null || !arg.isRequired,
        'Story \'${_story.name}\' has no value provided for required arg \'$name\' and missing default value for its argType');

    return _values[name] ?? arg.defaultValue;
  }

  void update(String name, dynamic value) {
    _story.updateArg(name, value);
    isFresh = false;
    notifyListeners();
    _appState.argSet();
  }

  void reset() {
    _story.resetArgs();
    isFresh = true;
    notifyListeners();
    _appState.argSet();
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

    this.control = control ?? Controls().choose<T>(this);

    if (defaultMapped != null) {
      assert(mapping != null && mapping!.containsKey(defaultMapped),
          'Mapping default $defaultMapped does not exist as value in mapping');
      defaultValue = mapping![defaultMapped];
    }
  }

  bool checkArgType(dynamic value) => value is T;
}
