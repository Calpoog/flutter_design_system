import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class Section extends StatelessWidget {
  const Section({Key? key, required this.child, this.margin}) : super(key: key);

  final Widget child;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    return Container(
      margin: margin,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: theme.foreground,
        border: Border.all(color: theme.border),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 1),
            blurRadius: 5,
          )
        ],
      ),
      child: child,
    );
  }
}
