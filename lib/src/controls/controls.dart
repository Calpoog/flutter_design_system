import 'package:flutter/material.dart';
import '../models/arg_type.dart';
import 'boolean_control.dart';
import 'number_control.dart';
import 'options_control.dart';
import 'text_control.dart';
import '../ui/utils/functions.dart';

/// A collection of [Control]s which can be assigned to [ArgType]s for dynamic
/// interaction when viewing [Story]s in the canvas.
///
/// A [Control] will be chosen implicitly based on the [ArgType]'s type. If there
/// is no matching control, it will not display in the Controls panel when viewing
/// the canvas. For types that would implicitly be assigned a control you can turn
/// off the control using `Controls.none()`.
class Controls {
  /// Do not display a control for the arg.
  ///
  /// If an arg has no control specified and an implicit match is not found for the
  /// type, `Controls.none()` will be used.
  static Control none() => NoControl();

  /// Creates a textbox control for String args.
  static Control text() => TextControl();

  /// Creates a true/false toggle control for bool args.
  static Control boolean() => BooleanControl();

  /// Creates a numbers-only textbox control for number/int/double args.
  static Control number<T>() => NumberControl<T>();

  /// Creates a dropdown for complex-typed args where `ArgType.mapping` is used
  /// to map String values to the complex type [T].
  static Control select<T>({Map<String, T>? options}) => SelectControl<T>(options: options);

  /// Creates a radio button list for complex-typed args where `ArgType.mapping`
  /// is used to map String values to the complex type [T].
  static Control radio<T>({Map<String, T>? options}) => RadioControl<T>(options: options);

  /// Programmitcally choose a control type for the given [argType].
  static Control choose<T>(ArgType<T> argType) {
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

/// An abstract representation of all controls.
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

/// A control to render no control.
class NoControl extends Control {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }

  @override
  deserialize(String value) {}
}
