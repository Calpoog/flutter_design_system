import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/controls.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/nullable_control.dart';
import 'package:provider/provider.dart';

class TextControl extends Control<String> {
  @override
  Widget build(BuildContext context) {
    return NullableControl(
      argType: argType,
      notNullInitialValue: '',
      builder: (_) => ResetAwareTextField(
        name: argType.name,
      ),
    );
  }

  @override
  String deserialize(String value) {
    return value;
  }
}

class ResetAwareTextField extends StatefulWidget {
  final String name;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String value)? onChanged;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final EdgeInsets? contentPadding;

  const ResetAwareTextField({
    Key? key,
    required this.name,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onChanged,
    this.controller,
    this.validator,
    this.contentPadding,
  }) : super(key: key);

  @override
  _ResetAwareTextFieldState createState() => _ResetAwareTextFieldState();
}

class _ResetAwareTextFieldState extends State<ResetAwareTextField> {
  late TextEditingController controller;
  late Arguments args;

  @override
  void initState() {
    args = context.read<Arguments>();
    controller = widget.controller ?? TextEditingController(text: args.value(widget.name));
    args.addListener(resetListener);
    super.initState();
  }

  resetListener() {
    if (args.isFresh) {
      controller.text = args.value(widget.name).toString();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    args.removeListener(resetListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
              contentPadding: widget.contentPadding,
            ),
      ),
      child: TextFormField(
        controller: controller,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: widget.onChanged ??
            (String value) {
              args.update(widget.name, value);
            },
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 0, color: Colors.transparent)),
      ),
    );
  }
}
