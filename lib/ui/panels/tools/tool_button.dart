import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/utils/hoverable.dart';
import 'package:flutter_storybook/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class ToolButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final void Function() onPressed;

  const ToolButton({Key? key, required this.icon, required this.onPressed, this.isActive = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return GestureDetector(
      onTap: onPressed,
      child: Hoverable(
        builder: (_, isHovered) => Tooltip(
          message: 'Hello',
          waitDuration: const Duration(seconds: 1),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isHovered || isActive)
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: theme.selected.withAlpha(isHovered ? 45 : 25),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                Icon(
                  icon,
                  size: 20,
                  color: isHovered ? theme.selected : theme.unselected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
