import 'package:flutter/material.dart';
import '../../ui/utils/hoverable.dart';
import '../../ui/utils/text.dart';
import '../../ui/utils/theme.dart';
import 'package:provider/provider.dart';

class ToolButton extends StatelessWidget {
  final IconData icon;
  final String? text;
  final String name;
  final bool isActive;
  final void Function() onPressed;

  const ToolButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
    this.text,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return Hoverable(
      onPressed: onPressed,
      builder: (_, isHovered) => Tooltip(
        message: name,
        waitDuration: const Duration(seconds: 1),
        child: Container(
          height: 40,
          padding: const EdgeInsets.all(5.0),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            constraints: const BoxConstraints(minWidth: 30),
            decoration: BoxDecoration(
              color: theme.selected.withAlpha(isHovered ? 45 : (isActive ? 25 : 0)),
              borderRadius: const BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isActive || isHovered ? theme.selected : theme.unselected,
                ),
                if (text != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: AppText(
                      text!,
                      weight: FontWeight.bold,
                      color: isActive || isHovered ? theme.selected : theme.unselected,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
