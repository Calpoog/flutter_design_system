import 'package:flutter/material.dart';
import 'text.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

class Toggle extends StatelessWidget {
  final bool value;
  final String trueText;
  final String falseText;
  final void Function(bool value)? onChanged;

  const Toggle({
    Key? key,
    required this.value,
    this.trueText = 'true',
    this.falseText = 'false',
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onChanged == null ? () {} : () => onChanged!(!value),
        child: Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: theme.inputBorder.withOpacity(0.03),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: theme.inputBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [_buildSide(theme, falseText, !value), _buildSide(theme, trueText, value)],
          ),
        ),
      ),
    );
  }

  Widget _buildSide(AppTheme theme, String text, bool selected) {
    return Container(
      height: 30,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: selected ? theme.selected.withOpacity(0.2) : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: AppText(
        text,
        weight: FontWeight.bold,
        color: selected ? theme.selected : null,
      ),
    );
  }
}
