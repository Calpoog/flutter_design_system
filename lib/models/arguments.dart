import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/controls.dart';
import 'package:flutter_storybook/models/story.dart';

typedef ArgTypes = Map<String, ArgType>;
typedef ArgValues = Map<String, dynamic>;
typedef TemplateBuilder = Widget Function(BuildContext context, Arguments args);

class Arguments extends ChangeNotifier {
  late Story _story;
  late ArgTypes _argTypes;
  bool isForced = true;

  Arguments(Story story) {
    updateStory(story);
  }

  T? value<T>(String name) {
    final values = _story.args;
    assert(_argTypes.containsKey(name), 'There is no arg definition \'$name\'');
    ArgType arg = _argTypes[name]!;

    assert(values.containsKey(name) || arg.defaultValue != null || !arg.isRequired,
        'Story \'${_story.name}\' has no value provided for required arg \'$name\' and missing default value for its argType');

    return values[name] ?? arg.defaultValue;
  }

  void updateStory(Story story) {
    _story = story;
    _argTypes = story.component.argTypes;
  }

  void update(String name, dynamic value) {
    _story.updateArg(name, value);
    isForced = false;
    notifyListeners();
  }

  void reset() {
    _story.resetArgs();
    isForced = true;
    notifyListeners();
  }
}

/// An argument definition for a [Story] which determines the documentation
/// to show as well as any controls for real-time modification in the canvas.
class ArgType<T> {
  final String name;
  final Type type;
  final bool isRequired;
  final String description;
  T? defaultValue;
  final String? defaultMapped;
  final Map<String, T>? mapping;
  late final Control control;

  ArgType({
    required this.name,
    required this.description,
    this.defaultValue,
    this.defaultMapped,
    Control? control,
    this.mapping,
    this.isRequired = false,
  }) : type = T {
    assert(isRequired || defaultValue != null || defaultMapped != null || null is T,
        'Arg \'$name\' is not required but has no defaultValue and is non-nullable');

    this.control = control ?? Controls().choose<T>(this);
    this.control.argType = this;

    if (defaultMapped != null) {
      assert(mapping != null && mapping!.containsKey(defaultMapped),
          'Mapping default $defaultMapped does not exist as value in mapping');
      defaultValue = mapping![defaultMapped];
    }
  }

  bool checkArgType(dynamic value) => value is T;
}
