import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'arguments.dart';

typedef ControlBuilder = Control Function(ArgType, dynamic);

class Controls {
  ControlBuilder none() => (argType, initial) => NoControl(argType: argType);
  ControlBuilder text() => (argType, initial) => TextControl(argType: argType, initial: initial);
  ControlBuilder select<T>({Map<String, T>? options}) =>
      (argType, initial) => SelectControl(argType: argType, initial: initial, options: options);
  ControlBuilder radio<T>({Map<String, T>? options}) =>
      (argType, initial) => RadioControl(argType: argType, initial: initial, options: options);

  ControlBuilder choose<T>(ArgType<T> argType) {
    if (argType.mapping != null) {
      return select<T>(options: argType.mapping!);
    } else {
      switch (argType.type) {
        case String:
          return text();
        default:
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

class TextControl extends Control<String> {
  TextControl({required ArgType argType, String? initial}) : super(argType: argType, initial: initial);

  @override
  Widget build(BuildContext context) {
    final ArgsNotifier args = context.read<ArgsNotifier>();
    return TextFormField(
      style: const TextStyle(fontSize: 14),
      initialValue: initial,
      onChanged: (String value) {
        args.update(argType.name, value);
      },
    );
  }
}

abstract class OptionsControl<T> extends Control<T> {
  OptionsControl({
    required ArgType<T> argType,
    T? initial,
    Map<String, T>? options,
    // ignore: unnecessary_this
  })  : this.options = options ?? argType.mapping ?? {},
        super(argType: argType, initial: initial) {
    assert((options ?? argType.mapping) != null, 'No options provided and ArgType has no mapping');
  }

  final Map<String, T> options;
}

class RadioControl<T> extends OptionsControl<T> {
  RadioControl({required ArgType<T> argType, T? initial, Map<String, T>? options})
      : super(argType: argType, initial: initial, options: options);

  @override
  Widget build(BuildContext context) {
    final ArgsNotifier argsNotifier = context.watch<ArgsNotifier>();
    final name = argType.name;
    return Column(
      children: options.entries
          .map(
            (option) => RadioListTile<T>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(option.key),
              value: option.value,
              groupValue: argsNotifier.args!.value(name),
              onChanged: (T? value) {
                argsNotifier.update(name, value);
              },
            ),
          )
          .toList(),
    );
  }
}

class SelectControl<T> extends OptionsControl<T> {
  SelectControl({required ArgType<T> argType, T? initial, Map<String, T>? options})
      : super(argType: argType, initial: initial, options: options);

  @override
  Widget build(BuildContext context) {
    final ArgsNotifier argsNotifier = context.watch<ArgsNotifier>();
    final name = argType.name;
    return DropdownButton<T>(
      value: argsNotifier.args!.value(name),
      items: options.entries
          .map(
            (option) => DropdownMenuItem<T>(
              value: option.value,
              child: Text(option.key),
            ),
          )
          .toList(),
      onChanged: (T? value) {
        argsNotifier.update(name, value);
      },
    );
  }
}
