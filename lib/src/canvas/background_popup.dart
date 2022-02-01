import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/storybook.dart';
import 'package:flutter_design_system/src/tools/tool.dart';
import 'package:flutter_design_system/src/ui/utils/text.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class BackgroundTool extends Tool {
  BackgroundTool({Key? key}) : super(key: key, name: 'Change background', icon: Icons.image_outlined);

  @override
  bool isActive(BuildContext context) {
    return context.watch<BackgroundNotifier>().color != null;
  }

  @override
  Widget popup(BuildContext context) {
    final overlay = context.read<OverlayNotifier>();
    final theme = context.read<AppTheme>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: const AppText.body('Reset background'),
          hoverColor: theme.background,
          onTap: () {
            context.read<BackgroundNotifier>().reset();
            overlay.close();
          },
        ),
        ...context
            .read<StorybookConfig>()
            .backgrounds
            .entries
            .map(
              (entry) => ListTile(
                title: AppText.body(entry.key),
                hoverColor: theme.background,
                trailing: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: entry.value,
                    border: Border.all(color: theme.backgroundDark),
                  ),
                ),
                onTap: () {
                  context.read<BackgroundNotifier>().update(entry.value);
                  overlay.close();
                },
              ),
            )
            .toList(),
      ],
    );
  }
}

class BackgroundNotifier extends ChangeNotifier {
  Color? color;

  update(Color color) {
    this.color = color;
    notifyListeners();
  }

  reset() {
    color = null;
    notifyListeners();
  }
}
