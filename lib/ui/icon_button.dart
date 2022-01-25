import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/theme.dart';
import 'package:provider/provider.dart';

class AppIconButton extends StatefulWidget {
  final IconData icon;
  final void Function() onPressed;

  const AppIconButton({Key? key, required this.icon, required this.onPressed}) : super(key: key);

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  late bool isHovered;

  @override
  void initState() {
    isHovered = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return GestureDetector(
      onTap: widget.onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() => isHovered = true),
        onExit: (event) => setState(() => isHovered = false),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isHovered ? 1 : 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: theme.selected.withAlpha(40),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                ),
              ),
              Icon(
                widget.icon,
                size: 20,
                color: isHovered ? theme.selected : theme.unselected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
