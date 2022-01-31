import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/boolean_control.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/number_control.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/options_control.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/text_control.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/ui/utils/functions.dart';

typedef ControlBuilder = Control Function(ArgType, dynamic);

class Controls {
  Control none() => NoControl();
  Control text() => TextControl();
  Control boolean() => BooleanControl();
  Control number<T>() => NumberControl<T>();
  Control select<T>({Map<String, T>? options}) => SelectControl<T>(options: options);
  Control radio<T>({Map<String, T>? options}) => RadioControl<T>(options: options);

  Control choose<T>(ArgType<T> argType) {
    if (argType.mapping != null) {
      return select<T>(options: argType.mapping!);
    } else {
      if (typesEqual<T, String>() || typesEqual<T, String?>()) {
        return text();
      } else if (typesEqual<T, bool>() || typesEqual<T, bool?>()) {
        return boolean();
      } else if (typesEqual<T, int>() || typesEqual<T, int?>()) {
        return number<int>();
      } else if (typesEqual<T, double>() || typesEqual<T, double?>() || typesEqual<T, num>() || typesEqual<T, num?>()) {
        return number<double>();
      } else {
        return none();
      }
    }
  }
}

abstract class Control<T> {
  late final ArgType<T> argType;

  Widget build(BuildContext context);

  /// Takes a serialized string value of type T and deserializes (from URL).
  T deserialize(String value);

  /// Serializes the control value for use in the URL.
  ///
  /// Defaults to value.toString(). For custom controls that don't use a mapping
  /// control ([RadioControl], [SelectControl]), both serialize and deserialize
  /// will need implemented.
  String? serialize(T value) {
    return value?.toString();
  }
}

class NoControl extends Control {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }

  @override
  deserialize(String value) {}
}
