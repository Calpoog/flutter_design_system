import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/boolean_control.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/number_control.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/options_control.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/text_control.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/ui/utils/functions.dart';

typedef ControlBuilder = Control Function(ArgType, dynamic);

class Controls {
  ControlBuilder none() => (argType, initial) => NoControl(argType: argType);
  ControlBuilder text() => (argType, initial) => TextControl(argType: argType, initial: initial);
  ControlBuilder boolean() => (argType, initial) => BooleanControl(argType: argType, initial: initial);
  ControlBuilder number<T>() => (argType, initial) => NumberControl<T>(argType: argType, initial: initial);
  ControlBuilder select<T>({Map<String, T>? options}) =>
      (argType, initial) => SelectControl(argType: argType, initial: initial, options: options);
  ControlBuilder radio<T>({Map<String, T>? options}) =>
      (argType, initial) => RadioControl(argType: argType, initial: initial, options: options);

  ControlBuilder choose<T>(ArgType<T> argType) {
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
  final ArgType argType;
  final T? initial;

  Control({required this.argType, this.initial});

  Widget build(BuildContext context);
}

class NoControl extends Control {
  NoControl({required ArgType argType}) : super(argType: argType, initial: null);

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
