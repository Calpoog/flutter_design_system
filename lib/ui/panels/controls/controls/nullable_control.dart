import 'package:flutter/material.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:provider/provider.dart';

class NullableControl extends StatelessWidget {
  final WidgetBuilder builder;
  final ArgType argType;

  /// The initial value to set as the value for the arg when this widget becomes non-null
  final dynamic initialForType;

  const NullableControl({required this.builder, required this.argType, required this.initialForType, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = context.read<Arguments>();
    final value = args.value(argType.name);
    return value == null
        ? OutlinedButton(
            onPressed: () {
              args.update(argType.name, initialForType);
            },
            child: Text('Set ${argType.type.toString()}'),
          )
        : builder(context);
  }
}
