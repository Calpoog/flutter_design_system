import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/utils/text.dart';
import 'package:flutter_storybook/ui/utils/theme.dart';
import 'package:flutter_storybook/ui/utils/toggle.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'arguments.dart';

typedef ControlBuilder = Control Function(ArgType, dynamic);

class Controls {
  ControlBuilder none() => (argType, initial) => NoControl(argType: argType);
  ControlBuilder text() => (argType, initial) => TextControl(argType: argType, initial: initial);
  ControlBuilder boolean() => (argType, initial) => BooleanControl(argType: argType, initial: initial);
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
        case bool:
          return boolean();
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

class BooleanControl extends Control<bool> {
  BooleanControl({required ArgType argType, bool? initial}) : super(argType: argType, initial: initial);

  @override
  Widget build(BuildContext context) {
    final ArgsNotifier argsNotifier = context.read<ArgsNotifier>();
    final value = argsNotifier.args!.value(argType.name);
    return value == null
        ? OutlinedButton(
            onPressed: () {
              argsNotifier.update(argType.name, false);
            },
            child: const Text('Set boolean'),
          )
        : Toggle(
            value: value,
            onChanged: (bool value) {
              argsNotifier.update(argType.name, value);
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
            (option) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(-7, 0),
                    child: Radio<T>(
                      // contentPadding: EdgeInsets.zero,
                      // title: AppText(option.key),
                      value: option.value,
                      groupValue: argsNotifier.args!.value(name),
                      onChanged: (T? value) {
                        argsNotifier.update(name, value);
                      },
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: AppText(option.key),
                  )),
                ],
              ),
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
    final argsNotifier = context.watch<ArgsNotifier>();
    final theme = context.watch<AppTheme>();
    final name = argType.name;
    return SizedBox(
      height: 40,
      child: DropdownButtonFormField<T>(
        value: argsNotifier.args!.value(name),
        icon: Icon(
          Icons.expand_more,
          color: theme.selected,
        ),
        style: GoogleFonts.nunitoSans(fontSize: 14, color: theme.body),
        decoration: InputDecoration(
          hoverColor: theme.background,
          focusColor: Colors.red,
          fillColor: Colors.green,
          contentPadding: const EdgeInsets.all(14),
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: theme.inputBorder),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
        ),
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
      ),
    );
  }
}
