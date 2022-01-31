import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/controls.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/nullable_control.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/text_control.dart';
import 'package:flutter_storybook/ui/utils/hoverable.dart';
import 'package:flutter_storybook/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class NumberControl<T> extends Control<T> {
  final Type type;
  NumberControl({required ArgType argType, T? initial})
      : type = T,
        super(argType: argType, initial: initial);

  @override
  Widget build(BuildContext context) {
    return NullableControl(
      argType: argType,
      initialForType: 0,
      builder: (_) => _NumberControl<T>(
        type: type,
        argType: argType,
        initial: initial,
      ),
    );
  }
}

class _NumberControl<T> extends StatefulWidget {
  final Type type;
  final ArgType argType;
  final T? initial;

  const _NumberControl({
    Key? key,
    required this.type,
    required this.argType,
    this.initial,
  }) : super(key: key);

  @override
  _NumberControlState<T> createState() => _NumberControlState<T>();
}

class _NumberControlState<T> extends State<_NumberControl<T>> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.initial?.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final argType = widget.argType;
    final type = widget.type;
    final args = context.read<Arguments>();

    return StatefulBuilder(builder: (context, setState) {
      return Stack(
        children: [
          ResetAwareTextField(
            name: argType.name,
            initial: widget.initial.toString(),
            keyboardType: TextInputType.number,
            controller: controller,
            contentPadding: const EdgeInsets.fromLTRB(12, 16, 60, 16),
            validator: (value) {
              try {
                _parse(value);
              } catch (_) {
                return 'Invalid ${type.toString()}';
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(type == double ? r'[0-9.-]' : r'[0-9.-]')),
            ],
            onChanged: (String value) {
              args.update(argType.name, value.isEmpty ? 0 : num.parse(value));
            },
          ),
          _Incrementer(
            isPositive: false,
            onTap: () {
              final number = num.parse(controller.text) - 1;
              controller.text = number.toString();
              args.update(argType.name, number);
            },
          ),
          _Incrementer(
            isPositive: true,
            onTap: () {
              final number = num.parse(controller.text) + 1;
              controller.text = number.toString();
              args.update(argType.name, number);
            },
          ),
        ],
      );
    });
  }

  dynamic _parse(String value) {
    switch (widget.type) {
      case int:
        return int.parse(value);
      case double:
        return double.parse(value);
      default:
        return num.parse(value);
    }
  }
}

class _Incrementer extends StatelessWidget {
  final bool isPositive;
  final void Function() onTap;

  const _Incrementer({Key? key, required this.isPositive, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return Positioned(
      right: isPositive ? 4 : 30,
      top: 7,
      child: GestureDetector(
        onTap: onTap,
        child: Hoverable(
          builder: (context, isHovered) => Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: isHovered ? theme.selected.withOpacity(0.2) : Colors.transparent,
            ),
            height: 26,
            width: 26,
            child: Icon(
              isPositive ? Icons.add : Icons.remove,
              size: 18,
              color: theme.selected,
            ),
          ),
        ),
      ),
    );
  }
}
