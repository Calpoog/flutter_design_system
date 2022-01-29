import 'package:flutter/material.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/controls.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/nullable_control.dart';
import 'package:flutter_storybook/ui/utils/text.dart';
import 'package:flutter_storybook/ui/utils/theme.dart';
import 'package:provider/provider.dart';

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
    return NullableControl(
        argType: argType,
        initialForType: argType.mapping!.values.first,
        builder: (context) {
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
                            groupValue: argsNotifier.args.value(name),
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
        });
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
    final value = argsNotifier.args.value<T>(name);
    return NullableControl(
        argType: argType,
        initialForType: argType.mapping!.values.first,
        builder: (context) {
          return Container(
            height: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.inputBorder,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                icon: Icon(
                  Icons.expand_more,
                  color: theme.selected,
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
            ),
          );
        });
  }
}
