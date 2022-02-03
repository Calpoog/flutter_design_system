import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/models/globals.dart';
import 'package:flutter_design_system/src/storybook.dart';
import 'package:flutter_design_system/src/tools/models/tool.dart';
import 'package:flutter_design_system/src/ui/utils/text.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:provider/provider.dart';

class ThemeTool extends Tool {
  ThemeTool({Key? key})
      : super(
          key: key,
          name: 'Change theme',
          icon: Icons.image_outlined,
          decorator: (context, child, globals) {
            final config = context.read<StorybookConfig>();
            return Theme(
              data: config.themes[globals['theme']] ?? ThemeData.fallback(),
              child: child,
            );
          },
        );

  @override
  bool isActive(BuildContext context) {
    return context.watch<Globals>()['theme'] != null;
  }

  @override
  Widget popup(BuildContext context) {
    final overlay = context.read<OverlayNotifier>();
    final theme = context.read<AppTheme>();
    final globals = context.read<Globals>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: const AppText.body('Reset background'),
          hoverColor: theme.background,
          onTap: () {
            globals.remove('theme');
            overlay.close();
          },
        ),
        ...context
            .read<StorybookConfig>()
            .themes
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
                    color: entry.value.backgroundColor,
                    border: Border.all(color: theme.backgroundDark),
                  ),
                ),
                onTap: () {
                  globals['theme'] = entry.key;
                  overlay.close();
                },
              ),
            )
            .toList(),
      ],
    );
  }
}
