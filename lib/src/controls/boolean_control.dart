import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/arguments.dart';
import 'package:flutter_design_system/src/controls/controls.dart';
import 'package:flutter_design_system/src/controls/nullable_control.dart';
import 'package:flutter_design_system/src/ui/utils/toggle.dart';
import 'package:provider/provider.dart';

class BooleanControl extends Control<bool> {
  @override
  Widget build(BuildContext context) {
    final Arguments args = context.read<Arguments>();
    final value = args.value(argType.name);
    return NullableControl(
      argType: argType,
      notNullInitialValue: false,
      builder: (_) => Toggle(
        value: value,
        onChanged: (bool value) {
          args.update(argType.name, value);
        },
      ),
    );
  }

  @override
  bool deserialize(String value) {
    if (value == 'true') return true;
    if (value == 'false') return false;
    throw ErrorDescription('Invalid boolean value \'$value\' for \'${argType.name}\' control');
  }
}
