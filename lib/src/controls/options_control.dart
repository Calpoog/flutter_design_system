import 'package:flutter/material.dart';
import '../models/arguments.dart';
import 'controls.dart';
import 'nullable_control.dart';
import '../ui/utils/text.dart';
import '../ui/utils/theme.dart';
import 'package:provider/provider.dart';

abstract class OptionsControl<T> extends Control<T> {
  OptionsControl({
    Map<String, T>? options,
    // ignore: unnecessary_this
  }) : _options = options;
  // : this.options = options ?? argType.mapping ?? {} {
  //   assert((options ?? argType.mapping) != null, 'No options provided and ArgType has no mapping');
  // }

  final Map<String, T>? _options;

  Map<String, T> get options => _options ?? argType.mapping ?? {};

  @override
  T deserialize(String value) {
    if (options.containsKey(value)) {
      return options[value]!;
    }
    throw ErrorDescription('Invalid mapping value \'$value\' for \'${argType.name}\' control');
  }

  @override
  String serialize(T? value) {
    return options.entries.firstWhere((option) => option.value == value).key;
  }
}

class RadioControl<T> extends OptionsControl<T> {
  RadioControl({Map<String, T>? options}) : super(options: options);

  @override
  Widget build(BuildContext context) {
    final args = context.watch<Arguments>();
    final name = argType.name;
    return NullableControl(
        argType: argType,
        notNullInitialValue: argType.mapping!.values.first,
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
                            value: option.value,
                            groupValue: args.value(name),
                            onChanged: (T? value) {
                              args.update(name, value);
                            },
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => args.update(name, option.value),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: AppText(option.key),
                            ),
                          ),
                        ),
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
  SelectControl({Map<String, T>? options}) : super(options: options);

  @override
  Widget build(BuildContext context) {
    final args = context.watch<Arguments>();
    final theme = context.watch<AppTheme>();
    final name = argType.name;
    final value = args.value<T>(name);
    return NullableControl(
        argType: argType,
        notNullInitialValue: argType.mapping!.values.first,
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
                  args.update(name, value);
                },
              ),
            ),
          );
        });
  }
}
