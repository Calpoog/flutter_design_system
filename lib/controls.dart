import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'component.dart';

abstract class Control<T> {
  late final String name;

  Widget build(BuildContext context, dynamic value);
}

class NoControl extends Control {
  @override
  Widget build(BuildContext context, dynamic value) {
    return const SizedBox();
  }
}

class TextControl extends Control<String> {
  @override
  Widget build(BuildContext context, dynamic value) {
    final Args args = context.read<Args>();
    return TextFormField(
      initialValue: value,
      onChanged: (String value) {
        args.updateValue(name, value);
      },
    );
  }
}

abstract class OptionsControl<T> extends Control<T> {
  final Map<String, T> options;

  OptionsControl(this.options);
}

class SelectControl<T> extends OptionsControl<T> {
  SelectControl({required Map<String, T> options}) : super(options);

  @override
  Widget build(BuildContext context, dynamic value) {
    final Args args = context.watch<Args>();
    return DropdownButton<String>(
      value: args.controlValue(name),
      items: options.entries
          .map(
            (option) => DropdownMenuItem<String>(
              value: option.key,
              child: Text(option.key),
            ),
          )
          .toList(),
      onChanged: (String? value) {
        args.updateValue(name, value);
      },
    );
  }
}
