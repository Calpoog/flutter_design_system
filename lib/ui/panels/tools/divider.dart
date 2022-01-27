import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class ToolDivider extends StatelessWidget {
  const ToolDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: context.read<AppTheme>().border),
        ),
      ),
    );
  }
}
