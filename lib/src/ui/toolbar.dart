import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/tools/models/tool.dart';
import 'package:flutter_design_system/src/tools/ui/divider.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({Key? key, required this.tools}) : super(key: key);

  final List<Widget> tools;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final tool in tools) ...[
          tool,
          // if (tool.divide) const ToolDivider(),
        ],
      ],
    );
  }
}
