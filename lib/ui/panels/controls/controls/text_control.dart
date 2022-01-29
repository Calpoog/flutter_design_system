import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/ui/panels/controls/controls/controls.dart';
import 'package:provider/provider.dart';

class TextControl extends Control<String> {
  TextControl({required ArgType argType, String? initial}) : super(argType: argType, initial: initial);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return ResetAwareTextField(
        name: argType.name,
        initial: initial,
      );
    });
  }
}

class ResetAwareTextField extends StatefulWidget {
  final String? initial;
  final String name;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String value)? onChanged;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final EdgeInsets? contentPadding;

  const ResetAwareTextField({
    Key? key,
    this.initial,
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
  late ArgsNotifier argsNotifier;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController(text: widget.initial);
    argsNotifier = context.read<ArgsNotifier>();
    argsNotifier.addListener(resetListener);
    super.initState();
  }

  resetListener() {
    if (argsNotifier.isFresh) {
      controller.text = argsNotifier.args.value(widget.name).toString();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    argsNotifier.removeListener(resetListener);
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
              argsNotifier.update(widget.name, value);
            },
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 0, color: Colors.transparent)),
      ),
    );
  }
}
