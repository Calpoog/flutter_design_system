import 'package:flutter/material.dart';
import '../consumer.dart' as consumer;
import '../controls/controls.dart';

typedef ArgTypes = Map<String, ArgType>;
typedef ArgValues = Map<String, dynamic>;
typedef TemplateBuilder = Widget Function(BuildContext context, consumer.Arguments args, consumer.Globals globals);

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

  /// Creates an ArgType.
  ///
  /// If the arg is not required, it must have a [defaultValue] or be nullable.
  ///
  /// If the arg has a [mapping], a provided [defaultMapping] must exist as a key
  /// in the map.
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

    this.control = control ?? Controls.choose<T>(this);
    this.control.argType = this;

    if (defaultMapped != null) {
      assert(mapping != null && mapping!.containsKey(defaultMapped),
          'Mapping default $defaultMapped does not exist as value in mapping');
      defaultValue = mapping![defaultMapped];
    }
  }

  bool checkArgType(dynamic value) => value is T;
}
