import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/arguments.dart';
import 'package:provider/provider.dart';

/// A Widget to flip between a null value and the correct [Control] for
/// `argType.type`.
///
/// Used as a wrapper around the type-specific control for all controls,
/// allowing them to be null and the user to choose to set the value. The
/// Widget then swaps to the Widget for the correct control type.
class NullableControl extends StatelessWidget {
  /// A builder for a control when its value is not null.
  final WidgetBuilder builder;

  /// The arg definition for this control.
  final ArgType argType;

  /// The initial value to set as the value for the arg when this widget becomes non-null
  final dynamic notNullInitialValue;

  const NullableControl({required this.builder, required this.argType, required this.notNullInitialValue, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = context.read<Arguments>();
    final value = args.value(argType.name);
    return value == null
        ? OutlinedButton(
            onPressed: () {
              args.update(argType.name, notNullInitialValue);
            },
            child: Text('Set ${argType.type.toString()}'),
          )
        : builder(context);
  }
}
